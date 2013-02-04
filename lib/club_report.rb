class ClubReport
  include Datagrid

  scope do
    Club.select('COUNT(members.*) AS num_members, club.name, users.email').
      joins(:members, :user)
  end

  filter(:club_id)
  
  column :id
  column :member_count 
  

end
