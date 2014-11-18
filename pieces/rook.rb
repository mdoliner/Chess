class Rook < SlidingPiece

  def moves
    straight_moves
  end

  def to_s
    self.color == :white ? "♖" : "♜"
  end

end
