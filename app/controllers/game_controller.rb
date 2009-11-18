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
  
  def board
  end

end
