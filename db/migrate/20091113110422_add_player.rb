class AddPlayer < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :name
      t.integer :x, :y
      t.string :avatar
      t.boolean :active
    end
  end

  def self.down
    drop_table :players
  end
end
