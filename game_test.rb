require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'game'

class GameTest < Minitest::Test

  def test_multiple_frames_all_dead_cells
    grid = Grid.new(rows: 10, cols: 10)
    game = Game.new(grid, frames: 2)
    assert_equal grid.display, game.run
  end

  def test_multiple_frames_all_alive_cells
    grid = Grid.new(rows: 10, cols: 10)
    grid.board.flatten.each { |cell| cell.status = :live }

    game = Game.new(grid, frames: 3)
    all_dead_cells_in_grid = Grid.new(rows: 10, cols: 10)
    assert_equal all_dead_cells_in_grid.display, game.run
  end

  def test_multiple_frames_all_alive_cells
    grid = Grid.new(rows: 10, cols: 10)
    grid.board[0][0].status = :live
    grid.board[1][0].status = :live
    grid.board[0][1].status = :live

    game = Game.new(grid, frames: 3)
    after = ""
    after << "|x|x| | | | | | | | |\n"
    after << "|x|x| | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"

    assert_equal after, game.run
  end

  def test_multiple_frames_all_alive_cells
    grid = Grid.new(rows: 10, cols: 10)
    grid.board[1][1].status = :live
    grid.board[3][1].status = :live
    grid.board[4][2].status = :live
    grid.board[4][3].status = :live
    grid.board[4][4].status = :live
    grid.board[4][5].status = :live
    grid.board[3][5].status = :live
    grid.board[2][5].status = :live
    grid.board[1][4].status = :live

    game = Game.new(grid, frames: 20)
    after = ""
    after << "| | | | | |x|x| | | |\n"
    after << "| | | | | |x|x| | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"

    assert_equal after, game.run
  end

  def test_draw_grid_all_dead_cells
    grid = Grid.new(rows: 3, cols: 3)
    x = ""
    x << "| | | |\n"
    x << "| | | |\n"
    x << "| | | |\n"
    assert_equal x, grid.display
  end

  def test_draw_grid_all_live_cells
    grid = Grid.new(rows: 3, cols: 3)
    grid.board.flatten.each { |cell| cell.status = :live }

    x = ""
    x << "|x|x|x|\n"
    x << "|x|x|x|\n"
    x << "|x|x|x|\n"
    assert_equal x, grid.display
  end

  def test_all_alone_cell_dies
    grid = Grid.new(rows: 3, cols: 3)
    grid.board[1][1].status = :live

    before = ""
    before << "| | | |\n"
    before << "| |x| |\n"
    before << "| | | |\n"

    after = ""
    after << "| | | |\n"
    after << "| | | |\n"
    after << "| | | |\n"
    assert_equal after, grid.next_frame.display
  end

  def test_large_grid
    grid = Grid.new(rows: 10, cols: 10)
    grid.board[2][6].status = :live
    grid.board[3][3].status = :live
    grid.board[3][5].status = :live
    grid.board[4][4].status = :live
    grid.board[4][5].status = :live
    grid.board[4][6].status = :live
    grid.board[5][6].status = :live

    before = ""
    before << "| | | | | | | | | | |\n"
    before << "| | | | | | | | | | |\n"
    before << "| | | | | | |x| | | |\n"
    before << "| | | |x| |x| | | | |\n"
    before << "| | | | |x|x|x| | | |\n"
    before << "| | | | | | |x| | | |\n"
    before << "| | | | | | | | | | |\n"
    before << "| | | | | | | | | | |\n"
    before << "| | | | | | | | | | |\n"
    before << "| | | | | | | | | | |\n"

    after = ""
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | |x| |x| | | |\n"
    after << "| | | | | | |x| | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"
    after << "| | | | | | | | | | |\n"

    assert_equal after, grid.next_frame.display
  end

  def test_only_one_cell_survives
    grid = Grid.new(rows: 3, cols: 3)
    grid.board[0][0].status = :live
    grid.board[0][2].status = :live
    grid.board[1][1].status = :live

    before = ""
    before << "|x| |x|\n"
    before << "| |x| |\n"
    before << "| | | |\n"

    after = ""
    after << "| |x| |\n"
    after << "| |x| |\n"
    after << "| | | |\n"
    assert_equal after, grid.next_frame.display
  end

  def test_every_one_dies_because_overpopulation
    grid = Grid.new(rows: 3, cols: 3)
    grid.board.each do |row|
      row.each { |cell| cell.status = :live }
    end

    before = ""
    before << "|x|x|x|\n"
    before << "|x|x|x|\n"
    before << "|x|x|x|\n"

    after = ""
    after << "|x| |x|\n"
    after << "| | | |\n"
    after << "|x| |x|\n"

    assert_equal after, grid.next_frame.display
  end

  def test_random_live_cells_1
    grid = Grid.new(rows: 3, cols: 3)
    grid.board[0][1].status = :live
    grid.board[1][0].status = :live
    grid.board[1][1].status = :live
    grid.board[1][2].status = :live
    grid.board[2][1].status = :live

    before = ""
    before << "| |x| |\n"
    before << "|x|x|x|\n"
    before << "| |x| |\n"

    after = ""
    after << "|x|x|x|\n"
    after << "|x| |x|\n"
    after << "|x|x|x|\n"

    assert_equal after, grid.next_frame.display
  end


  def test_live_cell_lives_with_2_neighbors
    cell = Cell.new(status: :live, neighbors: 2)
    cell.update
    assert_equal :live, cell.status
  end

  def test_live_cell_lives_with_3_neighbors
    cell = Cell.new(status: :live, neighbors: 3)
    cell.update
    assert_equal :live, cell.status
  end

  def test_live_cell_dies_with_1_neighbor
    cell = Cell.new(status: :live, neighbors: 1)
    cell.update
    assert_equal :dead, cell.status
  end

  def test_live_cell_dies_with_0_neighbors
    cell = Cell.new(status: :live, neighbors: 0)
    cell.update
    assert_equal :dead, cell.status
  end

  def test_dead_cell_spawns_with_3_neighbors
    cell = Cell.new(status: :dead, neighbors: 3)
    cell.update
    assert_equal :live, cell.status
  end

  def test_dead_cell_does_not_spown_with_different_than_3_neighbor_count_1
    cell = Cell.new(status: :dead, neighbors: 2)
    cell.update
    assert_equal :dead, cell.status
  end

  def test_dead_cell_does_not_spown_with_different_than_3_neighbor_count_2
    cell = Cell.new(status: :dead, neighbors: 4)
    cell.update
    assert_equal :dead, cell.status
  end
end
