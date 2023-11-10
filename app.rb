#himanshu tomar
#email id: ht272@njit.edu

require 'sinatra/base'
require 'sinatra/flash'
require './lib/wordguesser_game.rb'

class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  # Set up game before each request
  before do
    @game = session[:game] || WordGuesserGame.new('')
  end

  # Save game after each request
  after do
    session[:game] = @game
  end

  # Home route redirects to new game
  get '/' do
    redirect '/new'
  end

  # New game route
  get '/new' do
    erb :new
  end

  # Create a new game route
  post '/create' do
    word = params[:word] || WordGuesserGame.get_random_word
    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  # Process guess route
  post '/guess' do
    begin
      letter = params[:guess].to_s[0]
      process_guess(letter)
    rescue ArgumentError
      flash[:message] = "Invalid guess."
    end
    redirect '/show'
  end

  # Show game status route
  get '/show' do
    handle_game_status
  end

  # Win route
  get '/win' do
    redirect '/show' if @game.check_win_or_lose == :play
    erb :win
  end

  # Lose route
  get '/lose' do
    redirect '/show' if @game.check_win_or_lose == :play
    erb :lose
  end

  private

  # Process a guess
  def process_guess(letter)
    guesses_before_guess = @game.guesses
    if !@game.guess(letter)
      flash[:message] = "You have already used that letter."
    elsif guesses_before_guess == @game.guesses
      flash[:message] = "Invalid guess."
    end
  end

  # Handle game status and redirection
  def handle_game_status
    case @game.check_win_or_lose
    when :win
      redirect '/win'
    when :lose
      redirect '/lose'
    else
      erb :show
    end
  end
end

