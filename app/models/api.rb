class Api
  class << self
    def map(map)
      command('map', map.data)
    end

    def new_player(player)
      draw_player(player) +
      activity("#{player.name} joined the game")
    end

    def attack(victim, player)
      draw_player(victim) +
      activity("#{player.name} attacked #{victim.name}")
    end
    
    def leave(player)
      command('remove_player', player.id) +
      activity("#{player.name} left the game")
    end

    def activity(text)
      command('activity', text)
    end

    def move_player(player, direction)
      new_location = player.pre_move(direction)
      return if Map.load('map1').solid_tile?(*new_location) || Player.in?(*new_location)
      player.move(direction)
      draw_player(player)
    end
    
    def draw_player(player)
      command('draw_player', player.data)
    end
    
    def you_are(player)
      command('you_are', data_hash(player, :name, :avatar, :id))
    end
    
    def player_dead(player,a)
      command('player_dead', player.id) + 
      activity("<b>#{a.name} killed #{player.name}</b>")
    end

    def player_list(players)
      data = players.map{|p| {:name => p.name, :avatar => p.avatar} }
      command('player_list', data)
    end
    
    def incorrect_password
      command('incorrect_password', nil)
    end

    def command(cmd, data)
      [{:command => cmd, :data => data}]
    end

    def data_hash(obj, *attrs)
      attrs.inject({}) do |h, attr|
        h[attr] = obj.send(attr)
        h
      end
    end
  end
end
