class Pawn < SteppingPiece

  attr_accessor :moved

  def initialize(board,pos,color)
    super(board,pos,color)
    @moved = false
  end

  def moves
    straight_moves + diagonal_moves
  end

  def to_s
    self.color == :white ? "♙" : "♟"
  end

  private

  def has_moved?
    @moved
  end

  def get_straight_delta
    delta = (@color == :black ? [[1,0]] : [[-1,0]])
    delta += (@color == :black ? [[2, 0]] : [[-2,0]]) unless has_moved?
    delta
  end

  def get_diagonal_delta
    if @color == :black
      [[ 1, -1], [ 1,  1]]
    else
      [[-1,  1], [-1, -1]]
    end
  end

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

end
