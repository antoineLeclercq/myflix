module ApplicationHelper
  def options_for_video_ratings(selected=nil)
    options_for_select([['1 Star', 1], ['2 Stars', 2], ['3 Stars', 3], ['4 Stars', 4], ['5 Stars', 5]], selected)
  end
end
