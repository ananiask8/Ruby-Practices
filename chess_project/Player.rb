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