local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local wasMirage = false
local PLACE_ID = 7449423635
local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1370704896671617064/ma_l66V5RdMY2y0kHEDqw1Mtfudl3YR0uWoBMYAO0y2WcEpNAQ6RsJ7zPcNny7U5ES5B"

local function sendMirageWebhook()
    local jobId = game.JobId
    local playerCount = #Players:GetPlayers()
    local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', PLACE_ID, jobId)

    local data = {
        username = "Mirage Notify",
        embeds = {{
            title = "Mirage Notify | NomDom",
            color = tonumber(0xFFFFFF),
            fields = {
                {name = "🧬 Type :", value = "```\nMirage Island [Spawned]\n```", inline = false},
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
        local found = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("MysticIsland")
        if found and not wasMirage then
            wasMirage = true
            sendMirageWebhook()
        elseif not found then
            wasMirage = false
        end
    end
end)
