class HumanPlayer

  COL_LETTER_TO_NUM = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7
  }

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def get_move
    print "Move from: "
    start_pos = convert(gets.chomp.split(""))

    print "Move to: "
    end_pos = convert(gets.chomp.split(""))
    unless start_pos.length == 2 && end_pos.length == 2
      raise InvalidMoveError.new "Use a letter and a number when making a move!"
    end
    [start_pos, end_pos]
  end

  def convert(array)
    col = COL_LETTER_TO_NUM[array[0].downcase]
    row = array[1].to_i - 1
    unless row.is_a?(Fixnum) && col.is_a?(Fixnum)
      raise InvalidMoveError.new "Use letter-number coordinates! I.e. a5"
    end
    [row, col]
  end

end
