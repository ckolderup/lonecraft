class Lonecraft < Sinatra::Application

  get '/pass' do
    unless logged_in?
      flash[:error] = "You must log in or create an account."
      flash[:vaudeville_hook] = '/pass'
      redirect '/login'
    end

    @u = current_user
    @passable = (Game.current && Game.current.player == @u)
    @token = Game.current.token

    haml :pass
  end

  post '/pass' do
    unless logged_in?
      flash[:error] = "You must log in or create an account."
      flash[:vaudeville_hook] = '/pass'
      redirect '/login', 303
    end

    @u = current_user 
    @email = params[:email]
    
    error 403 unless (Game.current && Game.current.player == @u) #TODO: change this to something informative

    @token = Game.current.token

    send_email(@email, "Lonecraft game token", erb(:token_email))

    flash[:notice] = "Key sent to #{@email}."
    redirect '/pass', 303
  end

  ['/play', '/play/:token'].each do |path|  
    get path do
      unless logged_in?
        flash[:error] = "You must log in or create an account."
        flash[:vaudeville_hook] = '/play'
        flash[:vaudeville_hook] << "/#{params[:token]}" if params[:token]
        redirect '/login'
      end

      @u = current_user 

      @current = false
      
      @current = (Game.current && Game.current.last_round &&
                  Game.current.active? && 
                  Game.current.last_round.user == @u)
      
      if @current
        @mc_server = ENV['GAME_DOMAIN']
      else
        @token = params[:token]
      end

      haml :play
    end
  end

  post '/play' do
    unless logged_in?
      flash[:error] = "You must log in or create an account."
      flash[:vaudeville_hook] = "/play/#{params[:token]}"
      redirect '/login', 303
    end
    @u = current_user 

    error 500 unless Game.current
    error 403 unless Game.current.challenge(params[:token]) #TODO: change this to something informative
    #TODO: verify that the person has not played during this Game
   
    @game = Game.current 
    @game.token = nil
    @newround = Round.create(:started => Time.now, :user => @u)
    @game.rounds << @newround
    @game.save

    Bukkit.white_list(@u.mc_name)

    flash[:notice] = "Success! You are now the active player. Please see the instructions below." 
    redirect '/play', 303
  end

end
