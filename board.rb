require './piece'

class Board

  #piece => [x_positions]
  STARTUP_POSITIONS = {
    rook:   [0,7],
    knight: [1,6],
    bishop: [2,5],
    king:   [3],
    queen:  [4],
  }

  STARTUP_COLOR_ROWS = [
    [:black, 0],
    [:white, 7]
  ]

  STARTUP_PAWN_COLOR_ROWS = [
    [:black, 1],
    [:white, 6]
  ]

  BOARD_SIZE = 8

  def initialize
    @grid = create_grid
    setup_pieces
    setup_pawns
  end

  def [] (pos)
    y, x = pos
    @grid[y][x]
  end

  def []=(pos,value)
    y, x = pos
    @grid[y][x] = value
  end

  private
  def create_grid
    Array.new (BOARD_SIZE) { Array.new(BOARD_SIZE)}
  end

  def setup_pieces
    STARTUP_COLOR_ROWS.each do |color, row|
      STARTUP_POSITIONS.each do |piece, col|
        piece_class = piece.to_s.camelize.constantize
        pos = [row,col]
        self[pos] = piece_class.new(self, pos, color)
      end
    end
    nil
  end

  def setup_pawns
    STARTUP_PAWN_COLOR_ROWS.each do |color, row|
      BOARD_SIZE.times do |col|
        pos = [row,col]
        self[pos] = Pawn.new(self, pos, color)
      end
    end
    nil
  end

end
