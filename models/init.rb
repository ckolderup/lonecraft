DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/lonecraft.db")

require_relative 'user'
require_relative 'round'
require_relative 'game'
require_relative 'bukkit'

DataMapper.auto_upgrade!

