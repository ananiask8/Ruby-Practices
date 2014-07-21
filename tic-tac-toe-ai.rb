
module TicTacToe
	MARKS = [false, true]
end
class Board
	include TicTacToe
	attr_reader :winner, :n
	def initialize(n = 3)
		@n = n
		@spots = Array.new(n){Array.new(n)}
		@winner = nil
	end

	def won?
		diag = Array.new(2){Array.new(@n)}
		@n.times{|i| diag[0][i] = @spots[i][i]}
		@n.times{|i| diag[1][i] = @spots[i][@n - i]}
		@spots.each{|i| @winner = i[0] if i.uniq.length == 1 && i[0] != nil}
		@spots.transpose.each{|i| @winner = i[0] if i.uniq.length == 1 && i[0] != nil}
		diag.each{|i| @winner = i[0] if i.uniq.length == 1 && i[0] != nil}
		return @winner? true : false
	end

	# def winner
	# end

	def empty?(pos)
		i = pos / @n
		j = pos % @n
		@spots[i][j].nil?
	end

	def place_mark(pos, mark)
		i = pos / @n
		j = pos % @n
		@spots[i][j] = mark
	end

	def filled?
		(@n * @n).times{|i| return false if empty?(i)}
		return true
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
			move = @players[i].make_move(@board)
			@board.place_mark(move[0], move[1])
			i = (i == 0) ? 1 : 0
		end
		results
	end

	def game_over?
		@board.won? || @board.filled?
	end

	def results
		return puts "#{@players[0].name} won!!" if @board.winner == @players[0].mark
		return puts "#{@players[1].name} won!!" unless @board.winner == @players[1].mark
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

class TicTacToeNode
	attr_reader :next_mover_mark, :prev_move_pos
	def initialize(board, next_mover_mark, prev_move_pos)
		@board = board
		@next_mover_mark = next_mover_mark
		@prev_move_pos = prev_move_pos
	end

	def children
		npos = @board.n * @board.n
		@potential_states = (0...npos).select{|pos| @board.empty?(pos)}.
					map{|available_pos| TicTacToeNode.new(@board.dup.
					place_mark(available_pos, next_mover_mark), 
					!next_mover_mark, available_pos)}
	end

	def losing_node?(player)
		@board.filled? && @board.win? != player.mark ||
		players_turn?(player) && !any_winning_children?(player) ||
		!players_turn?(player) && any_losing_children?(player)
	end

	def winning_node?(player)
		@board.filled? && @board.win? == player.mark ||
		players_turn?(player) && any_winning_children?(player) ||
		!players_turn?(player) && !any_losing_children?(player)
	end

	def players_turn?(player)
		next_mover_mark == player.mark
	end

	def any_winning_children?(player)
		result = false
		@potential_states.each{|child| result ||= child.winning_node?(player)}
		result
	end

	def any_losing_children?(player)
		result = false
		@potential_states.each{|child| result ||= child.losing_node?(player)}
		result
	end
end

human_player = HumanPlayer.new("Ananias")
cpu1_player = ComputerPlayer.new
cpu2_player = ComputerPlayer.new
tic_tac_toe = Game.new(cpu1_player, cpu2_player)
tic_tac_toe.play
# b = Board.new
# tttn = TicTacToeNode.new(b, true, nil)
# tttn.children