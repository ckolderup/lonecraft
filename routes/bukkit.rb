class Minebound < Sinatra::Application

  post '/api/player/join' do #TODO: secure, token-based auth
  end

  post '/api/player/death' do #TODO: secure, token-based auth

    #TODO: POST /death: update Game model
    
    @round = Game.current.last_round
    @round.finished = Time.now
    @round.save
    
    @u = @round.user

    if (Game.current.rounds.size == 10) then
      #TODO: POST /death: run endgame
    else
      Pony.mail :to => @u.email,
                :form => 'no-reply@kolderup.org',
                :subject => 'Minebound death',
                :body => erb(:died_email)
      
      #TODO: POST /death: connect to ec2
     
      #TODO: POST /death: remove current player from whitelist on ec2
    
      #TODO: POST /death: add current player to banlist on ec2
      
      #TODO: POST /death: add current player to past players on ec2

    end


  end
end
