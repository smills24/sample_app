require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => "Bob",
              :email => "bob@bob.com",
              :password => "iluvsteph",
              :password_confirmation => "iluvsteph",
              :species => "Manatee" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should not be more than 50 characters" do
    long_name = "s"*51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email address" do
    addresses = %w[user@place.com THE_USER@boop.goo.ca first.last@noo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
    end

  it "should reject invalid email address" do
    addresses = %w[user@place,com squash.ca examp.hey@co]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
  end  
end

  it "should reject duplicate entries" do
    User.create!(@attr)
    duplicate_user = User.new(@attr)
    duplicate_user.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    duplicate_user = User.new(@attr)
    duplicate_user.should_not be_valid
  end


  describe "valid password" do
    
    it "should not be too short" do
      short = "a"*5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should not be too long" do
      long = "a"*41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end

    it "should not be blank" do
      user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
      user.should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end


  end

  describe "encrypted password" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should encrypt the password" do
      @user.encrypted_password.should_not be_blank
    end


    describe "has_password? method" do
    
    it "should be true if the password matches" do
      @user.has_password?(@attr[:password]).should be_true
    end

    it "should reject mismatched passwords" do
      @user.has_password?("invalid").should be_false
    end   

  end

  describe "authenticate user method" do

    it "should return nil if the password doesn't match" do
      wrong_pass_user = User.authenticate(@attr[:email], "wrongpass")
      wrong_pass_user.should be_nil
    end
    
    it "should return nil for a nonexistant user" do
      nonexistant_user = User.authenticate("stoo@boo.com", @attr[:password])
      nonexistant_user.should be_nil 
    end

    it "should be valid if the password matches" do
      matching_user = User.authenticate(@attr[:email], @attr[:password])
      matching_user.should == @user
    end

  end

  describe "sign in/out" do
    
    it "should not sign in blank users" do
      visit '/signin_path'
      fill_in :email, :with => ""
      fill_in :password, :with => ""
      click_button
      response.should have_selector('div.flash.error', :content => "Invalid")
    end
  end

  describe "success" do
    it "should sign in a valid user" do
      user = Factory(:user)
      visit '/signin_path'
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.password
      click_button
      controller.should be_signed_in
      click_link "Sign out"
      controller.should_not be_signed_in
    end

  end


end


  describe "admin users" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should be convertible to admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end

  end

    describe "micropost associations" do

      before(:each) do
        @user = User.create!(@attr)
        @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
        @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
      end

      it "should have a microposts attribute" do
        @user.should respond_to(:microposts)
      end

      it "should order the microposts by date" do
        @user.microposts.should == [@mp2, @mp1]
      end

      it "should destroy associated microposts" do
        @user.destroy
        [@mp1, @mp2].each do |micropost|
          Micropost.find_by_id(micropost.id).should be_nil
        end
        end

       describe "it should have a feed" do
       
          it "should have a feed" do
             @user.should respond_to(:feed)
          end

          it "should include the microposts" do
            @user.feed.include?(@mp1).should be_true
            @user.feed.include?(@mp2).should be_true
          end

          it "should not include other users microposts" do
            mp3 = Factory(:micropost, :user => Factory(:user, :email => Factory.next(:email)))
            @user.feed.include?(mp3).should be_false
          end

      end

    end
end

