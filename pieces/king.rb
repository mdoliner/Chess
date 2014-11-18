class King < SteppingPiece

  def moves
    possible_moves(STRAIGHT_DELTAS) +
    possible_moves(DIAGONAL_DELTAS)
  end

  def to_s
    self.color == :white ? "♔" : "♚"
  end

end
