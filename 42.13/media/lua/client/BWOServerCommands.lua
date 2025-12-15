BWOServerCommands = BWOServerCommands or {}

BWOServerCommands.Events = BWOServerCommands.Events or {}

BWOServerCommands.Events.Ping = function(args)
    print ("PING received from server for player " .. tostring(args.pid))
end


