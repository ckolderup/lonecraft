require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'haml'
require 'sass'
require 'rack'
require 'rack-flash'

#use Rack::Session::Cookie
#use Rack::Flash
  
use OmniAuth::Builder do
  provider :twitter, "CONSUMER_KEY", "CONSUMER_SECRET"
  provider :facebook, "APP_ID", "APP_SECRET"
end

def logged_in?
  current_user != nil
end
 
class User
  include DataMapper::Resource
  property :id, Serial
  property :email, Text
  property :passhash, BCryptHash
  property :mc_name, Text
  property :admin,  Boolean, default => false
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

get '/auth/:provider/callback' do
  auth = request.env['omniauth.auth']
  "Thanks, #{auth['user_info']['name']}! Next I'll make it so that this will log you in or prompt you to fill in info!"
  #TODO: compare to users, if found, send to login
end

get '/logout' do
  #session[:u_id] = nil
  flash[:notice] = "You've been logged out."
  redirect '/login'
end

get '/login' do
  haml :login
end

post '/login' do
  if user = User.authenticate(params[:username], params[:password])
    #session[:u_id] = user.id
    redirect '/account'
  else
    info[:notice] = "Incorrect username or password."
    redirect '/login'
  end
end

get '/account' do
  unless logged_in?
    info[:notice] = "You must be logged in"
    redirect '/login'
  end

  #TODO: user control panel: offer to let them use a game token, store their minecraft username for later, send out/retrieve a game token
end

get '/play/:token' do
  unless logged_in?
    info[:notice] = "You must log in or create an account."
    redirect '/login'
  end

  #TODO: cash in the token
end

post '/signup' do
  #TODO: create a user
end

get '/confirm/:token' do
  #TODO: offer to confirm the account 
end

post '/confirm' do
  #TODO: actually confirm the account
end

get '/admin' do
  #TODO: show a list of games/status of those games
  #TODO: put a form field under completed games to store the download URL
end
get '/' do
  "Nothing here yet"
end
