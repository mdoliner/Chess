require_relative 'board'
require_relative 'human_player'

class Game

  def initialize(board = Board.new)
    @board = board
    @players = [HumanPlayer.new(:white), HumanPlayer.new(:black)]
  end

  def run_game
    turn = 1
    until game_over?
      current_player = @players[turn % 2]
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
      turn += 1
    end
  end

  private

  def game_over?
    @board.checkmate?(:white) || @board.checkmate?(:black)
  end

  def display_board
    @board.render
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
  Game.new.run_game
end
