class ClubsController < ApplicationController


  before_filter :default_breadcrumbs
  
  def index
    @grid = initialize_grid @clubs.includes(:user)
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


  def destroy
    if @club.destroy
      session.delete :club_id
      flash[:success] = 'Club has been purged from database!'
      redirect_to :root
    else
      flash[:error] = 'Unable to delete club!'
      render action: :show
    end
  end
end
