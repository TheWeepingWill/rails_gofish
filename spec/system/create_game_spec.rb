require 'rails_helper'

RSpec.describe 'Log In', type: :system do 
  let!(:user) { User.create!(name:  "Will", email: "will@gmail.com", password: "password") }

  it 'creates a game' do 
    player_count = 2
    setup_and_click_create_game
    fill_in 'Player count', with: player_count.to_s
  
    click_on 'Create' 
  
    expect(page).to have_content "waiting for #{player_count - GameUser.count} players..." 
  end
  
  
  
  #Helper methods and classes
  def setup_and_click_create_game
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log In'
    click_on 'Create Game'
  end
end