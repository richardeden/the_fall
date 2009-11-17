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

end
