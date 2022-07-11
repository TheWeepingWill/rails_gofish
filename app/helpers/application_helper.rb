module ApplicationHelper
  def icon_name_for_flash(type)
    case type
    when 'notice'
      'check_circle'
    when 'alert'
      'cancel'
    else
      type
    end
  end


  def full_title(page_title = '')
		base_title = "Go Fish"
		if page_title.empty?
			base_title
		else
			page_title + " | " + base_title
		end
	end
end
