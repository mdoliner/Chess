class King < SteppingPiece

  def moves
    possible_moves(STRAIGHT_DELTAS) +
    possible_moves(DIAGONAL_DELTAS)
  end

  def to_s
    self.color == :white ? "♔" : "♚"
  end

  def special_move

  end

  def castle?
    !has_moved?
  end

end
