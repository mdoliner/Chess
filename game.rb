require_relative 'board'
require_relative 'human_player'
require 'yaml'

class Game

  def self.load_game
    YAML.load_file('chess_game.sav')
  end

  def initialize(board = Board.new)
    @board = board
    @players = [HumanPlayer.new(:white), HumanPlayer.new(:black)]
  end

  def run_game
    @turn = 1
    until game_over?
      current_player = @players[@turn % 2]
      begin
        display_board
        puts "#{current_player.color.to_s.capitalize} moves next."
        move_from, move_to = current_player.get_move
        if @board[move_from].nil?
          raise InvalidMoveError.new "That space be empty."
        elsif @board[move_from].color != current_player.color
          raise InvalidMoveError.new "Wrong Color"
        end
        @board.move(move_from, move_to)
      rescue InvalidMoveError => e
        puts "Yo, invalid move: #{e.message}"
        sleep(2)
        retry
      end
      @turn += 1
      save_game
    end
  end


  private

  def game_over?
    @board.checkmate?(:white) || @board.checkmate?(:black)
  end

  def display_board
    @board.render
  end

  def save_game
    File.write("chess_game.sav", YAML.dump(self))
  end

end

class NilClass
  def to_s
    " "
  end

  def dup
    nil
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
