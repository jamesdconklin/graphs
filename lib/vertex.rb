require 'set'

class Vertex
  attr_accessor :prev, :value, :distance
  attr_reader :neighbors, :id

  @@id_counter = -1

  def self.get_count
    @@id_counter += 1
  end

  def self.reset_count
    @@id_counter = -1
  end

  def initialize(options={})
    @id = @@id_counter
    @@id_counter += 1
    @value = options[:value]

    @neighbors = Hash.new
  end

  def inspect
    "<Node #{@id}, neighbors [#{@neighbors.keys.map(&:id).join(', ')}]"
  end

  def to_s
    @value.nil? ? "nil" : @value.to_s
  end

  def connect(neighbor, weight=1)
    neighbor.neighbors[self] = weight
    neighbors[neighbor] = weight
  end

  def record_path(dest)
    path = [dest]
    while (node_walker = path.last.prev)
      path << node_walker
    end
    path.reverse
  end

  def self.enqueue(queue, parent, child, nq_fn = nil)
    if nq_fn
      nq_fn.call(queue, parent, child)
    elsif child.distance.nil? ||
          child.distance > parent.distance + parent.neighbors[child]
      child.prev = parent
      child.distance = parent.distance + parent.neighbors[child]
      queue << child
    end
  end

  def self.dequeue(queue, dq_fn = nil)
    dq_fn ? dq_fn.call(queue) : queue.shift
  end

  def self.traverse(start, dest, dq_fn = nil, nq_fn = nil, &blk)
    start.prev, start.distance = nil, 0
    queue = [start]
    while (vert = self.dequeue(queue, dq_fn))
      blk.call(vert) if block_given?
      vert.neighbors.each do |neighbor, weight|
        if neighbor == dest
          neighbor.prev, neighbor.distance = vert, vert.distance + weight
          blk.call(neighbor) if block_given?
          return start.record_path(neighbor)
        end
        self.enqueue(queue, vert, neighbor, nq_fn)
      end
    end
    []
  end
end
