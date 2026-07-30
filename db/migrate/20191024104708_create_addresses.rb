# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.references :user
      t.string :street
      t.string :city
      t.string :zip

      t.timestamps
    end
  end
end
