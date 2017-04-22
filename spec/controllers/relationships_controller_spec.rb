require 'rails_helper'

describe RelationshipsController do
  describe 'GET index' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end

    it "sets @relationships to the current user's following relationships" do
      antoine = Fabricate(:user)
      set_current_user(antoine)
      bob = Fabricate(:user)
      joe = Fabricate(:user)

      relationship = Fabricate(:relationship, follower: antoine, leader: bob)
      relationship = Fabricate(:relationship, follower: antoine, leader: joe)

      get :index

      expect(assigns[:leaders]).to eq([bob, joe])
    end

    describe 'POST create' do
      it_behaves_like 'requires sign in' do
        let(:action) { post :create }
      end

      context 'with alredy existing relationship' do
        it 'does not create a new relationship' do
          set_current_user
          bob = Fabricate(:user)
          relationship = Fabricate(:relationship, follower: current_user, leader: bob)

          post :create, follower_id: current_user.id, leader_id: bob.id

          expect(Relationship.last).to eq(relationship)
        end

        it 'sets notice message' do
          set_current_user
          bob = Fabricate(:user)
          relationship = Fabricate(:relationship, follower: current_user, leader: bob)

          post :create, follower_id: current_user.id, leader_id: bob.id

          expect(flash[:notice]).to be_present
        end

        it 'redirects to visited user profile' do
          set_current_user
          bob = Fabricate(:user)
          relationship = Fabricate(:relationship, follower: current_user, leader: bob)

          post :create, follower_id: current_user.id, leader_id: bob.id

          expect(response).to redirect_to(people_path)
        end
      end

      context 'with unexisting relationship' do
        it 'creates the relationship' do
          set_current_user
          bob = Fabricate(:user)

          post :create, follower_id: current_user.id, leader_id: bob.id

          expect(Relationship.find_by(follower_id: current_user.id, leader_id: bob.id)).to be_present
        end

        it 'sets success message' do
          set_current_user
          bob = Fabricate(:user)

          post :create, follower_id: current_user.id, leader_id: bob.id

          expect(flash[:success]).to be_present
        end

        it 'does not set notice message' do
          set_current_user
          bob = Fabricate(:user)

          post :create, follower_id: current_user.id, leader_id: bob.id

          expect(flash[:notice]).to be_nil
        end

        it 'redirects to visited user profile' do
          set_current_user
          bob = Fabricate(:user)

          post :create, follower_id: current_user.id, leader_id: bob.id

          expect(response).to redirect_to(people_path)
        end
      end

      it 'does not allow the current user to follow himself/herslef' do
        set_current_user

        post :create, follower_id: current_user.id, leader_id: current_user.id

        expect(flash[:error]).to be_present
        expect(response).to redirect_to(people_path)
      end
    end

    describe 'DELETE destroy' do
      it_behaves_like 'requires sign in' do
        let(:action) { delete :destroy, id: 1 }
      end

      context 'with current user not being the follower of the relationship' do
        it 'does not delete the relationship' do
          set_current_user

          bob = Fabricate(:user)
          joe = Fabricate(:user)
          relationship = Fabricate(:relationship, follower: bob, leader: joe)

          delete :destroy, id: relationship.id

          expect(Relationship.last).to eq(relationship)
        end

        it 'redirects user to people page' do
          set_current_user

          bob = Fabricate(:user)
          joe = Fabricate(:user)
          relationship = Fabricate(:relationship, follower: bob, leader: joe)

          delete :destroy, id: relationship.id

          expect(response).to redirect_to(people_path)
        end
      end

      context 'with current user as follower of the relationship' do
        it 'deletes the relationship' do
          set_current_user

          bob = Fabricate(:user)
          relationship = Fabricate(:relationship, follower: current_user, leader: bob)

          delete :destroy, id: relationship.id

          expect { Relationship.find(relationship.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'redirects to people page' do
          set_current_user

          bob = Fabricate(:user)
          relationship = Fabricate(:relationship, follower: current_user, leader: bob)

          delete :destroy, id: relationship.id

          expect(response).to redirect_to(people_path)
        end
      end
    end
  end
end
