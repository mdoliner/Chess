require './sliding_piece'
require './stepping_piece'

class Piece

  BOARD_SIZE = 8
  STRAIGHT_DELTAS = [[1,0], [0,1], [-1,0], [0,-1]]
  DIAGONAL_DELTAS = [[1,1], [-1,-1], [1, -1], [-1,1]]

  attr_reader :pos

  def initialize(board, pos, color)
    @board, @pos, @color = board, pos, color
  end

  def moves
    raise "Didn't implement moves function."
  end

  def off_board?(pos)
    pos.all? { |num| num.between?(0,BOARD_SIZE - 1) }
  end

end


class Array
  def add_delta(delta)
    [self[0] + delta[0], self[1] + delta[1]]
  end
endp
