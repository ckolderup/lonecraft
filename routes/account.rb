class Lonecraft < Sinatra::Application
  
  def logged_in?
    session[:u_id] != nil
  end

  def current_user
    return User.first :id => session[:u_id]
  end


  get '/logout' do
    session[:u_id] = nil
    flash[:notice] = "You've been logged out."
    redirect '/login'
  end

  get '/login' do
    haml :login
  end

  post '/login' do
    if user = User.authenticate(params[:email], params[:password])
      session[:u_id] = user.id
      redirect flash[:vaudeville_hook]||'/account', 303
    else
      flash[:error] = "Incorrect username or password."
      redirect '/login', 303
    end
  end

  get '/account' do
    unless logged_in?
      flash[:error] = "You must be logged in"
      flash[:vaudeville_hook] = '/account'
      redirect '/login'
    end

    @u = current_user

    haml :account
  end

  post '/account' do
    unless logged_in?
      flash[:error] = "You must be logged in"
      flash[:vaudeville_hook] = '/account'
      redirect '/login', 303
    end

    @u = current_user 

    begin
      @u.mc_name = params[:mc_name] unless params[:mc_name].nil?
      @u.email = params[:email] unless params[:email].nil?
      unless params[:password] == params[:password2]
        raise ArgumentError, "Passwords did not match. Try again."
      end
    rescue ArgumentError => e
      flash[:error] = e.message
      redirect '/account', 303
    end

    error 400 unless @u.valid?
    error 503 unless @u.save

    flash[:notice] = "Account details updated."
    redirect '/account', 303
  end

  get '/signup' do
    if logged_in?
      flash[:notice] = "You are already logged in!"
      redirect '/login'
    end

    haml :signup
  end

  post '/signup' do
    @u = User.new

    begin
      @u.email = params[:email]
      @u.mc_name = params[:mc_name] unless params[:mc_name].nil?
      unless params[:password] == params[:password2]
        raise ArgumentError, "Passwords did not match. Try again."
      end
    rescue ArgumentError => e
      flash[:error] = e.message
      redirect '/signup', 303
    end

    error 400 unless @u.valid?
    error 503 unless @u.save

    session[:u_id] = @u.id
    redirect '/account', 303
  end

  get '/confirm/:token' do #TODO: offer to confirm the account 
  end

  post '/confirm' do #TODO: actually confirm the account
  end

end
