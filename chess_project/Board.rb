require 'active_support/all'
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

  def move!(start, end_pos)
    piece = self[start]
    self[end_pos],  self[start] = piece, nil
    piece.try(:pos=, end_pos)
  end

  def move(start, end_pos)
    piece = self[start]
    raise "Invalid move" if empty?(start) || self[start].moves.none?{|move| move == end_pos} || piece.move_into_check?(end_pos)
    move!(start, end_pos)
  end

  def empty?(pos)
    self[pos].nil?
  end

  def all_pieces(color)
    pieces = []
    @grid.map do |row|
      pieces += row.compact.select{|piece| piece.color == color}
    end
    pieces
  end

  def in_check?(color)
    king_of_color = Proc.new{|piece| piece.is_a?(King) && piece.color == color}

    king = @grid.find{|row| row.compact.any?(&king_of_color)}.compact.find(&king_of_color)

    enemy_color = color == :white ? :black : :white
    all_pieces(enemy_color).map(&:moves).inject(:+).any?{|pos| pos == king.pos}
  end

  def checkmate?(color)
   in_check?(color) && all_pieces(color).all?{|piece| piece.valid_moves == []}
  end

  def draw?
    all_pieces(:white).length == 1 || all_pieces(:black).length == 1
  end

  def dup
    duplicate_board = Board.new(false)
    @grid.each{|row| row.each{ |piece| piece.try(:dup, duplicate_board)} }
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
          to_print = piece.color_symbol.concat " "
        else
          to_print = "  "
        end
        mark_color = prc.call([j, i]) unless prc.nil?
        to_print.colorize(background: mark_color)

      end.join('|')
      "#{N - j}|".concat rows

    end.join("|\n")

    state << "|\n" << "  "
    N.times{|i| state << " #{LETTERS[i]} "}
    puts state
  end

  def out_of_bounds?(pos)
    pos[0] < 0 || pos[1] < 0 || pos[0] >= N || pos[1] >= N
  end

  def setup
    STARTING_POS.each_pair{|piece_class, positions| place_all_pieces_of_type(piece_class, positions)}
  end

  def place_all_pieces_of_type(piece_class, positions)
    positions.each_with_index do |pos|
      color = pos[0] < N / 2 ? :black : :white
      self[pos] = Kernel.const_get(piece_class.to_s.capitalize).new(color, self, pos)
    end
  end

  def light_possible_moves(start)
    potential_moves = self[start].moves
    draw do |pos|
      potential_moves.any?{|mov| mov == pos} ? :yellow : nil
    end
  end
end
