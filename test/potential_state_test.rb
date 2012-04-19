require 'test_helper'

class PotentialStateTest < MiniTest::Unit::TestCase
  def setup
    TicTacToe::PotentialState.instance_eval { attr_accessor :board }
    @state = TicTacToe::PotentialState.new(TicTacToe::Board.new, 'x')
  end

  def test_solved
    set_grid([ ['x', 'x', 'x'], [nil, nil, nil], [nil, nil, nil] ])
    assert @state.solved?
  end

  def test_fork_exsits
    set_grid([ ['x', nil, 'x'], [nil, 'x', nil], [nil, nil, nil] ])
    assert @state.fork_exsits?

    set_grid([ ['x', nil, 'x'], [nil, 'o', nil], ['x', nil, nil] ])
    assert @state.fork_exsits?

    set_grid([ ['o', nil, 'o'], [nil, 'x', nil], ['o', nil, nil] ])
    refute @state.fork_exsits?
    
  end

  def test_forking_positions
    # o | 2 | x | 
    # 4 | o | 6 | 
    # x | 8 | 9 | 
    set_grid([ ['o', nil, 'x'], [nil, 'o', nil], ['x', nil, nil] ])
    assert @state.forking_positions.size == 1
  end

  def test_can_win_next_turn
    set_grid([[ 'x', nil, 'x'], [nil, nil, nil], [nil, nil, nil] ])
    assert @state.can_win_next_turn?

    # 1 | 2 | x
    # 4 | o | 6
    # 7 | x | x
    set_grid([[ nil, nil, 'x'], [nil, 'o', nil], [nil, 'x', 'x'] ])
    assert @state.can_win_next_turn?

    # o | 2 | x | 
    # 4 | o | 6 | 
    # x | 8 | 9 | 
    set_grid([ ['o', nil, 'x'], [nil, 'o', nil], ['x', nil, nil] ])
    refute @state.can_win_next_turn?
  end

private

  def set_grid(grid)
    @state.board.instance_variable_set("@grid", grid)
  end
end
