require "io/console"

KEYMAP = {
  " " => :space,
  "h" => :left,
  "j" => :down,
  "k" => :up,
  "l" => :right,
  "w" => :up,
  "a" => :left,
  "s" => :down,
  "d" => :right,
  "\t" => :tab,
  "\r" => :return,
  "\n" => :newline,
  "\e" => :escape,
  "\e[A" => :up,
  "\e[B" => :down,
  "\e[C" => :right,
  "\e[D" => :left,
  "\177" => :backspace,
  "\004" => :delete,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0]
}

class Cursor

  attr_reader :cursor_pos, :board

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
    @board = board
  end

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  private

  def read_char
    STDIN.echo = false # stops the console from printing return values

    STDIN.raw! # in raw mode data is given as is to the program--the system
                 # doesn't preprocess special characters such as control-c

    input = STDIN.getc.chr # STDIN.getc reads a one-character string as a
                             # numeric keycode. chr returns a string of the
                             # character represented by the keycode.
                             # (e.g. 65.chr => "A")

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil # read_nonblock(maxlen) reads
                                                   # at most maxlen bytes from a
                                                   # data stream; it's nonblocking,
                                                   # meaning the method executes
                                                   # asynchronously; it raises an
                                                   # error if no data is available,
                                                   # hence the need for rescue

      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true # the console prints return values again
    STDIN.cooked! # the opposite of raw mode :)

    return input
  end

  KEYMAP = {
    " " => :space,
    "h" => :left,
    "j" => :down,
    "k" => :up,
    "l" => :right,
    "w" => :up,
    "a" => :left,
    "s" => :down,
    "d" => :right,
    "\t" => :tab,
    "\r" => :return,
    "\n" => :newline,
    "\e" => :escape,
    "\e[A" => :up,
    "\e[B" => :down,
    "\e[C" => :right,
    "\e[D" => :left,
    "\177" => :backspace,
    "\004" => :delete,
    "\u0003" => :ctrl_c,
  }


  def handle_key(key)
    case key
    when :up, :down, :right, :left
      update_pos(MOVES[key])
      nil
    when :space
      # p board.destination_square
      return @board.destination_square = cursor_pos.dup unless @board.start_square.nil? || cursor_pos == @board.start_square
      return @board.start_square = cursor_pos.dup if @board.start_square == nil && board[cursor_pos].symbol != :null
      return @board.start_square = nil if cursor_pos == @board.start_square
      # p @board.destination_square
    when :backspace
    when :tab
    when :return
      @board.destination_square = cursor_pos.dup
      # @board.start_square = cursor_pos if @board.start_square == nil
      # @board.start_square = nil if cursor_pos == @board.start_square

    when :newline
    when :escape
    when :delete
    when :ctrl_c
      Process.exit(0)
    end
  end

  def update_pos(diff)
    row_diff, col_diff = diff
    new_row, new_col = @cursor_pos[0] + row_diff, @cursor_pos[1] + col_diff
    if board.in_bounds?([new_row, new_col])
      @cursor_pos[0], @cursor_pos[1] = new_row, new_col
    end
  end
end
