require 'colorize'

class Vertex
  attr_accessor :prev, :name, :distance, :color
  attr_reader :neighbors, :x, :y, :id

  @@id_counter = 0

  def distance_from(source)
    if self == source
      return 0
    end
    if @prev == nil
      raise "Not connected."
    end
    return 1 + @prev.distance_from(source)
  end

  def estimate_distance(destination)
    (destination.y-@y).abs + (destination.x-@x).abs
  end

  def initialize(options={})
    @id = @@id_counter
    @@id_counter += 1
    @color = nil

    @name = options[:name] || ' '
    @x = options[:x] || 0
    @y = options[:y] || 0

    @neighbors = Hash.new
  end

  def inspect
    "<Node #{id}, #{neighbors.count} neighbors"
  end

  def to_s
    @name.to_s[0].colorize(@color)
  end

  def connect(neighbor)
    neighbor.neighbors[self] = true
    neighbors[neighbor] = true
  end

  def record_path(destination)
    path = []
    node_walker = destination
    while node_walker
      path << node_walker
      node_walker = node_walker.prev
    end
    path.reverse
  end

  def expand_node(queue, heuristic)
    expansion_node = queue.delete(queue.min_by do |v|
      heuristic ? (v.distance + heuristic.call(v)) : 0
    end)
    expansion_node.neighbors.each do |neighbor, thunk|
      if  ( neighbor.distance.nil? ||
           (neighbor.distance > expansion_node.distance + 1) )
        neighbor.distance = expansion_node.distance + 1
        queue.push(neighbor) #insert(0, neighbor)
        neighbor.prev = expansion_node
      end
    end
    expansion_node
  end

  def bfs(destination, heuristic=nil, &blk)
    prev = nil
    @distance = 0
    queue = neighbors.keys
    queue.each do |neighbor|
      neighbor.distance = 1
      neighbor.prev = self
    end
    until destination.distance || queue.empty?
      expansion_node = expand_node(queue, heuristic)
      blk.call(expansion_node) if block_given?
    end
    record_path(destination)
  end

  def self.vertex_from_char(char, idx, idy)
    if char == '*'
      nil
    elsif char == 'E'
      Vertex.new(:x=>idx, :y=>idy, :name=>'END')
    elsif char == 'S'
      Vertex.new(:x=>idx, :y=>idy, :name=>'START')
    else
      Vertex.new(:x=>idx, :y=>idy)
    end
  end

end
