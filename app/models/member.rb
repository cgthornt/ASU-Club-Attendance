class Member < ActiveRecord::Base
  belongs_to :club
  has_and_belongs_to_many :events, :join_table => 'attendances'
  has_many :attendances
  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email, :scope => :club_id
  
  
  attr_accessible :first_name, :last_name, :email
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  scope :top, joins(:attendances).group('attendances.member_id').order('count(attendances.id) DESC')
  scope :with_statistics, lambda{|event_count|
    select("members.*, COUNT(attendances.id) AS attendance_count, (COUNT(attendances.id)/#{event_count}) AS attendance_percent")
  }
  
  
end
