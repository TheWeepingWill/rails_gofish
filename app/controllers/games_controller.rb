class GamesController < ApplicationController
  def new
    @game = Game.new 
  end

  def create
    @game = Game.new(game_params)
    if @game.save 
      @game.users << current_user
      redirect_to play_game_url(@game)
    else 
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  def index
    @games = Game.paginate(page: params[:page])
  end

  def update
    @game = Game.find(params[:id])
    @game.play_round(params[:Ranks], params[:Players])
  end

  private

  def game_params
    params.require(:game).permit(:name, :player_count)
  end
end