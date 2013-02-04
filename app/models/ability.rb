class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    
    @user = user
    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    unless user.blank?
      
      # Update role
      if user.role.blank?
        user.role = Role.where(:system_name => "club_admin").first
        user.save!
      end
      
      m = "can_" + user.role.system_name
      send(m) if respond_to?(m)
    end
  end
  
  
  # Manage clubs
  def can_club_admin
    can :manage, Club, :user_id => user.id
    can :create, Club if user.can_create_club?
    can :create, Event
    can :manage, Event, :club => {:user => {:id => user.id}}
    can :manage, Member, :club => {:user => {:id => user.id}}
  end
  
  # Site admin can do anything
  def can_site_admin
    can :manage, :all
  end

end
