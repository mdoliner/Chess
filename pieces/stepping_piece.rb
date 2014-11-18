require './king'
require './knight'
require './pawn'

class SteppingPiece < Piece

  def possible_moves(deltas)
    moves = []
    deltas.each do |delta|
      new_pos = self.pos.add_delta(delta)
      next if off_board?(new_pos)
      if self.board[new_pos].nil? ||
        self.board[new_pos].color != self.color
        moves << new_pos
      end
    end
    moves
  end

end
