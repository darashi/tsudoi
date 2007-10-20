class AccountController < ApplicationController

  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie

  # say something nice, you goof!  something sweet.
  def index
    if logged_in?
      redirect_to(:controller => 'index', :action => 'index')
    else
      redirect_to(:action => 'signup')
    end
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => 'index', :action => 'index')
      flash[:notice] = "Logged in successfully"
    end
  end

  def signup
    @user = User.new(params[:user])
    return unless request.post?
    begin
      User.transaction do
        @user.save!
        #    self.current_user = @user
        #    redirect_back_or_default(:controller => '/account', :action => 'index')
        flash[:notice] = "Thanks for signing up!"
        render :action => 'signup_notification'
      end
    rescue ActiveRecord::RecordInvalid
      flash[:notice] = "ユーザー登録に失敗しました"
      render :action => 'signup'
    end
  end

  def signup_notification

  end

  def activate
    @user = User.find_by_activation_code(params[:id])
    if @user and @user.activate
      self.current_user = @user
#      flash[:notice] = "ユーザー登録が完了しました"
    else
      flash[:notice] = "ユーザー登録に失敗しました"
    end
  end

  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => 'index', :action => 'index')
  end
end
