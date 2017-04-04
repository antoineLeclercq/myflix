require 'rails_helper'

describe VideosController do
  describe 'GET show' do
    let(:video) { Fabricate(:video) }

    it 'sets @video for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :show, id: video
      expect(assigns(:video)).to eq(video)
    end

    it 'redirects to sign in page for unauthenticated users' do
      get :show, id: video
      expect(response).to redirect_to(sign_in_path)
    end
  end

  describe 'GET search' do
    let(:video) { Fabricate(:video, title: 'Inception') }

    it 'sets @videos for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      video
      get :search, search_term: 'Ince'
      expect(assigns(:videos)).to eq([video])
    end

    it 'redirects to sign in page for unauthenticated users' do
      get :search
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
