class Piece
  # Track position
  # Hold a reference to board
  attr_reader :color
  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
  end

  def moves
    # Return array to where pieces can move.
    # Implement in subclasses.
  end

  def move_into_check?(pos)
    # Duplicate the board and perform the move.
    # Look to see if the player is in check after the move.
    # Board#in_check?
    # Need Board#dup for this. Remember to write it for all classes involved.
  end

  def representation
  end
end

class SlidingPiece < Piece
  # Needs reference to board to know when its blocked by another.
  # Dont allow to move to square occupied by piece of same color.

  def moves(directions)

  end

end

class SteppingPiece < Piece

end

class Pawn < Piece

  def representation
    "P"
  end
end

class Bishop < SlidingPiece

  def move_dirs
    moves([:diagonal])
  end

  def representation
    "B"
  end
end

class Rook < SlidingPiece
  def move_dirs
    moves([:straight])
  end

  def representation
    "R"
  end
end

class Queen < SlidingPiece
  def move_dirs
    moves([:straight, :diagonal])
  end

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
    p pos
    raise "Invalid position" if out_of_bounds?(pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, value)
    raise "Invalid position" if out_of_bounds?(pos)
    @grid[pos[0]][pos[1]] = value
  end

  def in_check?(color)
    # Find king
    # See if any oposing piece can move there
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
    # To use with Piece#valid_moves
  end

  def checkmate?(color)
    # If player in check.
    # No pieces have valid moves.
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
    STARTING_POS.each_pair{|piece, positions| place(piece, positions)}
  end

  def place(piece, positions)
    positions.each_with_index do |pos|
      if pos[0] < N / 2
        color = :black
      else
        color = :white
      end
      self[pos] = Kernel.const_get(piece.to_s.capitalize).new(color, self, pos)
    end
  end

end

# board = Board.new
# board.draw
# # board[[9, 8]]
# p board[[5,5]] = Rook.new(:black, board, [5, 5])
# p board[[5,5]].class
# p board[[5,5]].color