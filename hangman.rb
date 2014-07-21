class Hangman
	def initialize(guessing_player, checking_player)
		@guessing_player = guessing_player
		@checking_player = checking_player
	end

	def play
		@checking_player.pick_secret_word
		@guessing_player.receive_secret_length(@checking_player.secret_length)
		@checking_player.check_guess("")
		until @checking_player.win?
			correct, position = @checking_player.check_guess(@guessing_player.guess)
			@guessing_player.handle_guess_response(correct, position)
		end
	end
end

class Player
	DICTIONARY_PATH = '../projects/dictionary.txt'
	
	attr_reader :name, :secret_length

	def initialize()
		
	end

	def pick_secret_word
	end

	def receive_secret_length(secret_length)
	end

	def guess
	end

	def win?
		@word == @word.tr("^#{@checked_letters}", '_') if @checked_letters != ""
	end

	def check_guess(guess)
		if @word.include?(guess)
			@checked_letters << guess
			message_for_guess
			return true, @word.index(guess)
		end
		message_for_guess
		return false, 0
	end

	def handle_guess_response(correct, position = 0)
	end

private
	def message_for_guess
		if @checked_letters != ""
			puts @word.tr("^#{@checked_letters}", '_')
		else
			puts "_" * @word.length
		end
	end
end

class HumanPlayer < Player
	attr_reader :name, :secret_length
	def initialize(name)
		@name = name
		@checked_letters = ""
		@guessed_letters = ""
	end

	def pick_secret_word
		pick_length
		@word = File.read(DICTIONARY_PATH).split(%r{\s}).select{|word| word.length == @secret_length}.sample
	end

	def guess
		@last_guess = gets.chomp
	end

	def handle_guess_response(correct, position)
		#@guessed_letters << @last_guess if correct
	end

private
	def pick_length
		until @secret_length.class == Fixnum
			puts "Type a length (number)"
			@secret_length = gets.chomp.to_i
		end
	end
end

class ComputerPlayer < Player
	@@cpu_players = 0
	attr_reader :name, :secret_length
	def initialize()
		@@cpu_players += 1
		@name = "CPU " + @@cpu_players.to_s
		@checked_letters = ""
		@guessed_letters = ""
	end

	def pick_secret_word
		@word = File.read(DICTIONARY_PATH).split(%r{\s}).sample
		@secret_length = @word.length
	end

	def receive_secret_length(length)
		@secret_length = length
		@possibilities = File.read(DICTIONARY_PATH).split(%r{\s}).select{|word| word.length == @secret_length}
	end

	def guess
		@last_guess = most_frequent_letter
	end

	def most_frequent_letter
		max = 0
		most_frequent = ""
		("a".."z").each do |letter| 
			max
			@possibilities.join.count(letter)
			if max <= @possibilities.join.count(letter) && !@guessed_letters.include?(letter)
				max = @possibilities.join.count(letter)
				most_frequent = letter
			end
		end
		most_frequent
	end

	def handle_guess_response(correct, position = 0)
		if correct
			@possibilities.select!{|word| word[position] == @last_guess}
			@guessed_letters << @last_guess
		else
			@possibilities.select!{|word| !word.include?(@last_guess)}
		end
	end
end

human_player = HumanPlayer.new("Ananias")
computer_player = ComputerPlayer.new
#hangman = Hangman.new(human_player, computer_player)
hangman = Hangman.new(computer_player, human_player)
hangman.play
