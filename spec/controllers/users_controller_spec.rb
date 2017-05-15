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
    context 'with unauthenticated users' do
      it 'sets @user' do
        result = double(:sign_up_result, successful?: true)
        expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(assigns(:user)).to be_instance_of(User)
      end

      context 'successful user sign up' do
        it 'redirects to sign in page' do
          result = double(:sign_up_result, successful?: true)
          expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
          post :create, user: Fabricate.attributes_for(:user)
          expect(response).to redirect_to(sign_in_path)
        end

        it 'sets success message' do
          result = double(:sign_up_result, successful?: true)
          expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
          post :create, user: Fabricate.attributes_for(:user)
          expect(flash[:success]).to be_present
        end
      end

      context 'failed user sign up' do
        it 'sets flash error message' do
          result = double(:sign_up_result, successful?: false, error_message: 'error message')
          expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
          post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567'
          expect(flash[:error]).to eq('error message')
        end

        it 'renders the new page' do
          result = double(:sign_up_result, successful?: false, error_message: 'error message')
          expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
          post :create, user: Fabricate.attributes_for(:user), stripeToken: '1234567'
          expect(response).to render_template(:new)
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
