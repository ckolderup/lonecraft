class Lonecraft < Sinatra::Application
  get '/api/ec2/test' do #TODO: delete this
  end

  post '/api/player/join' do #TODO: secure, token-based auth
  end

  post '/api/player/death' do #TODO: secure, token-based auth

    @game = Game.current
    @game.cycle
      
    if not @game.finished?
      send_email(@email, "You have died...", erb(:died_email)) 
    end
  end

end
