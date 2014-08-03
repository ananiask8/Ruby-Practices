# encoding: utf-8

class SteppingPiece < Piece

  def constraint_met?(pos)
    class_name = self.class.to_s.downcase.to_sym
    #This new position is farther from what I can get with one move?
    #If so, then the constraint is met
    @board.out_of_bounds?(pos) || !move_diffs.any?{|step| @pos.zip(step).map{|a| a.inject(:+)} == pos}
  end

end

class King < SteppingPiece

  MOVING_DIFFS = [[0, 1], [1, 0], [0, -1], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]

  def move_diffs
    MOVING_DIFFS
  end

  def representation
    "♔"
  end

end

class Knight < SteppingPiece

  MOVING_DIFFS = [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]]

  def move_diffs
    MOVING_DIFFS
  end

  def representation
    "♞"
  end
end