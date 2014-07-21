class PolyTreeNode
	attr_reader :parent, :value
	def initialize(value)
		@value = value
		@parent = nil
		@children = []
	end

	def children
		# We dup to avoid someone inadvertantly trying to modify our
	    # children directly through the children array.
		@children.dup
	end

	def parent=(parent)
		remove_old_parents_children if has_parent?
		@parent = parent
		@parent._children << self unless @parent.nil?
		self
	end

	def add_child(child_node)
		child_node.parent = self
	end

	def remove_child(child)
		child.parent = nil
	end

	def dfs(value, &prc)
		raise "Need proc" unless block_given?
		return self if prc.call(@value, value)
		return nil if @children == []
		@children.each do |child| 
			node = child.dfs(value, &prc)
			return node unless node.nil?
		end
		nil
	end

	def bfs(value, &prc)
		queue = [] << self
		until queue.empty?
			node = queue.shift
			return node if prc.call(node.value, value)
			queue += node.children
		end
	end

	def trace_path_back

	end

	protected

	def _children
		@children
	end

	def remove_old_parents_children
		@parent._children.delete(self)
	end

	def has_parent?
		!@parent.nil?
	end
end

class KnightPathFinder
	def initialize(from)
		@from = from
		p @visited_positions = [from]
		@move_tree = build_move_tree
	end

	def build_move_tree
		queue = [PolyTreeNode.new(@from)]
		until queue.empty?
			node = queue.shift
			node_children = new_move_positions(node.value).map{|child| PolyTreeNode.new(child)}
			node_children.each{|child| node.add_child(child)}
			queue += node_children
		end
	end

	def find_path(to)

	end

	# protected

	def new_move_positions(pos)
		new_moves = KnightPathFinder::valid_moves(pos).reject{|pos| @visited_positions.include?(pos)}
		@visited_positions += new_moves
		new_moves
	end

	def self.valid_moves(pos)
		valid_moves = []
		([1, 3]).each do |i|
			j = 4 - i
			valid_moves += permute_moves(pos, i, j)	
		end
		valid_moves
	end

	def self.permute_moves(pos, i, j)
		possible_moves = []
		([-1, 1]).each do |px| 
			([-1, 1]).each do |py| 
				new_pos = [pos[0] + px * i, pos[1] + py * j]
				possible_moves << new_pos if is_valid_position?(new_pos)
			end
		end
		possible_moves
	end

	def self.is_valid_position?(pos)
		pos[0] >= 0 && pos[0] < 8 && pos[1] >= 0 && pos[1] < 8
	end

end

kpf = KnightPathFinder.new([0, 0])
# kpf.find_path([7, 6])
# kpf.find_path([6, 2])
