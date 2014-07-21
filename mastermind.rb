class Code
	def initialize(colors)
		@code = colors.sample(4).map{|color| color[0].capitalize}.join
	end

	def compare(guess)
		exact_matches = 0
		near_matches = 0
		guess.each_char.with_index do |c, i| 
			if @code[i] == c
				exact_matches += 1
			elsif @code.include? c
				near_matches += 1
			end
		end
		{:exact_matches => exact_matches, :near_matches => near_matches}
	end
end

class Game
	NUMBER_OF_TURNS = 10
	PEG_COLORS = ["Red", "Green", "Blue", "Yellow", "Orange", "Purple"]
	@@valid_guesses = PEG_COLORS.map{|color| color[0].capitalize}.join(", ")

	def initialize()
		@code = Code.new(PEG_COLORS)
	end

	def play
		NUMBER_OF_TURNS.times do
			@guess = make_guess
			@result = @code.compare(@guess)
			break if win?
			print "You just got #{@result[:exact_matches]} exact_matches, and "
			print "#{@result[:near_matches]} near matches.\n"
		end
		game_over
	end

	def make_guess
		@guess = ""
		until valid_guess?
			puts "Make a guess!"
			@guess = gets.chomp 
			message
		end
		@guess.upcase
	end

	def valid_guess?
		@guess.length == 4 && @guess =~ /^[#{@@valid_guesses}]/i
	end

	def message
		if valid_guess?
			puts "Lets see..."
		else
			puts "Invalid guess!"
		end
	end

	def win?
		@result[:exact_matches] == 4
	end

	def game_over
		if win?
			puts "Congratulations, you won!!"
		else
			puts "So sorry, but you lost..."
		end
	end

end

mastermind = Game.new
mastermind.play