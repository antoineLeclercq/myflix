require 'rails_helper'

describe QueueItemsController do
  describe 'GET index' do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    it 'sets @queue_items to queue items of logged in user' do
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user, video: video)
      queue_item2 = Fabricate(:queue_item, user: user, video: video)
      get :index
      expect(assigns[:queue_items]).to match_array([queue_item1, queue_item2])
    end

    it 'redirects to sign in page for unauthenticated users' do
      get :index
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
