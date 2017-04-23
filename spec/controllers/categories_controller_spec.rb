require 'rails_helper'

describe CategoriesController do
  describe 'GET index' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end

    it 'sets @categories with all existing categories' do
      set_current_user
      movies = Fabricate(:category)
      tv_shows = Fabricate(:category)

      get :index

      expect(assigns[:categories]).to match([movies, tv_shows])
    end
  end

  describe 'GET show' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end

    it 'sets @category' do
      set_current_user
      movies = Fabricate(:category)

      get :show, id: movies.token

      expect(assigns[:category]).to eq(movies)
    end
  end
end
