require_relative "utils"

test_input = <<INPUT
2333133121414131402
INPUT

input = open("./input.txt").read()

class FileSystem
  def initialize(input)
    @fs = in_to_fs2(input)
  end

  def checksum
    offset = 0

    @fs.sum do |block|
      block => { type:, size: }

      val = if type == "space"
          0
        else
          block => { id: }

          offset.upto(offset + size - 1).sum * id.to_i
        end

      offset += size

      val
    end
  end

  def defragment_single
    fs1 = fs2_to_fs1(@fs)

    i = 0

    loop do
      content = fs1[i]

      break if content.nil?

      if content == "."
        tail = fs1.pop
        while tail == "."
          tail = fs1.pop
        end
        fs1[i] = tail
      end

      i += 1
    end

    @fs = fs1_to_fs2(fs1)
  end

  def defragment_whole
    max_id = @fs.last[:id].to_i

    max_id.downto(0) do |i|
      block_index = @fs.find_index { |b| b[:id] == i.to_s }
      block = @fs[block_index]

      next if block[:type] == "space"

      0.upto(block_index) do |j|
        other_block = @fs[j]

        if other_block[:type] == "space" && other_block[:size] >= block[:size]
          other_block[:size] -= block[:size]

          @fs.insert(j, block.dup)

          block[:type] = "space"
          block.delete(:id)

          break
        end
      end
    end
  end
end

fs = FileSystem.new(test_input)

fs.defragment_single

puts "Part 1 (Test): #{fs.checksum}"

fs = FileSystem.new(input)

fs.defragment_single

puts "Part 1: #{fs.checksum}"

fs = FileSystem.new(test_input)

fs.defragment_whole

puts "Part 2 (Test): #{fs.checksum}"

fs = FileSystem.new(input)

fs.defragment_whole

puts "Part 2: #{fs.checksum}"
