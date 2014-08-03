# encoding: utf-8

class SlidingPiece < Piece

  MOVING_DIFFS = [[0, 1], [1, 0], [0, -1], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]

  def constraint_met?(pos)
    @board.out_of_bounds?(pos)
  end
end

class Bishop < SlidingPiece

  def move_diffs
    MOVING_DIFFS[4..7]
  end

  def representation
    "♝"
  end

end

class Rook < SlidingPiece

  def move_diffs
    MOVING_DIFFS[0..3]
  end

  def representation
    "♜"
  end

end

class Queen < SlidingPiece

  def move_diffs
    MOVING_DIFFS
  end

  def representation
    "♕"
  end

end
