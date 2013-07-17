class MembersController < ApplicationController
  before_filter :ensure_club_selected, :default_breadcrumbs, :add_curr_club_crumb
  
  
  def index
    @members = current_club.members.
        with_statistics(current_club.events.count).top
    return export_members(@members) if params[:export]
  end
end
