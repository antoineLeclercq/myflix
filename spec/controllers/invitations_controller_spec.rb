require 'rails_helper'

describe InvitationsController do
  describe 'GET new' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end

    it 'sets @invitation to a new invitation' do
      set_current_user

      get :new

      expect(assigns[:invitation]).to be_a(Invitation)
      expect(assigns[:invitation]).to be_new_record
    end
  end

  describe 'POST create' do
    after { ActionMailer::Base.deliveries.clear }

    it_behaves_like 'requires sign in' do
      let(:action) { post :create }
    end

    context 'valid input' do
      it 'creates an invitation' do
        set_current_user

        post :create, invitation: Fabricate.attributes_for(:invitation)

        expect(Invitation.count).to eq(1)
      end

      it 'sends an invitation email to recipient' do
        set_current_user

        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: 'bob@example.com')

        expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@example.com'])
      end

      it 'sets success message' do
        set_current_user

        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: 'bob@example.com')

        expect(flash[:success]).to be_present
      end

      it 'redirects to the invitation page' do
        set_current_user

        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: 'bob@example.com')

        expect(response).to redirect_to(new_invitation_path)
      end
    end

    context 'invalid input' do
      it 'does not create an inivitation' do
        set_current_user

        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: '')

        expect(Invitation.count).to eq(0)
      end

      it 'does not send out an invitation email' do
        set_current_user

        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: '')

        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end

      it 'sets @invitation with invalid input' do
        set_current_user

        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: '')

        expect(assigns[:invitation]).to be_a(Invitation)
      end

      it 'renders new template' do
        set_current_user

        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: '')

        expect(response).to render_template(:new)
      end
    end
  end
end
