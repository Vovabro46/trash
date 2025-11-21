--[[
    GILA MONSTER LIBRARY [SOURCE v11]
    - Fixed: SubTabs allow instant theme updating (Smart Re-registering)
    - Fixed: SubTabs spacing (Added padding from top)
    - Fixed: ColorPicker visibility
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
    ThemeObjects = {},
    Screen = nil,
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

--// PRESETS
Library.ThemePresets = {
    ["Default"] = { Main = Color3.fromRGB(20, 20, 20), Sidebar = Color3.fromRGB(25, 25, 28), Section = Color3.fromRGB(30, 30, 35), Accent = Color3.fromRGB(120, 110, 225), Text = Color3.fromRGB(255, 255, 255) },
    ["Blood Moon"] = { Main = Color3.fromRGB(20, 15, 15), Sidebar = Color3.fromRGB(25, 20, 20), Section = Color3.fromRGB(30, 25, 25), Accent = Color3.fromRGB(230, 60, 60), Text = Color3.fromRGB(255, 255, 255) },
    ["Oceanic"] = { Main = Color3.fromRGB(15, 20, 25), Sidebar = Color3.fromRGB(20, 25, 30), Section = Color3.fromRGB(25, 30, 35), Accent = Color3.fromRGB(0, 160, 255), Text = Color3.fromRGB(255, 255, 255) },
    ["Midnight"] = { Main = Color3.fromRGB(10, 10, 15), Sidebar = Color3.fromRGB(15, 15, 20), Section = Color3.fromRGB(20, 20, 25), Accent = Color3.fromRGB(80, 80, 255), Text = Color3.fromRGB(255, 255, 255) },
    ["Nature"] = { Main = Color3.fromRGB(20, 25, 20), Sidebar = Color3.fromRGB(25, 30, 25), Section = Color3.fromRGB(30, 35, 30), Accent = Color3.fromRGB(100, 200, 100), Text = Color3.fromRGB(255, 255, 255) },
    ["Void"] = { Main = Color3.fromRGB(5, 5, 5), Sidebar = Color3.fromRGB(10, 10, 10), Section = Color3.fromRGB(15, 15, 15), Accent = Color3.fromRGB(255, 255, 255), Text = Color3.fromRGB(200, 200, 200) }
}

local CfgFolder = "GilaConfigs"
local Icons = { ["menu"]="rbxassetid://6031091000", ["minimize"]="rbxassetid://6031094670", ["x"]="rbxassetid://6031094678", ["arrow_d"]="rbxassetid://6031091304", ["check"]="rbxassetid://6031094667" }

local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

--// THEME SYSTEM
function Library:RegisterThemeObj(type, obj, property)
    if not Library.ThemeObjects[type] then Library.ThemeObjects[type] = {} end
    -- Удаляем старую регистрацию для этого объекта и свойства, если есть (чтобы не дублировать при переключении вкладок)
    for i, item in pairs(Library.ThemeObjects[type]) do
        if item.Object == obj and item.Property == property then
            table.remove(Library.ThemeObjects[type], i)
            break
        end
    end
    table.insert(Library.ThemeObjects[type], {Object = obj, Property = property})
    if Library.Theme[type] then pcall(function() obj[property] = Library.Theme[type] end) end
end

-- Функция для смены типа темы у объекта (например, с DimText на Accent)
function Library:ChangeThemeType(obj, property, newType)
    -- Удаляем из всех списков
    for typeName, list in pairs(Library.ThemeObjects) do
        for i = #list, 1, -1 do
            if list[i].Object == obj and list[i].Property == property then
                table.remove(list, i)
            end
        end
    end
    -- Регистрируем в новом
    Library:RegisterThemeObj(newType, obj, property)
end

function Library:UpdateTheme(type, color)
    Library.Theme[type] = color
    if Library.ThemeObjects[type] then
        for _, item in pairs(Library.ThemeObjects[type]) do
            if item.Object then pcall(function() item.Object[item.Property] = color end) end
        end
    end
end

function Library:SetTheme(name)
    local preset = Library.ThemePresets[name]
    if preset then for k, v in pairs(preset) do Library:UpdateTheme(k, v) end Library:Notify("Theme", "Loaded: "..name, 2) end
end
function Library:GetThemes() local t={} for k in pairs(Library.ThemePresets) do table.insert(t,k) end table.sort(t) return t end

--// MOBILE DRAG
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
            dragging = false; if isButton and not hasMoved and trigger:FindFirstChild("TouchClick") then trigger.TouchClick:Fire() end
        end
    end)
end

--// TOOLTIP
local TooltipGui = Create("ScreenGui", {Parent=CoreGui, DisplayOrder=200, Name="GilaTooltip"})
local TooltipFrame = Create("Frame", {Parent=TooltipGui, BackgroundColor3=Color3.fromRGB(30,30,30), Size=UDim2.new(0,0,0,0), Visible=false, AutomaticSize=Enum.AutomaticSize.XY})
Create("UICorner", {Parent=TooltipFrame, CornerRadius=UDim.new(0,4)}); Create("UIStroke", {Parent=TooltipFrame, Color=Library.Theme.Accent})
local TooltipText = Create("TextLabel", {Parent=TooltipFrame, Text="", TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamMedium, TextSize=11, BackgroundTransparency=1, Size=UDim2.new(0,0,0,0), AutomaticSize=Enum.AutomaticSize.XY})
Create("UIPadding", {Parent=TooltipFrame, PaddingTop=UDim.new(0,5), PaddingBottom=UDim.new(0,5), PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8)})

local function AddTooltip(obj, text)
    if not text then return end
    obj.MouseEnter:Connect(function()
        TooltipText.Text = text; TooltipFrame.Visible = true; TooltipFrame.UIStroke.Color = Library.Theme.Accent
        local m = UserInputService:GetMouseLocation(); TooltipFrame.Position = UDim2.new(0, m.X + 15, 0, m.Y + 15)
    end)
    obj.MouseLeave:Connect(function() TooltipFrame.Visible = false end)
    obj.MouseMoved:Connect(function() local m = UserInputService:GetMouseLocation(); TooltipFrame.Position = UDim2.new(0, m.X + 15, 0, m.Y + 15) end)
end

--// CONFIGS
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
    Create("UICorner", {Parent=Frame, CornerRadius=UDim.new(0,6)}); local S = Create("UIStroke", {Parent=Frame, Color=Library.Theme.Accent, Thickness=1.5, Transparency=0.5}); Library:RegisterThemeObj("Accent", S, "Color")
    local T1 = Create("TextLabel", {Parent=Frame, Text=title:upper(), TextColor3=Library.Theme.Accent, Font=Enum.Font.GothamBlack, TextSize=13, BackgroundTransparency=1, Size=UDim2.new(1,-20,0,20), Position=UDim2.new(0,10,0,5), TextXAlignment=Enum.TextXAlignment.Left}); Library:RegisterThemeObj("Accent", T1, "TextColor3")
    local T2 = Create("TextLabel", {Parent=Frame, Text=desc, TextColor3=Library.Theme.Text, Font=Enum.Font.GothamMedium, TextSize=11, BackgroundTransparency=1, Size=UDim2.new(1,-20,0,0), Position=UDim2.new(0,10,0,25), TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, AutomaticSize=Enum.AutomaticSize.Y}); Library:RegisterThemeObj("Text", T2, "TextColor3")
    Frame:TweenPosition(UDim2.new(0,0,0,0), "Out", "Back", 0.5); task.delay(duration or 4, function() if Frame then Frame:Destroy() end end)
end

--// WINDOW
function Library:Window(opts)
    local TargetParent = RunService:IsStudio() and Players.LocalPlayer.PlayerGui or CoreGui
    if TargetParent:FindFirstChild("GilaFixed") then TargetParent.GilaFixed:Destroy() end
    
    Library.Screen = Create("ScreenGui", {Name = "GilaFixed", Parent = TargetParent, DisplayOrder=50})
    
    local MobToggle = Create("ImageButton", {Parent = Library.Screen, BackgroundColor3 = Library.Theme.Main, Position = UDim2.new(0,50,0,50), Size = UDim2.new(0,45,0,45), Image = Icons.menu, ImageColor3 = Library.Theme.Accent, Active = true, ZIndex = 200})
    Library:RegisterThemeObj("Main", MobToggle, "BackgroundColor3"); Library:RegisterThemeObj("Accent", MobToggle, "ImageColor3")
    Create("UICorner", {Parent=MobToggle, CornerRadius=UDim.new(0,8)}); local MS = Create("UIStroke", {Parent=MobToggle, Color=Library.Theme.Accent, Thickness=2}); Library:RegisterThemeObj("Accent", MS, "Color")
    local TouchClick = Instance.new("BindableEvent", MobToggle); TouchClick.Name = "TouchClick"
    
    local Main = Create("Frame", {Parent = Library.Screen, BackgroundColor3 = Library.Theme.Main, Position = UDim2.new(0.5,-325,0.5,-225), Size = UDim2.new(0,650,0,450), ClipsDescendants = true, ZIndex = 1})
    Library:RegisterThemeObj("Main", Main, "BackgroundColor3"); Create("UICorner", {Parent=Main, CornerRadius=UDim.new(0,6)})
    local MainS = Create("UIStroke", {Parent=Main, Color=Library.Theme.Border, Thickness=1.5}); Library:RegisterThemeObj("Border", MainS, "Color")
    TouchClick.Event:Connect(function() Main.Visible = not Main.Visible end); MakeDraggable(MobToggle, MobToggle, true)
    
    local Top = Create("Frame", {Parent = Main, BackgroundColor3 = Library.Theme.Main, Size = UDim2.new(1,0,0,40), BorderSizePixel = 0, ZIndex=2}); Library:RegisterThemeObj("Main", Top, "BackgroundColor3")
    local Logo1 = Create("TextLabel", {Parent = Top, Text = "GILA", TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamBlack, TextSize = 16, Size = UDim2.new(0,50,1,0), Position = UDim2.new(0,15,0,0), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3}); Library:RegisterThemeObj("Text", Logo1, "TextColor3")
    local Logo2 = Create("TextLabel", {Parent = Top, Text = "MONSTER", TextColor3 = Library.Theme.Accent, Font = Enum.Font.GothamBlack, TextSize = 16, Size = UDim2.new(0,100,1,0), Position = UDim2.new(0,60,0,0), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3}); Library:RegisterThemeObj("Accent", Logo2, "TextColor3")
    MakeDraggable(Top, Main, false)
    
    local Sidebar = Create("Frame", {Parent=Main, BackgroundColor3=Library.Theme.Sidebar, Size=UDim2.new(0,150,1,-41), Position=UDim2.new(0,0,0,41), BorderSizePixel=0, ZIndex=2}); Library:RegisterThemeObj("Sidebar", Sidebar, "BackgroundColor3")
    local Content = Create("Frame", {Parent=Main, BackgroundTransparency=1, Size=UDim2.new(1,-160,1,-51), Position=UDim2.new(0,160,0,51), ZIndex=2})
    local SidebarList = Create("ScrollingFrame", {Parent=Sidebar, BackgroundTransparency=1, Size=UDim2.new(1,0,1,-10), Position=UDim2.new(0,0,0,10), ScrollBarThickness=0, ZIndex=3})
    Create("UIListLayout", {Parent=SidebarList, SortOrder=Enum.SortOrder.LayoutOrder})

    local Tabs = {}
    local firstTab = true

    function Tabs:Tab(name)
        local TBtn = Create("TextButton", {Parent = SidebarList, Size = UDim2.new(1,0,0,36), BackgroundTransparency=1, Text = "    "..name:upper(), TextColor3 = Library.Theme.DimText, Font = Library.Theme.FontMain, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor=false, ZIndex=4})
        Library:RegisterThemeObj("DimText", TBtn, "TextColor3") -- Default inactive
        
        local Ind = Create("Frame", {Parent=TBtn, BackgroundColor3=Library.Theme.Accent, Size=UDim2.new(0,2,0,18), Position=UDim2.new(0,0,0.5,-9), Visible=false, ZIndex=5}); Library:RegisterThemeObj("Accent", Ind, "BackgroundColor3")
        local Page = Create("Frame", {Parent=Content, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Visible=false, ZIndex=3})
        
        -- SUBTABS CONTAINER (Moved Down slightly, Added Padding)
        local SubTabBox = Create("ScrollingFrame", {Parent=Page, Size=UDim2.new(1,0,0,32), Position=UDim2.new(0,0,0,10), BackgroundTransparency=1, CanvasSize=UDim2.new(0,0,0,0), ScrollBarThickness=0, ZIndex=5})
        Create("UIListLayout", {Parent=SubTabBox, FillDirection=Enum.FillDirection.Horizontal, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,8)}); Create("UIPadding", {Parent=SubTabBox, PaddingLeft=UDim.new(0,10)})
        local SubContent = Create("Frame", {Parent=Page, Size=UDim2.new(1,0,1,-45), Position=UDim2.new(0,0,0,45), BackgroundTransparency=1, ZIndex=4})
        
        local function ShowTab()
            for _, v in pairs(SidebarList:GetChildren()) do 
                if v:IsA("TextButton") then 
                    Library:ChangeThemeType(v, "TextColor3", "DimText") -- Deactivate others
                    v.Frame.Visible=false 
                end 
            end
            for _, v in pairs(Content:GetChildren()) do v.Visible=false end
            Library:ChangeThemeType(TBtn, "TextColor3", "Text") -- Activate current
            Ind.Visible=true Page.Visible=true
        end
        TBtn.MouseButton1Click:Connect(ShowTab)
        if firstTab then firstTab=false ShowTab() end

        local SubTabs = {}
        local firstSub = true

        function SubTabs:SubTab(subName)
            local SBtn = Create("TextButton", {Parent=SubTabBox, BackgroundColor3=Library.Theme.Section, Size=UDim2.new(0,0,1,0), AutomaticSize=Enum.AutomaticSize.X, Text="  "..subName.."  ", TextColor3=Library.Theme.DimText, Font=Library.Theme.FontSmall, TextSize=11, ZIndex=6})
            Library:RegisterThemeObj("Section", SBtn, "BackgroundColor3")
            Library:RegisterThemeObj("DimText", SBtn, "TextColor3") -- Register as inactive initially
            Create("UICorner", {Parent=SBtn, CornerRadius=UDim.new(0,4)})
            
            local SPage = Create("Frame", {Parent=SubContent, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Visible=false, ZIndex=4})
            local Left = Create("ScrollingFrame", {Parent=SPage, Size=UDim2.new(0.48,0,1,0), BackgroundTransparency=1, ScrollBarThickness=0, AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(0,0,0,0), ZIndex=4})
            local Right = Create("ScrollingFrame", {Parent=SPage, Size=UDim2.new(0.48,0,1,0), Position=UDim2.new(0.52,0,0,0), BackgroundTransparency=1, ScrollBarThickness=0, AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(0,0,0,0), ZIndex=4})
            Create("UIListLayout", {Parent=Left, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,12)}); Create("UIListLayout", {Parent=Right, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,12)})
            
            local function ShowSub()
                for _, v in pairs(SubTabBox:GetChildren()) do 
                    if v:IsA("TextButton") then 
                        -- Re-register all as DimText
                        Library:ChangeThemeType(v, "TextColor3", "DimText")
                    end 
                end
                for _, v in pairs(SubContent:GetChildren()) do v.Visible=false end
                
                -- Re-register Active as Accent
                Library:ChangeThemeType(SBtn, "TextColor3", "Accent")
                SPage.Visible=true
            end
            SBtn.MouseButton1Click:Connect(ShowSub)
            if firstSub then firstSub=false ShowSub() end

            local Funcs = {}
            function Funcs:Section(title, side)
                local P = (side=="Right") and Right or Left
                local Sec = Create("Frame", {Parent=P, BackgroundColor3=Library.Theme.Section, Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y, ZIndex=5})
                Library:RegisterThemeObj("Section", Sec, "BackgroundColor3"); Create("UICorner", {Parent=Sec, CornerRadius=UDim.new(0,4)})
                local H = Create("Frame", {Parent=Sec, BackgroundTransparency=1, Size=UDim2.new(1,0,0,30), ZIndex=6})
                local HTxt = Create("TextLabel", {Parent=H, Text=title:upper(), TextColor3=Library.Theme.Accent, Font=Library.Theme.FontMain, TextSize=11, BackgroundTransparency=1, Size=UDim2.new(1,-10,1,0), Position=UDim2.new(0,10,0,0), TextXAlignment=Enum.TextXAlignment.Left, ZIndex=7}); Library:RegisterThemeObj("Accent", HTxt, "TextColor3")
                local Items = Create("Frame", {Parent=Sec, BackgroundTransparency=1, Position=UDim2.new(0,8,0,35), Size=UDim2.new(1,-16,0,0), AutomaticSize=Enum.AutomaticSize.Y, ZIndex=6})
                Create("UIListLayout", {Parent=Items, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,6)}); Create("UIPadding", {Parent=Items, PaddingBottom=UDim.new(0,10)})

                local E = {}
                function E:Label(t, tip)
                    local L = Create("TextLabel", {Parent=Items, Text=t, TextColor3=Library.Theme.DimText, Font=Library.Theme.FontSmall, TextSize=12, BackgroundTransparency=1, Size=UDim2.new(1,0,0,18), TextXAlignment=Enum.TextXAlignment.Left, ZIndex=7})
                    if tip then AddTooltip(L, tip) end return L
                end
                function E:Paragraph(h, d)
                   local Box = Create("Frame", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y, ZIndex=7})
                   Create("TextLabel", {Parent=Box, Text=h, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=8}); Library:RegisterThemeObj("Text", Box.TextLabel, "TextColor3")
                   Create("TextLabel", {Parent=Box, Text=d, TextColor3=Library.Theme.DimText, Font=Library.Theme.FontSmall, TextSize=11, Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, AutomaticSize=Enum.AutomaticSize.Y, ZIndex=8})
                   Create("UIPadding", {Parent=Box, PaddingBottom=UDim.new(0,5)}); return Box
                end
                function E:Button(t, cb, tip)
                    local Btn = Create("TextButton", {Parent=Items, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(1,0,0,25), Text=t, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=11, ZIndex=7})
                    Library:RegisterThemeObj("Main", Btn, "BackgroundColor3"); Library:RegisterThemeObj("Text", Btn, "TextColor3")
                    Create("UICorner", {Parent=Btn, CornerRadius=UDim.new(0,4)}); local S = Create("UIStroke", {Parent=Btn, Color=Library.Theme.Border}); Library:RegisterThemeObj("Border", S, "Color")
                    Btn.MouseButton1Click:Connect(cb); if tip then AddTooltip(Btn, tip) end return Btn
                end
                function E:Toggle(txt, def, flag, cb, tip)
                    local TogBtn = Create("TextButton", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,20), Text="", ZIndex=7})
                    local T = Create("TextLabel", {Parent=TogBtn, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, BackgroundTransparency=1, Size=UDim2.new(1,-25,1,0), TextXAlignment=Enum.TextXAlignment.Left, ZIndex=8}); Library:RegisterThemeObj("Text", T, "TextColor3")
                    local Box = Create("Frame", {Parent=TogBtn, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(0,14,0,14), Position=UDim2.new(1,-14,0.5,-7), ZIndex=8}); Create("UICorner", {Parent=Box, CornerRadius=UDim.new(0,3)}); Library:RegisterThemeObj("Main", Box, "BackgroundColor3"); local S = Create("UIStroke", {Parent=Box, Color=Library.Theme.Border}); Library:RegisterThemeObj("Border", S, "Color")
                    local Fill = Create("Frame", {Parent=Box, BackgroundColor3=Library.Theme.Accent, Size=UDim2.new(1,-2,1,-2), Position=UDim2.new(0,1,0,1), Visible=def or false, ZIndex=9}); Library:RegisterThemeObj("Accent", Fill, "BackgroundColor3"); Create("UICorner", {Parent=Fill, CornerRadius=UDim.new(0,2)})
                    local state=def; local function Set(v) state=v Fill.Visible=v if flag then Library.Flags[flag]=v end if cb then cb(v) end end
                    TogBtn.MouseButton1Click:Connect(function() Set(not state) end)
                    local r={Set=Set} if flag then Library.Items[flag]=r end if tip then AddTooltip(TogBtn, tip) end return r
                end
                function E:Checkbox(txt, def, flag, cb, tip) return E:Toggle(txt, def, flag, cb, tip) end
                function E:Slider(txt, min, max, def, flag, cb, tip)
                    local Box = Create("Frame", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,35), ZIndex=7})
                    local T = Create("TextLabel", {Parent=Box, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=8}); Library:RegisterThemeObj("Text", T, "TextColor3")
                    local Val = Create("TextLabel", {Parent=Box, Text=tostring(def), TextColor3=Library.Theme.Accent, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right, ZIndex=8}); Library:RegisterThemeObj("Accent", Val, "TextColor3")
                    local Bar = Create("Frame", {Parent=Box, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(1,0,0,5), Position=UDim2.new(0,0,0,22), ZIndex=8}); Library:RegisterThemeObj("Main", Bar, "BackgroundColor3"); Create("UICorner", {Parent=Bar, CornerRadius=UDim.new(0,2)})
                    local Fill = Create("Frame", {Parent=Bar, BackgroundColor3=Library.Theme.Accent, Size=UDim2.new((def-min)/(max-min),0,1,0), ZIndex=9}); Library:RegisterThemeObj("Accent", Fill, "BackgroundColor3"); Create("UICorner", {Parent=Fill, CornerRadius=UDim.new(0,2)})
                    local Trigger = Create("TextButton", {Parent=Bar, BackgroundTransparency=1, Size=UDim2.new(1,0,1,0), Text="", ZIndex=10})
                    local function Set(v) v=math.clamp(v,min,max) Fill.Size=UDim2.new((v-min)/(max-min),0,1,0) Val.Text=tostring(v) if flag then Library.Flags[flag]=v end if cb then cb(v) end end
                    local d=false; Trigger.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=true Set(math.floor(min+((max-min)*math.clamp((i.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1)))) end end)
                    UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then Set(math.floor(min+((max-min)*math.clamp((i.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1)))) end end)
                    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=false end end)
                    local r={Set=Set} if flag then Library.Items[flag]=r end if tip then AddTooltip(Box, tip) end return r
                end
                function E:TextBox(txt, ph, flag, cb, tip)
                    local Box = Create("Frame", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,40), ZIndex=7})
                    local T = Create("TextLabel", {Parent=Box, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=8}); Library:RegisterThemeObj("Text", T, "TextColor3")
                    local Input = Create("TextBox", {Parent=Box, BackgroundColor3=Library.Theme.Main, TextColor3=Library.Theme.Text, PlaceholderText=ph, Text="", Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,20), Font=Library.Theme.FontSmall, TextSize=11, ZIndex=8}); Library:RegisterThemeObj("Main", Input, "BackgroundColor3"); Library:RegisterThemeObj("Text", Input, "TextColor3")
                    Create("UICorner", {Parent=Input, CornerRadius=UDim.new(0,4)}); local S = Create("UIStroke", {Parent=Input, Color=Library.Theme.Border}); Library:RegisterThemeObj("Border", S, "Color")
                    Input.FocusLost:Connect(function() if flag then Library.Flags[flag]=Input.Text end if cb then cb(Input.Text) end end)
                    if tip then AddTooltip(Box, tip) end
                end
                function E:Keybind(txt, def, flag, cb, tip)
                    local Row = Create("Frame", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,20), ZIndex=7})
                    Create("TextLabel", {Parent=Row, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,-60,1,0), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=8}); Library:RegisterThemeObj("Text", Row.TextLabel, "TextColor3")
                    local BindBtn = Create("TextButton", {Parent=Row, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(0,55,0,18), Position=UDim2.new(1,-55,0,1), Text=tostring(def):gsub("Enum.KeyCode.", ""), TextColor3=Library.Theme.Accent, Font=Library.Theme.FontSmall, TextSize=10, ZIndex=8})
                    Library:RegisterThemeObj("Main", BindBtn, "BackgroundColor3"); Library:RegisterThemeObj("Accent", BindBtn, "TextColor3"); Create("UICorner", {Parent=BindBtn, CornerRadius=UDim.new(0,4)}); local S = Create("UIStroke", {Parent=BindBtn, Color=Library.Theme.Border}); Library:RegisterThemeObj("Border", S, "Color")
                    local key=def; local w=false
                    BindBtn.MouseButton1Click:Connect(function() w=true BindBtn.Text="..." end)
                    UserInputService.InputBegan:Connect(function(i) if w and i.KeyCode~=Enum.KeyCode.Unknown then key=i.KeyCode w=false BindBtn.Text=tostring(key):gsub("Enum.KeyCode.", "") if flag then Library.Flags[flag]=key end if cb then cb(key) end elseif i.KeyCode==key and cb then cb(key) end end)
                    if tip then AddTooltip(Row, tip) end
                end
                function E:Dropdown(txt, opts, def, flag, cb, tip)
                    local Main = Create("Frame", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,40), ZIndex=7})
                    local T = Create("TextLabel", {Parent=Main, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=8}); Library:RegisterThemeObj("Text", T, "TextColor3")
                    local Btn = Create("TextButton", {Parent=Main, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,20), Text="  "..(def or "..."), TextXAlignment=Enum.TextXAlignment.Left, TextColor3=Library.Theme.DimText, Font=Library.Theme.FontSmall, TextSize=11, ZIndex=8})
                    Library:RegisterThemeObj("Main", Btn, "BackgroundColor3"); local S = Create("UIStroke", {Parent=Btn, Color=Library.Theme.Border}); Library:RegisterThemeObj("Border", S, "Color")
                    Create("ImageLabel", {Parent=Btn, BackgroundTransparency=1, Image=Icons.arrow_d, ImageColor3=Library.Theme.DimText, Size=UDim2.new(0,16,0,16), Position=UDim2.new(1,-20,0,2), ZIndex=9})
                    local List = Create("ScrollingFrame", {Parent=Btn, Visible=false, Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,1,2), BackgroundColor3=Library.Theme.Section, BorderColor3=Library.Theme.Accent, ZIndex=100, ScrollBarThickness=2, AutomaticSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(0,0,0,0)}); Library:RegisterThemeObj("Section", List, "BackgroundColor3"); Library:RegisterThemeObj("Accent", List, "BorderColor3")
                    Create("UIListLayout", {Parent=List, SortOrder=Enum.SortOrder.LayoutOrder}); Create("UISizeConstraint", {Parent=List, MaxSize=Vector2.new(9999, 150)})
                    local open=false; Btn.MouseButton1Click:Connect(function() open=not open List.Visible=open end)
                    local function Set(v) Btn.Text="  "..v if flag then Library.Flags[flag]=v end if cb then cb(v) end open=false List.Visible=false end
                    for _,opt in pairs(opts) do local b=Create("TextButton", {Parent=List, BackgroundTransparency=1, Size=UDim2.new(1,0,0,25), Text=opt, TextColor3=Library.Theme.DimText, Font=Library.Theme.FontSmall, TextSize=11, ZIndex=101}); b.MouseButton1Click:Connect(function() Set(opt) end) end
                    if tip then AddTooltip(Main, tip) end
                end
                function E:MultiDropdown(txt, opts, flag, cb, tip)
                    local Main = Create("Frame", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,40), ZIndex=7})
                    local T = Create("TextLabel", {Parent=Main, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=8}); Library:RegisterThemeObj("Text", T, "TextColor3")
                    local Btn = Create("TextButton", {Parent=Main, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,20), Text="  ...", TextXAlignment=Enum.TextXAlignment.Left, TextColor3=Library.Theme.DimText, Font=Library.Theme.FontSmall, TextSize=11, ZIndex=8})
                    Library:RegisterThemeObj("Main", Btn, "BackgroundColor3"); local S = Create("UIStroke", {Parent=Btn, Color=Library.Theme.Border}); Library:RegisterThemeObj("Border", S, "Color")
                    Create("ImageLabel", {Parent=Btn, BackgroundTransparency=1, Image=Icons.arrow_d, ImageColor3=Library.Theme.DimText, Size=UDim2.new(0,16,0,16), Position=UDim2.new(1,-20,0,2), ZIndex=9})
                    local List = Create("ScrollingFrame", {Parent=Btn, Visible=false, Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,1,2), BackgroundColor3=Library.Theme.Section, BorderColor3=Library.Theme.Accent, ZIndex=100, ScrollBarThickness=2, AutomaticSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(0,0,0,0)}); Library:RegisterThemeObj("Section", List, "BackgroundColor3"); Library:RegisterThemeObj("Accent", List, "BorderColor3")
                    Create("UIListLayout", {Parent=List, SortOrder=Enum.SortOrder.LayoutOrder}); Create("UISizeConstraint", {Parent=List, MaxSize=Vector2.new(9999, 150)})
                    local open=false; Btn.MouseButton1Click:Connect(function() open=not open List.Visible=open end)
                    local sel={}
                    for _,opt in pairs(opts) do
                        local b=Create("TextButton", {Parent=List, BackgroundTransparency=1, Size=UDim2.new(1,0,0,25), Text="  "..opt, TextXAlignment=Enum.TextXAlignment.Left, TextColor3=Library.Theme.DimText, Font=Library.Theme.FontSmall, TextSize=11, ZIndex=101})
                        local tick=Create("ImageLabel", {Parent=b, Image=Icons.check, ImageColor3=Library.Theme.Accent, Size=UDim2.new(0,14,0,14), Position=UDim2.new(1,-20,0,5), Visible=false, BackgroundTransparency=1, ZIndex=102}); Library:RegisterThemeObj("Accent", tick, "ImageColor3")
                        b.MouseButton1Click:Connect(function()
                            if sel[opt] then sel[opt]=nil tick.Visible=false else sel[opt]=true tick.Visible=true end
                            local str="" for k in pairs(sel) do str=str..k..", " end Btn.Text="  "..(str=="" and "..." or str:sub(1,-3))
                            if flag then Library.Flags[flag]=sel end if cb then cb(sel) end
                        end)
                    end
                    if tip then AddTooltip(Main, tip) end
                end
                function E:ColorPicker(txt, def, flag, cb, tip)
                    local Box = Create("Frame", {Parent=Items, BackgroundTransparency=1, Size=UDim2.new(1,0,0,40), ZIndex=7})
                    local T = Create("TextLabel", {Parent=Box, Text=txt, TextColor3=Library.Theme.Text, Font=Library.Theme.FontSmall, TextSize=12, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=8}); Library:RegisterThemeObj("Text", T, "TextColor3")
                    local Preview = Create("TextButton", {Parent=Box, BackgroundColor3=def, Text="", Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,20), ZIndex=8})
                    Create("UICorner", {Parent=Preview, CornerRadius=UDim.new(0,4)}); local S = Create("UIStroke", {Parent=Preview, Color=Library.Theme.Border}); Library:RegisterThemeObj("Border", S, "Color")
                    -- FIX: Parent to Screen so it floats above everything
                    local PickFrame = Create("Frame", {Parent=Library.Screen, Visible=false, BackgroundColor3=Library.Theme.Section, Size=UDim2.new(0,200,0,95), Position=UDim2.new(0,0,0,0), ZIndex=1000})
                    Library:RegisterThemeObj("Section", PickFrame, "BackgroundColor3"); local S2 = Create("UIStroke", {Parent=PickFrame, Color=Library.Theme.Border}); Library:RegisterThemeObj("Border", S2, "Color"); Create("UICorner", {Parent=PickFrame, CornerRadius=UDim.new(0,4)})
                    
                    local R,G,B = def.R*255, def.G*255, def.B*255
                    local function Update() local c=Color3.fromRGB(R,G,B) Preview.BackgroundColor3=c if flag then Library.Flags[flag]=c end if cb then cb(c) end end
                    
                    local function MakeS(t,y,val,set)
                        local SBox = Create("Frame", {Parent=PickFrame, BackgroundTransparency=1, Size=UDim2.new(1,-10,0,25), Position=UDim2.new(0,5,0,y), ZIndex=1001})
                        Create("TextLabel", {Parent=SBox, Text=t, TextColor3=Library.Theme.DimText, Size=UDim2.new(0,15,1,0), BackgroundTransparency=1, ZIndex=1002})
                        local Bar = Create("Frame", {Parent=SBox, BackgroundColor3=Library.Theme.Main, Size=UDim2.new(1,-20,0,5), Position=UDim2.new(0,20,0.5,-2), ZIndex=1002}); Library:RegisterThemeObj("Main", Bar, "BackgroundColor3")
                        local Fill = Create("Frame", {Parent=Bar, BackgroundColor3=Library.Theme.Accent, Size=UDim2.new(val/255,0,1,0), ZIndex=1003}); Library:RegisterThemeObj("Accent", Fill, "BackgroundColor3")
                        local Trig = Create("TextButton", {Parent=Bar, BackgroundTransparency=1, Size=UDim2.new(1,0,1,0), Text="", ZIndex=1004})
                        local d=false; local function In(i) local s=math.clamp((i.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1) Fill.Size=UDim2.new(s,0,1,0) set(s*255) Update() end
                        Trig.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=true In(i) end end)
                        UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then In(i) end end)
                        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=false end end)
                    end
                    MakeS("R", 5, R, function(v) R=v end); MakeS("G", 35, G, function(v) G=v end); MakeS("B", 65, B, function(v) B=v end)
                    
                    Preview.MouseButton1Click:Connect(function() 
                        PickFrame.Visible = not PickFrame.Visible
                        -- Auto-update position
                        if PickFrame.Visible then
                            RunService:BindToRenderStep("PickerPos"..txt, 1, function()
                                PickFrame.Position = UDim2.new(0, Preview.AbsolutePosition.X, 0, Preview.AbsolutePosition.Y + 25)
                            end)
                        else
                            RunService:UnbindFromRenderStep("PickerPos"..txt)
                        end
                    end)
                    if tip then AddTooltip(Box, tip) end
                end
                return E
            end return Funcs
        end return SubTabs
    end return Tabs
end
return Library
