class Role < ActiveRecord::Base
  has_many :users
  
  validates_uniqueness_of :system_name
end
