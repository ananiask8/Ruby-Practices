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
      @players.each{|player| player.new_game(@deck.hand, @min_bid)}
      active_players = @players

      previously_active_players_number = active_players.size
      until previously_active_players_number == active_players_number
        active_players.each(&:play)

        active_players.reject!{|player| player.pot < @min_bid || !player.playing?}
        active_players_number = active_players.size
      end
    end

    winner
  end

  def game_over?
    @players.reject{|player| player.pot < @min_bid}.size == 1
  end

  def winner
    @players.max{|a, b| a.pot <=> b.pot}
  end

end