module MinesweeperGame
	UNEXPLORED = "*"
	INTERIOR = "_"
	FLAGGED = "f"
	BOMB = "X"
	BOMBS_FRACTION = {:easy => 20, :medium => 50, :hard => 75}
	PARSING_REGEXP = /(\d+|[fr])/i
	VALID_MOVE_MEMBERS = 3
	NEIGHBORS = [[0, 1], [0, -1], [1, 0], [-1, 0],
								[1, 1], [1, -1], [-1, 1], [-1, -1]]
end

class Tile
	include MinesweeperGame
	attr_writer :neighbors
	attr_reader :neighbor_bomb_count, :state

	def initialize
		@neighbors = []
		@neighbor_bomb_count = 0
		@state = UNEXPLORED
	end

	def self.set_difficulty(difficulty)
		@@prob_bombs = BOMBS_FRACTION[difficulty] / 100
	end

	def bombed?
		@state == BOMB
	end

	def set_type
		@type ||= rand() < @@prob_bombs ? BOMB : INTERIOR
		@neighbors.each{|tile| tile._neighbor_bomb_count += 1} if @type == BOMB
	end

	def flagged?
		@state == FLAGGED
	end

	def revealed?
		@state == @type
	end

	def reveal(type)
		if @state == UNEXPLORED
			if type == FLAGGED
				@state = type
			else
				@state = @type
				@neighbors.select{|tile| tile.revealed?}.each{|tile| tile.reveal(type)}
			end
		end
	end

	protected
	def _neighbor_bomb_count=(new_count)
		@neighbor_bomb_count = new_count
	end
end

class Board
	include MinesweeperGame
	def initialize(n, difficulty)
		@n = n
		@difficulty = difficulty
		create_board
		seed_board
		instructions
	end

	def game_over?
		any?{|tile| tile.bombed?} || all?{|tile| tile.flagged? || tile.revealed?}
	end

	def make_move
		move = parse_move(gets.chomp)
		until valid_move?(move)
			puts "Please make a valid move... Punny human."
			move = parse_move(gets.chomp)
		end
		px, py = move[:coords][0], move[:coords][1]
		@board[py][px].reveal(move[:type])
		draw_board
	end

	protected

	def create_board
		Tile.set_difficulty(@difficulty)
		@board = Array.new(@n){ Array.new(@n){ Tile.new } }
		connect_neighbors
	end

	def seed_board #check if can take map! out
		@board.each{|row| row.each{|tile| tile.set_type}}
	end

	def instructions
		puts "Take an action on the '(x, y)' position. After a blank space, type 'f' to flag and 'r' to reveal."
	end

	def connect_neighbors
		count = 0
		@board.each_with_index do |row, y| 
			row.each_with_index do |tile, x|
				NEIGHBORS.each do |dx, dy|
					p count += 1
					px = x + dx
					py = y + dy
					tile.neighbors << @board[py][px] if in_range?([px, py])
				end
			end
		end
	end

	def draw_board
		state = " "
		@n.order_of_magnitude(10).times{state << " "}
		state << (1..@n).to_a.join('|') << "\n"
		state << @board.map.with_index{|row, j| "#{j + 1} ".concat row.map{|tile| tile.state}.join('|')}.join("\n")
		puts state
	end

	def parse_move(line)
		move = line.scan(PARSING_REGEXP).flatten
		{:coords => [move[0] - 1, move[1] - 1], :type => move[2]}
	end

	def valid_move?(move)
		!(move.length != VALID_MOVE_MEMBERS || (move[0] =~ /^[0-9]$/).nil? || (move[1] =~ /^[0-9]$/).nil? || (move[2] =~ /^[fr]$/i).nil?)
	end

	def in_range?(pos)
		pos[0] >= 0 && pos[0] < @n && pos[1] >= 0 && pos[1] < @n
	end

	def any?(&prc)
		result = false
		@board.each{|row| row.each{|tile| p tile.bombed?;result |= prc.call(tile)}}
		result
	end

	def all?(&prc)
		result = true
		@board.each{|row| row.each{|tile| p tile.bombed?; result &= prc.call(tile)}}
		result
	end
	
end

class Minesweeper
	include MinesweeperGame

	def initialize(n = 9, difficulty = :easy)
		@board = Board.new(n, difficulty)
	end

	def run
		until @board.game_over?
			@board.make_move
		end
		@board.results
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
# game.run
