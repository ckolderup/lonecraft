class Minebound < Sinatra::Application
  get '/api/ec2/test' do #TODO: delete this
  end

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
    
      Pony.mail :to => @email,
              :from => 'no-reply@lonecraft.com',
              :subject => 'You have died...',
              :body => erb(:died_email),
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
      
      @commands = ""
      @commands << "rm bukkit/white-list.txt; "
      @commands << "echo \"#{@u.mc_name}\" >> bukkit/banned-players.txt; "

      ec2_ssh(@commands)
      
    end


  end
end
