require 'rails_helper'

RSpec.describe 'Log In', type: :system do 
  let!(:user) { User.create!(name:  "Will", email: "will@gmail.com", password: "password") }

  fit 'creates a game', :chrome do 
    player_count = 2
    login

    click_on 'Create Game'
    fill_in 'Player count', with: player_count.to_s
    fill_in 'Name', with: 'Game'
    click_on 'Create' 
  
    game = Game.last
    expect(page).to have_content "waiting for #{player_count - game.users.count} players..." 
  end
  
  
  
  #Helper methods and classes
  def login
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log In'
  end
end