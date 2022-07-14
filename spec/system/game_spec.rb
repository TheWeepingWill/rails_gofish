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
      game
      login(user2)
      click_on 'Join Game' 
      expect(page).to have_content "Game has started" 
      end
    end

    describe 'game plays rounds' do 
      it 'can play a round' do 
        game
        login(user2)
        click_on 'Join Game' 
        expect(page).to have_content "Game has started" 
        expect(page).to have_content "It's Will's Turn"
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