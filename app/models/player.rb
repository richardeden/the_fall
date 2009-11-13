class Player < ActiveRecord::Base
  named_scope :active, :conditions => {:active => true}
  named_scope :at_location, lambda {|x, y| {:conditions => {:x => x, :y => y}}}
  
  def self.find_or_create(name)
    find_by_name(name) || create(:name => name, :x => 2, :y => 2)
  end
  
  def self.in?(x, y)
    active.any?{|player| player.in?(x,y)}
  end
  
  def self.at(x, y)
    active.at_location(x, y).first
  end
  
  def data
    to_json
  end
  
  def pre_move(direction)
    x, y = self.x, self.y
    case direction
    when 'north' : y -= 1
    when 'south' : y += 1
    when 'east' : x += 1
    when 'west' : x -= 1
    end
    [x, y]
  end
  
  def move(direction)
    self.x, self.y = pre_move(direction)
    self.save
  end
  
  def in?(x, y)
    self.x == x && self.y == y
  end
  
  def dead?
    health <= 0
  end
end