local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/3345-c-a-t-s-u-s/Harmony/refs/heads/main/src/init.luau"))();

local Window = Library.new({
    Title = "Harmony Library "..Library.Version,
})

local MainTab = Window:AddTab({
    Title = "Main",
    Icon = "home"
});

local BallsTab = Window:AddTab({
    Title = "Balls",
    Icon = "circle"
});

local EggsTab = Window:AddTab({
    Title = "Eggs",
    Icon = "package"
});

local ZonesTab = Window:AddTab({
    Title = "Zones",
    Icon = "map"
});

local PlayerTab = Window:AddTab({
    Title = "Player",
    Icon = "user"
});

local SettingsTab = Window:AddTab({
    Title = "Settings",
    Icon = "settings"
});

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local InvokeServerAction = ReplicatedStorage.Events.InvokeServerAction
local RequestServerAction = ReplicatedStorage.Events.RequestServerAction

-- Auto Variables
local AutoWin = false
local AutoTrain = false
local AutoRebirth = false
local AutoEquipSelectedBall = false
local AutoOpenAllEggs = false
local AutoOpenSelectedEgg = false
local AutoBuyZone = false
local SelectedBall = "Beach"
local SelectedEgg = "Tree"
local SelectedZone = "1"
local SelectedWinZone = "1"
local SelectedBuyZone = "1"

local AllBalls = {
    "Aurion Nova", "Basic", "Beach", "Bomb", "Camo", "Candy", "Crystal", "Electric Ball", 
    "Enchanted", "Galaxy", "Halloween", "Hauntkin", "Hologramic", "Ice", "Magic", 
    "Nyan Cat Ball", "Ocean", "Primordial", "Shadow Viper", "Spectrum", "Tennis Ball", 
    "Tesla", "Toxic", "VIP", "Volcano"
}

local AllEggs = {
    "Aqua Pearl", "Basic", "Bat", "Beehive", "Cactus", "Candy Basket", "Candy Corn", 
    "City", "Coctail", "Corn", "Crystal", "Crystallica", "Dragon", "Enchanted", 
    "Floatie", "Flower", "Frostbite", "Ghost", "Gift", "Hamburger", "Hot Chocolate", 
    "Mine", "Molten Lava", "Mudstone", "Ninja", "Nuclear", "Nut", "Ocean", "Pirate", 
    "Police", "Pumpkin", "Pumpkin Basket", "Raptor Spike", "Serpent Amethyst", 
    "Silver Spire", "Snowflake", "Snowman", "Toxic", "Tree", "UFO", "Voidspike", 
    "Volcano", "Zombie"
}

local AllZones = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"}

local function equipBall(ballName)
    pcall(function()
        local success, result = pcall(function()
            return InvokeServerAction:InvokeServer("Balls", "Equip", ballName)
        end)
    end)
end

local function openEgg(eggName, amount)
    pcall(function()
        local success, result = pcall(function()
            return InvokeServerAction:InvokeServer(
                "Eggs",
                "RequestPurchase",
                {
                    EggAmount = amount or "max",
                    EggName = eggName,
                    PetsToAutoDelete = {}
                }
            )
        end)
    end)
end

local function buyZone(zoneNumber)
    pcall(function()
        local success, result = pcall(function()
            return InvokeServerAction:InvokeServer("Zone", "Purchase", zoneNumber)
        end)
    end)
end

local function train(zoneNumber, trainType)
    pcall(function()
        RequestServerAction:FireServer("Gameplay", "Train", {trainType, zoneNumber})
    end)
end

local function win(zoneNumber)
    pcall(function()
        InvokeServerAction:InvokeServer("Gameplay", "Win", zoneNumber)
    end)
end

-- ========== MAIN TAB ==========
local AutoSection = MainTab:AddSection({
    Title = "Auto Features"
});

local WinSection = MainTab:AddSection({
    Title = "Win Settings"
});

local TrainSection = MainTab:AddSection({
    Title = "Training Settings"
});

local TogglesSection = MainTab:AddSection({
    Title = "Manual Actions"
});

-- Fast Auto Win
AutoSection:AddToggle({
    Title = "Fast Auto Win",
    Default = false,
    Callback = function(value)
        AutoWin = value
        if value then
            spawn(function()
                while AutoWin do
                    win(tonumber(SelectedWinZone))
                    wait(0.1)
                end
            end)
        end
    end,
})

-- Fast Auto Train
AutoSection:AddToggle({
    Title = "Fast Auto Train",
    Default = false,
    Callback = function(value)
        AutoTrain = value
        if value then
            spawn(function()
                while AutoTrain do
                    pcall(function()
                        train(tonumber(SelectedZone), 1)
                        wait(0.05)
                        train(tonumber(SelectedZone), 2)
                        wait(0.05)
                        train(tonumber(SelectedZone), 3)
                    end)
                    wait(0.1)
                end
            end)
        end
    end,
})

-- Auto Rebirth
AutoSection:AddToggle({
    Title = "Auto Rebirth",
    Default = false,
    Callback = function(value)
        AutoRebirth = value
        if value then
            spawn(function()
                while AutoRebirth do
                    pcall(function()
                        InvokeServerAction:InvokeServer("Rebirths", "Request")
                    end)
                    wait(1)
                end
            end)
        end
    end,
})

WinSection:AddDropdown({
    Title = "Select Win Zone",
    Values = AllZones,
    Default = '1',
    Callback = function(value)
        SelectedWinZone = value
    end,
})

WinSection:AddButton({
    Title = "Win Once (Current Zone)",
    Callback = function()
        win(tonumber(SelectedWinZone))
    end,
})

TrainSection:AddDropdown({
    Title = "Select Training Zone",
    Values = AllZones,
    Default = '1',
    Callback = function(value)
        SelectedZone = value
    end,
})

TrainSection:AddButton({
    Title = "Train Type 1 (Current Zone)",
    Callback = function()
        train(tonumber(SelectedZone), 1)
    end,
})

TrainSection:AddButton({
    Title = "Train Type 2 (Current Zone)",
    Callback = function()
        train(tonumber(SelectedZone), 2)
    end,
})

TrainSection:AddButton({
    Title = "Train Type 3 (Current Zone)",
    Callback = function()
        train(tonumber(SelectedZone), 3)
    end,
})

-- Manual Buttons
TogglesSection:AddButton({
    Title = "Win Once",
    Callback = function()
        win(tonumber(SelectedWinZone))
    end,
})

TogglesSection:AddButton({
    Title = "Train All Types Once",
    Callback = function()
        pcall(function()
            train(tonumber(SelectedZone), 1)
            wait(0.1)
            train(tonumber(SelectedZone), 2)
            wait(0.1)
            train(tonumber(SelectedZone), 3)
        end)
    end,
})

TogglesSection:AddButton({
    Title = "Rebirth Once",
    Callback = function()
        pcall(function()
            InvokeServerAction:InvokeServer("Rebirths", "Request")
        end)
    end,
})

-- ========== BALLS TAB ==========
local AutoBallsSection = BallsTab:AddSection({
    Title = "Auto Balls"
});

local ManualBallsSection = BallsTab:AddSection({
    Title = "Manual Balls"
});

-- Auto Equip Selected Ball
AutoBallsSection:AddToggle({
    Title = "Auto Equip Selected Ball",
    Default = false,
    Callback = function(value)
        AutoEquipSelectedBall = value
        if value then
            spawn(function()
                while AutoEquipSelectedBall do
                    equipBall(SelectedBall)
                    wait(0.5)
                end
            end)
        end
    end,
})

AutoBallsSection:AddDropdown({
    Title = "Select Ball to Auto Equip",
    Values = AllBalls,
    Default = 'Beach',
    Callback = function(value)
        SelectedBall = value
    end,
})

ManualBallsSection:AddDropdown({
    Title = "Select Ball to Equip",
    Values = AllBalls,
    Default = 'Beach',
    Callback = function(value)
        equipBall(value)
    end,
})

ManualBallsSection:AddButton({
    Title = "Equip Selected Ball",
    Callback = function()
        equipBall(SelectedBall)
    end,
})

ManualBallsSection:AddButton({
    Title = "Equip Beach Ball",
    Callback = function()
        equipBall("Beach")
    end,
})

ManualBallsSection:AddButton({
    Title = "Equip Aurion Nova",
    Callback = function()
        equipBall("Aurion Nova")
    end,
})

ManualBallsSection:AddButton({
    Title = "Equip Galaxy",
    Callback = function()
        equipBall("Galaxy")
    end,
})

-- ========== EGGS TAB ==========
local AutoEggsSection = EggsTab:AddSection({
    Title = "Auto Eggs"
});

local ManualEggsSection = EggsTab:AddSection({
    Title = "Manual Eggs"
});

AutoEggsSection:AddToggle({
    Title = "Auto Open All Eggs",
    Default = false,
    Callback = function(value)
        AutoOpenAllEggs = value
        if value then
            spawn(function()
                while AutoOpenAllEggs do
                    for _, eggName in ipairs(AllEggs) do
                        if not AutoOpenAllEggs then break end
                        openEgg(eggName, "max")
                        wait(0.3)
                    end
                    wait(2)
                end
            end)
        end
    end,
})

AutoEggsSection:AddToggle({
    Title = "Auto Open Selected Egg",
    Default = false,
    Callback = function(value)
        AutoOpenSelectedEgg = value
        if value then
            spawn(function()
                while AutoOpenSelectedEgg do
                    openEgg(SelectedEgg, "max")
                    wait(0.5)
                end
            end)
        end
    end,
})

AutoEggsSection:AddDropdown({
    Title = "Select Egg to Auto Open",
    Values = AllEggs,
    Default = 'Tree',
    Callback = function(value)
        SelectedEgg = value
    end,
})

ManualEggsSection:AddDropdown({
    Title = "Select Egg to Open",
    Values = AllEggs,
    Default = 'Tree',
    Callback = function(value)
        openEgg(value, "max")
    end,
})

ManualEggsSection:AddButton({
    Title = "Open Selected Egg (Max)",
    Callback = function()
        openEgg(SelectedEgg, "max")
    end,
})

ManualEggsSection:AddButton({
    Title = "Open Selected Egg (1)",
    Callback = function()
        openEgg(SelectedEgg, 1)
    end,
})

ManualEggsSection:AddButton({
    Title = "Open All Eggs Once",
    Callback = function()
        spawn(function()
            for _, eggName in ipairs(AllEggs) do
                openEgg(eggName, "max")
                wait(0.2)
            end
        end)
    end,
})

-- ========== ZONES TAB ==========
local AutoZonesSection = ZonesTab:AddSection({
    Title = "Auto Zones"
});

local ManualZonesSection = ZonesTab:AddSection({
    Title = "Manual Zones"
});

AutoZonesSection:AddDropdown({
    Title = "Select Zone to Purchase",
    Values = AllZones,
    Default = '1',
    Callback = function(value)
        SelectedBuyZone = value
    end,
})

-- Auto Buy Zone
AutoZonesSection:AddToggle({
    Title = "Auto Buy Selected Zone",
    Default = false,
    Callback = function(value)
        AutoBuyZone = value
        if value then
            spawn(function()
                while AutoBuyZone do
                    buyZone(tonumber(SelectedBuyZone))
                    wait(0.5)
                end
            end)
        end
    end,
})

-- Manual Zone Buttons
ManualZonesSection:AddButton({
    Title = "Buy Selected Zone Once",
    Callback = function()
        buyZone(tonumber(SelectedBuyZone))
    end,
})

ManualZonesSection:AddButton({
    Title = "Buy Selected Zone 10 Times",
    Callback = function()
        spawn(function()
            for i = 1, 10 do
                buyZone(tonumber(SelectedBuyZone))
                wait(0.1)
            end
        end)
    end,
})

ManualZonesSection:AddButton({
    Title = "Buy All Zones Once",
    Callback = function()
        spawn(function()
            for _, zoneNumber in ipairs(AllZones) do
                buyZone(tonumber(zoneNumber))
                wait(0.2)
            end
        end)
    end,
})

-- ========== PLAYER TAB ==========
local PlayerSection = PlayerTab:AddSection({
    Title = "Player Utilities"
});

local MovementSection = PlayerTab:AddSection({
    Title = "Movement"
});

-- Player Utilities
PlayerSection:AddButton({
    Title = "Reset Character",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character then
            player.Character:BreakJoints()
        end
    end,
})

PlayerSection:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end,
})

PlayerSection:AddButton({
    Title = "Server Hop",
    Callback = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local API = "https://games.roblox.com/v1/games/"
        
        local _place = game.PlaceId
        local _servers = API.._place.."/servers/Public?sortOrder=Asc&limit=100"
        local function ListServers(cursor)
            local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
            return Http:JSONDecode(Raw)
        end
        
        local Server, Next
        repeat
            local Servers = ListServers(Next)
            Server = Servers.data[1]
            Next = Servers.nextPageCursor
        until Server
        
        TPS:TeleportToPlaceInstance(_place, Server.id)
    end,
})

-- Movement
local Noclip = false
local SpeedEnabled = false
local JumpEnabled = false
local Speed = 16
local Jump = 50

MovementSection:AddToggle({
    Title = "Noclip",
    Default = false,
    Callback = function(value)
        Noclip = value
    end,
})

MovementSection:AddToggle({
    Title = "Enable Walk Speed",
    Default = false,
    Callback = function(value)
        SpeedEnabled = value
        if value then
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = Speed
            end
        else
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = 16
            end
        end
    end,
})

MovementSection:AddSlider({
    Title = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Rounding = 1,
    Callback = function(value)
        Speed = value
        if SpeedEnabled then
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = value
            end
        end
    end,
})

MovementSection:AddToggle({
    Title = "Enable Jump Power",
    Default = false,
    Callback = function(value)
        JumpEnabled = value
        if value then
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.JumpPower = Jump
            end
        else
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.JumpPower = 50
            end
        end
    end,
})

MovementSection:AddSlider({
    Title = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Rounding = 1,
    Callback = function(value)
        Jump = value
        if JumpEnabled then
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.JumpPower = value
            end
        end
    end,
})

-- ========== SETTINGS TAB ==========
local ConfigSection = SettingsTab:AddSection({
    Title = "Configuration"
});

local StatusSection = SettingsTab:AddSection({
    Title = "Status"
});

-- Status Display
local StatusParagraph = StatusSection:AddParagraph({
    Title = 'Current Status',
    Content = "Loading..."
})

-- Update status function
local function updateStatus()
    local status = {}
    if AutoWin then table.insert(status, "Auto Win: ON (Zone "..SelectedWinZone..")") else table.insert(status, "Auto Win: OFF") end
    if AutoTrain then table.insert(status, "Auto Train: ON (Zone "..SelectedZone..")") else table.insert(status, "Auto Train: OFF") end
    if AutoRebirth then table.insert(status, "Auto Rebirth: ON") else table.insert(status, "Auto Rebirth: OFF") end
    if AutoEquipSelectedBall then table.insert(status, "Auto Equip "..SelectedBall..": ON") else table.insert(status, "Auto Equip "..SelectedBall..": OFF") end
    if AutoOpenAllEggs then table.insert(status, "Auto Open All Eggs: ON") else table.insert(status, "Auto Open All Eggs: OFF") end
    if AutoOpenSelectedEgg then table.insert(status, "Auto Open "..SelectedEgg..": ON") else table.insert(status, "Auto Open "..SelectedEgg..": OFF") end
    if AutoBuyZone then table.insert(status, "Auto Buy Zone: ON (Zone "..SelectedBuyZone..")") else table.insert(status, "Auto Buy Zone: OFF") end
    if Noclip then table.insert(status, "Noclip: ON") else table.insert(status, "Noclip: OFF") end
    if SpeedEnabled then table.insert(status, "Speed: "..Speed) else table.insert(status, "Speed: OFF") end
    if JumpEnabled then table.insert(status, "Jump: "..Jump) else table.insert(status, "Jump: OFF") end
    
    StatusParagraph:SetContent(table.concat(status, "\n"))
end

-- Configuration
ConfigSection:AddParagraph({
    Title = 'Information',
    Content = "Complete Auto Farm Script\n• 25 Balls\n• 43 Eggs\n• 16 Win Zones\n• 16 Training Zones\n• 16 Purchase Zones\n• Player Utilities"
})

ConfigSection:AddButton({
    Title = "Disable All Auto Features",
    Callback = function()
        AutoWin = false
        AutoTrain = false
        AutoRebirth = false
        AutoEquipSelectedBall = false
        AutoOpenAllEggs = false
        AutoOpenSelectedEgg = false
        AutoBuyZone = false
        Noclip = false
        SpeedEnabled = false
        JumpEnabled = false
        updateStatus()
    end,
})

spawn(function()
    while true do
        updateStatus()
        wait(0.5)
    end
end)

spawn(function()
    while true do
        if Noclip then
            pcall(function()
                local character = game.Players.LocalPlayer.Character
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
        wait(0.1)
    end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    if SpeedEnabled then
        character:WaitForChild("Humanoid").WalkSpeed = Speed
    end
    if JumpEnabled then
        character:WaitForChild("Humanoid").JumpPower = Jump
    end
end)
