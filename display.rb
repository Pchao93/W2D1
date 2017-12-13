require "colorize"
require_relative "board"
require_relative "cursor"
require 'byebug'

class Display
  attr_reader :board

  def initialize(board=Board.new)
    @board = board
    @cursor = Cursor.new([0,0],board)
  end

  def render
    @board[@cursor.cursor_pos].to_s.colorize(:blue)
    i=0
    p "black"
    @board.each_row_with_index do |row, row_idx|
      printable_row = []
      row.each_with_index do |square,idx|

        piece = board[[row_idx, idx]]
        case piece.color
        when :white
          case piece.symbol
          when :king
            piece_string = "\u2654"
          when :pawn
            piece_string = "\u2659"
          when :rook
            piece_string = "\u2656"
          when :bishop
            piece_string = "\u2657"
          when :queen
            piece_string = "\u2655"
          when :knight
            piece_string = "\u2658"
          end
        when :black
          case piece.symbol
          when :king
            piece_string = "\u265a"
          when :pawn
            piece_string = "\u265f"
          when :rook
            piece_string = "\u265c"
          when :bishop
            piece_string = "\u265d"
          when :queen
            piece_string = "\u265b"
          when :knight
            piece_string = "\u265e"
          end
        when :null
          piece_string = " "
        end


        left_bracket = "["
        right_bracket = "]"

        if row_idx.even?
          if idx.even?
            left_bracket = "[".colorize(:light_white)
            right_bracket = "]".colorize(:light_white)
            background = :light_white
          else
            background = :light_black
          end
        else
          if !idx.even?
            left_bracket = "[".colorize(:white)
            right_bracket = "]".colorize(:white)
            background = :light_white
          else
            background = :light_black
          end
        end
        if [i,idx] == @board.start_square
          left_bracket, right_bracket = left_bracket.colorize(:red), right_bracket.colorize(:red)
        elsif [i,idx] == @cursor.cursor_pos && !@board.start_square.nil?
          left_bracket, right_bracket = left_bracket.colorize(:green), right_bracket.colorize(:green)
        elsif [i,idx] == @cursor.cursor_pos
          left_bracket, right_bracket = left_bracket.colorize(:blue), right_bracket.colorize(:blue)
        end

        output = left_bracket + piece_string + right_bracket

        print output.colorize(:background => background)

      end
      i+=1
      puts

    end
    p "white"
    nil
  end

  def test_display
    until false
      system("clear")

      if board.start_square && board.destination_square
        begin
          board.move_piece(board.start_square, board.destination_square)
          if board.in_check?(:black) || board.in_check?(:white)
            puts"check!"
            if board.checkmate?(:black) || board.checkmate?(:white)
              puts "checkmate bitches"
            end
          end
        rescue InvalidMoveError => e
          puts e.message
          @board.start_square = nil
          @board.destination_square = nil
        end
      end
      self.render
      @cursor.get_input
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  d = Display.new
  d.test_display
end

def test_colorize
  string = "SDKFLSDLKFHSDLKFHSDF".colorize(:white)

  p [string]
  p string
  puts(string)
  print(string)

end
