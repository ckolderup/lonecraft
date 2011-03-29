require 'sinatra'
require 'data_mapper'
require 'haml'
require 'sass'
require 'rack'
require 'rack-flash'
require 'pony'

use Rack::Session::Cookie #TODO: make cookie last more than just the session
use Rack::Flash

require_relative 'models/init'
require_relative 'routes/init'

