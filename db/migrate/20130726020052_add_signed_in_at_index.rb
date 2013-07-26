class AddSignedInAtIndex < ActiveRecord::Migration
  def change
    add_index :attendances, [:member_id, :signed_in_at]
  end
end
