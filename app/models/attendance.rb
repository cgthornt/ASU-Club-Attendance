class Attendance < ActiveRecord::Base
  belongs_to :event
  belongs_to :member
  validates_presence_of :signed_in_at
  validates_uniqueness_of :member_id, :scope => :event_id
end
