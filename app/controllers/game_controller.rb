class GameController < ApplicationController

  def login
    if request.post?
      session[:player] = Player.find_or_create(params['name'])
      current_player.update_attributes(:active => true)
      redirect_to :action => :board
    end
  end
  
  def leave
    current_player.update_attributes(:active => false)
    send_cmd clear_player
    redirect_to root_path
  end    
  
  def board
    @map = Map.load('map1')
    send_cmd draw_player
  end
  
  def move
    send_cmd move_player params[:direction]
    render :nothing => true
  end
  
  private
  
  def move_player(direction)
    cmds = clear_player
    current_player.move(direction)
    cmds << draw_player
  end
  
  def draw_player
    "draw_player(#{current_player.data});"
  end
  
  def clear_player
    "clear_tile(#{current_player.x}, #{current_player.y});"
  end

  def send_cmd(cmd)
    Juggernaut.send_to_all cmd
  end
  
end