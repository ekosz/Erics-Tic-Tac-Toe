require 'sinatra'
require 'json'

require 'tic_tac_toe'

get '/' do
  @game = TicTacToe::Game.new

  erb :index
end

get '/play' do
  board = JSON.parse(params[:board]) if params[:board]

  stuff = {
    board: board,
    first: params[:first],
    x: params[:x],
    o: params[:o]
  }
  @game = TicTacToe::Game.new(stuff).play

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
