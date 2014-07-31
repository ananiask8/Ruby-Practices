class Piece
  # Track position
  # Hold a reference to board
  def initialize

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
  def initialize
  end

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

  def initialize
  end

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


class Board
  LETTERS = ('a'..'z').to_a
  def initialize(n = 8)
    @n = n
    @grid = Array.new(n){Array.new(n)}
    # Create setup with all pieces in initial positions
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
      "#{j + 1}|".concat rows
    end.join("|\n")
    state << "|\n" << "  "
    @n.times{|i| state << "#{LETTERS[i]} "}
    puts state
  end
end

board = Board.new
board.draw
