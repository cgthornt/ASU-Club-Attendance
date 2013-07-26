class Event < ActiveRecord::Base
  belongs_to :club
  has_and_belongs_to_many :members, :join_table => 'attendances'
  has_many :attendances, dependent: :destroy
  scope :upcoming, where('DATE(meeting_stop) >= ?', Date.today)
  
  validates_presence_of :club, :name, :meeting_start, :meeting_stop
  attr_accessible :name, :description, :meeting_start, :meeting_stop
  
  def new_members
    Member.joins(:attendances).where("attendances.event_id = ? AND attendances.first_event = ?", id, true)
  end
  
  def existing_members
    Member.joins(:attendances).where("attendances.event_id = ? AND attendances.first_event = ?", id, false)
  end
  
end
