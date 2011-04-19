require 'spec_helper'

describe PageController do
  render_views

  describe "GET 'about'" do
    it "should have the right title" do
      get 'about'
      response.should have_selector("title", :content => " | About")
    end
    it "should be successful" do
      get 'about'
      response.should be_success
    end
  end


  describe "GET 'home'" do
    it "should have the right title" do
      get 'home'
      response.should have_selector("title", :content => " | Home")
    end

    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end

  describe "GET 'contact'" do
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title", :content => " | Contact")
    end

    it "should be successful" do
      get 'contact'
      response.should be_success
    end
  end

end
