local Version = "1.6.53"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()

WindUI:AddTheme({
    Name = "My Theme",
    Accent = Color3.fromHex("#18181b"),
    Dialog = Color3.fromHex("#161616"),
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#101010"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa")
})

local Window = WindUI:CreateWindow({
    Title = "Dinas Hub Best",
    Icon = "gamepad-2",
    Author = "by Dinas",
})

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Race = ReplicatedStorage.Remote.Race
local Egg = ReplicatedStorage.Remote.Egg
local Daily = ReplicatedStorage.Remote.Daily

-- Variables
local LocalPlayer = Players.LocalPlayer
local AutoFarmEnabled = false
local AutoOpenEggsEnabled = false
local FreeEggsEnabled = false
local SelectedEgg = "Egg1"
local EggAmount = 1

-- Farming Tab
local FarmingTab = Window:Tab({
    Title = "Auto Farm",
    Icon = "trending-up",
    Locked = false,
})

local AutoFarmToggle = FarmingTab:Toggle({
    Title = "Auto Farm Wins",
    Desc = "Automatically farm race wins",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        AutoFarmEnabled = state
        if state then
            farmWins()
        end
    end
})

local MoneyButton = FarmingTab:Button({
    Title = "Get Massive Money",
    Desc = "Get huge amount of money instantly",
    Locked = false,
    Callback = function()
        Race:FireServer("ToQuit", 999999999999999999999999999999)
        WindUI:Notify({
            Title = "Money Added",
            Text = "Massive money added to your account!",
            Duration = 3
        })
    end
})

local WinSlider = FarmingTab:Slider({
    Title = "Wins Per Second",
    Step = 1,
    Value = {
        Min = 1,
        Max = 500000,
        Default = 1,
    },
    Callback = function(value)
        getgenv().WinsPerSecond = value
    end
})

function farmWins()
    spawn(function()
        local winsPerSecond = getgenv().WinsPerSecond or 10
        while AutoFarmEnabled do
            for i = 1, winsPerSecond do
                Race:FireServer("GetWin")
            end
            wait(1)
        end
    end)
end

-- Eggs Tab
local EggsTab = Window:Tab({
    Title = "Egg System",
    Icon = "egg",
    Locked = false,
})

local Paragraph = EggsTab:Paragraph({
    Title = "Egg System",
    Desc = "Shop1,Shop2,Event eggs free(this donate eggs lol)",
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})

local EggList = {
    "Egg1", "Egg2", "Egg3", "Egg5", "Egg6", "Egg7", "Egg8", 
    "Egg9", "Egg10", "Egg11", "Egg12", "Egg13", "Shop1", "Shop2", "Event"
}

local EggDropdown = EggsTab:Dropdown({
    Title = "Select Egg Type",
    Desc = "Choose which egg to open",
    Values = EggList,
    Value = "Egg1",
    Multi = false,
    AllowNone = false,
    Callback = function(value)
        SelectedEgg = value
    end
})

local EggAmountSlider = EggsTab:Slider({
    Title = "Eggs To Open",
    Desc = "How many eggs to open at once",
    Step = 1,
    Value = {
        Min = 1,
        Max = 100,
        Default = 1,
    },
    Callback = function(value)
        EggAmount = value
    end
})

local OpenEggButton = EggsTab:Button({
    Title = "Open Eggs Now",
    Desc = "Open selected eggs immediately",
    Locked = false,
    Callback = function()
        Egg:FireServer("TryOpenEgg", SelectedEgg, EggAmount)
        WindUI:Notify({
            Title = "Eggs Opened",
            Text = "Opened " .. EggAmount .. " " .. SelectedEgg .. " eggs!",
            Duration = 3
        })
    end
})

local AutoOpenToggle = EggsTab:Toggle({
    Title = "Auto Open Eggs",
    Desc = "Continuously open selected eggs",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        AutoOpenEggsEnabled = state
        if state then
            autoOpenEggs()
        end
    end
})

function autoOpenEggs()
    spawn(function()
        while AutoOpenEggsEnabled do
            Egg:FireServer("TryOpenEgg", SelectedEgg, EggAmount)
            wait(0.5)
        end
    end)
end

-- Daily Rewards Tab
local DailyTab = Window:Tab({
    Title = "Daily Rewards",
    Icon = "calendar",
    Locked = false,
})

local DailyParagraph = DailyTab:Paragraph({
    Title = "Daily Rewards System",
    Desc = "Claim all 7 daily rewards instantly",
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})

local ClaimAllDailyButton = DailyTab:Button({
    Title = "🎁 Claim All Daily Rewards",
    Desc = "Instantly claim all 7 daily rewards",
    Locked = false,
    Callback = function()
        -- Claim all 7 daily rewards
        for day = 1, 7 do
            Daily:FireServer("TryClaim", day)
        end
        WindUI:Notify({
            Title = "🎁 Daily Rewards Claimed!",
            Text = "All 7 daily rewards collected successfully!",
            Duration = 5
        })
    end
})

local ClaimSpecificButton = DailyTab:Button({
    Title = "Claim Specific Day",
    Desc = "Claim reward for specific day (1-7)",
    Locked = false,
    Callback = function()
        for day = 1, 7 do
            Daily:FireServer("TryClaim", day)
            wait(0.1)
        end
        WindUI:Notify({
            Title = "Specific Reward Claimed",
            Text = "Attempted to claim all specific day rewards!",
            Duration = 4
        })
    end
})

local AutoDailyToggle = DailyTab:Toggle({
    Title = "Auto Claim Daily",
    Desc = "Automatically claim daily rewards on join",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        if state then
            -- Auto claim on toggle enable
            for day = 1, 7 do
                Daily:FireServer("TryClaim", day)
            end
            WindUI:Notify({
                Title = "Auto Daily Enabled",
                Text = "Daily rewards will be auto-claimed!",
                Duration = 4
            })
        end
    end
})

-- Quick Actions Tab
local QuickTab = Window:Tab({
    Title = "Quick Actions",
    Icon = "zap",
    Locked = false,
})

local InstantWinsButton = QuickTab:Button({
    Title = "Instant 100 Wins",
    Desc = "Get 100 wins immediately",
    Locked = false,
    Callback = function()
        for i = 1, 100 do
            Race:FireServer("GetWin")
        end
        WindUI:Notify({
            Title = "Wins Added",
            Text = "100 wins added to your account!",
            Duration = 3
        })
    end
})

local InstantWinsButton2 = QuickTab:Button({
    Title = "Instant 10000 Wins",
    Desc = "Get 10000 wins immediately",
    Locked = false,
    Callback = function()
        for i = 1, 10000 do
            Race:FireServer("GetWin")
        end
        WindUI:Notify({
            Title = "Wins Added",
            Text = "10000 wins added to your account!",
            Duration = 3
        })
    end
})

local MaxMoneyButton = QuickTab:Button({
    Title = "Max Money",
    Desc = "Get maximum possible money",
    Locked = false,
    Callback = function()
        for i = 1, 10 do
            Race:FireServer("ToQuit", 999999999999999999999999999999)
        end
        WindUI:Notify({
            Title = "Max Money",
            Text = "Maximum money achieved!",
            Duration = 3
        })
    end
})

local BestEggButton = QuickTab:Button({
    Title = "Open Best Eggs",
    Desc = "Open 50 of the best eggs",
    Locked = false,
    Callback = function()
        for i = 1, 50 do
            Egg:FireServer("TryOpenEgg", "Egg13", 1)
        end
        WindUI:Notify({
            Title = "Best Eggs Opened",
            Text = "Opened 50 of the best eggs!",
            Duration = 3
        })
    end
})

local DailyQuickButton = QuickTab:Button({
    Title = "Quick Daily Rewards",
    Desc = "Claim all daily rewards instantly",
    Locked = false,
    Callback = function()
        for day = 1, 7 do
            Daily:FireServer("TryClaim", day)
        end
        WindUI:Notify({
            Title = "Daily Rewards",
            Text = "All daily rewards claimed quickly!",
            Duration = 3
        })
    end
})

-- Player Tab
local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user",
    Locked = false,
})

local WalkSpeedSlider = PlayerTab:Slider({
    Title = "Walk Speed",
    Desc = "Adjust player walk speed",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = 16,
    },
    Callback = function(value)
        LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = value
    end
})

local JumpPowerSlider = PlayerTab:Slider({
    Title = "Jump Power",
    Desc = "Adjust player jump power",
    Step = 1,
    Value = {
        Min = 50,
        Max = 200,
        Default = 50,
    },
    Callback = function(value)
        LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = value
    end
})

local AntiAFKToggle = PlayerTab:Toggle({
    Title = "Anti-AFK",
    Desc = "Prevent being kicked for AFK",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        if state then
            -- Anti-AFK system
            LocalPlayer.Idled:Connect(function()
                game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                wait(1)
                game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            end)
        end
    end
})

-- Auto-apply player modifications
LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    
    if getgenv().CustomWalkSpeed then
        character.Humanoid.WalkSpeed = getgenv().CustomWalkSpeed
    end
    
    if getgenv().CustomJumpPower then
        character.Humanoid.JumpPower = getgenv().CustomJumpPower
    end
end)

-- Save settings
WalkSpeedSlider.Callback = function(value)
    getgenv().CustomWalkSpeed = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end

JumpPowerSlider.Callback = function(value)
    getgenv().CustomJumpPower = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = value
    end
end
