class EventsController < ApplicationController
  
  require 'nokogiri'
  require 'net/https'
  
  before_filter :ensure_club_selected, :default_breadcrumbs, :add_curr_club_crumb
  
  
  
  def index
    @events = Event.where(:club_id => @curr_club.id)
    @grid = autogrid @events do |g|
      g.col :name, :meeting_start, :meeting_stop
      g.col 'attendances.count', :name => 'Attendance'
    end
  end
  
  def new
    add_breadcrumb "Events", events_path
  end
  def show
    add_breadcrumb "Events", events_path
  end
  def edit
     add_breadcrumb "Events", events_path
     add_breadcrumb @event.name, url_for(@event)
  end
  def update
    if @event.update_attributes(params[:event])
      flash[:success] = "Event Updated!"
    end
    render :action => :edit
  end
  def create
    @event.club = @curr_club
    if @event.save
      flash[:success] = "Event has been created"
      return redirect_to @event
    end
    render :action => :new
  end
  

  
  
  def attendance
    @club = @event.club
    @member = Member.new do |m|
      m.club = @club
    end
    render :layout => 'attendance'
  end
  
  def submit_attendance
    @club = @event.club
    @member = @club.members.new(params[:member])
    first_event = true
    
    # User already exists
    if @club.members.where(:email => @member.email).any?
      @member = @club.members.where(:email => @member.email).first
      # Current logic implies a new member has not signed in
      first_event = false
    else
      unless @member.save
        return render :action => :attendance, :layout => 'attendance'
      end
    end
    
    # Already attended
    if @event.attendances.where(:member_id => @member.id).any?
      flash[:success] = "You've already signed in #{@member.first_name}"
    else
      attendance = @event.attendances.new do |a|
        a.member_id    = @member.id
        a.signed_in_at = DateTime.now
        a.first_event  = first_event
      end
      attendance.save!
      flash[:success] = "Thanks for signing in, #{@member.first_name}!"
    end
    
    
    
    return redirect_to :action => 'attendance', :id => @event.id
  end
  
  
  def user_lookup
   begin
      url = URI.parse("https://webapp4.asu.edu/directory/ws/search?asuriteId=" + CGI::escape(params[:asurite]))
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      result = http.get(url.path + "?" + url.query)
      xml = Nokogiri::XML(result.body)
      
      data = {
        :first_name => xml.xpath("//firstName[1]").text,
        :last_name  => xml.xpath("//lastName[1]").text,
        :email      => xml.xpath("//email[1]").text
      }
      
      success = !data[:email].blank?
      
      respond_to do |format|
        format.json { render :json => {:success => success, :data => data}}
      end
      
    rescue Exception
      respond_to do |format|
        format.json { render :json => {:success => false}}
      end
    end
  end
  
end
