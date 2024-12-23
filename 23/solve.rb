# frozen_string_literal: true

input = open('./input.txt').read

##
class Node
  attr_reader :name, :connections

  def initialize(name)
    @name = name
    @connections = Set[]
  end

  def <<(node)
    @connections << node
  end

  def each_conn(&block)
    @connections.each(&block)
  end

  def inspect
    "#{@name}: #{@connections.map(&:name)}"
  end
end

connections = input.split("\n").map { |row| row.split('-') }

nodes = {}
connections.each do |conn|
  one, two = conn

  node_one = nodes[one]
  node_two = nodes[two]

  nodes[one] = Node.new(one) unless node_one
  nodes[two] = Node.new(two) unless node_two

  node_one = nodes[one]
  node_two = nodes[two]

  node_one << node_two
  node_two << node_one
end

triangles = Set.new

nodes.each_key do |key|
  node = nodes[key]
  node.each_conn do |c_node|
    c_node.each_conn do |c_node2|
      c_node2.each_conn do |candidate|
        triangles << Set[node.name, c_node.name, c_node2.name] if candidate.name == node.name
      end
    end
  end
end

triangles = triangles.filter { |set| set.any? { |a| a.start_with? 't' } }

puts "Part 1: #{triangles.size}"

connections = input.split("\n").map { |row| row.split('-') }

nodes = {}
connections.each do |conn|
  one, two = conn

  node_one = nodes[one]
  node_two = nodes[two]

  nodes[one] = Node.new(one) unless node_one
  nodes[two] = Node.new(two) unless node_two

  node_one = nodes[one]
  node_two = nodes[two]

  node_one << node_two
  node_two << node_one
end

##
class MaxCliqueFinder
  def initialize(nodes)
    @nodes = nodes
  end

  def neighbours(node_name)
    @nodes[node_name].connections.map(&:name).to_set
  end

  def bron_kerbosch(r_set, p_set, x_set, c_set)
    c_set << r_set.to_a if p_set.empty? && x_set.empty? && r_set.size > (2)

    p_set.each do |v|
      bron_kerbosch(r_set | Set[v], p_set & neighbours(v), x_set & neighbours(v), c_set)
      p_set.delete(v)
      x_set << v
    end
  end

  def find_max_cliques
    sets = []
    bron_kerbosch(Set.new, Set.new(@nodes.keys), Set.new, sets)
    sets
  end

  def find_lan_password
    cliques = find_max_cliques
    largest_clique = cliques.max { |set_a, set_b| set_a.size <=> set_b.size }
    largest_clique.sort.join(',')
  end
end

finder = MaxCliqueFinder.new(nodes)

puts "Part 2: #{finder.find_lan_password}"
