require 'rubygems'
require 'eventmachine'
require 'json'
require 'authlogic'

class Connection < EventMachine::Connection
  attr_accessor :server
  attr :current_player
  attr :current_user

  def receive_data data
    server.command self, data
  end

  def unbind
    server.disconnect(self)
    leave({}) unless current_player.nil?
  end

  def send_cmd(cmds)
    return if cmds.nil?
    send_data cmds.map{|c| c.to_json}.join("\0") + "\0"
  end


  def login(params)
    @current_user = User.find_by_username(params[:name])
    if current_user && authenticated?(current_user, params[:password])
      send_cmd Api.player_list(current_user.players)
    else
      unbind
    end
  end
  
  def authenticated?(user, password)
    p = Authlogic::CryptoProviders::Sha512.encrypt(password, user.password_salt)
    user.crypted_password == p
  end

  def join(params)
    return unless current_user
    @current_player = current_user.players.find_by_name(params[:name])
    return unless current_player
    current_player.update_attributes(:health => 100) if current_player.dead?
    cmds = Api.map(Map.load('map1'))
    current_player.update_attributes(:active => true)
    cmds += Api.you_are(current_player)
    Player.active.each do |p|
      cmds += Api.draw_player(p)
    end
    server.send_cmd Api.new_player(current_player), :except => self
    send_cmd cmds
  end

  def move(params)
    return unless current_player.active?
    server.send_cmd Api.move_player(current_player, params[:direction])
  end

  def attack(params)
    victim = current_player.attack(params[:direction])
    unless victim.nil?
      if victim.dead?
        server.send_cmd Api.player_dead(victim, current_player)
      else
        server.send_cmd Api.attack(victim, current_player)
      end
    end
  end
 
  def leave(params)
    current_player.update_attributes(:active => false)
    server.send_cmd Api.leave(current_player)
  end    
 
end