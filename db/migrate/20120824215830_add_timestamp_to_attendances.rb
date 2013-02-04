class AddTimestampToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :signed_in_at, :datetime
    add_column :attendances, :first_event, :boolean, :default => true
    add_index :attendances, [:member_id, :first_event]
  end
end
