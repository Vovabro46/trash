local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/3345-c-a-t-s-u-s/Harmony/refs/heads/main/src/init.luau"))();

local Window = Library.new({
    Title = "Dinas Comeback "..Library.Version,
})

local MainTab = Window:AddTab({
    Title = "Main",
    Icon = "home"
});

local EggsTab = Window:AddTab({
    Title = "Eggs",
    Icon = "package"
});

local AutoTab = Window:AddTab({
    Title = "Auto Features",
    Icon = "zap"
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

-- Remote Objects
local Roll = ReplicatedStorage.Remote.Function.Aura.Roll
local PlayerEnd = ReplicatedStorage.Remote.Event.Game["[C-S]PlayerEnd"]
local DoLuck = ReplicatedStorage.Remote.Function.Luck["[C-S]DoLuck"]
local TryEatFood = ReplicatedStorage.Remote.Event.Food["[C-S]TryEatFood"]
local TryUpgrade = ReplicatedStorage.Remote.Event.Upgrade["[C-S]TryUpgrade"]
local PlayerTryClick = ReplicatedStorage.Remote.Event.Train["[C-S]PlayerTryClick"]

-- Auto Variables
local AutoRoll = false
local AutoMoney = false
local AutoClick = false
local AutoFood = false
local AutoUpgrade = false
local AutoOpenAllEggs = false
local AutoOpenSelectedEgg = false
local UltraFastMoneyRoll = false
local UltraFastClickFood = false
local AllAutoFeatures = false
local SelectedEgg = "Egg1"

-- Список яиц
local AllEggs = {
    "Egg1", "Egg2", "Egg3", "Egg4", "Egg5", "Egg6", "Egg7", "Egg8", "Egg9",
    "Event1", "Robux1", "Robux2", "Squid"
}

-- ========== MAIN TAB ==========
local MoneySection = MainTab:AddSection({
    Title = "Money & Farming"
});

local ManualSection = MainTab:AddSection({
    Title = "Manual Actions"
});

-- Бесконечные деньги (Fight15)
MoneySection:AddToggle({
    Title = "Auto Money",
    Default = false,
    Callback = function(value)
        AutoMoney = value
        if value then
            spawn(function()
                while AutoMoney do
                    pcall(function()
                        PlayerEnd:FireServer("Fight15")
                    end)
                    wait(0.1)
                end
            end)
        end
    end,
})

-- Быстрый авто ролл
MoneySection:AddToggle({
    Title = "Fast Auto Roll",
    Default = false,
    Callback = function(value)
        AutoRoll = value
        if value then
            spawn(function()
                while AutoRoll do
                    pcall(function()
                        Roll:InvokeServer()
                    end)
                    wait(0.1)
                end
            end)
        end
    end,
})

-- Быстрый клик
MoneySection:AddToggle({
    Title = "Fast Auto Click",
    Default = false,
    Callback = function(value)
        AutoClick = value
        if value then
            spawn(function()
                while AutoClick do
                    pcall(function()
                        PlayerTryClick:FireServer(true)
                    end)
                    wait(0.05)
                end
            end)
        end
    end,
})

-- Быстрая еда
MoneySection:AddToggle({
    Title = "Fast Auto Food",
    Default = false,
    Callback = function(value)
        AutoFood = value
        if value then
            spawn(function()
                while AutoFood do
                    pcall(function()
                        TryEatFood:FireServer()
                    end)
                    wait(0.1)
                end
            end)
        end
    end,
})

-- Авто апгрейд
MoneySection:AddToggle({
    Title = "Auto Upgrade",
    Default = false,
    Callback = function(value)
        AutoUpgrade = value
        if value then
            spawn(function()
                while AutoUpgrade do
                    pcall(function()
                        TryUpgrade:FireServer()
                    end)
                    wait(0.2)
                end
            end)
        end
    end,
})

-- Ручные кнопки
ManualSection:AddButton({
    Title = "Get Money Once",
    Callback = function()
        pcall(function()
            PlayerEnd:FireServer("Fight15")
        end)
    end,
})

ManualSection:AddButton({
    Title = "Roll Once",
    Callback = function()
        pcall(function()
            Roll:InvokeServer()
        end)
    end,
})

ManualSection:AddButton({
    Title = "Click Once",
    Callback = function()
        pcall(function()
            PlayerTryClick:FireServer(true)
        end)
    end,
})

ManualSection:AddButton({
    Title = "Eat Food Once",
    Callback = function()
        pcall(function()
            TryEatFood:FireServer()
        end)
    end,
})

ManualSection:AddButton({
    Title = "Upgrade Once",
    Callback = function()
        pcall(function()
            TryUpgrade:FireServer()
        end)
    end,
})

-- ========== EGGS TAB ==========
local AutoEggsSection = EggsTab:AddSection({
    Title = "Auto Eggs"
});

local ManualEggsSection = EggsTab:AddSection({
    Title = "Manual Eggs"
});

local SpecialEggsSection = EggsTab:AddSection({
    Title = "Special Eggs"
});

-- Auto Open All Eggs
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
                        pcall(function()
                            DoLuck:InvokeServer(eggName)
                        end)
                        wait(0.2)
                    end
                    wait(1)
                end
            end)
        end
    end,
})

-- Auto Open Selected Egg
AutoEggsSection:AddToggle({
    Title = "Auto Open Selected Egg",
    Default = false,
    Callback = function(value)
        AutoOpenSelectedEgg = value
        if value then
            spawn(function()
                while AutoOpenSelectedEgg do
                    pcall(function()
                        DoLuck:InvokeServer(SelectedEgg)
                    end)
                    wait(0.3)
                end
            end)
        end
    end,
})

-- Dropdown для выбора яйца
AutoEggsSection:AddDropdown({
    Title = "Select Egg to Auto Open",
    Values = AllEggs,
    Default = 'Egg1',
    Callback = function(value)
        SelectedEgg = value
    end,
})

-- Ручное открытие яиц
ManualEggsSection:AddDropdown({
    Title = "Select Egg to Open",
    Values = AllEggs,
    Default = 'Egg1',
    Callback = function(value)
        pcall(function()
            DoLuck:InvokeServer(value)
        end)
    end,
})

ManualEggsSection:AddButton({
    Title = "Open Selected Egg",
    Callback = function()
        pcall(function()
            DoLuck:InvokeServer(SelectedEgg)
        end)
    end,
})

ManualEggsSection:AddButton({
    Title = "Open All Eggs Once",
    Callback = function()
        spawn(function()
            for _, eggName in ipairs(AllEggs) do
                pcall(function()
                    DoLuck:InvokeServer(eggName)
                end)
                wait(0.1)
            end
        end)
    end,
})

-- Специальные яйца
SpecialEggsSection:AddButton({
    Title = "Open Egg9 (Special)",
    Callback = function()
        pcall(function()
            DoLuck:InvokeServer("Egg9")
        end)
    end,
})

SpecialEggsSection:AddButton({
    Title = "Open Robux Eggs",
    Callback = function()
        spawn(function()
            pcall(function() DoLuck:InvokeServer("Robux1") end)
            wait(0.1)
            pcall(function() DoLuck:InvokeServer("Robux2") end)
        end)
    end,
})

SpecialEggsSection:AddButton({
    Title = "Open Event & Squid",
    Callback = function()
        spawn(function()
            pcall(function() DoLuck:InvokeServer("Event1") end)
            wait(0.1)
            pcall(function() DoLuck:InvokeServer("Squid") end)
        end)
    end,
})

-- ========== AUTO FEATURES TAB ==========
local FastSection = AutoTab:AddSection({
    Title = "Fast Auto Features"
});

local SettingsSection = AutoTab:AddSection({
    Title = "Auto Settings"
});

-- Быстрые авто-функции
FastSection:AddToggle({
    Title = "Ultra Fast Money + Roll",
    Default = false,
    Callback = function(value)
        UltraFastMoneyRoll = value
        if value then
            spawn(function()
                while UltraFastMoneyRoll do
                    -- Money
                    pcall(function()
                        PlayerEnd:FireServer("Fight15")
                    end)
                    -- Roll
                    pcall(function()
                        Roll:InvokeServer()
                    end)
                    wait(0.05)
                end
            end)
        end
    end,
})

FastSection:AddToggle({
    Title = "Ultra Fast Click + Food",
    Default = false,
    Callback = function(value)
        UltraFastClickFood = value
        if value then
            spawn(function()
                while UltraFastClickFood do
                    -- Click
                    pcall(function()
                        PlayerTryClick:FireServer(true)
                    end)
                    -- Food
                    pcall(function()
                        TryEatFood:FireServer()
                    end)
                    wait(0.03)
                end
            end)
        end
    end,
})

-- Настройки задержек
local MoneyDelay = 0.1
local RollDelay = 0.1
local ClickDelay = 0.05
local FoodDelay = 0.1
local UpgradeDelay = 0.2

SettingsSection:AddSlider({
    Title = "Money Delay",
    Min = 0.01,
    Max = 1,
    Default = 0.1,
    Rounding = 2,
    Callback = function(value)
        MoneyDelay = value
    end,
})

SettingsSection:AddSlider({
    Title = "Roll Delay",
    Min = 0.01,
    Max = 1,
    Default = 0.1,
    Rounding = 2,
    Callback = function(value)
        RollDelay = value
    end,
})

SettingsSection:AddSlider({
    Title = "Click Delay",
    Min = 0.01,
    Max = 0.5,
    Default = 0.05,
    Rounding = 2,
    Callback = function(value)
        ClickDelay = value
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
    if AutoMoney then table.insert(status, "Auto Money: ON") else table.insert(status, "Auto Money: OFF") end
    if AutoRoll then table.insert(status, "Auto Roll: ON") else table.insert(status, "Auto Roll: OFF") end
    if AutoClick then table.insert(status, "Auto Click: ON") else table.insert(status, "Auto Click: OFF") end
    if AutoFood then table.insert(status, "Auto Food: ON") else table.insert(status, "Auto Food: OFF") end
    if AutoUpgrade then table.insert(status, "Auto Upgrade: ON") else table.insert(status, "Auto Upgrade: OFF") end
    if AutoOpenAllEggs then table.insert(status, "Auto Open All Eggs: ON") else table.insert(status, "Auto Open All Eggs: OFF") end
    if AutoOpenSelectedEgg then table.insert(status, "Auto Open "..SelectedEgg..": ON") else table.insert(status, "Auto Open "..SelectedEgg..": OFF") end
    if UltraFastMoneyRoll then table.insert(status, "Ultra Money+Roll: ON") else table.insert(status, "Ultra Money+Roll: OFF") end
    if UltraFastClickFood then table.insert(status, "Ultra Click+Food: ON") else table.insert(status, "Ultra Click+Food: OFF") end
    if AllAutoFeatures then table.insert(status, "All Features: ON") else table.insert(status, "All Features: OFF") end
    if Noclip then table.insert(status, "Noclip: ON") else table.insert(status, "Noclip: OFF") end
    if SpeedEnabled then table.insert(status, "Speed: "..Speed) else table.insert(status, "Speed: OFF") end
    if JumpEnabled then table.insert(status, "Jump: "..Jump) else table.insert(status, "Jump: OFF") end
    
    StatusParagraph:SetContent(table.concat(status, "\n"))
end

-- Configuration
ConfigSection:AddParagraph({
    Title = 'Information',
    Content = "Ultra Fast Auto Farm Script\n• Infinite Money\n• Fast Auto Roll\n• Fast Auto Click\n• Fast Auto Food\n• Auto Upgrade\n• 13 Eggs\n• Player Utilities"
})

ConfigSection:AddButton({
    Title = "Disable All Auto Features",
    Callback = function()
        AutoMoney = false
        AutoRoll = false
        AutoClick = false
        AutoFood = false
        AutoUpgrade = false
        AutoOpenAllEggs = false
        AutoOpenSelectedEgg = false
        UltraFastMoneyRoll = false
        UltraFastClickFood = false
        AllAutoFeatures = false
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
