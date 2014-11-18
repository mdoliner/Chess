class HumanPlayer

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def get_move
    print "Move from: "
    start_pos = gets.chomp.split(" ").map(&:to_i)
    print "Move to: "
    end_pos = gets.chomp.split(" ").map(&:to_i)
    unless start_pos.length == 2 && end_pos.length == 2
      raise InvalidMoveError.new "Use two numbers when making a move!"
    end
    [start_pos, end_pos]
  end

end
