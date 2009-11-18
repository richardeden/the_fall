class PlayersController < ApplicationController
  def new
    @player = Player.new
  end
  
  def create
    @player = Player.new(params[:player])
    if @player.save
      flash[:notice] = "Player successfully created."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
end