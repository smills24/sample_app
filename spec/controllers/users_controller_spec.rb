require 'spec_helper'

describe UsersController do
render_views

  describe "GET 'index'" do

    describe "for non-signed in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :name => "Stoo", :email => "stoo@foo.com")
        third = Factory(:user, :name => "Joe", :email => "woohh@home.com")

        @users = [@user, second, third]

        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
       end

      it "should be a success" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector('title', :content => "Index")
      end

      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector('li', :content => user.name)
        end
      end

      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
         response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "Next")
      end

      end
    end

  describe "GET 'show'" do
    
   before(:each) do
      @user = Factory(:user)
    end

   it "should display user microposts" do
      mp1 = Factory(:micropost, :user => @user, :content => "Lorem ipsum")
      mp2 = Factory(:micropost, :user => @user, :content => "Foo bar")
      get :show, :id => @user
      response.should have_selector('span.content', :content => mp1.content)
      response.should have_selector('span.content', :content => mp2.content)
   end

   it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the correct user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end


  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

  it "should have the right title" do
     get 'new'
      response.should have_selector('title', :content => "Sign up")
  end 

  it "should have the right title" do
    get :show, :id => @user
    response.should have_selector("title", :content => @user.name)
  end

  it "should have the right h1 tag" do
    get :show, :id => @user
    response.should have_selector("h1", :content => @user.name)
  end

  it "should have a profile image" do
    get :show, :id => @user
    response.should have_selector("h1>img", :class => "gravatar")
  end

  end
end

  describe "POST 'create'" do

    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => "", :species => ""}
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render a 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

            
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "Steph Mills", 
                  :email=> "steph@gmail.com", 
                  :password => "stephiscool", 
                  :password_confirmation => "stephiscool",
                  :species => "Manatee"}        
      end

      it "should create a new user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end

    end

    describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be a success" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector('title', :content => "Edit")
    end

    it "should have an edit gravatar option" do
      get :edit, :id => @user
      gravatar_url = "http://www.gravatar.com/email"
      response.should have_selector('a', :href => gravatar_url, :content => "Change")
    end

    end
  


  end


  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

  describe "failure" do
    
    before(:each) do
      @attr = { :email => "", :name => "", :password => "",
                :password_confirmation => "" }
    end

  it "should render the 'edit' page" do
    put :update, :id => @user, :user => @attr
    response.should render_template('edit')
  end

  it "should have the right title" do
    put :update, :id => @user, :user => @attr
    response.should have_selector('title', :content => "Edit")
  end

end

  describe "success" do
    
    before(:each) do
      @attr = { :name => "New name", :email => "user@user.com",
                :password => "foobar", :password_confirmation => "foobar", :species => "Manatee" }
    end

    it "should change the users info" do
      put :update, :id => @user, :user => @attr
      @user.reload
      @user.name.should == @attr[:name]
      @user.email.should == @attr[:email]
    end

    it "should redirect to the user show page" do
      put :update, :id => @user, :user => @attr
      response.should redirect_to(user_path(@user))
    end

    it "should have a flash message" do
      put :update, :id => @user, :user => @attr
      flash[:success].should =~ /updated/i
    end
    end
    end

  describe "authentication" do
    
    before(:each) do
      @user = Factory(:user)
    end

    it "should deny access to 'edit'" do
      get :edit, :id => @user
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'update'" do
      put :update, :id => @user, :user => {}
      response.should redirect_to(signin_path)
    end

  

  describe "for signed in users" do

    before(:each) do
      wrong_user = Factory(:user, :email => "wrongemail@email.com")
      test_sign_in(wrong_user)
    end

    it "should require matching user" do
      get :edit, :id => @user
      response.should redirect_to(root_path)
    end
  
    it "should require matching user" do
      put :edit, :id => @user, :user => {}
      response.should redirect_to(root_path)
    end

  end


  end


  describe "DELETE 'destroy'" do
    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-signed in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end

    end


    describe "as a non-admin user" do
      it "should restrict access" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end


    describe "as an admin user" do

      before(:each) do
        admin = Factory(:user, :email => "woot@wooo.com")
        @user = Factory(:user, :email => "ugh@ugh.com")
        admin.toggle!(:admin)
        test_sign_in(admin)
    end

    it "should destroy the user" do
      lambda do
        delete :destroy, :id => @user
      end.should change(User, :count).by(-1)
    end

    it "should redirect to the users page" do
      delete :destroy, :id => @user
      response.should redirect_to(users_path)
    end

  end


end

end




