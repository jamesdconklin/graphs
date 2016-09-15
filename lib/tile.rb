require_relative 'vertex'
require 'colorize'

class Tile < Vertex
  attr_reader :x, :y
  attr_accessor :color

  def initialize(options={})
    @x = options[:x] || 0
    @y = options[:y] || 0
    @color = nil
    super(options)
  end

  # def inspect
  #   "(#{x},#{y})"
  # end

  def to_s
    @value.nil? ? ' ' : @value.to_s[0].colorize(color)
  end

  def estimate_distance(destination)
    (destination.y-@y).abs + (destination.x-@x).abs
  end

  def self.vertex_from_char(char, idx, idy)
    if char == '*'
      nil
    elsif char == 'E'
      self.new(:x=>idx, :y=>idy, :value=>'END')
    elsif char == 'S'
      self.new(:x=>idx, :y=>idy, :value=>'START')
    else
      self.new(:x=>idx, :y=>idy)
    end
  end
end
