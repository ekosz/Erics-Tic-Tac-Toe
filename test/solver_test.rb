require 'test_helper'

class SolverTest < MiniTest::Unit::TestCase
  def setup
    @solver = TicTacToe::MinimaxStrategy.new(TicTacToe::Board.new, 'x')
  end

  def test_win_next_move
    refute board.solved?

    # Will win, when there is a winning move
    set_grid([[ 'x', 'x', nil], 
              [ 'o', 'o', nil], 
              [ 'x', 'o', nil] ])
    refute board.solved? # Is not solved yet
    @solver.solve!
    assert !!board.solved?, "Could not solve the board" # Solved it
    assert_equal 'x', board.get_cell(2, 0) # Placed the right letter

    set_grid([[ 'x', 'o', nil], 
              [ nil, 'x', nil], 
              [ 'o', nil, nil] ])
    refute board.solved?
    @solver.solve!
    assert !!board.solved?
    assert_equal 'x', board.get_cell(2, 2)
    
    set_grid([[ 'x', nil, 'o'], 
              [nil,  'o', 'o'], 
              [ 'x', nil, nil] ])
    refute board.solved?
    @solver.solve!
    assert !!board.solved?
    assert_equal 'x', board.get_cell(0, 1)

    # Can not win when there is no winning move
    set_grid([[ 'o', nil, nil], [nil, nil, nil], ['o', nil, nil] ])
    refute board.solved?
    @solver.solve!
    refute board.solved?
  end

  def test_block_next_move
    refute board.solved?

    # Will block when the opponent is about to win
    set_grid([ ['o', 'o', nil], 
               [nil, 'x', nil], 
               [nil, 'x', nil]])
    refute board.solved?
    @solver.solve!
    refute board.solved?
    # Placed the right letter at the right place
    assert_equal 'x', board.get_cell(2, 0) 
  end


  def test_fork_next_move
    refute board.solved?

    # Place letter in place where next turn is an automatic win
    set_grid([ ['x', 'o', 'x'], 
               [nil, nil, 'o'], 
               [nil, nil, nil]])
    refute board.solved?
    @solver.solve!
    refute board.solved?
    correct_cells =  board.get_cell(1, 1) || board.get_cell(0, 2)
    assert !!correct_cells

    # 1 | 2 | x
    # 4 | o | 6
    # 7 | x | 9 <--
    set_grid([ [nil, 'o', 'x'], 
               [nil, 'o', nil], 
               [nil, 'x', nil]])
    refute board.solved?
    @solver.solve!
    refute board.solved?
    assert_equal 'x', board.get_cell(2, 2)
  end

  def test_block_fork_next_move
    # 1 | 2 | o
    # 4 | x | 6
    # o | 8 | 9
    set_grid([[nil,nil,'o'],
              [nil,'x',nil],
              ['o',nil,nil]])
    @solver.solve!
    assert_nil board.get_cell(2,2)
    assert_nil board.get_cell(0,0)

    # x | 2 | 3
    # 4 | o | 6
    # 7 | 8 | o
    set_grid([ ['x',nil,nil], [nil,'o',nil], [nil,nil,'o'] ])
    @solver.solve!
    assert_nil board.get_cell(1, 0)
    assert_nil board.get_cell(0, 1)
    assert_nil board.get_cell(2, 1)
    assert_nil board.get_cell(1, 2)
  end

  #def test_center
  #  # Will play in the center if its an empty board
  #  assert board.empty?
  #  @solver.solve!
  #  assert_equal 'x', board.center_cell
  #  assert board.only_one?
  #end
  #
  #def test_oposite_corner
  #  # 1 | 2 | o
  #  # 4 | x | 6
  #  # 7 | 8 | 9
  #  set_grid([[nil,nil,'o'],[nil,'x',nil],[nil,nil,nil]])
  #  @solver.solve!
  #  assert_equal 'x', board.get_cell(0, 2)

  #  set_grid([['o',nil,nil],[nil,'x',nil],[nil,nil,nil]])
  #  @solver.solve!
  #  assert_equal 'x', board.get_cell(2, 2)
  #end

  def test_empty_corner
    set_grid([[nil,nil,nil],[nil,'o',nil],[nil,nil,nil]])
    @solver.solve!
    played_corner = board.get_cell(0,0) || board.get_cell(0,2) || 
                    board.get_cell(2,0) || board.get_cell(2,2)
    assert played_corner
  end
  
  def test_any_empty_position
    # o | x | o
    # o | x | 6
    # x | o | x
    set_grid([['o', 'x', 'o'],['o','x',nil],['x','o','x']])
    @solver.solve!
    assert_equal 'x', board.get_cell(2, 1)
  end

  private

  def set_grid(grid)
    board.instance_variable_set("@grid", grid)
  end

  def board
    @solver.board
  end
end
