def in_to_fs2(input)
  fs = []

  input.strip.split("").each_slice(2).each_with_index do |file_space, id|
    file_size, space_size = file_space

    fs << { type: "file", id: id.to_s, size: file_size.to_i }
    fs << { type: "space", size: space_size.to_i } unless space_size.nil? || space_size == "0"
  end

  fs
end

def fs1_to_fs2(fs)
  new_fs = []

  fs.each do |id|
    last_item = new_fs.last

    if last_item.nil?
      if id == "."
        new_fs << { type: "space", size: 1 }
      else
        new_fs << { type: "file", id:, size: 1 }
      end
    else
      if id == "." && last_item[:type] == "space" || id == last_item[:id]
        last_item[:size] += 1
      else
        if id == "."
          new_fs << { type: "space", size: 1 }
        else
          new_fs << { type: "file", id:, size: 1 }
        end
      end
    end
  end

  new_fs
end

def fs2_to_fs1(fs)
  fs.reduce([]) { |acc, block| acc + Array.new(block[:size], block[:type] == "space" ? "." : block[:id]) }
end
