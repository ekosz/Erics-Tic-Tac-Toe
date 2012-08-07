require 'sinatra'
require 'json'

require 'tic_tac_toe'

helpers do
  def player_json(letter, type="human", move=nil)
    {letter: letter, type: type, move: move}.to_json
  end
end

get '/' do
  @game = TicTacToe::Game.new

  erb :index
end

post '/play' do
  board = JSON.parse(params[:board]) if params[:board]

  @game = TicTacToe::Game.new(board, *players)

  redirect to(over_url(@game.winner)) if @game.solved?
  redirect to(over_url("nobody")) if @game.cats?

  erb :play
end

get '/over' do
  @grid = JSON.parse params[:board]
  erb :over
end

def over_url(winner)
  "/over?board=#{URI.escape @game.grid.to_json}&winner=#{winner}"
end

def players
  player_1 = JSON.parse(params[:player_1])
  player_2 = JSON.parse(params[:player_2])

  [player_1, player_2].map { |player| Player.build(player) }
end

class Player
  def self.build(params)
    case params['type']
    when 'human' then TicTacToe::HumanPlayer.new(params)
    else 
      TicTacToe::ComputerPlayer.new(params)
    end
  end
end


