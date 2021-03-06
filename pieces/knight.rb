class Knight < SteppingPiece

  KNIGHT_DELTAS = [[  1,  2],
                   [  1, -2],
                   [ -1,  2],
                   [ -1, -2],
                   [  2,  1],
                   [  2, -1],
                   [ -2,  1],
                   [ -2, -1]]

  def moves
    possible_moves(KNIGHT_DELTAS)
  end

  def to_s
    self.color == :white ? "♘" : "♞"
  end

end
