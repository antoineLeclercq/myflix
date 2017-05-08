require 'rails_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end

    it_behaves_like 'requires admin' do
      let(:action) { get :new }
    end

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

  describe 'POST create' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end

    it_behaves_like 'requires admin' do
      let(:action) { post :create }
    end

    before { set_current_admin }

    it 'tries to save the video' do
      category = Fabricate(:category)
      video_attrs = Fabricate.attributes_for(:video, category_id: category.id.to_s)
      video = Fabricate.build(:video, video_attrs)

      expect(Video).to receive(:new).with(video_attrs).and_return(video)
      expect(video).to receive(:save)

      post :create, video: video_attrs
    end

    context 'with valid input' do
      it 'sets success message' do
        category = Fabricate(:category)
        post :create, video: Fabricate.attributes_for(:video, category: category)

        expect(flash[:success]).to be_present
      end

      it 'redirects to the add video page' do
        category = Fabricate(:category)
        post :create, video: Fabricate.attributes_for(:video, category: category)

        expect(response).to redirect_to(new_admin_video_path)
      end
    end

    context 'with invalid input' do
      it 'sets @video' do
        category = Fabricate(:category)
        post :create, video: Fabricate.attributes_for(:video, title: '', category: category)

        expect(assigns(:video)).to be_a(Video)
        expect(assigns(:video)).to be_new_record
      end

      it 'sets error message' do
        category = Fabricate(:category)
        post :create, video: Fabricate.attributes_for(:video, title: '', category: category)

        expect(flash.now[:error]).to be_present
      end

      it 'renders new template' do
        category = Fabricate(:category)
        post :create, video: Fabricate.attributes_for(:video, title: '', category: category)

        expect(response).to render_template(:new)
      end
    end
  end
end
