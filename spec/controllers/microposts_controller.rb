require 'spec_helper'

  describe MicropostsController do
    render_views

  describe "access controls fro microposts" do

    it "should deny access to signed out users" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end

  end

end 
