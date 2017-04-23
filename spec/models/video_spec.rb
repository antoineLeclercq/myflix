require 'rails_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  it 'generates a random token when the user is created' do
    inception = Fabricate(:video)
    expect(inception.token).to be_present
  end

  describe 'search_by_title' do
    let(:inception) { Video.create(title: 'Inception', description: 'great movie') }
    let(:blood_diamond) { Video.create(title: 'Blood Diamond', description: 'awesome movie') }

    it 'returns an empty array if no video is found' do
      expect(Video.search_by_title('A search')).to eq([])
    end

    it 'returns an array with one video for an exact match' do
      expect(Video.search_by_title('Inception')).to eq([inception])
    end

    it 'returns an array with one video for a partial match' do
      expect(Video.search_by_title('cept')).to eq([inception])
    end

    it 'returns an array with one video for case-insensitive partial match' do
      expect(Video.search_by_title('blood diamond')).to eq([blood_diamond])
    end

    it 'returns an array of all matches ordered by created_at' do
      inception.created_at = 1.day.ago
      expect(Video.search_by_title('on')).to eq([blood_diamond, inception])
    end

    it 'returns an empty array for a search with an empty string' do
      expect(Video.search_by_title('')).to eq([])
    end

    it 'returns an empty array for a search with whitespace only' do
      expect(Video.search_by_title(' ')).to eq([])
    end
  end

  describe '#average_rating' do
    let(:video) { Fabricate(:video) }
    let(:review) { Fabricate(:review) }

    it 'returns a message if there is no reviews for the video' do
      expect(video.average_rating).to eq('No ratings')
    end

    it 'returns the rating of the review if there is one review for the video' do
      video.reviews << review
      expect(video.average_rating).to eq(review.rating)
    end

    it 'returns the average for the rating of the reviews for the video' do
      review1 = Fabricate(:review, rating: 1)
      review2 = Fabricate(:review, rating: 2)
      review3 = Fabricate(:review, rating: 2)
      video.reviews.push(review1, review2, review3)
      expect(video.average_rating).to eq(1.7)
    end
  end
end
