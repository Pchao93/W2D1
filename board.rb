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
    Array.new(8) { Array.new(8, NullPiece.instance) }
  end

  def test_grid
    grid = Board.empty_grid
    grid[1][0] = Pawn.new([1,0], self, :black)
    grid[1][1] = Pawn.new([1,1], self, :black)
    grid[1][2] = Pawn.new([1,2], self, :black)
    grid[1][3] = Pawn.new([1,3], self, :black)
    grid[1][4] = Pawn.new([1,4], self, :black)
    grid[1][5] = Pawn.new([1,5], self, :black)
    grid[1][6] = Pawn.new([1,6], self, :black)
    grid[1][7] = Pawn.new([1,7], self, :black)
    grid[6][0] = Pawn.new([6,0], self, :white)
    grid[6][1] = Pawn.new([6,1], self, :white)
    grid[6][2] = Pawn.new([6,2], self, :white)
    grid[6][3] = Pawn.new([6,3], self, :white)
    grid[6][4] = Pawn.new([6,4], self, :white)
    grid[6][5] = Pawn.new([6,5], self, :white)
    grid[6][6] = Pawn.new([6,6], self, :white)
    grid[6][7] = Pawn.new([6,7], self, :white)
    grid[0][7] = King.new([0,7], self, :white)
    grid[0][4] = King.new([0, 4], self, :black)
    grid[7][4] = King.new([7, 4], self, :white)
    grid[0][3] = Queen.new([0, 3], self, :black)
    grid[7][3] = Queen.new([7, 3], self, :white)
    grid[0][1] = Knight.new([0, 1], self, :black)
    grid[0][6] = Knight.new([0, 6], self, :black)
    grid[7][1] = Knight.new([7, 1], self, :white)
    grid[7][6] = Knight.new([7, 6], self, :white)
    grid[0][0] = Rook.new([0, 0], self, :black)
    grid[0][7] = Rook.new([0, 7], self, :black)
    grid[7][7] = Rook.new([7, 7], self, :white)
    grid[7][0] = Rook.new([7, 0], self, :white)
    grid[0][2] = Bishop.new([0, 2], self, :black)
    grid[0][5] = Bishop.new([0, 5], self, :black)
    grid[7][2] = Bishop.new([7, 2], self, :white)
    grid[7][5] = Bishop.new([7, 5], self, :white)

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

    raise InvalidMoveError, "no piece at start" if self[start_pos].nil? #instead, check for null piece
    raise InvalidMoveError unless in_bounds?(end_pos)
    piece = self[start_pos]
    self.each_piece do |p|
      p.update_pos(p.pos)
    end
    p piece.valid_moves.nil?

    if piece.valid_moves.include?(end_pos)

      # p [self[end_pos], self[start_pos]]
      self[end_pos] = piece
      self[start_pos] = NullPiece.instance
    else
      raise InvalidMoveError, "not a valid move"
    # p [self[end_pos], self[start_pos]]
    end
    piece.update_pos(end_pos)
    self.each_piece do |p|
      p.update_pos(p.pos)
    end

    @start_square = nil
    @destination_square = nil
  end

  def move_piece!(start_pos, end_pos)
    piece = self[start_pos]


    self[end_pos] = piece
    self[start_pos] = NullPiece.instance

  end

  def [](pos)
    row, col = pos
    if row < 0 || col < 0
      return nil
    # elsif row > 7 || col > 7
    #   return nil
    end

    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def each_row(&prc)
    @grid.each(&prc)
  end

  def each_row_with_index(&prc)
    @grid.each_with_index(&prc)
  end

  def each_piece(&prc)
    @grid.each do |row|
      row.each do |square|
        prc.call(square)
      end
    end
    self
  end

  def map(&prc)
    result = []
    @grid.each do |row|
      row.each do |square|
        result << prc.call(square)
      end
    end
    result
  end

  def each_col(&prc)
    columns = @grid.transpose
    columns.each(&prc)
  end

  def in_check?(color)
    total_possible_moves = []
    king_position = nil
    self.each_piece do |piece|
      if piece == NullPiece.instance
        next
      end
      piece.update_pos(piece.pos)
      total_possible_moves.concat(piece.moves.compact)
      if piece.symbol == :king && piece.color == color
        king_position = piece.pos
      end
    end

    return total_possible_moves.include?(king_position)
  end

  def dup
    dup_board = Board.new(Board.empty_grid)

    self.each_piece do |piece|
      case piece.symbol
      when :null
        next
      when :king
        dup_piece = King.new(piece.pos, dup_board, piece.color)
      when :queen
        dup_piece = Queen.new(piece.pos, dup_board, piece.color)
      when :bishop
        dup_piece = Bishop.new(piece.pos, dup_board, piece.color)
      when :knight
        dup_piece = Knight.new(piece.pos, dup_board, piece.color)
      when :rook
        dup_piece = Rook.new(piece.pos, dup_board, piece.color)
      when :pawn
        dup_piece = Pawn.new(piece.pos, dup_board, piece.color)
      end
      dup_board[piece.pos] = dup_piece
    end

    dup_board

  end

  def checkmate?(color)
    if in_check?(color)
      valid_moves = []
      self.each_piece do |piece|
        valid_moves = piece.valid_moves
      end
      return valid_moves.empty?
    end
    false
  end


end
