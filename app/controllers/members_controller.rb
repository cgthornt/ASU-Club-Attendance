class MembersController < ApplicationController
  before_filter :ensure_club_selected, :default_breadcrumbs, :add_curr_club_crumb
  
  
  def index
    @members = current_club.members.
        with_statistics(current_club.events.count).
        with_first_and_last_seen


    # Get beginning of fall and spring semesters
    today           = Date.today
    spring_semester = today.beginning_of_year
    fall_semester   = spring_semester + 6.months
    end_of_year     = today.end_of_year

    # Whether today is the fall or spring semester!
    is_spring       = today < fall_semester
    is_fall         = !is_spring


    # Date Start
    # Default Condition
    if !params[:date_start]
      # If it is the spring semester, use the beginning of the year as our default start date
      @date_start = is_spring ?  spring_semester : fall_semester

    # Manually Specified Date
    elsif !params[:date_start].blank?
      @date_start = Date.parse params[:date_start]
    end

    # Date stop
    # Default Condition
    if !params[:date_stop]
      @date_stop = is_spring ? fall_semester : end_of_year
    elsif !params[:date_stop].blank?
      @date_stop = Date.parse params[:date_stop]
    end

    @members = @members.where('attendances.signed_in_at >= ?', @date_start) unless @date_start.blank?
    @members = @members.where('attendances.signed_in_at <= ?', @date_stop)  unless @date_stop.blank?

    @grid = initialize_grid @members, order: 'id', custom_order: { 'id' => 'attendance_count'}
    return export_members(@members) if params[:export]
  end
end
