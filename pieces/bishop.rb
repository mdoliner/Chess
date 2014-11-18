class Bishop < SlidingPiece

  def moves
    diagonal_moves
  end

  def to_s
    self.color == :white ? "♗" : "♝"
  end

end
