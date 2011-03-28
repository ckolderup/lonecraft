class Minebound < Sinatra::Application

  post '/api/player/join' do #TODO: secure, token-based auth
  end

  post '/api/player/death' do #TODO: secure, token-based auth
    #TODO: POST /death: connect to ec2
   
    #TODO: POST /death: remove current player from whitelist on ec2
  
    #TODO: POST /death: add current player to banlist on ec2
    
    #TODO: POST /death: add current player to past players on ec2, update Game model

    #TODO: POST /death: check if that's it, if so, run endgame

    #TODO: POST /death ...else email the player to direct them to /pass

  end
end
