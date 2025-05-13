local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local webhookUrl = "https://discordapp.com/api/webhooks/1370353262007554100/8DnI1E7znDbXfzh1cKLDY5obw8NrSxxLupX2urIN4K1uqv3u7VIqiHaPoPHkH7MlmYe-" -- 📌 Thay bằng webhook của bạn
local sentJobIds = {}

-- Kiểm tra xem game hiện tại có phải là Blox Fruits không (bằng PlaceId hoặc tên game)
local function isInBloxFruits()
    return game.PlaceId == 2753915549  -- Blox Fruits PlaceId
end

-- Xác định Sea dựa trên ID của game
local function getSea()
    local id = game.PlaceId  -- Lấy PlaceId của game hiện tại
    if id == 2753915549 then
        return "Sea 1"
    elseif id == 4442272183 then
        return "Sea 2"
    elseif id == 7449423635 then
        return "Sea 3"
    else
        return "Unknown Sea"  -- Nếu không xác định được, trả về Unknown Sea
    end
end

-- Gửi webhook
local function sendWebhook()
    local jobId = game.JobId
    local playerCount = #Players:GetPlayers()
    local sea = getSea() -- Lấy thông tin Sea

    local joinScript = string.format(
        'game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)',
        game.PlaceId, jobId
    )

    local data = {
        username = "Low Player Notify",
        embeds = { {
            title = "Low Player Notify | NomDom",
            color = tonumber(0xFFFFFF),
            fields = {
                { name = "🧬 Type:", value = "```\nLow Player\n```", inline = false },
                { name = "🌊 Sea:", value = "```\n" .. sea .. "\n```", inline = true },  -- Hiện Sea thay vì game name
                { name = "👥 Players:", value = "```\n" .. tostring(playerCount) .. "\n```", inline = true },
                { name = "🧾 Job ID:", value = "```\n" .. jobId .. "\n```", inline = false },
                { name = "📜 Join Script:", value = "```lua\n" .. joinScript .. "\n```", inline = false }
            },
            footer = { text = "Made by NomCakDepZai • " .. os.date("Time : %d/%m/%Y - %H:%M:%S") }
        } }
    }

    local requestFunc = (syn and syn.request) or request or http_request
    if requestFunc then
        pcall(function()
            requestFunc({
                Url = webhookUrl,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(data)
            })
        end)
    end
end

-- Kiểm tra liên tục và chỉ gửi webhook nếu đang ở trong Blox Fruits
task.spawn(function()
    while task.wait(5) do
        if isInBloxFruits() then  -- Kiểm tra nếu đang trong game Blox Fruits
            local jobId = game.JobId
            local playerCount = #Players:GetPlayers()

            if playerCount <= 4 and not sentJobIds[jobId] then
                sentJobIds[jobId] = true
                sendWebhook()
            end
        end
    end
end)
