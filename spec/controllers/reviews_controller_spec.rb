require 'rails_helper'

describe ReviewsController do
  describe 'POST create' do
    let(:video) { Fabricate(:video) }

    context 'with authenticated users' do
      let(:user) { Fabricate(:user) }
      before { session[:user_id] = user.id }

      it 'sets @review with creator and video' do
        post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        expect(assigns(:review)).to be_instance_of(Review)
        expect(assigns(:review).creator).to eq(user)
        expect(assigns(:review).video).to eq(video)
      end

      it 'tries to create the review' do
        review = Fabricate.build(:review)
        expect(Review).to receive(:new).and_return(review)
        expect(review).to receive(:save)
        post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
      end

      context 'with valid input' do
        before { post :create, video_id: video.id, review: Fabricate.attributes_for(:review) }

        it { expect(flash[:success]).to be_present }
        it { expect(response).to redirect_to(video_path(video)) }
      end

      context 'invalid input' do
        it 'sets @video with existing video' do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
          expect(assigns(:video)).to eq(video)
        end

        it 'renders video show template if invalid input' do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review, rating: 10)
          expect(response).to render_template('videos/show')
        end
      end
    end

    it 'redirects to sign in page with unauthenticated users' do
      post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
