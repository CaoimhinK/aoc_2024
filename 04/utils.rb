def each_row(ary, &block)
  if block_given?
    ary.each do |row|
      yield row
    end
  else
    ary.each
  end
end

def each_column(ary, &block)
  if block_given?
    ary.transpose.each do |column|
      yield column
    end
  else
    ary.transpose.each
  end
end

def each_diagonal(ary)
  width = ary[0].size
  height = ary.size

  diagonals = { sums: {}, diffs: {} }

  (0...height).each do |row|
    (0...width).each do |column|
      value = ary[row][column]

      diagonals[:sums][row + column] = [] if diagonals[:sums][row + column].nil?
      diagonals[:sums][row + column] << value

      diagonals[:diffs][row - column] = [] if diagonals[:diffs][row - column].nil?
      diagonals[:diffs][row - column] << value
    end
  end

  thing = diagonals.collect { |key, obj| obj.collect { |index, val| val } }.flatten(1)

  if block_given?
    thing.each do |diagonal|
      yield diagonal
    end
  else
    thing.each
  end
end
