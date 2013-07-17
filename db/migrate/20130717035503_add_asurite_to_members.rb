class AddAsuriteToMembers < ActiveRecord::Migration
  def change
    add_column :members, :asurite, :string
  end
end
