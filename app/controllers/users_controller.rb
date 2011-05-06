class UsersController < ApplicationController
before_filter :authenticate, :only => [ :edit, :update, :index]
before_filter :correct_user, :only => [ :edit, :update]
before_filter :admin_user, :only => [ :destroy ]

  def new
    @user = User.new
    @title = "Sign up"
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the sample app!"
      sign_in @user
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @title = "Edit"
  end

   def update
      @user = User.find(params[:id])
      if @user.update_attributes(params[:user])
        flash[:success] = "Profile updated"
        redirect_to @user
      else      
        @title = "Edit"
        render 'edit'
      end
   end

  def index
    if signed_in?
      @title = "Index"
      @users = User.all.paginate(:page => params[:page])
    else
      flash[:notice] = "Please sign in"
      redirect_to signin_path
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end


  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless (current_user && current_user.admin?)
    end

end
