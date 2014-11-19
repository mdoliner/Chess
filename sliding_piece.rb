require './piece'

class SlidingPiece < Piece

  def possible_moves(deltas)
    moves = []
    deltas.each do |delta|
      new_pos = self.pos.add_delta(delta)
      until off_board?(new_pos)
        unless self.board[new_pos].nil?
          moves << new_pos unless self.board[new_pos].color == self.color
          break
        else
          moves << new_pos
        end
        new_pos = new_pos.add_delta(delta)
      end
    end
    moves
  end

  def straight_moves
    possible_moves(STRAIGHT_DELTAS)
  end

  def diagonal_moves
    possible_moves(DIAGONAL_DELTAS)
  end

end
