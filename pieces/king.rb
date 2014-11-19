class King < SteppingPiece

  def moves
    possible_moves(STRAIGHT_DELTAS) +
    possible_moves(DIAGONAL_DELTAS) +
    special_moves
  end

  def to_s
    self.color == :white ? "♔" : "♚"
  end

  def special_moves
    castle_left_move + castle_right_move
  end

  def perform_special_move(end_pos)
    row = end_pos[0]
    if end_pos == [row, 2]
      @board.move!([row,0],[row,3])
    elsif end_pos == [row, 6]
      @board.move!([row,7],[row,5])
    end
    nil
  end

  private

  def castle_left?
    row = @pos[0]
    rook = @board[[row,0]]
    return false if rook.nil?
    !self.has_moved? &&
    !rook.has_moved? &&
    @board[[row,1]].nil? &&
    @board[[row,2]].nil? &&
    @board[[row,3]].nil?
  end

  def castle_left_move
    row = @pos[0]
    if castle_left? && !move_into_check?([row,3])
      [[@pos[0], 2]]
    else
      []
    end
  end

  def castle_right?
    row = @pos[0]
    rook = @board[[row,7]]
    return false if rook.nil?
    !self.has_moved? &&
    !rook.has_moved? &&
    @board[[row,5]].nil? &&
    @board[[row,6]].nil?
  end

  def castle_right_move
    row = @pos[0]
    if castle_right? && !move_into_check?([row,5])
      [[@pos[0], 6]]
    else
      []
    end
  end


end
