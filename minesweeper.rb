class Minesweeper
	UNEXPLORED = "*"
	INTERIOR = "_"
	FLAGGED = "F"
	
	def initialize(n = 9)
		@n = n
		draw_board
	end

protected
	def draw_board
		@board = Array.new(@n){Array.new(@n){UNEXPLORED}}
	end
end