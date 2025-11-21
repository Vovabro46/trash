--[[
    GILA MONSTER LIBRARY [SOURCE]
    Type: UI Library
    Version: 3.5 (Loadstring Compatible)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Library = { 
    Flags = {}, 
    Items = {}, 
    Minimized = false,
    Theme = {
        Main      = Color3.fromRGB(20, 20, 20),
        Sidebar   = Color3.fromRGB(25, 25, 28),
        Section   = Color3.fromRGB(30, 30, 35),
        Accent    = Color3.fromRGB(120, 110, 225), -- Lavender
        Text      = Color3.fromRGB(255, 255, 255),
        DimText   = Color3.fromRGB(145, 145, 145),
        Border    = Color3.fromRGB(45, 45, 50),
        FontMain  = Enum.Font.GothamBold,
        FontSmall = Enum.Font.GothamBold
    }
}

local CfgFolder = "GilaConfigs"
local Icons = {
    ["menu"] = "rbxassetid://6031091000", ["minimize"] = "rbxassetid://6031094670",
    ["x"] = "rbxassetid://6031094678", ["arrow_d"] = "rbxassetid://6031091304",
    ["info"] = "rbxassetid://6031225819"
}

--// UTILS
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

local function MakeDraggable(trigger, target, isButton)
    local dragging, dragStart, startPos, hasMoved = false, nil, nil, false
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false
            dragStart = input.Position; startPos = target.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    trigger.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if isButton and not hasMoved then trigger:FindFirstChild("TouchClick"):Fire() end
        end
    end)
end

--// CONFIG SYSTEM (Exposed to Library)
function Library:InitConfig()
    if not isfolder(CfgFolder) then makefolder(CfgFolder) end
end

function Library:SaveConfig(name)
    if not name or name == "" then return end
    writefile(CfgFolder .. "/" .. name .. ".json", HttpService:JSONEncode(Library.Flags))
end

function Library:LoadConfig(name)
    if not isfile(CfgFolder .. "/" .. name .. ".json") then return end
    local data = HttpService:JSONDecode(readfile(CfgFolder .. "/" .. name .. ".json"))
    for flag, value in pairs(data) do
        Library.Flags[flag] = value
        if Library.Items[flag] then Library.Items[flag]:Set(value) end
    end
end

function Library:DeleteConfig(name)
    if isfile(CfgFolder .. "/" .. name .. ".json") then delfile(CfgFolder .. "/" .. name .. ".json") end
end

function Library:GetConfigs()
    if not isfolder(CfgFolder) then return {} end
    local clean = {}
    for _, file in pairs(listfiles(CfgFolder)) do
        local name = file:match("([^/]+)%.json$")
        if name then table.insert(clean, name) end
    end
    return clean
end

Library:InitConfig()

--// NOTIFICATIONS
local NotifGui = Create("ScreenGui", {Parent = CoreGui, DisplayOrder = 100, Name = "GilaNotifs"})
local NotifContainer = Create("Frame", {
    Parent = NotifGui, BackgroundTransparency = 1, Position = UDim2.new(1, -20, 1, -20),
    AnchorPoint = Vector2.new(1, 1), Size = UDim2.new(0, 280, 1, 0)
})
Create("UIListLayout", {Parent = NotifContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right})

function Library:Notify(title, desc, duration)
    local dur = duration or 4
    local Frame = Create("Frame", {Parent = NotifContainer, BackgroundColor3 = Color3.fromRGB(25,25,25), Size = UDim2.new(1,0,0,60), Position = UDim2.new(2,0,0,0), BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y})
    Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0,6)})
    Create("UIStroke", {Parent = Frame, Color = Library.Theme.Accent, Thickness = 1.5, Transparency = 0.5})
    Create("UIGradient", {Parent = Frame, Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,35)), ColorSequenceKeypoint.new(1, Color3.fromRGB(20,20,20))}), Rotation = 45})
    Create("ImageLabel", {Parent = Frame, BackgroundTransparency = 1, Image = Icons.info, ImageColor3 = Library.Theme.Accent, Size = UDim2.new(0,24,0,24), Position = UDim2.new(0,10,0,10)})
    Create("TextLabel", {Parent = Frame, Text = title:upper(), TextColor3 = Library.Theme.Accent, Font = Enum.Font.GothamBlack, TextSize = 13, BackgroundTransparency = 1, Size = UDim2.new(1,-50,0,20), Position = UDim2.new(0,40,0,5), TextXAlignment = Enum.TextXAlignment.Left})
    Create("TextLabel", {Parent = Frame, Text = desc, TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 11, BackgroundTransparency = 1, Size = UDim2.new(1,-50,0,0), Position = UDim2.new(0,40,0,25), TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y})
    Create("UIPadding", {Parent = Frame, PaddingBottom = UDim.new(0,12)})
    
    local BarBg = Create("Frame", {Parent = Frame, BackgroundColor3 = Color3.fromRGB(40,40,40), Size = UDim2.new(1,-12,0,2), Position = UDim2.new(0,6,1,-4), BorderSizePixel = 0})
    local BarFill = Create("Frame", {Parent = BarBg, BackgroundColor3 = Library.Theme.Accent, Size = UDim2.new(0,0,1,0), BorderSizePixel = 0})
    
    Frame:TweenPosition(UDim2.new(0,0,0,0), "Out", "Back", 0.5)
    TweenService:Create(BarFill, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Size = UDim2.new(1,0,1,0)}):Play()
    
    task.delay(dur, function()
        if Frame then Frame:TweenPosition(UDim2.new(1.5,0,0,0), "In", "Quad", 0.3); task.wait(0.3); Frame:Destroy() end
    end)
end

--// WINDOW CREATION
function Library:Window(opts)
    local TargetParent = RunService:IsStudio() and Players.LocalPlayer.PlayerGui or CoreGui
    if TargetParent:FindFirstChild("GilaFixed") then TargetParent.GilaFixed:Destroy() end
    
    local Screen = Create("ScreenGui", {Name = "GilaFixed", Parent = TargetParent, ResetOnSpawn = false, IgnoreGuiInset=true, DisplayOrder=10})
    local MobToggle = Create("ImageButton", {Parent = Screen, BackgroundColor3 = Library.Theme.Main, Position = UDim2.new(0,50,0,50), Size = UDim2.new(0,45,0,45), Image = Icons.menu, ImageColor3 = Library.Theme.Accent, ZIndex = 50, Active = true})
    Create("UICorner", {Parent=MobToggle, CornerRadius=UDim.new(0,8)})
    Create("UIStroke", {Parent=MobToggle, Color=Library.Theme.Accent, Thickness=2})
    local ClickEvt = Instance.new("BindableEvent", MobToggle) ClickEvt.Name = "TouchClick"

    local Main = Create("Frame", {Parent = Screen, BackgroundColor3 = Library.Theme.Main, Position = UDim2.new(0.5,-325,0.5,-225), Size = UDim2.new(0,650,0,450), ClipsDescendants = true, Visible = true})
    Create("UICorner", {Parent=Main, CornerRadius=UDim.new(0,6)})
    Create("UIStroke", {Parent=Main, Color=Library.Theme.Border, Thickness=1.5})
    
    ClickEvt.Event:Connect(function() Main.Visible = not Main.Visible end)
    MakeDraggable(MobToggle, MobToggle, true)

    local Top = Create("Frame", {Parent = Main, BackgroundColor3 = Library.Theme.Main, Size = UDim2.new(1,0,0,40), BorderSizePixel = 0, ZIndex=5})
    Create("TextLabel", {Parent = Top, Text = "GILA", TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamBlack, TextSize = 16, Size = UDim2.new(0,50,1,0), Position = UDim2.new(0,15,0,0), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6})
    Create("TextLabel", {Parent = Top, Text = "MONSTER", TextColor3 = Library.Theme.Accent, Font = Enum.Font.GothamBlack, TextSize = 16, Size = UDim2.new(0,100,1,0), Position = UDim2.new(0,60,0,0), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6})
    
    local ControlBox = Create("Frame", {Parent=Top, Size=UDim2.new(0,80,1,0), Position=UDim2.new(1,-80,0,0), BackgroundTransparency=1, ZIndex=6})
    Create("UIListLayout", {Parent=ControlBox, FillDirection=Enum.FillDirection.Horizontal, HorizontalAlignment=Enum.HorizontalAlignment.Center, VerticalAlignment=Enum.VerticalAlignment.Center})
    
    local function AddCtrl(ico, cb)
        local Btn = Create("ImageButton", {Parent = ControlBox, Size = UDim2.new(0,24,0,24), BackgroundTransparency=1, Image = ico, ImageColor3 = Library.Theme.DimText, ScaleType=Enum.ScaleType.Fit, ZIndex=7})
        Btn.MouseButton1Click:Connect(cb)
    end
    AddCtrl(Icons.minimize, function() Library.Minimized = not Library.Minimized; Main:TweenSize(Library.Minimized and UDim2.new(0,650,0,40) or UDim2.new(0,650,0,450), "Out", "Quad", 0.3, true) end)
    AddCtrl(Icons.x, function() Screen:Destroy() NotifGui:Destroy() end)
    Create("Frame", {Parent=Main, BackgroundColor3=Library.Theme.Border, Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,0,40), ZIndex=6})
    MakeDraggable(Top, Main, false)

    local Sidebar = Create("Frame", {Parent=Main, BackgroundColor3=Library.Theme.Sidebar, Size=UDim2.new(0,150,1,-41), Position=UDim2.new(0,0,0,41), BorderSizePixel=0})
    local Content = Create("Frame", {Parent=Main, BackgroundTransparency=1, Size=UDim2.new(1,-160,1,-51), Position=UDim2.new(0,160,0,51)})
    local SidebarList = Create("ScrollingFrame", {Parent=Sidebar, BackgroundTransparency=1, Size=UDim2.new(1,0,1,-10), Position=UDim2.new(0,0,0,10), ScrollBarThickness=0})
    Create("UIListLayout", {Parent=SidebarList, SortOrder=Enum.SortOrder.LayoutOrder})

    local Tabs = {}
    local firstTab = true

    function Tabs:Tab(name)
        local TBtn = Create("TextButton", {Parent = SidebarList, Size = UDim2.new(1,0,0,36), BackgroundTransparency=1, Text = "    "..name:upper(), TextColor3 = Library.Theme.DimText, Font = Library.Theme.FontMain, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor=false})
        local Ind = Create("Frame", {Parent=TBtn, BackgroundColor3=Library.Theme.Accent, Size=UDim2.new(0,2,0,18), Position=UDim2.new(0,0,0.5,-9), Visible=false})
        local Page = Create("Frame", {Parent=Content, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Visible=false})
        local Left = Create("ScrollingFrame", {Parent=Page, Size=UDim2.new(0.48,0,1,0), BackgroundTransparency=1, ScrollBarThickness=0, AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(0,0,0,0)})
        local Right = Create("ScrollingFrame", {Parent=Page, Size=UDim2.new(0.48,0,1,0), Position=UDim2.new(0.52,0,0,0), BackgroundTransparency=1, ScrollBarThickness=0, AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(0,0,0,0)})
        Create("UIListLayout", {Parent=Left, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,12)})
        Create("UIListLayout", {Parent=Right, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,12)})
        
        local function Show()
            for _, v in pairs(SidebarList:GetChildren()) do if v:IsA("TextButton") then TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Library.Theme.DimText}):Play(); v.Frame.Visible=false end end
            for _, v in pairs(Content:GetChildren()) do v.Visible=false end
            TweenService:Create(TBtn, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Text}):Play(); Ind.Visible=true; Page.Visible=true
        end
        TBtn.MouseButton1Click:Connect(Show)
        if firstTab then firstTab=false; Show() end

        local Funcs = {}
        function Funcs:Section(title, side)
            local P = (side=="Right") and Right or Left
            local Sec = Create("Frame", {Parent=P, BackgroundColor3=Library.Theme.Section, Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y})
            Create("UICorner", {Parent=Sec, CornerRadius=UDim.new(0,4)})
            local H = Create("Frame", {Parent=Sec, BackgroundTransparency=1, Size=UDim2.new(1,0,0,30)})
            Create("Frame", {Parent=H, BackgroundColor3=Library.Theme.Border, Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,0), BorderSizePixel=0})
            Create("TextLabel", {Parent=H, Text=title:upper(), TextColor3=Library.Theme.Accent, Font=Library.Theme.FontMain, TextSize=11, BackgroundTransparency=1, Size=UDim2.new(1,-10,1,0), Position=UDim2.new(0,10,0,0), TextXAlignment=Enum.TextXAlignment.Left})
            local Items = Create("Frame", {Parent=Sec, BackgroundTransparency=1, Position=UDim2.new(0,8,0,35), Size=UDim2.new(1,-16,0,0), AutomaticSize=Enum.AutomaticSize.Y})
            Create("UIListLayout", {Parent=Items, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,6)})
            Create("UIPadding", {Parent=Items, PaddingBottom=UDim.new(0,10)})

            local E = {}
            function E:Label(text) return Create("TextLabel", {Parent=Items, Text=text, TextColor3=Library.Theme.DimText, Font=Library.Theme.FontSmall, TextSize=12, BackgroundTransparency=1, Size=UDim2.new(1,0,0,18), TextXAlignment=Enum.TextXAlignment.Left}) end
            function E:Paragraph(head, desc)
                local Box = Create("Frame", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y})
                Create("TextLabel", {Parent=Box, Text=head, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})
                Create("TextLabel", {Parent=Box, Text=desc, TextColor3=Library.Theme.DimText, Font=Library.Theme.FontSmall, TextSize=11, Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, AutomaticSize=Enum.AutomaticSize.Y})
                Create("UIPadding", {Parent=Box, PaddingBottom=UDim.new(0,5)})
                return Box
            end
            function E:Button(text, cb)
                local Btn = Create("TextButton", {Parent=Items, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(1,0,0,25), Text=text, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=11})
                Create("UICorner", {Parent=Btn, CornerRadius=UDim.new(0,4)}); Create("UIStroke", {Parent=Btn, Color=Library.Theme.Border})
                Btn.MouseButton1Click:Connect(cb)
                return Btn
            end
            function E:Toggle(txt, def, flag, cb)
                local TogBtn = Create("TextButton", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,20), Text=""})
                Create("TextLabel", {Parent=TogBtn, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, BackgroundTransparency=1, Size=UDim2.new(1,-25,1,0), TextXAlignment=Enum.TextXAlignment.Left})
                local Box = Create("Frame", {Parent=TogBtn, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(0,14,0,14), Position=UDim2.new(1,-14,0.5,-7)})
                Create("UICorner", {Parent=Box, CornerRadius=UDim.new(0,3)}); Create("UIStroke", {Parent=Box, Color=Library.Theme.Border})
                local Fill = Create("Frame", {Parent=Box, BackgroundColor3=Library.Theme.Accent, Size=UDim2.new(1,-2,1,-2), Position=UDim2.new(0,1,0,1), Visible=def or false})
                Create("UICorner", {Parent=Fill, CornerRadius=UDim.new(0,2)})
                local state = def or false; if flag then Library.Flags[flag] = state end
                local function Set(val) state = val; Fill.Visible = state; if flag then Library.Flags[flag] = state end; if cb then cb(state) end end
                TogBtn.MouseButton1Click:Connect(function() Set(not state) end)
                local ret = {Set = Set}; if flag then Library.Items[flag] = ret end; return ret
            end
            function E:Slider(txt, min, max, def, flag, cb)
                local Box = Create("Frame", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,35)})
                Create("TextLabel", {Parent=Box, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})
                local Val = Create("TextLabel", {Parent=Box, Text=tostring(def), TextColor3=Library.Theme.Accent, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right})
                local Bar = Create("Frame", {Parent=Box, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(1,0,0,5), Position=UDim2.new(0,0,0,22)}); Create("UICorner", {Parent=Bar, CornerRadius=UDim.new(0,2)})
                local Fill = Create("Frame", {Parent=Bar, BackgroundColor3=Library.Theme.Accent, Size=UDim2.new((def-min)/(max-min),0,1,0)}); Create("UICorner", {Parent=Fill, CornerRadius=UDim.new(0,2)})
                local Trigger = Create("TextButton", {Parent=Bar, BackgroundTransparency=1, Size=UDim2.new(1,0,1,0), Text=""})
                if flag then Library.Flags[flag] = def end
                local function Set(val) val = math.clamp(val, min, max); Fill.Size = UDim2.new((val-min)/(max-min), 0, 1, 0); Val.Text = tostring(val); if flag then Library.Flags[flag] = val end; if cb then cb(val) end end
                local d = false; local function Input(i) local sc = math.clamp((i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1); Set(math.floor(min + ((max-min)*sc))) end
                Trigger.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=true; Input(i) end end)
                UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then Input(i) end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=false end end)
                local ret = {Set = Set}; if flag then Library.Items[flag] = ret end; return ret
            end
            function E:Dropdown(txt, opts, def, flag, cb)
                local Main = Create("Frame", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,40), ZIndex=5})
                Create("TextLabel", {Parent=Main, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})
                local Btn = Create("TextButton", {Parent=Main, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,20), Text="  "..(def or "..."), TextXAlignment=Enum.TextXAlignment.Left, TextColor3=Library.Theme.DimText, Font=Library.Theme.FontSmall, TextSize=11}); Create("UIStroke", {Parent=Btn, Color=Library.Theme.Border})
                Create("ImageLabel", {Parent=Btn, BackgroundTransparency=1, Image=Icons.arrow_d, ImageColor3=Library.Theme.DimText, Size=UDim2.new(0,16,0,16), Position=UDim2.new(1,-20,0,2)})
                local List = Create("ScrollingFrame", {Parent=Btn, Visible=false, Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,1,2), BackgroundColor3=Library.Theme.Section, BorderColor3=Library.Theme.Accent, ZIndex=20, ScrollBarThickness=2, AutomaticSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0)}); Create("UIListLayout", {Parent=List, SortOrder=Enum.SortOrder.LayoutOrder}); Create("UISizeConstraint", {Parent=List, MaxSize=Vector2.new(9999, 150)})
                local open = false; local current = def; if flag then Library.Flags[flag] = current end
                local function ToggleList() open = not open; List.Visible = open end; Btn.MouseButton1Click:Connect(ToggleList)
                local function Set(val) current = val; Btn.Text = "  " .. val; if flag then Library.Flags[flag] = current end; if cb then cb(val) end; open = false; List.Visible = false end
                local function Refresh(newOpts) for _,v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end; for _, o in pairs(newOpts) do local OBtn = Create("TextButton", {Parent=List, BackgroundTransparency=1, Size=UDim2.new(1,0,0,25), Text=o, TextColor3=Library.Theme.DimText, Font=Library.Theme.FontSmall, TextSize=11, ZIndex=21}); OBtn.MouseButton1Click:Connect(function() Set(o) end) end end
                Refresh(opts); local ret = {Set = Set, Refresh = Refresh}; if flag then Library.Items[flag] = ret end; return ret
            end
            function E:Keybind(txt, def, flag, cb)
                local Row = Create("Frame", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,20)})
                Create("TextLabel", {Parent=Row, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,-60,1,0), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})
                local BindBtn = Create("TextButton", {Parent=Row, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(0,55,0,18), Position=UDim2.new(1,-55,0,1), Text=tostring(def):gsub("Enum.KeyCode.", ""), TextColor3=Library.Theme.Accent, Font=Library.Theme.FontSmall, TextSize=10}); Create("UIStroke", {Parent=BindBtn, Color=Library.Theme.Border}); Create("UICorner", {Parent=BindBtn, CornerRadius=UDim.new(0,4)})
                local key = def; local waiting = false
                BindBtn.MouseButton1Click:Connect(function() waiting = true; BindBtn.Text = "..." end)
                UserInputService.InputBegan:Connect(function(input) if waiting and input.KeyCode ~= Enum.KeyCode.Unknown then key = input.KeyCode; waiting = false; BindBtn.Text = tostring(key):gsub("Enum.KeyCode.", ""); if flag then Library.Flags[flag] = key end; if cb then cb(key) end elseif input.KeyCode == key and cb then cb(key) end end)
            end
            return E
        end
        return Funcs
    end
    return Tabs
end

return Library
