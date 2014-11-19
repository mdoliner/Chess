require_relative 'board'
require_relative 'human_player'
require 'yaml'

class Game

  def self.load_game
    load_file = YAML.load_file('chess_game.sav')
    Game.delete_save
    load_file
  end

  def self.delete_save
    File.delete("chess_game.sav")
  end

  def initialize(board = Board.new)
    @board = board
    @board.store_state
    @players = [HumanPlayer.new(:black), HumanPlayer.new(:white)]
    @turn = 1
  end

  def run_game
    puts "Start run game"
    until game_over?
      @board.store_state
      play_turn
      save_game
    end
    display_board
    victory_message
    Game.delete_save
  end

  private

  def play_turn
    @current_player = @players[@turn % 2]

    begin
      display_board
      puts "#{@current_player} moves next."

      move_from, move_to = @current_player.get_move
      if @board[move_from].nil?
        raise InvalidMoveError.new "That space is empty."
      elsif @board[move_from].color != @current_player.color
        raise InvalidMoveError.new "Wrong Color"
      end
      @board.move(move_from, move_to)
      promote_pawn(move_to)
    rescue InvalidMoveError => e
      puts "Invalid move: #{e.message}"
      sleep(2)
      retry
    end

    @turn += 1
  end

  def promote_pawn(pos)
    color = @current_player.color
    promoted_pawn = @board.promoted_pawn(color)
    if promoted_pawn
      new_piece = @current_player.get_promotion.new(@board, pos, color)
      @board[pos] = new_piece
    end
  end

  def victory_message
    if @board.checkmate?(:white)
      puts "Congrats, black wins in #{@turn} turns!"
    elsif @board.checkmate?(:black)
      puts "Congrats, white wins in #{@turn} turns!"
    else
      puts "Too bad, stalemate. Nobody wins."
    end
  end

  def game_over?
    @board.checkmate?(:white) ||
    @board.checkmate?(:black) ||
    @board.stalemate?
  end

  def display_board
    @board.render
  end

  def save_game
    File.write("chess_game.sav", YAML.dump(self))
  end

end

if __FILE__ == $PROGRAM_NAME
  if File.exist?('chess_game.sav')
    puts "Would you like to load your previous game?(y/n)"
    if gets.chomp.downcase == "y"
      Game.load_game.run_game
    else
      Game.new.run_game
    end
  else
    Game.new.run_game
  end
end
