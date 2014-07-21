
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
		if player_1.class == HumanPlayer
			@player_1 = player_1
			@player_2 = player_2
		else
			@player_1 = player_2
			@player_2 = player_1
		end
		@board = Board.new
		@marks = TicTacToe::MARKS
	end

	def play
		while true
			@board.place_mark(@player_1.make_move(@board), @marks[0])
			break if @board.won? || @board.filled?
			@board.place_mark(@player_2.make_move(@board), @marks[1])
			break if @board.won? || @board.filled?
		end
		return puts "#{@player_1.name} won!!" if @board.winner == @marks[0]
		return puts "#{@player_2.name} won!!" if @board.winner == @marks[1]
		return puts "Its a tie.."
	end
end

class Player
	attr_reader :name
	def initialize()
	end
	def make_move(board)
	end
end

class HumanPlayer < Player
	attr_reader :name
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
		return pos
	end
end

class ComputerPlayer < Player
	@@cpu_players = 0
	attr_reader :name
	def initialize()
		@@cpu_players += 1
		@name = "CPU " + @@cpu_players.to_s
	end
	def make_move(board)
		available_pos = []
		size = board.n
		(size * size).times{|i| available_pos << i if board.empty?(i)}
		return available_pos.sample if available_pos.length > 0
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
		potential_states = (0...npos).select{|pos| @board.empty?(pos)}.
							map{|available_pos| TicTacToeNode.new(@board.dup, !next_mover_mark, available_pos)}
	end
end

human_player = HumanPlayer.new("Ananias")
cpu1_player = ComputerPlayer.new
cpu2_player = ComputerPlayer.new
tic_tac_toe = Game.new(cpu1_player, cpu2_player)
tic_tac_toe.play
b = Board.new
tttn = TicTacToeNode.new(b, true, nil)
tttn.children