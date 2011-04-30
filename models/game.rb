class Game
  include DataMapper::Resource
  property :id, Serial
  property :worldfile_url, URI
  property :token, String, :default => lambda { UUIDTools::UUID.random_create.to_s }
  property :created, DateTime, :default => lambda { DateTime.now }
  has n, :rounds

  def challenge(intoken)
    token == intoken
  end

  def first_round
    rounds.first( :order => [:started.asc])
  end

  def last_round
    rounds.last( :order => [:started.asc])
  end

  def player
    last_round.user
  end

  def active?
    return last_round.finished == nil
  end

  def finished?
    rounds.size == 10 && last_round.finished
  end

  def cycle
    update(:token => UUIDTools::UUID.random_create.to_s)
    
    @round = last_round
    @round.finished = Time.now
    
    self.save
    
    Bukkit.ban_user(@round.user.mc_name)      
    
    wrapup if finished?
  end

  def assign(user)
    update(:token => nil)
   
    @newround = Round.create(:started => Time.now, :user => user)
    rounds << @newround
   
    self.save
 
    Bukkit.white_list(user.mc_name)
  end

  def wrapup
    #TODO: send email to all players in round announcing the end of the round and asking any who haven't already to write their post
  end

  def self.current
    first( :order => [:created.desc])
  end

end

