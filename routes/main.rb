class Lonecraft < Sinatra::Application
  
  get '/' do #TODO: add list of recently completed games (and status of current game?)
    haml :index
  end

  get '/lonecraft.css' do
    headers 'Content-Type' => 'text/css; charset=utf-8'
    sass :style
  end

end
