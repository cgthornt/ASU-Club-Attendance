class Club < ActiveRecord::Base
  has_paper_trail
  belongs_to :user
  has_many :members, dependent: :destroy
  has_many :events, dependent: :destroy

  attr_accessor :add_officer_email, :add_officer_role

  validates_presence_of :user, :name
  
  attr_accessible :name, :description, :add_officer_email, :clubs_users_attributes

  has_many :clubs_users, dependent: :delete_all

  accepts_nested_attributes_for :clubs_users, allow_destroy: true

  before_validation :add_new_officer


  def add_new_officer
    return if add_officer_email.blank?
    user = User.where(email: add_officer_email).first
    if user.blank?
      errors.add :add_officer_email, 'was not found. Make sure this user has signed in to the website.'
      return
    end

    if clubs_users.where(user_id: user.id).any?
      errors.add :add_officer_email, 'already exists  '
      return
    end

    clubs_users << ClubsUser.new do |u|
      u.user = user
      u.club = self
      u.role = 'admin' # TODO: don't hard code!
    end

  end
  
end
