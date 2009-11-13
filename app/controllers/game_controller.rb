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
    clear_player
    redirect_to root_path
  end    
  
  def board
    @map = Map.load('map1')
    draw_player
  end
  
  def move
    clear_player
    current_player.move(params[:direction])
    draw_player
    render :nothing => true
  end
  
  private
  
  def move_player
    Juggernaut.send_to_all "draw_player(#{current_player.data})"
  end
  
  def clear_player
    Juggernaut.send_to_all "clear_tile(#{current_player.x}, #{current_player.y})"
  end
  
end