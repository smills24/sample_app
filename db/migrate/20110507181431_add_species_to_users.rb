class AddSpeciesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :species, :string
  end

  def self.down
    remove_column :users, :species
  end
end
