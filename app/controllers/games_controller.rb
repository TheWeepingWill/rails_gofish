class GamesController < ApplicationController
  def new
    @game = Game.new 
  end

  def create
    @game = Game.new(game_params)
    if @game.save 
      redirect_to  game_play_url 
    else 
      render 'new', stats: unprocessable_entity
    end
  end

  private

  def game_params
    params.require(:game).permit(:names, :player_count)
  end
end