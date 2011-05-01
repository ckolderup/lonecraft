screen -dr bukkit -p 0 -X stuff "$(printf "save-all\r")"
sleep 3
screen -dr bukkit -p 0 -X stuff "$(printf "stop.\r")"
sleep 2
screen -r bukkit -p 0 -X quit
