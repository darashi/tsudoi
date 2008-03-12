class EventsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]  
  # GET /events
  # GET /events.xml
  def index
    @events = Event.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event
        format.html # show.html.erb
        format.xml  { render :xml => @event }
      else
        format.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => "404 Not Found" }
        format.xml  { render :xml => @event.errors, :status => "404 Not found" }
      end
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end

  def participate
    if current_user.participates_in(Event.find(params[:id]))
      flash[:notice] = "参加登録が完了しました"
    else
      flash[:notice] = "参加登録できませんでした"
    end
    redirect_to :back
  end

  def cancel
    if current_user.cancels(Event.find(params[:id]))
      flash[:notice] = "参加をキャンセルしました"
    else
      flash[:notice] = "参加をキャンセルできませんでした"
    end
    redirect_to :back
  end
end
