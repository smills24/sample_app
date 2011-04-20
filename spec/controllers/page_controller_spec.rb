require 'spec_helper'

describe PageController do
  render_views

  before(:each) do
    @base_title = "Steph's app"
  end


  describe "GET 'about'" do
    it "should have the right title" do
      get 'about'
      response.should have_selector("title", 
                                    :content => @base_title + " | About")
    end
    it "should be successful" do
      get 'about'
      response.should be_success
    end
  end


  describe "GET 'home'" do
    it "should have the right title" do
      get 'home'
      response.should have_selector("title", 
                                    :content => @base_title + " | Home")
    end

    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end

  describe "GET 'contact'" do
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title", 
                                    :content => @base_title + " | Contact")
    end

    it "should be successful" do
      get 'contact'
      response.should be_success
    end
  end

  describe "GET 'help'" do
    it "should have the right title" do
      get 'help'
      response.should have_selector("title", 
                                    :content => @base_title + " | Help")
    end

    it "should be successful" do
      get 'help'
      response.should be_success
    end
  end


end
