# Checks to see if a certain group of cell qualify as a win condition
class WinningGroupChecker
  def initialize(group)
    @group = group
  end
  
  # Won when none of the cells are nil and they are all the same value
  def won?
    !@group.any? { |cell| cell.nil? } && @group.uniq.size == 1
  end
end
