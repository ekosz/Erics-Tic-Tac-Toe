module TicTacToe
  class HumanPlayer

    attr_reader :letter

    def initialize(letter, interface)
      @letter, @interface = letter, interface
    end

    def get_move(board)
      @interface.new(board).get_move_from_user
    end
  end
end
