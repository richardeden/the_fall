class Player < ActiveRecord::Base
  named_scope :active, :conditions => {:active => true}
  
  def self.find_or_create(name)
    find_by_name(name) || create(:name => name, :x => 2, :y => 2)
  end
  
  def self.in?(x, y)
    active.any?{|player| player.in?(x,y)}
  end
  
  def data
    "#{id}, #{x}, #{y}, '#{avatar}'"
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
end