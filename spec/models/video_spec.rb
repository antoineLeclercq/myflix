require 'rails_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  it_behaves_like 'tokenable' do
    let(:object) { Fabricate(:video) }
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

  describe '#rating' do
    let(:video) { Fabricate(:video) }
    let(:review) { Fabricate(:review) }

    it 'returns nil if there is no reviews for the video' do
      expect(video.rating).to be_nil
    end

    it 'returns the rating of the review if there is one review for the video' do
      video.reviews << review
      expect(video.rating).to eq(review.rating)
    end

    it 'returns the average for the rating of the reviews for the video' do
      review1 = Fabricate(:review, rating: 1)
      review2 = Fabricate(:review, rating: 2)
      review3 = Fabricate(:review, rating: 2)
      video.reviews.push(review1, review2, review3)
      expect(video.rating).to eq(1.7)
    end
  end

  describe '.search', :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context 'with title' do
      it "returns no results when there's no match" do
        Fabricate(:video, title: 'Inception')
        refresh_index

        expect(Video.search('whatever').records.to_a).to eq([])
      end

      it "returns an empty array when there's no search term" do
        Fabricate(:video, title: 'Inception')
        Fabricate(:video, title: 'Friends')
        refresh_index

        expect(Video.search('').records.to_a).to eq([])
      end

      it 'returns an array of 1 video for title case insensitve match' do
        Fabricate(:video, title: 'Friends')
        inception = Fabricate(:video, title: 'Inception')
        refresh_index

        expect(Video.search('inception').records.to_a).to eq([inception])
      end

      it 'returns an array of many videos for title match' do
        star_trek = Fabricate(:video, title: 'Star Trek')
        star_wars = Fabricate(:video, title: 'Star Wars')
        refresh_index

        expect(Video.search('star').records.to_a).to match_array([star_trek, star_wars])
      end
    end

    context 'with title and description' do
      it 'returns an array of many videos based for title and description match' do
        star_wars = Fabricate(:video, title: 'Star Wars')
        about_sun = Fabricate(:video, description: 'sun is a star')
        refresh_index

        expect(Video.search('star').records.to_a).to match_array([star_wars, about_sun])
      end
    end

    context 'multiple words must match' do
      it 'returns an array of videos where 2 words match title' do
        star_wars_1 = Fabricate(:video, title: 'Star Wars: Episode 1')
        star_wars_2 = Fabricate(:video, title: 'Star Wars: Episode 2')
        Fabricate(:video, title: 'Bride Wars')
        Fabricate(:video, title: 'Star Trek')
        refresh_index

        expect(Video.search('Star Wars').records.to_a).to match_array([star_wars_1, star_wars_2])
      end
    end

    context 'with title, description and reviews' do
      it 'returns an an empty array for no match with reviews option' do
        star_wars = Fabricate(:video, title: 'Star Wars')
        batman = Fabricate(:video, title: 'Batman')
        batman_review = Fabricate(:review, video: batman, body: 'such a star movie!')
        refresh_index

        expect(Video.search('no_match', reviews: true).records.to_a).to eq([])
      end

      it 'returns an array of many videos with relevance title > description > review' do
        star_wars = Fabricate(:video, title: 'Star Wars')
        about_sun = Fabricate(:video, description: 'the sun is a star!')
        batman  = Fabricate(:video, title: 'Batman')
        batman_review = Fabricate(:review, video: batman, body: 'such a star movie!')
        refresh_index

        expect(Video.search('star', reviews: true).records.to_a).to eq([star_wars, about_sun, batman])
      end
    end

    context "filter with average ratings" do
      let(:star_wars_1) { Fabricate(:video, title: "Star Wars 1") }
      let(:star_wars_2) { Fabricate(:video, title: "Star Wars 2") }
      let(:star_wars_3) { Fabricate(:video, title: "Star Wars 3") }

      before do
        Fabricate(:review, rating: "2", video: star_wars_1)
        Fabricate(:review, rating: "4", video: star_wars_1)
        Fabricate(:review, rating: "4", video: star_wars_2)
        Fabricate(:review, rating: "2", video: star_wars_3)
        refresh_index
      end

      context "with only rating_from" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_from: "4.1").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_from: "4.0").records.to_a).to eq [star_wars_2]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_from: "3.0").records.to_a).to match_array [star_wars_2, star_wars_1]
        end
      end

      context "with only rating_to" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_to: "1.5").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_to: "2.5").records.to_a).to eq [star_wars_3]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_to: "3.4").records.to_a).to match_array [star_wars_1, star_wars_3]
        end
      end

      context "with both rating_from and rating_to" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_from: "3.4", rating_to: "3.9").records.to_a).to eq []
        end

        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_from: "1.8", rating_to: "2.2").records.to_a).to eq [star_wars_3]
        end

        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_from: "2.9", rating_to: "4.1").records.to_a).to match_array [star_wars_1, star_wars_2]
        end
      end
    end
  end
end
