class EventsController < ApplicationController
  
  require 'nokogiri'
  require 'net/https'
  
  before_filter :ensure_club_selected, :default_breadcrumbs, :add_curr_club_crumb
  
  
  
  def index
    @events = Event.select('events.*, COUNT(event_id) AS attendance_count').
        where(:club_id => @curr_club.id).joins(:attendances).group('event_id')
    @grid = initialize_grid @events, order: 'events.meeting_start', order_direction: 'ASC',
        custom_order: { 'attendances.id' => 'attendance_count'}
  end
  
  def new
    add_breadcrumb "Events", events_path
  end
  def show
    add_breadcrumb "Events", events_path
    if ex = params[:export]
      s = @event.new_members      if ex == 'new'
      s = @event.existing_members if ex == 'existing'
      s = @event.members          if ex == 'all'
      return export_members(s) if s
    end
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
      flash[:success] = "You've already signed in, #{@member.first_name}!"
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
    data = nil
    success = false

    # Lookup existing email - save time!
    lookup = current_club.members.where('asurite = :p OR email = :p', p: params[:asurite]).first
    unless lookup.nil?
      success = true
      data    = {
          first_name: lookup.first_name,
          last_name:  lookup.last_name,
          email:      lookup.email,
          asurite:    lookup.asurite
      }
    end

    begin
      if data.nil?
        url = URI.parse("https://webapp4.asu.edu/directory/ws/search?asuriteId=" + CGI::escape(params[:asurite]))
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        result = http.get(url.path + "?" + url.query)
        xml = Nokogiri::XML(result.body)

        data = {
          :first_name => xml.xpath("//firstName[1]").text,
          :last_name  => xml.xpath("//lastName[1]").text,
          :email      => xml.xpath("//email[1]").text,
          :asurite    => xml.xpath("//asuriteId[1]").text
        }

        success = !data[:email].blank?
      end

    rescue Exception
      respond_to do |format|
        format.json { render :json => {:success => false}}
      end
    end

    respond_to do |format|
      format.json { render :json => {:success => success, :data => data}}
    end
  end
  
end
