class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

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
end
