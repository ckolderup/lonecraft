class Minebound < Sinatra::Application
  
  get '/' do #TODO: add list of recently completed games (and status of current game?)
    haml :index
  end

  ['/games', '/games/:page'].each do |path|
    get path do #TODO: paged list of games
    @page = params[:page] || 1

    end
  end

  get '/game/:id' do #TODO: display list of blog posts for a game and world file download link 
  end

  get '/minebound.css' do
    headers 'Content-Type' => 'text/css; charset=utf-8'
    sass :style
  end

end
