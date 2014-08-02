# encoding: utf-8
require 'colorize'

class NilClass
  def color
    nil
  end

  def pos
    nil
  end

  def board
    nil
  end

  def is_a?(*args)
    nil
  end

  def moves
    nil
  end

  def dup(*args)
    nil
  end
end

class Piece
  MOVING_DIR = {:rook => [[0, 1], [1, 0], [0, -1], [-1, 0]],
                :bishop => [[1, 1], [1, -1], [-1, 1], [-1, -1]],
                :queen => [[0, 1], [1, 0], [0, -1], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]],
                :pawn => {:white => [[-1, 0], [-1, -1], [-1, 1]], :black => [[1, 0], [1, -1], [1, 1]]},
                :king => [[0, 1], [1, 0], [0, -1], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]],
                :knight => [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]]
                }
  PIECE_SYMBOL_COLOR = {:white => :white, :black => :red}
  # Track position
  # Hold a reference to board
  attr_accessor :pos
  attr_reader :color
  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
    @board[pos] = self unless @board[pos] == self
  end

  def moves
    result = []
    move_diffs.each do |differential|
      result += possible_moves(differential)
    end
    result
  end

  def possible_moves(differential)
    result = []
    new_pos = @pos.zip(differential).map{|a| a.inject(:+)}
    until constraint_met?(new_pos)
      unless @board.empty?(new_pos)
        result << new_pos if @board[new_pos].color != @color
        break
      end
      result << new_pos
      new_pos = new_pos.zip(differential).map{|a| a.inject(:+)}
    end
    result
  end

  def valid_moves
    moves.reject{|pos| move_into_check?(pos)}
  end

  def move_diffs
    class_name = self.class.to_s.downcase.to_sym
    MOVING_DIR[class_name]
  end

  def dup(board = nil)
    board ||= @board.dup
    self.class.new(@color, board, @pos)
  end

  def is_a?(piece_class, color)
    self.class == piece_class && @color == color
  end

  def move_into_check?(pos)
    duplicate_board = @board.dup
    duplicate_board.move!(@pos.dup, pos)
    duplicate_board.in_check?(@color)
  end

  def color_symbol
    representation.colorize(PIECE_SYMBOL_COLOR[@color])
  end
end

class SlidingPiece < Piece

  def constraint_met?(pos)
    @board.out_of_bounds?(pos)
  end

end

class SteppingPiece < Piece

  def constraint_met?(pos)
    class_name = self.class.to_s.downcase.to_sym
    #This new position is farther from what I can get with one move?
    #If so, then the constraint is met
    @board.out_of_bounds?(pos) || !MOVING_DIR[class_name].any?{|step| @pos.zip(step).map{|a| a.inject(:+)} == pos}
  end

end

class Pawn < Piece

  def representation
    "♟"
  end

  def move_diffs
    MOVING_DIR[:pawn][@color]
  end

  def moves
    free_moves = []
    moves_to_kill = []
    pre_processing = super

    free_moves << @pos.zip(MOVING_DIR[:pawn][@color][0]).map{|dif| dif.inject(:+)}
    moves_to_kill << @pos.zip(MOVING_DIR[:pawn][@color][1]).map{|dif| dif.inject(:+)}
    moves_to_kill << @pos.zip(MOVING_DIR[:pawn][@color][2]).map{|dif| dif.inject(:+)}

    results = pre_processing.select{|pos| moves_to_kill.include?(pos) && !@board.empty?(pos)}
    results += pre_processing.select{|pos| free_moves.include?(pos) && @board.empty?(pos)}
  end

  def constraint_met?(pos)
    #This new position is farther from what I can get with one move?
    #If so, then the constraint is met
    @board.out_of_bounds?(pos) || !MOVING_DIR[:pawn][@color].any?{|step| @pos.zip(step).map{|a| a.inject(:+)} == pos}
  end

end

class Bishop < SlidingPiece

  def representation
    "♝"
  end

end

class Rook < SlidingPiece

  def representation
    "♜"
  end

end

class Queen < SlidingPiece

  def representation
    "♕"
  end

end

class King < SteppingPiece

  def representation
    "♔"
  end

end

class Knight < SteppingPiece
  def representation
    "♞"
  end
end

class Board
  LETTERS = ('a'..'z').to_a
  N = 8
  STARTING_POS = {:pawn => (0...N).map{|col| [1, col]}.concat((0...N).map{|col| [N - 2, col]}),
                  :knight => [[0, 1], [0, N - 2], [N - 1, 1], [N - 1, N - 2]],
                  :bishop => [[0, 2], [0, N - 3], [N - 1, 2], [N - 1, N - 3]],
                  :rook => [[0, 0], [0, N - 1], [N - 1, 0], [N - 1, N - 1]],
                  :queen => [[0, 3], [N - 1, 3]],
                  :king => [[0, 4], [N - 1, 4]] }

  def initialize(auto_setup = true)
    @grid = Array.new(N){Array.new(N)}
    setup if auto_setup
  end

  def [](pos)
    raise "Invalid position" if out_of_bounds?(pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, piece)
    raise "Invalid position" if out_of_bounds?(pos)
    @grid[pos[0]][pos[1]] = piece
  end

  def in_check?(color)
    # Find king
    king_row = @grid.find do |row|
      row.any?{|piece| piece.is_a?(King, color)}
    end
    king = king_row.find{|piece| piece.is_a?(King, color)}
    # See if any oposing piece can move there
    enemy_color = color == :white ? :black : :white
    all_pieces(enemy_color).map(&:moves).inject(:+).any?{|pos| pos == king.pos}
  end

  def all_pieces(color)
    pieces = []
    @grid.map do |row|
      pieces += row.select{|piece| piece.color == color && !piece.nil?}
    end
    pieces
  end

  def move(start, end_pos)
    piece = self[start]
    raise "Invalid move" if empty?(start) || self[start].moves.none?{|move| move == end_pos} || piece.move_into_check?(end_pos)
    move!(start, end_pos)
  end

  def empty?(pos)
    self[pos].nil?
  end

  def move!(start, end_pos)
    piece = self[start]
    self[end_pos] = piece
    self[start] = nil
    piece.pos = end_pos
  end

  def checkmate?(color)
    # If player in check.
    # AND
    # No pieces have valid moves.
    in_check?(color) && all_pieces(color).all?{|piece| piece.valid_moves == []}
  end

  def draw?
    all_pieces(:white).length == 1 || all_pieces(:black).length == 1
  end

  def dup
    duplicate_board = Board.new(false)
    @grid.each{|row| row.each{ |piece| piece.dup(duplicate_board)} }
    #When dupping the pieces, they get assigned to the duplicate board
    duplicate_board
  end

  def draw(&prc)
    system("clear")
    state = ""
    rows = ""
    state << @grid.map.with_index do |row, j|
      rows = row.map.with_index do |piece, i|
        to_print = ""
        unless piece.nil?
          to_print = piece.color_symbol
        else
          to_print = " "
        end
        mark_color = prc.call([j, i]) unless prc.nil?
        to_print.colorize(background: mark_color)

      end.join('|')
      "#{N - j}|".concat rows

    end.join("|\n")

    state << "|\n" << "  "
    N.times{|i| state << "#{LETTERS[i]} "}
    puts state
  end

  def out_of_bounds?(pos)
    pos[0] < 0 || pos[1] < 0 || pos[0] >= N || pos[1] >= N
  end

  def setup
    STARTING_POS.each_pair{|piece_class, positions| place_all(piece_class, positions)}
  end

  def place_all(piece_class, positions)
    positions.each_with_index do |pos|
      piece = get_piece_instance(piece_class, pos)
      self[pos] = piece
    end
  end

  def get_piece_instance(piece_class, pos)
    if pos[0] < N / 2
      color = :black
    else
      color = :white
    end
    Kernel.const_get(piece_class.to_s.capitalize).new(color, self, pos)
  end

  def light_possible_moves(start)
    potential_moves = self[start].moves
    draw do |pos|
      potential_moves.any?{|mov| mov == pos} ? :yellow : nil
    end
  end
end

class Player

  @@count_players = 0
  CODE_COLOR = {:white => :white, :black => :red}
  attr_reader :name

  def initialize(name = nil)
    @name = name || "#{self.class} ##{@@count_players + 1}"
    @@count_players += 1
  end

end

class HumanPlayer < Player

  attr_reader :color

  def play_turn
    gets.chomp
  end

  def color=(color)
    @color ||= color
    @name = @name.colorize(CODE_COLOR[color])
  end

end

class Game
  N = 8
  COMMAND_REGEXP = /^([a-h])(\d)$/i
  SAVE = "s"

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
    raise "Invalid sintax" if start_code.length != 2 || !start_code.all?{|element| @@codes[element]}
    start = [@@codes[start_code[1]], @@codes[start_code[0]]]
    raise "Select your pieces only" if @board[start].color != player.color

    @board.light_possible_moves(start)

    puts "Select destination:"
    print "-> "
    end_pos_code = player.play_turn.scan(COMMAND_REGEXP).flatten
    raise "Invalid sintax" if end_pos_code.length != 2 || !end_pos_code.all?{|element| @@codes[element]}
    end_pos = [@@codes[end_pos_code[1]], @@codes[end_pos_code[0]]]

    [start, end_pos]
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
      winner = @players[0].color == :white ? @players[0] : @players[1]
    end
    puts "The winner is #{winner.name}"
  end
end

Game.setup
game = Game.new(HumanPlayer.new, HumanPlayer.new)
game.play
