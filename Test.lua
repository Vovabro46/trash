local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local Library = {
    Flags = {},
    Items = {},
    Registry = {},
    ActivePicker = nil,
    WatermarkObj = nil,
    NotifyContainer = nil,
    Preview = nil,
    ConfigFolder = "RedOnyx_Configs",
    ConfigExt = ".json",
    WatermarkSettings = {
        Enabled = true,
        Text = "RedOnyx"
    },
    GlobalSettings = {
        Animations = true
    },
    Theme = {
        Background     = Color3.fromRGB(15, 15, 15),
        Sidebar        = Color3.fromRGB(20, 20, 20),
        Groupbox       = Color3.fromRGB(25, 25, 25),
        ItemBackground = Color3.fromRGB(35, 35, 35),
        Outline        = Color3.fromRGB(45, 45, 45),
        Accent         = Color3.fromRGB(255, 40, 40),
        Text           = Color3.fromRGB(235, 235, 235),
        TextDark       = Color3.fromRGB(140, 140, 140),
        Header         = Color3.fromRGB(100, 100, 100)
    },
    ThemePresets = {
        ["Default"] = {
            Background     = Color3.fromRGB(15, 15, 15),
            Sidebar        = Color3.fromRGB(20, 20, 20),
            Groupbox       = Color3.fromRGB(25, 25, 25),
            ItemBackground = Color3.fromRGB(35, 35, 35),
            Outline        = Color3.fromRGB(45, 45, 45),
            Accent         = Color3.fromRGB(255, 40, 40),
            Text           = Color3.fromRGB(235, 235, 235),
            TextDark       = Color3.fromRGB(140, 140, 140),
            Header         = Color3.fromRGB(100, 100, 100)
        },
        ["ImGui Classic"] = { -- Extracted from StyleColorsClassic() in imgui_draw.cpp
            Background     = Color3.fromRGB(10, 10, 15),      -- WindowBg (darker blue-ish black)
            Sidebar        = Color3.fromRGB(30, 30, 40),      -- Slightly lighter for contrast
            Groupbox       = Color3.fromRGB(15, 15, 20),      -- ChildBg
            ItemBackground = Color3.fromRGB(40, 40, 50),      -- FrameBg
            Outline        = Color3.fromRGB(80, 80, 100),     -- Border
            Accent         = Color3.fromRGB(82, 82, 161),     -- TitleBgActive (The iconic ImGui Blue/Purple)
            Text           = Color3.fromRGB(230, 230, 230),   -- Text
            TextDark       = Color3.fromRGB(153, 153, 153),   -- TextDisabled
            Header         = Color3.fromRGB(68, 68, 138)      -- Header
        },
        ["Light"] = {
            Background     = Color3.fromRGB(240, 240, 240),
            Sidebar        = Color3.fromRGB(225, 225, 225),
            Groupbox       = Color3.fromRGB(255, 255, 255),
            ItemBackground = Color3.fromRGB(245, 245, 245),
            Outline        = Color3.fromRGB(200, 200, 200),
            Accent         = Color3.fromRGB(0, 120, 215),
            Text           = Color3.fromRGB(20, 20, 20),
            TextDark       = Color3.fromRGB(100, 100, 100),
            Header         = Color3.fromRGB(80, 80, 80)
        },
        ["Midnight"] = {
            Background     = Color3.fromRGB(10, 10, 20),
            Sidebar        = Color3.fromRGB(15, 15, 30),
            Groupbox       = Color3.fromRGB(20, 20, 40),
            ItemBackground = Color3.fromRGB(25, 25, 50),
            Outline        = Color3.fromRGB(40, 40, 70),
            Accent         = Color3.fromRGB(80, 140, 255),
            Text           = Color3.fromRGB(220, 230, 255),
            TextDark       = Color3.fromRGB(120, 130, 160),
            Header         = Color3.fromRGB(90, 100, 130)
        },
        ["Forest"] = {
            Background     = Color3.fromRGB(15, 20, 15),
            Sidebar        = Color3.fromRGB(20, 25, 20),
            Groupbox       = Color3.fromRGB(25, 30, 25),
            ItemBackground = Color3.fromRGB(30, 35, 30),
            Outline        = Color3.fromRGB(45, 60, 45),
            Accent         = Color3.fromRGB(80, 200, 80),
            Text           = Color3.fromRGB(235, 245, 235),
            TextDark       = Color3.fromRGB(140, 160, 140),
            Header         = Color3.fromRGB(100, 120, 100)
        },
        ["Amethyst"] = {
            Background     = Color3.fromRGB(20, 15, 20),
            Sidebar        = Color3.fromRGB(25, 20, 25),
            Groupbox       = Color3.fromRGB(30, 25, 30),
            ItemBackground = Color3.fromRGB(40, 30, 40),
            Outline        = Color3.fromRGB(60, 45, 60),
            Accent         = Color3.fromRGB(180, 80, 255),
            Text           = Color3.fromRGB(245, 235, 245),
            TextDark       = Color3.fromRGB(160, 140, 160),
            Header         = Color3.fromRGB(120, 100, 120)
        },
        ["Sunset"] = {
            Background     = Color3.fromRGB(20, 15, 10),
            Sidebar        = Color3.fromRGB(30, 20, 15),
            Groupbox       = Color3.fromRGB(40, 25, 20),
            ItemBackground = Color3.fromRGB(50, 30, 25),
            Outline        = Color3.fromRGB(70, 45, 40),
            Accent         = Color3.fromRGB(255, 100, 50),
            Text           = Color3.fromRGB(255, 235, 220),
            TextDark       = Color3.fromRGB(180, 140, 120),
            Header         = Color3.fromRGB(150, 110, 90)
        },
        ["Ocean"] = {
            Background     = Color3.fromRGB(10, 15, 20),
            Sidebar        = Color3.fromRGB(15, 20, 30),
            Groupbox       = Color3.fromRGB(20, 25, 40),
            ItemBackground = Color3.fromRGB(25, 30, 50),
            Outline        = Color3.fromRGB(40, 50, 70),
            Accent         = Color3.fromRGB(0, 200, 255),
            Text           = Color3.fromRGB(220, 240, 255),
            TextDark       = Color3.fromRGB(120, 150, 180),
            Header         = Color3.fromRGB(90, 120, 150)
        },
        ["Crimson"] = {
            Background     = Color3.fromRGB(20, 10, 10),
            Sidebar        = Color3.fromRGB(30, 15, 15),
            Groupbox       = Color3.fromRGB(40, 20, 20),
            ItemBackground = Color3.fromRGB(50, 25, 25),
            Outline        = Color3.fromRGB(70, 35, 35),
            Accent         = Color3.fromRGB(220, 20, 60),
            Text           = Color3.fromRGB(255, 220, 220),
            TextDark       = Color3.fromRGB(180, 120, 120),
            Header         = Color3.fromRGB(150, 90, 90)
        },
        ["Terminal"] = {
            Background     = Color3.fromRGB(0, 10, 0),
            Sidebar        = Color3.fromRGB(0, 15, 0),
            Groupbox       = Color3.fromRGB(0, 20, 0),
            ItemBackground = Color3.fromRGB(0, 25, 0),
            Outline        = Color3.fromRGB(0, 40, 0),
            Accent         = Color3.fromRGB(0, 255, 0),
            Text           = Color3.fromRGB(200, 255, 200),
            TextDark       = Color3.fromRGB(0, 150, 0),
            Header         = Color3.fromRGB(0, 120, 0)
        },
        ["Royal Gold"] = {
            Background     = Color3.fromRGB(20, 15, 5),
            Sidebar        = Color3.fromRGB(30, 20, 10),
            Groupbox       = Color3.fromRGB(40, 25, 15),
            ItemBackground = Color3.fromRGB(50, 30, 20),
            Outline        = Color3.fromRGB(70, 45, 30),
            Accent         = Color3.fromRGB(255, 215, 0),
            Text           = Color3.fromRGB(255, 245, 200),
            TextDark       = Color3.fromRGB(180, 160, 100),
            Header         = Color3.fromRGB(150, 130, 70)
        },
        ["Arctic"] = {
            Background     = Color3.fromRGB(230, 240, 255),
            Sidebar        = Color3.fromRGB(210, 225, 245),
            Groupbox       = Color3.fromRGB(250, 250, 255),
            ItemBackground = Color3.fromRGB(240, 245, 255),
            Outline        = Color3.fromRGB(180, 200, 230),
            Accent         = Color3.fromRGB(0, 100, 200),
            Text           = Color3.fromRGB(10, 20, 40),
            TextDark       = Color3.fromRGB(100, 120, 150),
            Header         = Color3.fromRGB(70, 90, 120)
        }
    }
}

--// THEME SYSTEM //--
local ThemeObjects = {}
function Library:RegisterTheme(Obj, Prop, Key)
    if not ThemeObjects[Key] then ThemeObjects[Key] = {} end
    table.insert(ThemeObjects[Key], {Obj = Obj, Prop = Prop})
    Obj[Prop] = Library.Theme[Key]
end

function Library:UpdateTheme(Key, Col)
    Library.Theme[Key] = Col
    if ThemeObjects[Key] then
        for _, D in pairs(ThemeObjects[Key]) do
            pcall(function() TweenService:Create(D.Obj, TweenInfo.new(0.2), {[D.Prop] = Col}):Play() end)
        end
    end
end

function Library:SetTheme(ThemeName)
    local Preset = Library.ThemePresets[ThemeName]
    if not Preset then 
        warn("Theme preset not found: "..tostring(ThemeName))
        return 
    end
    for Key, Color in pairs(Preset) do
        Library:UpdateTheme(Key, Color)
    end
end

function Library:FadeIn(Object, Time)
    if not Library.GlobalSettings.Animations then 
        if Object:IsA("CanvasGroup") then Object.GroupTransparency = 0 end
        Object.Visible = true 
        return 
    end
    
    Object.Visible = true
    if Object:IsA("CanvasGroup") then
        Object.GroupTransparency = 1
        TweenService:Create(Object, TweenInfo.new(Time or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            GroupTransparency = 0
        }):Play()
    else
        local t = Object.Transparency
        Object.BackgroundTransparency = 1
        TweenService:Create(Object, TweenInfo.new(Time or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0
        }):Play()
    end
end

--// TOOLTIP SYSTEM //
local TooltipObj = nil
local function CreateTooltipSystem(ScreenGui)
    local Tooltip = Instance.new("TextLabel")
    Tooltip.Name = "Tooltip"
    Tooltip.Size = UDim2.new(0, 0, 0, 0)
    Tooltip.AutomaticSize = Enum.AutomaticSize.XY
    Tooltip.BackgroundColor3 = Library.Theme.ItemBackground 
    Tooltip.TextColor3 = Library.Theme.Text
    Tooltip.Font = Enum.Font.Gotham
    Tooltip.TextSize = 12
    Tooltip.TextWrapped = false
    Tooltip.Visible = false
    Tooltip.ZIndex = 1000
    Tooltip.Parent = ScreenGui

    Instance.new("UICorner", Tooltip).CornerRadius = UDim.new(0, 4)
    local TStroke = Instance.new("UIStroke", Tooltip)
    TStroke.Color = Library.Theme.Outline 
    TStroke.Thickness = 1
    Instance.new("UIPadding", Tooltip).PaddingLeft = UDim.new(0, 6)
    Instance.new("UIPadding", Tooltip).PaddingRight = UDim.new(0, 6)
    Instance.new("UIPadding", Tooltip).PaddingTop = UDim.new(0, 4)
    Instance.new("UIPadding", Tooltip).PaddingBottom = UDim.new(0, 4)

    Library:RegisterTheme(Tooltip, "BackgroundColor3", "ItemBackground")
    Library:RegisterTheme(Tooltip, "TextColor3", "Text")
    Library:RegisterTheme(TStroke, "Color", "Outline")

    RunService.RenderStepped:Connect(function()
        if Tooltip.Visible then
            local MPos = UserInputService:GetMouseLocation()
            Tooltip.Position = UDim2.new(0, MPos.X + 15, 0, MPos.Y + 15)
        end
    end)

    TooltipObj = Tooltip
end

local function AddTooltip(HoverObject, Text)
    if not Text or Text == "" or not TooltipObj then return end
    HoverObject.MouseEnter:Connect(function()
        TooltipObj.Text = Text
        TooltipObj.Visible = true
    end)
    HoverObject.MouseLeave:Connect(function()
        TooltipObj.Visible = false
    end)
end

--// NOTIFICATIONS //--
function Library:InitNotifications(ScreenGui)
    local Holder = Instance.new("Frame")
    Holder.Name = "Notifications"
    Holder.Size = UDim2.new(0, 300, 1, -20)
    Holder.Position = UDim2.new(1, -310, 0, 10)
    Holder.AnchorPoint = Vector2.new(0, 0)
    Holder.BackgroundTransparency = 1
    Holder.ZIndex = 1000 
    Holder.Parent = ScreenGui

    local List = Instance.new("UIListLayout", Holder)
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.VerticalAlignment = Enum.VerticalAlignment.Bottom
    List.Padding = UDim.new(0, 6)

    Library.NotifyContainer = Holder
end

function Library:Notify(Title, Content, Duration)
    if not Library.NotifyContainer then return end
    Duration = Duration or 3

    local Wrapper = Instance.new("Frame")
    Wrapper.Name = "NotifyWrapper"
    Wrapper.Size = UDim2.new(1, 0, 0, 0)
    Wrapper.BackgroundTransparency = 1
    Wrapper.ClipsDescendants = true
    Wrapper.Parent = Library.NotifyContainer

    local Box = Instance.new("Frame")
    Box.Name = "Box"
    Box.Size = UDim2.new(1, 0, 1, 0)
    Box.Position = UDim2.new(1, 20, 0, 0)
    Box.BackgroundColor3 = Library.Theme.Background
    Box.Parent = Wrapper

    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
    local Stroke = Instance.new("UIStroke", Box)
    Stroke.Thickness = 1
    Stroke.Color = Library.Theme.Outline

    local Line = Instance.new("Frame", Box)
    Line.Size = UDim2.new(0, 2, 1, 0)
    Line.BackgroundColor3 = Library.Theme.Accent
    Instance.new("UICorner", Line).CornerRadius = UDim.new(0, 4)

    local TLab = Instance.new("TextLabel", Box)
    TLab.Size = UDim2.new(1, -15, 0, 20)
    TLab.Position = UDim2.new(0, 10, 0, 5)
    TLab.BackgroundTransparency = 1
    TLab.Text = Title
    TLab.Font = Enum.Font.GothamBold
    TLab.TextSize = 13
    TLab.TextColor3 = Library.Theme.Text
    TLab.TextXAlignment = Enum.TextXAlignment.Left

    local CLab = Instance.new("TextLabel", Box)
    CLab.Size = UDim2.new(1, -15, 0, 20)
    CLab.Position = UDim2.new(0, 10, 0, 25)
    CLab.BackgroundTransparency = 1
    CLab.Text = Content
    CLab.Font = Enum.Font.Gotham
    CLab.TextSize = 12
    CLab.TextColor3 = Library.Theme.TextDark
    CLab.TextXAlignment = Enum.TextXAlignment.Left

    TweenService:Create(Wrapper, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 50)}):Play()
    TweenService:Create(Box, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    task.delay(Duration, function()
        if not Box or not Wrapper then return end
        local OutTween = TweenService:Create(Box, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, 0, 0)})
        OutTween:Play()
        OutTween.Completed:Wait()
        local ShrinkTween = TweenService:Create(Wrapper, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)})
        ShrinkTween:Play()
        ShrinkTween.Completed:Wait()
        Wrapper:Destroy()
    end)
end

--// CONFIG SYSTEM //--
function Library:InitConfig()
    if writefile and readfile and makefolder and listfiles then
        if not isfolder(Library.ConfigFolder) then makefolder(Library.ConfigFolder) end
        return true
    end
    return false
end

function Library:SaveConfig(Name)
    if not Library:InitConfig() or not Name or Name == "" then return end
    local Encoded = HttpService:JSONEncode(Library.Flags)
    writefile(Library.ConfigFolder.."/"..Name..Library.ConfigExt, Encoded)
    Library:Notify("Config Saved", "Successfully saved: " .. Name, 3)
end

function Library:LoadConfig(Name)
    if not Library:InitConfig() or not Name then return end
    local Path = Library.ConfigFolder.."/"..Name..Library.ConfigExt
    if isfile(Path) then
        local Data = HttpService:JSONDecode(readfile(Path))
        if Data then
            for Flag, Value in pairs(Data) do
                if Library.Items[Flag] and Library.Items[Flag].Set then
                    Library.Items[Flag].Set(Value)
                end
            end
            Library:Notify("Config Loaded", "Loaded settings: " .. Name, 3)
        end
    end
end

function Library:DeleteConfig(Name)
    if not Library:InitConfig() or not Name then return end
    local Path = Library.ConfigFolder.."/"..Name..Library.ConfigExt
    if isfile(Path) then
        delfile(Path)
        Library:Notify("Config Deleted", "Deleted config: " .. Name, 3)
    end
end

function Library:GetConfigs()
    if not Library:InitConfig() then return {} end
    local Configs = {}
    if listfiles then
        for _, File in pairs(listfiles(Library.ConfigFolder)) do
            if File:sub(-#Library.ConfigExt) == Library.ConfigExt then
                local Name = File:match("([^/]+)"..Library.ConfigExt.."$") or File
                table.insert(Configs, Name)
            end
        end
    end
    return Configs
end

local function MakeDraggable(dragFrame, moveFrame)
    local dragging, dragInput, dragStart, startPos
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = moveFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            moveFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

--// WATERMARK //--
function Library:Watermark(Name)
    Library.WatermarkSettings.Text = Name
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Watermark"
    ScreenGui.ResetOnSpawn = false
    if RunService:IsStudio() then ScreenGui.Parent = Player:WaitForChild("PlayerGui") else pcall(function() ScreenGui.Parent = CoreGui end) end

    Library:InitNotifications(ScreenGui)

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 0, 0, 22)
    Frame.Position = UDim2.new(0.01, 0, 0.01, 0)
    Frame.BackgroundColor3 = Library.Theme.Background
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
    Library:RegisterTheme(Frame, "BackgroundColor3", "Background")

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Thickness = 1
    Library:RegisterTheme(Stroke, "Color", "Outline")

    local TopLine = Instance.new("Frame")
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    TopLine.BorderSizePixel = 0
    TopLine.Parent = Frame
    Library:RegisterTheme(TopLine, "BackgroundColor3", "Accent")

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, -10, 1, 0)
    Text.Position = UDim2.new(0, 5, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Font = Enum.Font.GothamBold
    Text.TextSize = 12
    Text.Text = Name
    Text.Parent = Frame
    Library:RegisterTheme(Text, "TextColor3", "Text")

    RunService.RenderStepped:Connect(function()
        ScreenGui.Enabled = Library.WatermarkSettings.Enabled
        if ScreenGui.Enabled then
            local FPS = math.floor(1 / math.max(RunService.RenderStepped:Wait(), 0.001))
            local PingVal = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
            local Ping = math.floor(PingVal:split(" ")[1] or 0)
            local CurrentName = Library.WatermarkSettings.Text
            Text.Text = string.format("%s | FPS: %d | Ping: %d | %s", CurrentName, FPS, Ping, os.date("%H:%M:%S"))
            Frame.Size = UDim2.new(0, Text.TextBounds.X + 14, 0, 24)
        end
    end)
    Library.WatermarkObj = ScreenGui
end

--// MAIN WINDOW //--
function Library:Window(TitleText)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RedOnyx"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global 
    if RunService:IsStudio() then ScreenGui.Parent = Player:WaitForChild("PlayerGui") else pcall(function() ScreenGui.Parent = CoreGui end) end

    CreateTooltipSystem(ScreenGui)

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 750, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -375, 0.5, -250)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    Library:RegisterTheme(MainFrame, "BackgroundColor3", "Background")

    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Thickness = 1
    Library:RegisterTheme(MainStroke, "Color", "Outline")
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 4)
    
    --// RESIZER HANDLE //--
    local Resizer = Instance.new("TextButton")
    Resizer.Name = "Resizer"
    Resizer.Size = UDim2.new(0, 30, 0, 30)
    Resizer.AnchorPoint = Vector2.new(1, 1)
    Resizer.Position = UDim2.new(1, 0, 1, 0)
    Resizer.BackgroundTransparency = 1
    Resizer.Text = "◢"
    Resizer.TextSize = 16
    Resizer.TextXAlignment = Enum.TextXAlignment.Right
    Resizer.TextYAlignment = Enum.TextYAlignment.Bottom 
    Resizer.Font = Enum.Font.Gotham
    Resizer.Parent = MainFrame
    Resizer.ZIndex = 200 
    Library:RegisterTheme(Resizer, "TextColor3", "TextDark")
    AddTooltip(Resizer, "Resize")

    local draggingResize = false
    local dragStartResize = Vector2.new()
    local startSizeResize = UDim2.new()
    local dragInputResize = nil

    Resizer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingResize = true
            dragStartResize = input.Position
            startSizeResize = MainFrame.Size
            dragInputResize = input

            TweenService:Create(Resizer, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Accent}):Play()
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingResize = false
                    dragInputResize = nil
                    TweenService:Create(Resizer, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextDark}):Play()
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingResize and (input == dragInputResize or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStartResize
            local newX = startSizeResize.X.Offset + delta.X
            local newY = startSizeResize.Y.Offset + delta.Y
            
            if newX < 300 then newX = 300 end
            if newY < 200 then newY = 200 end
            
            MainFrame.Size = UDim2.new(0, newX, 0, newY)
        end
    end)

    --// SIDEBAR //--
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.Parent = MainFrame
    Sidebar.ZIndex = 2 
    Library:RegisterTheme(Sidebar, "BackgroundColor3", "Sidebar")
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 4)

    local Logo = Instance.new("TextLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(1, 0, 0, 50)
    Logo.BackgroundTransparency = 1
    Logo.Text = TitleText
    Logo.Font = Enum.Font.GothamBlack
    Logo.TextSize = 22
    Logo.Parent = Sidebar
    Logo.ZIndex = 5 
    Library:RegisterTheme(Logo, "TextColor3", "Accent")

    --// SEARCH BAR //--
    local SearchBar = Instance.new("TextBox")
    SearchBar.Name = "SearchBar"
    SearchBar.Size = UDim2.new(1, -20, 0, 30)
    SearchBar.Position = UDim2.new(0, 10, 0, 55)
    SearchBar.BackgroundColor3 = Library.Theme.ItemBackground
    SearchBar.BorderSizePixel = 0
    SearchBar.PlaceholderText = "Search..."
    SearchBar.Text = ""
    SearchBar.TextColor3 = Library.Theme.Text
    SearchBar.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    SearchBar.Font = Enum.Font.Gotham
    SearchBar.TextSize = 13
    SearchBar.Parent = Sidebar
    SearchBar.ZIndex = 5 
    Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 4)
    local SBStroke = Instance.new("UIStroke", SearchBar)
    SBStroke.Color = Library.Theme.Outline
    SBStroke.Thickness = 1
    SBStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
   
    Library:RegisterTheme(SearchBar, "BackgroundColor3", "ItemBackground")

    --// TAB CONTAINER //--
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, -95)
    TabContainer.Position = UDim2.new(0, 0, 0, 95)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar
    TabContainer.ZIndex = 3 
    TabContainer.Visible = true 
    local TabLayout = Instance.new("UIListLayout", TabContainer)
    TabLayout.Padding = UDim.new(0, 2)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    --// SEARCH RESULTS //--
    local SearchResults = Instance.new("ScrollingFrame")
    SearchResults.Name = "SearchResults"
    SearchResults.Size = UDim2.new(1, 0, 1, -95)
    SearchResults.Position = UDim2.new(0, 0, 0, 95)
    SearchResults.BackgroundTransparency = 1
    SearchResults.BackgroundColor3 = Library.Theme.Sidebar 
    SearchResults.ScrollBarThickness = 2
    SearchResults.ScrollBarImageColor3 = Library.Theme.Accent
    SearchResults.Visible = false 
    SearchResults.Parent = Sidebar
    SearchResults.ZIndex = 10 
    local SearchLayout = Instance.new("UIListLayout", SearchResults)
    SearchLayout.Padding = UDim.new(0, 2)
    SearchLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local PagesArea = Instance.new("Frame")
    PagesArea.Name = "PagesArea"
    PagesArea.Size = UDim2.new(1, -180, 1, 0)
    PagesArea.Position = UDim2.new(0, 180, 0, 0)
    PagesArea.BackgroundTransparency = 1
    PagesArea.Parent = MainFrame

    MakeDraggable(Sidebar, MainFrame)
    MakeDraggable(PagesArea, MainFrame)

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleUI"
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
    ToggleBtn.Text = "UI"
    ToggleBtn.TextColor3 = Library.Theme.Accent
    ToggleBtn.Font = Enum.Font.GothamBlack
    ToggleBtn.Parent = ScreenGui
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", ToggleBtn).Color = Library.Theme.Accent
    MakeDraggable(ToggleBtn, ToggleBtn)
    ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    local DropdownHolder = Instance.new("Frame")
    DropdownHolder.Name = "DropdownHolder"
    DropdownHolder.Size = UDim2.new(1,0,1,0)
    DropdownHolder.BackgroundTransparency = 1
    DropdownHolder.Visible = false
    DropdownHolder.ZIndex = 100
    DropdownHolder.Parent = ScreenGui 

    --// SEARCH LOGIC //--
    SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local Input = SearchBar.Text:lower()
        if #Input == 0 then
            TabContainer.Visible = true
            SearchResults.Visible = false
        else
            TabContainer.Visible = false
            SearchResults.Visible = true
            
            for _, v in pairs(SearchResults:GetChildren()) do
                if v:IsA("TextButton") then v:Destroy() end
            end

            for _, ItemData in pairs(Library.Registry) do
                if string.find(ItemData.Name:lower(), Input, 1, true) then
                    local ResBtn = Instance.new("TextButton")
                    ResBtn.Size = UDim2.new(1, 0, 0, 25)
                    ResBtn.BackgroundTransparency = 1
                    ResBtn.Text = "  " .. ItemData.Name
                    ResBtn.Font = Enum.Font.Gotham
                    ResBtn.TextSize = 12
                    ResBtn.TextColor3 = Library.Theme.TextDark
                    ResBtn.TextXAlignment = Enum.TextXAlignment.Left
                    ResBtn.Parent = SearchResults
                    ResBtn.ZIndex = 11
                    
                    local P = Instance.new("UIPadding", ResBtn)
                    P.PaddingLeft = UDim.new(0, 15)

                    ResBtn.MouseButton1Click:Connect(function()
                        if ItemData.TabBtn then
                            for _, v in pairs(TabContainer:GetChildren()) do
                                if v:IsA("TextButton") then
                                    TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextDark}):Play()
                                    if v:FindFirstChild("ActiveIndicator") then v.ActiveIndicator.Visible = false end
                                end
                            end
                            for _, v in pairs(PagesArea:GetChildren()) do 
                                if v:IsA("CanvasGroup") then
                                    v.Visible = false 
                                    v.GroupTransparency = 1 
                                end
                            end
                            
                            TweenService:Create(ItemData.TabBtn, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Text}):Play()
                            if ItemData.TabBtn:FindFirstChild("ActiveIndicator") then ItemData.TabBtn.ActiveIndicator.Visible = true end
                            
                            local PageFrame = ItemData.TabBtn:FindFirstChild("PageRef") and ItemData.TabBtn.PageRef.Value
                            if PageFrame then Library:FadeIn(PageFrame) end
                        end

                        if ItemData.SubTabBtn and ItemData.SubPage then
                            for _, v in pairs(ItemData.SubPage.Parent:GetChildren()) do 
                                if v:IsA("CanvasGroup") then v.Visible = false v.GroupTransparency = 1 end 
                            end
                            for _, v in pairs(ItemData.SubTabBtn.Parent:GetChildren()) do 
                                if v:IsA("TextButton") then 
                                    TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextDark}):Play() 
                                end 
                            end
                            
                            Library:FadeIn(ItemData.SubPage)
                            TweenService:Create(ItemData.SubTabBtn, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Accent}):Play()
                        end
                        
                        if ItemData.Object then
                            local OriginalColor = ItemData.Object.BackgroundColor3
                            local HighlightTween = TweenService:Create(ItemData.Object, TweenInfo.new(0.5), {BackgroundColor3 = Library.Theme.Accent})
                            local RestoreTween = TweenService:Create(ItemData.Object, TweenInfo.new(0.5), {BackgroundColor3 = OriginalColor})
                            HighlightTween:Play()
                            HighlightTween.Completed:Wait()
                            RestoreTween:Play()
                        end
                    end)
                end
            end
            SearchResults.CanvasSize = UDim2.new(0, 0, 0, SearchLayout.AbsoluteContentSize.Y)
        end
    end)


    local WindowFuncs = {}
    local FirstTab = true

    function WindowFuncs:Section(Text)
        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(1,0,0,25)
        L.BackgroundTransparency=1
        L.Text="  "..string.upper(Text)
        L.Font=Enum.Font.GothamBold
        L.TextSize=11
        L.TextXAlignment=Enum.TextXAlignment.Left
        L.Parent=TabContainer
        L.ZIndex = 5 
        Library:RegisterTheme(L, "TextColor3", "Header")
        local P=Instance.new("UIPadding",L)
        P.PaddingTop=UDim.new(0,10)
        P.PaddingLeft=UDim.new(0,15)
    end

    function WindowFuncs:Tab(Name, IconId)
        local Btn = Instance.new("TextButton")
        Btn.Name = Name
        Btn.Size = UDim2.new(1,0,0,32)
        Btn.BackgroundTransparency = 1
        Btn.Text = ""
        Btn.Parent = TabContainer
        Btn.ZIndex = 4
        
        local TextOffset = IconId and 45 or 20

        local Title = Instance.new("TextLabel", Btn)
        Title.Name = "Title"
        Title.Size = UDim2.new(1, -TextOffset, 1, 0)
        Title.Position = UDim2.new(0, TextOffset, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = Name
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.ZIndex = 5
        Library:RegisterTheme(Title, "TextColor3", "TextDark")

        local TabIcon
        if IconId then
            TabIcon = Instance.new("ImageLabel", Btn)
            TabIcon.Name = "Icon"
            TabIcon.Size = UDim2.new(0, 20, 0, 20)
            TabIcon.Position = UDim2.new(0, 12, 0.5, -10) 
            TabIcon.BackgroundTransparency = 1
            TabIcon.Image = "rbxassetid://" .. tostring(IconId)
            TabIcon.ZIndex = 5 
            Library:RegisterTheme(TabIcon, "ImageColor3", "TextDark")
        end

        local Ind = Instance.new("Frame")
        Ind.Name = "ActiveIndicator" 
        Ind.Size = UDim2.new(0, 4, 0.6, 0)
        Ind.Position = UDim2.new(0, 0, 0.2, 0) 
        Ind.Visible = false
        Ind.Parent = Btn
        Ind.ZIndex = 5 
        Library:RegisterTheme(Ind, "BackgroundColor3", "Accent")

        local Page = Instance.new("CanvasGroup")
        Page.Name = Name.."_Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.GroupTransparency = 1
        Page.Visible = false
        Page.Parent = PagesArea
        
        local PageRef = Instance.new("ObjectValue", Btn)
        PageRef.Name = "PageRef"
        PageRef.Value = Page

        local SubTabArea = Instance.new("Frame")
        SubTabArea.Size = UDim2.new(1, -20, 0, 30)
        SubTabArea.Position = UDim2.new(0, 10, 0, 10)
        SubTabArea.BackgroundTransparency = 1
        SubTabArea.Parent = Page
        local SubLayout = Instance.new("UIListLayout", SubTabArea)
        SubLayout.FillDirection = Enum.FillDirection.Horizontal
        SubLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SubLayout.Padding = UDim.new(0, 10)
        local ContentArea = Instance.new("Frame")
        ContentArea.Size = UDim2.new(1, 0, 1, -40)
        ContentArea.Position = UDim2.new(0, 0, 0, 40)
        ContentArea.BackgroundTransparency = 1
        ContentArea.Parent = Page

        if FirstTab then
            FirstTab = false
            Title.TextColor3 = Library.Theme.Text
            if TabIcon then TabIcon.ImageColor3 = Library.Theme.Text end
            Ind.Visible = true
            Library:FadeIn(Page)
        end

        Btn.MouseButton1Click:Connect(function()
            for _,v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    local t = v:FindFirstChild("Title")
                    if t then TweenService:Create(t, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextDark}):Play() end
                    
                    local ico = v:FindFirstChild("Icon")
                    if ico then TweenService:Create(ico, TweenInfo.new(0.2), {ImageColor3 = Library.Theme.TextDark}):Play() end
                    
                    if v:FindFirstChild("ActiveIndicator") then v.ActiveIndicator.Visible = false end
                end
            end
            
            for _,v in pairs(PagesArea:GetChildren()) do 
                if v:IsA("CanvasGroup") and v ~= Page then
                    v.Visible = false 
                    v.GroupTransparency = 1
                end
            end
            
            TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Text}):Play()
            if TabIcon then 
                TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = Library.Theme.Text}):Play() 
            end
            
            Ind.Visible = true
            Library:FadeIn(Page)
        end)
        
        local TabFuncs = {}
        local FirstSubTab = true
        
        function TabFuncs:SubTab(SubName)
            local SBtn = Instance.new("TextButton")
            SBtn.Size = UDim2.new(0, 0, 1, 0)
            SBtn.AutomaticSize = Enum.AutomaticSize.X
            SBtn.BackgroundTransparency = 1
            SBtn.Text = SubName
            SBtn.Font = Enum.Font.GothamBold
            SBtn.TextSize = 13
            SBtn.Parent = SubTabArea
            Library:RegisterTheme(SBtn, "TextColor3", "TextDark")
            
            local SubPage = Instance.new("CanvasGroup")
            SubPage.Name = SubName.."_SubPage"
            SubPage.Size = UDim2.new(1,0,1,0)
            SubPage.BackgroundTransparency = 1
            SubPage.GroupTransparency = 1
            SubPage.Visible = false
            SubPage.Parent = ContentArea
            
            local LCol = Instance.new("ScrollingFrame")
            LCol.Name = "LeftColumn"
            LCol.Size = UDim2.new(0.5, -10, 1, -10)
            LCol.Position = UDim2.new(0, 10, 0, 0)
            LCol.BackgroundTransparency = 1
            LCol.ScrollBarThickness = 2
            LCol.ScrollBarImageColor3 = Library.Theme.Accent
            LCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
            LCol.CanvasSize = UDim2.new(0, 0, 0, 0)
            LCol.Parent = SubPage
            Library:RegisterTheme(LCol, "ScrollBarImageColor3", "Accent")

            local RCol = Instance.new("ScrollingFrame")
            RCol.Name = "RightColumn"
            RCol.Size = UDim2.new(0.5, -10, 1, -10)
            RCol.Position = UDim2.new(0.5, 5, 0, 0)
            RCol.BackgroundTransparency = 1
            RCol.ScrollBarThickness = 2
            RCol.ScrollBarImageColor3 = Library.Theme.Accent
            RCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
            RCol.CanvasSize = UDim2.new(0, 0, 0, 0)
            RCol.Parent = SubPage
            Library:RegisterTheme(RCol, "ScrollBarImageColor3", "Accent")

            local function Setup(f)
                local l = Instance.new("UIListLayout", f)
                l.Padding = UDim.new(0, 12)
                l.SortOrder = Enum.SortOrder.LayoutOrder
                
                local p = Instance.new("UIPadding", f)
                p.PaddingBottom = UDim.new(0, 10)
                p.PaddingRight = UDim.new(0, 5)
            end
            Setup(LCol)
            Setup(RCol)

            if FirstSubTab then
                FirstSubTab = false
                SBtn.TextColor3 = Library.Theme.Accent
                Library:FadeIn(SubPage)
                table.insert(ThemeObjects["Accent"], {Obj = SBtn, Prop = "TextColor3", CustomCheck = function() return SubPage.Visible end})
            else
                table.insert(ThemeObjects["TextDark"], {Obj = SBtn, Prop = "TextColor3", CustomCheck = function() return not SubPage.Visible end})
            end

            SBtn.MouseButton1Click:Connect(function()
                for _, v in pairs(ContentArea:GetChildren()) do 
                    if v:IsA("CanvasGroup") then v.Visible = false v.GroupTransparency = 1 end
                end
                for _, v in pairs(SubTabArea:GetChildren()) do 
                    if v:IsA("TextButton") then TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextDark}):Play() end 
                end
                Library:FadeIn(SubPage)
                TweenService:Create(SBtn, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Accent}):Play()
            end)

            local SubFuncs = {}
            
            function SubFuncs:Groupbox(Name, Side, IconId)
                local P = (Side=="Right") and RCol or LCol
                local Box = Instance.new("Frame")
                Box.Size = UDim2.new(1,0,0,100)
                Box.Parent = P
                Library:RegisterTheme(Box,"BackgroundColor3","Groupbox")
                Instance.new("UICorner",Box).CornerRadius=UDim.new(0,4)
                local S=Instance.new("UIStroke",Box)
                S.Thickness=1
                Library:RegisterTheme(S,"Color","Outline")
                
                Box.BackgroundTransparency = 1 
                TweenService:Create(Box, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                
                local HeaderOffset = 10
                if IconId then
                    HeaderOffset = 32
                    local GIcon = Instance.new("ImageLabel", Box)
                    GIcon.Size = UDim2.new(0, 16, 0, 16)
                    GIcon.Position = UDim2.new(0, 10, 0, 5)
                    GIcon.BackgroundTransparency = 1
                    GIcon.Image = "rbxassetid://" .. tostring(IconId)
                    Library:RegisterTheme(GIcon, "ImageColor3", "Accent")
                end

                local H=Instance.new("TextLabel")
                H.Size=UDim2.new(1,-20,0,25)
                H.Position=UDim2.new(0, HeaderOffset, 0, 0)
                H.BackgroundTransparency=1
                H.Text=Name
                H.Font=Enum.Font.GothamBold
                H.TextSize=13
                H.TextXAlignment=Enum.TextXAlignment.Left
                H.Parent=Box
                Library:RegisterTheme(H,"TextColor3","Accent")

                local C=Instance.new("Frame")
                C.Name = "MainContent"
                C.Size=UDim2.new(1,0,0,0)
                C.Position=UDim2.new(0,0,0,30)
                C.BackgroundTransparency=1
                C.Parent=Box
                
                local L=Instance.new("UIListLayout",C)
                L.SortOrder=Enum.SortOrder.LayoutOrder
                L.Padding=UDim.new(0,12)
                
                local Pa=Instance.new("UIPadding",C)
                Pa.PaddingLeft=UDim.new(0,10)
                Pa.PaddingRight=UDim.new(0,10)
                Pa.PaddingBottom=UDim.new(0,10)
                Pa.PaddingTop=UDim.new(0,5)
                
                L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Box.Size=UDim2.new(1,0,0,L.AbsoluteContentSize.Y+45)
                end)
                

                local function RegisterItem(ItemName, ItemObj)
                    if not Btn or not SBtn or not SubPage then return end 
                    table.insert(Library.Registry, {
                        Name = ItemName,
                        Object = ItemObj,
                        TabBtn = Btn,
                        SubTabBtn = SBtn,
                        SubPage = SubPage
                    })
                end

                local ContainerStack = {C}
                local NextItemOpenVal = nil

                local function GetContainer()
                    return ContainerStack[#ContainerStack]
                end

                local BoxFuncs = {}
                
                local function CheckActivePicker()
                    if Library.ActivePicker then
                        Library.ActivePicker.Visible = false
                        Library.ActivePicker = nil
                    end
                end

                function BoxFuncs:SetNextItemOpen(isOpen)
                    NextItemOpenVal = isOpen
                end
            
                function BoxFuncs:GetTreeNodeToLabelSpacing()
                    return 20
                end
            
                local function TreeNodeBehavior(Label, Flags)
                    local Parent = GetContainer()
                    local IsFramed = (Flags and Flags.Framed)
                    
                    local NodeFrame = Instance.new("Frame")
                    NodeFrame.Name = "TreeNode_" .. Label
                    NodeFrame.Size = UDim2.new(1, 0, 0, 0)
                    NodeFrame.AutomaticSize = Enum.AutomaticSize.Y
                    NodeFrame.BackgroundTransparency = IsFramed and 0 or 1
                    NodeFrame.BackgroundColor3 = IsFramed and Library.Theme.ItemBackground or Color3.new(0,0,0)
                    NodeFrame.Parent = Parent

                    if IsFramed then
                        Instance.new("UICorner", NodeFrame).CornerRadius = UDim.new(0, 4)
                        Library:RegisterTheme(NodeFrame, "BackgroundColor3", "ItemBackground")
                    end
            
                    local NodeLayout = Instance.new("UIListLayout", NodeFrame)
                    NodeLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    NodeLayout.Padding = UDim.new(0, 0)
            
                    local HeaderBtn = Instance.new("TextButton", NodeFrame)
                    HeaderBtn.Size = UDim2.new(1, 0, 0, IsFramed and 25 or 20)
                    HeaderBtn.BackgroundTransparency = 1
                    HeaderBtn.Text = ""
                    
                    local Arrow = Instance.new("TextLabel", HeaderBtn)
                    Arrow.Size = UDim2.new(0, 15, 1, 0)
                    Arrow.BackgroundTransparency = 1
                    Arrow.Text = ">"
                    Arrow.Font = Enum.Font.Code
                    Arrow.TextSize = 14
                    Arrow.TextColor3 = Library.Theme.TextDark
                    Arrow.Position = UDim2.new(0, IsFramed and 5 or 0, 0, 0)
                    
                    local Lb = Instance.new("TextLabel", HeaderBtn)
                    Lb.Size = UDim2.new(1, -20, 1, 0)
                    Lb.Position = UDim2.new(0, 20, 0, 0)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Label
                    Lb.Font = Enum.Font.GothamBold
                    Lb.TextSize = 12
                    Lb.TextColor3 = Library.Theme.Text
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
            
                    local ChildContent = Instance.new("Frame", NodeFrame)
                    ChildContent.Name = "Content"
                    ChildContent.Size = UDim2.new(1, 0, 0, 0)
                    ChildContent.BackgroundTransparency = 1
                    ChildContent.Visible = false
                    
                    local ChildLayout = Instance.new("UIListLayout", ChildContent)
                    ChildLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    ChildLayout.Padding = UDim.new(0, 10)
                    
                    local ChildPadding = Instance.new("UIPadding", ChildContent)
                    ChildPadding.PaddingLeft = UDim.new(0, IsFramed and 10 or 15)
                    ChildPadding.PaddingTop = UDim.new(0, 5)
                    ChildPadding.PaddingBottom = UDim.new(0, 5)
            
                    ChildLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        ChildContent.Size = UDim2.new(1, 0, 0, ChildLayout.AbsoluteContentSize.Y + 10)
                    end)
            
                    local IsOpen = false
                    if NextItemOpenVal ~= nil then
                        IsOpen = NextItemOpenVal
                        NextItemOpenVal = nil
                    end
            
                    local function Toggle(v)
                        IsOpen = v
                        ChildContent.Visible = IsOpen
                        if IsOpen then
                            TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 90, TextColor3 = Library.Theme.Accent}):Play()
                        else
                            TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0, TextColor3 = Library.Theme.TextDark}):Play()
                        end
                    end
            
                    HeaderBtn.MouseButton1Click:Connect(function()
                        Toggle(not IsOpen)
                    end)
            
                    Toggle(IsOpen)
           
                    table.insert(ContainerStack, ChildContent)
                    
                    return true 
                end
            
                function BoxFuncs:TreePush()
                    local Parent = GetContainer()
                    local Indent = Instance.new("Frame", Parent)
                    Indent.Size = UDim2.new(1,0,0,0)
                    Indent.AutomaticSize = Enum.AutomaticSize.Y
                    Indent.BackgroundTransparency = 1
                    
                    local IL = Instance.new("UIListLayout", Indent)
                    IL.SortOrder = Enum.SortOrder.LayoutOrder
                    IL.Padding = UDim.new(0, 10)
                    
                    local IP = Instance.new("UIPadding", Indent)
                    IP.PaddingLeft = UDim.new(0, 20) 
                    
                    IL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                         Indent.Size = UDim2.new(1, 0, 0, IL.AbsoluteContentSize.Y)
                    end)
            
                    table.insert(ContainerStack, Indent)
                end
            
                function BoxFuncs:TreePop()
                    if #ContainerStack > 1 then
                        table.remove(ContainerStack)
                    end
                end
            
                function BoxFuncs:TreeNode(Label)
                    return TreeNodeBehavior(Label, {Framed = false})
                end
            
                function BoxFuncs:TreeNodeEx(Label, Flags)
                    return TreeNodeBehavior(Label, Flags or {})
                end
                
                function BoxFuncs:TreeNodeV(Label) return BoxFuncs:TreeNode(Label) end
                function BoxFuncs:TreeNodeExV(Label, Flags) return BoxFuncs:TreeNodeEx(Label, Flags) end
            
                function BoxFuncs:CollapsingHeader(Label)
                    return TreeNodeBehavior(Label, {Framed = true})
                end

                function BoxFuncs:AddLabel(Config)
                    local Text = type(Config) == "table" and Config.Title or Config
                    local F=Instance.new("Frame", GetContainer())
                    F.Size=UDim2.new(1,0,0,15)
                    F.BackgroundTransparency=1
                    local Lb=Instance.new("TextLabel",F)
                    Lb.Size=UDim2.new(1,0,1,0)
                    Lb.BackgroundTransparency=1
                    Lb.Text=Text
                    Lb.Font=Enum.Font.Gotham
                    Lb.TextSize=12
                    Lb.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb,"TextColor3","Text")
                end

                function BoxFuncs:AddTextUnformatted(Text)
                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 15)
                    F.BackgroundTransparency = 1
                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, 0, 1, 0)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Code
                    Lb.TextSize = 12
                    Lb.TextColor3 = Color3.new(1,1,1) 
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
                end

                function BoxFuncs:AddTextWrapped(Text)
                    local P = GetContainer()
                    local F = Instance.new("Frame", P)
                    F.BackgroundTransparency = 1
                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, 0, 1, 0)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Gotham
                    Lb.TextSize = 12
                    Lb.TextColor3 = Library.Theme.Text
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
                    Lb.TextWrapped = true
                    Library:RegisterTheme(Lb, "TextColor3", "Text")

                    local TextBounds = game:GetService("TextService"):GetTextSize(Text, 12, Enum.Font.Gotham, Vector2.new(P.AbsoluteSize.X - 20, 9999))
                    F.Size = UDim2.new(1, 0, 0, TextBounds.Y + 5)
                end

                function BoxFuncs:AddLabelText(Label, Value)
                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 15)
                    F.BackgroundTransparency = 1
                    local L1 = Instance.new("TextLabel", F)
                    L1.Size = UDim2.new(0.5, 0, 1, 0)
                    L1.BackgroundTransparency = 1
                    L1.Text = Label
                    L1.Font = Enum.Font.GothamBold
                    L1.TextSize = 12
                    L1.TextXAlignment = Enum.TextXAlignment.Left
                    L1.TextColor3 = Library.Theme.Text
                    Library:RegisterTheme(L1, "TextColor3", "Text")
                    local L2 = Instance.new("TextLabel", F)
                    L2.Size = UDim2.new(0.5, 0, 1, 0)
                    L2.Position = UDim2.new(0.5, 0, 0, 0)
                    L2.BackgroundTransparency = 1
                    L2.Text = tostring(Value)
                    L2.Font = Enum.Font.Gotham
                    L2.TextSize = 12
                    L2.TextXAlignment = Enum.TextXAlignment.Right
                    L2.TextColor3 = Library.Theme.Accent
                    Library:RegisterTheme(L2, "TextColor3", "Accent")
                end

                function BoxFuncs:AddBulletText(Text)
                    BoxFuncs:AddLabel(" • " .. Text)
                end

                function BoxFuncs:AddSeparator()
                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 8) 
                    F.BackgroundTransparency = 1
                    local Line = Instance.new("Frame", F)
                    Line.Size = UDim2.new(1, 0, 0, 1)
                    Line.Position = UDim2.new(0, 0, 0.5, 0)
                    Line.BackgroundColor3 = Library.Theme.Outline
                    Line.BorderSizePixel = 0
                    Library:RegisterTheme(Line, "BackgroundColor3", "Outline")
                end

                function BoxFuncs:AddSpacing(Amount)
                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, Amount or 10)
                    F.BackgroundTransparency = 1
                end

                function BoxFuncs:AddDummy(Height)
                    BoxFuncs:AddSpacing(Height)
                end

                function BoxFuncs:AddNewLine()
                    BoxFuncs:AddSpacing(5)
                end

                function BoxFuncs:AlignTextToFramePadding(Text)
                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 15)
                    F.BackgroundTransparency = 1
                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, 0, 1, 0)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Gotham
                    Lb.TextSize = 12
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb, "TextColor3", "Text")
                    local P = Instance.new("UIPadding", F)
                    P.PaddingLeft = UDim.new(0, 5) 
                end
                
                function BoxFuncs:AddParagraph(Config)
                    local Head = Config.Title or "Paragraph"
                    local Cont = Config.Content or ""
                    local Wrapped = Config.TextWrapped ~= false 
                    local P = GetContainer()
                    
                    local F = Instance.new("Frame", P)
                    F.BackgroundTransparency = 1
                    F.Size = UDim2.new(1, 0, 0, 0)
                    
                    local H1 = Instance.new("TextLabel", F)
                    H1.Size = UDim2.new(1, 0, 0, 15)
                    H1.BackgroundTransparency = 1
                    H1.Text = Head
                    H1.Font = Enum.Font.GothamBold
                    H1.TextSize = 12
                    H1.TextXAlignment = Enum.TextXAlignment.Left
                    Library:RegisterTheme(H1, "TextColor3", "Text")
                    
                    local C1 = Instance.new("TextLabel", F)
                    C1.Position = UDim2.new(0, 0, 0, 20)
                    C1.BackgroundTransparency = 1
                    C1.Text = Cont
                    C1.Font = Enum.Font.Gotham
                    C1.TextSize = 11
                    C1.TextXAlignment = Enum.TextXAlignment.Left
                    C1.TextYAlignment = Enum.TextYAlignment.Top
                    C1.TextWrapped = Wrapped
                    Library:RegisterTheme(C1, "TextColor3", "TextDark")
                    
                    local WrapWidth = P.AbsoluteSize.X - 20
                    if WrapWidth < 50 then WrapWidth = 230 end
                    
                    local TextHeight = 15
                    if Wrapped then
                        local TextBounds = game:GetService("TextService"):GetTextSize(Cont, 11, Enum.Font.Gotham, Vector2.new(WrapWidth, 9999))
                        TextHeight = TextBounds.Y
                    end

                    C1.Size = UDim2.new(1, 0, 0, TextHeight)
                    F.Size = UDim2.new(1, 0, 0, TextHeight + 25)
                    
                    RegisterItem(Head, F)
                end

                -- // TOGGLE //
                function BoxFuncs:AddToggle(Config)
                    local Text = Config.Title or "Toggle"
                    local Default = Config.Default or false
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description
                    local Risky = Config.Risky

                    local F=Instance.new("TextButton", GetContainer())
                    F.Size=UDim2.new(1,0,0,20)
                    F.BackgroundTransparency=1
                    F.Text=""
                    if Desc then AddTooltip(F, Desc) end

                    local Lb=Instance.new("TextLabel",F)
                    Lb.Size=UDim2.new(1,-45,1,0)
                    Lb.BackgroundTransparency=1
                    Lb.Text=Text
                    Lb.Font=Enum.Font.Gotham
                    Lb.TextSize=12
                    Lb.TextXAlignment=Enum.TextXAlignment.Left
                    if Risky then
                        Lb.TextColor3 = Color3.fromRGB(255, 80, 80)
                    else
                        Library:RegisterTheme(Lb,"TextColor3","Text")
                    end

                    local T=Instance.new("Frame",F)
                    T.Size=UDim2.new(0,34,0,18)
                    T.Position=UDim2.new(1,-34,0.5,-9)
                    T.BackgroundColor3=Default and Library.Theme.Accent or Library.Theme.ItemBackground
                    Library:RegisterTheme(T, "BackgroundColor3", Default and "Accent" or "ItemBackground")
                    
                    Instance.new("UICorner",T).CornerRadius=UDim.new(1,0)
                    local Cir=Instance.new("Frame",T)
                    Cir.Size=UDim2.new(0,14,0,14)
                    Cir.Position=Default and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
                    Cir.BackgroundColor3=Library.Theme.Text
                    Instance.new("UICorner",Cir).CornerRadius=UDim.new(1,0)

                    local function Set(v)
                        Library.Flags[Flag]=v
                        TweenService:Create(Cir,TweenInfo.new(0.2, Enum.EasingStyle.Sine),{Position=v and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)}):Play()
                        if v then
                            TweenService:Create(T,TweenInfo.new(0.2, Enum.EasingStyle.Sine),{BackgroundColor3=Library.Theme.Accent}):Play()
                        else
                            TweenService:Create(T,TweenInfo.new(0.2, Enum.EasingStyle.Sine),{BackgroundColor3=Library.Theme.ItemBackground}):Play()
                        end
                        pcall(Callback,v)
                    end
                    Library.Items[Flag]={Set=Set}
                    F.MouseButton1Click:Connect(function() Set(not Library.Flags[Flag]) end)
                    Library.Flags[Flag]=Default

                    RegisterItem(Text, F)
                end

                -- // CHECKBOX //
                function BoxFuncs:AddCheckbox(Config)
                    local Text = Config.Title or "Checkbox"
                    local Default = Config.Default or false
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description
                    local Risky = Config.Risky

                    local F = Instance.new("TextButton", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 20)
                    F.BackgroundTransparency = 1
                    F.Text = ""
                    if Desc then AddTooltip(F, Desc) end

                    local Box = Instance.new("Frame", F)
                    Box.Size = UDim2.new(0, 14, 0, 14)
                    Box.Position = UDim2.new(0, 0, 0.5, -8)
                    Box.BackgroundColor3 = Library.Theme.ItemBackground
                    Library:RegisterTheme(Box, "BackgroundColor3", "ItemBackground") 
                    
                    local BoxStroke = Instance.new("UIStroke", Box)
                    BoxStroke.Color = Library.Theme.Outline
                    BoxStroke.Thickness = 1
                    Library:RegisterTheme(BoxStroke, "Color", "Outline")
                    
                    local Check = Instance.new("ImageLabel", Box)
                    Check.Size = UDim2.new(1, -2, 1, -2)
                    Check.Position = UDim2.new(0, 1, 0, 1)
                    Check.BackgroundTransparency = 1
                    Check.Image = "rbxassetid://3944680095" 
                    Check.ImageColor3 = Library.Theme.Accent
                    Library:RegisterTheme(Check, "ImageColor3", "Accent")
                    Check.Visible = Default

                    local Label = Instance.new("TextLabel", F)
                    Label.Size = UDim2.new(1, -25, 1, 0)
                    Label.Position = UDim2.new(0, 25, 0, 0)
                    Label.BackgroundTransparency = 1
                    Label.Text = Text
                    Label.Font = Enum.Font.Gotham
                    Label.TextSize = 13
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    
                    Label.TextColor3 = Default and Library.Theme.Text or Library.Theme.TextDark
                    if Default then
                        Library:RegisterTheme(Label, "TextColor3", "Text")
                    else
                        Library:RegisterTheme(Label, "TextColor3", "TextDark")
                    end

                    local function UpdateVisuals(IsHovering)
                        local targetColor = Library.Theme.ItemBackground
                        if IsHovering then
                            targetColor = Color3.fromRGB(
                                math.min(Library.Theme.ItemBackground.R * 255 + 20, 255),
                                math.min(Library.Theme.ItemBackground.G * 255 + 20, 255),
                                math.min(Library.Theme.ItemBackground.B * 255 + 20, 255)
                            )
                        end
                        TweenService:Create(Box, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {BackgroundColor3 = targetColor}):Play()
                        
                        if not Library.Flags[Flag] then
                             local txtColor = IsHovering and Library.Theme.Text or Library.Theme.TextDark
                             TweenService:Create(Label, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {TextColor3 = txtColor}):Play()
                        end
                    end

                    F.MouseEnter:Connect(function() UpdateVisuals(true) end)
                    F.MouseLeave:Connect(function() UpdateVisuals(false) end)

                    local function Set(v)
                        Library.Flags[Flag] = v
                        Check.Visible = v
                        
                        if v then
                            Label.TextColor3 = Library.Theme.Text
                        else
                            Label.TextColor3 = Library.Theme.TextDark
                        end
                        pcall(Callback, v)
                    end

                    Library.Items[Flag] = {Set = Set}
                    Library.Flags[Flag] = Default

                    F.MouseButton1Click:Connect(function() Set(not Library.Flags[Flag]) end)

                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddSlider(Config)
                    local Text = Config.Title or "Slider"
                    local Min = Config.Min or 0
                    local Max = Config.Max or 100
                    local Def = Config.Default or Min
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Rounding = Config.Rounding or 0
                    local Suffix = Config.Suffix or ""
                    local Desc = Config.Description

                    local F=Instance.new("Frame", GetContainer())
                    F.Size=UDim2.new(1,0,0,38)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end

                    local Lb=Instance.new("TextLabel",F)
                    Lb.Size=UDim2.new(1,0,0,15)
                    Lb.BackgroundTransparency=1
                    Lb.Text=Text
                    Lb.Font=Enum.Font.Gotham
                    Lb.TextSize=12
                    Lb.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb,"TextColor3","Text")
                    local Vl=Instance.new("TextLabel",F)
                    Vl.Size=UDim2.new(0,80,0,15)
                    Vl.Position=UDim2.new(1,-80,0,0)
                    Vl.BackgroundTransparency=1
                    Vl.Text=tostring(Def)..Suffix
                    Vl.Font=Enum.Font.Gotham
                    Vl.TextSize=12
                    Vl.TextXAlignment=Enum.TextXAlignment.Right
                    Library:RegisterTheme(Vl,"TextColor3","Accent")
                    local B=Instance.new("Frame",F)
                    B.Size=UDim2.new(1,0,0,5)
                    B.Position=UDim2.new(0,0,0,25)
                    B.BackgroundColor3=Library.Theme.ItemBackground
                    Library:RegisterTheme(B, "BackgroundColor3", "ItemBackground")
                    Instance.new("UICorner",B).CornerRadius=UDim.new(1,0)
                    local Fil=Instance.new("Frame",B)
                    Fil.Size=UDim2.new((Def-Min)/(Max-Min),0,1,0)
                    Library:RegisterTheme(Fil,"BackgroundColor3","Accent")
                    Instance.new("UICorner",Fil).CornerRadius=UDim.new(1,0)
                    local Btn=Instance.new("TextButton",F)
                    Btn.Size=UDim2.new(1,0,0,25)
                    Btn.Position=UDim2.new(0,0,0,15)
                    Btn.BackgroundTransparency=1
                    Btn.Text=""
                    
                    local function Set(v)
                        v=math.clamp(v,Min,Max)
                        if Rounding > 0 then
                            v = math.floor(v * (10^Rounding)) / (10^Rounding)
                        else
                            v = math.floor(v)
                        end
                        
                        Library.Flags[Flag]=v
                        Vl.Text=tostring(v)..Suffix
                        TweenService:Create(Fil,TweenInfo.new(0.1),{Size=UDim2.new((v-Min)/(Max-Min),0,1,0)}):Play()
                        pcall(Callback,v)
                    end
                    Library.Items[Flag]={Set=Set}
                    Library.Flags[Flag]=Def
                    local drag=false
                    local function Upd(i)
                        local x=math.clamp((i.Position.X-B.AbsolutePosition.X)/B.AbsoluteSize.X,0,1)
                        local newVal = ((Max-Min)*x)+Min
                        Set(newVal)
                    end
                    Btn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true Upd(i) end end)
                    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end)
                    UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then Upd(i) end end)

                    RegisterItem(Text, F)
                end
                
                function BoxFuncs:AddColorPicker(Config)
                    local Text = Config.Title or "Color"
                    local Def = Config.Default or Color3.new(1,1,1)
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description

                    local F=Instance.new("Frame", GetContainer())
                    F.Size=UDim2.new(1,0,0,25)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end

                    local Lb=Instance.new("TextLabel",F)
                    Lb.Size=UDim2.new(0.7,0,1,0)
                    Lb.BackgroundTransparency=1
                    Lb.Text=Text
                    Lb.Font=Enum.Font.Gotham
                    Lb.TextSize=12
                    Lb.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb,"TextColor3","Text")
                    local P=Instance.new("TextButton",F)
                    P.Size=UDim2.new(0,35,0,18)
                    P.Position=UDim2.new(1,-35,0.5,-9)
                    P.BackgroundColor3=Def
                    P.Text=""
                    Instance.new("UICorner",P).CornerRadius=UDim.new(0,4)
                    
                    local Win=Instance.new("Frame",ScreenGui)
                    Win.Size=UDim2.new(0,200,0,190)
                    Win.BackgroundColor3=Color3.fromRGB(25,25,25)
                    Win.Visible=false
                    Win.ZIndex=200 
                    Instance.new("UIStroke",Win).Color=Library.Theme.Outline
                    Instance.new("UICorner",Win).CornerRadius=UDim.new(0,4)
                    local SV=Instance.new("ImageButton",Win)
                    SV.Size=UDim2.new(0,180,0,130)
                    SV.Position=UDim2.new(0,10,0,10)
                    SV.BackgroundColor3=Def
                    SV.Image="rbxassetid://4155801252"
                    SV.ZIndex=201
                    local H=Instance.new("ImageButton",Win)
                    H.Size=UDim2.new(0,180,0,25)
                    H.Position=UDim2.new(0,10,0,150)
                    H.BackgroundColor3=Color3.new(1,1,1)
                    H.Image=""
                    H.ZIndex=201
                    local Gr=Instance.new("UIGradient",H)
                    Gr.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),ColorSequenceKeypoint.new(0.17,Color3.new(1,1,0)),ColorSequenceKeypoint.new(0.33,Color3.new(0,1,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0,1,1)),ColorSequenceKeypoint.new(0.67,Color3.new(0,0,1)),ColorSequenceKeypoint.new(0.83,Color3.new(1,0,1)),ColorSequenceKeypoint.new(1,Color3.new(1,0,0))}
                    
                    local h,s,v = Def:ToHSV()
                    local function Upd()
                        local c=Color3.fromHSV(h,s,v)
                        P.BackgroundColor3=c
                        SV.BackgroundColor3=Color3.fromHSV(h,1,1)
                        Library.Flags[Flag]={R=c.R,G=c.G,B=c.B}
                        pcall(Callback,c)
                    end
                    Library.Items[Flag]={Set=function(t) if type(t)=="table" then local c=Color3.new(t.R,t.G,t.B) h,s,v=c:ToHSV() Upd() end end}
                    Library.Flags[Flag]={R=Def.R,G=Def.G,B=Def.B}

                    local d1,d2=false,false
                    local function Hand(i,mode)
                        if mode=="H" then h=math.clamp((i.Position.X-H.AbsolutePosition.X)/H.AbsoluteSize.X,0,1)
                        else s=math.clamp((i.Position.X-SV.AbsolutePosition.X)/SV.AbsoluteSize.X,0,1) v=1-math.clamp((i.Position.Y-SV.AbsolutePosition.Y)/SV.AbsoluteSize.Y,0,1) end
                        Upd()
                    end
                    H.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d1=true Hand(i,"H") end end)
                    SV.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d2=true Hand(i,"S") end end)
                    UserInputService.InputEnded:Connect(function() d1=false d2=false end)
                    UserInputService.InputChanged:Connect(function(i) if d1 and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then Hand(i,"H") elseif d2 and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then Hand(i,"S") end end)
                    P.MouseButton1Click:Connect(function() 
                        if Win.Visible then Win.Visible = false Library.ActivePicker = nil else
                            if Library.ActivePicker then Library.ActivePicker.Visible = false end
                            Win.Visible = true
                            Win.Position = UDim2.new(0, P.AbsolutePosition.X + 50, 0, P.AbsolutePosition.Y)
                            Library.ActivePicker = Win
                        end
                    end)
                    DropdownHolder.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then Win.Visible=false if Library.ActivePicker==Win then Library.ActivePicker=nil end end end)
                
                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddDropdown(Config)
                    local Text = Config.Title or "Dropdown"
                    local Opt = Config.Values or {}
                    local Default = Config.Default
                    local Callback = Config.Callback or function() end
                    local Multi = Config.Multi or false
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description

                    local F=Instance.new("Frame", GetContainer())
                    F.Size=UDim2.new(1,0,0,40)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end

                    local L=Instance.new("TextLabel",F)
                    L.Size=UDim2.new(1,0,0,15)
                    L.BackgroundTransparency=1
                    L.Text=Text
                    L.Font=Enum.Font.Gotham
                    L.TextSize=12
                    L.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(L,"TextColor3","Text")
                    local B=Instance.new("TextButton",F)
                    B.Size=UDim2.new(1,0,0,22)
                    B.Position=UDim2.new(0,0,0,18)
                    B.BackgroundColor3=Library.Theme.ItemBackground
                    Library:RegisterTheme(B, "BackgroundColor3", "ItemBackground")
                    B.Font=Enum.Font.Gotham
                    B.TextSize=12
                    B.TextColor3=Color3.fromRGB(200,200,200)
                    B.TextXAlignment=Enum.TextXAlignment.Left
                    Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
                    
                    local List=Instance.new("ScrollingFrame",ScreenGui)
                    List.Visible=false
                    List.BackgroundColor3=Library.Theme.ItemBackground
                    Library:RegisterTheme(List, "BackgroundColor3", "ItemBackground")
                    List.BorderSizePixel=0
                    List.ZIndex=200 
                    List.AutomaticCanvasSize = Enum.AutomaticSize.Y
                    Instance.new("UIStroke",List).Color=Library.Theme.Outline
                    local LL=Instance.new("UIListLayout",List)
                    LL.SortOrder=Enum.SortOrder.LayoutOrder

                    if not Multi then
                        B.Text = "  " .. (Default or "Select...")
                        local function Set(v)
                            B.Text="  "..v
                            Library.Flags[Flag]=v
                            pcall(Callback,v)
                            List.Visible=false
                            DropdownHolder.Visible=false
                            CheckActivePicker()
                        end
                        
                        Library.Items[Flag]={Set=Set, Refresh=function(New)
                            for _,v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                            for _,v in pairs(New) do
                                local bt=Instance.new("TextButton",List)
                                bt.Size=UDim2.new(1,0,0,25)
                                bt.BackgroundTransparency=1
                                bt.Text=v
                                bt.TextColor3=Color3.fromRGB(200,200,200)
                                bt.Font=Enum.Font.Gotham
                                bt.TextSize=12
                                bt.ZIndex = 205
                                bt.MouseButton1Click:Connect(function() Set(v) end)
                            end
                        end}
                        Library.Items[Flag].Refresh(Opt)
                        if Default then Set(Default) end

                        B.MouseButton1Click:Connect(function()
                            if List.Visible then List.Visible=false DropdownHolder.Visible=false else
                                CheckActivePicker()
                                List.Position=UDim2.new(0,B.AbsolutePosition.X,0,B.AbsolutePosition.Y+25)
                                local ContentH = LL.AbsoluteContentSize.Y
                                List.Size=UDim2.new(0,B.AbsoluteSize.X,0,math.min(ContentH, 150))
                                List.CanvasSize=UDim2.new(0,0,0,ContentH)
                                List.Visible=true
                                DropdownHolder.Visible=true
                            end
                        end)

                    else
                        local Sel={}
                        if type(Default) == "table" then
                            for _, val in pairs(Default) do Sel[val] = true end
                        end
                        
                        Library.Flags[Flag]=Sel
                        
                        local function Upd()
                            local t={} for k,v in pairs(Sel) do if v then table.insert(t,k) end end
                            B.Text=#t==0 and "  None" or (#t==1 and "  "..t[1] or "  "..#t.." Selected")
                            pcall(Callback,Sel)
                        end
                        Upd()

                        for _,v in pairs(Opt) do
                            local bt=Instance.new("TextButton",List)
                            bt.Size=UDim2.new(1,0,0,25)
                            bt.BackgroundTransparency=1
                            bt.Text=v
                            bt.TextColor3=Color3.fromRGB(200,200,200)
                            bt.Font=Enum.Font.Gotham
                            bt.TextSize=12
                            bt.ZIndex = 205 
                            bt.MouseButton1Click:Connect(function()
                                Sel[v]=not Sel[v]
                                bt.TextColor3=Sel[v] and Library.Theme.Accent or Color3.fromRGB(200,200,200)
                                Upd()
                            end)
                            if Sel[v] then bt.TextColor3 = Library.Theme.Accent end
                        end
                        
                        B.MouseButton1Click:Connect(function()
                            if List.Visible then List.Visible=false DropdownHolder.Visible=false else
                                CheckActivePicker()
                                List.Position=UDim2.new(0,B.AbsolutePosition.X,0,B.AbsolutePosition.Y+25)
                                local ContentH = LL.AbsoluteContentSize.Y
                                List.Size=UDim2.new(0,B.AbsoluteSize.X,0,math.min(ContentH, 150))
                                List.CanvasSize=UDim2.new(0,0,0,ContentH)
                                List.Visible=true
                                DropdownHolder.Visible=true
                            end
                        end)
                    end

                    DropdownHolder.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then List.Visible=false DropdownHolder.Visible=false end end)
                    
                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddKeybind(Config)
                    local Text = Config.Title or "Keybind"
                    local Def = Config.Default or Enum.KeyCode.RightShift
                    local Call = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description

                    local F=Instance.new("Frame", GetContainer())
                    F.Size=UDim2.new(1,0,0,20)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end

                    local L=Instance.new("TextLabel",F)
                    L.Size=UDim2.new(1,0,1,0)
                    L.BackgroundTransparency=1
                    L.Text=Text
                    L.Font=Enum.Font.Gotham
                    L.TextSize=12
                    L.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(L,"TextColor3","Text")
                    local B=Instance.new("TextButton",F)
                    B.Size=UDim2.new(0,60,0,18)
                    B.Position=UDim2.new(1,-60,0.5,-9)
                    B.BackgroundColor3=Library.Theme.ItemBackground
                    Library:RegisterTheme(B, "BackgroundColor3", "ItemBackground")
                    B.Text=Def.Name
                    B.Font=Enum.Font.Gotham
                    B.TextSize=11
                    B.TextColor3=Color3.fromRGB(200,200,200)
                    Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
                    local bind=false
                    B.MouseButton1Click:Connect(function() bind=true B.Text="..." end)
                    UserInputService.InputBegan:Connect(function(i) if bind and i.UserInputType==Enum.UserInputType.Keyboard then bind=false B.Text=i.KeyCode.Name pcall(Call,i.KeyCode) end end)
                
                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddTextbox(Config)
                    local Text = Config.Title or "Textbox"
                    local Ph = Config.Placeholder or ""
                    local Call = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description
                    local Clear = Config.ClearOnFocus

                    local F=Instance.new("Frame", GetContainer())
                    F.Size=UDim2.new(1,0,0,40)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end

                    local L=Instance.new("TextLabel",F)
                    L.Size=UDim2.new(1,0,0,15)
                    L.BackgroundTransparency=1
                    L.Text=Text
                    L.Font=Enum.Font.Gotham
                    L.TextSize=12
                    L.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(L,"TextColor3","Text")
                    local B=Instance.new("TextBox",F)
                    B.Size=UDim2.new(1,0,0,20)
                    B.Position=UDim2.new(0,0,0,18)
                    B.BackgroundColor3=Library.Theme.ItemBackground
                    Library:RegisterTheme(B, "BackgroundColor3", "ItemBackground")
                    B.Text=""
                    B.PlaceholderText=Ph
                    B.TextColor3=Color3.fromRGB(230,230,230)
                    B.Font=Enum.Font.Gotham
                    B.TextSize=12
                    B.ClearTextOnFocus = Clear or false
                    Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
                    B.FocusLost:Connect(function() Library.Flags[Flag]=B.Text pcall(Call,B.Text) end)
                
                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddButton(Config)
                    local Text = Config.Title or "Button"
                    local Call = Config.Callback or function() end
                    local Desc = Config.Description

                    local F=Instance.new("Frame", GetContainer())
                    F.Size=UDim2.new(1,0,0,32)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end
                    
                    local B=Instance.new("TextButton",F)
                    B.Size=UDim2.new(1,0,1,0)
                    B.BackgroundColor3=Library.Theme.ItemBackground 
                    Library:RegisterTheme(B, "BackgroundColor3", "ItemBackground")
                    B.Text=Text
                    B.TextColor3=Library.Theme.Text
                    B.Font=Enum.Font.Gotham
                    B.TextSize=12
                    Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
                    B.MouseButton1Click:Connect(function()
                        TweenService:Create(B,TweenInfo.new(0.1),{BackgroundColor3=Library.Theme.Accent}):Play()
                        wait(0.1)
                        TweenService:Create(B,TweenInfo.new(0.1),{BackgroundColor3=Library.Theme.ItemBackground}):Play()
                        pcall(Call)
                    end)
                
                    RegisterItem(Text, F)
                end


                -- [ImGui: ProgressBar]
                function BoxFuncs:AddProgressBar(Config)
                    local Text = Config.Title or "Progress"
                    local Default = Config.Default or 0
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description

                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 35)
                    F.BackgroundTransparency = 1
                    if Desc then AddTooltip(F, Desc) end

                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, 0, 0, 15)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Gotham
                    Lb.TextSize = 12
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb, "TextColor3", "Text")

                    local BarBack = Instance.new("Frame", F)
                    BarBack.Name = "BarBackground"
                    BarBack.Size = UDim2.new(1, 0, 0, 14)
                    BarBack.Position = UDim2.new(0, 0, 0, 20)
                    BarBack.BackgroundColor3 = Library.Theme.ItemBackground
                    Library:RegisterTheme(BarBack, "BackgroundColor3", "ItemBackground")
                    Instance.new("UICorner", BarBack).CornerRadius = UDim.new(0, 4)

                    local BarFill = Instance.new("Frame", BarBack)
                    BarFill.Name = "BarFill"
                    BarFill.Size = UDim2.new(math.clamp(Default, 0, 1), 0, 1, 0)
                    BarFill.BackgroundColor3 = Library.Theme.Accent
                    BarFill.BorderSizePixel = 0
                    Library:RegisterTheme(BarFill, "BackgroundColor3", "Accent")
                    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(0, 4)

                    local PercentText = Instance.new("TextLabel", BarBack)
                    PercentText.Size = UDim2.new(1, 0, 1, 0)
                    PercentText.BackgroundTransparency = 1
                    PercentText.Font = Enum.Font.GothamBold
                    PercentText.TextSize = 10
                    PercentText.Text = math.floor(math.clamp(Default, 0, 1) * 100) .. "%"
                    PercentText.TextColor3 = Library.Theme.Text
                    PercentText.ZIndex = 2
                    Library:RegisterTheme(PercentText, "TextColor3", "Text")

                    local function Set(val)
                        val = math.clamp(val, 0, 1)
                        Library.Flags[Flag] = val
                        PercentText.Text = math.floor(val * 100) .. "%"
                        TweenService:Create(BarFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(val, 0, 1, 0)}):Play()
                    end

                    Library.Items[Flag] = {Set = Set}
                    Library.Flags[Flag] = Default
                    
                    RegisterItem(Text, F)
                end

                -- [ImGui: Image]
                function BoxFuncs:AddImage(Config)
                    local ImageId = Config.Image or "" -- rbxassetid://...
                    local Size = Config.Size or UDim2.new(0, 100, 0, 100)
                    local Desc = Config.Description
                    
                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, Size.Y.Offset + 5)
                    F.BackgroundTransparency = 1
                    
                    local Img = Instance.new("ImageLabel", F)
                    Img.Size = Size
                    Img.Position = UDim2.new(0.5, -Size.X.Offset/2, 0, 0)
                    Img.BackgroundTransparency = 1
                    Img.Image = ImageId
                    if Desc then AddTooltip(Img, Desc) end
                    
                    RegisterItem("Image", F)
                end

                -- [ImGui: ImageButton]
                function BoxFuncs:AddImageButton(Config)
                    local ImageId = Config.Image or ""
                    local Callback = Config.Callback or function() end
                    local Size = Config.Size or UDim2.new(0, 50, 0, 50)
                    local Desc = Config.Description

                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, Size.Y.Offset + 5)
                    F.BackgroundTransparency = 1

                    local Btn = Instance.new("ImageButton", F)
                    Btn.Size = Size
                    Btn.Position = UDim2.new(0.5, -Size.X.Offset/2, 0, 0)
                    Btn.BackgroundColor3 = Library.Theme.ItemBackground
                    Btn.Image = ImageId
                    Library:RegisterTheme(Btn, "BackgroundColor3", "ItemBackground")
                    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
                    
                    if Desc then AddTooltip(Btn, Desc) end

                    Btn.MouseButton1Click:Connect(function()
                        TweenService:Create(Btn, TweenInfo.new(0.1), {ImageColor3 = Library.Theme.Accent}):Play()
                        task.wait(0.1)
                        TweenService:Create(Btn, TweenInfo.new(0.1), {ImageColor3 = Color3.new(1,1,1)}):Play()
                        pcall(Callback)
                    end)

                    RegisterItem("ImageButton", F)
                end

                -- [ImGui: RadioButton]
                function BoxFuncs:AddRadioButton(Config)
                    local Text = Config.Title or "Radio Button"
                    local Options = Config.Options or {}
                    local Default = Config.Default or Options[1]
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    
                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 0)
                    F.AutomaticSize = Enum.AutomaticSize.Y
                    F.BackgroundTransparency = 1

                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, 0, 0, 15)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Gotham
                    Lb.TextSize = 12
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb, "TextColor3", "Text")

                    local OptionButtons = {}
                    local CurrentValue = Default

                    local OptContainer = Instance.new("Frame", F)
                    OptContainer.Size = UDim2.new(1, 0, 0, 0)
                    OptContainer.Position = UDim2.new(0, 0, 0, 20)
                    OptContainer.AutomaticSize = Enum.AutomaticSize.Y
                    OptContainer.BackgroundTransparency = 1
                    
                    local UIList = Instance.new("UIListLayout", OptContainer)
                    UIList.Padding = UDim.new(0, 5)

                    local function UpdateState(val)
                        CurrentValue = val
                        Library.Flags[Flag] = val
                        for _, btnData in pairs(OptionButtons) do
                            local isSelected = (btnData.Value == val)
                            local circleInner = btnData.Obj:FindFirstChild("InnerCircle", true)
                            if circleInner then
                                circleInner.Visible = isSelected
                            end
                            local txt = btnData.Obj:FindFirstChild("Label", true)
                            if txt then
                                TweenService:Create(txt, TweenInfo.new(0.2), {TextColor3 = isSelected and Library.Theme.Text or Library.Theme.TextDark}):Play()
                            end
                        end
                        pcall(Callback, val)
                    end

                    for _, opt in ipairs(Options) do
                        local OptBtn = Instance.new("TextButton", OptContainer)
                        OptBtn.Size = UDim2.new(1, 0, 0, 20)
                        OptBtn.BackgroundTransparency = 1
                        OptBtn.Text = ""
                        
                        local OuterCircle = Instance.new("Frame", OptBtn)
                        OuterCircle.Size = UDim2.new(0, 14, 0, 14)
                        OuterCircle.Position = UDim2.new(0, 0, 0.5, -7)
                        OuterCircle.BackgroundColor3 = Library.Theme.ItemBackground
                        Instance.new("UICorner", OuterCircle).CornerRadius = UDim.new(1, 0)
                        Library:RegisterTheme(OuterCircle, "BackgroundColor3", "ItemBackground")
                        local Stroke = Instance.new("UIStroke", OuterCircle)
                        Stroke.Color = Library.Theme.Outline
                        Stroke.Thickness = 1
                        Library:RegisterTheme(Stroke, "Color", "Outline")

                        local InnerCircle = Instance.new("Frame", OuterCircle)
                        InnerCircle.Name = "InnerCircle"
                        InnerCircle.Size = UDim2.new(0, 8, 0, 8)
                        InnerCircle.Position = UDim2.new(0.5, -4, 0.5, -4)
                        InnerCircle.BackgroundColor3 = Library.Theme.Accent
                        InnerCircle.Visible = false
                        Instance.new("UICorner", InnerCircle).CornerRadius = UDim.new(1, 0)
                        Library:RegisterTheme(InnerCircle, "BackgroundColor3", "Accent")

                        local OptLabel = Instance.new("TextLabel", OptBtn)
                        OptLabel.Name = "Label"
                        OptLabel.Size = UDim2.new(1, -20, 1, 0)
                        OptLabel.Position = UDim2.new(0, 20, 0, 0)
                        OptLabel.BackgroundTransparency = 1
                        OptLabel.Text = tostring(opt)
                        OptLabel.Font = Enum.Font.Gotham
                        OptLabel.TextSize = 12
                        OptLabel.TextXAlignment = Enum.TextXAlignment.Left
                        OptLabel.TextColor3 = Library.Theme.TextDark
                        Library:RegisterTheme(OptLabel, "TextColor3", "TextDark")

                        OptBtn.MouseButton1Click:Connect(function()
                            UpdateState(opt)
                        end)

                        table.insert(OptionButtons, {Obj = OptBtn, Value = opt})
                    end
                    
                    UpdateState(Default)
                    Library.Items[Flag] = {Set = UpdateState}
                    
                    F.Size = UDim2.new(1, 0, 0, 25 + (#Options * 25))
                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddGraph(Config)
                    local Text = Config.Title or "Graph"
                    local Values = Config.Values or {}
                    local Height = Config.Height or 60
                    local Desc = Config.Description

                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, Height + 20)
                    F.BackgroundTransparency = 1
                    if Desc then AddTooltip(F, Desc) end

                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, 0, 0, 15)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Gotham
                    Lb.TextSize = 12
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb, "TextColor3", "Text")

                    local GraphBox = Instance.new("Frame", F)
                    GraphBox.Size = UDim2.new(1, 0, 0, Height)
                    GraphBox.Position = UDim2.new(0, 0, 0, 20)
                    GraphBox.BackgroundColor3 = Library.Theme.ItemBackground
                    Library:RegisterTheme(GraphBox, "BackgroundColor3", "ItemBackground")
                    Instance.new("UICorner", GraphBox).CornerRadius = UDim.new(0, 4)
                    local Stroke = Instance.new("UIStroke", GraphBox)
                    Stroke.Color = Library.Theme.Outline
                    Stroke.Thickness = 1
                    Library:RegisterTheme(Stroke, "Color", "Outline")

                    local GraphContainer = Instance.new("Frame", GraphBox)
                    GraphContainer.Size = UDim2.new(1, -4, 1, -4)
                    GraphContainer.Position = UDim2.new(0, 2, 0, 2)
                    GraphContainer.BackgroundTransparency = 1
                    
                    local Layout = Instance.new("UIListLayout", GraphContainer)
                    Layout.FillDirection = Enum.FillDirection.Horizontal
                    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
                    Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
                    Layout.Padding = UDim.new(0, 1)

                    local function UpdateGraph(NewValues)
                        for _, v in pairs(GraphContainer:GetChildren()) do
                            if v:IsA("Frame") then v:Destroy() end
                        end
                        
                        if #NewValues == 0 then return end
                        local BarWidth = (GraphContainer.AbsoluteSize.X / #NewValues) - 1
                        if BarWidth < 1 then BarWidth = 1 end

                        local MaxVal = 0
                        for _, v in ipairs(NewValues) do if v > MaxVal then MaxVal = v end end
                        if MaxVal == 0 then MaxVal = 1 end

                        for _, val in ipairs(NewValues) do
                            local Bar = Instance.new("Frame", GraphContainer)
                            Bar.Size = UDim2.new(0, BarWidth, val / MaxVal, 0)
                            Bar.BackgroundColor3 = Library.Theme.Accent
                            Bar.BorderSizePixel = 0
                            Library:RegisterTheme(Bar, "BackgroundColor3", "Accent")
                            
                            local ValTip = Instance.new("TextLabel", Bar)
                            ValTip.Visible = false
                            ValTip.Size = UDim2.new(0, 50, 0, 15)
                            ValTip.Position = UDim2.new(0.5, -25, 0, -15)
                            ValTip.BackgroundColor3 = Library.Theme.Background
                            ValTip.TextColor3 = Library.Theme.Text
                            ValTip.TextSize = 8
                            ValTip.Text = tostring(math.floor(val*10)/10)
                            
                            Bar.MouseEnter:Connect(function() 
                                TweenService:Create(Bar, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
                                ValTip.Visible = true 
                            end)
                            Bar.MouseLeave:Connect(function() 
                                TweenService:Create(Bar, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
                                ValTip.Visible = false 
                            end)
                        end
                    end

                    UpdateGraph(Values)
                    Library.Items[Text] = {Set = UpdateGraph}

                    RegisterItem(Text, F)
                end

                -- [ImGui: VSliderFloat / VSliderInt]
                function BoxFuncs:AddVerticalSlider(Config)
                    local Text = Config.Title or "V.Slider"
                    local Min = Config.Min or 0
                    local Max = Config.Max or 100
                    local Def = Config.Default or Min
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Height = Config.Height or 100
                    local Desc = Config.Description

                    local F = Instance.new("Frame", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, Height + 25)
                    F.BackgroundTransparency = 1
                    if Desc then AddTooltip(F, Desc) end

                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, 0, 0, 15)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Gotham
                    Lb.TextSize = 12
                    Lb.TextXAlignment = Enum.TextXAlignment.Center
                    Library:RegisterTheme(Lb, "TextColor3", "Text")

                    local SliderBg = Instance.new("Frame", F)
                    SliderBg.Name = "SliderBackground"
                    SliderBg.Size = UDim2.new(0, 20, 0, Height)
                    SliderBg.Position = UDim2.new(0.5, -10, 0, 20)
                    SliderBg.BackgroundColor3 = Library.Theme.ItemBackground
                    Library:RegisterTheme(SliderBg, "BackgroundColor3", "ItemBackground")
                    Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(0, 4)

                    local SliderFill = Instance.new("Frame", SliderBg)
                    SliderFill.Name = "SliderFill"
                    SliderFill.AnchorPoint = Vector2.new(0, 1)
                    SliderFill.Position = UDim2.new(0, 0, 1, 0)
                    SliderFill.Size = UDim2.new(1, 0, (Def - Min) / (Max - Min), 0)
                    SliderFill.BackgroundColor3 = Library.Theme.Accent
                    SliderFill.BorderSizePixel = 0
                    Library:RegisterTheme(SliderFill, "BackgroundColor3", "Accent")
                    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 4)

                    local ValText = Instance.new("TextLabel", SliderBg)
                    ValText.Size = UDim2.new(2, 0, 1, 0)
                    ValText.Position = UDim2.new(-0.5, 0, 0, 0)
                    ValText.BackgroundTransparency = 1
                    ValText.Font = Enum.Font.GothamBold
                    ValText.TextSize = 10
                    ValText.Text = tostring(math.floor(Def * 100)/100)
                    ValText.TextColor3 = Library.Theme.Text
                    ValText.TextStrokeTransparency = 0.5
                    ValText.ZIndex = 3

                    local Btn = Instance.new("TextButton", SliderBg)
                    Btn.Size = UDim2.new(1, 0, 1, 0)
                    Btn.BackgroundTransparency = 1
                    Btn.Text = ""

                    local function Set(v)
                        v = math.clamp(v, Min, Max)
                        v = math.floor(v * 100) / 100
                        
                        Library.Flags[Flag] = v
                        ValText.Text = tostring(v)
                        
                        local percent = (v - Min) / (Max - Min)
                        TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, percent, 0)}):Play()
                        
                        pcall(Callback, v)
                    end

                    Library.Items[Flag] = {Set = Set}
                    Library.Flags[Flag] = Def

                    local dragging = false
                    local function UpdateInput(input)
                        local bottomY = SliderBg.AbsolutePosition.Y + SliderBg.AbsoluteSize.Y
                        local mouseY = input.Position.Y
                        
                        local distFromBottom = bottomY - mouseY
                        local percent = math.clamp(distFromBottom / SliderBg.AbsoluteSize.Y, 0, 1)
                        
                        local newVal = Min + (Max - Min) * percent
                        Set(newVal)
                    end

                    Btn.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = true
                            UpdateInput(input)
                        end
                    end)

                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                        end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            UpdateInput(input)
                        end
                    end)

                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddSelectable(Config)
                    local Text = Config.Title or "Selectable"
                    local Selected = Config.Default or false
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description

                    local F = Instance.new("TextButton", GetContainer())
                    F.Size = UDim2.new(1, 0, 0, 22)
                    F.BackgroundTransparency = Selected and 0 or 1
                    F.BackgroundColor3 = Library.Theme.Accent
                    F.Text = ""
                    F.AutoButtonColor = false
                    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 4)
                    
                    if Desc then AddTooltip(F, Desc) end

                    Library:RegisterTheme(F, "BackgroundColor3", "Accent") 

                    local Lb = Instance.new("TextLabel", F)
                    Lb.Size = UDim2.new(1, -10, 1, 0)
                    Lb.Position = UDim2.new(0, 10, 0, 0)
                    Lb.BackgroundTransparency = 1
                    Lb.Text = Text
                    Lb.Font = Enum.Font.Gotham
                    Lb.TextSize = 12
                    Lb.TextXAlignment = Enum.TextXAlignment.Left
                    Lb.TextColor3 = Selected and Library.Theme.Text or Library.Theme.TextDark
                    
                    local function UpdateVisuals(isHovered, isSelected)
                        if isSelected then
                            TweenService:Create(F, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
                            TweenService:Create(Lb, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Text}):Play()
                        elseif isHovered then
                            TweenService:Create(F, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
                            TweenService:Create(Lb, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Text}):Play()
                        else
                            TweenService:Create(F, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                            TweenService:Create(Lb, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextDark}):Play()
                        end
                    end

                    F.MouseEnter:Connect(function() UpdateVisuals(true, Library.Flags[Flag]) end)
                    F.MouseLeave:Connect(function() UpdateVisuals(false, Library.Flags[Flag]) end)

                    local function Set(val)
                        Library.Flags[Flag] = val
                        UpdateVisuals(false, val)
                        pcall(Callback, val)
                    end

                    Library.Items[Flag] = {Set = Set}
                    Library.Flags[Flag] = Selected
                    
                    UpdateVisuals(false, Selected)

                    F.MouseButton1Click:Connect(function()
                        Set(not Library.Flags[Flag])
                    end)

                    RegisterItem(Text, F)
                end

                return BoxFuncs
            end
            return SubFuncs
        end
        return TabFuncs
    end
    return WindowFuncs
end

return Library
