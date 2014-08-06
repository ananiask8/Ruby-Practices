class Hanoi
  MOVE_REGEXP = /^(\d*)->(\d*)$/i
  attr_reader :piles

  def initialize(n = 3)
    @n = n
    @piles = Array.new(@n) { [] }
    setup
  end

  def play
    until won?
      render
      begin
        puts "Please make a move (from->to): "
        input = gets.chomp.scan(MOVE_REGEXP).flatten
        move(input[0].to_i, input[1].to_i)
      rescue
        render
        puts "Please make a VALID move!"
        retry
      end
    end
  end

  def setup
    @n.times{|i| @piles[0] << @n - i}
  end

  def move(from, to)
    raise "Invalid move" unless valid_parameters?(from, to) && valid_move?(from, to)
    @piles[to] << @piles[from].pop
  end

  def valid_parameters?(from, to)
    from.class == Fixnum && to.class == Fixnum && from >= 0 && from < @n && to >= 0 && to < @n
  end

  def valid_move?(from, to)
    @piles[from].size != 0 && (@piles[to].size == 0 || @piles[to].last > @piles[from].last)
  end

  def won?
    @piles.last.size == @n
  end

  def render
    # some cool graphic stuff
  end
end

hanoi = Hanoi.new
hanoi.play
