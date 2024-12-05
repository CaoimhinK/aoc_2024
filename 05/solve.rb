rules, manuals = open("./input.txt").read().split("\n\n")

rules = rules.split("\n").map { |line| line.strip.split("|") }
manuals = manuals.split("\n").map { |line| line.strip.split(",") }

@ordering = {}

rules.each do |before, after|
  existing_before = @ordering[before]
  existing_after = @ordering[after]

  @ordering[before] = { before: [], after: [] } if existing_before.nil?
  @ordering[after] = { before: [], after: [] } if existing_after.nil?

  @ordering[before][:after] << after
  @ordering[after][:before] << before
end

def check_manual(manual)
  okay = true

  manual.each_with_index do |page, index|
    before_okay = manual[0...index].all? do |before|
      @ordering[page][:before].include? before
    end
    after_okay = manual[(index + 1)...manual.size].all? do |after|
      @ordering[page][:after].include? after
    end

    unless before_okay && after_okay
      okay = false
      break
    end
  end

  okay
end

middle_page_sum = 0

manuals.each do |manual|
  if check_manual(manual)
    middle_page_sum += manual[(manual.size / 2).floor].to_i
  end
end

puts "Part 1: #{middle_page_sum}"

def swap(manual, i1, i2)
  temp = manual[i1]
  manual[i1] = manual[i2]
  manual[i2] = temp
  manual
end

def bubble_sort(manual)
  n = manual.size
  loop do
    swapped = false
    1.upto(n - 1) do |i|
      if @ordering[manual[i]][:after].include?(manual[i - 1]) || @ordering[manual[i - 1]][:before].include?(manual[i])
        manual = swap(manual, i - 1, i)
        swapped = trueokay
      end
    end
    break unless swapped
  end
  manual
end

middle_page_sum = 0

manuals.each do |manual|
  if !check_manual(manual)
    sorted_manual = bubble_sort(manual)
    middle_page_sum += sorted_manual[(sorted_manual.size / 2).floor].to_i
  end
end

puts "Part 2: #{middle_page_sum}"
