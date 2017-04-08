require 'rails_helper'

describe VideosController do
  before { set_current_user }

  describe 'GET show' do
    let(:video) { Fabricate(:video) }

    it 'sets @video' do
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it 'sets @review as new record' do
      get :show, id: video.id
      expect(assigns(:review)).to be_instance_of(Review)
      expect(assigns(:review)).to be_new_record
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :show, id: video }
    end
  end

  describe 'GET search' do
    let(:video) { Fabricate(:video, title: 'Inception') }

    it 'sets @videos for authenticated users' do
      get :search, search_term: 'Ince'
      expect(assigns(:videos)).to eq([video])
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :search }
    end
  end
end
