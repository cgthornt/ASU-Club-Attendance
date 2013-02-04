# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

roles = [
  [:site_admin, "Site Administrator", "The Site Administrator can access anything"],
  [:club_admin, "Club Administrator", "The club admin can create multiple sites"],
]

roles.each do |role|
  role_model = Role.new do |r|
    r.system_name = role[0]
    r.name        = role[1]
    r.description = role[2]
  end
  role_model.save!
end

admin = User.new do |u|
  u.email    = "cgthornt@asu.edu"
  u.password = "password2"
  u.first_name = "Christopher"
  u.last_name  = "Thornton"
  u.role_id    = Role.select('id').where(:system_name => :site_admin).first.id
end
admin.save!

