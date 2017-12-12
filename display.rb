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
    @board.each_row do |row|
      printable_row = []
      row.each_with_index do |square,idx|
        square.nil? ? output = "[ ]" : output = "[P]"
        if [i,idx] == @cursor.cursor_pos
          output = output.colorize(:blue)
        end
        if [i,idx] == @board.start_square
          output = output.colorize(:red)
        end
        if [i,idx] == @board.destination_square
          output = output.colorize(:green)
        end
        print output

      end
      i+=1
      puts

    end
    nil
  end

  def test_display
    until false
      # system("clear")
      if board.start_square && board.destination_square
        board.move_piece(board.start_square, board.destination_square)
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
  string = "SDKFLSDLKFHSDLKFHSDF".colorize(:blue)
  p string
  puts(string)
  print(string)

end
