module TicTacToe
  class Board

    SIZE = 3.freeze

    def initialize(grid=nil)
      #[[ nil, nil, nil],
      # [ nil, nil, nil],
      # [ nil, nil, nil]]
      @grid = grid || [ [nil] * SIZE ] * SIZE
    end

    def get_cell(x, y)
      @grid[y][x]
    end

    # Returns the closest middle cell
    def center_cell
      mid = @grid.size/2
      get_cell(mid, mid)
    end

    # Sets the closet middle cell if its not already set
    def center_cell=(letter)
      mid = @grid.size/2
      play_at(mid, mid, letter)
    end

    # Returns the corners of the grid
    def corners
      [@grid[0][0], 
       @grid[0][SIZE-1], 
       @grid[SIZE-1][SIZE-1], 
       @grid[SIZE-1][0]]
    end

    # Returns the corners of the empty cells
    def any_empty_position(&block)
      SIZE.times do |y|
        SIZE.times do |x|
          next if get_cell(x, y)
          yield(x, y)
        end
      end
    end

    # Plays a letter at a position, unless that position has already been taken
    def play_at(x, y, letter)
      # Weird bug I found in ruby 1.9.3-p0
      # Given a @grid of [ [nil,nil,nil], [nil,nil,nil], [nil,nil,nil] ]
      # If you call @grid[0][0] = 'x'
      # I aspect @grid to be [ ['x',nil,nil], [nil,nil,nil], [nil,nil,nil] ]
      # What happens is that @grid is [ ['x',nil,nil], ['x',nil,nil], ['x',nil,nil] ]
      # This is a workaround for that
      inner = @grid[y].clone
      inner[x] ||= letter
      @grid[y] = inner
    end

    # Returns true if the grid is empty
    def empty?
      each_cell do |cell|
        return false if cell
      end
      true
    end

    # Returns true if the grid only has one element
    def only_one?
      counter = 0
      each_cell do |cell|
        counter += 1 if cell
        return false if counter >= 2
      end
      counter == 1
    end

    # Returns true if every cell is set to a value
    def full?
      each_cell do |cell|
        return false unless cell
      end
      true
    end

    # Returns true if the board has a wining pattern
    def solved?
      return true if won_across?
      return true if won_up_and_down?
      return true if won_diagonally?
      false
    end

    def to_s
      output = ["-----------\n"]
      @grid.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          output << "#{cell || ((i*3)+j+1)} | #{"\n" if j==2}"
        end
      end
      output << ["-----------\n\n"]
      output.join
    end

    # Preform a deep clone of the board
    # FIXME: This only works for SIZE=3
    def clone
      Board.new([[@grid[0][0], @grid[0][1], @grid[0][2] ],
                 [@grid[1][0], @grid[1][1], @grid[1][2] ],
                 [@grid[2][0], @grid[2][1], @grid[2][2] ]])
    end

    private 

    def each_cell(&block)
      @grid.each do |row|
        row.each do |cell|
          yield(cell)
        end
      end
    end

    def won_across?(grid = @grid)
      grid.any? do |row|
        winning_group?(row)
      end
    end

    def won_up_and_down?
      won_across?(@grid.transpose)
    end

    def won_diagonally?
      base = (0..@grid.size-1)
      left_to_right = base.collect { |i| @grid[i][i]}
      right_to_left = base.collect { |i| @grid[i][@grid.size-1-i]}
      return true if winning_group?(left_to_right)
      return true if winning_group?(right_to_left)
      false
    end

    def winning_group?(group)
      # Won when none of the cells are nil and they are all the same value
      !group.any? { |cell| cell.nil? } && group.uniq.size == 1
    end

  end
end
