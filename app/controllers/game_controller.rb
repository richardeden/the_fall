class GameController < ApplicationController

  def login
    if request.post?
      session[:player_id] = Player.find_or_create(params['name']).id
      current_player.update_attributes(:active => true)
      current_player.update_attributes(:health => 100) if current_player.dead?
      if current_player.avatar.nil?
        redirect_to :action => :create_character
      else
        redirect_to :action => :board
      end
    end
  end
  
  def leave
    current_player.update_attributes(:active => false)
    send_cmd "remove_player(#{current_player.id})"
    redirect_to root_path
  end    
  
  def board
    @map = Map.load('map1')
    send_cmd draw_player
  end
  
  def move
    move_player params[:direction] unless current_player.dead?
    render :nothing => true
  end
  

  def create_character
    if request.post?
      if current_player.update_attributes(:avatar => params['avatar']) 
        redirect_to :action => :board
      else
        flash[:error] = "Character could not be created."
        redirect_to :action => create_character
      end
    end
  end

  def attack
    attack_location = current_player.pre_move(params[:direction])
    victim = Player.at(*attack_location)
    unless victim.nil?
      victim.health -= current_player.strength
      if victim.dead?
        victim.active = false
        send_cmd player_dead(victim)
      else
        send_cmd draw_player(victim)
      end
      victim.save
    end
    render :nothing => true
  end
  
  private
  
  def move_player(direction)
    new_location = current_player.pre_move(direction)
    return if Map.load('map1').solid_tile?(*new_location) || Player.in?(*new_location)
    current_player.move(direction)
    send_cmd draw_player
  end
  
  def draw_player(player=current_player)
    "draw_player(#{player.data});"
  end
  
  def player_dead(player)
    "player_dead(#{player.id});"
  end

  def send_cmd(cmd)
    Juggernaut.send_to_all cmd
  end
  
end