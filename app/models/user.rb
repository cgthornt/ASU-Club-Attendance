class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :omniauth_providers => [:google_oauth2]



  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  # attr_accessible :title, :body
  
  validates_presence_of :first_name, :last_name
  
  belongs_to :role
  has_many :clubs
  
  MAX_CLUB_COUNT = 5
  
  # Can create a club if less than 5
  def can_create_club?
    clubs.count <= MAX_CLUB_COUNT
  end
  
  # Gets the ful name of the user in the format of "FirstName LastName"
  def full_name
    "#{first_name} #{last_name}"
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"], omniauth_type: 'google_oauth2').first

    unless user
      user = User.new(email: data["email"], password: Devise.friendly_token[0,20])
      user.omniauth_type = 'google_oauth2'
      user.first_name = data['first_name']
      user.last_name  = data['last_name']
      user.save!
    end
    user
  end


  def self.find_for_authentication(tainted_conditions)
    find_first_by_auth_conditions(tainted_conditions, omniauth_type: nil)
  end


end
