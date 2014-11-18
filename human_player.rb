class HumanPlayer

  def initialize(color)
    @color = color
  end

  def get_move
    print "Move from: "
    start_pos = gets.chomp.split(" ").map(&:to_i)
    print "Move to: "
    end_pos = gets.chomp.split(" ").map(&:to_i)
    [start_pos, end_pos]
  end

end
