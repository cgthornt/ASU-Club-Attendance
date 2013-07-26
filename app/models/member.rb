class Member < ActiveRecord::Base
  belongs_to :club
  has_and_belongs_to_many :events, :join_table => 'attendances'
  has_many :attendances
  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email, :scope => :club_id
  
  
  attr_accessible :first_name, :last_name, :email, :asurite
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  scope :top, ->{ order('count(attendances.id) DESC') }

  def self.with_statistics(event_count)
    select("members.*, COUNT(attendances.id) AS attendance_count, (COUNT(attendances.id)/#{event_count}) AS attendance_percent").
    joins(:attendances).group('members.id')
  end

  scope :with_first_and_last_seen, ->{ select('MAX(attendances.signed_in_at) AS last_seen_at, MIN(attendances.signed_in_at) AS first_seen_at')}


  # Members within this semester
  def self.current_semester
    # Get beginning of fall and spring semesters
    today           = Date.today
    spring_semester = today.beginning_of_year
    fall_semester   = spring_semester + 6.months
    end_of_year     = today.end_of_year

    # Whether today is the fall or spring semester!
    is_spring       = today < fall_semester
    is_fall         = !is_spring

    # Now get start / stop times
    start = is_spring ?  spring_semester : fall_semester
    stop  = is_spring ? fall_semester : end_of_year

    # Finally, get the scope
    joins(:attendances).where(attendances: {signed_in_at: start..stop})
  end

  # Formats in an export format:
  #   example@example.com Joe Smith
  #
  # It can also work with listserv!
  def export_format
    return "#{email} #{full_name}"
  end

  def self.export_format_scope
    str = ""
    all.each{|m| str << m.export_format + "\n" }
    return str
  end
  
  
end
