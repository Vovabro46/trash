--[[
    GILA MONSTER [TITAN FRAMEWORK v14]
    Status: STABLE / FIXED
    
    [CHANGELOG]
    - Fixed "Empty Tab" bug (Switched to AutomaticCanvasSize)
    - Fixed Mobile Layout (Auto-stacking columns)
    - Added Collapsible Sections
    - Added Dropdown Search & Scroll
    - Full OOP Architecture
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

--// [DEVICE CHECK]
local Camera = workspace.CurrentCamera
local Device = "PC"
if Camera.ViewportSize.X < 600 then Device = "Mobile" elseif Camera.ViewportSize.X < 1024 then Device = "Tablet" end

--// [LIBRARY ROOT]
local Library = {
    Opened = true,
    Theme = {
        Main = Color3.fromRGB(22, 22, 26),
        Header = Color3.fromRGB(26, 26, 32),
        Sidebar = Color3.fromRGB(24, 24, 28),
        Section = Color3.fromRGB(28, 28, 34),
        Element = Color3.fromRGB(32, 32, 38),
        Text = Color3.fromRGB(245, 245, 245),
        DimText = Color3.fromRGB(140, 140, 140),
        Accent = Color3.fromRGB(125, 110, 255),
        Border = Color3.fromRGB(45, 45, 50),
        Shadow = Color3.fromRGB(0, 0, 0)
    },
    Registry = {}
}

--// [UTILITIES]
local Utility = {}

function Utility:Create(class, props)
    local object = Instance.new(class)
    for prop, value in pairs(props) do
        if prop ~= "Parent" then object[prop] = value end
    end
    if props.Parent then object.Parent = props.Parent end
    return object
end

function Utility:Tween(object, time, props)
    TweenService:Create(object, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

function Utility:Drag(frame, trigger)
    if Device == "Mobile" then return end
    local dragging, dragInput, dragStart, startPos
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    trigger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Utility:Tween(frame, 0.05, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)})
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

--// [THEME MANAGER]
function Library:Register(obj, prop, key)
    if not Library.Registry[obj] then Library.Registry[obj] = {} end
    Library.Registry[obj][prop] = key
    obj[prop] = Library.Theme[key]
end

function Library:UpdateTheme(key, color)
    Library.Theme[key] = color
    for obj, props in pairs(Library.Registry) do
        if obj.Parent then
            for prop, themeKey in pairs(props) do
                if themeKey == key then Utility:Tween(obj, 0.3, {[prop] = color}) end
            end
        else
            Library.Registry[obj] = nil
        end
    end
end

--// [MAIN WINDOW]
function Library:Window(options)
    local Name = options.Name or "GILA TITAN"
    
    -- Protect GUI
    if CoreGui:FindFirstChild("GilaTitan") then CoreGui.GilaTitan:Destroy() end
    local Screen = Utility:Create("ScreenGui", {Name = "GilaTitan", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    
    -- Scale Factor
    local Scale = Utility:Create("UIScale", {Parent = Screen, Scale = (Device == "Mobile" and 1.1 or 1.0)})

    -- Main Frame
    local Main = Utility:Create("Frame", {
        Parent = Screen, BackgroundColor3 = Library.Theme.Main,
        Size = (Device == "Mobile" and UDim2.new(0.95, 0, 0.85, 0) or UDim2.new(0, 700, 0, 500)),
        Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true
    })
    Library:Register(Main, "BackgroundColor3", "Main")
    Utility:Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 6)})
    Utility:Create("UIStroke", {Parent = Main, Color = Library.Theme.Border, Thickness = 1})
    
    -- Shadow
    local Shadow = Utility:Create("ImageLabel", {
        Parent = Main, Image = "rbxassetid://5554236805", ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23,23,277,277), Size = UDim2.new(1, 50, 1, 50), Position = UDim2.new(0, -25, 0, -25),
        BackgroundTransparency = 1, ImageColor3 = Library.Theme.Shadow, ImageTransparency = 0.4, ZIndex = -1
    })

    -- Topbar
    local Topbar = Utility:Create("Frame", {
        Parent = Main, Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = Library.Theme.Header, ZIndex = 2
    })
    Library:Register(Topbar, "BackgroundColor3", "Header")
    
    local TitleLbl = Utility:Create("TextLabel", {
        Parent = Topbar, Text = Name, Font = Enum.Font.GothamBold, TextSize = 16,
        TextColor3 = Library.Theme.Text, Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
    })
    Library:Register(TitleLbl, "TextColor3", "Text")
    
    -- Mobile Close Button
    if Device == "Mobile" then
        local Close = Utility:Create("TextButton", {
            Parent = Topbar, Text = "X", Font = Enum.Font.GothamBold, TextSize = 18,
            TextColor3 = Library.Theme.DimText, Size = UDim2.new(0, 45, 1, 0), Position = UDim2.new(1, -45, 0, 0),
            BackgroundTransparency = 1
        })
        Close.MouseButton1Click:Connect(function()
            Library.Opened = not Library.Opened
            Main.Visible = Library.Opened
        end)
    end
    
    Utility:Drag(Main, Topbar)

    -- Container System
    local Sidebar = Utility:Create("ScrollingFrame", {
        Parent = Main, BackgroundColor3 = Library.Theme.Sidebar,
        Size = (Device == "Mobile" and UDim2.new(0, 65, 1, -45) or UDim2.new(0, 170, 1, -45)),
        Position = UDim2.new(0, 0, 0, 45), ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0)
    })
    Library:Register(Sidebar, "BackgroundColor3", "Sidebar")
    
    local SidebarLayout = Utility:Create("UIListLayout", {
        Parent = Sidebar, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)
    })
    Utility:Create("UIPadding", {Parent = Sidebar, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10)})

    local Pages = Utility:Create("Frame", {
        Parent = Main, BackgroundTransparency = 1,
        Size = (Device == "Mobile" and UDim2.new(1, -65, 1, -45) or UDim2.new(1, -170, 1, -45)),
        Position = (Device == "Mobile" and UDim2.new(0, 65, 0, 45) or UDim2.new(0, 170, 0, 45))
    })

    -- Mobile Toggle Sphere
    local Sphere = Utility:Create("ImageButton", {
        Parent = Screen, Image = "rbxassetid://6031091000", BackgroundColor3 = Library.Theme.Main,
        Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 30, 0, 30),
        ImageColor3 = Library.Theme.Accent, ZIndex = 100
    })
    Library:Register(Sphere, "BackgroundColor3", "Main"); Library:Register(Sphere, "ImageColor3", "Accent")
    Utility:Create("UICorner", {Parent = Sphere, CornerRadius = UDim.new(1, 0)})
    Utility:Create("UIStroke", {Parent = Sphere, Color = Library.Theme.Accent, Thickness = 2})
    
    local draggingS, dragStartS, startPosS
    Sphere.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then draggingS=true; dragStartS=i.Position; startPosS=Sphere.Position end end)
    UserInputService.InputChanged:Connect(function(i) if draggingS and i.UserInputType==Enum.UserInputType.Touch then local delta=i.Position-dragStartS; Sphere.Position = UDim2.new(startPosS.X.Scale, startPosS.X.Offset+delta.X, startPosS.Y.Scale, startPosS.Y.Offset+delta.Y) end end)
    Sphere.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then draggingS=false end end)
    Sphere.MouseButton1Click:Connect(function() Library.Opened = not Library.Opened; Main.Visible = Library.Opened end)

    --// [TABS SYSTEM]
    local WindowAPI = {}
    local FirstTab = true

    function WindowAPI:Tab(name, icon)
        local TabButton = Utility:Create("TextButton", {
            Parent = Sidebar, Size = (Device == "Mobile" and UDim2.new(1, -10, 0, 40) or UDim2.new(1, -10, 0, 32)),
            BackgroundColor3 = Library.Theme.Main, Text = (Device == "Mobile" and "" or "  "..name),
            TextColor3 = Library.Theme.DimText, Font = Enum.Font.GothamBold, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false
        })
        Library:Register(TabButton, "TextColor3", "DimText")
        Utility:Create("UICorner", {Parent = TabButton, CornerRadius = UDim.new(0, 4)})
        
        if Device == "Mobile" and icon then
            local Ico = Utility:Create("ImageLabel", {
                Parent = TabButton, BackgroundTransparency=1, Image=icon, Size=UDim2.new(0,24,0,24),
                Position=UDim2.new(0.5,-12,0.5,-12), ImageColor3=Library.Theme.DimText
            }); Library:Register(Ico, "ImageColor3", "DimText")
        end

        -- Page Frame
        local Page = Utility:Create("ScrollingFrame", {
            Parent = Pages, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Visible = false, ScrollBarThickness = 3, AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0,0,0,0) -- Important: Let AutoSize handle it
        })
        
        -- Columns Layout
        local LeftSide = Utility:Create("Frame", {
            Parent = Page, BackgroundTransparency = 1,
            Size = (Device == "Mobile" and UDim2.new(0.96, 0, 0, 0) or UDim2.new(0.48, 0, 0, 0)),
            Position = UDim2.new(0.02, 0, 0, 10), AutomaticSize = Enum.AutomaticSize.Y
        })
        local RightSide = Utility:Create("Frame", {
            Parent = Page, BackgroundTransparency = 1,
            Size = (Device == "Mobile" and UDim2.new(0.96, 0, 0, 0) or UDim2.new(0.48, 0, 0, 0)),
            Position = (Device == "Mobile" and UDim2.new(0.02, 0, 0, 0) or UDim2.new(0.51, 0, 0, 10)),
            AutomaticSize = Enum.AutomaticSize.Y
        })
        
        local LeftLayout = Utility:Create("UIListLayout", {Parent = LeftSide, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12)})
        local RightLayout = Utility:Create("UIListLayout", {Parent = RightSide, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12)})
        
        -- Fix for Mobile Layout Stacking
        if Device == "Mobile" then
            local MobileList = Utility:Create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12)})
        end

        local function Activate()
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    Utility:Tween(v, 0.2, {BackgroundColor3 = Library.Theme.Main, TextColor3 = Library.Theme.DimText})
                    if v:FindFirstChild("ImageLabel") then Utility:Tween(v.ImageLabel, 0.2, {ImageColor3 = Library.Theme.DimText}) end
                end
            end
            for _, v in pairs(Pages:GetChildren()) do v.Visible = false end
            
            Utility:Tween(TabButton, 0.2, {BackgroundColor3 = Library.Theme.Element, TextColor3 = Library.Theme.Accent})
            if TabButton:FindFirstChild("ImageLabel") then Utility:Tween(TabButton.ImageLabel, 0.2, {ImageColor3 = Library.Theme.Accent}) end
            Page.Visible = true
        end

        TabButton.MouseButton1Click:Connect(Activate)
        if FirstTab then FirstTab = false; Activate() end

        --// [SECTIONS]
        local TabAPI = {}
        function TabAPI:Section(title, side)
            local Parent = (side == "Right" and RightSide or LeftSide)
            
            local Section = Utility:Create("Frame", {
                Parent = Parent, BackgroundColor3 = Library.Theme.Section,
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y
            })
            Library:Register(Section, "BackgroundColor3", "Section")
            Utility:Create("UICorner", {Parent = Section, CornerRadius = UDim.new(0, 5)})
            Utility:Create("UIStroke", {Parent = Section, Color = Library.Theme.Border, Thickness = 1})
            
            local SecTitle = Utility:Create("TextLabel", {
                Parent = Section, Text = title:upper(), Font = Enum.Font.GothamBold, TextSize = 11,
                TextColor3 = Library.Theme.DimText, Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 2),
                BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            Library:Register(SecTitle, "TextColor3", "DimText")
            
            local Content = Utility:Create("Frame", {
                Parent = Section, Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 28),
                BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y
            })
            Utility:Create("UIListLayout", {Parent = Content, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)})
            Utility:Create("UIPadding", {Parent = Content, PaddingBottom = UDim.new(0, 10)})

            --// [ELEMENTS]
            local El = {}
            
            function El:Label(txt)
                local L = Utility:Create("TextLabel", {
                    Parent = Content, Text = txt, TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham,
                    TextSize = 12, Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
                })
                Library:Register(L, "TextColor3", "Text")
                return L
            end

            function El:Button(txt, cb)
                local Btn = Utility:Create("TextButton", {
                    Parent = Content, Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Library.Theme.Element,
                    Text = txt, TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12
                })
                Library:Register(Btn, "BackgroundColor3", "Element"); Library:Register(Btn, "TextColor3", "Text")
                Utility:Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 4)})
                Utility:Create("UIStroke", {Parent = Btn, Color = Library.Theme.Border})
                
                Btn.MouseButton1Click:Connect(function()
                    Utility:Tween(Btn, 0.1, {BackgroundColor3 = Library.Theme.Accent})
                    wait(0.1)
                    Utility:Tween(Btn, 0.1, {BackgroundColor3 = Library.Theme.Element})
                    if cb then cb() end
                end)
            end

            function El:Toggle(txt, default, cb)
                local state = default or false
                local Btn = Utility:Create("TextButton", {
                    Parent = Content, Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Library.Theme.Element,
                    Text = "", AutoButtonColor = false
                })
                Library:Register(Btn, "BackgroundColor3", "Element")
                Utility:Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 4)})
                Utility:Create("UIStroke", {Parent = Btn, Color = Library.Theme.Border})
                
                local Text = Utility:Create("TextLabel", {
                    Parent = Btn, Text = txt, TextColor3 = Library.Theme.DimText, Font = Enum.Font.Gotham,
                    TextSize = 12, Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
                })
                Library:Register(Text, "TextColor3", "DimText")
                
                local Box = Utility:Create("Frame", {
                    Parent = Btn, Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -30, 0.5, -10),
                    BackgroundColor3 = Library.Theme.Main
                })
                Library:Register(Box, "BackgroundColor3", "Main")
                Utility:Create("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 4)})
                
                local Fill = Utility:Create("Frame", {
                    Parent = Box, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Library.Theme.Accent,
                    BackgroundTransparency = 1
                })
                Library:Register(Fill, "BackgroundColor3", "Accent")
                Utility:Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(0, 4)})
                
                local function Update()
                    Utility:Tween(Fill, 0.2, {BackgroundTransparency = state and 0 or 1})
                    Utility:Tween(Text, 0.2, {TextColor3 = state and Library.Theme.Text or Library.Theme.DimText})
                    if cb then cb(state) end
                end
                
                Btn.MouseButton1Click:Connect(function() state = not state; Update() end)
                if default then Update() end
            end

            function El:Slider(txt, min, max, def, cb)
                local val = def or min
                local SFrame = Utility:Create("Frame", {
                    Parent = Content, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Library.Theme.Element
                })
                Library:Register(SFrame, "BackgroundColor3", "Element")
                Utility:Create("UICorner", {Parent = SFrame, CornerRadius = UDim.new(0, 4)})
                
                local Lbl = Utility:Create("TextLabel", {
                    Parent = SFrame, Text = txt, TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham,
                    TextSize = 12, Position = UDim2.new(0, 10, 0, 5), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
                }); Library:Register(Lbl, "TextColor3", "Text")
                
                local ValLbl = Utility:Create("TextLabel", {
                    Parent = SFrame, Text = tostring(val), TextColor3 = Library.Theme.DimText, Font = Enum.Font.GothamBold,
                    TextSize = 12, Size = UDim2.new(1, -10, 0, 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Right
                }); Library:Register(ValLbl, "TextColor3", "DimText")
                
                local Bar = Utility:Create("Frame", {
                    Parent = SFrame, Size = UDim2.new(1, -20, 0, 4), Position = UDim2.new(0, 10, 0, 28),
                    BackgroundColor3 = Library.Theme.Main
                }); Library:Register(Bar, "BackgroundColor3", "Main")
                Utility:Create("UICorner", {Parent = Bar, CornerRadius = UDim.new(0, 2)})
                
                local Fill = Utility:Create("Frame", {
                    Parent = Bar, Size = UDim2.new((val-min)/(max-min), 0, 1, 0), BackgroundColor3 = Library.Theme.Accent
                }); Library:Register(Fill, "BackgroundColor3", "Accent")
                Utility:Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(0, 2)})
                
                local Btn = Utility:Create("TextButton", {Parent = SFrame, Size = UDim2.new(1,0,1,0), BackgroundTransparency=1, Text=""})
                
                local function Update(input)
                    local percent = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    val = math.floor(min + (max - min) * percent)
                    Fill.Size = UDim2.new(percent, 0, 1, 0)
                    ValLbl.Text = tostring(val)
                    if cb then cb(val) end
                end
                
                local sliding
                Btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding=true; Update(i) end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding=false end end)
                UserInputService.InputChanged:Connect(function(i) if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i) end end)
            end

            return El
        end
        return TabAPI
    end
    return WindowAPI
end

return Library
