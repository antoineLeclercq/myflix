require 'rails_helper'

describe User do
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should have_many(:queue_items).order(:position) }
  it { should have_secure_password }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(5) }
  it { should validate_presence_of(:full_name) }
  it { should have_many(:following_relationships).class_name('Relationship').with_foreign_key(:follower_id) }
  it { should have_many(:leaders).through(:following_relationships) }
  it { should have_many(:leading_relationships).class_name('Relationship').with_foreign_key(:leader_id) }
  it { should have_many(:followers).through(:leading_relationships) }
  it { should have_many(:invitations).with_foreign_key(:inviter_id) }

  it 'generates a random token when the user is created' do
    joe = Fabricate(:user)
    expect(joe.token).to be_present
  end

  describe '#follows?' do
    it 'returns true if the user has a following relationship with another user' do
      bob = Fabricate(:user)
      joe = Fabricate(:user)
      Fabricate(:relationship, follower: bob, leader: joe)

      expect(bob.follows?(joe)).to eq(true)
    end

    it "returns false if the user doesn't have a following relationship with another user" do
      bob = Fabricate(:user)
      joe = Fabricate(:user)

      expect(bob.follows?(joe)).to eq(false)
    end
  end

  describe '#can_follow?' do
    it "returns true if the user doesn't have a following relationship with another user" do
      bob = Fabricate(:user)
      joe = Fabricate(:user)

      expect(bob.can_follow?(joe)).to eq(true)
    end

    it "returns true if the user isn't the other user" do
      bob = Fabricate(:user)
      joe = Fabricate(:user)

      expect(bob.can_follow?(joe)).to eq(true)
    end

    it 'returns false if the user has a following relationship with another user' do
      bob = Fabricate(:user)
      joe = Fabricate(:user)
      Fabricate(:relationship, follower: bob, leader: joe)

      expect(bob.can_follow?(joe)).to eq(false)
    end

    it "returns false if the user is the other user" do
      bob = Fabricate(:user)

      expect(bob.can_follow?(bob)).to eq(false)
    end
  end

  describe '#follow' do
    it 'follows another user' do
      bob = Fabricate(:user)
      joe = Fabricate(:user)

      bob.follow(joe)

      expect(bob.follows?(joe)).to eq(true)
    end

    it 'does not follow the other user if the user can\'t follow the other user' do
      bob = Fabricate(:user)
      bob.follow(bob)

      expect(bob.follows?(bob)).to eq(false)
    end
  end
end
