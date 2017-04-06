require 'rails_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe '#recent_videos' do
    it 'returns an empty array if there are no videos' do
      movies = Category.create(name: 'Movies')
      expect(movies.recent_videos).to eq([])
    end

    it 'returns an array with one video if there is exactly one video' do
      movies = Category.create(name: 'Movies')
      Video.create(title: 'Inception', description: 'great movie', category: movies)
      expect(movies.recent_videos.count).to eq(1)
    end

    it 'returns an array with 6 videos if there are more than 6 videos' do
      movies = Category.create(name: 'Movies')

      10.times do |n|
        Video.create(title: "video #{n}", description: "desc #{n}", category: movies)
      end

      expect(movies.recent_videos.count).to eq(6)
    end

    it 'returns an array with the videos in reverse chronological order by created_at' do
      movies = Category.create(name: 'Movies')
      inception = Video.create(title: 'Inception', description: 'great movie', category: movies)
      blood_diamond = Video.create(title: 'Blood Diamond', description: 'great movie', category: movies, created_at: 1.day.ago)
      expect(movies.recent_videos).to eq([inception, blood_diamond])
    end

    it 'returns the 6 most recent videos' do
      movies = Category.create(name: 'Movies')
      videos = []

      10.times do |n|
        videos << Video.create(title: "video #{n}", description: "desc #{n}", category: movies, created_at: n.day.ago)
      end

      expect(movies.recent_videos).to eq(videos[0..5])
    end
  end
end
