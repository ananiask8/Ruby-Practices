require 'Set'

class WordChainer
	def initialize(dictionary_file_name)
		@dictionary = Set.new File.read(dictionary_file_name).split(%r{\s})
	end

	def adjacent_words(word)
		@adjacent = Set.new
		word.length.times do |i|
			filter = "#{word.dup[0...i]}.#{word.dup[i + 1...word.length]}"
			@adjacent.merge @dictionary.clone.select!{|word| word.match(/^#{filter}$/)}
		end
		@adjacent
	end

	def run(source, target)
		@current_words = Set.new [source]
		@all_seen_words = {source => nil}

		until @current_words.empty? || @all_seen_words.include?(target)
			explore_current_words
		end
		p build_path(target)
	end

	protected

	def explore_current_words
		new_current_words = Set.new []
		@current_words.each do |current_word|
			adjacent_words(current_word).each do |adjacent_word|
				unless @all_seen_words.include?(adjacent_word)
					@all_seen_words[adjacent_word] = current_word
					new_current_words << adjacent_word
				end
			end
		end
		@current_words = new_current_words
		new_current_words.each{|word| puts "#{word} came from #{@all_seen_words[word]}"}
	end

	def build_path(target)
		path = [target]
		path << @all_seen_words[path.last] until path.last.nil?
		path
	end
end

dict_path = '../projects/dictionary.txt'
chainer = WordChainer.new(dict_path)
# p chainer.adjacent_words('gain')
chainer.run('gain', 'stain')
