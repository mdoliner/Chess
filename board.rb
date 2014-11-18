require './piece'

class Board

  BOARD_SIZE = 8

  def initialize
    @grid = create_board
  end


  private
  def create_grid
    Array.new (BOARD_SIZE) { Array.new(BOARD_SIZE)}
  end

  def setup_pieces

  end

end
