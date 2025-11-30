--[[ 
    ETERNESUS LIBRARY - RELEASE BUILD
    [+] Loadstring Compatible (return Library)
    [+] Clean Sidebar (No Ripple)
    [+] Fixed Dropdowns (Close Button, Search, Multi)
    [+] Fixed Color Picker (Rainbow Strip)
    [+] Mobile Support (Draggable Toggle)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // LIBRARY ROOT //
local Library = {
    Flags = {},
    Signals = {},
    Config = {
        Name = "Eternesus",
        Size = UDim2.new(0, 750, 0, 520),
        MobileScale = 0.9,
        Keybind = Enum.KeyCode.Insert,
        Font = Enum.Font.GothamBold,
        FontContent = Enum.Font.GothamMedium,
        AnimSpeed = 0.22,
        Easing = Enum.EasingStyle.Quart
    },
    Theme = {
        Main = Color3.fromRGB(12, 12, 14),
        Sidebar = Color3.fromRGB(15, 15, 17),
        Section = Color3.fromRGB(20, 20, 22),
        Stroke = Color3.fromRGB(35, 35, 38),
        Text = Color3.fromRGB(240, 240, 240),
        TextDim = Color3.fromRGB(120, 120, 120),
        Accent = Color3.fromRGB(0, 255, 60), -- Neon Green
        Dropdown = Color3.fromRGB(25, 25, 27),
        Hover = Color3.fromRGB(32, 32, 34),
        ToggleOff = Color3.fromRGB(45, 45, 48)
    }
}

-- // UTILITIES //
local Utility = {}

function Utility:Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

function Utility:Round(p, r)
    return Utility:Create("UICorner", {CornerRadius = UDim.new(0, r), Parent = p})
end

function Utility:Stroke(p, c, t)
    return Utility:Create("UIStroke", {Color = c or Library.Theme.Stroke, Thickness = t or 1, Parent = p})
end

function Utility:Tween(obj, props, time, style, dir)
    TweenService:Create(obj, TweenInfo.new(time or Library.Config.AnimSpeed, style or Library.Config.Easing, dir or Enum.EasingDirection.Out), props):Play()
end

function Utility:Ripple(btn)
    task.spawn(function()
        local ripple = Utility:Create("ImageLabel", {
            BackgroundTransparency = 1, Image = "rbxassetid://2708891598", ImageColor3 = Color3.new(1,1,1), ImageTransparency = 0.8, ScaleType = Enum.ScaleType.Fit, Parent = btn, ZIndex = 9
        })
        local x, y = Mouse.X - btn.AbsolutePosition.X, Mouse.Y - btn.AbsolutePosition.Y
        ripple.Position = UDim2.new(0, x, 0, y)
        local size = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 1.5
        local t = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(ripple, t, {Size = UDim2.new(0, size, 0, size), Position = UDim2.new(0, x - size/2, 0, y - size/2), ImageTransparency = 1}):Play()
        task.wait(0.5)
        ripple:Destroy()
    end)
end

-- // ICON REGISTRY //
local Icons = {
    ["Aimbot"] = "rbxassetid://3926305904",
    ["Visuals"] = "rbxassetid://3926305904",
    ["Skins"] = "rbxassetid://3926307971",
    ["Settings"] = "rbxassetid://3926307971",
    ["Search"] = "rbxassetid://3926305904",
    ["Close"] = "rbxassetid://3926305904",
    ["Down"] = "rbxassetid://6034818379"
}

local function GetIcon(id)
    if Icons[id] then return Icons[id] end
    if tostring(id):match("rbxassetid") then return id end
    return ""
end

-- // UI CORE //
local ScreenGui = Utility:Create("ScreenGui", {
    Name = Library.Config.Name,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
    Parent = LocalPlayer:WaitForChild("PlayerGui")
})

local GlobalLayer = Utility:Create("Frame", {
    Name = "GlobalLayer",
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    ZIndex = 5000,
    Parent = ScreenGui
})

-- Cleanup
for _, c in pairs(LocalPlayer.PlayerGui:GetChildren()) do
    if c.Name == Library.Config.Name and c ~= ScreenGui then c:Destroy() end
end

-- // WINDOW GENERATION //
function Library:Window(options)
    local Window = {}
    local WinName = options.Name or "Eternesus"
    
    local MainFrame = Utility:Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Library.Theme.Main,
        Position = UDim2.new(0.5, -375, 0.5, -260),
        Size = Library.Config.Size,
        Parent = ScreenGui
    })
    
    if UserInputService.TouchEnabled then
        local s = Library.Config.MobileScale
        MainFrame.Size = UDim2.new(0, 750 * s, 0, 520 * s)
        MainFrame.Position = UDim2.new(0.5, -(375 * s), 0.5, -(260 * s))
    end
    
    Utility:Round(MainFrame, 6)
    Utility:Stroke(MainFrame, Color3.new(0,0,0), 2)
    
    -- Dragging
    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Utility:Tween(MainFrame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)

    -- Sidebar
    local Sidebar = Utility:Create("Frame", {BackgroundColor3 = Library.Theme.Sidebar, Size = UDim2.new(0, 180, 1, 0), Parent = MainFrame}); Utility:Round(Sidebar, 6)
    Utility:Create("Frame", {BackgroundColor3 = Library.Theme.Sidebar, BorderSizePixel = 0, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0), Parent = Sidebar})

    Utility:Create("TextLabel", {
        Text = WinName, Font = Enum.Font.GothamBlack, TextSize = 22, TextColor3 = Library.Theme.Accent, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 70), Parent = Sidebar
    })

    local TabHolder = Utility:Create("Frame", {BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 80), Size = UDim2.new(1, 0, 1, -80), Parent = Sidebar})
    Utility:Create("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabHolder})

    local TabInd = Utility:Create("Frame", {BackgroundColor3 = Library.Theme.Accent, Size = UDim2.new(0, 3, 0, 24), Position = UDim2.new(1, -3, 0, 0), Parent = Sidebar})

    local Content = Utility:Create("Frame", {BackgroundTransparency = 1, Position = UDim2.new(0, 190, 0, 10), Size = UDim2.new(1, -200, 1, -20), Parent = MainFrame})

    -- Mobile Toggle
    local MobToggle = Utility:Create("TextButton", {Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 30, 0.5, -25), BackgroundColor3 = Library.Theme.Sidebar, Text = "", Parent = ScreenGui})
    Utility:Round(MobToggle, 16); Utility:Stroke(MobToggle, Library.Theme.Accent)
    Utility:Create("ImageLabel", {Image = GetIcon("Aimbot"), ImageColor3 = Library.Theme.Accent, BackgroundTransparency = 1, Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0.5, -14, 0.5, -14), Parent = MobToggle})
    
    local tDragging, tStart, tPos
    MobToggle.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then tDragging=true; tStart=i.Position; tPos=MobToggle.Position end end)
    UserInputService.InputChanged:Connect(function(i) if tDragging and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then local d=i.Position-tStart; MobToggle.Position=UDim2.new(tPos.X.Scale, tPos.X.Offset+d.X, tPos.Y.Scale, tPos.Y.Offset+d.Y) end end)
    UserInputService.InputEnded:Connect(function() tDragging=false end)
    MobToggle.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    local Tabs = {}

    function Window:AddTab(options)
        local Name = options.Name or "Tab"
        local Icon = options.Icon or ""
        
        local TabBtn = Utility:Create("TextButton", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 42), Text = "", Parent = TabHolder})
        local Ico = Utility:Create("ImageLabel", {Image = GetIcon(Icon), ImageColor3 = Library.Theme.TextDim, BackgroundTransparency = 1, Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 20, 0.5, -9), Parent = TabBtn})
        local Tit = Utility:Create("TextLabel", {Text = Name, TextColor3 = Library.Theme.TextDim, Font = Library.Config.Font, TextSize = 14, BackgroundTransparency = 1, Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 50, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = TabBtn})
        local Page = Utility:Create("Frame", {Visible = false, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = Content})

        table.insert(Tabs, {Btn = TabBtn, Page = Page, Tit = Tit, Ico = Ico})

        TabBtn.MouseButton1Click:Connect(function()
            -- Clean switch, no ripple on tabs
            for _, t in pairs(Tabs) do Utility:Tween(t.Tit, {TextColor3 = Library.Theme.TextDim}); Utility:Tween(t.Ico, {ImageColor3 = Library.Theme.TextDim}); t.Page.Visible = false end
            Utility:Tween(Tit, {TextColor3 = Color3.new(1, 1, 1)})
            Utility:Tween(Ico, {ImageColor3 = Library.Theme.Accent})
            Page.Visible = true
            local y = TabBtn.AbsolutePosition.Y - Sidebar.AbsolutePosition.Y + (TabBtn.AbsoluteSize.Y/2) - (TabInd.Size.Y.Offset/2)
            Utility:Tween(TabInd, {Position = UDim2.new(1, -3, 0, y)}, 0.3, Enum.EasingStyle.Back)
        end)
        
        if #Tabs == 1 then Tit.TextColor3 = Color3.new(1, 1, 1); Ico.ImageColor3 = Library.Theme.Accent; Page.Visible = true; TabInd.Position = UDim2.new(1, -3, 0, 80 + 9) end

        -- // SUBTABS //
        local SubHolder = Utility:Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 35), Parent = Page})
        local BtnContainer = Utility:Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = SubHolder})
        local SubList = Utility:Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 15), VerticalAlignment = Enum.VerticalAlignment.Center, Parent = BtnContainer})
        local SubLine = Utility:Create("Frame", {BackgroundColor = BrickColor.new(Library.Theme.Accent), BackgroundColor3 = Library.Theme.Accent, Size = UDim2.new(0, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), Parent = SubHolder})
        local SectHolder = Utility:Create("Frame", {BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 45), Size = UDim2.new(1, 0, 1, -45), Parent = Page})

        local SubTabs = {}
        local TabFuncs = {}

        function TabFuncs:AddSubTab(sName)
            local SBtn = Utility:Create("TextButton", {Text = sName, Font = Library.Config.Font, TextSize = 12, TextColor3 = Library.Theme.TextDim, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), Parent = BtnContainer})
            local SCont = Utility:Create("Frame", {Visible = false, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = SectHolder})
            local Col1 = Utility:Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(0.48, 0, 1, 0), Parent = SCont}); Utility:Create("UIListLayout", {Padding = UDim.new(0, 10), Parent = Col1})
            local Col2 = Utility:Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.52, 0, 0, 0), Parent = SCont}); Utility:Create("UIListLayout", {Padding = UDim.new(0, 10), Parent = Col2})
            
            table.insert(SubTabs, {Btn = SBtn, Cont = SCont})
            
            SBtn.MouseButton1Click:Connect(function()
                for _, s in pairs(SubTabs) do Utility:Tween(s.Btn, {TextColor3 = Library.Theme.TextDim}); s.Cont.Visible = false end
                Utility:Tween(SBtn, {TextColor3 = Library.Theme.Accent}); SCont.Visible = true
                local x = SBtn.AbsolutePosition.X - SubHolder.AbsolutePosition.X
                Utility:Tween(SubLine, {Size = UDim2.new(0, SBtn.AbsoluteSize.X, 0, 2), Position = UDim2.new(0, x, 1, -2)})
            end)
            
            if #SubTabs == 1 then SBtn.TextColor3 = Library.Theme.Accent; SCont.Visible = true; task.delay(0.05, function() local x = SBtn.AbsolutePosition.X - SubHolder.AbsolutePosition.X; SubLine.Size = UDim2.new(0, SBtn.AbsoluteSize.X, 0, 2); SubLine.Position = UDim2.new(0, x, 1, -2) end) end

            local SectFuncs = {}
            function SectFuncs:AddSection(options)
                local Title = options.Name or "Section"
                local Side = options.Side or "Left"
                local Target = (Side == "Right") and Col2 or Col1
                local Sect = Utility:Create("Frame", {BackgroundColor3 = Library.Theme.Section, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0), Parent = Target}); Utility:Round(Sect, 4)
                Utility:Create("TextLabel", {Text = string.upper(Title), Font = Library.Config.Font, TextSize = 11, TextColor3 = Library.Theme.Accent, BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 2), TextXAlignment = Enum.TextXAlignment.Left, Parent = Sect})
                local Items = Utility:Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 0), Position = UDim2.new(0, 10, 0, 28), AutomaticSize = Enum.AutomaticSize.Y, Parent = Sect})
                Utility:Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = Items}); Utility:Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 5), LayoutOrder = 999, Parent = Items})

                local Widgets = {}

                function Widgets:AddLabel(text) Utility:Create("TextLabel", {Text = text, Font = Library.Config.FontContent, TextSize = 13, TextColor3 = Library.Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), TextXAlignment = Enum.TextXAlignment.Left, Parent = Items}) end
                function Widgets:AddParagraph(text) Utility:Create("TextLabel", {Text = text, Font = Library.Config.FontContent, TextSize = 12, TextColor3 = Library.Theme.TextDim, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = Items}) end

                function Widgets:AddToggle(opt)
                    local text, def, flag, cb = opt.Name, opt.Default, opt.Flag, opt.Callback
                    local F = Utility:Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), Parent = Items})
                    Utility:Create("TextLabel", {Text = text, Font = Library.Config.FontContent, TextSize = 13, TextColor3 = Library.Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(0.8, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = F})
                    local B = Utility:Create("TextButton", {Text = "", AutoButtonColor = false, BackgroundColor3 = def and Library.Theme.Accent or Library.Theme.ToggleOff, Size = UDim2.new(0, 42, 0, 22), Position = UDim2.new(1, -42, 0.5, -11), Parent = F}); Utility:Round(B, 12)
                    local K = Utility:Create("Frame", {BackgroundColor3 = Color3.new(1, 1, 1), Size = UDim2.new(0, 18, 0, 18), Position = def and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9), Parent = B}); Utility:Round(K, 9)
                    if flag then Library.Flags[flag] = def end
                    B.MouseButton1Click:Connect(function()
                        def = not def
                        Utility:Tween(B, {BackgroundColor3 = def and Library.Theme.Accent or Library.Theme.ToggleOff})
                        Utility:Tween(K, {Position = def and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}, 0.3, Enum.EasingStyle.Back)
                        if flag then Library.Flags[flag] = def end
                        if cb then cb(def) end
                    end)
                end

                function Widgets:AddSlider(opt)
                    local text, min, max, def, flag, cb = opt.Name, opt.Min, opt.Max, opt.Default, opt.Flag, opt.Callback
                    local F = Utility:Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 36), Parent = Items})
                    Utility:Create("TextLabel", {Text = text, Font = Library.Config.FontContent, TextSize = 13, TextColor3 = Library.Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), TextXAlignment = Enum.TextXAlignment.Left, Parent = F})
                    local Val = Utility:Create("TextLabel", {Text = def .. "F", Font = Library.Config.Font, TextSize = 13, TextColor3 = Library.Theme.Accent, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), TextXAlignment = Enum.TextXAlignment.Right, Parent = F})
                    local Bg = Utility:Create("TextButton", {Text = "", AutoButtonColor = false, BackgroundColor3 = Color3.fromRGB(50, 50, 50), Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 0, 28), Parent = F})
                    local Fill = Utility:Create("Frame", {BackgroundColor3 = Library.Theme.Accent, Size = UDim2.new((def - min) / (max - min), 0, 1, 0), BorderSizePixel = 0, Parent = Bg})
                    Utility:Create("Frame", {BackgroundColor3 = Color3.new(1, 1, 1), Size = UDim2.new(0, 8, 0, 8), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Parent = Fill})
                    if flag then Library.Flags[flag] = def end
                    local drag = false
                    local function Upd(i) local p = math.clamp((i.Position.X - Bg.AbsolutePosition.X) / Bg.AbsoluteSize.X, 0, 1); local v = math.floor(min + (max - min) * p); Val.Text = v .. "F"; Fill.Size = UDim2.new(p, 0, 1, 0); if flag then Library.Flags[flag] = v end; if cb then cb(v) end end
                    Bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true; Upd(i) end end)
                    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
                    UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Upd(i) end end)
                end

                function Widgets:AddDropdown(opt)
                    local text, options, def, flag, cb = opt.Name, opt.Options, opt.Default, opt.Flag, opt.Callback
                    local isMulti = type(def) == "table"
                    local F = Utility:Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 45), Parent = Items})
                    Utility:Create("TextLabel", {Text = text, Font = Library.Config.FontContent, TextSize = 13, TextColor3 = Library.Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), TextXAlignment = Enum.TextXAlignment.Left, Parent = F})
                    local Main = Utility:Create("TextButton", {Text = "", BackgroundColor3 = Library.Theme.Dropdown, Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0, 22), AutoButtonColor = false, Parent = F}); Utility:Round(Main, 4); Utility:Stroke(Main, Library.Theme.Stroke)
                    local Lab = Utility:Create("TextLabel", {Text = "...", Font = Library.Config.FontContent, TextSize = 12, TextColor3 = Library.Theme.TextDim, BackgroundTransparency = 1, Size = UDim2.new(1, -25, 1, 0), Position = UDim2.new(0, 8, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = Main})
                    local Arrow = Utility:Create("ImageLabel", {Image = "rbxassetid://6034818379", Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -20, 0.5, -6), BackgroundTransparency = 1, ImageColor3 = Library.Theme.TextDim, Parent = Main})
                    local Sel = def or (isMulti and {} or "")
                    local function UpdText() if isMulti then local c = 0; local f; for k, v in pairs(Sel) do if v then c = c + 1; if not f then f = k end end end; Lab.Text = (c == 0 and "None") or (c == 1 and f) or (f .. ", +" .. (c - 1)) else Lab.Text = tostring(Sel) end end; UpdText()
                    
                    local List = Utility:Create("Frame", {BackgroundColor3 = Library.Theme.Sidebar, Size = UDim2.new(0, 0, 0, 0), Visible = false, ZIndex = 5100, ClipsDescendants = true, Parent = GlobalLayer}); Utility:Round(List, 4); Utility:Stroke(List, Library.Theme.Accent)
                    local Search = Utility:Create("TextBox", {PlaceholderText = "Search...", Text = "", BackgroundColor3 = Library.Theme.Main, Size = UDim2.new(1, -30, 0, 20), Position = UDim2.new(0, 5, 0, 5), Font = Library.Config.FontContent, TextSize = 12, TextColor3 = Library.Theme.Text, Parent = List}); Utility:Round(Search, 4)
                    local CloseX = Utility:Create("TextButton", {Text = "X", TextColor3 = Library.Theme.TextDim, Font = Enum.Font.GothamBold, TextSize = 12, BackgroundTransparency = 1, Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -25, 0, 5), Parent = List})
                    local Scroll = Utility:Create("ScrollingFrame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, -30), Position = UDim2.new(0, 0, 0, 30), CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 2, Parent = List}); Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = Scroll})
                    
                    local isOpen = false
                    local function Render(f)
                        f = f:lower(); local c = 0; for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                        for _, o in ipairs(options) do
                            if o:lower():find(f) then
                                local B = Utility:Create("TextButton", {Text = "", BackgroundColor3 = Library.Theme.Dropdown, Size = UDim2.new(1, -6, 0, 22), AutoButtonColor = false, Parent = Scroll}); Utility:Round(B, 3)
                                local T = Utility:Create("TextLabel", {Text = o, Font = Library.Config.FontContent, TextSize = 12, TextColor3 = Library.Theme.TextDim, BackgroundTransparency = 1, Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = B})
                                if isMulti then T.TextColor3 = Sel[o] and Library.Theme.Accent or Library.Theme.TextDim else T.TextColor3 = (Sel == o) and Library.Theme.Accent or Library.Theme.TextDim end
                                B.MouseButton1Click:Connect(function()
                                    if isMulti then Sel[o] = not Sel[o]; T.TextColor3 = Sel[o] and Library.Theme.Accent or Library.Theme.TextDim; UpdText()
                                    else Sel = o; UpdText(); List.Visible = false; isOpen = false; Utility:Tween(Main, {BackgroundColor3 = Library.Theme.Dropdown}); Utility:Tween(Arrow, {Rotation = 0}) end
                                    if flag then Library.Flags[flag] = Sel end; if cb then cb(Sel) end
                                end)
                                c = c + 1
                            end
                        end
                        Scroll.CanvasSize = UDim2.new(0, 0, 0, c * 24)
                    end
                    local function Toggle()
                        isOpen = not isOpen
                        if isOpen then
                            local abs = Main.AbsolutePosition; List.Position = UDim2.new(0, abs.X, 0, abs.Y + 26); List.Size = UDim2.new(0, Main.AbsoluteSize.X, 0, 200); List.Visible = true
                            Utility:Tween(Main, {BackgroundColor3 = Library.Theme.Hover}); Utility:Tween(Arrow, {Rotation = 180}); Search.Text = ""; Render("")
                        else
                            List.Visible = false; Utility:Tween(Main, {BackgroundColor3 = Library.Theme.Dropdown}); Utility:Tween(Arrow, {Rotation = 0})
                        end
                    end
                    Main.MouseButton1Click:Connect(Toggle); CloseX.MouseButton1Click:Connect(Toggle)
                    Search:GetPropertyChangedSignal("Text"):Connect(function() Render(Search.Text) end)
                end

                function Widgets:AddColorPicker(opt)
                    local text, def, flag, cb = opt.Name, opt.Default, opt.Flag, opt.Callback
                    local F = Utility:Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24), Parent = Items})
                    Utility:Create("TextLabel", {Text = text, Font = Library.Config.FontContent, TextSize = 13, TextColor3 = Library.Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(0.7, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = F})
                    local P = Utility:Create("TextButton", {Text = "", AutoButtonColor = false, BackgroundColor3 = def, Size = UDim2.new(0, 35, 0, 16), Position = UDim2.new(1, -35, 0.5, -8), Parent = F}); Utility:Round(P, 4)
                    if flag then Library.Flags[flag] = def end
                    local Pop = Utility:Create("Frame", {Visible = false, Size = UDim2.new(0, 200, 0, 200), BackgroundColor3 = Library.Theme.Sidebar, ZIndex = 5100, Parent = GlobalLayer}); Utility:Round(Pop, 6); Utility:Stroke(Pop, Library.Theme.Stroke)
                    local SV = Utility:Create("TextButton", {Text = "", AutoButtonColor = false, BackgroundColor3 = def, Size = UDim2.new(0, 160, 0, 160), Position = UDim2.new(0, 10, 0, 10), Parent = Pop}); Utility:Round(SV, 4)
                    local SL = Utility:Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1), Parent = SV}); Utility:Round(SL, 4); Utility:Create("UIGradient", {Color = ColorSequence.new(Color3.new(1, 1, 1)), Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}, Parent = SL})
                    local VL = Utility:Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 2, Parent = SV}); Utility:Round(VL, 4); Utility:Create("UIGradient", {Rotation = -90, Color = ColorSequence.new(Color3.new(0, 0, 0)), Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}, Parent = VL})
                    local Cur = Utility:Create("Frame", {Size = UDim2.new(0, 6, 0, 6), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 3, Parent = SV}); Utility:Round(Cur, 4); Utility:Stroke(Cur, Color3.new(0, 0, 0))
                    local Hue = Utility:Create("TextButton", {Text = "", AutoButtonColor = false, BackgroundColor3 = Color3.new(1, 1, 1), Size = UDim2.new(0, 15, 0, 160), Position = UDim2.new(1, -20, 0, 10), Parent = Pop}); Utility:Round(Hue, 4)
                    Utility:Create("UIGradient", {Rotation = 90, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromHSV(1, 0, 0)), ColorSequenceKeypoint.new(0.16, Color3.fromHSV(0.83, 1, 1)), ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.66, 1, 1)), ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)), ColorSequenceKeypoint.new(0.66, Color3.fromHSV(0.33, 1, 1)), ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.16, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 1, 1))}, Parent = Hue})
                    local HCur = Utility:Create("Frame", {Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = Hue})
                    local h, s, v = Color3.toHSV(def)
                    local function Upd() local c = Color3.fromHSV(h, s, v); P.BackgroundColor3 = c; SV.BackgroundColor3 = Color3.fromHSV(h, 1, 1); if flag then Library.Flags[flag] = c end; if cb then cb(c) end end
                    local dS, dH
                    SV.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dS = true end end)
                    Hue.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dH = true end end)
                    UserInputService.InputEnded:Connect(function() dS = false; dH = false end)
                    UserInputService.InputChanged:Connect(function(i) if dS and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local x = math.clamp((i.Position.X - SV.AbsolutePosition.X) / SV.AbsoluteSize.X, 0, 1); local y = math.clamp((i.Position.Y - SV.AbsolutePosition.Y) / SV.AbsoluteSize.Y, 0, 1); s = x; v = 1 - y; Cur.Position = UDim2.new(x, 0, y, 0); Upd() elseif dH and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local y = math.clamp((i.Position.Y - Hue.AbsolutePosition.Y) / Hue.AbsoluteSize.Y, 0, 1); h = 1 - y; HCur.Position = UDim2.new(0, 0, y, 0); Upd() end end)
                    P.MouseButton1Click:Connect(function() Pop.Visible = not Pop.Visible; Pop.Position = UDim2.new(0, P.AbsolutePosition.X + 42, 0, P.AbsolutePosition.Y) end)
                end

                function Widgets:AddButton(opt)
                    local text, cb = opt.Name, opt.Callback
                    local F = Utility:Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), Parent = Items})
                    local B = Utility:Create("TextButton", {Text = text, Font = Library.Config.FontContent, TextSize = 13, TextColor3 = Library.Theme.Text, BackgroundColor3 = Library.Theme.Dropdown, Size = UDim2.new(1, 0, 1, 0), Parent = F}); Utility:Round(B, 4)
                    B.MouseButton1Click:Connect(function() Utility:Tween(B, {BackgroundColor3 = Library.Theme.Accent, TextColor3 = Color3.new(0, 0, 0)}); task.wait(0.15); Utility:Tween(B, {BackgroundColor3 = Library.Theme.Dropdown, TextColor3 = Library.Theme.Text}); if cb then cb() end end)
                end

                function Widgets:AddInput(opt)
                    local text, def, flag, cb = opt.Name, opt.Default, opt.Flag, opt.Callback
                    local F = Utility:Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 45), Parent = Items})
                    Utility:Create("TextLabel", {Text = text, Font = Library.Config.FontContent, TextSize = 13, TextColor3 = Library.Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), TextXAlignment = Enum.TextXAlignment.Left, Parent = F})
                    local B = Utility:Create("TextBox", {Text = def, Font = Library.Config.FontContent, TextSize = 12, TextColor3 = Library.Theme.Text, BackgroundColor3 = Library.Theme.Dropdown, Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0, 22), Parent = F}); Utility:Round(B, 4)
                    if flag then Library.Flags[flag] = def end
                    B.FocusLost:Connect(function() if flag then Library.Flags[flag] = B.Text end; if cb then cb(B.Text) end end)
                end

                function Widgets:AddKeybind(opt)
                    local text, def, flag, cb = opt.Name, opt.Default, opt.Flag, opt.Callback
                    local F = Utility:Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24), Parent = Items})
                    Utility:Create("TextLabel", {Text = text, Font = Library.Config.FontContent, TextSize = 13, TextColor3 = Library.Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(0.7, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = F})
                    local B = Utility:Create("TextButton", {Text = def.Name, AutoButtonColor = false, BackgroundColor3 = Library.Theme.Dropdown, Size = UDim2.new(0, 60, 0, 18), Position = UDim2.new(1, -60, 0.5, -9), Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Library.Theme.TextDim, Parent = F}); Utility:Round(B, 4)
                    if flag then Library.Flags[flag] = def end
                    B.MouseButton1Click:Connect(function() B.Text = "..."; local i = UserInputService.InputBegan:Wait(); if i.UserInputType == Enum.UserInputType.Keyboard then B.Text = i.KeyCode.Name; if flag then Library.Flags[flag] = i.KeyCode end; if cb then cb(i.KeyCode) end else B.Text = "None" end end)
                end

                return Widgets
            end
            return SectFuncs
        end
        return TabFuncs
    end
    return Window
end

return Library
