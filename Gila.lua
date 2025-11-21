--[[
    GILA MONSTER LIBRARY [SOURCE v6]
    Features:
    - PRESET THEMES (Red, Blue, Green, etc.)
    - FULL MOBILE SUPPORT
    - Configs & ColorPickers
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
    ThemeObjects = { Accent = {}, Text = {}, Main = {}, Sidebar = {}, Section = {} },
    Theme = {
        Main      = Color3.fromRGB(20, 20, 20),
        Sidebar   = Color3.fromRGB(25, 25, 28),
        Section   = Color3.fromRGB(30, 30, 35),
        Accent    = Color3.fromRGB(120, 110, 225),
        Text      = Color3.fromRGB(255, 255, 255),
        DimText   = Color3.fromRGB(145, 145, 145),
        Border    = Color3.fromRGB(45, 45, 50),
        FontMain  = Enum.Font.GothamBold,
        FontSmall = Enum.Font.GothamBold
    }
}

--// [NEW] THEME PRESETS
Library.ThemePresets = {
    ["Default"] = {
        Main = Color3.fromRGB(20, 20, 20), Sidebar = Color3.fromRGB(25, 25, 28), Section = Color3.fromRGB(30, 30, 35), Accent = Color3.fromRGB(120, 110, 225)
    },
    ["Blood Moon"] = {
        Main = Color3.fromRGB(20, 15, 15), Sidebar = Color3.fromRGB(25, 20, 20), Section = Color3.fromRGB(30, 25, 25), Accent = Color3.fromRGB(230, 60, 60)
    },
    ["Oceanic"] = {
        Main = Color3.fromRGB(15, 20, 25), Sidebar = Color3.fromRGB(20, 25, 30), Section = Color3.fromRGB(25, 30, 35), Accent = Color3.fromRGB(0, 160, 255)
    },
    ["Toxic"] = {
        Main = Color3.fromRGB(15, 20, 15), Sidebar = Color3.fromRGB(20, 25, 20), Section = Color3.fromRGB(25, 30, 25), Accent = Color3.fromRGB(100, 255, 100)
    },
    ["Cotton Candy"] = {
        Main = Color3.fromRGB(25, 20, 25), Sidebar = Color3.fromRGB(30, 25, 30), Section = Color3.fromRGB(35, 30, 35), Accent = Color3.fromRGB(255, 150, 210)
    },
    ["Midnight"] = {
        Main = Color3.fromRGB(10, 10, 15), Sidebar = Color3.fromRGB(15, 15, 20), Section = Color3.fromRGB(20, 20, 25), Accent = Color3.fromRGB(80, 80, 255)
    }
}

local CfgFolder = "GilaConfigs"
local Icons = {
    ["menu"] = "rbxassetid://6031091000", ["minimize"] = "rbxassetid://6031094670",
    ["x"] = "rbxassetid://6031094678", ["arrow_d"] = "rbxassetid://6031091304",
    ["info"] = "rbxassetid://6031225819"
}

local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

--// THEME SYSTEM
function Library:RegisterThemeObj(type, obj, property)
    if not Library.ThemeObjects[type] then Library.ThemeObjects[type] = {} end
    table.insert(Library.ThemeObjects[type], {Object = obj, Property = property})
end

function Library:UpdateTheme(type, color)
    Library.Theme[type] = color
    if Library.ThemeObjects[type] then
        for _, item in pairs(Library.ThemeObjects[type]) do
            if item.Object then item.Object[item.Property] = color end
        end
    end
end

--// [NEW] SET PRESET FUNCTION
function Library:SetTheme(themeName)
    local preset = Library.ThemePresets[themeName]
    if not preset then return end
    for key, color in pairs(preset) do
        Library:UpdateTheme(key, color)
    end
    Library:Notify("Theme", "Applied: " .. themeName, 2)
end

function Library:GetThemes()
    local t = {}
    for k,v in pairs(Library.ThemePresets) do table.insert(t, k) end
    table.sort(t)
    return t
end

--// MOBILE DRAG (PRESERVED)
local function MakeDraggable(trigger, target, isButton)
    local dragging, dragStart, startPos, hasMoved = false, nil, nil, false
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false; dragStart = input.Position; startPos = target.Position
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
            dragging = false; if isButton and not hasMoved then trigger:FindFirstChild("TouchClick"):Fire() end
        end
    end)
end

--// CONFIG SYSTEM
function Library:InitConfig() if not isfolder(CfgFolder) then makefolder(CfgFolder) end end
function Library:SaveConfig(name) if not name or name=="" then return end writefile(CfgFolder.."/"..name..".json", HttpService:JSONEncode(Library.Flags)) end
function Library:LoadConfig(name) if not isfile(CfgFolder.."/"..name..".json") then return end local data = HttpService:JSONDecode(readfile(CfgFolder.."/"..name..".json")) for flag,v in pairs(data) do Library.Flags[flag]=v if Library.Items[flag] then Library.Items[flag]:Set(v) end end end
function Library:DeleteConfig(name) if isfile(CfgFolder.."/"..name..".json") then delfile(CfgFolder.."/"..name..".json") end end
function Library:GetConfigs() if not isfolder(CfgFolder) then return {} end local c={} for _,f in pairs(listfiles(CfgFolder)) do local n=f:match("([^/]+)%.json$") if n then table.insert(c,n) end end return c end
Library:InitConfig()

--// NOTIFICATIONS
local NotifGui = Create("ScreenGui", {Parent = CoreGui, DisplayOrder = 100, Name = "GilaNotifs"})
local NotifContainer = Create("Frame", {Parent = NotifGui, BackgroundTransparency = 1, Position = UDim2.new(1,-20,1,-20), AnchorPoint = Vector2.new(1,1), Size = UDim2.new(0,280,1,0)})
Create("UIListLayout", {Parent = NotifContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,10), VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right})
function Library:Notify(title, desc, duration)
    local Frame = Create("Frame", {Parent = NotifContainer, BackgroundColor3 = Color3.fromRGB(25,25,25), Size = UDim2.new(1,0,0,60), AutomaticSize=Enum.AutomaticSize.Y, BorderSizePixel=0})
    Create("UICorner", {Parent=Frame, CornerRadius=UDim.new(0,6)}); Create("UIStroke", {Parent=Frame, Color=Library.Theme.Accent, Thickness=1.5, Transparency=0.5})
    Library:RegisterThemeObj("Accent", Frame.UIStroke, "Color")
    Create("TextLabel", {Parent=Frame, Text=title:upper(), TextColor3=Library.Theme.Accent, Font=Enum.Font.GothamBlack, TextSize=13, BackgroundTransparency=1, Size=UDim2.new(1,-20,0,20), Position=UDim2.new(0,10,0,5), TextXAlignment=Enum.TextXAlignment.Left})
    Create("TextLabel", {Parent=Frame, Text=desc, TextColor3=Library.Theme.Text, Font=Enum.Font.GothamMedium, TextSize=11, BackgroundTransparency=1, Size=UDim2.new(1,-20,0,0), Position=UDim2.new(0,10,0,25), TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, AutomaticSize=Enum.AutomaticSize.Y})
    Frame:TweenPosition(UDim2.new(0,0,0,0), "Out", "Back", 0.5); task.delay(duration or 4, function() if Frame then Frame:Destroy() end end)
end

--// WINDOW
function Library:Window(opts)
    local TargetParent = RunService:IsStudio() and Players.LocalPlayer.PlayerGui or CoreGui
    if TargetParent:FindFirstChild("GilaFixed") then TargetParent.GilaFixed:Destroy() end
    
    local Screen = Create("ScreenGui", {Name = "GilaFixed", Parent = TargetParent, DisplayOrder=50})
    local MobToggle = Create("ImageButton", {Parent = Screen, BackgroundColor3 = Library.Theme.Main, Position = UDim2.new(0,50,0,50), Size = UDim2.new(0,45,0,45), Image = Icons.menu, ImageColor3 = Library.Theme.Accent, Active = true, ZIndex = 100})
    Create("UICorner", {Parent=MobToggle, CornerRadius=UDim.new(0,8)}); Create("UIStroke", {Parent=MobToggle, Color=Library.Theme.Accent, Thickness=2})
    local TouchClick = Instance.new("BindableEvent", MobToggle); TouchClick.Name = "TouchClick"
    
    local Main = Create("Frame", {Parent = Screen, BackgroundColor3 = Library.Theme.Main, Position = UDim2.new(0.5,-325,0.5,-225), Size = UDim2.new(0,650,0,450), ClipsDescendants = true})
    Library:RegisterThemeObj("Main", Main, "BackgroundColor3")
    Create("UICorner", {Parent=Main, CornerRadius=UDim.new(0,6)}); Create("UIStroke", {Parent=Main, Color=Library.Theme.Border, Thickness=1.5})
    
    TouchClick.Event:Connect(function() Main.Visible = not Main.Visible end); MakeDraggable(MobToggle, MobToggle, true)
    
    local Top = Create("Frame", {Parent = Main, BackgroundColor3 = Library.Theme.Main, Size = UDim2.new(1,0,0,40), BorderSizePixel = 0})
    Library:RegisterThemeObj("Main", Top, "BackgroundColor3")
    Create("TextLabel", {Parent = Top, Text = "GILA", TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamBlack, TextSize = 16, Size = UDim2.new(0,50,1,0), Position = UDim2.new(0,15,0,0), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})
    local Logo2 = Create("TextLabel", {Parent = Top, Text = "MONSTER", TextColor3 = Library.Theme.Accent, Font = Enum.Font.GothamBlack, TextSize = 16, Size = UDim2.new(0,100,1,0), Position = UDim2.new(0,60,0,0), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})
    Library:RegisterThemeObj("Accent", Logo2, "TextColor3")
    MakeDraggable(Top, Main, false)
    
    local Sidebar = Create("Frame", {Parent=Main, BackgroundColor3=Library.Theme.Sidebar, Size=UDim2.new(0,150,1,-41), Position=UDim2.new(0,0,0,41), BorderSizePixel=0})
    Library:RegisterThemeObj("Sidebar", Sidebar, "BackgroundColor3")
    local Content = Create("Frame", {Parent=Main, BackgroundTransparency=1, Size=UDim2.new(1,-160,1,-51), Position=UDim2.new(0,160,0,51)})
    local SidebarList = Create("ScrollingFrame", {Parent=Sidebar, BackgroundTransparency=1, Size=UDim2.new(1,0,1,-10), Position=UDim2.new(0,0,0,10), ScrollBarThickness=0})
    Create("UIListLayout", {Parent=SidebarList, SortOrder=Enum.SortOrder.LayoutOrder})

    local Tabs = {} 
    local first = true
    function Tabs:Tab(name)
        local TBtn = Create("TextButton", {Parent = SidebarList, Size = UDim2.new(1,0,0,36), BackgroundTransparency=1, Text = "    "..name:upper(), TextColor3 = Library.Theme.DimText, Font = Library.Theme.FontMain, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor=false})
        local Ind = Create("Frame", {Parent=TBtn, BackgroundColor3=Library.Theme.Accent, Size=UDim2.new(0,2,0,18), Position=UDim2.new(0,0,0.5,-9), Visible=false})
        Library:RegisterThemeObj("Accent", Ind, "BackgroundColor3")
        local Page = Create("Frame", {Parent=Content, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Visible=false})
        local Left = Create("ScrollingFrame", {Parent=Page, Size=UDim2.new(0.48,0,1,0), BackgroundTransparency=1, ScrollBarThickness=0, AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(0,0,0,0)})
        local Right = Create("ScrollingFrame", {Parent=Page, Size=UDim2.new(0.48,0,1,0), Position=UDim2.new(0.52,0,0,0), BackgroundTransparency=1, ScrollBarThickness=0, AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(0,0,0,0)})
        Create("UIListLayout", {Parent=Left, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,12)})
        Create("UIListLayout", {Parent=Right, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,12)})
        local function Show()
            for _, v in pairs(SidebarList:GetChildren()) do if v:IsA("TextButton") then TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Library.Theme.DimText}):Play() v.Frame.Visible=false end end
            for _, v in pairs(Content:GetChildren()) do v.Visible=false end
            TweenService:Create(TBtn, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Text}):Play() Ind.Visible=true Page.Visible=true
        end
        TBtn.MouseButton1Click:Connect(Show)
        if first then first=false Show() end

        local Funcs = {}
        function Funcs:Section(title, side)
            local P = (side=="Right") and Right or Left
            local Sec = Create("Frame", {Parent=P, BackgroundColor3=Library.Theme.Section, Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y})
            Library:RegisterThemeObj("Section", Sec, "BackgroundColor3")
            Create("UICorner", {Parent=Sec, CornerRadius=UDim.new(0,4)})
            local H = Create("Frame", {Parent=Sec, BackgroundTransparency=1, Size=UDim2.new(1,0,0,30)})
            local HTxt = Create("TextLabel", {Parent=H, Text=title:upper(), TextColor3=Library.Theme.Accent, Font=Library.Theme.FontMain, TextSize=11, BackgroundTransparency=1, Size=UDim2.new(1,-10,1,0), Position=UDim2.new(0,10,0,0), TextXAlignment=Enum.TextXAlignment.Left})
            Library:RegisterThemeObj("Accent", HTxt, "TextColor3")
            local Items = Create("Frame", {Parent=Sec, BackgroundTransparency=1, Position=UDim2.new(0,8,0,35), Size=UDim2.new(1,-16,0,0), AutomaticSize=Enum.AutomaticSize.Y})
            Create("UIListLayout", {Parent=Items, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,6)}); Create("UIPadding", {Parent=Items, PaddingBottom=UDim.new(0,10)})
            
            local E = {}
            function E:Label(t) return Create("TextLabel", {Parent=Items, Text=t, TextColor3=Library.Theme.DimText, Font=Library.Theme.FontSmall, TextSize=12, BackgroundTransparency=1, Size=UDim2.new(1,0,0,18), TextXAlignment=Enum.TextXAlignment.Left}) end
            function E:Button(t, cb)
                local Btn = Create("TextButton", {Parent=Items, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(1,0,0,25), Text=t, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=11})
                Library:RegisterThemeObj("Main", Btn, "BackgroundColor3")
                Create("UICorner", {Parent=Btn, CornerRadius=UDim.new(0,4)}); Create("UIStroke", {Parent=Btn, Color=Library.Theme.Border})
                Btn.MouseButton1Click:Connect(cb); return Btn
            end
            function E:TextBox(txt, ph, flag, cb)
                local Box = Create("Frame", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,40)})
                Create("TextLabel", {Parent=Box, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})
                local Input = Create("TextBox", {Parent=Box, BackgroundColor3=Library.Theme.Main, TextColor3=Library.Theme.Text, PlaceholderText=ph, Text="", Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,20), Font=Library.Theme.FontSmall, TextSize=11})
                Library:RegisterThemeObj("Main", Input, "BackgroundColor3")
                Create("UICorner", {Parent=Input, CornerRadius=UDim.new(0,4)}); Create("UIStroke", {Parent=Input, Color=Library.Theme.Border})
                Input.FocusLost:Connect(function() if flag then Library.Flags[flag]=Input.Text end if cb then cb(Input.Text) end end)
            end
            function E:Toggle(txt, def, flag, cb)
                local TogBtn = Create("TextButton", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,20), Text=""})
                Create("TextLabel", {Parent=TogBtn, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, BackgroundTransparency=1, Size=UDim2.new(1,-25,1,0), TextXAlignment=Enum.TextXAlignment.Left})
                local Box = Create("Frame", {Parent=TogBtn, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(0,14,0,14), Position=UDim2.new(1,-14,0.5,-7)}); Create("UICorner", {Parent=Box, CornerRadius=UDim.new(0,3)}); Create("UIStroke", {Parent=Box, Color=Library.Theme.Border})
                Library:RegisterThemeObj("Main", Box, "BackgroundColor3")
                local Fill = Create("Frame", {Parent=Box, BackgroundColor3=Library.Theme.Accent, Size=UDim2.new(1,-2,1,-2), Position=UDim2.new(0,1,0,1), Visible=def or false})
                Library:RegisterThemeObj("Accent", Fill, "BackgroundColor3")
                Create("UICorner", {Parent=Fill, CornerRadius=UDim.new(0,2)})
                local state=def; local function Set(v) state=v Fill.Visible=v if flag then Library.Flags[flag]=v end if cb then cb(v) end end
                TogBtn.MouseButton1Click:Connect(function() Set(not state) end)
                local r={Set=Set} if flag then Library.Items[flag]=r end return r
            end
            function E:Slider(txt, min, max, def, flag, cb)
                local Box = Create("Frame", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,35)})
                Create("TextLabel", {Parent=Box, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})
                local Val = Create("TextLabel", {Parent=Box, Text=tostring(def), TextColor3=Library.Theme.Accent, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right})
                Library:RegisterThemeObj("Accent", Val, "TextColor3")
                local Bar = Create("Frame", {Parent=Box, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(1,0,0,5), Position=UDim2.new(0,0,0,22)}); Create("UICorner", {Parent=Bar, CornerRadius=UDim.new(0,2)})
                Library:RegisterThemeObj("Main", Bar, "BackgroundColor3")
                local Fill = Create("Frame", {Parent=Bar, BackgroundColor3=Library.Theme.Accent, Size=UDim2.new((def-min)/(max-min),0,1,0)}); Create("UICorner", {Parent=Fill, CornerRadius=UDim.new(0,2)})
                Library:RegisterThemeObj("Accent", Fill, "BackgroundColor3")
                local Trigger = Create("TextButton", {Parent=Bar, BackgroundTransparency=1, Size=UDim2.new(1,0,1,0), Text=""})
                local function Set(v) v=math.clamp(v,min,max) Fill.Size=UDim2.new((v-min)/(max-min),0,1,0) Val.Text=tostring(v) if flag then Library.Flags[flag]=v end if cb then cb(v) end end
                local d=false; Trigger.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=true Set(math.floor(min+((max-min)*math.clamp((i.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1)))) end end)
                UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then Set(math.floor(min+((max-min)*math.clamp((i.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1)))) end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=false end end)
                local r={Set=Set} if flag then Library.Items[flag]=r end return r
            end
            function E:Dropdown(txt, opts, def, flag, cb)
                local Main = Create("Frame", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,40), ZIndex=5})
                Create("TextLabel", {Parent=Main, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})
                local Btn = Create("TextButton", {Parent=Main, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,20), Text="  "..(def or "..."), TextXAlignment=Enum.TextXAlignment.Left, TextColor3=Library.Theme.DimText, Font=Library.Theme.FontSmall, TextSize=11})
                Library:RegisterThemeObj("Main", Btn, "BackgroundColor3")
                Create("UIStroke", {Parent=Btn, Color=Library.Theme.Border})
                Create("ImageLabel", {Parent=Btn, BackgroundTransparency=1, Image=Icons.arrow_d, ImageColor3=Library.Theme.DimText, Size=UDim2.new(0,16,0,16), Position=UDim2.new(1,-20,0,2)})
                local List = Create("ScrollingFrame", {Parent=Btn, Visible=false, Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,1,2), BackgroundColor3=Library.Theme.Section, BorderColor3=Library.Theme.Accent, ZIndex=20, ScrollBarThickness=2, AutomaticSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(0,0,0,0)})
                Library:RegisterThemeObj("Section", List, "BackgroundColor3"); Library:RegisterThemeObj("Accent", List, "BorderColor3")
                Create("UIListLayout", {Parent=List, SortOrder=Enum.SortOrder.LayoutOrder}); Create("UISizeConstraint", {Parent=List, MaxSize=Vector2.new(9999, 150)})
                local open=false; local function Toggle() open=not open List.Visible=open end Btn.MouseButton1Click:Connect(Toggle)
                local function Set(v) Btn.Text="  "..v if flag then Library.Flags[flag]=v end if cb then cb(v) end open=false List.Visible=false end
                local function Refresh(o) for _,v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end for _,opt in pairs(o) do local b=Create("TextButton", {Parent=List, BackgroundTransparency=1, Size=UDim2.new(1,0,0,25), Text=opt, TextColor3=Library.Theme.DimText, Font=Library.Theme.FontSmall, TextSize=11, ZIndex=21}) b.MouseButton1Click:Connect(function() Set(opt) end) end end
                Refresh(opts) local r={Set=Set, Refresh=Refresh} if flag then Library.Items[flag]=r end return r
            end
            function E:ColorPicker(txt, def, flag, cb)
                local Box = Create("Frame", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,40), ZIndex=5})
                Create("TextLabel", {Parent=Box, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})
                local Preview = Create("TextButton", {Parent=Box, BackgroundColor3=def, Text="", Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,20)})
                Create("UICorner", {Parent=Preview, CornerRadius=UDim.new(0,4)}); Create("UIStroke", {Parent=Preview, Color=Library.Theme.Border})
                local PickFrame = Create("Frame", {Parent=Preview, Visible=false, BackgroundColor3=Library.Theme.Section, Size=UDim2.new(1,0,0,95), Position=UDim2.new(0,0,1,5), ZIndex=10})
                Library:RegisterThemeObj("Section", PickFrame, "BackgroundColor3")
                Create("UIStroke", {Parent=PickFrame, Color=Library.Theme.Border}); Create("UICorner", {Parent=PickFrame, CornerRadius=UDim.new(0,4)})
                local R,G,B = def.R*255, def.G*255, def.B*255
                local function Update() local c=Color3.fromRGB(R,G,B) Preview.BackgroundColor3=c if flag then Library.Flags[flag]=c end if cb then cb(c) end end
                local function MakeS(t,y,val,set)
                    local SBox = Create("Frame", {Parent=PickFrame, BackgroundTransparency=1, Size=UDim2.new(1,-10,0,25), Position=UDim2.new(0,5,0,y), ZIndex=11})
                    Create("TextLabel", {Parent=SBox, Text=t, TextColor3=Library.Theme.DimText, Size=UDim2.new(0,15,1,0), BackgroundTransparency=1, ZIndex=11})
                    local Bar = Create("Frame", {Parent=SBox, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(1,-20,0,5), Position=UDim2.new(0,20,0.5,-2), ZIndex=11})
                    local Fill = Create("Frame", {Parent=Bar, BackgroundColor3=Library.Theme.Accent, Size=UDim2.new(val/255,0,1,0), ZIndex=11}); Library:RegisterThemeObj("Accent", Fill, "BackgroundColor3")
                    local Trig = Create("TextButton", {Parent=Bar, BackgroundTransparency=1, Size=UDim2.new(1,0,1,0), Text="", ZIndex=12})
                    local d=false; local function In(i) local s=math.clamp((i.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1) Fill.Size=UDim2.new(s,0,1,0) set(s*255) Update() end
                    Trig.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=true In(i) end end)
                    UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then In(i) end end)
                    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=false end end)
                end
                MakeS("R", 5, R, function(v) R=v end); MakeS("G", 35, G, function(v) G=v end); MakeS("B", 65, B, function(v) B=v end)
                Preview.MouseButton1Click:Connect(function() PickFrame.Visible = not PickFrame.Visible end)
            end
            
            return E
        end return Funcs
    end return Tabs
end
return Library
