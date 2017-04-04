require 'rails_helper'

describe SessionsController do
  describe 'GET new' do
    it 'redirects to home page for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to(home_path)
    end
  end

  describe 'POST create' do
    let(:user) { Fabricate(:user) }

    context 'with unauthenticated users' do
      setup { @request.env['HTTP_REFERER'] = 'http://test.host/home' }

      it 'tries to authenticate user if user exists' do
        expect(User).to receive(:find_by).and_return(user)
        expect(user).to receive(:authenticate)
        post :create, email: user.email, password: user.password
      end

      context 'with valid credentials' do
        it 'adds user to the session' do
          post :create, email: user.email, password: user.password
          expect(session[:user_id]).to eq(user.id)
        end

        it 'redirects to home page' do
          post :create, email: user.email, password: user.password
          expect(response).to redirect_to(home_path)
        end
      end

      context 'with invalid credentials' do
        it 'does not add user to the session' do
          post :create, email: user.email, password: 'a'
          expect(session[:user_id]).to be_blank
        end

        it 'sets error message' do
          post :create, email: user.email, password: 'a'
          expect(flash[:danger]).to be_present
        end

        it 'redirects to sign in page' do
          post :create, email: user.email, password: 'a'
          expect(response).to redirect_to(sign_in_path)
        end
      end
    end

    it ('redirects to home page for authenticated users') do
      session[:user_id] = user.id
      post :create, email: user.email, password: user.password
      expect(response).to redirect_to(home_path)
    end
  end

  describe 'GET destroy' do
    context 'with authenticated users' do
      let(:user) { Fabricate(:user) }
      before do
        session[:user_id] = user.id
        get :destroy
      end

      it 'remove user from the session' do
        expect(session[:user_id]).to be_blank
      end

      it 'sets a notice message' do
        expect(flash[:info]).to be_present
      end

      it ('redirects to root path') do
        expect(response).to redirect_to(root_path)
      end
    end

    it ('redirects to sign in page with unauthenticated users') do
      get :destroy
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
