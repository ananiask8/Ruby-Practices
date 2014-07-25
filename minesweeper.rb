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
		instructions
	end

	def run
		until game_over
			play = make_move
			reveal(play)
		end
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

	def instructions
		puts "Take an action on the '(x, y)' position. After a blank space, type 'f' to flag and 'r' to reveal."
	end

	def draw_board
		state = " "
		@n.order_of_magnitude(10).times{state << " "}
		state << (1..@n).to_a.join('|') << "\n"
		state << @board[:status].map.with_index{|row, j| "#{j + 1} ".concat row.join('|')}.join("\n")
		puts state
	end

	def make_move
		move = parse_move(gets.chomp)
		until valid_move?(move)
			puts "Please make a valid move. Thank you... Punny human."
			move = gets.chomp
		end
		move
	end

	def reveal

	end

	def parse_move(line)

	end

	def valid_move?(move)

	end
end

class Fixnum
	def order_of_magnitude(base)
		count = 0
		count += 1 until self / base ** count == 0
		count
	end
end

game = Minesweeper.new
game.draw_board
