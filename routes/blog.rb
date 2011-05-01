class Lonecraft < Sinatra::Application

  get '/relate' do
    unless logged_in?
      flash[:error] = "You must log in or create an account."
      flash[:vaudeville_hook] = '/relate'
      redirect '/login'
    end
    @u = current_user
    @rounds = Round.all(:user => @u)

    haml :relate_all
  end

  get '/relate/:round' do
    unless logged_in? 
      flash[:error] = "You must log in or create an account."
      flash[:vaudeville_hook] = "/relate/#{params[:round]}"
      redirect '/login'
    end
    @u = current_user
    @round = Round.get(params[:round])

    error 403 unless @round.try(:user) == @u
    
    haml :relate_one
  end

  post '/relate/:round' do
    unless logged_in?
      flash[:error] = "You must log in or create an account."
      flash[:vaudeville_hook] = "/relate/#{params[:round]}"
      redirect '/login', 303
    end
    @u = current_user
    @round = Round.get(params[:round])
    
    error 404 unless @round
    error 403 unless @round.user == @u

    @round.story = params[:story]
    @round.save

    flash[:notice] = "Story saved."
    redirect "/relate/#{params[:round]}", 303
  end

  get '/consider' do
    @games = Game.all

    haml :consider_all
  end

  get '/consider/:game' do
    @game = Game.get(params[:game])

    error 404 unless @game
    
    @rounds = @game.rounds

    haml :consider_one
  end

end
