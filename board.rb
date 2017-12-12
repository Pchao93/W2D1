require 'byebug'
require_relative 'piece'
class InvalidMoveError < StandardError
end


class Board

  # attr_accessor :grid

  STARTING_POSITIONS = {
    [0,0] => "rook"
  }
  attr_accessor :start_square, :destination_square
  def initialize(grid = test_grid)
    @grid = grid
    @start_square = nil
    @destination_square = nil
  end

  def self.empty_grid
    Array.new(8) { Array.new(8) }
  end

  def test_grid
    grid = Board.empty_grid
    grid[0][0] = King.new([0,0], self)
    grid[0][7] = King.new([0,7], self)
    # grid[7][0] = King.new
    # grid[7][7] = King.new
    # grid[0][1] = King.new
    # grid[0][6] = King.new
    # grid[7][1] = King.new
    # grid[7][6] = King.new
    # grid[0][3] = King.new
    # grid[7][3] = King.new
    grid
  end

  def in_bounds?(pos)
    row, col = pos
    row.between?(0, 7) && col.between?(0,7)
  end

  def move_piece(start_pos, end_pos)
    p "I made a move"
    raise InvalidMoveError if start_pos.nil? #instead, check for null piece
    raise InvalidMoveError unless in_bounds?(end_pos)
    p [self[end_pos], self[start_pos]]
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
    p [self[end_pos], self[start_pos]]
    @start_square = nil
    @destination_square = nil
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def each_row(&prc)
    @grid.each(&prc)
  end

  def each_piece(&prc)
    @grid.each do |row|
      row.each do |square|
        prc.call(square)
      end
    end
  end

  def each_col(&prc)
    columns = @grid.transpose
    columns.each(&prc)
  end


end
