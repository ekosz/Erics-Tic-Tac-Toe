module TicTacToe
  class GamePresentor

    def initialize(game)
      @game = game
    end

    def grid
      @game.grid.each_with_index.map do |row, i|
        row.each_with_index.map do |cell, j|
          cell || ((i*3)+(j+1)).to_s
        end
      end
    end
  end
end
