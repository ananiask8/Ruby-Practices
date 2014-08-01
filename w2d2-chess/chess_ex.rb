#Make nil respond to all pieces methods by returning nil
#Make board respond to |=
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
                :pawn => [[0, 1], [-1, 1], [1, 1]],
                :king => [[0, 1], [1, 0], [0, -1], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]],
                :knight => [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]]
                }
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
    moves.reject{|pos| move_into_check?(pos) }
  end

  def move_diffs
    class_name = self.class.to_s.downcase.to_sym
    MOVING_DIR[class_name]
  end

  def dup(board = nil)
    board = @board.dup if board.nil? #Write with |
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

  def representation
  end
end

class SlidingPiece < Piece
  # Needs reference to board to know when its blocked by another.
  # Dont allow to move to square occupied by piece of same color.

  def constraint_met?(pos)
    @board.out_of_bounds?(pos)
  end

end

class SteppingPiece < Piece

  def constraint_met?(pos)
    class_name = self.class.to_s.downcase.to_sym
    @board.out_of_bounds?(pos) || !MOVING_DIR[class_name].any?{|step| @pos.zip(step).map{|a| a.inject(:+)} == pos}
  end

end

class Pawn < SteppingPiece

  def representation
    "P"
  end

end

class Bishop < SlidingPiece

  def representation
    "B"
  end

end

class Rook < SlidingPiece

  def representation
    "R"
  end

end

class Queen < SlidingPiece

  def representation
    "Q"
  end

end

class King < SteppingPiece

  def representation
    "K"
  end

end

class Knight < SteppingPiece
  def representation
    "H"
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
    # self.draw
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
    # Update grid
    # Update piece's position
    # Raise exception if there is no piece at 'start'
    # or the piece cannot move to 'end_pos'
  end

  def empty?(pos)
    self[pos].nil?
  end

  def move!(start, end_pos)
    # To use with Piece#valid_moves (checkmate and such)
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

  def dup
    duplicate_board = Board.new(false)
    @grid.each{|row| row.each{ |piece| piece.dup(duplicate_board)} }
    #When dupping the pieces, they get assigned to the duplicate board
    duplicate_board
  end

  def draw
    system("clear")
    state = ""
    rows = ""
    state << @grid.map.with_index do |row, j|
      rows = row.map do |piece|
        unless piece.nil?
          piece.representation
        else
          " "
        end
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

end

# board = Board.new(true)
# board.draw
# board.in_check?(:white)
# board.dup
# board.draw
# # # board[[9, 8]]
# board[[0,0]] = Rook.new(:black, board, [0, 0])
# p board[[0,0]].class
# p board[[0,0]].color
# board.draw
# p board[[0,0]].moves