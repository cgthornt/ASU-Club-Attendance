class CreateTables < ActiveRecord::Migration
  def change
    
    
    change_table :users do |t|
      t.string :first_name
      t.string :last_name
    end
    
    # Clubs
    create_table :clubs do |t|
      t.integer :user_id
      
      t.string  :name
      t.string  :description
      
      t.timestamps
    end
    
    add_index :clubs, :user_id
    
    # Meetings
    create_table :meetings do |t|
      t.integer :club_id
      
      t.string  :name
      t.string  :description
    
      t.datetime :meeting_start
      t.datetime :meeting_stop
      
      t.timestamps
    end
    
    add_index :meetings, :club_id
    
    # Members
    create_table :members do |t|
      t.integer :club_id
      t.string :email
      
      t.string :first_name
      t.string :last_name
      
      t.timestamps
    end
    
    add_index :members, :club_id
    add_index :members, [:club_id, :email]
    
    
    # Attendance
    create_table :attendances do |t|
      t.integer :meeting_id
      t.integer :member_id
    end
    
    add_index :attendances, [:meeting_id, :member_id]
    add_index :attendances, [:member_id, :meeting_id]
    
    

    
  end
end
