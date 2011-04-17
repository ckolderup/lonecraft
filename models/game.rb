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
    @round = last_round
    @round.finished = Time.now
    @round.save
    
    @u = @round.user
    Bukkit.ban_user(@u.mc_name)      

    token = UUIDTools::UUID.random_create.to_s

    wrapup if finished?
    self.save
 end

 def wrapup
      #TODO: send email to all players in round announcing the end of the round and asking any who haven't already to write their post
 end

 def self.current
   first( :order => [:created.desc])
 end

end

