require_relative "piece"
require_relative "sliding_piece"
require_relative "stepping_piece"
Dir["./pieces/*.rb"].each {|file| require file }

class InvalidMoveError < StandardError
end

class Board

  BOARD_SIZE = 8

  attr_accessor :grid

  #piece => [x_positions]
  STARTUP_POSITIONS = {
    rook:   [0,7],
    knight: [1,6],
    bishop: [2,5],
    king:   [4],
    queen:  [3],
  }

  STARTUP_COLOR_ROWS = [
    [:black, 7],
    [:white, 0]
  ]

  STARTUP_PAWN_COLOR_ROWS = [
    [:black, 6],
    [:white, 1]
  ]

  PAWN_PROMOTION_ROW = {
    black: 0,
    white: 7
  }

  def initialize(grid = nil)
    if grid.nil?
      @grid = create_grid
      setup_pieces
      setup_pawns
    else
      @grid = grid
    end
  end

  def [](pos)
    y, x = pos
    @grid[y][x]
  end

  def []=(pos,value)
    y, x = pos[0], pos[1]
    @grid[y][x] = value
  end

  def all_moves(color)
    moves = []
    all_pieces_of_color(color).each do |piece|
      moves += piece.moves
    end
    moves
  end

  def find_king(color)
    all_pieces_of_color(color).each do |piece|
      return piece if piece.is_a?(King)
    end
  end

  def in_check?(color)
    all_moves(opp_color(color)).include?(find_king(color).pos)
  end

  def pawn_promotion?(color)
    all_pieces_of_color(color).each do |piece|
      if piece.is_a?(Pawn) &&
        piece.pos.first == ROW_PROMOTION_ROW[opp_color(color)]
        return piece
      end
    end
  end

  def checkmate?(color)
    all_pieces_of_color(color).all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def opp_color(color)
    color == :black ? :white : :black
  end

  def move(start_pos, end_pos)
    piece = self[start_pos]
    check_for_invalid_moves(piece, end_pos)
    if piece.special_moves.include?(end_pos)
      piece.perform_special_move(end_pos)
    end
    move!(start_pos, end_pos)
  end

  def move!(start_pos, end_pos)
    piece = self[start_pos]
    piece.moved = true
    self[start_pos], self[end_pos] = EmptySpace, piece
    piece.pos = end_pos
  end

  def render
    system('clear')
    puts "    " + ('a'..'h').to_a.join("   ")
    puts "  ╔══" + "═╦══"*(BOARD_SIZE - 1) + "═╗"
    BOARD_SIZE.times do |row|
      puts "#{row + 1} ║ " + @grid[row].join(" ║ ") + " ║"
      next if row == (BOARD_SIZE - 1)
      puts "  ╠══" + "═╬══"*(BOARD_SIZE - 1) + "═╣"
    end
    puts "  ╚══" + "═╩══"*(BOARD_SIZE - 1) + "═╝"
  end

  def dup
    dup_board = Board.new(@grid.map { |row| row.map(&:dup) })
    dup_board.reset_ref
  end

  def reset_ref
    all_pieces.each do |piece|
      piece.board = self unless piece.nil?
    end
    self
  end

  def inspect
  end

  private
  def create_grid
    Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) {EmptySpace}}
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

  def all_pieces
    @grid.flatten
  end

  def all_pieces_of_color(color)
    all_pieces.select { |piece| piece.color == color }
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
        raise InvalidMoveError.new "That move is invalid. (or the space is full.)"
      end
    end
  end

end
