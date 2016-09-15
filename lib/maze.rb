require './vertex.rb'

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
        if cell && cell.name == "START"
          start = cell
        elsif cell && cell.name == "END"
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
        row << Vertex.vertex_from_char(char, idx, idy)
      end
      grid << row
    end
    grid
  end

  def self.connect_grid(grid)
    0.upto(grid.length-1) do |idy|
      0.upto(grid[idy].length-1) do |idx|
        curr = grid[idy][idx]
        if curr
          right = grid[idy][idx+1]
          down = grid[idy+1][idx]
          curr.connect(right) if right
          curr.connect(down) if down
        end
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
      string  << "\n"
    end
    string
  end

  def render
    puts to_s
  end

  def self.test
    scheme = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a

    m = Maze.from_file('maze.txt')
    m.render
    heuristic = nil #Proc.new {|node| node.estimate_distance(m.goal)}
    path = m.start.bfs(m.goal, heuristic ) do |node|
      node.name = node.distance%10
      node.color = :cyan
      m.render
      sleep(1)

    end
    m.render
    path.shift
    path.pop
    path.each do |node|
      node.name = 'X'
      node.color = :green
    end
    m.render
  end
end
