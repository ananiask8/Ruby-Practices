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
		@visited_positions = [from]
		@move_tree = build_move_tree
	end

	def build_move_tree
	
	end

	def find_path(to)

	end

	protected

	def new_move_positions

	end

	def self.valid_moves(pos)

	end

end

kpf = KnightPathFinder.new([0, 0])
kpf.find_path([7, 6])
kpf.find_path([6, 2])
