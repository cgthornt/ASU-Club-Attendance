class MembersController < ApplicationController
  before_filter :ensure_club_selected, :default_breadcrumbs, :add_curr_club_crumb
  
  
  def index
    @grid = autogrid Member.where(:club_id => @curr_club.id) do |g|
      g.col :email, :first_name, :last_name
      g.col 'attendances.count', :name => 'Attendance'
    end
  end
end
