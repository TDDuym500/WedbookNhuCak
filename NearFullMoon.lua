local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local PLACE_ID = 7449423635

-- 🌕 Full Moon Settings
local Near_FULL_MOON_TEXTURE_ID = "http://www.roblox.com/asset/?id=9709149052"
local NearFullMoonWebhook = "https://discordapp.com/api/webhooks/1371833001234923570/VJSR5cyCueolCLtKA1wmB8G5lX505sPX5E9NE8vfKoB3ZSnaDTF1k4GpmrlxA04yz_wX"

local wasFullMoon = false

-- Function to send webhook when near full moon is detected
local function sendNearFullMoonWebhook()
    local jobId = game.JobId
    local playerCount = #Players:GetPlayers()

    -- Join Script (correct format for TeleportService)
    local joinScript = string.format(
        'game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, "%s", game.Players.LocalPlayer)',
        game.JobId
    )

    local data = {
        username = "Near Full Moon Notify",
        embeds = {{
            title = "Near Full Moon Notify | NomDom",
            color = tonumber(0xFFFFFF),
            fields = {
                {name = "🧬 Type :", value = "```\nNear Full Moon [Spawn]\n```", inline = false},
                {name = "👥 Players In Server :", value = "```\n" .. tostring(playerCount) .. "\n```", inline = false},
                {name = "🧾 Job ID (PC Copy) :", value = "```\n" .. jobId .. "\n```", inline = false},
                {name = "📜 Join Script (PC Copy) :", value = "```lua\n" .. joinScript .. "\n```", inline = false}
            },
            footer = {text = "Made by NomCakDepZai • " .. os.date("Time : %d/%m/%Y - %H:%M:%S")}
        }}
    }

    local requestFunc = (syn and syn.request) or request or http_request
    if requestFunc then
        pcall(function()
            requestFunc({
                Url = NearFullMoonWebhook,  -- Use the correct webhook URL here
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end)
    end
end

-- Loop to check moon texture and send a webhook when near full moon is detected
task.spawn(function()
    while task.wait(2) do
        -- Check if we are in the correct game
        if game.PlaceId ~= PLACE_ID then continue end

        -- Look for the moon texture
        local sky = Lighting:FindFirstChildWhichIsA("Sky")
        local moonTexture = sky and sky.MoonTextureId

        -- If moon texture matches the Near Full Moon texture, send webhook if not already sent
        if moonTexture == Near_FULL_MOON_TEXTURE_ID then
            if not wasFullMoon then
                wasFullMoon = true
                sendNearFullMoonWebhook()
            end
        else
            -- Only reset wasFullMoon when the moon texture is no longer the Near Full Moon
            if wasFullMoon then
                wasFullMoon = false
            end
        end
    end
end)
