local KitsuneWebhook = "https://discordapp.com/api/webhooks/1370293325042683944/TTPvtrjzUTcIHzRmmp3Wl10jl9GTqb8PWjlBZc9sxT8T2jcfgMHhvnMChkLUAzNr_0ib"
local wasKitsuneFound = false

local function sendKitsuneWebhook()
    local jobId = game.JobId
    local playerCount = #Players:GetPlayers()

    local joinScript = string.format(
        'game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, "%s", game.Players.LocalPlayer)',
        jobId
    )

    local data = {
        username = "Kitsune Island Notify",
        embeds = {{
            title = "Kitsune Island Notify | NomDom",
            color = tonumber(0xFFFFFF),
            fields = {
                {name = "🧬 Type :", value = "```\nKitsune Island [Spawn]\n```", inline = false},
                {name = "👥 Players In Server :", value = "```\n" .. tostring(playerCount) .. "\n```", inline = false},
                {name = "🧾 Job ID :", value = "```\n" .. jobId .. "\n```", inline = false},
                {name = "📜 Join Script :", value = "```lua\n" .. joinScript .. "\n```", inline = false}
            },
            footer = {text = "Make by NomCakDepZai • " .. os.date("Time : %d/%m/%Y - %H:%M:%S")}
        }}
    }

    local requestFunc = (syn and syn.request) or request or http_request
    if requestFunc then
        pcall(function()
            requestFunc({
                Url = KitsuneWebhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end)
    end
end
task.spawn(function()
    while task.wait(2) do
        if game.PlaceId ~= PLACE_ID then continue end

        local success, result = pcall(function()
            return game.Workspace._WorldOrigin
                and game.Workspace._WorldOrigin:FindFirstChild("Locations")
                and game.Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island")
        end)

        if success and result and not wasKitsuneFound then
            wasKitsuneFound = true
            sendKitsuneWebhook()
        elseif success and not result then
            wasKitsuneFound = false
        end
    end
end)
