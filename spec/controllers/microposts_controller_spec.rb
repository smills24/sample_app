require 'spec_helper'

describe MicropostsController do
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do

      before(:each) do
        @attr = { :content => " " }
      end

      it "should not create a blank post" do
        lambda do
          post :create, :content => @attr
        end.should_not change(Micropost, :count)
      end

      it "should redirect to homepage" do
        post :create, :content => @attr
        response.should render_template('page/home')
      end

    end

    describe "success" do

      before(:each) do
        @attr = { :content => "Lorem ipsum" }
      end

      it "should create a new micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should change(Micropost, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, :micropost => @attr
        response.should render_template('page/home')
      end

      it "should have a flash message" do
        post :create, :micropost => @attr
        flash[:success].should =~ /micropost created/i
      end

    end

    end

    describe "DELETE 'delete'" do

    describe "for the wrong user" do

      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should deny access" do
        delete :destroy, :id => @micropost
        response.should redirect_to(root_path)
      end
      end

      describe "for the correct user" do

        before(:each) do
          @user = test_sign_in(Factory(:user))
          @micropost = Factory(:micropost, :user => @user)
        end

        it "should delete the post" do
          
          lambda do
            delete :destroy, :id => @micropost
          end.should change(Micropost, :count).by(-1)

        end

    end

end
end



