require './king'
require './knight'

class SteppingPiece < Piece

  def possible_moves(deltas)
    moves = []
    deltas.each do |delta|
      new_pos = self.pos.add_delta(delta)
      next if off_board?(new_pos)
      if self.board[new_pos].nil? ||
         self.board[new_pos].alignment != self.alignment
        moves << new_pos
      end
    end
    moves
  end

end
