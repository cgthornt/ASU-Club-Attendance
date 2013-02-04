class Club < ActiveRecord::Base
  belongs_to :user
  has_many :members
  has_many :events
  
  validates_presence_of :user, :name
  
  attr_accessible :name, :description
  

  
end
