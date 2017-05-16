require 'rails_helper'

describe UserSignup do
  describe '#sign_up' do
    after { ActionMailer::Base.deliveries.clear }

    let(:stripe_token) { 'stripe_token' }
    let(:invitation_token) { 'invitation_token' }
    let(:bob) { Fabricate.build(:user, email: 'bob@example.com',full_name: 'Bob Doe') }

    it 'tries to create the user' do
      customer = double(:customer, successful?: true)
      allow(StripeWrapper::Customer).to receive(:create) { customer }
      expect(bob).to receive(:save)

      UserSignup.new(bob).sign_up(stripe_token, invitation_token)
    end

    context 'valid personal info and valid card' do
      let(:customer) { double(:customer, successful?: true) }
      before { expect(StripeWrapper::Customer).to receive(:create) { customer } }

      context 'sending email' do
        it 'sends out an email' do
          Sidekiq::Testing.inline! do
            UserSignup.new(bob).sign_up(stripe_token, invitation_token)
            expect(ActionMailer::Base.deliveries).not_to be_empty
          end
        end

        it 'sends out an email to the correct recipient' do
          Sidekiq::Testing.inline! do
            UserSignup.new(bob).sign_up(stripe_token, invitation_token)
            expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@example.com'])
          end
        end

        it 'sends out an email containing the reciptient name' do
          Sidekiq::Testing.inline! do
            UserSignup.new(bob).sign_up(stripe_token, invitation_token)
            expect(ActionMailer::Base.deliveries.last.body).to include('Bob Doe')
          end
        end
      end

      context 'with invitation' do
        it 'makes the inviter follow the reciever' do
          joe = Fabricate(:user)
          bob_invitation = Fabricate(:invitation, inviter: joe, recipient_email: bob[:email])
          UserSignup.new(bob).sign_up(stripe_token, bob_invitation.token)

          expect(User.find_by(email: bob[:email]).followers).to include(bob_invitation.inviter)
        end

        it 'makes the receiver follow the inviter' do
          joe = Fabricate(:user)
          bob_invitation = Fabricate(:invitation, inviter: joe, recipient_email: bob[:email])
          UserSignup.new(bob).sign_up(stripe_token, bob_invitation.token)

          expect(joe.followers).to include(User.find_by(email: bob[:email]))
        end

        it 'expires the invitation upon acceptance' do
          joe = Fabricate(:user)
          bob_invitation = Fabricate(:invitation, inviter: joe, recipient_email: bob[:email])
          UserSignup.new(bob).sign_up(stripe_token, bob_invitation.token)

          expect(bob_invitation.reload.token).to be_nil
        end
      end
    end

    context 'valid personal info and declined card' do
      it 'does not create a new user record' do
        customer = double(:customer, successful?: false, error_message: 'card was declined')
        expect(StripeWrapper::Customer).to receive(:create) { customer }

        UserSignup.new(bob).sign_up(stripe_token, invitation_token)

        expect(User.count).to eq(0)
      end
    end

    context 'invalid personal info' do
      it 'does not send out an email' do
        invalid_bob = Fabricate.build(:user, password: '')
        UserSignup.new(invalid_bob).sign_up(stripe_token, invitation_token)
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'does not charge the card' do
        expect(StripeWrapper::Charge).not_to receive(:create)
        invalid_bob = Fabricate.build(:user, password: '')
        UserSignup.new(invalid_bob).sign_up(stripe_token, invitation_token)
      end
    end
  end
end
