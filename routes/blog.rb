class Lonecraft < Sinatra::Application

  get '/relate' do #TODO: a list of all the rounds you've been in 
  end

  get '/relate/:round' do #TODO: a textarea with the contents of your round story
  end

  post '/relate/:round' do #TODO: receive the most recent text and update it in the db
  end

  get '/consider' do #TODO: show a complete list of past games
  end

  get '/consider/:game' do #TODO: show a game's journal
  end

end
