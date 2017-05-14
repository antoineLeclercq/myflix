require 'rails_helper'

describe UsersController do
  describe 'GET new' do
    it 'sets @user with unauthenticated users' do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end

    it 'redirects to home page with authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to(home_path)
    end
  end

  describe 'POST create' do
    after { ActionMailer::Base.deliveries.clear }

    context 'with unauthenticated users' do
      it 'sets @user' do
        charge = double(:charge, successful?: true)
        allow(StripeWrapper::Charge).to receive(:create) { charge }
        post :create, user: Fabricate.attributes_for(:user)
        expect(assigns(:user)).to be_instance_of(User)
      end

      it 'tries to create the user' do
        charge = double(:charge, successful?: true)
        allow(StripeWrapper::Charge).to receive(:create) { charge }
        user = Fabricate.build(:user)
        expect(User).to receive(:new).and_return(user)
        expect(user).to receive(:save)
        post :create, user: user.attributes
      end

      context 'valid personal info and valid card' do
        let(:charge) { double(:charge, successful?: true) }
        before { expect(StripeWrapper::Charge).to receive(:create) { charge } }

        it 'redirects to sign in page' do
          post :create, user: Fabricate.attributes_for(:user)
          expect(response).to redirect_to(sign_in_path)
        end

        context 'sending email' do
          it 'sends out an email' do
            Sidekiq::Testing.inline! do
              post :create, user: { email: 'bob@example.com', password: 'password', full_name: 'Bob Doe' }
              expect(ActionMailer::Base.deliveries).not_to be_empty
            end
          end

          it 'sends out an email to the correct recipient' do
            Sidekiq::Testing.inline! do
              post :create, user: { email: 'bob@example.com', password: 'password', full_name: 'Bob Doe' }
              expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@example.com'])
            end
          end

          it 'sends out an email containing the reciptient name' do
            Sidekiq::Testing.inline! do
              post :create, user: { email: 'bob@example.com', password: 'password', full_name: 'Bob Doe' }
              expect(ActionMailer::Base.deliveries.last.body).to include('Bob Doe')
            end
          end
        end

        context 'with invitation' do
          it 'makes the inviter follow the reciever' do
            joe = Fabricate(:user)
            bob = Fabricate.attributes_for(:user, email: 'bob@example.com')
            bob_invitation = Fabricate(:invitation, inviter: joe, recipient_email: bob[:email])
            post :create, user: bob, invitation_token: bob_invitation.token

            expect(User.find_by(email: bob[:email]).followers).to include(bob_invitation.inviter)
          end

          it 'makes the receiver follow the inviter' do
            joe = Fabricate(:user)
            bob = Fabricate.attributes_for(:user, email: 'bob@example.com')
            bob_invitation = Fabricate(:invitation, inviter: joe, recipient_email: bob[:email])
            post :create, user: bob, invitation_token: bob_invitation.token

            expect(joe.followers).to include(User.find_by(email: bob[:email]))
          end

          it 'expires the invitation upon acceptance' do
            joe = Fabricate(:user)
            bob = Fabricate.attributes_for(:user, email: 'bob@example.com')
            bob_invitation = Fabricate(:invitation, inviter: joe, recipient_email: bob[:email])
            post :create, user: bob, invitation_token: bob_invitation.token

            expect(bob_invitation.reload.token).to be_nil
          end
        end

        it 'sets success message' do
          post :create, user: Fabricate.attributes_for(:user)
          expect(flash[:success]).to be_present
        end
      end

      context 'valid personal info and declined card' do
        it 'does not create a new user record' do
          charge = double(:charge, successful?: false, error_message: 'card was declined')
          expect(StripeWrapper::Charge).to receive(:create) { charge }

          post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567'

          expect(User.count).to eq(0)
        end

        it 'sets flash error message' do
          charge = double(:charge, successful?: false, error_message: 'card was declined')
          expect(StripeWrapper::Charge).to receive(:create) { charge }

          post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567'

          expect(flash[:error]).to eq(charge.error_message)
        end

        it 'renders the new template' do
          charge = double(:charge, successful?: false, error_message: 'card was declined')
          expect(StripeWrapper::Charge).to receive(:create) { charge }

          post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567'

          expect(response).to render_template(:new)
        end
      end

      context 'invalid personal info' do
        it 'does not send out an email' do
          post :create, user: { email: 'bob@example.com', password: '', full_name: 'Bob Doe' }
          expect(ActionMailer::Base.deliveries).to be_empty
        end

        it 'renders new page' do
          post :create, user: Fabricate.attributes_for(:user, password: 'a')
          expect(response).to render_template(:new)
        end

        it 'does not charge the card' do
          expect(StripeWrapper::Charge).not_to receive(:create)
          post :create, user: Fabricate.attributes_for(:user, password: 'a'), stripeToken: '1234567'
        end
      end
    end

    it 'redirects to home page for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      post :create, user: Fabricate.attributes_for(:user)
      expect(response).to redirect_to(home_path)
    end
  end

  describe 'GET show' do
    let(:user) { Fabricate(:user) }

    it 'sets @user' do
      set_current_user

      get :show, id: user.token

      expect(assigns[:user]).to eq(user)
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :show, id: user.token }
    end
  end

  describe 'GET new_with_invitation_token' do
    it "sets @user with recipient's email" do
      bob_invitation = Fabricate(:invitation, recipient_email: 'bob@example.com')
      get :new_with_invitation_token, token: bob_invitation.token

      expect(assigns[:user].email).to eq('bob@example.com')
    end

    it 'sets @invitation_token' do
      bob_invitation = Fabricate(:invitation, recipient_email: 'bob@example.com')
      get :new_with_invitation_token, token: bob_invitation.token

      expect(assigns[:invitation_token]).to eq(bob_invitation.token)
    end

    it 'renders new template' do
      bob_invitation = Fabricate(:invitation, recipient_email: 'bob@example.com')
      get :new_with_invitation_token, token: bob_invitation.token

      expect(response).to render_template(:new)
    end

    it 'redirects to invalid token page for expired tokens' do
      get :new_with_invitation_token, token: '12345'

      expect(response).to redirect_to(expired_token_path)
    end

    it 'redirects logged in user to home page' do
      set_current_user
      bob_invitation = Fabricate(:invitation, recipient_email: 'bob@example.com')
      get :new_with_invitation_token, token: bob_invitation.token

      expect(response).to redirect_to(home_path)
    end
  end
end
