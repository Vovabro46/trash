local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vovabro46/dinas/refs/heads/main/BestDinas.lua"))()

local window = Library:CreateWindow("Dinas Hub - Trampoline Battle Simulator")
local mainTab = window:AddTab("Main", "🏠")
local petsTab = window:AddTab("Pets", "🐉")
local powerTab = window:AddTab("Power", "💪")
local visualsTab = window:AddTab("Visuals", "👁️")
local settingsTab = window:AddTab("Settings", "⚙️")
local communityTab = window:AddTab("Community", "👥")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local Train = ReplicatedStorage.Event.Train
local WinGain = ReplicatedStorage.Event.WinGain
local BuyPower = ReplicatedStorage.Event.BuyPower
local Hatch = ReplicatedStorage.PEV.Hatch
local CRAFT = ReplicatedStorage.PEV.CRAFT

Library:AddSection(mainTab, "Best Functions", "🔥")

local valueInput = Library:AddInputText(mainTab, "Value for infinity wins & strength", 
    "Enter value...", 
    function(text)
        print("Value:", text)
    end,
    {numeric = true, maxLength = 100}
)

Library:AddToggle(mainTab, "Inf Strength", function(state)
    _G.InfiniteStrength = state
    
    if state then
        spawn(function()
            while _G.InfiniteStrength do
                pcall(function()
                    local value = tonumber(valueInput:GetText())
                    if value then
                        Train:FireServer(value)
                    end
                end)
                wait(0.1)
            end
        end)
    end
end)

Library:AddToggle(mainTab, "Inf Wins", function(state)
    _G.InfiniteWins = state
    
    if state then
        spawn(function()
            while _G.InfiniteWins do
                pcall(function()
                    local value = tonumber(valueInput:GetText())
                    if value then
                        WinGain:FireServer(value)
                    end
                end)
                wait(0.1)
            end
        end)
    end
end)

Library:AddSection(mainTab, "Misc", "🔥")
Library:AddSlider(mainTab, "Walk Speed", 16, 200, 16, function(value)
    local character = localPlayer.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
    end
end, {suffix = " studs"})

-- FOV Changer
Library:AddSlider(mainTab, "FOV Changer", 70, 120, 70, function(value)
    if workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView = value
    end
end)

local playerCard = Library:AddCard(mainTab, "Player Info", 
    "Name: " .. localPlayer.Name .. 
    "\nAccount Age: " .. localPlayer.AccountAge .. " days" ..
    "\nUser ID: " .. localPlayer.UserId, 
    {height = 100}
)

Library:AddSection(petsTab, "Hatching", "🥚")

Library:AddToggle(petsTab, "Free All Pets(Laggy)", function(state)
    _G.FreePets = state
    
    if state then
        spawn(function()
            while _G.FreePets do
                pcall(function()
                    local eggs = {
                        "Abyss", "Cyro", "Exotic", "Frostflare", "Grass", 
                        "Nethera", "Sand", "Sinister", "Starter", "Subo", 
                        "Tropical", "Wild"
                    }
                    
                    local pets = {
                        "Demon", "Flamethrower", "Phoenix", "Soul Warden",
                        "Fish", "Reindeer", "Shark",
                        "Banana", "Celestia", "Parrot", "Tiger",
                        "Arctic Golem", "Blue Dominus", "Glacier",
                        "Bird", "Piggy", "Sapphire Dragon",
                        "Ant", "Crocodile", "Crow", "Crystal Lord",
                        "Doggy", "Enchantico", "Fairy Chihuahua",
                        "Flamingo", "Hotdog", "King Ant",
                        "Kitty", "Magma Golem", "Mouse", "Mutant Purp", "Mystery Cat",
                        "Pineapple Cat", "Sand Spider", "Seraph",
                        "Sloth", "Space Kitty", "Stegosaurus",
                        "Sugarflare", "Sundo", "Warpeeler", "Witch Dragon"
                    }
                    
                    for _, egg in ipairs(eggs) do
                        for _, pet in ipairs(pets) do
                            Hatch:FireServer(egg, pet, 1.2)
                        end
                    end
                end)
                wait(0.2)
            end
        end)
    end
end)

Library:AddToggle(petsTab, "Inf Craft Pets", function(state)
    _G.InfiniteCraft = state
    
    if state then
        spawn(function()
            while _G.InfiniteCraft do
                pcall(function()
                    local pets = {
                        "Crystal Lord",
                        "Demon", "Flamethrower", "Phoenix", "Soul Warden",
                        "Fish", "Reindeer", "Shark",
                        "Banana", "Celestia", "Parrot", "Tiger",
                        "Arctic Golem", "Blue Dominus", "Glacier",
                        "Bird", "Piggy", "Sapphire Dragon",
                        "Enchantico", "Magma Golem", "Mystery Cat",
                        "Bolt", "Sand Spider", "Sloth",
                        "Hotdog", "Seraph", "Sundo", "Warpeeler",
                        "Crow", "Sugarflare", "Witch Dragon",
                        "Doggy", "Kitty", "Mouse",
                        "Mutant Purp", "Soul Golem", "Space Kitty",
                        "Flamingo", "King Ant", "Pineapple Cat",
                        "Ant", "Crocodile", "Fairy Chihuahua", "Stegosaurus"
                    }
                    
                    for _, pet in ipairs(pets) do
                        CRAFT:FireServer(pet, "Big")
                    end
                end)
                wait(0.1)
            end
        end)
    end
end)

Library:AddSection(powerTab, "Power Management", "⚡")

Library:AddToggle(powerTab, "Free All Powers", function(state)
    _G.FreePower = state
    
    if state then
        spawn(function()
            while _G.FreePower do
                pcall(function()
                    local powers = {
                        "Fire", "Water", "Earth", "Air", "Light", "Dark",
                        "Acid", "Bone", "Classic", "Death", "Explosive", "Frost",
                        "Gold", "Gust", "Health", "Laser", "Life", "Lightning",
                        "Love", "Melodic", "Nebula", "Quake", "Shadow", "Smelly",
                        "Starry", "ToxicGold", "Warp"
                    }
                    for _, power in ipairs(powers) do
                        BuyPower:FireServer(power, 0)
                    end
                end)
                wait(0.2)
            end
        end)
    end
end)

Library:AddSection(visualsTab, "World Visuals", "🌍")

Library:AddToggle(visualsTab, "Fullbright", function(state)
    if state then
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
    else
        game:GetService("Lighting").GlobalShadows = true
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").ClockTime = 14
    end
end)

Library:AddToggle(visualsTab, "ESP Players", function(state)
    _G.ESPEnabled = state
    
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local character = player.Character
                if character then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = character
                end
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("Highlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end)

local fpsWidget = Library:AddStatusWidget(visualsTab, "FPS", "60", "📊")
spawn(function()
    while true do
        local fps = math.floor(1/game:GetService("RunService").Heartbeat:Wait())
        fpsWidget.Update(fps)
        wait(1)
    end
end)

local pingWidget = Library:AddStatusWidget(visualsTab, "Ping", "0ms", "📡")
spawn(function()
    while true do
        local stats = game:GetService("Stats")
        local ping = stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        pingWidget.Update(math.floor(ping) .. "ms")
        wait(2)
    end
end)

Library:AddToggle(settingsTab, "AntiAFK", function(state)
    _G.AntiAFKEnabled = state
    
    if state then
        local VirtualInputManager = game:GetService("VirtualInputManager")
        local connection
        connection = localPlayer.Idled:Connect(function()
            if _G.AntiAFKEnabled then
                VirtualInputManager:SendKeyEvent(true, "Space", false, game)
                wait(0.1)
                VirtualInputManager:SendKeyEvent(false, "Space", false, game)
            else
                connection:Disconnect()
            end
        end)
    end
end)

Library:AddSection(settingsTab, "Information", "ℹ️")

Library:AddLabel(settingsTab, "Version: 2.0", "ℹ️")
Library:AddLabel(settingsTab, "Game: Trampoline Battle Simulator", "🎮")
Library:AddLabel(settingsTab, "Last Update: " .. os.date("%d.%m.%Y"), "📅")
Library:AddParagraph(settingsTab, "Menu By Dinas", "📋")

-- Сообщество
Library:AddSection(communityTab, "My social networks", "🌐")

Library:AddButton(communityTab, "📢 Telegram Channel (@dinasscripts)", function()
    if setclipboard then
        setclipboard("https://t.me/dinasscripts")
    end
    local message = "The link to the Telegram channel has been copied to your clipboard!"
    window:ShowNotification("Success", message, 3, "success")
end)

Library:AddParagraph(communityTab, "Join our telegram channel for the latest updates and news!", "📢")

-- Дискорд сервер
Library:AddButton(communityTab, "💬 Discord Channel (Soon)", function()
    if setclipboard then
        setclipboard("soon")
    end
    local message = "copied"
    window:ShowNotification("Info", message, 2, "info")
end)

Library:AddParagraph(communityTab, "Join my Discord community for communication and support!", "💬")

-- Статистика сообщества
local membersWidget = Library:AddStatusWidget(communityTab, "Community Members", "1", "👥")
local onlineWidget = Library:AddStatusWidget(communityTab, "Online Now", "1", "🟢")

window:ShowNotification("Dinas Hub", "Menu loaded successfully!", 5, "success")
