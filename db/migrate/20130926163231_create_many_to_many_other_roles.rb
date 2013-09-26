class CreateManyToManyOtherRoles < ActiveRecord::Migration
  def change
    create_table :clubs_users do |t|
      t.references :club
      t.references :user
      t.string :role
      t.index :club_id
      t.index :user_id
    end
  end
end
