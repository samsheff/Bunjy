class UsersDefaults < ActiveRecord::Migration
  def change
    change_column :users, :balance, :decimal, :default => 0.0
    change_column :users, :active, :boolean, :default => true
  end
end
