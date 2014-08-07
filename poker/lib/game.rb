require 'player.rb'
require 'deck.rb'

class Game

  def initialize(min_bid, *players)
    @deck = Deck.new
    @players = players[0..3]
    @min_bid = min_bid
  end

  def run
    until game_over?
      active_players = capable_players.map{|player| player.new_game(@deck.deal(5), @min_bid)}

      previously_active_players_number = active_players.size
      active_players_number = 1.0/0.0
      # until previously_active_players_number == active_players_number
      #   active_players.each(&:play)

      #   active_players.reject!{|player| player.pot < @min_bid || !player.playing?}
      #   active_players_number = active_players.size
      # end
    end

    winner
  end

  def capable_players
    @players.select{|player| player.pot > @min_bid}
  end

  def game_over?
    capable_players.size == 1
  end

  def winner
    @players.max{|a, b| a.pot <=> b.pot}
  end

end