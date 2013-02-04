class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.string :description
      t.string :system_name
    end
    
    add_index :roles, :system_name
    
    change_table :users do |t|
      t.integer :role_id
    end
    add_index :users, :role_id
  end
end
