location_map = File.readlines("./input.txt").map { |line| line.strip.split("") }

GUARD_CHAR = "^"
OBSTACLE_CHAR = "#"
VISITED_CHAR = "X"

class Direction
  UP = 0
  RIGHT = 1
  DOWN = 2
  LEFT = 3
end

class Guard
  def initialize(location_map)
    @location_map = location_map
    @direction = Direction::UP
    @loop_count = 0
    @thingos = []

    location_map.each_with_index do |row, row_index|
      row.each_with_index do |cell_content, column_index|
        if (cell_content == GUARD_CHAR)
          @row = row_index
          @column = column_index
          break
        end
      end

      if (!@position.nil?)
        break
      end
    end
  end

  def get_neighbour(direction)
    case direction
    when Direction::UP
      @location_map[@row - 1][@column]
    when Direction::RIGHT
      @location_map[@row][@column + 1]
    when Direction::DOWN
      @location_map[@row + 1][@column]
    when Direction::LEFT
      @location_map[@row][@column - 1]
    end
  end

  def walk_to_obstacle(direction)
    case direction
    when Direction::UP
      i = @row - 1
      loop do
        break nil if i <= 0

        char = @location_map[i][@column]

        break @location_map[i - 1][@column] if char == OBSTACLE_CHAR

        i -= 1
      end
    when Direction::RIGHT
      i = @column + 1
      loop do
        break nil if i >= @location_map[@row].size - 1

        char = @location_map[@row][i]

        break @location_map[@row][i + 1] if char == OBSTACLE_CHAR

        i += 1
      end
    when Direction::DOWN
      i = @row + 1
      loop do
        break nil if i >= @location_map.size - 1

        char = @location_map[i][@column]

        break @location_map[i + 1][@column] if char == OBSTACLE_CHAR

        i += 1
      end
    when Direction::LEFT
      i = @column - 1
      loop do
        break nil if i <= 0

        char = @location_map[@row][i]

        break @location_map[@row][i - 1] if char == OBSTACLE_CHAR

        i -= 1
      end
    end
  end

  def look_forward
    get_neighbour(@direction)
  end

  def turn
    @direction = (@direction + 1) % 4
  end

  def walk
    @location_map[@row][@column] = @direction.to_s

    case @direction
    when Direction::UP
      if @row == 0
        true
      else
        @row -= 1
        false
      end
    when Direction::RIGHT
      if @column == @location_map[0].size - 1
        true
      else
        @column += 1
        false
      end
    when Direction::DOWN
      if @row == @location_map.size - 1
        true
      else
        @row += 1
        false
      end
    when Direction::LEFT
      if @column == 0
        true
      else
        @column -= 1
        false
      end
    end
  end

  def make_patrol
    loop do
      finished = loop do
        content = look_forward

        if content == OBSTACLE_CHAR
          turn
        else
          break walk
        end
      end
      at_obstacle = walk_to_obstacle((@direction + 1) % 4)

      if at_obstacle == ((@direction + 2) % 4).to_s
        @loop_count += 1
        @thingos << [@row, @column]
      end

      break if finished
    end
  end

  def count_positions
    @location_map.sum do |row|
      row.count { |char| ["0", "1", "2", "3"].include? (char) }
    end
  end

  def loop_count
    @loop_count
  end

  def draw_path
    @location_map.map.each_with_index do |row, row_index|
      row.map.each_with_index do |char, column_index|
        if @thingos.include?([row_index, column_index])
          "\033[35mX\033[0m"
        elsif ["0", "1", "2", "3"].include?(char)
          thing = case char
            when "0"
              "^"
            when "1"
              ">"
            when "2"
              "v"
            when "3"
              "<"
            end
          "\033[32m#{thing}\033[0m"
        else
          if char == OBSTACLE_CHAR
            "\033[41m#{char}\033[0m"
          else
            char
          end
        end
      end.join("")
    end.join("\n")
  end
end

guard = Guard::new(location_map)

guard.make_patrol

puts "Part 1: #{guard.count_positions}"

puts "Part 2: #{guard.loop_count}" # still wrong
