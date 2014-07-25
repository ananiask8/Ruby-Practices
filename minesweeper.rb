class Minesweeper
	UNEXPLORED = "*"
	INTERIOR = "_"
	FLAGGED = "F"

	def initialize(n = 9)
		@n = n
		create_board
	end

# protected
	def create_board
		@board = Array.new(@n){Array.new(@n){UNEXPLORED}}
	end

	def draw_board
		state = @board.map{|row| row.join('|')}
		puts state
	end
end

game = Minesweeper.new
game.draw_board