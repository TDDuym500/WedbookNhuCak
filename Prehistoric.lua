.lualocal HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local wasPrehistoric = false
local PLACE_ID = 7449423635
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1370706043163774996/Il86uY67qKcWA2PDCI4MkBiHHBWM93_YlmEmEo-brmPJdaprSGTt6wj3tGtvzZB8Ps2M"

local function sendPrehistoricWebhook()
    local jobId = game.JobId
    local playerCount = #Players:GetPlayers()
    local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', PLACE_ID, jobId)

    local data = {
        username = "Prehistoric Notify",
        embeds = {{
            title = "Prehistoric Notify | NomDom",
            color = tonumber(0xFFFFFF),
            fields = {
                {name = "🧬 Type :", value = "```\nPrehistoric Island [Spawned]\n```", inline = false},
                {name = "👥 Players In Server :", value = "```\n" .. tostring(playerCount) .. "\n```", inline = false},
                {name = "🧾 Job ID (PC Copy) :", value = "```\n" .. jobId .. "\n```", inline = false},
                {name = "📜 Join Script (PC Copy) :", value = "```lua\n" .. joinScript .. "\n```", inline = false}
            },
            footer = {text = "Make by NomCakDepZai • " .. os.date("Time : %d/%m/%Y - %H:%M:%S")}
        }}
    }

    local req = (syn and syn.request) or request or http_request
    if req then
        pcall(function()
            req({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end)
    end
end

task.spawn(function()
    while task.wait(1) do
        if game.PlaceId ~= PLACE_ID then continue end
        local found = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("PrehistoricIsland")
        if found and not wasPrehistoric then
            wasPrehistoric = true
            sendPrehistoricWebhook()
        elseif not found then
            wasPrehistoric = false
        end
    end
end)
