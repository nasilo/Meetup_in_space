class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups do |table|
      table.belongs_to :user, null: false
      table.belongs_to :meetup, null: false

      table.timestamps null: false
    end
  end
end
