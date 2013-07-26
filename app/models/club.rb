class Club < ActiveRecord::Base
  belongs_to :user
  has_many :members, dependent: :destroy
  has_many :events, dependent: :destroy
  
  validates_presence_of :user, :name
  
  attr_accessible :name, :description
  

  
end
