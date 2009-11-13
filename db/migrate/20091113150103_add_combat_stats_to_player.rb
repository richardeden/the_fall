class AddCombatStatsToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :health, :integer
    add_column :players, :strength, :integer
  end

  def self.down
    remove_column :players, :strength
    remove_column :players, :health
  end
end
