class Bukkit
  
  def self.ban_user(mc_name)
    @commands = ""
    @commands << "./stop.sh; "
    @commands << "rm bukkit/white-list.txt; "
    @commands << "echo \"#{ENV['ADMIN_MCNAME']}\" > bukkit/white-list.txt; "
    @commands << "echo \"#{mc_name}\" >> bukkit/banned-players.txt; "
    @commands << "./go.sh; "

    ec2_ssh(@commands)
  end

  def self.reset_server
    @commands = ""
    @commands << "./stop.sh; "
    @commands << "rm bukkit/white-list.txt; "
    @commands << "echo \"#{ENV['ADMIN_MCNAME']}\" > bukkit/white-list.txt; "
    @commands << "rm bukkit/banned-players.txt; "
    @commands << "rm bukkit/plugins/GhostBuster/ghosts.yml; "
    @commands << "./go.sh; "

    ec2_ssh(@commands)
  end

  def self.white_list(mc_name)
    @commands = ""
    @commands << "./stop.sh; "
    @commands << "echo \"#{mc_name}\" >> bukkit/white-list.txt; "
    @commands << "./go.sh; "

    ec2_ssh(@commands)
  end

  def self.ec2_ssh(commands) #TODO: make this more ruby-like (array of commands instead of string, handle the "; " between each element)
    system('echo "$EC2_KEYFILE" > ./tmp/ec2.pem; chmod 600 ./tmp/ec2.pem')
    system("ssh -i ./tmp/ec2.pem ec2-user@#{ENV['GAME_DOMAIN']} \"#{commands}\"") 
  end
end

