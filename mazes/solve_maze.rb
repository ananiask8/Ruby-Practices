
class Graph
	attr_reader :path
	def initialize(vertices, max_line_length) #vertices are expected as a hash and with absolute index pointers from position 0
		@graph = {:adjacency_list => Hash.new {|h,k| h[k]=[]} , :vertices => [], :dist => []}
		@path = {}
		@graph[:vertices] = vertices
		vertices.each_key do |vertex|
			@graph[:adjacency_list][vertex] << vertex - 1 if vertices.has_key?(vertex - 1)
			@graph[:adjacency_list][vertex] << vertex + 1 if vertices.has_key?(vertex + 1)
			@graph[:adjacency_list][vertex] << vertex - max_line_length if vertices.has_key?(vertex - max_line_length)
			@graph[:adjacency_list][vertex] << vertex + max_line_length if vertices.has_key?(vertex + max_line_length)
		end
	end

	def shortest_path(from, to)
		vertices = @graph[:vertices]
		from = from
		to = to
		queue = []
		@graph[:dist] = Hash.new {|h,k| h[k]=0}
		
		vertices[from] = true
		@graph[:dist][from] = 0
		queue << from

		while !vertices[to] 
			u = queue.pop
			@graph[:adjacency_list][u].each do |v|
				if !vertices[v]
					vertices[v] = true
					@graph[:dist][v] = @graph[:dist][u] + 1
					queue << v
				end
			end
		end
		trace_current_shortest_path(from, to)
		return @graph[:dist][to]
	end

private
	def trace_current_shortest_path(from, to)
		u = to
		while u != from
			@path[u] = '+'
			u_p = u
			@graph[:adjacency_list][u].each{|v| u_p = v if @graph[:dist][v] < @graph[:dist][u_p]}
			u = u_p
		end
	end

end

def get_vertices(file, maze, from_symbol, to_symbol, vertices)
	from = 0
	to = 0
	File.open(file) do |f| 
		f.each_char.with_index do |c, i|
    	vertices[i] = false if c == " " || c == from_symbol || c == to_symbol
    	from = i if c == from_symbol
    	to = i if c == to_symbol
    	maze << c
    end 
	end
	return from, to
end

file = "maze1.txt"
from_symbol = 'S'
to_symbol = 'E'
lines = File.foreach(file).count
max_length = (File.open(file).size) / lines
vertices = {}

maze = ""
from, to = get_vertices(file, maze, from_symbol, to_symbol, vertices)

graph = Graph.new(vertices, max_length)
graph.shortest_path(from, to)


graph.path.each_pair{|k, v| maze[k] = v}
puts maze

# File.open(file, 'w').puts maze