require 'rails_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe 'search_by_title' do
    it 'returns an empty array if no video is found' do
      inception = Video.create(title: 'Inception', description: 'great movie')
      blood_diamond = Video.create(title: 'Blood Diamond', description: 'awesome movie')
      expect(Video.search_by_title('A search')).to eq([])
    end

    it 'returns an array with one video for an exact match' do
      inception = Video.create(title: 'Inception', description: 'great movie')
      blood_diamond = Video.create(title: 'Blood Diamond', description: 'awesome movie')
      expect(Video.search_by_title('Inception')).to eq([inception])
    end

    it 'returns an array with one video for a partial match' do
      inception = Video.create(title: 'Inception', description: 'great movie')
      blood_diamond = Video.create(title: 'Blood Diamond', description: 'awesome movie')
      expect(Video.search_by_title('cept')).to eq([inception])
    end

    it 'returns an array with one video for case-insensitive partial match' do
      inception = Video.create(title: 'Inception', description: 'great movie')
      blood_diamond = Video.create(title: 'Blood Diamond', description: 'awesome movie')
      expect(Video.search_by_title('blood diamond')).to eq([blood_diamond])
    end

    it 'returns an array of all matches ordered by created_at' do
      inception = Video.create(title: 'Inception', description: 'great movie', created_at: 1.day.ago)
      blood_diamond = Video.create(title: 'Blood Diamond', description: 'awesome movie')
      expect(Video.search_by_title('on')).to eq([blood_diamond, inception])
    end

    it 'returns an empty array for a search with an empty string' do
      inception = Video.create(title: 'Inception', description: 'great movie', created_at: 1.day.ago)
      blood_diamond = Video.create(title: 'Blood Diamond', description: 'awesome movie')
      expect(Video.search_by_title('')).to eq([])
    end

    it 'returns an empty array for a search with whitespace only' do
      inception = Video.create(title: 'Inception', description: 'great movie', created_at: 1.day.ago)
      blood_diamond = Video.create(title: 'Blood Diamond', description: 'awesome movie')
      expect(Video.search_by_title(' ')).to eq([])
    end
  end
end
