class Pawn < SteppingPiece

  attr_accessor :moved

  def initialize(board,pos,color)
    super(board,pos,color)
    @moved = false
    get_dir_delta
  end

  def get_dir_delta
    @pawn_straight_delta = (@color == :black ? [[1,0]] : [[-1,0]])
    @pawn_diagonal_delta = (@color == :black ? [[ 1, -1], [ 1,  1]] :
                                               [[-1,  1], [-1, -1]])
    @pawn_first_delta = (@color == :black ? [[2, 0]] : [[-2,0]])
  end

  def moves
    moves = possible_moves(@pawn_straight_delta)
    moves += possible_moves(@pawn_diagonal_delta).select do |pos|
      !@board[pos].nil? && @board[pos].color != @color
    end
    moves += possible_moves(@pawn_first_delta) unless @moved
  end

end
