class Lonecraft < Sinatra::Application
  post '/api/player/join' do
  end

  post '/api/player/death' do
    error 400 unless params[:secret] 
    error 403 unless ENV['SPLASH_KEY'] == params[:secret]
    
    @game = Game.current
    @game.cycle
    @game.save
      
    if not @game.finished?
      send_email( :to => @game.player.email, :subject => "You have died...", :body => erb(:died_email)) 
    end
  end

end
