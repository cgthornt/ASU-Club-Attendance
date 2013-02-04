class ClubsController < ApplicationController


  before_filter :default_breadcrumbs
  
  def index
    @grid= autogrid @clubs do |g|
      g.col :id, :name, "user.email"
    end
  end
  
  def new; end
  
  def create
    @club.user = current_user
    if @club.save
      flash[:success] = "Club has been created"
      return redirect_to clubs_path
    end
    render :action => 'new'
  end
  
  def show
    session[:club_id] = @club.id
  end
end
