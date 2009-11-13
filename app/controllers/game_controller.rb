class GameController < ApplicationController

  def login
    if request.post?
      session[:player_id] = Player.find_or_create(params['name']).id
      current_player.update_attributes(:active => true)
      redirect_to :action => :board
    end
  end
  
  def leave
    current_player.update_attributes(:active => false)
    send_cmd "remove_player(#{player.id})"
    redirect_to root_path
  end    
  
  def board
    @map = Map.load('map1')
    send_cmd draw_player
  end
  
  def move
    move_player params[:direction]
    render :nothing => true
  end
  
  private
  
  def move_player(direction)
    new_location = current_player.pre_move(direction)
    return if Map.load('map1').solid_tile?(*new_location) || Player.in?(*new_location)
    current_player.move(direction)
    send_cmd draw_player
  end
  
  def draw_player
    "draw_player(#{current_player.data});"
  end

  def send_cmd(cmd)
    Juggernaut.send_to_all cmd
  end
  
end