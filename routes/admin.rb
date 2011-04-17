class Lonecraft < Sinatra::Application

  get '/admin' do #TODO: admin control panel: ban players, add worldfile download urls, etc
    haml :admin
  end

  post '/admin/game/:id/URL' do
    error 403 unless User.logged_in && User.current.admin?
    
    @game = Game.get(params[:id])
    error 200 unless params[:worldfile]
    @game.worldfile = params[:worldfile]
  end

  post '/admin/game/:id/cycle' do
    error 403 unless User.logged_in && User.current.admin?
    Game.current.cycle
    send_email(User.current.email, "Lonecraft game token", erb(:token_email))
  end
  
  post '/admin/game/reset' do
    error 403 unless User.logged_in && User.current.admin?

    @oldgame = Game.current
    @newgame = Game.create

    send_email(User.current.email, "Lonecraft game token", erb(:token_email))
  end
end

