# frozen_string_literal: true

##
class MaxCliqueFinder
  def initialize(input)
    connections = parse_connections(input)
    @nodes = create_nodes(connections)
  end

  def parse_connections(input)
    input.split("\n").map { |row| row.split('-') }
  end

  def create_nodes(connections)
    connections.each_with_object({}) do |conn, nodes|
      one, two = conn

      nodes[one] = Node.new(one) unless nodes[one]
      nodes[two] = Node.new(two) unless nodes[two]

      nodes[one] << two
      nodes[two] << one
    end
  end

  def neighbours(node_name)
    @nodes[node_name].connections.to_set
  end

  def triangles_for_key(key)
    @nodes[key].each_conn do |c_node|
      @nodes[c_node].each_conn do |c_node2|
        @nodes[c_node2].each_conn do |candidate|
          yield Set[key, c_node, c_node2] if candidate == key
        end
      end
    end
  end

  def find_triangles
    tris = @nodes.keys.each_with_object(Set.new) do |key, triangles|
      triangles_for_key(key) do |triangle|
        triangles << triangle
      end
    end

    tris.filter { |set| set.any? { |a| a.start_with? 't' } }
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

input = open('./input.txt').read

finder = MaxCliqueFinder.new(input)

puts "Part 1: #{finder.find_triangles.size}"

puts "Part 2: #{finder.find_lan_password}"
