local Library = {
    Flags = {},
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
    Create("UIStroke", {Parent = parent, Color = color or Library.Theme.Border, Thickness = thick or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function IsMouse(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

-- // PARTICLES //
local function InitParticles(parent)
    local ParticleContainer = Create("Frame", {Parent = parent, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, ZIndex = 1, ClipsDescendants = true})
    task.spawn(function()
        while parent.Parent do
            if parent.Visible then
                local Size = math.random(2, 5)
                local Star = Create("Frame", {Parent = ParticleContainer, BackgroundColor3 = Library.Theme.Accent, BorderSizePixel = 0, Position = UDim2.new(math.random(), 0, 1, 0), Size = UDim2.new(0, Size, 0, Size), BackgroundTransparency = 0.5, ZIndex = 1})
                AddCorner(Star, 5)
                local Duration = math.random(3, 8)
                TweenService:Create(Star, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {Position = UDim2.new(math.random(), 0, -0.1, 0), BackgroundTransparency = 1, Rotation = math.random(-360, 360)}):Play()
                game.Debris:AddItem(Star, Duration)
            end
            task.wait(0.4)
        end
    end)
end

-- // TOOLTIP SYSTEM //
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

-- // ELEMENT CREATOR //
function Library:CreateSection(Parent, Title)
    local Section = Create("Frame", {Parent = Parent, BackgroundColor3 = Library.Theme.SectionBG, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 5}); AddCorner(Section, 6)
    Create("TextLabel", {Parent = Section, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 25), Font = Library.Theme.FontBold, Text = string.upper(Title), TextColor3 = Library.Theme.Accent, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6})
    local Container = Create("Frame", {Parent = Section, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 30), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 6}); 
    Create("UIListLayout", {Parent = Container, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)}); 
    Create("UIPadding", {Parent = Container, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 15)})
    
    local El = {}

    -- [ SEPARATOR ]
    function El:AddSeparator()
        local Sep = Create("Frame", {Parent = Container, BackgroundColor3 = Library.Theme.Border, Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0, ZIndex = 10})
        Create("UIPadding", {Parent = Sep, PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)})
    end

    -- [ SPACE / DUMMY ]
    function El:AddSpace(Amount)
        Create("Frame", {Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, Amount or 10)})
    end

    -- [ CARD ]
    function El:AddCard(options)
        local Title = options.Title or "Card"
        local Content = options.Content or ""
        local Icon = options.Icon or "rbxassetid://3944680095" -- Info icon default
        
        local Card = Create("Frame", {Parent = Container, BackgroundColor3 = Library.Theme.CardBG, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 7}); AddCorner(Card, 6); AddStroke(Card, Library.Theme.Border, 1)
        Create("UIPadding", {Parent = Card, PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
        
        local Ico = Create("ImageLabel", {Parent = Card, BackgroundTransparency = 1, Size = UDim2.new(0, 20, 0, 20), Image = Icon, ImageColor3 = Library.Theme.Accent, ZIndex = 8})
        Create("TextLabel", {Parent = Card, BackgroundTransparency = 1, Position = UDim2.new(0, 30, 0, 0), Size = UDim2.new(1, -30, 0, 20), Font = Library.Theme.FontBold, Text = Title, TextColor3 = Library.Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 8})
        Create("TextLabel", {Parent = Card, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 25), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Font = Library.Theme.Font, Text = Content, TextColor3 = Library.Theme.TextDim, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, ZIndex = 8})
        AddTooltip(Card, options.Description)
    end

    -- [ DRAG FLOAT ]
    function El:AddDragFloat(options)
        local Title = options.Title or "Drag Float"
        local Min, Max = options.Min or 0, options.Max or 100
        local Default = options.Default or Min
        local Flag = options.Flag
        local Callback = options.Callback or function() end
        local Val = Default
        if Flag then Library.Flags[Flag] = Val end

        local Fr = Create("Frame", {Parent = Container, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(1, 0, 0, 45), ZIndex = 7}); AddCorner(Fr, 4)
        Create("TextLabel", {Parent = Fr, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 20), Font = Library.Theme.Font, Text = Title, TextColor3 = Library.Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 8})
        
        -- The Drag Area
        local DragBtn = Create("TextButton", {Parent = Fr, BackgroundColor3 = Library.Theme.Background, Position = UDim2.new(0, 10, 0, 25), Size = UDim2.new(1, -20, 0, 15), Text = "", AutoButtonColor = false, ZIndex = 8}); AddCorner(DragBtn, 4)
        local ValLbl = Create("TextLabel", {Parent = DragBtn, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Library.Theme.FontBold, Text = tostring(Val), TextColor3 = Library.Theme.Accent, TextSize = 12, ZIndex = 9})
        
        -- Drag Logic
        local Dragging, StartX, StartVal = false, 0, 0
        DragBtn.InputBegan:Connect(function(i) if IsMouse(i) then Dragging = true; StartX = i.Position.X; StartVal = Val; UserInputService.MouseIconEnabled = false end end)
        UserInputService.InputEnded:Connect(function(i) if IsMouse(i) then Dragging = false; UserInputService.MouseIconEnabled = true end end)
        UserInputService.InputChanged:Connect(function(i)
            if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement) then
                local Delta = i.Position.X - StartX
                local Change = Delta * ((Max - Min) / 200) -- Sensitivity
                Val = math.clamp(math.floor(StartVal + Change), Min, Max)
                ValLbl.Text = tostring(Val) .. " < >"
                if Flag then Library.Flags[Flag] = Val end
                Callback(Val)
            end
        end)
        AddTooltip(DragBtn, options.Description or "Click and drag left/right")
    end

    -- [ INPUT GROUP ]
    function El:AddInputGroup(Title)
        local GroupFrame = Create("Frame", {Parent = Container, BackgroundColor3 = Library.Theme.Background, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 0.5, ZIndex = 7}); AddCorner(GroupFrame, 4); AddStroke(GroupFrame, Library.Theme.Border, 1)
        Create("UIPadding", {Parent = GroupFrame, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8)})
        Create("UIListLayout", {Parent = GroupFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)})
        
        if Title then
            Create("TextLabel", {Parent = GroupFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 15), Font = Library.Theme.FontBold, Text = Title, TextColor3 = Library.Theme.TextDim, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 8})
        end

        -- Proxy function to add elements to this group instead of main container
        local ProxyEl = {}
        -- Copy basic functions but change parent to GroupFrame
        function ProxyEl:AddToggle(opt)
            -- Simplified inline version for grouping
            local State = opt.Default or false; local Flag = opt.Flag
            if Flag then Library.Flags[Flag] = State end
            local Btn = Create("TextButton", {Parent = GroupFrame, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(1, 0, 0, 25), Text = "", AutoButtonColor = false, ZIndex = 8}); AddCorner(Btn, 4)
            Create("TextLabel", {Parent = Btn, BackgroundTransparency = 1, Position = UDim2.new(0, 25, 0, 0), Size = UDim2.new(1, -25, 1, 0), Font = Library.Theme.Font, Text = opt.Title, TextColor3 = Library.Theme.Text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 9})
            local Box = Create("Frame", {Parent = Btn, BackgroundColor3 = State and Library.Theme.Accent or Library.Theme.Background, Position = UDim2.new(0, 5, 0.5, -6), Size = UDim2.new(0, 12, 0, 12), ZIndex = 9}); AddCorner(Box, 3)
            Btn.MouseButton1Click:Connect(function() State = not State; Box.BackgroundColor3 = State and Library.Theme.Accent or Library.Theme.Background; if Flag then Library.Flags[Flag] = State end; opt.Callback(State) end)
            AddTooltip(Btn, opt.Description)
        end
        function ProxyEl:AddInput(opt)
             local Default = opt.Default or ""; local Flag = opt.Flag
             if Flag then Library.Flags[Flag] = Default end
             local Box = Create("TextBox", {Parent = GroupFrame, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(1, 0, 0, 25), Font = Library.Theme.Font, Text = Default, PlaceholderText = opt.Title, TextColor3 = Library.Theme.Text, TextSize = 12, ZIndex = 8, ClearTextOnFocus = false}); AddCorner(Box, 4)
             Box.FocusLost:Connect(function() if Flag then Library.Flags[Flag] = Box.Text end; opt.Callback(Box.Text) end)
             AddTooltip(Box, opt.Description)
        end
        return ProxyEl
    end

    -- [ STANDARD ELEMENTS WITH TOOLTIPS ]
    function El:AddToggle(options)
        local State = options.Default or false; if options.Flag then Library.Flags[options.Flag] = State end
        local Btn = Create("TextButton", {Parent = Container, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(1, 0, 0, 32), Text = "", AutoButtonColor = false, ZIndex = 7}); AddCorner(Btn, 4)
        Create("TextLabel", {Parent = Btn, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -60, 1, 0), Font = Library.Theme.Font, Text = options.Title, TextColor3 = Library.Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 8})
        local Box = Create("Frame", {Parent = Btn, BackgroundColor3 = State and Library.Theme.Accent or Library.Theme.Background, Position = UDim2.new(1, -45, 0.5, -10), Size = UDim2.new(0, 35, 0, 20), ZIndex = 8}); AddCorner(Box, 10); AddStroke(Box, Library.Theme.Border)
        local Cir = Create("Frame", {Parent = Box, BackgroundColor3 = State and Color3.new(1,1,1) or Library.Theme.TextDim, Position = UDim2.new(0, State and 17 or 2, 0.5, -8), Size = UDim2.new(0, 16, 0, 16), ZIndex = 9}); AddCorner(Cir, 10)
        local Funcs = {}
        function Funcs:Set(bool) State = bool; if options.Flag then Library.Flags[options.Flag] = State end; Tween(Box, {BackgroundColor3 = State and Library.Theme.Accent or Library.Theme.Background}); Tween(Cir, {Position = UDim2.new(0, State and 17 or 2, 0.5, -8), BackgroundColor3 = State and Color3.new(1,1,1) or Library.Theme.TextDim}); options.Callback(State) end
        Btn.MouseButton1Click:Connect(function() Funcs:Set(not State) end)
        AddTooltip(Btn, options.Description)
        return Funcs
    end

    function El:AddSlider(options)
        local Val = options.Default or options.Min or 0; if options.Flag then Library.Flags[options.Flag] = Val end
        local Fr = Create("Frame", {Parent = Container, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(1, 0, 0, 45), ZIndex = 7}); AddCorner(Fr, 4)
        Create("TextLabel", {Parent = Fr, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 20), Font = Library.Theme.Font, Text = options.Title, TextColor3 = Library.Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 8})
        local Lbl = Create("TextLabel", {Parent = Fr, BackgroundTransparency = 1, Position = UDim2.new(1, -60, 0, 5), Size = UDim2.new(0, 50, 0, 20), Font = Library.Theme.FontBold, Text = tostring(Val), TextColor3 = Library.Theme.Accent, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 8})
        local Tr = Create("Frame", {Parent = Fr, BackgroundColor3 = Library.Theme.Background, Position = UDim2.new(0, 10, 0, 30), Size = UDim2.new(1, -20, 0, 6), ZIndex = 8}); AddCorner(Tr, 4)
        local Fil = Create("Frame", {Parent = Tr, BackgroundColor3 = Library.Theme.Accent, Size = UDim2.new((Val-options.Min)/(options.Max-options.Min), 0, 1, 0), ZIndex = 9}); AddCorner(Fil, 4)
        local Btn = Create("TextButton", {Parent = Tr, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "", ZIndex = 10})
        local Funcs = {}
        function Funcs:Set(num) Val = math.clamp(num, options.Min, options.Max); if options.Flag then Library.Flags[options.Flag] = Val end; Lbl.Text = tostring(Val); Tween(Fil, {Size = UDim2.new((Val-options.Min)/(options.Max-options.Min), 0, 1, 0)}, 0.05); options.Callback(Val) end
        local function Upd(i) local p = math.clamp((i.Position.X - Tr.AbsolutePosition.X) / Tr.AbsoluteSize.X, 0, 1); Funcs:Set(math.floor(options.Min + ((options.Max-options.Min)*p))) end
        local drag = false; Btn.InputBegan:Connect(function(i) if IsMouse(i) then drag = true; Upd(i) end end); UserInputService.InputEnded:Connect(function(i) if IsMouse(i) then drag = false end end); UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Upd(i) end end)
        AddTooltip(Fr, options.Description)
        return Funcs
    end

    function El:AddDropdown(options)
        local Sel = options.Default or options.Values[1]; if options.Flag then Library.Flags[options.Flag] = Sel end; local Exp = false
        local Fr = Create("Frame", {Parent = Container, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(1, 0, 0, 32), ClipsDescendants = true, ZIndex = 20}); AddCorner(Fr, 4)
        local Btn = Create("TextButton", {Parent = Fr, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), Text = "", AutoButtonColor = false, ZIndex = 21})
        Create("TextLabel", {Parent = Btn, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(0.6, 0, 1, 0), Font = Library.Theme.Font, Text = options.Title, TextColor3 = Library.Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 22})
        local Lbl = Create("TextLabel", {Parent = Btn, BackgroundTransparency = 1, Position = UDim2.new(0.6, 0, 0, 0), Size = UDim2.new(0.4, -10, 1, 0), Font = Library.Theme.FontBold, Text = tostring(Sel), TextColor3 = Library.Theme.Accent, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 22})
        local Li = Create("Frame", {Parent = Fr, BackgroundColor3 = Library.Theme.Background, Position = UDim2.new(0, 5, 0, 35), Size = UDim2.new(1, -10, 0, 0), ZIndex = 21}); AddCorner(Li, 4); Create("UIListLayout", {Parent = Li, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
        Btn.MouseButton1Click:Connect(function() Exp = not Exp; local H = Exp and math.clamp(#options.Values * 27, 0, 150) or 0
            if Exp then for _, v in pairs(Li:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end; for _, v in pairs(options.Values) do local I = Create("TextButton", {Parent = Li, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25), Font = Library.Theme.Font, Text = v, TextColor3 = (Sel == v) and Library.Theme.Accent or Library.Theme.TextDim, TextSize = 12, ZIndex = 22}); I.MouseButton1Click:Connect(function() Sel = v; if options.Flag then Library.Flags[options.Flag] = Sel end; Lbl.Text = Sel; Exp = false; Tween(Fr, {Size = UDim2.new(1, 0, 0, 32)}); Tween(Li, {Size = UDim2.new(1, -10, 0, 0)}); options.Callback(Sel) end) end end
            Tween(Li, {Size = UDim2.new(1, -10, 0, H)}); Tween(Fr, {Size = UDim2.new(1, 0, 0, Exp and H + 40 or 32)}) end)
        AddTooltip(Fr, options.Description)
    end

    return El
end

function Library:Window(options)
    local ScreenGui = Create("ScreenGui", {Name = "AuroraLib_v26", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 9999})
    local Main = Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Library.Theme.Background, Position = UDim2.new(0.5, -300, 0.5, -200), Size = UDim2.new(0, 600, 0, 400), ClipsDescendants = false, Visible = true}); AddCorner(Main, 8); AddStroke(Main, Library.Theme.Accent, 2)
    InitParticles(Main)

    -- Tooltip GUI
    TooltipFrame = Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Library.Theme.Background, Size = UDim2.new(0, 0, 0, 26), Visible = false, ZIndex = 100}); AddCorner(TooltipFrame, 4); AddStroke(TooltipFrame, Library.Theme.Border)
    TooltipLabel = Create("TextLabel", {Parent = TooltipFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 5, 0, 0), Text = "", Font = Library.Theme.Font, TextSize = 12, TextColor3 = Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 101})
    RunService.RenderStepped:Connect(function() if TooltipFrame.Visible then TooltipFrame.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y) end end)

    local MobileToggle = Create("ImageButton", {Parent = ScreenGui, BackgroundColor3 = Library.Theme.Background, Position = UDim2.new(0.1, 0, 0.1, 0), Size = UDim2.new(0, 50, 0, 50), Image = "rbxassetid://16447544078", Visible = true}); AddCorner(MobileToggle, 25); AddStroke(MobileToggle, Library.Theme.Accent, 2)
    local mDragging, mDragInput, mDragStart, mStartPos
    MobileToggle.InputBegan:Connect(function(i) if IsMouse(i) then mDragging = true; mDragStart = i.Position; mStartPos = MobileToggle.Position end end)
    MobileToggle.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then mDragInput = i end end)
    UserInputService.InputChanged:Connect(function(i) if i == mDragInput and mDragging then local d = i.Position - mDragStart; MobileToggle.Position = UDim2.new(mStartPos.X.Scale, mStartPos.X.Offset + d.X, mStartPos.Y.Scale, mStartPos.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if IsMouse(i) then mDragging = false end end)
    MobileToggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
    UserInputService.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end end)

    local Resizer = Create("TextButton", {Parent = Main, BackgroundTransparency = 1, AnchorPoint = Vector2.new(1,1), Position = UDim2.new(1, -5, 1, -5), Size = UDim2.new(0, 25, 0, 25), Text = "◢", TextColor3 = Library.Theme.Accent, TextSize = 20, ZIndex = 50})
    local Resizing, ResizeStart, StartSize
    Resizer.InputBegan:Connect(function(i) if IsMouse(i) then Resizing = true; ResizeStart = i.Position; StartSize = Main.AbsoluteSize end end)
    UserInputService.InputChanged:Connect(function(i) if Resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - ResizeStart; Main.Size = UDim2.new(0, math.max(400, StartSize.X + d.X), 0, math.max(300, StartSize.Y + d.Y)) end end)
    UserInputService.InputEnded:Connect(function(i) if IsMouse(i) then Resizing = false end end)

    local Topbar = Create("Frame", {Parent = Main, BackgroundColor3 = Library.Theme.Background, Size = UDim2.new(1, 0, 0, 40), ZIndex = 2}); AddCorner(Topbar, 8)
    Create("TextLabel", {Parent = Topbar, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 20, 0, 0), Font = Library.Theme.FontBold, Text = options.Title or "Library", TextColor3 = Library.Theme.Text, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3})
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
        local function Show() for _, v in pairs(PageArea:GetChildren()) do v.Visible = false end; for _, b in pairs(TabArea:GetChildren()) do if b:IsA("TextButton") then b.TextLabel.TextColor3 = Library.Theme.TextDim end end; Page.Visible = true; TabBtn.TextLabel.TextColor3 = Library.Theme.Text end
        TabBtn.MouseButton1Click:Connect(Show); if FirstTab then Show(); FirstTab = false end
        local TabObj = {}
        local FirstSub = true
        function TabObj:AddSubTab(SubName)
            SubTabBar.Visible = true; SubPages.Visible = true; MainContainer.Visible = false
            local SBtn = Create("TextButton", {Parent = SubTabBar, BackgroundColor3 = Library.Theme.ElementBG, Size = UDim2.new(0, 100, 1, 0), Text = SubName, TextColor3 = Library.Theme.TextDim, Font = Library.Theme.Font, TextSize = 12, AutoButtonColor = false}); AddCorner(SBtn, 4)
            local SPage = Create("ScrollingFrame", {Parent = SubPages, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, ScrollBarThickness=2, ScrollBarImageColor3=Library.Theme.Accent, Visible=false, ZIndex=5})
            local SLeft = Create("Frame", {Parent = SPage, BackgroundTransparency = 1, Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y}); Create("UIListLayout", {Parent = SLeft, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})
            local SRight = Create("Frame", {Parent = SPage, BackgroundTransparency = 1, Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.52, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y}); Create("UIListLayout", {Parent = SRight, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})
            local function OpenSub() for _, v in pairs(SubPages:GetChildren()) do v.Visible = false end; for _, b in pairs(SubTabBar:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Library.Theme.TextDim; b.BackgroundColor3 = Library.Theme.ElementBG end end; SPage.Visible = true; SBtn.TextColor3 = Library.Theme.Accent; SBtn.BackgroundColor3 = Library.Theme.SectionBG end
            SBtn.MouseButton1Click:Connect(OpenSub); if FirstSub then OpenSub(); FirstSub = false end
            local SubObj = {}
            function SubObj:AddGroup(opt) return Library:CreateSection((opt.Side == "Right" and SRight) or SLeft, opt.Title) end
            return SubObj
        end
        function TabObj:AddGroup(opt) return Library:CreateSection((opt.Side == "Right" and Right) or Left, opt.Title) end
        return TabObj
    end
    return WindowObj
end
