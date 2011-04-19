class PageController < ApplicationController

  def home
    @title = "Home"
    @content = "Welcome to the homepage"
  end

  def contact
    @title = "Contact"
    @content = "Email me at stephmills24@gmail.com"
  end

  def about
    @title = "About"
    @content = "This is a silly little app I made"   
  end

end
