module ApplicationHelper

  #Return a title on a page
  def pagetitle
    base_title = "Steph's app"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
