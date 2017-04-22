class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @leaders = current_user.leaders
  end

  def create
    leader = User.find(params[:leader_id])

    if current_user.follows?(leader)
      flash[:notice] = "You are already following #{leader.full_name}."
    elsif leader == current_user
      flash[:error] = "You cannot follow yourself."
    else
      Relationship.create(follower: current_user, leader: leader)
      flash[:success] = "You are now following #{leader.full_name}."
    end

    redirect_to people_path
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.delete if current_user == relationship.follower
    redirect_to people_path
  end
end
