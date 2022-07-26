require 'rails_helper'

RSpec.describe 'Game', type: :system do 
  let!(:user1) { User.create!(name:  "Will", email: "will@gmail.com", password: "password") }
  let!(:user2) { User.create!(name:  "Josh", email: "josh@gmail.com", password: "password") }
  let(:game) { create(:game, users: [create(:user)]) }
  
  describe 'Create Game' do   
    it 'creates a game' do 
      player_count = 2
      login(user1)
      
      click_on 'Create Game'
      fill_in 'Player count', with: player_count.to_s
      fill_in 'Name', with: 'Game'
      click_on 'Create' 
      
      game = Game.last
      expect(page).to have_content "Waiting for #{player_count - game.users.count} player..." 
    end
  end
  
  describe 'Join Game' do 
    it 'joins a game' do
      player_count = 3
      game = create(:game, users: [create(:user)], player_count: player_count)
      login(user2)
      click_on 'Join Game' 
      expect(page).to have_content "Waiting for #{player_count - game.users.count} player..." 
    end
  end
  
  describe 'start game' do 
    it 'displays correctly' do 
      game
      login(user2)
      click_on 'Join Game' 
      expect(page).to have_content "It is Will's turn"
    end
  end
  
  describe 'play round' do 
    it 'displays the round correct' do 
      ready_game = create(:game, :started, users: [user1, user2], name: 'game1')
      login(user1)
      ready_game.start!
      expect(ready_game.go_fish.history.count).to be 0
      visit play_game_path(ready_game.id)
      select "#{user2.name}", from: 'Players'
      select "#{ready_game.go_fish.current_player.hand_ranks.sample}", from: 'Ranks'
      click_on 'Ask'
      expect(Game.last.go_fish.history.count).to be 1
    end
  end
  
  
  #Helper methods and classes
  def login(user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log In'
  end
  
end