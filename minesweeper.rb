#!/usr/bin/env ruby
require 'json'
require 'yaml'

module MinesweeperGame
	UNEXPLORED = "*"
	INTERIOR = "_"
	FLAGGED = "f"
	BOMB = "X"
	BOMBS_FRACTION = {:easy => 20, :medium => 50, :hard => 75}
	PARSING_REGEXP = /(\d+|[fr])/i
	PAUSE = "p"
	VALID_MOVE_MEMBERS = 3
	NEIGHBORS = [[0, 1], [0, -1], [1, 0], [-1, 0],
								[1, 1], [1, -1], [-1, 1], [-1, -1]]
end

class Tile
	include MinesweeperGame
	attr_accessor :neighbors
	attr_reader :neighbor_bomb_count, :state

	def initialize
		@neighbors = []
		@neighbor_bomb_count = 0
		@state = UNEXPLORED
	end

	def self.set_difficulty(difficulty)
		@@prob_bombs = BOMBS_FRACTION[difficulty] / 100.0
	end

	def bombed?
		@state == BOMB
	end

	def set_type
		@type ||= rand() < @@prob_bombs ? BOMB : INTERIOR
		@neighbors.each{|tile| tile._neighbor_bomb_count = tile.neighbor_bomb_count + 1} if @type == BOMB
	end

	def flagged?
		@state == FLAGGED
	end

	def revealed?
		@state == @type || @state == @neighbor_bomb_count
	end

	def reveal(type)
		if @state == UNEXPLORED
			if type == FLAGGED
				@state = type
			else
				@state = @type
				unless @type == BOMB
					if @neighbor_bomb_count == 0
						@neighbors.reject{|tile| tile.revealed?}.each{|tile| tile.reveal(type)}
					else
						@state = @neighbor_bomb_count.to_s
					end
				end
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
	attr_accessor :paused
	def initialize(n, difficulty)
		@n = n
		@difficulty = difficulty
		@paused = false
		create_board
		seed_board
	end

	def make_move
		@paused = false
		instructions
		draw_board
		input = $stdin.gets.chomp
		move = parse_move(input)

		until valid_move?(move)
			if input == PAUSE 
				@paused = true
				return
			end
			puts "Please make a valid move... Punny human."
			input = $stdin.gets.chomp
			move = parse_move(input)
		end

		px, py = move[:coords][0].to_i - 1, move[:coords][1].to_i - 1
		@board[py][px].reveal(move[:type])
		draw_board
	end

	def results
		if any?{|tile| tile.bombed?}
			puts "You lose, punny human..."
		else
			puts "You win... surprisingly clever human... I think you must be a bot."
		end
	end

	def game_over?
		any?{|tile| tile.bombed?} || all?{|tile| tile.flagged? || tile.revealed?}
	end

	protected

	def create_board
		Tile.set_difficulty(@difficulty)
		@board = Array.new(@n){ Array.new(@n){ Tile.new } }
		connect_neighbors
	end

	def seed_board
		@board.each{|row| row.each{|tile| tile.set_type}}
	end

	def instructions
		puts "Take an action on the '(x, y)' position. After a blank space, type 'f' to flag and 'r' to reveal."
	end

	def connect_neighbors
		@board.each_with_index do |row, y| 
			row.each_with_index do |tile, x|
				NEIGHBORS.each do |dx, dy|
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
		{:coords => [move[0], move[1]], :type => move[2]}
	end

	def valid_move?(move)
		!((move[:coords].length != 2 || move[:coords][0] =~ /^[0-9]$/).nil? || (move[:coords][1] =~ /^[0-9]$/).nil? || move[:type].nil?)
	end

	def in_range?(pos)
		pos[0] >= 0 && pos[0] < @n && pos[1] >= 0 && pos[1] < @n
	end

	def any?(&prc)
		result = false
		@board.each{|row| row.each{|tile| result |= prc.call(tile)}}
		result
	end

	def all?(&prc)
		result = true
		@board.each{|row| row.each{|tile| result &= prc.call(tile)}}
		result
	end	
end

class Minesweeper
	include MinesweeperGame

	def initialize(n = 9, difficulty = :easy)
		@board = Board.new(n, difficulty)
	end

	def run
		@board.paused = false
		until @board.game_over? || @board.paused
			@board.make_move
		end
		if @board.paused
			save_game
		else
			@board.results
		end
	end

	def save_game
		file = "minesweeper_game"
		File.open(file, 'w').puts self.to_yaml
	end

end

class Fixnum
	def order_of_magnitude(base)
		count = 0
		count += 1 until self / base ** count == 0
		count
	end
end

if $PROGRAM_NAME == __FILE__
	if ARGV[0]
		game = YAML::load(File.read(ARGV[0]))
  	game.run
  else
  	game = Minesweeper.new
		game.run
  end
end
