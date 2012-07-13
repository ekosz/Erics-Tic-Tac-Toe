module TicTacToe
  # This implements the Minimax algorithum with AlphaBeta Prunning
  # http://en.wikipedia.org/wiki/Minimax
  # http://en.wikipedia.org/wiki/Alpha-beta_pruning
  class MinimaxStrategy

    attr_reader :board # Avoid getters, setters and properties

    def initialize(board, letter)
      @board, @letter = board, letter
    end

    def solve!
      state = Minimax::GameState.new(@board, @letter)
      column, row = 
        Minimax::GameTree.new(Minimax::TicTacToeEvaluator, state).best_move
      @board.play_at(column, row, @letter)
    end
  end
  
  module Minimax

    # A move has a location, and a new state
    class GameMove
      attr_reader :location # Avoid getters, setters and properties

      def initialize(location, new_state)
        @location, @state = location, new_state
      end

      # Delegates to GameState
      def method_missing(method, *args, &block)
        return @state.send(method, *args, &block) if @state.respond_to?(method)
        super
      end

    end

    # Represents a state of the game
    # A state has a board,
    # A player trying to win,
    # and someones turn
    #
    # This class uses 3 instance variables: @board, @player, @whos_turn
    # Should be 2
    class GameState
      def initialize(board, player, whos_turn=nil)
        @board, @player = board, player
        @whos_turn = whos_turn || player
      end

      def over?
        @board.full? || @board.solved?
      end

      def won?
        @board.winner == @player # Demeter law violation
      end

      def lost?
        @board.solved? && !won? # Demeter law violation?
      end

      def each_child
        children.each { |child| yield(child) } # Demeter law violation
      end

      def children
        @board.any_empty_position.map do |column, row| # Demeter law violation
          new_state = GameState.new(
            @board.clone.play_at(column, row, @whos_turn), 
            @player, 
            next_turns_player)
          GameMove.new([column, row], new_state)
        end
      end

      private 

      def next_turns_player
        case @whos_turn
        when X then O
        when O then X
        end
      end
    end

    # The is the evaluator class for the game TicTacToe
    # Its score method returns 
    #  1: The player won
    #  0: Cats game
    # -1: The player lost
    class TicTacToeEvaluator
      def self.score(state)
        return  1 if state.won?
        return -1 if state.lost?
        0
      end
    end

    # Represents a tree of desitions for the game
    # The game tree needs a evaluator for generating rankings,
    # an initial game state,
    # and a player
    #
    # This class uses 5 instance variables: @evaluator, @state, 
    # @depth, @alpha, @beta. Should be < 3
    #
    # This class has 63 lines. Should be <= 50
    class GameTree
      MAXDEPTH = 5
      PositiveInfinity = +1.0/0.0 
      NegativeInfinity = -1.0/0.0 

      # has 5 parameters (LongParameterList)
      def initialize(evaluator, state, depth=1, 
                     alpha=NegativeInfinity, beta=PositiveInfinity)
        @evaluator = evaluator
        @state, @depth = state, depth
        @alpha, @beta = alpha, beta
      end

      def best_move
        maximized_move[0].location # Demeter law violation
      end

      private 

      # has approx 6 statements (LongMethod)
      def maximized_move
        best_move, best_depth = nil, PositiveInfinity

        @state.each_child do |child|

          score, depth = generate_score(child, :minimized_move)

          if score > @alpha || (score == @alpha && depth < best_depth)
            # Functions should only have one level of indentation
            @alpha, best_move, best_depth = score, child, depth
          end

          break if @alpha >= @beta || @depth >= MAXDEPTH

        end

        [best_move, @alpha, best_depth]
      end

      # has approx 6 statements (LongMethod)
      def minimized_move
        best_move, best_depth = nil, PositiveInfinity

        @state.each_child do |child| # Demeter law violation
          score, depth = generate_score(child, :maximized_move)

          if score < @beta || (score == @beta && depth < best_depth)
            # Functions should only have one level of indentation
            @beta, best_move, best_depth = score, child, depth
          end

          break if @beta <= @alpha || @depth >= MAXDEPTH

        end

        [best_move, @beta, best_depth]
      end

      def generate_score(state, method)
        return [@evaluator.score(state), @depth] if state.over?

        move, score, depth = 
          GameTree.new(@evaluator, state, @depth+1, @alpha, @beta).send(method)

        [score, depth]
      end
    end
  end
end

