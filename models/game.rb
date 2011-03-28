class Game
 include DataMapper::Resource
 property :id, Serial
 property :worldfile_url, URI
 property :token, UUID
 has n, :rounds

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

 def self.current
   last( :rounds => { :order => [:started.asc]})
 end

end

