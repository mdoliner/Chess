class Pawn < SteppingPiece

  SIDE_DELTA = [[0,1],[0,-1]]

  def moves
    straight_moves + diagonal_moves
  end

  def to_s
    self.color == :white ? "♙" : "♟"
  end

  private

  def straight_moves
    possible_moves(get_straight_delta).select do |pos|
      @board[pos].nil?
    end
  end

  def diagonal_moves
    possible_moves(get_diagonal_delta).select do |pos|
      !@board[pos].nil? && @board[pos].color != @color
    end
  end

  def get_straight_delta
    delta = forward_delta
    unless has_moved? || piece_in_front?(delta.first)
      delta += hop_delta
    end
    delta
  end

  def get_diagonal_delta
    SIDE_DELTA.map { |delta| delta.add_delta(forward_delta.flatten) }
  end

  def forward_delta
    (@color == :black ? [[-1,0]] : [[1,0]])
  end

  def hop_delta
    (@color == :black ? [[-2, 0]] : [[2,0]])
  end

  def piece_in_front?(delta)
    !@board[@pos.add_delta(delta)].nil?
  end

end
