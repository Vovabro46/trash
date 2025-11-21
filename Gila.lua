--[[
    GILA MONSTER [IMGUI REBORN v17]
    
    [FIXES]
    - Mobile ColorPicker: Added "DONE" button to close.
    - Dropdowns: Now use "Push" layout (Accordion) so items are always visible.
    - ZIndex: Fixed layering issues.
    
    [NEW FEATURES]
    - ImGui Style Elements: Label, Paragraph, Keybind.
    - Feature List (Watermark & Keybind List on screen).
    - Notification System (Stacking).
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")

--// 1. SETTINGS & DETECTION
local Device = "PC"
local Camera = workspace.CurrentCamera
if Camera.ViewportSize.X < 600 then Device = "Mobile" end

local Library = {
    Open = true,
    Theme = {
        Main = Color3.fromRGB(20, 20, 25),
        Header = Color3.fromRGB(25, 25, 30),
        Sidebar = Color3.fromRGB(23, 23, 28),
        Section = Color3.fromRGB(28, 28, 33),
        Element = Color3.fromRGB(32, 32, 38),
        Text = Color3.fromRGB(240, 240, 240),
        DimText = Color3.fromRGB(140, 140, 140),
        Accent = Color3.fromRGB(120, 100, 255),
        Border = Color3.fromRGB(45, 45, 50),
    },
    Registry = {},
    ActiveBinds = {} -- For Keybind List
}

--// 2. UTILITIES
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do if k ~= "Parent" then obj[k] = v end end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end

local function Tween(obj, time, props)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function Drag(frame, hold)
    if Device == "Mobile" then return end
    local dragging, dragInput, dragStart, startPos
    hold.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    hold.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(frame, 0.05, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)})
        end
    end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

local function UpdateTheme()
    for obj, propData in pairs(Library.Registry) do
        if obj.Parent then
            Tween(obj, 0.3, {[propData.Prop] = Library.Theme[propData.Key]})
        else
            Library.Registry[obj] = nil
        end
    end
end

local function Reg(obj, prop, key)
    Library.Registry[obj] = {Prop = prop, Key = key}
    obj[prop] = Library.Theme[key]
end

--// 3. UI COMPONENTS
function Library:Window(opts)
    local Name = opts.Name or "GILA IMGUI"
    if CoreGui:FindFirstChild("GilaMain") then CoreGui.GilaMain:Destroy() end
    
    local Screen = Create("ScreenGui", {Name = "GilaMain", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    local Scale = Create("UIScale", {Parent = Screen, Scale = Device == "Mobile" and 1.1 or 1.0})

    -->> WATERMARK
    local Watermark = Create("Frame", {
        Parent = Screen, Size = UDim2.new(0, 200, 0, 22), Position = UDim2.new(0.01, 0, 0.01, 0),
        BackgroundColor3 = Library.Theme.Main, AutomaticSize = Enum.AutomaticSize.X
    })
    Reg(Watermark, "BackgroundColor3", "Main")
    Create("UICorner", {Parent = Watermark, CornerRadius = UDim.new(0, 4)})
    Create("UIStroke", {Parent = Watermark, Color = Library.Theme.Accent}); Reg(Watermark.UIStroke, "Color", "Accent")
    local WText = Create("TextLabel", {
        Parent = Watermark, Text = "GILA | FPS: 0", TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamBold,
        TextSize = 12, BackgroundTransparency = 1, Size = UDim2.new(0,0,1,0), AutomaticSize = Enum.AutomaticSize.X
    }); Reg(WText, "TextColor3", "Text")
    Create("UIPadding", {Parent = Watermark, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})
    
    spawn(function()
        while Screen.Parent do
            local fps = math.floor(workspace:GetRealPhysicsFPS())
            WText.Text = string.format("%s | FPS: %s | %s", Name, fps, os.date("%X"))
            wait(1)
        end
    end)

    -->> MAIN FRAME
    local Main = Create("Frame", {
        Parent = Screen, BackgroundColor3 = Library.Theme.Main,
        Size = Device == "Mobile" and UDim2.new(0.9, 0, 0.8, 0) or UDim2.new(0, 650, 0, 450),
        Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), ClipsDescendants = true
    })
    Reg(Main, "BackgroundColor3", "Main")
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 6)})
    Create("UIStroke", {Parent = Main, Color = Library.Theme.Border})

    -- Header
    local Top = Create("Frame", {Parent = Main, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Library.Theme.Header, ZIndex = 2})
    Reg(Top, "BackgroundColor3", "Header")
    local TitleL = Create("TextLabel", {
        Parent = Top, Text = Name, Font = Enum.Font.GothamBlack, TextSize = 14, TextColor3 = Library.Theme.Text,
        Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
    })
    Reg(TitleL, "TextColor3", "Text")
    
    if Device == "Mobile" then
        local Close = Create("TextButton", {Parent = Top, Text = "X", Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(1, -40, 0, 0), BackgroundTransparency = 1, TextColor3 = Color3.new(1,1,1)})
        Close.MouseButton1Click:Connect(function() Library.Open = false; Main.Visible = false end)
    end
    Drag(Main, Top)

    -- Layout
    local Sidebar = Create("ScrollingFrame", {
        Parent = Main, Size = Device == "Mobile" and UDim2.new(0, 60, 1, -40) or UDim2.new(0, 150, 1, -40),
        Position = UDim2.new(0, 0, 0, 40), BackgroundColor3 = Library.Theme.Sidebar, ScrollBarThickness = 0
    }); Reg(Sidebar, "BackgroundColor3", "Sidebar")
    Create("UIListLayout", {Parent = Sidebar, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    Create("UIPadding", {Parent = Sidebar, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10)})

    local PageHolder = Create("Frame", {
        Parent = Main, Size = Device == "Mobile" and UDim2.new(1, -60, 1, -40) or UDim2.new(1, -150, 1, -40),
        Position = Device == "Mobile" and UDim2.new(0, 60, 0, 40) or UDim2.new(0, 150, 0, 40), BackgroundTransparency = 1
    })

    -- Mobile Toggle
    local Sphere = Create("ImageButton", {
        Parent = Screen, Image = "rbxassetid://6031091000", BackgroundColor3 = Library.Theme.Main,
        Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 30, 0, 50), ImageColor3 = Library.Theme.Accent, ZIndex = 100
    })
    Reg(Sphere, "BackgroundColor3", "Main"); Reg(Sphere, "ImageColor3", "Accent")
    Create("UICorner", {Parent = Sphere, CornerRadius = UDim.new(1, 0)})
    Create("UIStroke", {Parent = Sphere, Color = Library.Theme.Accent, Thickness = 2})
    Sphere.MouseButton1Click:Connect(function() Library.Open = not Library.Open; Main.Visible = Library.Open end)

    -- NOTIFICATIONS
    local NotifArea = Create("Frame", {Parent = Screen, Size = UDim2.new(0, 250, 1, 0), Position = UDim2.new(1, -260, 0, 0), BackgroundTransparency = 1})
    Create("UIListLayout", {Parent = NotifArea, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 5)})

    function Library:Notify(t, m, d)
        local F = Create("Frame", {Parent = NotifArea, BackgroundColor3 = Library.Theme.Main, Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 0.1})
        Reg(F, "BackgroundColor3", "Main")
        Create("UICorner", {Parent = F, CornerRadius = UDim.new(0, 4)})
        Create("UIStroke", {Parent = F, Color = Library.Theme.Accent}); Reg(F.UIStroke, "Color", "Accent")
        Create("TextLabel", {Parent = F, Text = t, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Library.Theme.Accent, Size = UDim2.new(1, -10, 0, 20), Position = UDim2.new(0, 10, 0, 2), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left})
        Create("TextLabel", {Parent = F, Text = m, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Library.Theme.Text, Size = UDim2.new(1, -10, 0, 20), Position = UDim2.new(0, 10, 0, 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left})
        task.delay(d or 3, function() F:Destroy() end)
    end

    -- TABS
    local Tabs = {}
    local First = true

    function Tabs:Tab(name, icon)
        local TabBtn = Create("TextButton", {
            Parent = Sidebar, Size = Device == "Mobile" and UDim2.new(1, -10, 0, 40) or UDim2.new(1, -10, 0, 30),
            BackgroundColor3 = Library.Theme.Main, Text = Device == "Mobile" and "" or "  "..name,
            TextColor3 = Library.Theme.DimText, Font = Enum.Font.GothamBold, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false
        })
        Reg(TabBtn, "TextColor3", "DimText")
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 4)})
        if Device == "Mobile" and icon then
            local I = Create("ImageLabel", {Parent = TabBtn, Image = icon, BackgroundTransparency = 1, Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0.5, -12, 0.5, -12), ImageColor3 = Library.Theme.DimText})
            Reg(I, "ImageColor3", "DimText")
        end

        local Page = Create("ScrollingFrame", {
            Parent = PageHolder, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false,
            ScrollBarThickness = 2, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0)
        })
        local Layout = Create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})
        Create("UIPadding", {Parent = Page, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then Tween(v, 0.2, {TextColor3 = Library.Theme.DimText, BackgroundColor3 = Library.Theme.Main}) end end
            for _, v in pairs(PageHolder:GetChildren()) do v.Visible = false end
            Tween(TabBtn, 0.2, {TextColor3 = Library.Theme.Accent, BackgroundColor3 = Library.Theme.Element})
            Page.Visible = true
        end)
        if First then First = false; TabBtn:Fire() end

        local Sections = {}
        function Sections:Section(title)
            local Sec = Create("Frame", {
                Parent = Page, BackgroundColor3 = Library.Theme.Section, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y
            })
            Reg(Sec, "BackgroundColor3", "Section")
            Create("UICorner", {Parent = Sec, CornerRadius = UDim.new(0, 4)})
            
            Create("TextLabel", {
                Parent = Sec, Text = title:upper(), TextColor3 = Library.Theme.Accent, Font = Enum.Font.GothamBold,
                TextSize = 11, Size = UDim2.new(1, -10, 0, 25), Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            }); 
            
            local Cont = Create("Frame", {
                Parent = Sec, Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 25),
                BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y
            })
            Create("UIListLayout", {Parent = Cont, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
            Create("UIPadding", {Parent = Cont, PaddingBottom = UDim.new(0, 8)})

            local El = {}
            
            function El:Label(t)
                local L = Create("TextLabel", {Parent = Cont, Text = t, TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left})
                Reg(L, "TextColor3", "Text")
            end

            function El:Paragraph(h, d)
                local F = Create("Frame", {Parent = Cont, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y})
                local H = Create("TextLabel", {Parent = F, Text = h, TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12, Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left})
                Reg(H, "TextColor3", "Text")
                local D = Create("TextLabel", {Parent = F, Text = d, TextColor3 = Library.Theme.DimText, Font = Enum.Font.Gotham, TextSize = 11, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 15), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y})
                Reg(D, "TextColor3", "DimText")
                Create("UIPadding", {Parent = F, PaddingBottom = UDim.new(0, 5)})
            end

            function El:Button(t, cb)
                local B = Create("TextButton", {Parent = Cont, Text = t, BackgroundColor3 = Library.Theme.Element, TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12, Size = UDim2.new(1, 0, 0, 30)})
                Reg(B, "BackgroundColor3", "Element"); Reg(B, "TextColor3", "Text")
                Create("UICorner", {Parent = B, CornerRadius = UDim.new(0, 4)})
                B.MouseButton1Click:Connect(cb)
            end

            function El:Toggle(t, def, cb)
                local s = def or false
                local B = Create("TextButton", {Parent = Cont, Text = "", BackgroundColor3 = Library.Theme.Element, Size = UDim2.new(1, 0, 0, 30)})
                Reg(B, "BackgroundColor3", "Element"); Create("UICorner", {Parent = B, CornerRadius = UDim.new(0, 4)})
                local L = Create("TextLabel", {Parent = B, Text = t, TextColor3 = Library.Theme.DimText, Font = Enum.Font.Gotham, TextSize = 12, Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left})
                Reg(L, "TextColor3", "DimText")
                local Box = Create("Frame", {Parent = B, Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -25, 0.5, -9), BackgroundColor3 = Library.Theme.Main})
                Reg(Box, "BackgroundColor3", "Main"); Create("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 4)})
                local Fill = Create("Frame", {Parent = Box, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Library.Theme.Accent, BackgroundTransparency = 1})
                Reg(Fill, "BackgroundColor3", "Accent"); Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(0, 4)})
                
                local function Upd()
                    Tween(Fill, 0.2, {BackgroundTransparency = s and 0 or 1})
                    Tween(L, 0.2, {TextColor3 = s and Library.Theme.Text or Library.Theme.DimText})
                    if cb then cb(s) end
                end
                B.MouseButton1Click:Connect(function() s = not s; Upd() end)
                if def then Upd() end
            end

            function El:Slider(t, min, max, def, cb)
                local v = def or min
                local F = Create("Frame", {Parent = Cont, BackgroundColor3 = Library.Theme.Element, Size = UDim2.new(1, 0, 0, 40)})
                Reg(F, "BackgroundColor3", "Element"); Create("UICorner", {Parent = F, CornerRadius = UDim.new(0, 4)})
                local L = Create("TextLabel", {Parent = F, Text = t, TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, Position = UDim2.new(0, 10, 0, 5), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left})
                Reg(L, "TextColor3", "Text")
                local VL = Create("TextLabel", {Parent = F, Text = tostring(v), TextColor3 = Library.Theme.DimText, Font = Enum.Font.GothamBold, TextSize = 12, Size = UDim2.new(1, -10, 0, 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Right})
                Reg(VL, "TextColor3", "DimText")
                local Bar = Create("Frame", {Parent = F, BackgroundColor3 = Library.Theme.Main, Size = UDim2.new(1, -20, 0, 4), Position = UDim2.new(0, 10, 0, 28)})
                Reg(Bar, "BackgroundColor3", "Main"); Create("UICorner", {Parent = Bar, CornerRadius = UDim.new(0, 2)})
                local Fill = Create("Frame", {Parent = Bar, BackgroundColor3 = Library.Theme.Accent, Size = UDim2.new((v-min)/(max-min), 0, 1, 0)})
                Reg(Fill, "BackgroundColor3", "Accent"); Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(0, 2)})
                local Btn = Create("TextButton", {Parent = F, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""})
                
                local function Move(input)
                    local p = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    v = math.floor(min + ((max-min)*p))
                    Fill.Size = UDim2.new(p, 0, 1, 0); VL.Text = tostring(v)
                    if cb then cb(v) end
                end
                local drag
                Btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true; Move(i) end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
                UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Move(i) end end)
            end

            function El:Dropdown(t, opts, def, cb)
                local open = false; local sel = def or opts[1]
                local F = Create("Frame", {Parent = Cont, BackgroundColor3 = Library.Theme.Element, Size = UDim2.new(1, 0, 0, 30), ClipsDescendants = true})
                Reg(F, "BackgroundColor3", "Element"); Create("UICorner", {Parent = F, CornerRadius = UDim.new(0, 4)})
                local L = Create("TextLabel", {Parent = F, Text = t..": "..sel, TextColor3 = Library.Theme.DimText, Font = Enum.Font.Gotham, TextSize = 12, Size = UDim2.new(1, -25, 0, 30), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left})
                Reg(L, "TextColor3", "DimText")
                local Arrow = Create("ImageLabel", {Parent = F, Image = "rbxassetid://6031091304", BackgroundTransparency = 1, Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -20, 0, 7), ImageColor3 = Library.Theme.DimText})
                Reg(Arrow, "ImageColor3", "DimText")
                local Btn = Create("TextButton", {Parent = F, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), Text = ""})
                local List = Create("Frame", {Parent = F, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 30)})
                local Layout = Create("UIListLayout", {Parent = List, SortOrder = Enum.SortOrder.LayoutOrder})
                
                for _, o in pairs(opts) do
                    local B = Create("TextButton", {Parent = List, BackgroundColor3 = Library.Theme.Main, TextColor3 = Library.Theme.DimText, Text = "  "..o, Font = Enum.Font.Gotham, TextSize = 12, Size = UDim2.new(1, 0, 0, 25), TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false})
                    Reg(B, "BackgroundColor3", "Main"); Reg(B, "TextColor3", "DimText")
                    B.MouseButton1Click:Connect(function()
                        sel = o; L.Text = t..": "..sel; open = false
                        Tween(F, 0.2, {Size = UDim2.new(1, 0, 0, 30)})
                        if cb then cb(o) end
                    end)
                end
                Btn.MouseButton1Click:Connect(function()
                    open = not open
                    local h = open and (30 + (#opts * 25)) or 30
                    Tween(F, 0.2, {Size = UDim2.new(1, 0, 0, h)})
                end)
            end

            function El:ColorPicker(t, def, cb)
                local F = Create("Frame", {Parent = Cont, BackgroundColor3 = Library.Theme.Element, Size = UDim2.new(1, 0, 0, 30)})
                Reg(F, "BackgroundColor3", "Element"); Create("UICorner", {Parent = F, CornerRadius = UDim.new(0, 4)})
                local L = Create("TextLabel", {Parent = F, Text = t, TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left})
                Reg(L, "TextColor3", "Text")
                local Prev = Create("TextButton", {Parent = F, BackgroundColor3 = def, Text = "", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -25, 0.5, -10)})
                Create("UICorner", {Parent = Prev, CornerRadius = UDim.new(0, 4)})
                
                -- POPUP
                local Pop = Create("Frame", {Parent = Screen, BackgroundColor3 = Library.Theme.Main, Size = UDim2.new(0, 200, 0, 210), Visible = false, ZIndex = 1000, Position = UDim2.new(0.5, -100, 0.5, -100)})
                Reg(Pop, "BackgroundColor3", "Main"); Create("UICorner", {Parent = Pop, CornerRadius = UDim.new(0, 6)}); Create("UIStroke", {Parent = Pop, Color = Library.Theme.Border})
                local SV = Create("ImageButton", {Parent = Pop, Image = "rbxassetid://4155801252", BackgroundColor3 = Color3.new(1,0,0), Size = UDim2.new(1, -20, 0, 130), Position = UDim2.new(0, 10, 0, 10), ZIndex = 1001})
                local Hue = Create("ImageButton", {Parent = Pop, Image = "rbxassetid://4013607203", Size = UDim2.new(1, -20, 0, 15), Position = UDim2.new(0, 10, 0, 150), ZIndex = 1001})
                
                -- CLOSE BUTTON (FIX FOR MOBILE)
                local DoneBtn = Create("TextButton", {Parent = Pop, Text = "DONE", BackgroundColor3 = Library.Theme.Element, TextColor3 = Library.Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 12, Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 1, -35), ZIndex = 1001})
                Reg(DoneBtn, "BackgroundColor3", "Element"); Reg(DoneBtn, "TextColor3", "Accent"); Create("UICorner", {Parent = DoneBtn, CornerRadius = UDim.new(0, 4)})
                DoneBtn.MouseButton1Click:Connect(function() Pop.Visible = false end)

                local h,s,v = Color3.toHSV(def)
                local function Upd()
                    local c = Color3.fromHSV(h, s, v); Prev.BackgroundColor3 = c; SV.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    if cb then cb(c) end
                end
                
                local down
                local function Input(i, box)
                    if down then
                        local m = UserInputService:GetMouseLocation()
                        if box == Hue then
                            h = math.clamp((m.X - Hue.AbsolutePosition.X) / Hue.AbsoluteSize.X, 0, 1)
                        else
                            s = math.clamp((m.X - SV.AbsolutePosition.X) / SV.AbsoluteSize.X, 0, 1)
                            v = 1 - math.clamp((m.Y - SV.AbsolutePosition.Y) / SV.AbsoluteSize.Y, 0, 1)
                        end
                        Upd()
                    end
                end
                
                SV.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then down=true; Input(i, SV) end end)
                Hue.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then down=true; Input(i, Hue) end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then down=false end end)
                UserInputService.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then Input(i, (i.Position.Y > Hue.AbsolutePosition.Y - 10) and Hue or SV) end end)
                
                Prev.MouseButton1Click:Connect(function() Pop.Visible = not Pop.Visible end)
            end

            function El:Keybind(t, def, cb)
                local F = Create("Frame", {Parent = Cont, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30)})
                Create("TextLabel", {Parent = F, Text = t, TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, Size = UDim2.new(1, -60, 1, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left})
                local B = Create("TextButton", {Parent = F, Text = tostring(def):gsub("Enum.KeyCode.", ""), BackgroundColor3 = Library.Theme.Element, TextColor3 = Library.Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, Size = UDim2.new(0, 60, 1, 0), Position = UDim2.new(1, -60, 0, 0)})
                Reg(B, "BackgroundColor3", "Element"); Reg(B, "TextColor3", "Accent"); Create("UICorner", {Parent = B, CornerRadius = UDim.new(0, 4)})
                
                local key = def; local wait = false
                B.MouseButton1Click:Connect(function() wait = true; B.Text = "..." end)
                UserInputService.InputBegan:Connect(function(i)
                    if wait and i.KeyCode ~= Enum.KeyCode.Unknown then
                        key = i.KeyCode; wait = false; B.Text = tostring(key):gsub("Enum.KeyCode.", "")
                        if cb then cb(key) end
                    end
                end)
            end

            return El
        end
        return Sections
    end
    return Tabs
end

return Library
