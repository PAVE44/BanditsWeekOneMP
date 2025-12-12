BWOServerCommands = BWOServerCommands or {}

BWOServerCommands.Events = BWOServerCommands.Events or {}

BWOServerCommands.Events.Ping = function(args)
    print ("PING received from server for player " .. tostring(args.pid))
end

local onServerCommand = function(module, command, args)
    if BWOServerCommands[module] and BWOServerCommands[module][command] then
        local player = getPlayer()
        if player then
            local pid = player:getOnlineID()
            for _, v in ipairs(args.pids) do
                if pid == v then
                    args.pids = nil
                    args.pid = pid
                    BWOServerCommands[module][command](args)
                    break
                end
            end
        end
    end
end

Events.OnServerCommand.Remove(onServerCommand)
Events.OnServerCommand.Add(onServerCommand)
