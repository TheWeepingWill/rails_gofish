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
    if @game.started_at
      if @game.go_fish.over?
        @game.update(finished_at: DateTime.current, winner_id: @game. go_fish.game_winner.user_id)
      end
    end
  end

  def index
    @games = Game.paginate(page: params[:page])
  end

  def update
    game = Game.find(params[:id])
    game.play_round(params[:Ranks], params[:Players])
    if game.go_fish.over?
      game.users.each do |user|
        partial = ApplicationController.render(partial: "games/game_over", locals: {game: game, current_user: user})
        ActionCable.server.broadcast("game_#{game.id}_#{user.id}", partial)
      end
    else
      game.users.each do |user|
        partial = ApplicationController.render(partial: "games/games_show", locals: {game: game, current_user: user})
        ActionCable.server.broadcast("game_#{game.id}_#{user.id}", partial)
      end
    end

    redirect_to game
  end

  private

  def game_params
    params.require(:game).permit(:name, :player_count)
  end
end