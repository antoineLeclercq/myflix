require 'rails_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:video) }
  it { should validate_presence_of(:position) }
  it { should validate_numericality_of(:position).only_integer.is_greater_than(0) }

  let(:user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }
  let(:queue_item) { Fabricate(:queue_item, video: video, user: user) }

  describe '#video_title' do
    it 'returns the title of the associated video' do
      video.title = 'Friends'
      video.save
      expect(queue_item.video_title).to eq('Friends')
    end
  end

  describe '#rating' do
    it 'returns nil if review from the associated user on the associated video is not present' do
      expect(queue_item.rating).to be_nil
    end

    it 'returns the rating of the review by the associated user for the associated video' do
      Fabricate(:review, rating: 5, creator: user, video: video)
      expect(queue_item.rating).to eq(5)
    end
  end

  describe '#category_name' do
    it 'returns the category name of the associated video' do
      video.category = Fabricate(:category, name: 'movies')
      expect(queue_item.category_name).to eq('movies')
    end
  end

  describe '#category' do
    it 'returns the category of the associated videos' do
      video.category = Fabricate(:category)
      expect(queue_item.category).to eq(video.category)
    end
  end

  describe '#rating=' do
    context 'with existing review' do
      it 'updates the rating' do
        review = Fabricate(:review, rating: 4, creator: user, video: video)
        queue_item.rating = 5
        expect(queue_item.rating).to eq(5)
      end

      it 'clears the rating of the review if the rating is blank' do
        review = Fabricate(:review, rating: 4, creator: user, video: video)
        queue_item.rating = ''
        expect(queue_item.rating).to be_nil
      end
    end

    context 'without existing review' do
      it 'does not create a review if the rating is blank' do
        queue_item.rating = ''
        expect(queue_item.rating).to be_nil
      end

      it 'creates new review with the rating' do
        queue_item.rating = 4
        expect(queue_item.rating).to eq(4)
      end
    end
  end
end
