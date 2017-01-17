class AddIndexToSignups < ActiveRecord::Migration
  def change
    add_index :signups, [:user_id, :meetup_id], unique: true 
  end
end
