# encoding: utf-8

class Pawn < Piece

  MOVING_DIR = {:white => [[-1, 0], [-2, 0], [-1, -1], [-1, 1]], :black => [[1, 0], [2, 0], [1, -1], [1, 1]]}
  INIT_VERTICAL_POS = {:white => 6, :black => 1}


  def representation
    "♟"
  end

  def move_diffs
    MOVING_DIR[@color]
  end

  def moves
    moves_to_kill = []
    pre_processing = super

    single_move = @pos.zip(MOVING_DIR[@color][0]).map{|dif| dif.inject(:+)}
    double_move = @pos.zip(MOVING_DIR[@color][1]).map{|dif| dif.inject(:+)}
    moves_to_kill << @pos.zip(MOVING_DIR[@color][2]).map{|dif| dif.inject(:+)}
    moves_to_kill << @pos.zip(MOVING_DIR[@color][3]).map{|dif| dif.inject(:+)}

    results = pre_processing.select{|pos| moves_to_kill.include?(pos) && !@board.empty?(pos)}
    results += pre_processing.select{|pos| single_move == pos && @board.empty?(pos)}
    results += pre_processing.select{|pos| double_move == pos && double_jump_allowed?(pos)}
    results
  end

  def double_jump_allowed?(double_move)
    @pos[0] == INIT_VERTICAL_POS[@color] && @board.empty?(double_move)
  end

  def constraint_met?(pos)
    #This new position is farther from what I can get with one move?
    #If so, then the constraint is met
    @board.out_of_bounds?(pos) || !MOVING_DIR[@color].any?{|step| @pos.zip(step).map{|a| a.inject(:+)} == pos}
  end

end