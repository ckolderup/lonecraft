class Round
  include DataMapper::Resource
  property :id, Serial
  property :started, DateTime
  property :finished, DateTime
  property :story, Text
  belongs_to :game
  belongs_to :user
end 

