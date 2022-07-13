class GamesController < ApplicationController
  def new
    @game = Game.new 
  end

  def create
    @game = Game.new(game_params)
    if @game.save 
      redirect_to play_game_url(@game)
    else 
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    binding.pry
    @game = Game.find(params[:id])
  end

  private

  def game_params
    params.require(:game).permit(:name, :player_count)
  end
end