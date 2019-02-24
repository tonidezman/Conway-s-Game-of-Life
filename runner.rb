require_relative 'game'

grid = Grid.new(rows: 15, cols: 15)
grid.board[1][1].status = :live
grid.board[3][1].status = :live
grid.board[4][2].status = :live
grid.board[4][3].status = :live
grid.board[4][4].status = :live
grid.board[4][5].status = :live
grid.board[3][5].status = :live
grid.board[2][5].status = :live
grid.board[1][4].status = :live

game = Game.new(grid, frames: 5000)
game.run
