require_relative 'tile'

class Maze
  attr_reader :start, :goal, :grid

  def initialize(grid)
    @grid = grid
    @start, @goal = find_ends
  end

  def find_ends
    start, goal = nil, nil
    @grid.each do |row|
      row.each do |cell|
        if cell && cell.value == "START"
          start = cell
        elsif cell && cell.value == "END"
          goal = cell
        end
      end
    end
    [start, goal]
  end

  def self.grid_from_file(file_name)
    grid = []
    File.foreach(file_name).with_index do |line, idy|
      row = []
      line.chomp.scan(/./).each.with_index do |char, idx|
        row << Tile.vertex_from_char(char, idx, idy)
      end
      grid << row
    end
    grid
  end

  def self.connect_grid(grid)
    0.upto(grid.length - 1) do |idy|
      0.upto(grid[idy].length - 1) do |idx|
        curr = grid[idy][idx]
        next unless curr
        right = grid[idy][idx + 1]
        down = grid[idy + 1][idx]
        curr.connect(right) if right
        curr.connect(down) if down
      end
    end
  end

  def self.from_file(file_name)
    grid = Maze.grid_from_file(file_name)
    Maze.connect_grid(grid)
    Maze.new(grid)
  end

  def to_s
    string = ""
    @grid.each do |row|
      row.each do |cell|
        string << (cell ? cell.to_s : '*')
      end
      string << "\n"
    end
    string
  end

  def render
    puts to_s
  end

  def self.test
    m = Maze.from_file('files/maze2.txt')
    m.render
    heuristic = nil # Proc.new {|node| node.estimate_distance(m.goal)}
    path = Vertex.traverse(m.start, m.goal) do |node|
      node.value = node.distance % 10
      node.color = [:red, :green, :yellow][node.distance / 10]
      m.render
      sleep(0.2)

    end
    m.render
    path.shift
    path.pop
    path.each do |node|
      # node.value = 'X'
      node.color = :cyan
    end
    m.render
  end
end
