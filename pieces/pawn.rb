class Pawn < SteppingPiece

  SIDE_DELTAS = [[0,1],[0,-1]]

  def moves
    straight_moves + diagonal_moves + special_moves
  end

  def to_s
    self.color == :white ? "♙" : "♟"
  end

  def special_moves
    moves = []
    SIDE_DELTAS.each do |delta|
      neighbor_space = @pos.add_delta(delta)
      last_board = @board.previous_states[-2]
      next if last_board.nil?
      if @board[neighbor_space].is_a?(Pawn) &&
        last_board[neighbor_space].nil? &&
        last_board[neighbor_space.add_delta(hop_delta)].is_a?(Pawn) &&
        @board[neighbor_space.add_delta(hop_delta)].nil?
        moves << neighbor_space.add_delta(forward_delta)
      end
    end
    moves
  end

  def perform_special_move(end_pos)
    remove_pos = end_pos.remove_delta(forward_delta)
    @board.graveyard << @board[remove_pos]
    @board[remove_pos] = EmptySpace
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
    deltas = []
    deltas << forward_delta
    unless has_moved? || piece_in_front?(forward_delta)
      deltas << hop_delta
    end
    deltas
  end

  def get_diagonal_delta
    SIDE_DELTAS.map { |delta| delta.add_delta(forward_delta) }
  end

  def forward_delta
    (@color == :black ? [-1,0] : [1,0])
  end

  def hop_delta
    (@color == :black ? [-2, 0] : [2,0])
  end

  def piece_in_front?(delta)
    !@board[@pos.add_delta(delta)].nil?
  end

end
