require_relative 'game'
class RoundResult
  attr_reader  :target_player_name, :rank 
  attr_accessor :went_fishing, :got_match, :current_player, :book_completed, :resulting_cards, :requesting_player_message 
  attr_accessor :target_player_message, :all_besides_requesting_player_message, :requesting_player_name
  
    def initialize(requesting_player_name:, target_player_name:, rank:)
      @requesting_player_name = requesting_player_name
      @target_player_name = target_player_name
      @rank = rank
      @resulting_cards = []
      @went_fishing = false
      @got_match = false
      @book_completed = false
      @current_player = []

      @requesting_player_message = []
      @target_player_message = []
      @all_besides_requesting_player_message = []
    end
  
    def no_match
      if went_fishing && !got_match 
        @requesting_player_message = ["#{target_player_name} did not have any #{rank}s", "You went fishing and got the #{resulting_cards}!", "Turn is over", "It's #{current_player}'s turn"]  
        @target_player_message = ["#{requesting_player_name} asked you for #{rank}s", "#{requesting_player_name} went fish!", "#{requesting_player_name}'s turn is over", "It's #{conditional_turn_output} turn"] 
      end
    end
  
    def match_from_fishing 
      if went_fishing && got_match 
        @requesting_player_message = ["#{target_player_name} did not have any #{rank}s", "You went fishing and got the #{resulting_cards}!", "Go Again!"]  
        @target_player_message = ["#{requesting_player_name} asked you for #{rank}s", "#{requesting_player_name} went fish!", "#{requesting_player_name} got a #{rank}", "It's #{current_player}'s turn"] 
      end
    end
  
    def match_from_request
      if !went_fishing && got_match 
        @requesting_player_message = ["#{target_player_name} had #{rank}s", "Go Again!"]  
        @target_player_message = ["#{requesting_player_name} took your #{rank}s", "It's #{requesting_player_name}'s turn"] 
      end
    end

    def conditional_turn_output
     current_player == target_player_name ? 'Your' : "#{current_player}'s"
    end

    def no_cards_in_deck 
       if went_fishing && resulting_cards == []
        @requesting_player_message = ["There are no cards left in the deck", "Turn Over"]
       end
    end
    
  end