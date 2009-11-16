class GameController < ApplicationController
  
  def index
  end
  
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
    send_cmd Api.leave(current_player)
    redirect_to root_path
  end    
  
  def board
    @map = Map.load('map1')
    send_cmd Api.new_player(current_player)
  end
  
  def move
    render :nothing => true if current_player.dead?
    cmd = Api.move_player(current_player, params[:direction])
    send_cmd cmd
    render :json => cmd
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
        send_cmd Api.player_dead(victim, current_player)
      else
        send_cmd Api.attack(victim, current_player)
      end
      victim.save
    end
    render :nothing => true
  end
  
  private
  
  def send_cmd(cmds)
    Juggernaut.send_to_all cmds.to_json
  end
  
end
