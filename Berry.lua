local BerryWebhook = "https://discord.com/api/webhooks/1369601650767171696/v1C7cwD6ivTza2iGpFX_n9Aelo12hCC6xFSWVmqH3VDFvbwNCpnNLY6Xe02_AKtI9z9D"
local lastBerryKey = ""

local function getSeaName()
    local id = game.PlaceId
    if id == 2753915549 then return "Sea 1"
    elseif id == 4442272183 then return "Sea 2"
    elseif id == 7449423635 then return "Sea 3"
    else return "Unknown Sea" end
end

local function sendBerryWebhook()
    local jobId = game.JobId
    local playerCount = #Players:GetPlayers()
    local sea = getSeaName()

    local joinScript = string.format(
        'game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, "%s", game.Players.LocalPlayer)',
        jobId
    )

    local data = {
        username = "Berry Notify",
        embeds = {{
            title = "Berry Notify | NomDom",
            color = tonumber(0xFFFFFF),
            fields = {
                {name = "🧬 Type:", value = "\nBerry [Spawn]\n", inline = false},
                {name = "🌊 Sea:", value = "\n" .. sea .. "\n", inline = true},
                {name = "👥 Players:", value = "\n" .. tostring(playerCount) .. "\n", inline = true},
                {name = "🧾 Job ID:", value = "\n" .. jobId .. "\n", inline = false},
                {name = "📜 Join Script:", value = "lua\n" .. joinScript .. "\n", inline = false}
            },
            footer = {text = "Make by NomCakDepZai • " .. os.date("Time : %d/%m/%Y - %H:%M:%S")}
        }}
    }

    local requestFunc = (syn and syn.request) or request or http_request
    if requestFunc then
        pcall(function()
            requestFunc({
                Url = BerryWebhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end)
    end
end

task.spawn(function()
    while task.wait(3) do
        local bushes = CollectionService:GetTagged("BerryBush")
        local currentKeys = {}

        for _, bush in ipairs(bushes) do
            for name in pairs(bush:GetAttributes()) do
                table.insert(currentKeys, name)
            end
        end

        table.sort(currentKeys)
        local keyString = table.concat(currentKeys, ",")

        if keyString ~= "" and keyString ~= lastBerryKey then
            lastBerryKey = keyString
            sendBerryWebhook()
        end
    end
end)
