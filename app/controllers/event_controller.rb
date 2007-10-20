class EventController < ApplicationController
  # Eventの状態を変更するためにはログインが必要
  before_filter :login_required, :only => [:destroy, :create, :update, :owned, :new, :edit]

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    # TODO: 募集中のものだけを抽出
    @events = Event.find(:all, params[:id])
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])
    @event.owner_user_id = self.current_user.id
    if @event.save
      flash[:notice] = 'Event was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
    if @event.owner != self.current_user
      redirect_to :back
      return false
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.owner != self.current_user
      redirect_to :back
      return false
    end
    if @event.update_attributes(params[:event])
      flash[:notice] = 'Event was successfully updated.'
      redirect_to :action => 'show', :id => @event
    else
      render :action => 'edit'
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    if @event.owner != self.current_user
      redirect_to :back
      return false
    end
    redirect_to :action => 'list'
  end
  def owned
    @events = self.current_user.owned_events
  end

end
