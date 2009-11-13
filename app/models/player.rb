class Player < ActiveRecord::Base
  named_scope :active, :conditions => {:active => true}
  
  def self.find_or_create(name)
    find_by_name(name) || create(:name => name, :x => 2, :y => 2)
  end
  
  def data
    "#{x}, #{y}, '#{avatar}'"
  end
  
  def move(direction)
    case direction
    when 'north' : self.y -= 1
    when 'south' : self.y += 1
    when 'east' : self.x += 1
    when 'west' : self.x -= 1
    end
    self.save
  end
end