class Minesweeper
	UNEXPLORED = "*"
	INTERIOR = "_"
	FLAGGED = "F"
	BOMB = "X"
	BOMBS_FRACTION = {:easy => 20, :medium => 50, :hard => 75}

	def initialize(n = 9, difficulty = :easy)
		@n = n
		@difficulty = difficulty
		create_board
		seed_board
	end

# protected
	def create_board
		@board = {:status => Array.new(@n){Array.new(@n){UNEXPLORED}},
						:configuration => Array.new(@n){Array.new(@n){UNEXPLORED}}}
	end

	def seed_board
		number_of_bombs = @n * @n * BOMBS_FRACTION[@difficulty] / 100
		bombs_placed = 0
		until bombs_placed == number_of_bombs
			px, py = rand(@n), rand(@n)
			unless @board[:configuration][py][px] == BOMB
				@board[:configuration][py][px] = BOMB
				bombs_placed += 1
			end
		end
	end

	def draw_board
		state = @board[:status].map{|row| row.join('|')}
		puts state
	end
end

game = Minesweeper.new
game.draw_board