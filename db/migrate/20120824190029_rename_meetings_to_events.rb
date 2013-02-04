class RenameMeetingsToEvents < ActiveRecord::Migration
  def change
    rename_table :meetings, :events
    rename_column :attendances, :meeting_id, :event_id
  end

end
