class PageController < ApplicationController

  def help
    @title = "Help"
  end

  def home
    @title = "Home"
    @micropost = Micropost.new if signed_in?  
    if signed_in?
      @microposts = Micropost.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

end
