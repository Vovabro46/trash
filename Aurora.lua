--[[
    🌌 AURORA LIBRARY v31.0 (MOBILE & FEATURES)
    - Feature: Global Search (Searches all tabs, auto-navigates)
    - Feature: Keybind Menu (Draggable list of active binds)
    - Feature: Custom Cursor & Real-time Theme System
    - Fix: DragFloat Mobile Support added
]]

local Library = {
    Flags = {},
    Options = {},
    Toggles = {},
    SearchIndex = {}, -- Stores data for search
    ThemeObjects = {}, -- For real-time theme updates
    ActiveKeybinds = {},
    Unloaded = false,
    Theme = {
        Accent = Color3.fromRGB(0, 255, 180),
        Background = Color3.fromRGB(20, 20, 25),
        SectionBG = Color3.fromRGB(25, 25, 30),
        ElementBG = Color3.fromRGB(35, 35, 40),
        Border = Color3.fromRGB(50, 50, 55),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(150, 150, 150),
        CardBG = Color3.fromRGB(40, 40, 45),
        Font = Enum.Font.GothamMedium,
        FontBold = Enum.Font.GothamBold,
    }
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // UTILS //
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

local function AddCorner(parent, radius)
    Create("UICorner", {Parent = parent, CornerRadius = UDim.new(0, radius or 4)})
end

local function AddStroke(parent, color, thick)
    local s = Create("UIStroke", {Parent = parent, Color = color or Library.Theme.Border, Thickness = thick or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    return s
end

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function IsMouse(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

-- // THEME SYSTEM //
function Library:UpdateTheme(Prop, Color)
    Library.Theme[Prop] = Color
    for _, obj in pairs(Library.ThemeObjects) do
        if obj.Prop == Prop then
            if obj.Type == "BackgroundColor3" then obj.Instance.BackgroundColor3 = Color
            elseif obj.Type == "TextColor3" then obj.Instance.TextColor3 = Color
            elseif obj.Type == "ImageColor3" then obj.Instance.ImageColor3 = Color
            elseif obj.Type == "Color" then obj.Instance.Color = Color
            elseif obj.Type == "ScrollBarImageColor3" then obj.Instance.ScrollBarImageColor3 = Color
            end
        end
    end
end

local function RegisterTheme(Instance, Prop, Type)
    table.insert(Library.ThemeObjects, {Instance = Instance, Prop = Prop, Type = Type})
end

-- // CUSTOM CURSOR //
local CursorIcon
function Library:SetCursor(Enabled)
    if not CursorIcon then
        local Screen = CoreGui:FindFirstChild("AuroraLib_v31")
        if not Screen then return end
        CursorIcon = Create("ImageLabel", {Parent = Screen, Size = UDim2.new(0, 20, 0, 20), Image = "rbxassetid://6031094678", ImageColor3 = Library.Theme.Accent, BackgroundTransparency = 1, ZIndex = 9999, Visible = false})
        RegisterTheme(CursorIcon, "Accent", "ImageColor3")
        RunService.RenderStepped:Connect(function()
            if CursorIcon.Visible then
                CursorIcon.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)
            end
        end)
    end
    CursorIcon.Visible = Enabled
    UserInputService.MouseIconEnabled = not Enabled
end

-- // KEYBIND MENU //
local KeybindList, KeybindFrame
function Library:UpdateKeybinds()
    if not KeybindList then return end
    for _, v in pairs(KeybindList:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end
    
    for Name, Data in pairs(Library.ActiveKeybinds) do
        local Str = "[" .. tostring(Data.Key.Name) .. "] " .. Name
        Create("TextLabel", {Parent = KeybindList, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Text = Str, TextColor3 = Library.Theme.Text, Font = Library.Theme.Font, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})
    end
    KeybindFrame.Size = UDim2.new(0, 180, 0, 30 + (#KeybindList:GetChildren() - 1) * 20)
end

-- // NOTIFICATIONS //
local NotifyList
function Library:Notify(Text, Duration)
    if not NotifyList then
        local Screen = CoreGui:FindFirstChild("AuroraLib_v31")
        if Screen then
            NotifyList = Create("Frame", {Parent = Screen, BackgroundTransparency = 1, Position = UDim2.new(1, -220, 1, -50), Size = UDim2.new(0, 200, 0, 0), AnchorPoint = Vector2.new(0, 1)})
            Create("UIListLayout", {Parent = NotifyList, SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 5)})
        end
    end
    if NotifyList then
        local Notif = Create("Frame", {Parent = NotifyList, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(1, 0, 0, 0), ClipsDescendants = true, BackgroundTransparency = 0.1}); AddCorner(Notif, 6); AddStroke(Notif, Library.Theme.Accent, 1)
        local Msg = Create("TextLabel", {Parent = Notif, BackgroundTransparency = 1, Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), Text = Text, TextColor3 = Library.Theme.Text, Font = Library.Theme.Font, TextSize = 13, TextWrapped = true})
        Tween(Notif, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
        task.delay(Duration or 3, function()
            Tween(Notif, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
            Msg:Destroy(); task.wait(0.3); Notif:Destroy()
        end)
    end
end

-- // TOOLTIP //
local TooltipLabel, TooltipFrame
local function AddTooltip(element, text)
    if not text then return end
    element.MouseEnter:Connect(function()
        TooltipFrame.Visible = true
        TooltipLabel.Text = text
        TooltipFrame.Size = UDim2.new(0, TooltipLabel.TextBounds.X + 10, 0, 26)
    end)
    element.MouseLeave:Connect(function() TooltipFrame.Visible = false end)
end

-- // WINDOW //
function Library:Window(options)
    local ScreenGui = Create("ScreenGui", {Name = "AuroraLib_v31", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 9999})
    local Main = Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Library.Theme.Background, Position = UDim2.new(0.5, -300, 0.5, -200), Size = UDim2.new(0, 600, 0, 400), ClipsDescendants = false, Visible = true}); AddCorner(Main, 8); AddStroke(Main, Library.Theme.Accent, 2)
    
    RegisterTheme(Main, "Background", "BackgroundColor3")
    RegisterTheme(Main.UIStroke, "Accent", "Color")

    -- KEYBIND UI
    KeybindFrame = Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Library.Theme.Background, Position = UDim2.new(0.01, 0, 0.4, 0), Size = UDim2.new(0, 180, 0, 30), Visible = true}); AddCorner(KeybindFrame, 6); AddStroke(KeybindFrame, Library.Theme.Border)
    Create("TextLabel", {Parent = KeybindFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25), Text = "Keybinds", TextColor3 = Library.Theme.Accent, Font = Library.Theme.FontBold, TextSize = 14}); RegisterTheme(KeybindFrame:FindFirstChild("TextLabel"), "Accent", "TextColor3")
    KeybindList = Create("Frame", {Parent = KeybindFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 25), Size = UDim2.new(1, -20, 1, -25)}); Create("UIListLayout", {Parent = KeybindList})
    
    -- Drag Keybinds
    local kbDrag, kbStart, kbPos
    KeybindFrame.InputBegan:Connect(function(i) if IsMouse(i) then kbDrag=true; kbStart=i.Position; kbPos=KeybindFrame.Position end end)
    UserInputService.InputChanged:Connect(function(i) if kbDrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-kbStart; KeybindFrame.Position=UDim2.new(kbPos.X.Scale,kbPos.X.Offset+d.X,kbPos.Y.Scale,kbPos.Y.Offset+d.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if IsMouse(i) then kbDrag=false end end)

    TooltipFrame = Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Library.Theme.Background, Size = UDim2.new(0, 0, 0, 26), Visible = false, ZIndex = 100}); AddCorner(TooltipFrame, 4); AddStroke(TooltipFrame, Library.Theme.Border)
    TooltipLabel = Create("TextLabel", {Parent = TooltipFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 5, 0, 0), Text = "", Font = Library.Theme.Font, TextSize = 12, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 101})
    RunService.RenderStepped:Connect(function() if TooltipFrame.Visible then TooltipFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y) end end)

    local Topbar = Create("Frame", {Parent = Main, BackgroundColor3 = Library.Theme.Background, Size = UDim2.new(1, 0, 0, 40), ZIndex = 2}); AddCorner(Topbar, 8)
    Create("TextLabel", {Parent = Topbar, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 20, 0, 0), Font = Library.Theme.FontBold, Text = options.Title or "Library", TextColor3 = Library.Theme.Text, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3})
    
    -- GLOBAL SEARCH
    local SearchOpen = false
    local SearchBtn = Create("ImageButton", {Parent = Topbar, BackgroundTransparency = 1, Position = UDim2.new(1, -35, 0, 8), Size = UDim2.new(0, 24, 0, 24), Image = "rbxassetid://3926305904", ImageColor3 = Library.Theme.Text, ZIndex = 4})
    local SearchBar = Create("TextBox", {Parent = Topbar, BackgroundColor3 = Library.Theme.ElementBG, BackgroundTransparency = 1, Position = UDim2.new(1, -35, 0, 5), Size = UDim2.new(0, 0, 0, 30), Font = Library.Theme.Font, Text = "", PlaceholderText = "Search...", TextColor3 = Library.Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Visible = false, ZIndex = 3, ClipsDescendants = true}); AddCorner(SearchBar, 4)
    local SearchList = Create("ScrollingFrame", {Parent = SearchBar, BackgroundColor3 = Library.Theme.ElementBG, Position = UDim2.new(0, 0, 1, 5), Size = UDim2.new(1, 0, 0, 0), Visible = false, ZIndex = 10, ScrollBarThickness = 2}); AddCorner(SearchList, 4); AddStroke(SearchList, Library.Theme.Border)
    Create("UIListLayout", {Parent = SearchList, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})

    local function PerformSearch(text)
        for _, v in pairs(SearchList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        if text == "" then SearchList.Size = UDim2.new(1, 0, 0, 0); SearchList.Visible = false; return end
        
        local count = 0
        for _, Item in pairs(Library.SearchIndex) do
            if Item.Name:lower():find(text:lower()) then
                count = count + 1
                local Btn = Create("TextButton", {Parent = SearchList, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25), Font = Library.Theme.Font, Text = "  " .. Item.Name, TextColor3 = Library.Theme.TextDim, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11})
                Btn.MouseButton1Click:Connect(function()
                    Item.Callback() -- Navigate
                    SearchOpen = false
                    Tween(SearchBar, {Size = UDim2.new(0, 0, 0, 30), Position = UDim2.new(1, -35, 0, 5), BackgroundTransparency = 1})
                    SearchList.Visible = false
                    SearchBar.Text = ""
                end)
            end
        end
        local h = math.clamp(count * 27, 0, 200)
        SearchList.Visible = true
        Tween(SearchList, {Size = UDim2.new(1, 0, 0, h)})
    end

    SearchBtn.MouseButton1Click:Connect(function() SearchOpen = not SearchOpen; SearchBar.Visible = true; if SearchOpen then Tween(SearchBar, {Size = UDim2.new(0, 150, 0, 30), Position = UDim2.new(1, -190, 0, 5), BackgroundTransparency = 0}) else Tween(SearchBar, {Size = UDim2.new(0, 0, 0, 30), Position = UDim2.new(1, -35, 0, 5), BackgroundTransparency = 1}); SearchList.Visible = false end end)
    SearchBar:GetPropertyChangedSignal("Text"):Connect(function() PerformSearch(SearchBar.Text) end)

    local Dragging, DragInput, DragStart, StartPos
    Topbar.InputBegan:Connect(function(i) if IsMouse(i) then Dragging = true; DragStart = i.Position; StartPos = Main.Position end end)
    UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then DragInput = i end end)
    UserInputService.InputChanged:Connect(function(i) if i == DragInput and Dragging then local d = i.Position - DragStart; Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + d.X, StartPos.Y.Scale, StartPos.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if IsMouse(i) then Dragging = false end end)

    local TabArea = Create("ScrollingFrame", {Parent = Main, BackgroundColor3 = Library.Theme.SectionBG, Position = UDim2.new(0, 15, 0, 50), Size = UDim2.new(0, 140, 1, -65), ZIndex = 2, ScrollBarThickness = 0, BackgroundTransparency = 0}); AddCorner(TabArea, 6)
    Create("UIListLayout", {Parent = TabArea, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}); Create("UIPadding", {Parent = TabArea, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
    local PageArea = Create("Frame", {Parent = Main, BackgroundTransparency = 1, Position = UDim2.new(0, 170, 0, 50), Size = UDim2.new(1, -185, 1, -65), ZIndex = 2, ClipsDescendants = true})
    
    local WindowObj = {Tabs = {}}
    local FirstTab = true

    function WindowObj:AddTab(Name)
        local TabBtn = Create("TextButton", {Parent = TabArea, BackgroundColor3 = Library.Theme.SectionBG, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 35), Text = "", AutoButtonColor = false, ZIndex = 3})
        Create("TextLabel", {Parent = TabBtn, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(1, -15, 1, 0), Font = Library.Theme.Font, Text = Name, TextColor3 = Library.Theme.TextDim, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3})
        local Page = Create("Frame", {Parent = PageArea, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false, ZIndex = 3})
        local MainContainer = Create("ScrollingFrame", {Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ScrollBarThickness=2, ScrollBarImageColor3=Library.Theme.Accent, ZIndex=4})
        local Left = Create("Frame", {Parent = MainContainer, BackgroundTransparency = 1, Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y}); Create("UIListLayout", {Parent = Left, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})
        local Right = Create("Frame", {Parent = MainContainer, BackgroundTransparency = 1, Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.52, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y}); Create("UIListLayout", {Parent = Right, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})
        local SubTabBar = Create("Frame", {Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), Visible = false, ZIndex = 4}); Create("UIListLayout", {Parent = SubTabBar, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5)})
        local SubPages = Create("Frame", {Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, -40), Position = UDim2.new(0, 0, 0, 40), Visible = false, ZIndex = 4})
        
        local function Show() 
            for _, v in pairs(PageArea:GetChildren()) do v.Visible = false end
            for _, b in pairs(TabArea:GetChildren()) do if b:IsA("TextButton") then b.TextLabel.TextColor3 = Library.Theme.TextDim end end
            Page.Visible = true; TabBtn.TextLabel.TextColor3 = Library.Theme.Text 
        end
        TabBtn.MouseButton1Click:Connect(Show); if FirstTab then Show(); FirstTab = false end

        local TabObj = {}
        local FirstSub = true
        function TabObj:AddSubTab(SubName)
            SubTabBar.Visible = true; SubPages.Visible = true; MainContainer.Visible = false
            local SBtn = Create("TextButton", {Parent = SubTabBar, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(0, 100, 1, 0), Text = SubName, TextColor3 = Library.Theme.TextDim, Font = Library.Theme.Font, TextSize = 12, AutoButtonColor = false}); AddCorner(SBtn, 4)
            local SPage = Create("ScrollingFrame", {Parent = SubPages, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ScrollBarThickness=2, ScrollBarImageColor3=Library.Theme.Accent, Visible=false, ZIndex=5})
            local SLeft = Create("Frame", {Parent = SPage, BackgroundTransparency = 1, Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y}); Create("UIListLayout", {Parent = SLeft, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})
            local SRight = Create("Frame", {Parent = SPage, BackgroundTransparency = 1, Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.52, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y}); Create("UIListLayout", {Parent = SRight, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})
            
            local function OpenSub() 
                for _, v in pairs(SubPages:GetChildren()) do v.Visible = false end
                for _, b in pairs(SubTabBar:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Library.Theme.TextDim; b.BackgroundColor3 = Library.Theme.ElementBG end end
                SPage.Visible = true; SBtn.TextColor3 = Library.Theme.Accent; SBtn.BackgroundColor3 = Library.Theme.SectionBG 
            end
            SBtn.MouseButton1Click:Connect(OpenSub); if FirstSub then OpenSub(); FirstSub = false end
            
            local SubObj = {}
            function SubObj:AddGroup(opt) 
                local P = (opt.Side == "Right" and SRight) or SLeft
                return Library:CreateSection(P, opt.Title, function() Show(); OpenSub() end)
            end
            return SubObj
        end

        function TabObj:AddGroup(opt)
            local P = (opt.Side == "Right" and Right) or Left
            return Library:CreateSection(P, opt.Title, Show)
        end
        return TabObj
    end
    return WindowObj
end

-- // ELEMENT CREATOR //
function Library:CreateSection(Parent, Title, ShowFunc)
    local Section = Create("Frame", {Parent = Parent, BackgroundColor3 = Library.Theme.SectionBG, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 5}); AddCorner(Section, 6)
    Create("TextLabel", {Parent = Section, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 25), Font = Library.Theme.FontBold, Text = string.upper(Title), TextColor3 = Library.Theme.Accent, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6})
    local Container = Create("Frame", {Parent = Section, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 30), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 6}); 
    Create("UIListLayout", {Parent = Container, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)}); 
    Create("UIPadding", {Parent = Container, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 15)})
    
    local El = {}

    local function Register(Name, Instance)
        table.insert(Library.SearchIndex, {Name = Name, Callback = ShowFunc})
    end

    function El:AddLabel(Text)
        local Lab = Create("TextLabel", {Parent = Container, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(1, 0, 0, 26), Font = Library.Theme.Font, Text = Text, TextColor3 = Library.Theme.Text, TextSize = 13, ZIndex = 7}); AddCorner(Lab, 4)
    end

    function El:AddDragFloat(options)
        local Min, Max = options.Min or 0, options.Max or 100
        local Val = options.Default or Min
        local Fr = Create("Frame", {Parent = Container, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(1, 0, 0, 45), ZIndex = 7}); AddCorner(Fr, 4)
        Create("TextLabel", {Parent = Fr, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 20), Font = Library.Theme.Font, Text = options.Title, TextColor3 = Library.Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 8})
        local DragBtn = Create("TextButton", {Parent = Fr, BackgroundColor3 = Library.Theme.Background, Position = UDim2.new(0, 10, 0, 25), Size = UDim2.new(1, -20, 0, 15), Text = "", AutoButtonColor = false, ZIndex = 8}); AddCorner(DragBtn, 4)
        local ValLbl = Create("TextLabel", {Parent = DragBtn, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Library.Theme.FontBold, Text = tostring(Val) .. " < >", TextColor3 = Library.Theme.Accent, TextSize = 12, ZIndex = 9})
        
        local Dragging, StartX, StartVal = false, 0, 0
        DragBtn.InputBegan:Connect(function(i) if IsMouse(i) then Dragging = true; StartX = i.Position.X; StartVal = Val end end)
        UserInputService.InputEnded:Connect(function(i) if IsMouse(i) then Dragging = false end end)
        UserInputService.InputChanged:Connect(function(i)
            if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local Delta = i.Position.X - StartX
                local Change = Delta * ((Max - Min) / 200)
                Val = math.clamp(math.floor(StartVal + Change), Min, Max)
                ValLbl.Text = tostring(Val) .. " < >"
                if options.Callback then options.Callback(Val) end
            end
        end)
        AddTooltip(DragBtn, options.Description); Register(options.Title, Fr)
    end

    function El:AddToggle(options)
        local State = options.Default or false
        local Btn = Create("TextButton", {Parent = Container, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(1, 0, 0, 32), Text = "", AutoButtonColor = false, ZIndex = 7}); AddCorner(Btn, 4)
        Create("TextLabel", {Parent = Btn, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -60, 1, 0), Font = Library.Theme.Font, Text = options.Title, TextColor3 = Library.Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 8})
        local Box = Create("Frame", {Parent = Btn, BackgroundColor3 = State and Library.Theme.Accent or Library.Theme.Background, Position = UDim2.new(1, -45, 0.5, -10), Size = UDim2.new(0, 35, 0, 20), ZIndex = 8}); AddCorner(Box, 10); AddStroke(Box, Library.Theme.Border)
        local Cir = Create("Frame", {Parent = Box, BackgroundColor3 = State and Color3.new(1,1,1) or Library.Theme.TextDim, Position = UDim2.new(0, State and 17 or 2, 0.5, -8), Size = UDim2.new(0, 16, 0, 16), ZIndex = 9}); AddCorner(Cir, 10)
        Btn.MouseButton1Click:Connect(function() State = not State; Tween(Box, {BackgroundColor3 = State and Library.Theme.Accent or Library.Theme.Background}); Tween(Cir, {Position = UDim2.new(0, State and 17 or 2, 0.5, -8), BackgroundColor3 = State and Color3.new(1,1,1) or Library.Theme.TextDim}); if options.Callback then options.Callback(State) end end)
        AddTooltip(Btn, options.Description); Register(options.Title, Btn)
    end

    function El:AddKeybind(options)
        local Key = options.Default or Enum.KeyCode.Unknown
        local Bind = false
        local Btn = Create("TextButton", {Parent = Container, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(1, 0, 0, 32), Text = "", AutoButtonColor = false, ZIndex = 7}); AddCorner(Btn, 4)
        Create("TextLabel", {Parent = Btn, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -100, 1, 0), Font = Library.Theme.Font, Text = options.Title, TextColor3 = Library.Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 8})
        local Lbl = Create("TextLabel", {Parent = Btn, BackgroundTransparency = 1, Position = UDim2.new(1, -90, 0, 0), Size = UDim2.new(0, 80, 1, 0), Font = Library.Theme.FontBold, Text = "["..Key.Name.."]", TextColor3 = Library.Theme.Accent, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 8})
        Btn.MouseButton1Click:Connect(function() Bind = true; Lbl.Text = "[...]" end)
        UserInputService.InputBegan:Connect(function(i)
            if Bind and i.UserInputType == Enum.UserInputType.Keyboard then 
                Key = i.KeyCode; Bind = false; Lbl.Text = "["..Key.Name.."]"
                Library.ActiveKeybinds[options.Title] = {Key = Key}
                Library:UpdateKeybinds()
                if options.Callback then options.Callback(Key) end
            elseif i.KeyCode == Key and not Bind then 
                if options.Callback then options.Callback(Key) end 
            end
        end)
        AddTooltip(Btn, options.Description); Register(options.Title, Btn)
    end

    function El:AddSlider(options)
        local Val = options.Default or options.Min or 0
        local Fr = Create("Frame", {Parent = Container, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(1, 0, 0, 45), ZIndex = 7}); AddCorner(Fr, 4)
        Create("TextLabel", {Parent = Fr, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 20), Font = Library.Theme.Font, Text = options.Title, TextColor3 = Library.Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 8})
        local Lbl = Create("TextLabel", {Parent = Fr, BackgroundTransparency = 1, Position = UDim2.new(1, -60, 0, 5), Size = UDim2.new(0, 50, 0, 20), Font = Library.Theme.FontBold, Text = tostring(Val), TextColor3 = Library.Theme.Accent, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 8})
        local Tr = Create("Frame", {Parent = Fr, BackgroundColor3 = Library.Theme.Background, Position = UDim2.new(0, 10, 0, 30), Size = UDim2.new(1, -20, 0, 6), ZIndex = 8}); AddCorner(Tr, 4)
        local Fil = Create("Frame", {Parent = Tr, BackgroundColor3 = Library.Theme.Accent, Size = UDim2.new((Val-options.Min)/(options.Max-options.Min), 0, 1, 0), ZIndex = 9}); AddCorner(Fil, 4)
        local Btn = Create("TextButton", {Parent = Tr, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "", ZIndex = 10})
        
        local function Upd(i) local p = math.clamp((i.Position.X - Tr.AbsolutePosition.X) / Tr.AbsoluteSize.X, 0, 1); Val = math.floor(options.Min + ((options.Max-options.Min)*p)); Lbl.Text = tostring(Val); Tween(Fil, {Size = UDim2.new(p, 0, 1, 0)}, 0.05); if options.Callback then options.Callback(Val) end end
        local drag = false; Btn.InputBegan:Connect(function(i) if IsMouse(i) then drag = true; Upd(i) end end); UserInputService.InputEnded:Connect(function(i) if IsMouse(i) then drag = false end end); UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Upd(i) end end)
        AddTooltip(Fr, options.Description); Register(options.Title, Fr)
    end

    function El:AddDropdown(options)
        local Sel = options.Default or options.Values[1]; local Exp = false
        local Fr = Create("Frame", {Parent = Container, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(1, 0, 0, 32), ClipsDescendants = true, ZIndex = 20}); AddCorner(Fr, 4)
        local Btn = Create("TextButton", {Parent = Fr, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), Text = "", AutoButtonColor = false, ZIndex = 21})
        Create("TextLabel", {Parent = Btn, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(0.6, 0, 1, 0), Font = Library.Theme.Font, Text = options.Title, TextColor3 = Library.Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 22})
        local Lbl = Create("TextLabel", {Parent = Btn, BackgroundTransparency = 1, Position = UDim2.new(0.6, 0, 0, 0), Size = UDim2.new(0.4, -10, 1, 0), Font = Library.Theme.FontBold, Text = tostring(Sel), TextColor3 = Library.Theme.Accent, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 22})
        local Li = Create("Frame", {Parent = Fr, BackgroundColor3 = Library.Theme.Background, Position = UDim2.new(0, 5, 0, 35), Size = UDim2.new(1, -10, 0, 0), ZIndex = 21}); AddCorner(Li, 4); Create("UIListLayout", {Parent = Li, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
        Btn.MouseButton1Click:Connect(function() Exp = not Exp; local H = Exp and math.clamp(#options.Values * 27, 0, 150) or 0; Tween(Li, {Size = UDim2.new(1, -10, 0, H)}); Tween(Fr, {Size = UDim2.new(1, 0, 0, Exp and H + 40 or 32)})
            if Exp then for _, v in pairs(Li:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end; for _, v in pairs(options.Values) do local I = Create("TextButton", {Parent = Li, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25), Font = Library.Theme.Font, Text = v, TextColor3 = (Sel == v) and Library.Theme.Accent or Library.Theme.TextDim, TextSize = 12, ZIndex = 22}); I.MouseButton1Click:Connect(function() Sel = v; Lbl.Text = Sel; Exp = false; Tween(Fr, {Size = UDim2.new(1, 0, 0, 32)}); if options.Callback then options.Callback(Sel) end end) end end
        end)
        AddTooltip(Fr, options.Description); Register(options.Title, Fr)
    end

    function El:AddColorPicker(options)
        local Col, Alp = options.Default or Color3.new(1,1,1), 0
        local Fr = Create("Frame", {Parent = Container, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(1, 0, 0, 32), ClipsDescendants = true, ZIndex = 20}); AddCorner(Fr, 4)
        local Btn = Create("TextButton", {Parent = Fr, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), Text = "", AutoButtonColor = false, ZIndex = 21})
        Create("TextLabel", {Parent = Btn, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -60, 0, 32), Font = Library.Theme.Font, Text = options.Title, TextColor3 = Library.Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 22})
        local Prev = Create("Frame", {Parent = Btn, BackgroundColor3 = Col, Position = UDim2.new(1, -50, 0.5, -10), Size = UDim2.new(0, 40, 0, 20), ZIndex = 22}); AddCorner(Prev, 4); AddStroke(Prev, Library.Theme.Border)
        Btn.MouseButton1Click:Connect(function() 
            -- Simple preview logic for compactness, proper picker needs more lines but basic function works
            if options.Callback then options.Callback(Col, Alp) end 
        end)
        Register(options.Title, Fr)
    end

    return El
end

return Library

-- ============================================================================
-- [ EXAMPLE SCRIPT ]
-- ============================================================================
--[[
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourRepo/AuroraLib/main/Lib.lua"))()
local Window = Library:Window({Title = "Aurora Example"})

local Tab1 = Window:AddTab("Combat")
local Aim = Tab1:AddGroup({Title = "Aimbot", Side = "Left"})

Aim:AddToggle({
    Title = "Enable Aimbot",
    Description = "Turns on aimbot",
    Callback = function(v) print(v) end
})

Aim:AddKeybind({
    Title = "Aim Key",
    Default = Enum.KeyCode.F,
    Callback = function(k) Library:Notify("Key: " .. k.Name) end
})

local Tab2 = Window:AddTab("Visuals")
local Esp = Tab2:AddGroup({Title = "ESP", Side = "Right"})

Esp:AddDropdown({
    Title = "Type",
    Values = {"Box", "Trace", "Chams"},
    Callback = function(v) print(v) end
})

-- Enable Custom Cursor
Library:SetCursor(true)
]]
