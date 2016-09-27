require 'set'

class Vertex
  include Enumerable
  attr_accessor :prev, :value, :distance
  attr_reader :neighbors, :id

  def initialize(options = {})
    @id = self.class.get_count
    @value = options[:value] || @id

    @neighbors = {}
  end

  def inspect
    "<Node #{@id}, neighbors [#{@neighbors.keys.map(&:id).join(', ')}]>"
  end

  def to_s
    @value.nil? ? "nil" : @value.to_s
  end

  def directed_connect(neighbor, weight = 1)
    neighbors[neighbor] = weight
  end

  def connect(neighbor, weight = 1)
    directed_connect(neighbor, weight)
    neighbor.directed_connect(self, weight)
  end

  def record_path(dest)
    path = [dest]
    while (node_walker = path.last.prev)
      path << node_walker
    end
    path.reverse
  end

  def each(&prc)
    self.class.bfs(self, nil, &prc)
    self.class.reset(self)
    self
  end

  def self.traverse(start, dest, dq_fn = nil, nq_fn = nil, &blk)
    start.prev = nil
    start.distance = 0
    queue = [start]
    while (vert = self.dequeue(queue, dq_fn))
      blk.call(vert) if block_given?
      return start.record_path(vert) if vert == dest
      vert.neighbors.each do |neighbor, _|
        self.enqueue(queue, vert, neighbor, nq_fn)
      end
    end
    []
  end

  def self.reset(start)
    reset_proc = proc do |queue, parent, child|
      self.reset_enqueue(queue, parent, child)
    end
    self.traverse(start, nil, nil, reset_proc) do |node|
      node.prev = nil
      node.distance = nil
    end
  end

  def self.bfs(start, dest, &blk)
    bfs_proc = proc do |queue, parent, child|
      self.bfs_enqueue(queue, parent, child)
    end
    self.traverse(start, dest, nil, bfs_proc, &blk)
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

  def self.bfs_enqueue(queue, parent, child)
    return if child.distance && child.distance <= parent.distance + 1
    child.distance = parent.distance + 1
    child.prev = parent
    queue << child
  end

  def self.reset_enqueue(queue, _, child)
    return if child.distance.nil?
    queue << child
  end

  @@id_counter = -1

  def self.get_count
    @@id_counter += 1
  end

  def self.reset_count
    @@id_counter = -1
  end
end
