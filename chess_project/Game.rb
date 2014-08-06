# encoding: utf-8
# require 'rubygems'
require 'colorize'
require 'active_support/all'
require './Piece.rb'
require './Pawn.rb'
require './SliddingPiece.rb'
require './SteppingPiece.rb'
require './Player.rb'
require './Board.rb'

# Still left to implement: Saving capability, Pawns turning to other pieces as they reach
# the opposite end of the Board, selecting the pieces with the arrows/mouse (js) and AI.
# Also add max qty of steps while in check to declare a draw.

class Game
  N = 8
  COMMAND_REGEXP = /^([a-h])(\d)$/i
  # SAVE = "s"

  class << self
    def setup
      @@codes = self.horizontal_keys.merge self.vertical_keys
    end

    def horizontal_keys
      map_each_to_index(("a".."h"))
    end

    def vertical_keys
      map_each_to_index(("1".."#{N}").to_a.reverse)
    end

    def map_each_to_index(array)
      hash = {}
      array.each_with_index{|key, value| hash[key] = value}
      hash
    end
  end

  def initialize(player1, player2)
    @board = Board.new(true)
    if player1.class != HumanPlayer
      player1, player2 = player2, player1
    end
    player1.color = :white
    player2.color = :black
    @players = [player1, player2]
  end

  def play
    loop do
      @players.each do |player|
        break if game_over?
        begin
          @board.draw
          move = prompt_move(player)
          @board.move(move[0], move[1])
        rescue
          @board.draw
          puts "Please make a valid move"
          retry
        end
      end
      break if game_over?
    end
    results
  end

  def prompt_move(player)
    puts "Select a piece to move #{player.name}:"
    start_code = player.play_turn.scan(COMMAND_REGEXP).flatten
    raise "Invalid sintax" if invalid_sintax?(start_code)
    start = [@@codes[start_code[1]], @@codes[start_code[0]]]
    raise "Select your pieces only" if @board[start].color != player.color

    @board.light_possible_moves(start)

    puts "Select destination:"
    print "-> "
    end_pos_code = player.play_turn.scan(COMMAND_REGEXP).flatten
    raise "Invalid sintax" if invalid_sintax?(end_pos_code)
    end_pos = [@@codes[end_pos_code[1]], @@codes[end_pos_code[0]]]

    [start, end_pos]
  end

  def invalid_sintax?(move_code)
    move_code.length != 2 || !move_code.all?{|element| @@codes[element]}
  end

  def game_over?
    winner? || @board.draw?
  end

  def winner?
    @board.checkmate?(:white) || @board.checkmate?(:black)
  end

  def results
    @board.draw
    return puts "Its a draw..." unless winner?
    if @board.checkmate?(:white)
      winner = @players[0].color == :black ? @players[0] : @players[1]
    else
      winner = @players[0].color == :white ? @players[0] : @players[1]
    end
    puts "The winner is #{winner.name}"
  end
end

Game.setup
game = Game.new(HumanPlayer.new, HumanPlayer.new)
game.play
