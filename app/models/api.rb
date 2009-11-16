class Api
  class << self
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
    
    def player_dead(player,a)
      command('player_dead', player.id) + 
      activity("<b>#{a.name} killed #{player.name}</b>")
    end

    def command(cmd, data)
      [{:command => cmd, :data => data}]
    end
  end
end
