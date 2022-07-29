class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_#{params[:id]}_#{params[:user_id]}"
    puts "game_#{params[:id]}_#{params[:user_id]}"
  end
end