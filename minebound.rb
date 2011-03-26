require 'sinatra'
require 'data_mapper'
require 'haml'
require 'sass'
require 'rack'
require 'rack-flash'

use Rack::Session::Cookie #TODO: make cookie last more than just the session
use Rack::Flash

##### MODELS #####

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/minebound.db")

class User
  include DataMapper::Resource
  property :id, Serial
  property :email, Text, :unique => true, :required => true
  property :passhash, BCryptHash
  property :mc_name, Text
  property :admin,  Boolean, :default => false
 
  belongs_to :game, :required => false

  def password=(pass)
    @password = pass
    self.passhash = BCrypt::Password.create(@password, :cost=> 10)
  end

  def self.authenticate(email, pass)
    user = User.first(:email => email)
    return nil if user.nil?
    return user if BCrypt::Password.new(user.passhash) == pass
  end

end

class Game
 include DataMapper::Resource
 property :id, Serial
 property :started, DateTime
 property :finished, DateTime
 property :worldfile_url, URI
 property :curr_token, UUID
 has 1, :curr_user, 'User'
 has n, :already_played, 'User'
end

DataMapper.auto_upgrade!

##### GAMEPLAY #####

get '/pass' do
  #TODO: get list of tokens they need to pass on, offer to email it to someone but suggest other options
end

get '/play' do
  unless logged_in?
    flash[:error] = "You must log in or create an account."
    redirect '/login'
  end

  #TODO: confirm minecraft username
  #TODO: inform the person of the rules
  #TODO: tell them to make sure to come back when they die
end

post '/play' do
  unless logged_in?
    flash[:error] = "You must log in or create an account."
    redirect '/login', 303
  end

  #TODO: cash in the token (params[:token])
  #TODO: go to MC server, add username to whitelist.txt
end

##### USER ACCOUNT MANAGEMENT #####

def logged_in?
  session[:u_id] != nil
end


get '/logout' do
  session[:u_id] = nil
  flash[:notice] = "You've been logged out."
  redirect '/login'
end

get '/login' do
  haml :login
end

post '/login' do
  #TODO: make this HTTPS
  if user = User.authenticate(params[:email], params[:password])
    session[:u_id] = user.id
    redirect '/account', 303
  else
    flash[:error] = "Incorrect username or password."
    redirect '/login', 303
  end
end

get '/account' do
  unless logged_in?
    flash[:error] = "You must be logged in"
    redirect '/login'
  end

  @u = User.first( :id => session[:u_id] )

  haml :account
end

post '/account' do
  #TODO: make this HTTPS
  unless logged_in?
    flash[:error] = "You must be logged in"
    redirect '/login', 303
  end

  @u = User.first( :id => session[:u_id] )
  @u.mc_name = params[:mc_name] unless params[:mc_name].nil?
  @u.email = params[:email] unless params[:email].nil?
  
  unless params[:password].nil?
    unless params[:password] == params[:password2]
      flash[:error] = "Passwords did not match. Try again."
      redirect '/account', 303
    end
    @u.password = params[:password]
  end

  error 400 unless @u.valid?
  error 503 unless @u.save

  flash[:notice] = "Account details updated."
  redirect '/account', 303
end

get '/signup' do
  haml :signup
end

post '/signup' do
  #TODO: make this HTTPS
  unless params[:password].eql? params[:password2]
    flash[:error] = "Passwords did not match. Try again."
    redirect '/signup', 303
  end

  @u = User.new :email => params[:email],
                :password => params[:password]
  @u.mc_name = params[:mc_name] unless params[:mc_name].nil?

  unless @u.valid?
    @u.errors.each do |e|
      puts e
    end
  end

  error 400 unless @u.valid?
  error 503 unless @u.save

  session[:u_id] = @u.id
  redirect '/account', 303
end

get '/confirm/:token' do
  #TODO: offer to confirm the account 
end

post '/confirm' do
  #TODO: actually confirm the account
end

##### MISCELLANEOUS FUNCTIONALITY #####

get '/admin' do
  #TODO: the status of the current game
  #TODO: option to ban current player and redirect to /pass (generates a game token)
  #TODO: put a form field under completed games to store the download URL
end

get '/' do
  haml :index
end

get '/minebound.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :style
end

##### SPLASH SERVER INTEGRATION #####

post '/api/player/join' do
  #TODO: secure, token-based auth
  #TODO: is this even necessary?
end

post '/api/player/quit' do
  #TODO: secure, token-based auth
  #TODO: is this necessary for anything?
end

post '/api/player/death' do
  #TODO: secure, token-based auth

  #TODO: scp to MC server, remove current player from whitelist, add current player to banlist
  #TODO: add current player to past players, nil out current player

  #TODO: check if that's it, if so, run endgame

  #TODO: ...else email the player to direct them to /pass
end

