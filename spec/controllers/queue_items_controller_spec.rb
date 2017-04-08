require 'rails_helper'

describe QueueItemsController do
  let(:video) { Fabricate(:video) }

  before { set_current_user }

  describe 'GET index' do
    it 'sets @queue_items to queue items of current user' do
      queue_item1 = Fabricate(:queue_item, user: current_user, video: video)
      queue_item2 = Fabricate(:queue_item, user: current_user, video: video)
      get :index
      expect(assigns[:queue_items]).to match_array([queue_item1, queue_item2])
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end
  end

  describe 'POST create' do
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
      expect(QueueItem).to receive(:create).with(hash_including(user: current_user))
      post :create, video_id: video.id
    end

    it 'puts the video as the last one in the queue' do
      Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
      Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
      post :create, video_id: video.id
      expect(QueueItem.find_by(user: current_user, video: video).position).to eq(3)
    end

    it 'does not add the video to the queue if video is already in the queue' do
      Fabricate(:queue_item, video: video, user: current_user)
      post :create, video_id: video.id
      expect(QueueItem.where(user: current_user, video: video).count).to eq(1)
    end

    it_behaves_like 'requires sign in' do
      let(:action) { post :create }
    end
  end

  describe 'DELETE destroy' do
    let(:queue_item) { Fabricate(:queue_item, user: current_user, video: video, position: 1) }

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

    it 'normalizes the remaining queue items position' do
      queue_item2 = Fabricate(:queue_item, user: current_user, video: Fabricate(:video), position: 2)
      delete :destroy, id: queue_item.id
      expect(queue_item2.reload.position).to eq(1)
    end

    it_behaves_like 'requires sign in' do
      let(:action) { delete :destroy, id: Fabricate(:queue_item, user: Fabricate(:user), video: video).id }
    end
  end

  describe 'PATCH update' do
    let(:queue_item1) { Fabricate(:queue_item, video: video, user: current_user, position: 1) }
    let(:queue_item2) { Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 2) }

    context 'with valid inputs' do
      it 'redirects to my queue page' do
        patch :update, queue_items: [{ id: queue_item1.id, position: 2 }]
        expect(response).to redirect_to(my_queue_path)
      end

      it 'reorders the queue items' do
        queue_item3 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 3)

        patch :update, queue_items: [
          { id: queue_item1.id, position: 3 },
          { id: queue_item2.id, position: 2 },
          { id: queue_item3.id, position: 1 }
        ]

        expect(current_user.queue_items).to eq([queue_item3, queue_item2, queue_item1])
      end

      it 'normalizes the queue items position numbers to start with 1' do
        patch :update, queue_items: [
          { id: queue_item1.id, position: 3 },
          { id: queue_item2.id, position: 2 }
        ]
        expect(current_user.queue_items.pluck(:position)).to eq([1, 2])
      end

      it 'updates the ratings for queue items' do
        patch :update, queue_items: [
          { id: queue_item1.id, position: 1, rating: 4 },
          { id: queue_item2.id, position: 2, rating: 5 }
        ]
        expect(queue_item1.rating).to eq(4)
        expect(queue_item2.rating).to eq(5)
      end
    end

    context 'with invalid inputs' do
      it 'redirects to my queue page' do
        patch :update, queue_items: [{ id: queue_item1.id, position: 0.5 }]
        expect(response).to redirect_to(my_queue_path)
      end

      it 'sets the flash error message' do
        patch :update, queue_items: [{ id: queue_item1.id, position: 0.5 }]
        expect(flash[:danger]).to be_present
      end

      it 'does not update any queue item' do
        patch :update, queue_items: [
          { id: queue_item1.id, position: 2 },
          { id: queue_item2.id, position: 0.5 }
        ]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    it_behaves_like 'requires sign in' do
      let(:action) { patch :update, queue_items: [{ id: Fabricate(:queue_item, user: Fabricate(:user), video: video).id, position: 2 }] }
    end

    it 'does not update the queue items that do not belong to current user' do
      queue_item1 = Fabricate(:queue_item, video: video, user: current_user, position: 4)

      user2 = Fabricate(:user)
      queue_item2 = Fabricate(:queue_item, video: Fabricate(:video), user: user2, position: 1)
      queue_item3 = Fabricate(:queue_item, video: Fabricate(:video), user: user2, position: 2)

      patch :update, queue_items: [
        { id: queue_item1.id, position: 1 },
        { id: queue_item2.id, position: 3 },
        { id: queue_item3.id, position: 2 }
      ]

      expect(queue_item1.reload.position).to eq(1)
      expect(queue_item2.reload.position).to eq(1)
      expect(queue_item3.reload.position).to eq(2)
    end
  end
end
