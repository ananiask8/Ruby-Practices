class Hangman
	def initialize(guessing_player, checking_player)
		@guessing_player = guessing_player
		@checking_player = checking_player
	end

	def play
		@checking_player.pick_secret_word
		@guessing_player.receive_secret_length(@checking_player.secret_length)
		until @checking_player.win?
			@guessing_player.message_for_guess
			correct, positions = @checking_player.check_guess(@guessing_player.guess)
			@guessing_player.handle_guess_response(correct, positions)
		end
		@guessing_player.message_for_guess
	end
end

class Player
	DICTIONARY_PATH = '../projects/dictionary.txt'
	
	attr_reader :name, :secret_length

	def initialize()
		
	end
#For guessing mode
	def receive_secret_length(secret_length)
	end

	def message_for_guess
		message = "_" * @secret_length
		@guessed.each{|guess| guess[:positions].each{|i| message[i] = guess[:letter]}}
		puts "Secret word: #{message}"
	end

	def guess
	end

	def handle_guess_response(correct, positions = [])
		@guessed << {:letter => @last_guess, :positions => positions} if correct
	end

#For checking mode
	def pick_secret_word
	end

	def win?
		@word == @word.tr("^#{@checked_letters}", '_') if @checked_letters != ""
	end

	def check_guess(guess)
		if @word.include?(guess)
			@checked_letters << guess
			return true, @word.each_char.with_index.to_a.select{|char_index| char_index[0] == guess}.map{|char_index| char_index[1]}
		end
		return false, 0
	end

end

class HumanPlayer < Player
	attr_reader :name, :secret_length
	def initialize(name)
		@name = name
		@checked_letters = ""
		@guessed = []
	end

#For guessing
	def receive_secret_length(length)
		@secret_length = length
	end

	def guess
		@last_guess = gets.chomp
	end

#For checking mode
	def pick_secret_word
		pick_length
		p @word = File.read(DICTIONARY_PATH).split(%r{\s}).select{|word| word.length == @secret_length}.sample
	end

	def check_guess(guess)
		positions = gets.chomp.split(", ").map{|position| position.to_i}
		return false, 0 if positions == ""
		return true, positions
	end

private
#For checking mode
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
		@guessed = []
	end

#For guessing mode
	def receive_secret_length(length)
		@secret_length = length
		@possibilities = File.read(DICTIONARY_PATH).split(%r{\s}).select{|word| word.length == @secret_length}
	end

	def guess
		@last_guess = most_frequent_letter
		puts @last_guess
	end

	def handle_guess_response(correct, positions = [])
		if correct
			@possibilities.select!{|word| matches_in_positions?(word, positions)}
			@guessed << {:letter => @last_guess, :positions => positions}
		else
			@possibilities.select!{|word| !word.include?(@last_guess)}
		end
	end

#For checking mode
def pick_secret_word
	@word = File.read(DICTIONARY_PATH).split(%r{\s}).sample
	@secret_length = @word.length
end

private
#For guessing mode
	def most_frequent_letter
		max = 0
		most_frequent = ""
		("a".."z").each do |letter| 
			max
			@possibilities.join.count(letter)
			if max <= @possibilities.join.count(letter) && !guessed_letters.include?(letter)
				max = @possibilities.join.count(letter)
				most_frequent = letter
			end
		end
		most_frequent
	end

	def guessed_letters
		result = ""
		@guessed.each{|guess| result << guess[:letter]}
		result
	end

	def matches_in_positions?(word, positions)
		positions.each{|p| return false unless word[p] == @last_guess}
		true
	end
#For checking mode
	
end

human_player = HumanPlayer.new("Ananias")
computer_player = ComputerPlayer.new
#hangman = Hangman.new(human_player, computer_player)
hangman = Hangman.new(computer_player, human_player)
hangman.play