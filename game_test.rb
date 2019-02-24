require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'game'

class GameTest < Minitest::Test

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
