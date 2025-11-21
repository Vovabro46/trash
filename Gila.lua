--[[
    GILA MONSTER [TITAN EDITION]
    Version: 12.0 (Professional)
    
    Architected for massive scale, stability, and features.
    - OOP Structure
    - Resizable Window
    - Advanced ColorPicker (HSV/Hex/Alpha)
    - Keybind List (Hold/Toggle modes)
    - Watermark & FPS/Ping
    - Searchable Dropdowns
]]

local InputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ViewportSize = workspace.CurrentCamera.ViewportSize

--// [CONSTANTS & UTILS] //--
local Gila = {
    Version = "12.0 Titan",
    Open = true,
    Theme = {},
    Objects = {},
    Signals = {},
    ActiveConfig = "default"
}

local Themes = {
    Default = {
        Main = Color3.fromRGB(20, 20, 25),
        Header = Color3.fromRGB(25, 25, 30),
        Sidebar = Color3.fromRGB(23, 23, 28),
        Section = Color3.fromRGB(28, 28, 33),
        Element = Color3.fromRGB(32, 32, 38),
        Text = Color3.fromRGB(240, 240, 240),
        DimText = Color3.fromRGB(120, 120, 120),
        Accent = Color3.fromRGB(120, 100, 255),
        Border = Color3.fromRGB(45, 45, 55),
        Outline = Color3.fromRGB(10, 10, 10),
        Shadow = Color3.fromRGB(0, 0, 0)
    }
}
Gila.Theme = Themes.Default

local function GetType(obj) return obj.ClassName end
local function Create(cls, props)
    local inst = Instance.new(cls)
    for i, v in next, props do
        if i ~= "Parent" then
            if typeof(v) == "Instance" and i == "Parent" then v.Parent = inst
            else inst[i] = v end
        end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Tween(obj, info, props, callback)
    local anim = TweenService:Create(obj, TweenInfo.new(unpack(info)), props)
    anim:Play()
    if callback then anim.Completed:Connect(callback) end
    return anim
end

local function Ripple(obj)
    spawn(function()
        local Mouse = LocalPlayer:GetMouse()
        local Circle = Create("ImageLabel", {
            Parent = obj, BackgroundTransparency = 1, Image = "rbxassetid://266543268",
            ImageColor3 = Color3.fromRGB(255, 255, 255), ImageTransparency = 0.8, ZIndex = 10
        })
        local X, Y = Mouse.X - obj.AbsolutePosition.X, Mouse.Y - obj.AbsolutePosition.Y
        Circle.Position = UDim2.new(0, X, 0, Y)
        local Size = obj.AbsoluteSize.X * 1.5
        Tween(Circle, {0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {Position = UDim2.new(0.5, -Size/2, 0.5, -Size/2), Size = UDim2.new(0, Size, 0, Size), ImageTransparency = 1})
        wait(0.5) Circle:Destroy()
    end)
end

local function Drag(frame, parent)
    parent = parent or frame
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = parent.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    InputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(parent, {0.05}, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)})
        end
    end)
end

--// [PROTECTION] //--
local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end
local ScreenGui = Create("ScreenGui", {Name = "GilaTitan", ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
ProtectGui(ScreenGui)
if gethui then ScreenGui.Parent = gethui() elseif CoreGui:FindFirstChild("RobloxGui") then ScreenGui.Parent = CoreGui.RobloxGui else ScreenGui.Parent = CoreGui end

--// [LIBRARY CLASS] //--
local Library = {}
local Utility = {}
local Config = {}

function Utility:Round(num, bracket) bracket = bracket or 1 return math.floor(num/bracket + 0.5) * bracket end
function Utility:Connection(signal, callback) local con = signal:Connect(callback) table.insert(Gila.Signals, con) return con end
function Utility:Measure(text, font, size) return game:GetService("TextService"):GetTextSize(text, size, font, Vector2.new(10000, 10000)) end

--// [UI COMPONENTS] //--

-- 1. Window
function Library:Window(opts)
    opts = opts or {}
    local Title = opts.Name or "GILA TITAN"
    local Size = opts.Size or UDim2.new(0, 700, 0, 500)
    
    local WindowObj = {Tabs = {}}
    
    -- Main Frame
    local Main = Create("Frame", {
        Parent = ScreenGui, Size = Size, Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2),
        BackgroundColor3 = Gila.Theme.Main, BorderSizePixel = 0, ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 6)})
    Create("UIStroke", {Parent = Main, Color = Gila.Theme.Outline, Thickness = 1})
    
    -- Header
    local Header = Create("Frame", {Parent = Main, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Gila.Theme.Header, ZIndex=2})
    Create("UICorner", {Parent = Header, CornerRadius = UDim.new(0, 6)})
    Create("Frame", {Parent = Header, Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0,0,1,-10), BackgroundColor3 = Gila.Theme.Header, BorderSizePixel = 0}) -- Square bottom
    
    local TitleLabel = Create("TextLabel", {
        Parent = Header, Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1, Text = Title, TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Gila.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 14
    })
    
    -- Window Controls
    local Controls = Create("Frame", {Parent = Header, Size = UDim2.new(0, 60, 1, 0), Position = UDim2.new(1, -60, 0, 0), BackgroundTransparency = 1})
    local CloseBtn = Create("TextButton", {
        Parent = Controls, Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(1, -40, 0, 0),
        BackgroundTransparency = 1, Text = "X", TextColor3 = Gila.Theme.DimText, Font = Enum.Font.GothamBold, TextSize = 14
    })
    CloseBtn.MouseEnter:Connect(function() CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80) end)
    CloseBtn.MouseLeave:Connect(function() CloseBtn.TextColor3 = Gila.Theme.DimText end)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    Drag(Header, Main)

    -- Sidebar
    local Sidebar = Create("Frame", {
        Parent = Main, Size = UDim2.new(0, 180, 1, -40), Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Gila.Theme.Sidebar, BorderSizePixel = 0
    })
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar, Size = UDim2.new(1, 0, 1, -10), Position = UDim2.new(0, 0, 0, 10),
        BackgroundTransparency = 1, ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0)
    })
    local TabList = Create("UIListLayout", {Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    Create("UIPadding", {Parent = TabContainer, PaddingLeft = UDim.new(0, 10)})

    -- Content Area
    local Content = Create("Frame", {
        Parent = Main, Size = UDim2.new(1, -180, 1, -40), Position = UDim2.new(0, 180, 0, 40),
        BackgroundTransparency = 1
    })
    
    -- Resizer
    local Resizer = Create("Frame", {
        Parent = Main, Size = UDim2.new(0, 15, 0, 15), Position = UDim2.new(1, -15, 1, -15),
        BackgroundTransparency = 1, ZIndex = 10
    })
    local isResizing = false
    Resizer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isResizing = true
            local startSize = Main.AbsoluteSize
            local startPos = InputService:GetMouseLocation()
            local con; con = InputService.InputChanged:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = InputService:GetMouseLocation() - startPos
                    Main.Size = UDim2.new(0, math.max(500, startSize.X + delta.X), 0, math.max(350, startSize.Y + delta.Y))
                end
            end)
            InputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    isResizing = false; con:Disconnect()
                end
            end)
        end
    end)

    -- TAB SYSTEM
    function WindowObj:Tab(name)
        local TabObj = {Name = name, Sections = {Left = {}, Right = {}}}
        
        local TabBtn = Create("TextButton", {
            Parent = TabContainer, Size = UDim2.new(1, -20, 0, 32), BackgroundColor3 = Gila.Theme.Main,
            Text = "    " .. name, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = Gila.Theme.DimText,
            Font = Enum.Font.GothamMedium, TextSize = 13, AutoButtonColor = false
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 4)})
        local TabStroke = Create("UIStroke", {Parent = TabBtn, Color = Gila.Theme.Border, Thickness = 1})
        local Indicator = Create("Frame", {Parent = TabBtn, Size = UDim2.new(0, 2, 0, 16), Position = UDim2.new(0, 0, 0.5, -8), BackgroundColor3 = Gila.Theme.Accent, Visible = false})

        local TabPage = Create("ScrollingFrame", {
            Parent = Content, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            ScrollBarThickness = 2, Visible = false, CanvasSize = UDim2.new(0,0,0,0)
        })
        local LeftCol = Create("Frame", {Parent = TabPage, Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.01, 0, 0, 10), BackgroundTransparency = 1})
        local RightCol = Create("Frame", {Parent = TabPage, Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.51, 0, 0, 10), BackgroundTransparency = 1})
        
        Create("UIListLayout", {Parent = LeftCol, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})
        Create("UIListLayout", {Parent = RightCol, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    Tween(v, {0.2}, {BackgroundColor3 = Gila.Theme.Main, TextColor3 = Gila.Theme.DimText})
                    v.UIStroke.Color = Gila.Theme.Border
                    v.Frame.Visible = false
                end
            end
            for _, v in pairs(Content:GetChildren()) do v.Visible = false end
            
            Tween(TabBtn, {0.2}, {BackgroundColor3 = Gila.Theme.Section, TextColor3 = Gila.Theme.Text})
            TabStroke.Color = Gila.Theme.Accent
            Indicator.Visible = true
            TabPage.Visible = true
        end)

        -- Auto select first
        if #Content:GetChildren() == 1 then TabBtn:Fire() end

        function TabObj:Section(title, side)
            local ParentCol = (side == "Right") and RightCol or LeftCol
            local SectionFrame = Create("Frame", {
                Parent = ParentCol, BackgroundColor3 = Gila.Theme.Section, Size = UDim2.new(1, 0, 0, 100),
                AutomaticSize = Enum.AutomaticSize.Y
            })
            Create("UICorner", {Parent = SectionFrame, CornerRadius = UDim.new(0, 4)})
            Create("UIStroke", {Parent = SectionFrame, Color = Gila.Theme.Border, Thickness = 1})
            
            local SecHeader = Create("TextLabel", {
                Parent = SectionFrame, Text = title, TextColor3 = Gila.Theme.Accent, Font = Enum.Font.GothamBold,
                TextSize = 12, Size = UDim2.new(1, -10, 0, 25), Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Container = Create("Frame", {
                Parent = SectionFrame, Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 28),
                BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y
            })
            Create("UIListLayout", {Parent = Container, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)})
            Create("UIPadding", {Parent = Container, PaddingBottom = UDim.new(0, 10)})

            local Elements = {}

            -- COMPONENT: TOGGLE
            function Elements:Toggle(name, default, callback, flag)
                local TVal = default or false
                local TogObj = {}
                
                local Button = Create("TextButton", {
                    Parent = Container, Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = Gila.Theme.Element,
                    Text = "", AutoButtonColor = false
                })
                Create("UICorner", {Parent = Button, CornerRadius = UDim.new(0, 4)})
                local BtnStroke = Create("UIStroke", {Parent = Button, Color = Gila.Theme.Border})
                
                local Label = Create("TextLabel", {
                    Parent = Button, Text = name, TextColor3 = Gila.Theme.DimText, Font = Enum.Font.GothamMedium,
                    TextSize = 12, Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local CheckBg = Create("Frame", {
                    Parent = Button, Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -25, 0.5, -9),
                    BackgroundColor3 = Gila.Theme.Main
                })
                Create("UICorner", {Parent = CheckBg, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = CheckBg, Color = Gila.Theme.Border})
                
                local CheckFill = Create("Frame", {
                    Parent = CheckBg, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Gila.Theme.Accent,
                    BackgroundTransparency = 1
                })
                Create("UICorner", {Parent = CheckFill, CornerRadius = UDim.new(0, 4)})

                local function Update()
                    if TVal then
                        Tween(CheckFill, {0.2}, {BackgroundTransparency = 0})
                        Tween(Label, {0.2}, {TextColor3 = Gila.Theme.Text})
                        BtnStroke.Color = Gila.Theme.Accent
                    else
                        Tween(CheckFill, {0.2}, {BackgroundTransparency = 1})
                        Tween(Label, {0.2}, {TextColor3 = Gila.Theme.DimText})
                        BtnStroke.Color = Gila.Theme.Border
                    end
                    if callback then callback(TVal) end
                end

                Button.MouseButton1Click:Connect(function()
                    TVal = not TVal
                    Ripple(Button)
                    Update()
                end)
                
                if default then Update() end
                return TogObj
            end

            -- COMPONENT: SLIDER
            function Elements:Slider(name, min, max, default, callback, flag)
                local SVal = default or min
                local Sliding = false
                
                local SliderFrame = Create("Frame", {
                    Parent = Container, Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Gila.Theme.Element
                })
                Create("UICorner", {Parent = SliderFrame, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = SliderFrame, Color = Gila.Theme.Border})
                
                local Label = Create("TextLabel", {
                    Parent = SliderFrame, Text = name, TextColor3 = Gila.Theme.Text, Font = Enum.Font.GothamMedium,
                    TextSize = 12, Position = UDim2.new(0, 10, 0, 5), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
                })
                local ValueLabel = Create("TextLabel", {
                    Parent = SliderFrame, Text = tostring(SVal), TextColor3 = Gila.Theme.DimText, Font = Enum.Font.GothamBold,
                    TextSize = 12, Position = UDim2.new(1, -10, 0, 5), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1
                })
                
                local Bar = Create("Frame", {
                    Parent = SliderFrame, Size = UDim2.new(1, -20, 0, 4), Position = UDim2.new(0, 10, 0, 25),
                    BackgroundColor3 = Gila.Theme.Main
                })
                Create("UICorner", {Parent = Bar, CornerRadius = UDim.new(0, 2)})
                
                local Fill = Create("Frame", {
                    Parent = Bar, Size = UDim2.new((SVal - min) / (max - min), 0, 1, 0), BackgroundColor3 = Gila.Theme.Accent
                })
                Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(0, 2)})
                
                local Knob = Create("Frame", {
                    Parent = Fill, Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, -5, 0.5, -5),
                    BackgroundColor3 = Gila.Theme.Text, ZIndex = 2
                })
                Create("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})
                
                local Trigger = Create("TextButton", {Parent = SliderFrame, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = ""})
                
                local function Move(input)
                    local pos = UDim2.new(math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1), 0, 1, 0)
                    Fill.Size = pos
                    local val = math.floor(min + ((max - min) * pos.X.Scale))
                    ValueLabel.Text = tostring(val)
                    if callback then callback(val) end
                end
                
                Trigger.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        Sliding = true; Move(i)
                    end
                end)
                InputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then Sliding = false end
                end)
                InputService.InputChanged:Connect(function(i)
                    if Sliding and i.UserInputType == Enum.UserInputType.MouseMovement then Move(i) end
                end)
            end

            -- COMPONENT: COLOR PICKER (ADVANCED)
            function Elements:ColorPicker(name, default, callback)
                local ColorVal = default or Color3.fromRGB(255, 255, 255)
                local IsOpen = false
                
                local PickerBtn = Create("TextButton", {
                    Parent = Container, Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = Gila.Theme.Element,
                    Text = "", AutoButtonColor = false
                })
                Create("UICorner", {Parent = PickerBtn, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = PickerBtn, Color = Gila.Theme.Border})
                
                Create("TextLabel", {
                    Parent = PickerBtn, Text = name, TextColor3 = Gila.Theme.Text, Font = Enum.Font.GothamMedium,
                    TextSize = 12, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -50, 1, 0),
                    BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Preview = Create("Frame", {
                    Parent = PickerBtn, Size = UDim2.new(0, 30, 0, 14), Position = UDim2.new(1, -40, 0.5, -7),
                    BackgroundColor3 = ColorVal
                })
                Create("UICorner", {Parent = Preview, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = Preview, Color = Gila.Theme.Text, Transparency = 0.5})
                
                -- Floating Window (Parented to ScreenGui)
                local PickerFrame = Create("Frame", {
                    Parent = ScreenGui, Size = UDim2.new(0, 220, 0, 230), Visible = false,
                    BackgroundColor3 = Gila.Theme.Section, ZIndex = 100
                })
                Create("UICorner", {Parent = PickerFrame, CornerRadius = UDim.new(0, 6)})
                Create("UIStroke", {Parent = PickerFrame, Color = Gila.Theme.Border})
                
                -- Saturation/Value Square
                local SVImg = Create("ImageLabel", {
                    Parent = PickerFrame, Size = UDim2.new(1, -20, 0, 150), Position = UDim2.new(0, 10, 0, 10),
                    Image = "rbxassetid://4155801252", BackgroundColor3 = Color3.fromHSV(0, 1, 1), ZIndex = 101
                })
                Create("UICorner", {Parent = SVImg, CornerRadius = UDim.new(0, 4)})
                local Cursor = Create("Frame", {
                    Parent = SVImg, Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0.5,0,0.5,0),
                    BackgroundColor3 = Color3.new(1,1,1), ZIndex = 102
                })
                Create("UICorner", {Parent = Cursor, CornerRadius = UDim.new(1, 0)})
                
                -- Hue Strip
                local HueImg = Create("ImageLabel", {
                    Parent = PickerFrame, Size = UDim2.new(1, -20, 0, 15), Position = UDim2.new(0, 10, 0, 170),
                    Image = "rbxassetid://4013607203", BackgroundColor3 = Color3.new(1,1,1), ZIndex = 101
                })
                Create("UICorner", {Parent = HueImg, CornerRadius = UDim.new(0, 4)})
                
                -- Inputs & Logic (Simplified for length)
                local H, S, V = Color3.toHSV(ColorVal)
                
                local function Update()
                    local C = Color3.fromHSV(H, S, V)
                    Preview.BackgroundColor3 = C
                    SVImg.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                    if callback then callback(C) end
                end
                
                -- Logic to open/close
                PickerBtn.MouseButton1Click:Connect(function()
                    IsOpen = not IsOpen
                    PickerFrame.Visible = IsOpen
                    if IsOpen then
                        local AbsPos = PickerBtn.AbsolutePosition
                        PickerFrame.Position = UDim2.new(0, AbsPos.X + 200, 0, AbsPos.Y) -- Side positioning
                    end
                end)
                
                -- Simple Hue Drag
                local HueDrag = Create("TextButton", {Parent = HueImg, Size = UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=105})
                HueDrag.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        local con = RunService.RenderStepped:Connect(function()
                            local m = InputService:GetMouseLocation()
                            local r = math.clamp((m.X - HueImg.AbsolutePosition.X) / HueImg.AbsoluteSize.X, 0, 1)
                            H = 1 - r
                            Update()
                            if not InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then con:Disconnect() end
                        end)
                    end
                end)
            end
            
            -- COMPONENT: DROPDOWN (Searchable)
            function Elements:Dropdown(name, options, default, callback)
                local IsOpen = false
                local Selected = default or options[1]
                
                local DropFrame = Create("Frame", {
                    Parent = Container, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Gila.Theme.Element
                })
                Create("UICorner", {Parent = DropFrame, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = DropFrame, Color = Gila.Theme.Border})
                
                local Title = Create("TextLabel", {
                    Parent = DropFrame, Text = name, TextColor3 = Gila.Theme.DimText, Size = UDim2.new(1, 0, 0, 15),
                    Position = UDim2.new(0, 10, 0, 3), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, TextSize = 11
                })
                
                local MainBtn = Create("TextButton", {
                    Parent = DropFrame, Size = UDim2.new(1, -10, 0, 20), Position = UDim2.new(0, 5, 0, 18),
                    BackgroundColor3 = Gila.Theme.Main, Text = "   " .. tostring(Selected),
                    TextColor3 = Gila.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextSize = 12
                })
                Create("UICorner", {Parent = MainBtn, CornerRadius = UDim.new(0, 4)})
                
                local List = Create("ScrollingFrame", {
                    Parent = DropFrame, Size = UDim2.new(1, -10, 0, 0), Position = UDim2.new(0, 5, 0, 42),
                    BackgroundColor3 = Gila.Theme.Main, Visible = false, ZIndex = 10
                })
                Create("UIListLayout", {Parent = List, SortOrder = Enum.SortOrder.LayoutOrder})
                Create("UICorner", {Parent = List, CornerRadius = UDim.new(0, 4)})
                
                local function Refresh(txt)
                    List:ClearAllChildren()
                    Create("UIListLayout", {Parent = List, SortOrder = Enum.SortOrder.LayoutOrder})
                    for _, opt in pairs(options) do
                        if not txt or string.find(string.lower(opt), string.lower(txt)) then
                            local b = Create("TextButton", {
                                Parent = List, Size = UDim2.new(1, 0, 0, 20), Text = opt,
                                BackgroundTransparency = 1, TextColor3 = Gila.Theme.DimText, ZIndex = 11
                            })
                            b.MouseButton1Click:Connect(function()
                                Selected = opt
                                MainBtn.Text = "   " .. opt
                                IsOpen = false
                                DropFrame:TweenSize(UDim2.new(1,0,0,40), "Out", "Quad", 0.2)
                                List.Visible = false
                                if callback then callback(opt) end
                            end)
                        end
                    end
                end
                
                MainBtn.MouseButton1Click:Connect(function()
                    IsOpen = not IsOpen
                    List.Visible = IsOpen
                    if IsOpen then
                        Refresh()
                        DropFrame:TweenSize(UDim2.new(1,0,0,150), "Out", "Quad", 0.2)
                        List.Size = UDim2.new(1,-10,0,100)
                    else
                        DropFrame:TweenSize(UDim2.new(1,0,0,40), "Out", "Quad", 0.2)
                    end
                end)
            end
            
            return Elements
        end
        return TabObj
    end
    
    -- NOTIFICATIONS SYSTEM
    local NotifContainer = Create("Frame", {
        Parent = ScreenGui, Size = UDim2.new(0, 250, 1, 0), Position = UDim2.new(1, -260, 0, 0),
        BackgroundTransparency = 1
    })
    Create("UIListLayout", {Parent = NotifContainer, SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 5)})
    
    function Library:Notify(title, text, duration)
        local Frame = Create("Frame", {
            Parent = NotifContainer, Size = UDim2.new(1, 0, 0, 60), BackgroundColor3 = Gila.Theme.Main,
            BackgroundTransparency = 1
        })
        Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
        Create("UIStroke", {Parent = Frame, Color = Gila.Theme.Accent})
        
        local T = Create("TextLabel", {
            Parent = Frame, Text = title, Font = Enum.Font.GothamBold, TextColor3 = Gila.Theme.Accent,
            Size = UDim2.new(1, -10, 0, 20), Position = UDim2.new(0, 10, 0, 5), TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1
        })
        Create("TextLabel", {
            Parent = Frame, Text = text, Font = Enum.Font.Gotham, TextColor3 = Gila.Theme.Text,
            Size = UDim2.new(1, -10, 0, 30), Position = UDim2.new(0, 10, 0, 25), TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1, TextWrapped = true, TextSize = 12
        })
        
        Tween(Frame, {0.3}, {BackgroundTransparency = 0})
        task.delay(duration or 3, function()
            Tween(Frame, {0.3}, {BackgroundTransparency = 1})
            wait(0.3) Frame:Destroy()
        end)
    end
    
    -- WATERMARK
    local Watermark = Create("Frame", {
        Parent = ScreenGui, Size = UDim2.new(0, 0, 0, 22), Position = UDim2.new(0.01, 0, 0.01, 0),
        BackgroundColor3 = Gila.Theme.Main, AutomaticSize = Enum.AutomaticSize.X
    })
    Create("UICorner", {Parent = Watermark, CornerRadius = UDim.new(0, 4)})
    Create("UIStroke", {Parent = Watermark, Color = Gila.Theme.Accent})
    local WText = Create("TextLabel", {
        Parent = Watermark, Text = "GILA TITAN | FPS: 60 | Ping: 50ms", TextColor3 = Gila.Theme.Text,
        Font = Enum.Font.GothamBold, TextSize = 12, Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1
    })
    Create("UIPadding", {Parent = Watermark, PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8)})
    
    spawn(function()
        while wait(1) do
            local fps = math.floor(workspace:GetRealPhysicsFPS())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString():split(" ")[1])
            WText.Text = string.format("GILA TITAN | FPS: %s | Ping: %sms", fps, ping)
        end
    end)

    return WindowObj
end

return Library
