class Minebound < Sinatra::Application

  get '/' do
    haml :index
  end

  get '/minebound.css' do
    headers 'Content-Type' => 'text/css; charset=utf-8'
    sass :style
  end

end
