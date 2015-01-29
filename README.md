Chess
==================
###Setup
- Run "ruby game.rb" in your console program of choice

###Controls
- Input a move as a letter-number coordinate pair. For example, a2.

###Rules
- For a detailed explanation of the rules of Chess, please feel free to visit http://www.chess.com/learn-how-to-play-chess
- This program incorporates every possible chess move, from castling to en passent

- To perform a castle (switch the rook and the castle), move the king to where it would be after the castle.

- To save game, type save as your move and follow the instructions

###Requirements
- A console program

###Features
- Sliding/Steppin/Empty Piece superclasses allows for modular code
- Deeply duplicates board to check for valid moves
- Utilizes YAML format to allow for auto-saving and custom save games
- Creates custom errors to provide responsive feedback to invalid moves
