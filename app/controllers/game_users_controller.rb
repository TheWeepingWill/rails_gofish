class GameUsersController < ApplicationController
  def create
    game = Game.find(params[:id])
    game.users << current_user
    game.start!
    redirect_to play_game_url(params[:id])
  end
end