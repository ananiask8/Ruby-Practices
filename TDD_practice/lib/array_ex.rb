class Array
  def my_uniq
    result = []
    self.each{|element| result << element unless result.include?(element)}
    result
  end

  def two_sum
    h = Hash.new { |h, k| h[k] = []}
    self.each_with_index{|element, i| h[element] << i}
    result = []
    self[0..self.size / 2].each_with_index do |element, i|
      if h[-element].size > 0
        h[-element].each do |complement_index|
          result << [i, complement_index] if i < complement_index
        end
      end
    end
    result
  end

  def my_transpose
    result = Array.new(self[0].size){Array.new(self.size)}
    self.each_with_index{|row, j| self[j].each_with_index{|element, i| result[i][j] = element}}
    result
  end

  def stock_picker
    max = -1.0/0.0
    max_index = self.size - 1
    max_difference = -1.0/0.0
    best_pair = []

    self.reverse.each_with_index do |element, i|
      max, max_index = element, self.size - 1 - i if element > max

      if max - element > max_difference
        best_pair = [self.size - 1 - i, max_index]
        max_difference = max - element
      end
    end
    best_pair
  end
end
