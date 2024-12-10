require "set"

class Node
  attr_accessor :row, :col, :height

  def initialize(row, col, height)
    @row = row
    @col = col
    @height = height
  end

  def inspect
    [@row, @col, @height].inspect
  end

  def hash
    [@row, @col, @height].hash
  end

  def eql?(node)
    node.row == @row && node.col == @col && node.height == height
  end
end

class TrailMap
  def initialize(map, use_filter = true)
    @trail_map = map
    @width = map[0].size
    @height = map.size
    @use_filter = use_filter
    @possible_trailsheads = map.each_with_index.reduce([]) do |acc, row_with_index|
      row, row_index = row_with_index
      acc + row.each_with_index.map do |height, column_index|
        if height == 0
          Node.new(row_index, column_index, height)
        else
          nil
        end
      end
    end.compact
  end

  def possible_trailsheads
    @possible_trailsheads
  end

  def in_bounds?(node)
    node.row >= 0 && node.row < @height && node.col >= 0 && node.col < @width
  end

  def create_node(row, col)
    map_row = @trail_map[row]
    Node.new(row, col, !map_row.nil? && map_row[col])
  end

  def check_neighbours(node)
    north = create_node(node.row - 1, node.col)
    south = create_node(node.row + 1, node.col)
    east = create_node(node.row, node.col + 1)
    west = create_node(node.row, node.col - 1)
    [north, east, south, west].select { |n| in_bounds?(n) && n.height == node.height + 1 }
  end

  def find_trail_score(trailhead)
    score = 0
    nodes_to_check = [trailhead]

    visited = Set.new()

    while nodes_to_check.size > 0
      node = nodes_to_check.pop

      visited << node

      if node.height == 9
        score += 1
        next
      end

      neighbours = check_neighbours(node).filter { |n| !@use_filter || !visited.include?(n) }

      nodes_to_check += neighbours
    end

    # puts render_map(visited)

    score
  end

  def render_map(visited)
    @trail_map.each_with_index.map do |row, row_index|
      row.each_with_index.map do |height, col_index|
        if visited.include?(Node.new(row_index, col_index, height))
          "\e[32m#{height}\e[0m"
        else
          height.to_s
        end
      end.join("")
    end.join("\n")
  end

  def get_trail_score_sum
    @possible_trailsheads.sum { |trailhead| find_trail_score(trailhead) }
  end
end

test_input = <<INPUT
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
INPUT

test_map = test_input.split("\n").map { |row| row.split("").map(&:to_i) }

input = File.readlines("./input.txt", chomp: true)

map = input.map { |row| row.split("").map(&:to_i) }

trail_map = TrailMap.new(test_map)

puts "Part 1 (Test): #{trail_map.get_trail_score_sum}"

trail_map = TrailMap.new(map)

puts "Part 1: #{trail_map.get_trail_score_sum}"

trail_map = TrailMap.new(test_map, false)

puts "Part 2 (Test): #{trail_map.get_trail_score_sum}"

trail_map = TrailMap.new(map, false)

puts "Part 2: #{trail_map.get_trail_score_sum}"
