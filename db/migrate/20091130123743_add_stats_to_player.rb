class AddStatsToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :intelligence, :integer
    add_column :players, :wisdom, :integer
    add_column :players, :dexterity, :integer
    add_column :players, :constitution, :integer
    add_column :players, :charisma, :integer
  end

  def self.down
    remove_column :players, :charisma
    remove_column :players, :constitution
    remove_column :players, :dexterity
    remove_column :players, :wisdom
    remove_column :players, :intelligence
  end
end
