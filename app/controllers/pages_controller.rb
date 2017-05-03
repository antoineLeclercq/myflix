class PagesController < ApplicationController
  before_action :redirect_logged_in_user
end
