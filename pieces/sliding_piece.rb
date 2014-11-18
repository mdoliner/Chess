class SlidingPiece < Piece

  def straight_moves
    moves = []
    STRAIGHT_DELTAS.each do |delta|
      new_pos = self.pos.add_delta(delta)
      until off_board(new_pos)
        unless self.board[new_pos].nil?
          moves << new_pos unless self.board[new_pos].alignment == self.alignment
          break
        else
          moves << new_pos
        end
        new_pos = new_pos.add_delta(delta)
      end
    end
    moves
  end

  def diagonal_moves

  end
end
