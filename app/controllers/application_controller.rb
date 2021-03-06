class ApplicationController < ActionController::Base
  protect_from_forgery
  load_and_authorize_resource :unless => :devise_controller?
  before_filter :load_current_club


  before_filter :configure_devise_permitted_parameters, if: :devise_controller?

  protected

  def configure_devise_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :first_name, :last_name) }
  end

  protected

  def export_members(members)
    data = members.export_format_scope
    send_data data, filename: 'members.txt', type: 'text/plain'
  end

  def load_current_club
    @curr_club = current_club
  end
  
  # Gets the current club
  def current_club
    begin
      return @curr_club unless @curr_club.blank?
      @curr_club = session[:club_id].blank? ? nil : Club.find(session[:club_id])
      return @curr_club
    rescue Exception
      return nil
    end
  end
  
  def ensure_club_selected
    if current_club.blank?
      flash[:notice] = "Please Select a Club"
      redirect_to clubs_path
    end
  end
  
  def default_breadcrumbs
    # add_breadcrumb "Home", :root_path
    add_breadcrumb "Clubs", :clubs_path
  end
  
  def add_curr_club_crumb
    unless current_club.blank?
      add_breadcrumb current_club.name, url_for(current_club)
    end
  end
end
