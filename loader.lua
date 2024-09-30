local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local function getKeysData()
    local url = "https://nis0.site/keys.json"
    local response = request({
        Url = url,
        Method = "GET",
        Headers = {
            ["Content-Type"] = "application/json"
        }
    })

    if response.StatusCode == 200 then
        return HttpService:JSONDecode(response.Body)
    else
        error("Failed to retrieve keys data: " .. response.Body)
    end
end

local function verifyKeyAndHWID(player, key)
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId() -- Получаем HWID игрока
    local keysData = getKeysData()

    if not keysData.keys[key] then
        player:Kick("Key does not exist.")
        return
    end

    local keyData = keysData.keys[key]

    if keyData.hwid == nil or keyData.hwid == "null" then
        keyData.hwid = hwid

        local jsonData = HttpService:JSONEncode(keysData)

        local response = request({
            Url = "https://nis0.site/keys.json",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })

        if response.StatusCode == 200 then
            print("HWID registered successfully.")
            loadstring(game:HttpGet("https://raw.githubusercontent.com/oguzxxxx/script/refs/heads/main/main.lua"))() 
        else
            print("Failed to register HWID: " .. response.Body)
            player:Kick("Failed to register HWID.")
        end
    else
        if keyData.hwid ~= hwid then
            player:Kick("Invalid HWID.")
        else
            print("Key and HWID verified successfully.")
            loadstring(game:HttpGet("https://raw.githubusercontent.com/oguzxxxx/script/refs/heads/main/main.lua"))()
        end
    end
end

local player = Players.LocalPlayer
local userkey = "key123"
verifyKeyAndHWID(player, userkey)
