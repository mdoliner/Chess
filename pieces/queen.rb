class Queen < SlidingPiece

  def moves
    straight_moves + diagonal_moves
  end

  def to_s
    self.color == :white ? "♕" : "♛"
  end

end
