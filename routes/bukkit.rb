class Minebound < Sinatra::Application

  post '/api/player/join' do
    #TODO: secure, token-based auth
    #TODO: is this even necessary?
  end

  post '/api/player/quit' do
    #TODO: secure, token-based auth
    #TODO: is this necessary for anything?
  end

  post '/api/player/death' do
    #TODO: secure, token-based auth

    #TODO: scp to MC server, remove current player from whitelist, add current player to banlist
    #TODO: add current player to past players, nil out current player

    #TODO: check if that's it, if so, run endgame

    #TODO: ...else email the player to direct them to /pass
  end

end
