class Map
  
  def self.load(name)
    self.new(File.readlines(File.join(RAILS_ROOT, 'app', 'maps', name + '.map')).map{|text| text.chop})
  end
  
  def initialize(map_data)
    @data = map_data.map{ |row| row.split(//)}
  end
  
  def tile_list
    tiles = []
    @data.each_with_index do |col, c|
      col.each_with_index do |tile, r|
        tiles << [r, c, tile]
      end
    end
    tiles
  end
  
  def solid_tile?(x, y)
    %w{| - +}.include? @data[y][x]
  end
  
end