class CreateMeetups < ActiveRecord::Migration
  def change

    create_table :meetups do |table|
      table.string :title, null: false
      table.string :description, null: false
      table.string :location, null: false
      table.belongs_to :user, null: false

      table.timestamps null: false
    end
  end
end
