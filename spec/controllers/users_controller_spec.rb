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
        post :create, user: Fabricate.attributes_for(:user)
        expect(assigns(:user)).to be_instance_of(User)
      end

      it 'tries to create the user' do
        user = Fabricate.build(:user)
        expect(User).to receive(:new).and_return(user)
        expect(user).to receive(:save)
        post :create, user: user.attributes
      end

      context 'valid input' do
        it 'redirects to sign in page' do
          post :create, user: Fabricate.attributes_for(:user)
          expect(response).to redirect_to(sign_in_path)
        end

        it 'sets success message' do
          post :create, user: Fabricate.attributes_for(:user)
          expect(flash[:success]).to be_present
        end
      end

      it 'renders new page if invalid input' do
        post :create, user: Fabricate.attributes_for(:user, password: 'a')
        expect(response).to render_template(:new)
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

      get :show, id: user.id

      expect(assigns[:user]).to eq(user)
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :show, id: user.id }
    end
  end
end
