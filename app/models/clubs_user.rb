# ClubsUser
# @author Christopher Thornton <cthornton@flexwage.com>
class ClubsUser < ActiveRecord::Base
  has_paper_trail
  belongs_to :club
  belongs_to :user

  validates_presence_of :club, :user

  validates_uniqueness_of :user, scope: :club

  # Allows linking of email and such
  attr_accessor :email


  attr_accessible :club, :email



end