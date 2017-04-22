module ApplicationHelper
  def message_type_class_name(type)
    types_name = HashWithIndifferentAccess.new(
      error: 'danger',
      notice: 'info',
      success: 'success'
    )

    types_name[type]
  end
  
  def options_for_video_ratings(selected=nil)
    options_for_select([['1 Star', 1], ['2 Stars', 2], ['3 Stars', 3], ['4 Stars', 4], ['5 Stars', 5]], selected)
  end
end
