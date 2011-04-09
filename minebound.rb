require 'sinatra'
require 'data_mapper'
require 'haml'
require 'sass'
require 'rack'
require 'rack-flash'
require 'pony'

use Rack::Session::Cookie #TODO: make cookie last more than just the session
use Rack::Flash

def ec2_ssh (commands) #TODO: make this more ruby-like (array of commands instead of string, handle the "; " between each element)
  system("ssh -i #{ENV['EC2_KEYFILE']} ec2-user@#{ENV['GAME_DOMAIN']} \"#{commands}\"") 
end

require_relative 'models/init'
require_relative 'routes/init'

