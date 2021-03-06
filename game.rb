# live cell < 2 neighbors       => dies
# live cell 2 or 3 neighbors    => lives
# live cell with > 3 neighbors  => dies
# dead cell with == 3 neighbors => spawns

class Game
  attr_accessor :grid
  attr_reader :frames

  def initialize(grid, frames: 10)
    @grid   = grid
    @frames = frames
  end

  def run
    (0..frames).each do
      sleep 0.3
      system "clear"
      puts grid.display
      self.grid = grid.next_frame
    end
    grid.display
  end
end

class Grid
  attr_accessor :board
  attr_reader :rows, :cols

  def initialize(rows: 5, cols: 5)
    @rows  = rows
    @cols  = cols
    @board = Array.new(rows) { Array.new(cols, nil) }
    @board = populate_dead_cells(@board)
  end

  def next_frame
    self.board = inform_cells_about_its_neighbors(board)
    self.board = update_cells(board)
    return self
  end

  def update_cells(board)
    board.map do |row|
      row.map { |cell| cell.update; cell }
    end
  end

  def inform_cells_about_its_neighbors(board)
    board.each.with_index do |row, i|
      row.each.with_index do |cell, j|
        neighbor_counter = 0

        # upper row neighbors
        row_is_inside_board = (i-1) >= 0
        col_is_inside_board = (j-1) >= 0
        if row_is_inside_board
          if col_is_inside_board
            neighbor = board[i-1][j-1]
            neighbor_counter += 1 if neighbor&.live?
          end
          neighbor = board[i-1][j]
          neighbor_counter += 1 if neighbor&.live?
          neighbor = board[i-1][j+1]
          neighbor_counter += 1 if neighbor&.live?
        end

        # same row neighbors
        if col_is_inside_board
          neighbor = board[i][j-1]
          neighbor_counter += 1 if neighbor&.live?
        end
        neighbor = board[i][j+1]
        neighbor_counter += 1 if neighbor&.live?

        # lower row neighbors
        if board[i+1]
          if col_is_inside_board
            neighbor = board[i+1][j-1]
            neighbor_counter += 1 if neighbor&.live?
          end
          neighbor = board[i+1][j]
          neighbor_counter += 1 if neighbor&.live?
          neighbor = board[i+1][j+1]
          neighbor_counter += 1 if neighbor&.live?
        end

        cell.neighbors = neighbor_counter
      end
    end
  end

  def display
    result = ""
    board.each do |row|
      result += "|#{row.join('|')}|\n"
    end
    result
  end

  private

  def populate_dead_cells(board)
    board.map do |row|
      row.map { |col| Cell.new }
    end
  end

end

class Cell
  attr_accessor :status, :neighbors

  def initialize(status: :dead, neighbors: 0)
    @status    = status
    @neighbors = neighbors
  end

  def dead?
    return true if status == :dead
    false
  end

  def live?
    return true if status == :live
    false
  end

  def update
    if neighbors < 2 # starvation
      self.status = :dead
    elsif (neighbors == 3) && (status == :dead) # birth
      self.status = :live
    elsif (neighbors > 3) && (status == :live) # overpopulation
      self.status = :dead
    end
  end

  def to_s
    case status
    when :dead then '🤢 '
    when :live then '😀 '
    end
  end
end
