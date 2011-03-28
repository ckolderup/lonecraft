class Minebound < Sinatra::Application

  get '/write' do #TODO: a list of all the rounds you've been in 
  end

  get '/write/:round' do #TODO: a textarea with the contents of your round story
  end

  post '/write/:round' do #TODO: receive the most recent text and update it in the db
  end

end
