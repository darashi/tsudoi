class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create]

  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # render index.rhtml
  def index
  end

  # render new.rhtml
  def new
  end
  
  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end
  
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])

    @user.save!
    #Uncomment to have the user logged in after creating an account - Not Recommended
    #self.current_user = @user
    redirect_back_or_default('/')
    flash[:notice] = "Thanks for signing up! Please check your email to activate your account before logging in."
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end
  
  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_back_or_default('/home') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? :false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
  end

end
