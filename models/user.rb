class User
  include DataMapper::Resource
  property :id, Serial
  property :email, Text, :unique => true, :required => true
  property :passhash, BCryptHash
  property :mc_name, Text
  property :admin,  Boolean, :default => false
 
  has n, :round, :required => false
  
  def admin?
    return admin
  end

  def password=(pass)
    @password = pass
    self.passhash = BCrypt::Password.create(@password, :cost=> 10)
  end

  def self.authenticate(email, pass)
    user = User.first(:email => email)
    return nil if user.nil?
    return user if BCrypt::Password.new(user.passhash) == pass
  end

end

