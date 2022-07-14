require 'rails_helper'
RSpec.describe 'GoFish' do 
  let!(:game) { GoFish.new }
  let(:players) { [Player.new(name: 'William'), Player.new(name:'Josh')] }

  describe '#initialize' do 
    it 'creates an object without paramaters' do 
      expect(game.players).to eq []
      expect(game.deck.deck_count).to eq 52 
    end
  end 

  describe '#add_player' do 
    it 'adds a player to the games players' do 
      player = Player.new(name: 'Sydney')
      game.add_player(player)
      expect(game.players).to eq [player]
    end
  end

  describe '#all_players_names_but_current' do 
    it 'lists all the players but the current one' do 
      game1 = GoFish.new(players: [Player.new(name: 'Sydney'), Player.new(name: 'Cross'), Player.new(name: 'Traver')])
      expect(game1.all_player_names_but_current).not_to include(game1.current_player.name)
    end
  end

  describe '#play_round' do 
    it 'does not get a match from player or fishing' do 
      setup_rigged_game(players: players, deck: [Card.new('2', 'Spades')], hands: [[Card.new('Ace', 'Hearts')], [Card.new('3', 'Hearts')]])
      game.play_round('Ace' , players[1])
      expect(game.round).to be 1
      expect(players[0].hand).to eq [Card.new('Ace', 'Hearts'), Card.new('2', 'Spades')]
      expect(players[1].hand).to eq [Card.new('3', 'Hearts')]
      expect(game.history[0].requesting_player_message).to eq ["Josh did not have any Aces","You went fishing and got the 2 of Spades!","Turn is over","It's Josh's turn"]  
      expect(game.history[0].target_player_message).to eq ["William asked you for Aces","William went fish!","William's turn is over","It's Your turn"  ]  
    end

    it 'gets a match from fishing' do 
      setup_rigged_game(players: players, deck: [Card.new('Ace', 'Spades')], hands: [[Card.new('Ace', 'Hearts')], [Card.new('2', 'Spades')]])
      game.play_round('Ace' , players[1])
      expect(players[0].hand).to eq [Card.new('Ace', 'Spades'), Card.new('Ace', 'Hearts')]
      expect(players[1].hand).to eq [Card.new('2', 'Spades')]
      expect(game.history[0].requesting_player_message).to eq ["Josh did not have any Aces","You went fishing and got the Ace of Spades!", "Go Again!"]  
      expect(game.history[0].target_player_message).to eq ["William asked you for Aces","William went fish!","William got a Ace","It's William's turn"]  
      
    end
    
    it 'gets a match from the player' do 
      setup_rigged_game(players: players, deck: [Card.new('2', 'Spades')], hands: [[Card.new('Ace', 'Hearts')], [Card.new('Ace', 'Spades')]])
      game.play_round('Ace' , players[1])
      expect(game.deck.cards).to eq [Card.new('2', 'Spades')]
      expect(players[0].hand).to eq [Card.new('Ace', 'Spades'), Card.new('Ace', 'Hearts')]
    end

    it 'creates a book' do 
      setup_rigged_game(players: players, hands: [[Card.new('Ace', 'Hearts'), Card.new('Ace', 'Clubs'), Card.new('Ace', 'Diamonds'), Card.new('2', 'Spades')], [Card.new('Ace', 'Spades')]])
      game.play_round('Ace' , players[1])
      expect(players[0].hand).to eq [Card.new('2', 'Spades')]
      expect(players[0].books).to eq ['Aces']
    end
  end

  it 'declares a winner' do 
    player1_books = %w( Kings Queens Jacks 10s 9s 8s 7s 6s 5s 4s 3s 2s)
    player2_books = %w( Aces )
    setup_rigged_game(players: players, books: [[player1_books], [player2_books]])
    expect(game.game_winner). to eq players[0]
    expect(game.over?).to be true
  end

  it 'does not go again if it gets a match from go fish' do 
    setup_rigged_game(players: players, hands: [[Card.new('Ace', 'Hearts')], [Card.new('3', 'Spades')]], deck: [ Card.new('Ace', 'Diamonds'), Card.new('Ace', 'Spades')])
    game.play_round('Ace' , players[1])
    expect(game.deck.cards).to eq [Card.new('Ace', 'Spades')]
  end


  it 'completes a game' do 
    setup_rigged_game(players: players) 
    expect { play_game }.not_to raise_error
  end

# Helper Methods and Classes
  def setup_rigged_game(players: [], hands: [[],[]], books: [[],[]], deck: [])
    game.players = players
    game.players.each_with_index do |player, i|
      player.hand = hands[i]
      player.books = books[i]
    end
    game.deck.cards = deck
    game
  end

  def play_game 
    rigged_game = setup_rigged_game(players: players, deck: Deck.new.cards)
    rigged_game.start 
    until rigged_game.over?
      rigged_game.play_round(rigged_game.current_player.hand.sample.rank, rigged_game.players.find { |player| player.name != rigged_game.current_player.name})
    end
  end
end