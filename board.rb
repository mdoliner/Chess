require_relative "piece"
require_relative "sliding_piece"
require_relative "stepping_piece"
Dir["./pieces/*.rb"].each {|file| require file }

BOARD_SIZE = 8

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
    y, x = pos[0], pos[1]
    @grid[y][x] = value
  end

  private
  def create_grid
    Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE)}
  end

  def setup_pieces
    STARTUP_COLOR_ROWS.each do |color, row|
      STARTUP_POSITIONS.each do |piece, columns|
        columns.each do |col|
          piece_class = piece.to_s.capitalize
          pos = [row,col]
          self[pos] = (Object.const_get(piece_class)).new(self, pos, color)
        end
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
