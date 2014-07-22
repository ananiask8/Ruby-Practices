
module TicTacToe
	MARKS = [:o, :x]
end
class Board
	include TicTacToe
	attr_reader :n, :spots
	attr_accessor :winner
	def initialize(n = 3)
		@n = n
		@spots = Array.new(n){Array.new(n)}
		@winner = nil
	end

	def status_update
		# First winner remains the winner. 
		# Added this condition just in case I calculate to the point where 
		# the board is filled with the SuperComputer and there might be 
		# two winning players and get an error in predictions because of that.
		if winner.nil? 
			diag = Array.new(2){Array.new(@n)}
			@n.times{|i| diag[0][i] = @spots[i][i]}
			@n.times{|i| diag[1][i] = @spots[i][@n - i - 1]}
			@spots.each{|i| @winner = i[0] if i.uniq.length == 1 && !i[0].nil?}
			@spots.transpose.each{|i| @winner = i[0] if i.uniq.length == 1 && !i[0].nil?}
			diag.each{|i| @winner = i[0] if i.uniq.length == 1 && !i[0].nil?}
		end
	end

	def over?
		filled? || won?
	end

	def won?
		@winner ? true : false
	end

	def clone
		clone_board = Board.new(@n)
		@spots.each_with_index{|col, i| col.each_with_index{|element, j| clone_board.place_mark(@n*i + j, element)}}
		clone_board.winner = @winner
		clone_board
	end

	def empty?(pos)
		i = pos / @n
		j = pos % @n
		@spots[i][j].nil?
	end

	def place_mark(pos, mark)
		i = pos / @n
		j = pos % @n
		@spots[i][j] = mark
		status_update
	end

	def filled?
		(@n * @n).times{|i| return false if empty?(i)}
		return true
	end

	def print
		table = @spots.map{|col| col.map{|elem| elem||=' '; "#{elem}|"}.join}.join("\n")
		puts "#{table}\n\n"
	end
end

class Game
	include TicTacToe
	def initialize(player_1, player_2)
		@board = Board.new
		@players = [player_1, player_2]
		@players[0].mark = TicTacToe::MARKS[0]
		@players[1].mark = TicTacToe::MARKS[1]
	end

	def play
		i = 0
		until game_over?
			@board.print
			move = @players[i].make_move(@board.clone)
			@board.place_mark(move[0], move[1])
			i = (i == 0) ? 1 : 0
		end
		@board.print
		results
	end

	def game_over?
		@board.over?
	end

	def results
		return puts "#{@players[0].name} won!!" if @board.winner == @players[0].mark
		return puts "#{@players[1].name} won!!" if @board.winner == @players[1].mark
		puts "Its a tie.."
	end
end

class Player
	attr_reader :name
	attr_accessor :mark
	def initialize()
	end
	def make_move(board)
	end
end

class HumanPlayer < Player
	def initialize(name)
		@name = name
	end

	def make_move(board)
		puts "Please, make a move: "
		pos = gets.chomp.to_i
		size = board.n
		while (size * size) <= pos || !board.empty?(pos)
			puts "Invalid move!"
			pos = gets.chomp.to_i
		end
		return [pos, @mark]
	end
end

class ComputerPlayer < Player
	@@cpu_players = 0
	def initialize()
		@@cpu_players += 1
		@name = "CPU " + @@cpu_players.to_s
	end
	def make_move(board)
		available_pos = []
		size = board.n
		(size * size).times{|i| available_pos << i if board.empty?(i)}
		return [available_pos.sample, @mark] if available_pos.length > 0
	end
end

class SuperComputerPlayer < ComputerPlayer
	def make_move(board)
		node = TicTacToeNode.new(board, @mark)
		possible_moves = node.children
		
		node = possible_moves.find{|child| child.winning_node?(self)}
		return [node.prev_move_pos, @mark] if node
		
		node = possible_moves.find{|child| !child.losing_node?(self)}
		return [node.prev_move_pos, @mark] if node
		
		raise "Error!"
	end
end

class TicTacToeNode
	include TicTacToe
	attr_reader :next_mover_mark, :prev_move_pos, :board
	def initialize(board, next_mover_mark, prev_move_pos = nil)
		@board = board
		@next_mover_mark = next_mover_mark
		@prev_move_pos = prev_move_pos
	end

	def children
		npos = @board.n * @board.n
		new_next = (@next_mover_mark == TicTacToe::MARKS[0]) ? TicTacToe::MARKS[1] : TicTacToe::MARKS[0]
		potential_states = []
		(0...npos).each do |available_pos| 
			next unless @board.empty?(available_pos)
			new_board = @board.clone
			new_board.place_mark(available_pos, @next_mover_mark)
			potential_states << TicTacToeNode.new(new_board, new_next, available_pos)
		end
		potential_states
	end

	def losing_node?(player)
		if @board.over?
			# Have to include 'tied' as a non-losing node.
			# So, return false if nobody won.
			return @board.won? && @board.winner != player.mark
		end
		
		if players_turn?(player)
			children.all?{|child| child.losing_node?(player)}
		else 
			children.any?{|child| child.losing_node?(player)}
		end
	end

	def winning_node?(player)
		if @board.over?
			return @board.winner == player.mark
		end
		
		if players_turn?(player) 
			children.any?{|child| child.winning_node?(player)}
		else
			children.all?{|child| child.winning_node?(player)}
		end
	end

	def players_turn?(player)
		@next_mover_mark == player.mark
	end
end

human_player = HumanPlayer.new("Ananias")
cpu1_player = SuperComputerPlayer.new
cpu2_player = SuperComputerPlayer.new
tic_tac_toe = Game.new(cpu1_player, human_player)
tic_tac_toe.play
