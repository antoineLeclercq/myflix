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

        context 'sending email' do
          it 'sends out an email' do
            post :create, user: { email: 'bob@example.com', password: 'password', full_name: 'Bob Doe' }
            expect(ActionMailer::Base.deliveries).not_to be_empty
          end

          it 'sends out an email to the correct recipient' do
            post :create, user: { email: 'bob@example.com', password: 'password', full_name: 'Bob Doe' }
            expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@example.com'])
          end

          it 'sends out an email containing the reciptient name' do
            post :create, user: { email: 'bob@example.com', password: 'password', full_name: 'Bob Doe' }
            expect(ActionMailer::Base.deliveries.last.body).to include('Bob Doe')
          end
        end

        it 'sets success message' do
          post :create, user: Fabricate.attributes_for(:user)
          expect(flash[:success]).to be_present
        end
      end

      context 'invalid input' do
        it 'does not send out an email' do
          post :create, user: { email: 'bob@example.com', password: '', full_name: 'Bob Doe' }
          expect(ActionMailer::Base.deliveries).to be_empty
        end

        it 'renders new page' do
          post :create, user: Fabricate.attributes_for(:user, password: 'a')
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
end
