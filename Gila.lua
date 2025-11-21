--[[
    GILA MONSTER [OMNITRIX EDITION v13]
    Build: Professional / Auto-Scaling / OOP
    
    [FEATURES]
    - Auto-Device Detection (PC/Mobile/Tablet)
    - Dynamic Scaling (UIScale)
    - Fixing "Empty Tabs" bug (Robust Layout Engine)
    - Advanced ColorPicker, Keybinds, Searchable Dropdowns
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")

--// [DEVICE DETECTION]
local Camera = workspace.CurrentCamera
local DeviceType = "PC"
local BaseScale = 1.0

local function CheckDevice()
    local Viewport = Camera.ViewportSize
    if Viewport.X < 600 then
        DeviceType = "Mobile"
        BaseScale = 1.1 -- Увеличиваем для пальцев
    elseif Viewport.X < 1100 then
        DeviceType = "Tablet"
        BaseScale = 0.9
    else
        DeviceType = "PC"
        BaseScale = 1.0
    end
end
CheckDevice()

--// [LIBRARY ROOT]
local Library = {
    Version = "13.0 Omnitrix",
    Open = true,
    Scale = BaseScale,
    Theme = {
        Main      = Color3.fromRGB(18, 18, 22),
        Sidebar   = Color3.fromRGB(22, 22, 26),
        Section   = Color3.fromRGB(26, 26, 32),
        Element   = Color3.fromRGB(32, 32, 38),
        Accent    = Color3.fromRGB(115, 100, 255),
        Text      = Color3.fromRGB(240, 240, 240),
        DimText   = Color3.fromRGB(130, 130, 130),
        Border    = Color3.fromRGB(45, 45, 55),
        Outline   = Color3.fromRGB(10, 10, 10)
    },
    ActiveObjects = {}
}

--// [UTILITIES]
local Utils = {}
function Utils:Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

function Utils:Tween(obj, time, props)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

function Utils:Drag(frame, hold)
    if DeviceType == "Mobile" then return end -- На телефоне окно фиксировано (обычно)
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
            Utils:Tween(frame, 0.05, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)})
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

--// [THEME MANAGER]
function Library:UpdateColors()
    for obj, props in pairs(Library.ActiveObjects) do
        if obj and obj.Parent then -- Check exist
            for prop, themeKey in pairs(props) do
                Utils:Tween(obj, 0.3, {[prop] = Library.Theme[themeKey]})
            end
        else
            Library.ActiveObjects[obj] = nil
        end
    end
end

function Library:Register(obj, prop, themeKey)
    if not Library.ActiveObjects[obj] then Library.ActiveObjects[obj] = {} end
    Library.ActiveObjects[obj][prop] = themeKey
    obj[prop] = Library.Theme[themeKey] -- Apply instant
end

function Library:SetTheme(newTheme)
    for k, v in pairs(newTheme) do Library.Theme[k] = v end
    Library:UpdateColors()
end

--// [UI ELEMENTS CLASS]
local Elements = {}
Elements.__index = Elements

function Elements.new(section, title)
    local self = setmetatable({}, Elements)
    self.Section = section
    return self
end

--// [WINDOW SYSTEM]
function Library:Window(opts)
    local WinName = opts.Name or "GILA OMNITRIX"
    -- Auto size logic
    local WinSize = (DeviceType == "Mobile") and UDim2.new(0.9, 0, 0.8, 0) or UDim2.new(0, 650, 0, 450)
    local WinPos = (DeviceType == "Mobile") and UDim2.new(0.5, -WinSize.X.Scale/2, 0.5, -WinSize.Y.Scale/2) or UDim2.new(0.5, -325, 0.5, -225)

    local Screen = Utils:Create("ScreenGui", {Name = "GilaUI", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    
    -- UI Scale Wrapper (Для адаптации под телефоны)
    local Scaler = Utils:Create("UIScale", {Parent = Screen, Scale = Library.Scale})
    
    -- Auto-update scale on screen resize
    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        CheckDevice()
        Scaler.Scale = Library.Scale
    end)

    -- Main Frame
    local Main = Utils:Create("Frame", {
        Parent = Screen, Size = WinSize, Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Library.Theme.Main, ClipsDescendants = true
    })
    Library:Register(Main, "BackgroundColor3", "Main")
    Utils:Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 6)})
    Utils:Create("UIStroke", {Parent = Main, Color = Library.Theme.Outline, Thickness = 1})

    -- Header
    local TopBar = Utils:Create("Frame", {
        Parent = Main, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Library.Theme.Sidebar, ZIndex = 5
    })
    Library:Register(TopBar, "BackgroundColor3", "Sidebar")
    
    local Title = Utils:Create("TextLabel", {
        Parent = TopBar, Text = WinName, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(0, 200, 1, 0),
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Library.Theme.Text
    })
    Library:Register(Title, "TextColor3", "Text")

    -- Close Button (Essential for Mobile)
    local CloseBtn = Utils:Create("TextButton", {
        Parent = TopBar, Text = "X", Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(1, -40, 0, 0),
        BackgroundTransparency = 1, TextColor3 = Library.Theme.DimText, Font = Enum.Font.GothamBold
    })
    CloseBtn.MouseButton1Click:Connect(function()
        Library.Open = not Library.Open
        Main.Visible = Library.Open
    end)

    Utils:Drag(Main, TopBar)

    -- Container Layout
    local Sidebar = Utils:Create("ScrollingFrame", {
        Parent = Main, Size = (DeviceType=="Mobile" and UDim2.new(0, 60, 1, -40) or UDim2.new(0, 160, 1, -40)),
        Position = UDim2.new(0, 0, 0, 40), BackgroundColor3 = Library.Theme.Sidebar,
        ScrollBarThickness = 0, BorderSizePixel = 0
    })
    Library:Register(Sidebar, "BackgroundColor3", "Sidebar")
    
    local SideList = Utils:Create("UIListLayout", {Parent = Sidebar, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    Utils:Create("UIPadding", {Parent = Sidebar, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10)})

    local PageContainer = Utils:Create("Frame", {
        Parent = Main, Size = (DeviceType=="Mobile" and UDim2.new(1, -60, 1, -40) or UDim2.new(1, -160, 1, -40)),
        Position = (DeviceType=="Mobile" and UDim2.new(0, 60, 0, 40) or UDim2.new(0, 160, 0, 40)),
        BackgroundTransparency = 1
    })

    -- Mobile Toggle Button
    local MobTog = Utils:Create("ImageButton", {
        Parent = Screen, Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = Library.Theme.Main, Image = "rbxassetid://6031091000",
        ImageColor3 = Library.Theme.Accent, Active = true
    })
    Library:Register(MobTog, "BackgroundColor3", "Main"); Library:Register(MobTog, "ImageColor3", "Accent")
    Utils:Create("UICorner", {Parent = MobTog, CornerRadius = UDim.new(0, 12)})
    Utils:Create("UIStroke", {Parent = MobTog, Color = Library.Theme.Accent, Thickness = 2})
    
    -- Draggable Mobile Button
    local dragging, dragStart, startPos
    MobTog.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = MobTog.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            MobTog.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    MobTog.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end end)
    
    MobTog.MouseButton1Click:Connect(function()
        Library.Open = not Library.Open
        Main.Visible = Library.Open
    end)

    -- TABS LOGIC
    local Tabs = {}
    local firstTab = true

    function Tabs:Tab(name, icon)
        local TabObj = {}
        
        local TabBtn = Utils:Create("TextButton", {
            Parent = Sidebar, Size = (DeviceType=="Mobile" and UDim2.new(1, -10, 0, 40) or UDim2.new(1, -10, 0, 32)),
            BackgroundColor3 = Library.Theme.Main, Text = (DeviceType=="Mobile" and "" or "  "..name),
            TextColor3 = Library.Theme.DimText, Font = Enum.Font.GothamBold, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false
        })
        Library:Register(TabBtn, "TextColor3", "DimText")
        Utils:Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 4)})
        
        if DeviceType == "Mobile" then
            -- Icon for mobile
            local Ico = Utils:Create("ImageLabel", {
                Parent = TabBtn, Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0.5, -12, 0.5, -12),
                BackgroundTransparency = 1, Image = icon or "rbxassetid://6031225819",
                ImageColor3 = Library.Theme.DimText
            })
            Library:Register(Ico, "ImageColor3", "DimText")
        end

        local TabPage = Utils:Create("ScrollingFrame", {
            Parent = PageContainer, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Visible = false, ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,0,0)
        })
        
        -- COLUMNS SYSTEM (Auto-Adjust for Mobile)
        local LeftCol = Utils:Create("Frame", {
            Parent = TabPage, BackgroundTransparency = 1,
            Size = (DeviceType=="Mobile" and UDim2.new(0.96, 0, 0, 0) or UDim2.new(0.48, 0, 0, 0)),
            Position = UDim2.new(0.02, 0, 0, 10), AutomaticSize = Enum.AutomaticSize.Y
        })
        local RightCol = Utils:Create("Frame", {
            Parent = TabPage, BackgroundTransparency = 1,
            Size = (DeviceType=="Mobile" and UDim2.new(0.96, 0, 0, 0) or UDim2.new(0.48, 0, 0, 0)),
            Position = (DeviceType=="Mobile" and UDim2.new(0.02, 0, 0, 0) or UDim2.new(0.51, 0, 0, 10)),
            AutomaticSize = Enum.AutomaticSize.Y
        })
        
        local LList = Utils:Create("UIListLayout", {Parent = LeftCol, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12)})
        local RList = Utils:Create("UIListLayout", {Parent = RightCol, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12)})
        
        -- Fix: Mobile needs RightCol below LeftCol
        if DeviceType == "Mobile" then
            -- We use a main Layout for the Page
            local PageLayout = Utils:Create("UIListLayout", {Parent = TabPage, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12)})
            -- Force update CanvasSize
            PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
            end)
        else
            -- PC Canvas Calculation
            TabPage.ChildAdded:Connect(function()
                local max = math.max(LList.AbsoluteContentSize.Y, RList.AbsoluteContentSize.Y)
                TabPage.CanvasSize = UDim2.new(0, 0, 0, max + 20)
            end)
        end

        local function Show()
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    Utils:Tween(v, 0.2, {TextColor3 = Library.Theme.DimText, BackgroundColor3 = Library.Theme.Main})
                    if v:FindFirstChild("ImageLabel") then Utils:Tween(v.ImageLabel, 0.2, {ImageColor3 = Library.Theme.DimText}) end
                end
            end
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            
            Utils:Tween(TabBtn, 0.2, {TextColor3 = Library.Theme.Accent, BackgroundColor3 = Library.Theme.Element})
            if TabBtn:FindFirstChild("ImageLabel") then Utils:Tween(TabBtn.ImageLabel, 0.2, {ImageColor3 = Library.Theme.Accent}) end
            TabPage.Visible = true
        end
        
        TabBtn.MouseButton1Click:Connect(Show)
        if firstTab then firstTab = false; Show() end

        function TabObj:Section(title, side)
            local Parent = (side == "Right" and RightCol or LeftCol)
            
            local SecFrame = Utils:Create("Frame", {
                Parent = Parent, BackgroundColor3 = Library.Theme.Section,
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y -- IMPORTANT
            })
            Library:Register(SecFrame, "BackgroundColor3", "Section")
            Utils:Create("UICorner", {Parent = SecFrame, CornerRadius = UDim.new(0, 6)})
            Utils:Create("UIStroke", {Parent = SecFrame, Color = Library.Theme.Border})
            
            -- Title
            local Lab = Utils:Create("TextLabel", {
                Parent = SecFrame, Text = title, TextColor3 = Library.Theme.Accent,
                Font = Enum.Font.GothamBold, TextSize = 12, Size = UDim2.new(1, -20, 0, 25),
                Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            Library:Register(Lab, "TextColor3", "Accent")
            
            -- Content Holder
            local ContentBox = Utils:Create("Frame", {
                Parent = SecFrame, Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 30),
                BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y
            })
            local List = Utils:Create("UIListLayout", {Parent = ContentBox, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)})
            Utils:Create("UIPadding", {Parent = ContentBox, PaddingBottom = UDim.new(0, 10)})

            -- ELEMENTS
            local El = {}
            
            function El:Toggle(text, def, cb)
                local s = def or false
                local Btn = Utils:Create("TextButton", {
                    Parent = ContentBox, Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Library.Theme.Element,
                    Text = "", AutoButtonColor = false
                })
                Library:Register(Btn, "BackgroundColor3", "Element")
                Utils:Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 4)})
                
                local Lb = Utils:Create("TextLabel", {
                    Parent = Btn, Text = text, TextColor3 = Library.Theme.DimText, Font = Enum.Font.Gotham,
                    TextSize = 13, Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
                })
                Library:Register(Lb, "TextColor3", "DimText")
                
                local Box = Utils:Create("Frame", {
                    Parent = Btn, Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -30, 0.5, -10),
                    BackgroundColor3 = Library.Theme.Main
                }); Library:Register(Box, "BackgroundColor3", "Main")
                Utils:Create("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 4)})
                
                local Fill = Utils:Create("Frame", {
                    Parent = Box, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Library.Theme.Accent,
                    BackgroundTransparency = 1
                }); Library:Register(Fill, "BackgroundColor3", "Accent")
                Utils:Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(0, 4)})
                
                local function Upd()
                    Utils:Tween(Fill, 0.2, {BackgroundTransparency = s and 0 or 1})
                    Utils:Tween(Lb, 0.2, {TextColor3 = s and Library.Theme.Text or Library.Theme.DimText})
                    if cb then cb(s) end
                end
                Btn.MouseButton1Click:Connect(function() s = not s; Upd() end)
                if def then Upd() end
            end
            
            function El:Slider(text, min, max, def, cb)
                local s_val = def or min
                local Frame = Utils:Create("Frame", {
                    Parent = ContentBox, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Library.Theme.Element
                }); Library:Register(Frame, "BackgroundColor3", "Element")
                Utils:Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 4)})
                
                local Lb = Utils:Create("TextLabel", {
                    Parent = Frame, Text = text, TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham,
                    TextSize = 13, Position = UDim2.new(0, 10, 0, 5), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
                }); Library:Register(Lb, "TextColor3", "Text")
                
                local ValLb = Utils:Create("TextLabel", {
                    Parent = Frame, Text = tostring(s_val), TextColor3 = Library.Theme.DimText, Font = Enum.Font.GothamBold,
                    TextSize = 13, Size=UDim2.new(1,-20,0,20), Position=UDim2.new(0,0,0,5), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local Bar = Utils:Create("Frame", {
                    Parent = Frame, Size = UDim2.new(1, -20, 0, 4), Position = UDim2.new(0, 10, 0, 28),
                    BackgroundColor3 = Library.Theme.Main
                }); Library:Register(Bar, "BackgroundColor3", "Main")
                Utils:Create("UICorner", {Parent = Bar, CornerRadius = UDim.new(0, 2)})
                
                local Fill = Utils:Create("Frame", {
                    Parent = Bar, Size = UDim2.new((s_val-min)/(max-min), 0, 1, 0), BackgroundColor3 = Library.Theme.Accent
                }); Library:Register(Fill, "BackgroundColor3", "Accent")
                
                local Trig = Utils:Create("TextButton", {Parent = Frame, Size = UDim2.new(1,0,1,0), BackgroundTransparency=1, Text=""})
                
                Trig.MouseButton1Down:Connect(function()
                    local c = RunService.RenderStepped:Connect(function()
                        local p = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        local v = math.floor(min + ((max-min)*p))
                        Fill.Size = UDim2.new(p,0,1,0)
                        ValLb.Text = tostring(v)
                        if cb then cb(v) end
                        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then c:Disconnect() end
                    end)
                end)
            end
            
            function El:Button(text, cb)
                local Btn = Utils:Create("TextButton", {
                    Parent = ContentBox, Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Library.Theme.Element,
                    Text = text, TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 13
                })
                Library:Register(Btn, "BackgroundColor3", "Element"); Library:Register(Btn, "TextColor3", "Text")
                Utils:Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 4)})
                Utils:Create("UIStroke", {Parent = Btn, Color = Library.Theme.Border})
                Btn.MouseButton1Click:Connect(cb)
            end
            
            function El:Dropdown(text, opts, def, cb)
                local open = false
                local sel = def or opts[1]
                local H = 30
                
                local Main = Utils:Create("Frame", {
                    Parent = ContentBox, Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Library.Theme.Element, ClipsDescendants=true
                }); Library:Register(Main, "BackgroundColor3", "Element")
                Utils:Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 4)})
                
                local Lb = Utils:Create("TextLabel", {
                    Parent = Main, Text = text .. ": " .. tostring(sel), TextColor3 = Library.Theme.DimText,
                    Font = Enum.Font.Gotham, TextSize = 13, Size = UDim2.new(1, -30, 0, 30),
                    Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
                })
                local Btn = Utils:Create("TextButton", {Parent=Main, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text=""})
                
                local List = Utils:Create("Frame", {
                    Parent = Main, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 30), BackgroundTransparency=1
                })
                local Layout = Utils:Create("UIListLayout", {Parent = List, SortOrder = Enum.SortOrder.LayoutOrder})
                
                for _, o in pairs(opts) do
                    local B = Utils:Create("TextButton", {
                        Parent = List, Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Library.Theme.Main,
                        Text = o, TextColor3 = Library.Theme.DimText, Font = Enum.Font.Gotham, TextSize = 12
                    })
                    Library:Register(B, "BackgroundColor3", "Main")
                    B.MouseButton1Click:Connect(function()
                        sel = o; Lb.Text = text .. ": " .. tostring(sel)
                        open = false; Utils:Tween(Main, 0.2, {Size = UDim2.new(1, 0, 0, 30)})
                        if cb then cb(o) end
                    end)
                end
                
                Btn.MouseButton1Click:Connect(function()
                    open = not open
                    Utils:Tween(Main, 0.2, {Size = UDim2.new(1, 0, 0, open and (30 + (#opts*25)) or 30)})
                end)
            end

            return El
        end
        return TabObj
    end
    return Tabs
end

return Library
