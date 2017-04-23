require 'rails_helper'

describe PasswordResetsController do
  describe 'GET show' do
    context 'with valid token' do
      it 'renders show template' do
        bob = Fabricate(:user)
        bob.update_column(:token, '12345')

        get :show, id: '12345'

        expect(response).to render_template(:show)
      end

      it 'sets @token with given token' do
        bob = Fabricate(:user)
        bob.update_column(:token, '12345')

        get :show, id: '12345'

        expect(assigns[:token]).to eq('12345')
      end
    end

    context 'with invalid token' do
      it 'redirects to invalid token page' do
        get :show, id: 'invalid_token'

        expect(response).to redirect_to(expired_token_path)
      end
    end
  end

  describe 'POST create' do
    context 'with valid token' do
      context 'update succeeds' do
        it "updates user's password" do
          bob = Fabricate(:user)
          bob.update_column(:token, '12345')

          get :create, token: '12345', password: 'password'

          expect(bob.reload.authenticate('password')).to eq(bob)
        end

        it "updates user's token" do
          bob = Fabricate(:user)
          bob.update_column(:token, '12345')

          get :create, token: '12345', password: 'password'

          expect(bob.reload.token).not_to eq('12345')
        end

        it 'sets success message' do
          bob = Fabricate(:user)
          bob.update_column(:token, '12345')

          get :create, token: '12345', password: 'password'

          expect(flash[:success]).to be_present
        end

        it 'redirects to sign in page if update succeeds' do
          bob = Fabricate(:user)
          bob.update_column(:token, '12345')

          get :create, token: '12345', password: 'password'

          expect(response).to redirect_to(sign_in_path)
        end
      end

      context 'update fails' do
        it 'sets error message' do
          bob = Fabricate(:user)
          bob.update_column(:token, '12345')

          get :create, token: '12345', password: ''

          expect(flash[:error]).to be_present
        end

        it 'redirects to reset password page' do
          bob = Fabricate(:user)
          bob.update_column(:token, '12345')

          get :create, token: '12345', password: ''

          expect(response).to redirect_to(password_reset_path(bob))
        end
      end
    end

    context 'with invalid token' do
      it 'redirects to expired token page' do
        get :create, token: '12345', password: 'password'

        expect(response).to redirect_to(expired_token_path)
      end
    end
  end
end
