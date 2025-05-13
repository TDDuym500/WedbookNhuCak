local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local PLACE_ID = 7449423635

-- 🌕 Full Moon Settings
local FULL_MOON_TEXTURE_ID = "http://www.roblox.com/asset/?id=9709149431"
local FullMoonWebhook = "https://discordapp.com/api/webhooks/1370290373988978708/0IxLrhCKGtWHX4B_OUbHJytC3RU7nrXpuukKPCa1nyw-Cj3HNKqkmKpoAyLz-9f_uB3P"

local wasFullMoon = false

local function sendFullMoonWebhook()
    local jobId = game.JobId
    local playerCount = #Players:GetPlayers()

    local joinScript = string.format(
        'game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)',
        PLACE_ID, jobId
    )

    local data = {
        username = "Full Moon Notify",
        embeds = {{
            title = "Full Moon Notify | NomDom",
            color = tonumber(0xFFFFFF),
            fields = {
                {name = "🧬 Type :", value = "```\nFull Moon [Spawn]\n```", inline = false},
                {name = "👥 Players In Server :", value = "```\n" .. tostring(playerCount) .. "\n```", inline = false},
                {name = "🧾 Job ID (PC Copy) :", value = "```\n" .. jobId .. "\n```", inline = false},
                {name = "📜 Join Script (PC Copy) :", value = "```lua\n" .. joinScript .. "\n```", inline = false}
            },
            footer = {text = "Make by NomCakDepZai • " .. os.date("Time : %d/%m/%Y - %H:%M:%S")}
        }}
    }

    local requestFunc = (syn and syn.request) or request or http_request
    if requestFunc then
        pcall(function()
            requestFunc({
                Url = FullMoonWebhook,
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

        local sky = Lighting:FindFirstChildWhichIsA("Sky")
        local moonTexture = sky and sky.MoonTextureId

        if moonTexture == FULL_MOON_TEXTURE_ID then
            if not wasFullMoon then
                wasFullMoon = true
                sendFullMoonWebhook()
            end
        else
            wasFullMoon = false
        end
    end
end)
