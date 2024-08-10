from constants import *
from Game import *
from Board import *
from AI import *

import sys # to quit the application

# MAIN method
def main():
    # Game object
    game = Game()
    # board object
    board = game.board
    # ai object
    ai = game.ai
    # main loop 
    while True:
        for event in pygame.event.get():
            # Quit the game and program / application
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            if event.type == pygame.MOUSEBUTTONDOWN:
                pos = event.pos
                # This will turn the coordinates of the board in pixels into
                # coordinates of the board by the grid. (0,0), (0,1) and so on...
                row = pos[0] // SQUARE_SIZE
                col = pos[1] // SQUARE_SIZE
                # check if the square on the board is unmarked
                if board.empty_square(row, col):
                    # mark the empty square
                    board.mark_squares(row, col, game.player)
                    # draw the crosses or circles on the board
                    game.draw_figure(row, col)
                    # switch turns 
                    game.next_player()

        if game.gamemode == 'ai' and game.player == ai.player:
            # update the screen
            pygame.display.update()

            # ai methods
            row, col = ai.eval(board)
            # mark the empty square
            board.mark_squares(row, col, ai.player)
            # draw the crosses or circles on the board
            game.draw_figure(row, col)
            # switch turns 
            game.next_player()
            
                
        # Sets the background color
        pygame.display.update()

main()