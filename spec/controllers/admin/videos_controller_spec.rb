require 'rails_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end

    context 'with non-admin users' do
      before { set_current_user }

      it 'sets error message' do
        get :new
        expect(flash[:error]).to be_present
      end

      it 'redirects to home page' do
        get :new
        expect(response).to redirect_to(home_path)
      end
    end

    context 'with admin users' do
      before { set_current_admin }

      it 'does not set error message' do
        get :new
        expect(flash[:error]).to be_nil
      end

      it 'sets @video to a new Video record' do
        get :new
        expect(assigns[:video]).to be_a(Video)
        expect(assigns[:video]).to be_new_record
      end
    end
  end
end
