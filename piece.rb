require 'singleton'



class Piece
  attr_reader :symbol, :pos, :board, :color
  def initialize(pos,board,color)
      @pos = pos
      @board = board
      @moves = []
      @symbol = nil
  end

  def update_pos(pos)
    @pos = pos
    @moves = self.moves
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
      moves_array = []
      if symbol == :rook || symbol == :queen


        # upwards row decreases, column stays the same
        row, col = start_row - 1, start_col
        until row < 0
          if board[[row,col]].symbol != :null
            if board[[row,col]].color != color
              moves_array << [row, col]
              break
            else
              break
            end
          end
          moves_array << [row,col]
          row -= 1
        end
        # downwards row increases, column stays the same
        row, col = start_row + 1, start_col
        until row > 7
          if board[[row,col]].symbol != :null
            if board[[row,col]].color != color
              moves_array << [row, col]
              break
            else
              break
            end
          end
          moves_array << [row,col]
          row += 1
        end
        # left row stays the same, column decreases
        row, col = start_row, start_col - 1
        until col < 0
          if board[[row,col]].symbol != :null
            if board[[row,col]].color != color
              moves_array << [row, col]
              break
            else
              break
            end
          end
          moves_array << [row,col]
          col -= 1
        end
        # right row stays the same, column increases
        row, col = start_row, start_col + 1
        until col > 7
          if board[[row,col]].symbol != :null
            if board[[row,col]].color != color
              moves_array << [row, col]
              break
            else
              break
            end
          end
          moves_array << [row,col]
          col += 1
        end
      end
      if symbol == :queen || symbol == :bishop
        row, col = start_row + 1, start_col + 1
        until row > 7 || col > 7
          if board[[row,col]].symbol != :null
            if board[[row,col]].color != color
              moves_array << [row, col]
              break
            else
              break
            end
          end
          moves_array << [row,col]
          row,col = row + 1, col + 1
        end
        row, col = start_row - 1, start_col - 1
        until row < 0 || col < 0
          if board[[row,col]].symbol != :null
            if board[[row,col]].color != color
              moves_array << [row, col]
              break
            else
              break
            end
          end
          moves_array << [row,col]
          row,col = row - 1, col - 1
        end
        row, col = start_row + 1, start_col - 1
        until row > 7 || col < 0
          if board[[row,col]].symbol != :null
            if board[[row,col]].color != color
              moves_array << [row, col]
              break
            else
              break
            end
          end
          moves_array << [row,col]
          row,col = row + 1, col - 1
        end
        row, col = start_row - 1, start_col + 1
        until row < 0 || col > 7
          if board[[row,col]].symbol != :null
            if board[[row,col]].color != color
              moves_array << [row, col]
              break
            else
              break
            end
          end
          moves_array << [row,col]
          row,col = row - 1, col + 1
        end
      end
      # p moves_array
      @moves = moves_array
    end
  end

  module SteppingPiece
    def moves
      moves_array = []
      start_row, start_col = pos

      move_proc = Proc.new do |offset|
        row = start_row + offset[0]
        col = start_col + offset[1]
        moves_array << [row,col] unless !board.in_bounds?([row,col]) || board[[row, col]].color == color
      end
      if symbol == :knight
        offsets = [
          [2, 1],
          [-2, -1],
          [2, -1],
          [-2, 1],
          [1, 2],
          [-1, -2],
          [1, -2],
          [-1, 2]
        ]
        moves_array.concat(offsets.map(&move_proc))
      elsif symbol == :king
        offsets = [
          [1, 1],
          [-1, -1],
          [1, -1],
          [-1, 1],
          [1, 0],
          [0, 1],
          [-1, 0],
          [0, -1]
        ]
        offsets.each(&move_proc)
      elsif symbol == :pawn
        start_row, start_col = pos
        if color == :white
          # diagonal squares are col -1, col + 1, row -1
          if !board[[start_row - 1, start_col + 1]].nil? &&
              board[[start_row - 1, start_col + 1]].symbol != :null &&
                board[[start_row - 1, start_col + 1]].color != color

            moves_array << [start_row - 1, start_col + 1]
          end
          if !board[[start_row - 1, start_col - 1]].nil? &&
              board[[start_row - 1, start_col - 1]].symbol != :null &&
                board[[start_row - 1, start_col - 1]].color != color
            moves_array << [start_row - 1, start_col - 1]
          end
          if start_row == 6
            row = start_row - 2
            col = start_col
            moves_array << [row, col] unless !board.in_bounds?([row,col]) ||
                board[[row, col]].color == color
          end
          col = start_col
          row = start_row - 1
          moves_array << [row, col] unless !board.in_bounds?([row,col]) ||
            board[[row, col]] != NullPiece.instance
        else
          if !board[[start_row + 1, start_col + 1]].nil? &&
              board[[start_row + 1, start_col + 1]].symbol != :null &&
                board[[start_row + 1, start_col + 1]].color != color
            moves_array << [start_row + 1, start_col + 1]
          end
          if !board[[start_row + 1, start_col - 1]].nil? &&
              board[[start_row + 1, start_col - 1]].symbol != :null &&
                board[[start_row + 1, start_col - 1]].color != color
              moves_array << [start_row + 1, start_col - 1]
          end
          if start_row == 1
            row = start_row + 2
            col = start_col
            moves_array << [row, col] unless !board.in_bounds?([row,col]) ||
              board[[row, col]].color == color
          end
          col = start_col
          row = start_row + 1
          moves_array << [row, col] unless !board.in_bounds?([row,col]) ||
            board[[row, col]] != NullPiece.instance
        end
      end
      @moves = moves_array


    end
  end

  def valid_moves
    # p "blarglefargle"
    dup_board = board.dup
    # p dup_board
    valid_moves_array = []

    i = 0
    while i < @moves.compact.length
      if @moves[i].nil?
        i += 1
        next
      end
      old_thing_at_new_spot = dup_board[@moves[i]]

      dup_board.move_piece!(self.pos, @moves[i])
      if !dup_board.in_check?(color)

        valid_moves_array << @moves[i]

        dup_board.move_piece!(@moves[i], self.pos)

        dup_board[@moves[i]] = old_thing_at_new_spot
        self.update_pos(self.pos)



      else

      end
      i += 1
    end

    # p "BLARGEESDF"
    return valid_moves_array

  end

end

class Rook < Piece
  include SlidingPiece

  def initialize(pos,board,color)
    super
    @symbol = :rook
    @color = color
  end
end

class Queen < Piece
  include SlidingPiece

  def initialize(pos,board,color)
    super
    @symbol = :queen
    @color = color
  end
end

class Bishop < Piece
  include SlidingPiece

  def initialize(pos,board,color)
    super
    @symbol = :bishop
    @color = color
  end
end

class King < Piece
  include SteppingPiece

  def initialize(pos,board,color)
    super
    @symbol = :king
    @color = color
  end
end

class Knight < Piece
  include SteppingPiece

  def initialize(pos,board,color)
    super
    @symbol = :knight
    @color=color

  end
end

class Pawn < Piece
  include SteppingPiece

  def initialize(pos,board,color)
    super
    @symbol = :pawn
    @color=color
  end
end

class NullPiece < Piece
  include Singleton

  attr_reader :color, :moves

  def initialize
    @color = :null
    @symbol = :null
  end
end
