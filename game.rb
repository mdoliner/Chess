require_relative 'board'
require_relative 'human_player'
require 'yaml'

class Game

  def self.load_game(filename)
    load_file = YAML.load_file(filename)
    Game.delete_save(filename) unless filename == "./saves/chess_game_auto_save.sav"
    load_file
  end

  def self.delete_save(filename)
      File.delete(filename)
  end

  def initialize(board = Board.new)
    @board = board
    @board.store_state
    @players = [HumanPlayer.new(:black), HumanPlayer.new(:white)]
    @turn = 1
  end

  def run_game
    until game_over?
      @board.store_state
      play_turn
      auto_save_game
    end
    display_board
    victory_message
    Game.delete_auto_save
  end

  private

  def play_turn
    @current_player = @players[@turn % 2]

    begin
      display_board
      puts "#{@current_player} moves next."
      current_move = @current_player.get_move
      save_game if current_move == :save
      move_from, move_to = current_move
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

  def auto_save_game
    File.write("saves/chess_game_auto_save.sav", YAML.dump(self))
  end

  def save_game
    puts "What is the name of your saved game?"
    filename = "./saves/" + gets.chomp + ".sav"
    File.write(filename, YAML.dump(self))
    abort
  end

end

if __FILE__ == $PROGRAM_NAME
  system('clear')
  if File.exist?('./saves/chess_game_auto_save.sav')
    puts "Would you like to load your previous game?(y/n)"
    if gets.chomp.downcase == "y"
      puts "Which file number would you like to load?"
      Dir["./saves/*.sav"].each.with_index { |file, index| puts "#{index}) #{file}" }
      Game.load_game(Dir["./saves/*.sav"][gets.chomp.to_i]).run_game
    else
      Game.new.run_game
    end
  else
    Game.new.run_game
  end
end
