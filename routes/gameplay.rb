class Minebound < Sinatra::Application

  get '/pass' do
    unless logged_in?
      flash[:error] = "You must log in or create an account."
      redirect '/login'
    end

    @u = User.first :id => session[:u_id]
    @passable = (Game.current && Game.current.player == @u)

    haml :pass
  end

  post '/pass' do
    unless logged_in?
      flash[:error] = "You must log in or create an account."
      redirect '/login', 303
    end

    @u = User.first :id => session[:u_id]
    @email = params[:email]
    
    error 403 unless (Game.current && Game.current.player == @u)

    @token = Game.current.token

    #TODO: get a gmail account, set up gmail auth using an ENV for passwd
    Pony.mail :to => @email,
              :from => 'no-reply@kolderup.org', 
              :subject => 'Minebound game token',
              :body => erb(:token_email)

    flash[:notice] = "Key sent to #{@email}."
    redirect '/play', 303
  end

  ['/play', '/play/:token'].each do |path|  
    get path do
      unless logged_in?
        flash[:error] = "You must log in or create an account."
        redirect '/login'
      end
      @u = User.first :id => session[:u_id]
      @token = params[:token]

      haml :play
    end
  end

  post '/play' do
    unless logged_in?
      flash[:error] = "You must log in or create an account."
      redirect '/login', 303
    end
    @u = User.first :id => session[:u_id]

    error 500 unless Game.current
    error 403 unless params[:token] == Game.current.token #TODO: change this to something descriptive
    
    Game.current.token = nil
    @newround = Round.create(:started => Time.now, :user => @u)
    Game.current.rounds << @newround
    Game.current.save

    #TODO: POST /play: connect to ec2
    #TODO: POST /play: add username to whitelist.txt
  end

end
