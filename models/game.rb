require 'base32/crockford'

class Game
 include DataMapper::Resource
 property :id, Serial
 property :worldfile_url, URI
 property :token, UUID #TODO: make token crockford's base32
 has n, :rounds

 def token
   Base32::Crockford.encode(token) 
 end

 def challenge(crockford)
   Base32::Crockford.decode(crockford) == token
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
   last_round.finished
 end

 def finished?
   round.size == 10 && last_round.finished
 end

 def cycle
    @round = last_round
    @round.finished = Time.now
    @round.save
    
    @u = @round.user
    Bukkit.ban_user(@u.mc_name)      

    finish if (Game.current.rounds.size == 10) 
 end

 def finish
      #TODO: send email to all players in round announcing the end of the round and asking any who haven't already to write their post
 end

 def self.current
   last( :rounds => { :order => [:started.asc]})
 end

end

