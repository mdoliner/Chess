class Queen < SlidingPiece

  def moves
    straight_moves + diagonal_moves
  end

end
