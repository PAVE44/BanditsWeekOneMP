BWOServerCommands = BWOServerCommands or {}

BWOServerCommands.Events = BWOServerCommands.Events or {}

BWOServerCommands.Events.Ping = function(args)
    print ("PING received from server")
end

local onServerCommand = function(module, command, args)
    if BWOServerCommands[module] and BWOServerCommands[module][command] then
        BWOServerCommands[module][command](args)
    end
end

Events.OnServerCommand.Remove(onServerCommand)
Events.OnServerCommand.Add(onServerCommand)
