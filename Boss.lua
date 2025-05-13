local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Enemies = workspace:WaitForChild("Enemies")

-- Boss phân theo từng PlaceId
local BossConfig = {
    [4442272183] = { -- Sea 2
        ["Soul Reaper"] = "https://discordapp.com/api/webhooks/1370744092614721546/YxI-RQusqGZY0aYMcKNfAOH11Vey7l6GA_MRaTn76fSXN_DYwo-qld3GM_mNm9EUyCKl",
        ["Cursed Captain"] = "https://discordapp.com/api/webhooks/1370743660886364201/4U3zWaG3RgCoI_-Oaa2etQEk9wGx1NnDs_3Tsi7yuBrcyH41N9pUbkE3lhDNXm2lCphb",
        ["Darkbeard"] = "https://discordapp.com/api/webhooks/1370745744319053824/Uy09oJXfJ8dpslvJKLDNHRG0Q7sdL098zLukmNk8q41_-hEm3bRNcrC195xhoKwlfQMk"
    },
    [2753915549] = { -- Sea 1
        ["Greybeard"] = "https://discordapp.com/api/webhooks/1370744660124893337/gghownuS7OmK-SngA8EUITaXD7wYm4c03w6hJvz854E5z2ta5PRxyoYoB5C02IA4_0eY"
    },
    [7449423635] = { -- Sea 3
        ["Dough King"] = "https://discordapp.com/api/webhooks/1370744836579262466/_YVq6KsScMIVIfd7-9qp-5UKa_rgTQ2xno9XzlIZQOaqXt0hZYgnJvPBZ5S5EltqDrOz",
        ["Cake Prince"] = "https://discordapp.com/api/webhooks/1370745347978170399/EfCGhhfCbthMYKmuaixPOnd3Dzg3a1FCDu7V3pClnEHsi0uW_z2sK6dnMqyI-jHFEZ0i",
        ["rip_indra"] = "https://discordapp.com/api/webhooks/1370745217258618880/SntVAJdOzsP5IpkZMdOeqp1HIxzMTCYqMymM81opMgMyHFxY9YDa0qDCK8lDgESItqT1",
        ["Tyrant of the Skies"] = "https://discordapp.com/api/webhooks/1370745484947357796/2N7h_4q-6RA9vHBlifVflG_11uON6EnjHrEjuCDIxkPhKGKmRc5_6XdczSHvpk77o6-b"
    }
}

local sentBoss = {}

local function sendBossWebhook(bossName, webhookUrl)
    local jobId = game.JobId
    local playerCount = #Players:GetPlayers()
    local placeId = game.PlaceId

    local joinScript = string.format(
        'game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)',
        placeId, jobId
    )

    local data = {
        username = bossName .. " Notify",
        embeds = { {
            title = bossName .. " Notify | NomDom",
            color = tonumber(0xFFFFFF),
            fields = {
                {name = "👾 Boss :", value = "```\n" .. bossName .. "\n```", inline = false},
                {name = "👥 Players In Server :", value = "```\n" .. tostring(playerCount) .. "\n```", inline = false},
                {name = "🧾 Job ID :", value = "```\n" .. jobId .. "\n```", inline = false},
                {name = "📜 Join Script :", value = "```lua\n" .. joinScript .. "\n```", inline = false}
            },
            footer = {text = "Time : " .. os.date("%d/%m/%Y - %H:%M:%S")}
        } }
    }

    local requestFunc = (syn and syn.request) or request or http_request
    if requestFunc then
        pcall(function()
            requestFunc({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end)
    end
end

local function checkBossSpawn()
    local currentPlaceBosses = BossConfig[game.PlaceId]
    if not currentPlaceBosses then return end

    for bossName, webhook in pairs(currentPlaceBosses) do
        local inReplicated = ReplicatedStorage:FindFirstChild(bossName)
        local inWorkspace = Enemies:FindFirstChild(bossName)

        if (inReplicated or inWorkspace) and not sentBoss[bossName] then
            sentBoss[bossName] = true
            sendBossWebhook(bossName, webhook)
        elseif not inReplicated and not inWorkspace then
            sentBoss[bossName] = false -- Reset nếu boss biến mất
        end
    end
end

-- Lặp kiểm tra mỗi 3 giây
task.spawn(function()
    while task.wait(3) do
        checkBossSpawn()
    end
end)
