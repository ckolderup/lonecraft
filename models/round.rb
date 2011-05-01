class Round
  include DataMapper::Resource
  property :id, Serial
  property :started, DateTime
  property :finished, DateTime
  property :story, Text
  belongs_to :game
  has 1, :user, :through => Resource
end 

