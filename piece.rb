require 'singleton'

class Piece
  attr_reader :symbol
  def initialize(pos, board)
      @pos = pos
      @board = board
      @moves = []
      @symbol = nil
  end

  def moves
  end

  def valid_moves
  end

  def empty?
  end

  def to_s
    "piece"
  end



  def move_into_check(to_pos)
  end

  module SlidingPiece
    def moves
      start_row,start_col = pos
      if symbol == :rook || symbol == :queen
        (0..7).each do |idx|
          moves << [start_row,idx] unless idx == start_col
          moves << [idx,start_col] unless idx == start_row
        end
      else
        row, col= start_row + 1, start_col + 1
        until row > 7 || col > 7
          break if board[row,col].symbol != :null
          moves << [row,col]
          row,col = row + 1, col + 1
        end
        row, col= start_row - 1, start_col - 1
        until row < 0 || col < 0
          break if board[row,col].symbol != :null
          moves << [row,col]
          row,col = row - 1, col - 1
        end
        row, col= start_row + 1, start_col - 1
        until row > 7 || col < 0
          break if board[row,col].symbol != :null
          moves << [row,col]
          row,col = row + 1, col - 1
        end
        row, col= start_row - 1, start_col + 1
        until row < 0 || col > 7
          break if board[row,col].symbol != :null
          moves << [row,col]
          row,col = row - 1, col + 1
        end
      end
    end
  end

  module SteppingPiece
    def moves
      start_row, start_col = pos
      if symbol == :knight
        moves << [start_row + 2, col + 1] unless board[start_row + 2, col + 1] != :null
        moves << [start_row - 2, col - 1] unless board[start_row - 2, col - 1] != :null
        moves << [start_row + 2, col - 1] unless board[start_row + 2, col - 1] != :null
        moves << [start_row - 2, col + 1] unless board[start_row - 2, col + 1] != :null
        moves << [start_row + 1, col + 2] unless board[start_row + 1, col + 2] != :null
        moves << [start_row - 1, col - 2] unless board[start_row - 1, col - 2] != :null
        moves << [start_row + 1, col - 2] unless board[start_row + 1, col - 2] != :null
        moves << [start_row - 1, col + 2] unless board[start_row - 1, col + 2] != :null
      elsif symbol == :king
        moves << [start_row + 1, col + 1] unless board[start_row + 1, col + 1] != :null
        moves << [start_row + 1, col + 1] unless board[start_row + 1, col + 1] != :null
        moves << [start_row + 1, col - 1] unless board[start_row + 1, col - 1] != :null
        moves << [start_row - 1, col + 1] unless board[start_row - 1, col + 1] != :null
        moves << [start_row, col + 1] unless board[start_row, col + 1] != :null
        moves << [start_row, col - 1] unless board[start_row, col - 1] != :null
        moves << [start_row + 1, col] unless board[start_row + 1, col] != :null
        moves << [start_row - 1, col] unless board[start_row - 1, col] != :null
      elsif symbol == :pawn
        start_row, start_col = pos
        if color == :white
          if in_start_row?
            moves << [start_row + 2, col] unless board[start_row + 2, col] != :null
          end
          moves << [start_row + 1, col] unless board[start_row + 1, col] != :null
        else
          if in_start_row?
            moves << [start_row - 2, col] unless board[start_row - 2, col] != :null
          end
          moves << [start_row - 1, col] unless board[start_row - 1, col] != :null
        end
      end
    end
  end

end

class King < Piece
  include SteppingPiece

  def initialize(pos,board)
    super
    @symbol = :king
  end
end

class NullPiece < Piece
  include Singleton

  attr_reader :color, :moves

  def initialize
    @color = :grey
    @symbol = :null
  end
end
