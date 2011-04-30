class Bukkit
  
  def self.ban_user(mc_name)
    @commands = ""
    @commands << "rm bukkit/white-list.txt; "
    @commands << "echo \"#{ENV['ADMIN_MCNAME']}\" > bukkit/white-list.txt; "
    @commands << "echo \"#{mc_name}\" >> bukkit/banned-players.txt; "

    ec2_ssh(@commands)
  end

  def self.reset_server
    @commands = ""
    @commands << "rm bukkit/white-list.txt; "
    @commands << "echo \"#{ENV['ADMIN_MCNAME']}\" > bukkit/white-list.txt; "
    @commands << "rm bukkit/banned-players.txt; "
    @commands << "rm bukkit/plugins/GhostBuster/ghosts.yml; "

    ec2_ssh(@commands)
  end

  def self.white_list(mc_name)
    @commands = ""
    @commands << "echo \"#{mc_name}\" >> bukkit/white-list.txt"

    ec2_ssh(@commands)
  end

  def self.ec2_ssh(commands) #TODO: make this more ruby-like (array of commands instead of string, handle the "; " between each element)
    system('cat "$EC2_KEYFILE" > ./tmp/ec2.pem; chmod 600 ./tmp/ec2.pem')
    system("ssh -i ./tmp/ec2.pem ec2-user@#{ENV['GAME_DOMAIN']} \"#{commands}\"") 
  end
end

