class AddOmniauthFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :omniauth_type, :string
    add_index :users, [:email, :omniauth_type]
  end
end
