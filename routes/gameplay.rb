class Minebound < Sinatra::Application

  get '/pass' do
    unless logged_in?
      flash[:error] = "You must log in or create an account."
      redirect '/login'
    end

    @u = User.first :id => session[:u_id]
   
    @passable = false
    @token = nil

    unless Game.current.nil?
      @passable = (Game.current.player == @u)
      @token = Game.current.token
    end

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

    #TODO: POST /pass: send an email with the contents of the key

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

    #TODO: cash in the token (params[:token])
    #TODO: POST /play: connect to ec2
    #TODO: POST /play: add username to whitelist.txt
  end

end
