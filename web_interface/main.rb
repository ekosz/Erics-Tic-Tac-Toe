require 'sinatra'
require 'json'

require 'tic_tac_toe'

get '/' do
  @game = TicTacToe::Game.new

  erb :index
end

post '/play' do
  board = JSON.parse(params[:board]) if params[:board]

  @player_1, @player_2 = players
  @game = TicTacToe::Game.new(board, *players)
  @game.start

  redirect to(over_url(@game.winner)) if @game.solved?
  redirect to(over_url("nobody")) if @game.cats?

  @player_2 = TicTacToe::ComputerPlayer.new(letter: @player_2.letter)

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

  [player_1, player_2].map { |player| TicTacToe::Player.build(player) }
end
