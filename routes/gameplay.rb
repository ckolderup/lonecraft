class Lonecraft < Sinatra::Application

  get '/pass' do
    unless logged_in?
      flash[:error] = "You must log in or create an account."
      flash[:vaudeville_hook] = '/pass'
      redirect '/login'
    end

    @u = User.first :id => session[:u_id]
    @passable = (Game.current && Game.current.player == @u)

    haml :pass
  end

  post '/pass' do
    unless logged_in?
      flash[:error] = "You must log in or create an account."
      flash[:vaudeville_hook] = '/pass'
      redirect '/login', 303
    end

    @u = User.first :id => session[:u_id]
    @email = params[:email]
    
    error 403 unless (Game.current && Game.current.player == @u) #TODO: change this to something informative

    @token = Game.current.token

    Pony.mail :to => @email,
              :from => 'no-reply@kolderup.org', 
              :subject => 'Lonecraft game token',
              :body => erb(:token_email),
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

      @u = User.first :id => session[:u_id]
      @current = (Game.current && Game.current.player == @u)
      
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
    @u = User.first :id => session[:u_id]

    error 500 unless Game.current
    error 403 unless params[:token] == Game.current.token #TODO: change this to something informative
    
    Game.current.token = nil
    @newround = Round.create(:started => Time.now, :user => @u)
    Game.current.rounds << @newround
    Game.current.save

    ec2_ssh("echo \"#{@u.mc_name}\" > bukkit/white-list.txt")

    flash[:notice] = "Success! You are now the active player. Please see the instructions below." 
    redirect '/play', 303
  end

end
