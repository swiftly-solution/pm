local cmdWithPrefix = {}

AddEventHandler("OnPluginStart", function(event)
    local splittedPrefixes = string.split(config:Fetch("core.commandPrefixes"), " ")
    for i=1,#splittedPrefixes do
        table.insert(cmdWithPrefix, splittedPrefixes[i].."pm")
    end
end)

AddEventHandler("OnClientChat", function(event, playerid, text, teamonly)
    for i=1,#cmdWithPrefix do
        if text:find(cmdWithPrefix[i]) then
            event:SetReturn(false)
            return EventResult.Handled
        end
    end
    return EventResult.Continue
end)

commands:Register("pm", function(playerid, args, argsCount, silent, prefix)
    local sender = GetPlayer(playerid)
    if not sender then return end
    if not sender:CBasePlayerController():IsValid() then return end
    local sendername = sender:CBasePlayerController().PlayerName

    if argsCount < 2 then
        ReplyToCommand(playerid, config:Fetch("pm.prefix"), string.format(FetchTranslation("privatemessages.NotEnoughArgs"), prefix))
        return
    end

    local receivers = FindPlayersByTarget(args[1], false)
    if #receivers == 0 then
        return ReplyToCommand(playerid, config:Fetch("pm.prefix"), FetchTranslation("privatemessages.PlayerNotFound"))
    end

    local receiver = receivers[1]
    if receiver == sender then
        return ReplyToCommand(playerid, config:Fetch("pm.prefix"), FetchTranslation("privatemessages.PlayerSendYourself"))
    end

    table.remove(args, 1)
    local message = table.concat(args, " ")

    ReplyToCommand(receiver:GetSlot(), config:Fetch("pm.prefix"), FetchTranslation("privatemessages.RevicedPM"):gsub("{NAME}", sendername):gsub("{TEXT}", message))
    ReplyToCommand(playerid, config:Fetch("pm.prefix"), FetchTranslation("privatemessages.SentPM"):gsub("{NAME}", receiver:CBasePlayerController().PlayerName):gsub("{TEXT}", message))
end)

function GetPluginAuthor()
    return "Swiftly Solution"
end
function GetPluginVersion()
    return "v1.0.0"
end
function GetPluginName()
    return "Swiftly Private Messages"
end
function GetPluginWebsite()
    return "https://github.com/swiftly-solution/pm"
end