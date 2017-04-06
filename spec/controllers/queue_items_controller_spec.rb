require 'rails_helper'

describe QueueItemsController do
  let(:user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }

  describe 'GET index' do
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

  describe 'POST create' do
    context 'with authenticated users' do
      before { session[:user_id] = user.id }

      it 'redirects to the my queue page' do
        post :create, video_id: video.id
        expect(response).to redirect_to(my_queue_path)
      end

      it 'sets a video variable with the associated video' do
        expect(Video).to receive(:find).with(video.id.to_s)
        post :create, video_id: video.id
      end

      it 'creates a queue item' do
        expect(QueueItem).to receive(:create)
        post :create, video_id: video.id
      end

      it 'creates a queue item with the associated video' do
        expect(QueueItem).to receive(:create).with(hash_including(video: video))
        post :create, video_id: video.id
      end

      it 'creates a queue item with the signed in user' do
        expect(QueueItem).to receive(:create).with(hash_including(user: user))
        post :create, video_id: video.id
      end

      it 'puts the video as the last one in the queue' do
        Fabricate(:queue_item, video: Fabricate(:video), user: user)
        Fabricate(:queue_item, video: Fabricate(:video), user: user)
        post :create, video_id: video.id
        expect(QueueItem.find_by(user: user, video: video).position).to eq(3)
      end

      it 'does not add the video to the queue if video is already in the queue' do
        Fabricate(:queue_item, video: video, user: user)
        post :create, video_id: video.id
        expect(QueueItem.where(user: user, video: video).count).to eq(1)
      end
    end

    it 'redirects to sign in page for unauthenticated users' do
      post :create, video_id: video.id
      expect(response).to redirect_to(sign_in_path)
    end
  end

  describe 'DELETE destroy' do
    let(:queue_item) { Fabricate(:queue_item, user: user, video: video) }

    context 'with authenticated users' do
      before { session[:user_id] = user.id }

      it 'redirects to the my queue page' do
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to(my_queue_path)
      end

      it 'deletes the queue item' do
        delete :destroy, id: queue_item.id
        expect { QueueItem.find(queue_item) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'does not delete queue item if it is not in the signed in user\s queue' do
        user2 = Fabricate(:user)
        queue_item2 = Fabricate(:queue_item, user: user2, video: video)
        delete :destroy, id: queue_item2.id
        expect(QueueItem.find(queue_item2.id)).to be_present
      end
    end

    it 'redirects to sign in page for unauthenticated users' do
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
