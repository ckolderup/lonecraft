require 'sinatra'
require 'data_mapper'
require 'haml'
require 'sass'
require 'rack'
require 'rack-flash'
require 'pony'
require 'rdiscount'

use Rack::Session::Cookie #TODO: make cookie last more than just the session
use Rack::Flash

def send_email(options)
  return false unless options[:to] && options[:subject] && options[:body]
  Pony.mail :to => options[:to],
            :from => "no-reply@#{ENV['EMAIL_DOMAIN']}", 
            :subject => options[:subject],
            :body => options[:body],
            :via => :smtp,
            :via_options => {
              :address => 'smtp.gmail.com',
              :port => 587,
              :enable_starttls_auto => true,
              :user_name => ENV['EMAIL_USER'],
              :password => ENV['EMAIL_PASS'],
              :authentication => :plain,
              :domain => ENV['EMAIL_DOMAIN']
            }
  return true
end

require_relative 'models/init'
require_relative 'routes/init'

