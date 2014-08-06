class Piece
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

  def dup(board = nil)
    board ||= @board.dup
    self.class.new(@color, board, @pos)
  end

  def move_into_check?(end_pos)
    duplicate_board = @board.dup
    duplicate_board.move!(@pos.dup, end_pos)
    duplicate_board.in_check?(@color)
  end

  def color_symbol
    representation.colorize(PIECE_SYMBOL_COLOR[@color])
  end
end


