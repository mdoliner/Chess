require_relative "piece"
require_relative "sliding_piece"
require_relative "stepping_piece"
Dir["./pieces/*.rb"].each {|file| require file }

BOARD_SIZE = 8

class InvalidMoveError < StandardError
end

class Board

  attr_accessor :grid

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

  def initialize (grid = nil)
    if grid.nil?
      @grid = create_grid
      setup_pieces
      setup_pawns
    else
      @grid = grid
    end
  end

  def [] (pos)
    y, x = pos
    @grid[y][x]
  end

  def []=(pos,value)
    y, x = pos[0], pos[1]
    @grid[y][x] = value
  end

  def all_moves(color)
    moves = []
    @grid.flatten.each do |piece|
      next if piece.nil? || piece.color != color
      moves += piece.moves
    end
    moves
  end

  def king_pos(color)
    @grid.flatten.each do |piece|
      return piece.pos if piece.is_a?(King) && piece.color == color
    end
  end

  def in_check?(color)
    all_moves(opp_color(color)).include?(king_pos(color))
  end

  def checkmate?(color)
    @grid.flatten.all? do |piece|
      if piece.nil? || piece.color != color
        true
      else
        piece.valid_moves.empty?
      end
    end
  end

  def opp_color(color)
    color == :black ? :white : :black
  end

  def move(start_pos, end_pos)
    piece = self[start_pos]
    check_for_invalid_moves(piece, end_pos)
    move!(start_pos, end_pos)
  end

  def move!(start_pos, end_pos)
    piece = self[start_pos]
    piece.moved = true if piece.is_a?(Pawn)
    self[start_pos], self[end_pos] = nil, piece
    piece.pos = end_pos
  end

  def render
    system('clear')
    puts "    " + (0...BOARD_SIZE).to_a.join("   ")
    puts "  ╔══" + "═╦══"*(BOARD_SIZE - 1) + "═╗"
    BOARD_SIZE.times do |row|
      puts "#{row} ║ " + @grid[row].join(" ║ ") + " ║"
      next if row == (BOARD_SIZE - 1)
      puts "  ╠══" + "═╬══"*(BOARD_SIZE - 1) + "═╣"
    end
    puts "  ╚══" + "═╩══"*(BOARD_SIZE - 1) + "═╝"
  end

  def dup
    Board.new(@grid.map { |row| row.map(&:dup) })
  end

  def reset_ref
    @grid.flatten.each do |piece|
      piece.board = self unless piece.nil?
    end
  end

  def inspect
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

  def check_for_invalid_moves(piece, end_pos)
    if !piece.valid_moves.include?(end_pos)
      if in_check?(piece.color) && piece.moves.include?(end_pos)
        raise InvalidMoveError.new "That move will keep you in check."
      elsif in_check?(piece.color)
        raise InvalidMoveError.new "You're currently in check."
      elsif piece.moves.include?(end_pos)
        raise InvalidMoveError.new "That move will put you into check."
      else
        raise InvalidMoveError.new "That space is full or invalid."
      end
    end
  end

end
