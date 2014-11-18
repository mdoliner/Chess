require_relative 'board'

class Game

  def initialize(board = Board.new)
    @board = board
    players = [HumanPlayer.new(:black), HumanPlayer.new(:white)]
  end

  def run_game
    player_index = 0
    until game_over?
      current_player = players[player_index]
      display_board
      move_from, move_to = current_player.get_move
      begin
        if @board[move_from].color != current_player.color
          raise InvalidMoveError.new "Wrng Color"
        end
        @board.move(move_from, move_to)
      rescue InvalidMoveError => e
        puts "Yo, invalid move: #{e.message}."
        retry
      end
  end

  def game_over?


end
