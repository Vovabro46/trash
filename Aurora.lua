--[[ 
    ETERNESUS UI REMASTERED v12.5 (PLATINUM + ICONS + PROFILE)
    Language: LuaU
    Added: 
    1. Player Profile (Sidebar Bottom)
    2. RadioButton Element
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local Library = {}

--// ICON LIBRARY (Названия вместо цифр)
local Icons = {
    Home = "6031068428",
    Settings = "6031280882",
    Visuals = "6034509993",
    Combat = "6031090835",
    Player = "6031280894",
    Cloud = "6034509990",
    Folder = "6031068426",
    Shield = "6031090867",
    Sword = "6031090835",
    Search = "6031154871",
    Bug = "6031280887",
    Info = "6031280883",
    Lock = "6031090854",
    List = "6031091000"
}

--// THEME & CONFIG
local Theme = {
    Main = Color3.fromRGB(18, 18, 22),
    Sidebar = Color3.fromRGB(25, 25, 30),
    Section = Color3.fromRGB(28, 28, 33),
    Accent = Color3.fromRGB(0, 255, 127),     -- Ядовитый Неон
    TextMain = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(145, 145, 155),
    Stroke = Color3.fromRGB(45, 45, 50),
    Glow = "rbxassetid://4996891970",
    Font = Enum.Font.GothamBold
}

--// UTILITY
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local function MakeDraggable(topbar, object)
    local Dragging, DragInput, DragStart, StartPos
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            TweenService:Create(object, TweenInfo.new(0.05), {
                Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
            }):Play()
        end
    end)
end

--// LIBRARY START
function Library:Window(name)
    local Window = {}
    
    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "EternesusUltimate",
        Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local NotifyContainer = Create("Frame", {
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 300, 1, 0),
        Position = UDim2.new(1, -320, 0, 0),
        ZIndex = 100
    })
    local NotifyLayout = Create("UIListLayout", {
        Parent = NotifyContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    })
    Create("UIPadding", {Parent = NotifyContainer, PaddingBottom = UDim.new(0, 20)})

    -- TOOLTIP SYSTEM
    local Tooltip = Create("Frame", {
        Name = "Tooltip",
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(35, 35, 40),
        Size = UDim2.new(0, 0, 0, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        Visible = false,
        ZIndex = 100
    })
    Create("UICorner", {Parent = Tooltip, CornerRadius = UDim.new(0, 4)})
    Create("UIStroke", {Parent = Tooltip, Color = Theme.Accent, Thickness = 1})
    local TooltipText = Create("TextLabel", {
        Parent = Tooltip,
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextMain,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X
    })
    Create("UIPadding", {Parent = Tooltip, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})

    RunService.RenderStepped:Connect(function()
        if Tooltip.Visible then
            local mPos = UserInputService:GetMouseLocation()
            Tooltip.Position = UDim2.new(0, mPos.X + 15, 0, mPos.Y + 15)
        end
    end)

    local function AddTooltip(obj, text)
        obj.MouseEnter:Connect(function()
            TooltipText.Text = text
            Tooltip.Visible = true
        end)
        obj.MouseLeave:Connect(function()
            Tooltip.Visible = false
        end)
    end

    -- Auto-Detect Screen Size
    local Viewport = Camera.ViewportSize
    local StartSize = UDim2.new(0, 700, 0, 500)
    
    if Viewport.X < 800 then
        StartSize = UDim2.new(0.7, 0, 0.6, 0)
    end

    -- Main Frame
    local Main = Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Main,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = StartSize,
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 8)})
    Create("UIStroke", {Parent = Main, Color = Theme.Stroke, Thickness = 1})

    -- Glow
    local Glow = Create("ImageLabel", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0,
        Image = Theme.Glow,
        ImageColor3 = Theme.Accent,
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(20, 20, 280, 280)
    })

    -- Sidebar (Background only)
    local Sidebar = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Theme.Sidebar,
        Size = UDim2.new(0, 180, 1, 0),
        ZIndex = 1 
    })
    Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 8)})
    Create("Frame", {Parent = Sidebar, BackgroundColor3 = Theme.Sidebar, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0), BorderSizePixel = 0})

    -- Title
    local Title = Create("TextLabel", {
        Parent = Main, 
        Text = name,
        Font = Enum.Font.GothamBlack,
        TextColor3 = Theme.Accent,
        TextSize = 22,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 200, 0, 60),
        Position = UDim2.new(0, 0, 0, 5),
        ZIndex = 10,
        TextXAlignment = Enum.TextXAlignment.Center
    })

    -- Drag Area
    local TopbarArea = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 60),
        ZIndex = 15
    })
    MakeDraggable(TopbarArea, Main)

    -- WINDOW CONTROLS
    local ControlHolder = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 60, 0, 30),
        Position = UDim2.new(1, -65, 0, 15), 
        ZIndex = 20
    })
    
    local MinBtn = Create("ImageButton", {
        Parent = ControlHolder,
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926307971",
        ImageRectOffset = Vector2.new(884, 284),
        ImageRectSize = Vector2.new(36, 36),
        ImageColor3 = Theme.TextDim,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 0, 0, 0)
    })

    local CloseBtn = Create("ImageButton", {
        Parent = ControlHolder,
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
        ImageRectOffset = Vector2.new(284, 4),
        ImageRectSize = Vector2.new(24, 24),
        ImageColor3 = Theme.TextDim,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 30, 0, 0)
    })

    local ContentArea -- Forward decl
    local Minimized = false
    local OldSize = Main.Size
    
    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            OldSize = Main.Size
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 250, 0, 60)}):Play()
            Sidebar.Visible = false
            if ContentArea then ContentArea.Visible = false end
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.TextXAlignment = Enum.TextXAlignment.Left
        else
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = OldSize}):Play()
            task.wait(0.2)
            Sidebar.Visible = true
            if ContentArea then ContentArea.Visible = true end
            Title.Position = UDim2.new(0, 0, 0, 5)
            Title.TextXAlignment = Enum.TextXAlignment.Center
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(Main, TweenInfo.new(0.2), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
        wait(0.2)
        ScreenGui:Destroy()
    end)
    
    CloseBtn.MouseEnter:Connect(function() CloseBtn.ImageColor3 = Color3.fromRGB(255, 80, 80) end)
    CloseBtn.MouseLeave:Connect(function() CloseBtn.ImageColor3 = Theme.TextDim end)

    -- RESIZE HANDLE
    local ResizeHandle = Create("TextButton", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -20, 1, -20),
        Text = "◢",
        Font = Enum.Font.Gotham,
        TextSize = 20,
        TextColor3 = Theme.TextDim,
        ZIndex = 50,
        AutoButtonColor = false
    })

    local Resizing = false
    local ResizeStartPos, ResizeStartSize

    ResizeHandle.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not Minimized then
            Resizing = true
            ResizeStartPos = input.Position
            ResizeStartSize = Main.AbsoluteSize
            ResizeHandle.TextColor3 = Theme.Accent
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = input.Position - ResizeStartPos
            local NewX = math.max(500, ResizeStartSize.X + Delta.X)
            local NewY = math.max(350, ResizeStartSize.Y + Delta.Y)
            Main.Size = UDim2.new(0, NewX, 0, NewY)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Resizing = false
            ResizeHandle.TextColor3 = Theme.TextDim
        end
    end)

    -- // PLAYER PROFILE (NEW)
    local ProfileFrame = Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Theme.Section,
        Size = UDim2.new(0, 160, 0, 50),
        Position = UDim2.new(0, 10, 1, -60),
        ZIndex = 5
    })
    Create("UICorner", {Parent = ProfileFrame, CornerRadius = UDim.new(0, 6)})
    Create("UIStroke", {Parent = ProfileFrame, Color = Theme.Stroke, Thickness = 1})

    local AvatarImg = Create("ImageLabel", {
        Parent = ProfileFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 34, 0, 34),
        Position = UDim2.new(0, 8, 0, 8),
        Image = "rbxassetid://0" -- Placeholder
    })
    Create("UICorner", {Parent = AvatarImg, CornerRadius = UDim.new(1, 0)})
    
    -- Async load avatar
    task.spawn(function()
        local content = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        AvatarImg.Image = content
    end)

    local PName = Create("TextLabel", {
        Parent = ProfileFrame,
        Text = LocalPlayer.DisplayName,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextMain,
        TextSize = 12,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -55, 0, 16),
        Position = UDim2.new(0, 50, 0, 8),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    })

    local PUser = Create("TextLabel", {
        Parent = ProfileFrame,
        Text = "@" .. LocalPlayer.Name,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextDim,
        TextSize = 10,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -55, 0, 14),
        Position = UDim2.new(0, 50, 0, 24),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    })

    -- Tab Container (Уменьшили размер, чтобы вместить профиль)
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 80),
        Size = UDim2.new(1, 0, 1, -150), -- Изменено с -80 на -150
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0,0,0,0),
        ZIndex = 2
    })
    local TabList = Create("UIListLayout", {Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})

    -- Content Area
    ContentArea = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 190, 0, 10),
        Size = UDim2.new(1, -200, 1, -20),
        ClipsDescendants = true
    })
    
    function Window:Notify(config)
        local Title = config.Title or "Notification"
        local Content = config.Content or "No content provided."
        local Duration = config.Duration or 3
        local Icon = config.Image or Icons.Bell or "6031091009"

        local NFrame = Create("Frame", {
            Parent = NotifyContainer,
            BackgroundColor3 = Theme.Main,
            Size = UDim2.new(1, 0, 0, 60),
            Position = UDim2.new(1, 20, 0, 0), -- Start offscreen
            BackgroundTransparency = 0.1
        })
        Create("UICorner", {Parent = NFrame, CornerRadius = UDim.new(0, 6)})
        Create("UIStroke", {Parent = NFrame, Color = Theme.Stroke, Thickness = 1})
        
        -- Glow
        Create("ImageLabel", {
            Parent = NFrame,
            Image = Theme.Glow,
            ImageColor3 = Theme.Accent,
            ImageTransparency = 0.8,
            Position = UDim2.new(0, -10, 0, -10),
            Size = UDim2.new(1, 20, 1, 20),
            BackgroundTransparency = 1,
            ZIndex = 0,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(20,20,280,280)
        })

        local SideBar = Create("Frame", {
            Parent = NFrame,
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(0, 3, 1, -10),
            Position = UDim2.new(0, 0, 0, 5)
        })
        Create("UICorner", {Parent = SideBar, CornerRadius = UDim.new(0, 4)})

        local IconImg = Create("ImageLabel", {
            Parent = NFrame,
            Image = "rbxassetid://" .. Icon,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 12, 0, 10),
            ImageColor3 = Theme.TextMain
        })

        local NTitle = Create("TextLabel", {
            Parent = NFrame,
            Text = Title,
            Font = Enum.Font.GothamBold,
            TextColor3 = Theme.TextMain,
            TextSize = 13,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -50, 0, 20),
            Position = UDim2.new(0, 40, 0, 10),
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local NDesc = Create("TextLabel", {
            Parent = NFrame,
            Text = Content,
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.TextDim,
            TextSize = 11,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -50, 0, 20),
            Position = UDim2.new(0, 40, 0, 30),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        })

        local TimeBarBase = Create("Frame", {
            Parent = NFrame,
            BackgroundColor3 = Color3.fromRGB(40,40,45),
            Size = UDim2.new(1, -10, 0, 2),
            Position = UDim2.new(0, 5, 1, -3),
            BorderSizePixel = 0
        })
        local TimeBar = Create("Frame", {
            Parent = TimeBarBase,
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0
        })

        -- Animations
        TweenService:Create(NFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(TimeBar, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

        task.delay(Duration, function()
            TweenService:Create(NFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0, 0)}):Play()
            wait(0.5)
            NFrame:Destroy()
        end)
    end

    local Tabs = {}
    local FirstTab = true
    local CurrentTab = nil

    function Window:Tab(text, icon)
        --// АВТОМАТИЧЕСКАЯ ЗАМЕНА ИКОНКИ ПО НАЗВАНИЮ
        if icon and Icons[icon] then
            icon = Icons[icon]
        end

        local Tab = {}
        local TabBtn = Create("TextButton", {
            Parent = TabContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 42),
            Text = "",
            AutoButtonColor = false,
            ZIndex = 3
        })

        local TabLabel = Create("TextLabel", {
            Parent = TabBtn,
            Text = text,
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme.TextDim,
            TextSize = 14,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -45, 1, 0),
            Position = UDim2.new(0, 45, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3
        })

        local Indicator = Create("Frame", {
            Parent = TabBtn,
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(0, 3, 0, 24),
            Position = UDim2.new(0, 0, 0.5, -12),
            BackgroundTransparency = 1,
            ZIndex = 3
        })

        if icon then
            Create("ImageLabel", {
                Parent = TabBtn,
                Image = "rbxassetid://"..icon,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 15, 0.5, -10),
                ImageColor3 = Theme.TextDim,
                ZIndex = 3
            })
        end

        local PageFrame = Create("Frame", {
            Parent = ContentArea,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false
        })

        local SubTabContainer = Create("Frame", {
            Parent = PageFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 35),
            Visible = false
        })
        local SubTabList = Create("UIListLayout", {
            Parent = SubTabContainer,
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })

        local RealContent = Create("Frame", {
            Parent = PageFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
        })

        local function Activate()
            if CurrentTab then
                TweenService:Create(CurrentTab.Label, TweenInfo.new(0.3), {TextColor3 = Theme.TextDim}):Play()
                TweenService:Create(CurrentTab.Ind, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                CurrentTab.Page.Visible = false
            end
            CurrentTab = {Label = TabLabel, Ind = Indicator, Page = PageFrame}
            TweenService:Create(TabLabel, TweenInfo.new(0.3), {TextColor3 = Theme.TextMain}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            PageFrame.Visible = true
        end
        TabBtn.MouseButton1Click:Connect(Activate)
        if FirstTab then Activate(); FirstTab = false end

        local function CreateContentPage(parent)
            local Scroll = Create("ScrollingFrame", {
                Parent = parent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Theme.Accent,
                CanvasSize = UDim2.new(0,0,0,0)
            })
            
            local Layout = Create("UIListLayout", {
                Parent = Scroll,
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 15)
            })
            
            local LeftCol = Create("Frame", {Parent = Scroll, BackgroundTransparency = 1, Size = UDim2.new(0.5, -8, 1, 0)})
            local LeftList = Create("UIListLayout", {Parent = LeftCol, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12)})
            
            local RightCol = Create("Frame", {Parent = Scroll, BackgroundTransparency = 1, Size = UDim2.new(0.5, -8, 1, 0)})
            local RightList = Create("UIListLayout", {Parent = RightCol, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12)})

            local function UpdateCanvas()
                Scroll.CanvasSize = UDim2.new(0, 0, 0, math.max(LeftList.AbsoluteContentSize.Y, RightList.AbsoluteContentSize.Y) + 20)
            end
            LeftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
            RightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)

            return {Left = LeftCol, Right = RightCol, LList = LeftList, RList = RightList}
        end

        local DefaultPageObj = CreateContentPage(RealContent)
        
        local SubTabCount = 0
        local CurrentSubTab = nil
        function Tab:SubTab(subName)
            if SubTabCount == 0 then
                SubTabContainer.Visible = true
                RealContent.Position = UDim2.new(0, 0, 0, 40)
                RealContent.Size = UDim2.new(1, 0, 1, -40)
                for _, v in pairs(RealContent:GetChildren()) do v:Destroy() end
            end
            SubTabCount = SubTabCount + 1

            local SubBtn = Create("TextButton", {
                Parent = SubTabContainer,
                Text = subName,
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.TextDim,
                TextSize = 13,
                BackgroundColor3 = Theme.Section,
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = SubBtn, CornerRadius = UDim.new(0, 6)})
            Create("UIPadding", {Parent = SubBtn, PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10)})
            
            local SubPage = Create("Frame", {
                Parent = RealContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Visible = false
            })
            local PageObj = CreateContentPage(SubPage)

            SubBtn.MouseButton1Click:Connect(function()
                if CurrentSubTab then
                    TweenService:Create(CurrentSubTab.Btn, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim, BackgroundColor3 = Theme.Section}):Play()
                    CurrentSubTab.Page.Visible = false
                end
                CurrentSubTab = {Btn = SubBtn, Page = SubPage}
                TweenService:Create(SubBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Main, BackgroundColor3 = Theme.Accent}):Play()
                SubPage.Visible = true
            end)

            if SubTabCount == 1 then
                CurrentSubTab = {Btn = SubBtn, Page = SubPage}
                TweenService:Create(SubBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Main, BackgroundColor3 = Theme.Accent}):Play()
                SubPage.Visible = true
            end

            return PageObj
        end
        
        local function GetTarget(subtab_res)
            if subtab_res then return subtab_res end
            return DefaultPageObj
        end

        function Tab:Section(title, side, subtab_ref)
            local TargetObj = GetTarget(subtab_ref)
            local ParentCol = (side == "Right") and TargetObj.Right or TargetObj.Left
            local ParentList = (side == "Right") and TargetObj.RList or TargetObj.LList

            local SectionFrame = Create("Frame", {
                Parent = ParentCol,
                BackgroundColor3 = Theme.Section,
                Size = UDim2.new(1, 0, 0, 50),
                ClipsDescendants = true
            })
            Create("UICorner", {Parent = SectionFrame, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = SectionFrame, Color = Theme.Stroke, Thickness = 1})

            local SecTitle = Create("TextLabel", {
                Parent = SectionFrame,
                Text = title:upper(),
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Accent,
                TextSize = 11,
                Size = UDim2.new(1, -20, 0, 25),
                Position = UDim2.new(0, 12, 0, 4),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Container = Create("Frame", {
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 28),
                Size = UDim2.new(1, -20, 0, 0)
            })
            local List = Create("UIListLayout", {Parent = Container, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)})

            local function Resize()
                local contentHeight = List.AbsoluteContentSize.Y
                TweenService:Create(SectionFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, contentHeight + 38)}):Play()
            end
            List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Resize)

            local Elements = {}

            --// LABEL
            function Elements:Label(text)
                local Lab = Create("TextLabel", {
                    Parent = Container,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextDim,
                    TextSize = 12,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                Resize()
                return Lab 
            end

            --// PARAGRAPH
            --// PARAGRAPH (ИСПРАВЛЕНО)
--// PARAGRAPH (ИСПРАВЛЕНО)
function Elements:Paragraph(title, content)
    local ParaFrame = Create("Frame", {
        Parent = Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0), 
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    Create("TextLabel", {
        Parent = ParaFrame,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextMain,
        TextSize = 12,
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local ContentFrame = Create("Frame", {
        Parent = ParaFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 18),
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    local ContentLabel = Create("TextLabel", {
        Parent = ContentFrame,
        Text = content,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextDim,
        TextSize = 11,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        TextYAlignment = Enum.TextYAlignment.Top
    })
    
    Create("UIPadding", {
        Parent = ParaFrame, 
        PaddingBottom = UDim.new(0, 5)
    })
    
    Resize()
end

            --// CHECKBOX
            function Elements:Checkbox(text, default, callback, tooltip)
                local State = default or false
                local CBFrame = Create("TextButton", {
                    Parent = Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 26),
                    Text = "",
                    AutoButtonColor = false
                })

                local BoxOutline = Create("Frame", {
                    Parent = CBFrame,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0, 0, 0.5, -10)
                })
                Create("UICorner", {Parent = BoxOutline, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = BoxOutline, Color = Theme.Stroke, Thickness = 1})

                local CheckIcon = Create("ImageLabel", {
                    Parent = BoxOutline,
                    Image = "rbxassetid://6031094667", -- Checkmark
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0.5, -8, 0.5, -8),
                    ImageColor3 = Theme.TextMain,
                    ImageTransparency = State and 0 or 1
                })

                if State then BoxOutline.BackgroundColor3 = Theme.Accent end

                local Label = Create("TextLabel", {
                    Parent = CBFrame,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(1, -25, 1, 0),
                    Position = UDim2.new(0, 25, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                CBFrame.MouseButton1Click:Connect(function()
                    State = not State
                    if State then
                        TweenService:Create(BoxOutline, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
                        TweenService:Create(CheckIcon, TweenInfo.new(0.2), {ImageTransparency = 0, Size = UDim2.new(0,16,0,16)}):Play()
                    else
                        TweenService:Create(BoxOutline, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
                        TweenService:Create(CheckIcon, TweenInfo.new(0.2), {ImageTransparency = 1, Size = UDim2.new(0,0,0,0)}):Play()
                    end
                    callback(State)
                end)
                
                if tooltip then AddTooltip(CBFrame, tooltip) end
                Resize()
            end

            --// RADIO BUTTON (NEW)
            function Elements:RadioButton(text, options, default, callback)
                local RadioFrame = Create("Frame", {
                    Parent = Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0), -- Auto sized
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Create("TextLabel", {
                    Parent = RadioFrame,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local OptionContainer = Create("Frame", {
                    Parent = RadioFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 22),
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                })
                Create("UIListLayout", {
                    Parent = OptionContainer,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 6)
                })

                local CurrentSelected = default or options[1]
                local Visuals = {}

                for _, opt in pairs(options) do
                    local OptBtn = Create("TextButton", {
                        Parent = OptionContainer,
                        BackgroundTransparency = 1,
                        Text = "",
                        Size = UDim2.new(1, 0, 0, 24),
                        AutoButtonColor = false
                    })

                    local Circle = Create("Frame", {
                        Parent = OptBtn,
                        BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(0, 0, 0.5, -9)
                    })
                    Create("UICorner", {Parent = Circle, CornerRadius = UDim.new(1, 0)})
                    Create("UIStroke", {Parent = Circle, Color = Theme.Stroke, Thickness = 1})

                    local Dot = Create("Frame", {
                        Parent = Circle,
                        BackgroundColor3 = Theme.Accent,
                        Size = UDim2.new(0, 10, 0, 10),
                        Position = UDim2.new(0.5, -5, 0.5, -5),
                        BackgroundTransparency = (opt == CurrentSelected) and 0 or 1
                    })
                    Create("UICorner", {Parent = Dot, CornerRadius = UDim.new(1, 0)})

                    local OptLabel = Create("TextLabel", {
                        Parent = OptBtn,
                        Text = opt,
                        Font = Enum.Font.Gotham,
                        TextColor3 = (opt == CurrentSelected) and Theme.TextMain or Theme.TextDim,
                        TextSize = 12,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -25, 1, 0),
                        Position = UDim2.new(0, 25, 0, 0),
                        TextXAlignment = Enum.TextXAlignment.Left
                    })

                    Visuals[opt] = {Dot = Dot, Label = OptLabel}

                    OptBtn.MouseButton1Click:Connect(function()
                        if CurrentSelected == opt then return end
                        
                        -- Reset old
                        if Visuals[CurrentSelected] then
                            TweenService:Create(Visuals[CurrentSelected].Dot, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                            TweenService:Create(Visuals[CurrentSelected].Label, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim}):Play()
                        end

                        CurrentSelected = opt
                        -- Set new
                        TweenService:Create(Visuals[CurrentSelected].Dot, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
                        TweenService:Create(Visuals[CurrentSelected].Label, TweenInfo.new(0.2), {TextColor3 = Theme.TextMain}):Play()
                        
                        callback(opt)
                    end)
                end
                
                Create("UIPadding", {Parent = RadioFrame, PaddingBottom = UDim.new(0, 5)})
                Resize()
            end

            --// TOGGLE
            function Elements:Toggle(text, default, callback)
                local State = default or false
                local TFrame = Create("TextButton", {
                    Parent = Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 26),
                    Text = "",
                    AutoButtonColor = false
                })

                Create("TextLabel", {
                    Parent = TFrame,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(1, -40, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local TBox = Create("Frame", {
                    Parent = TFrame,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                    Size = UDim2.new(0, 36, 0, 18),
                    Position = UDim2.new(1, -36, 0.5, -9)
                })
                Create("UICorner", {Parent = TBox, CornerRadius = UDim.new(1, 0)})
                
                local TDot = Create("Frame", {
                    Parent = TBox,
                    BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = State and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                })
                Create("UICorner", {Parent = TDot, CornerRadius = UDim.new(1, 0)})

                if State then TBox.BackgroundColor3 = Theme.Accent end

                TFrame.MouseButton1Click:Connect(function()
                    State = not State
                    TweenService:Create(TBox, TweenInfo.new(0.2), {BackgroundColor3 = State and Theme.Accent or Color3.fromRGB(40, 40, 45)}):Play()
                    TweenService:Create(TDot, TweenInfo.new(0.2), {Position = State and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
                    callback(State)
                end)
                Resize()
            end
            
            --// INPUT
            function Elements:Input(text, placeholder, callback, tooltip)
                local InputFrame = Create("Frame", {
                    Parent = Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 45)
                })
                
                Create("TextLabel", {
                    Parent = InputFrame,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local BoxBg = Create("Frame", {
                    Parent = InputFrame,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                    Size = UDim2.new(1, 0, 0, 25),
                    Position = UDim2.new(0, 0, 0, 20)
                })
                Create("UICorner", {Parent = BoxBg, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = BoxBg, Color = Theme.Stroke, Thickness = 1})

                local Box = Create("TextBox", {
                    Parent = BoxBg,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -10, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    Font = Enum.Font.Gotham,
                    Text = "",
                    PlaceholderText = placeholder or "Type here...",
                    TextColor3 = Theme.TextMain,
                    PlaceholderColor3 = Theme.TextDim,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ClearTextOnFocus = false
                })

                Box.FocusLost:Connect(function()
                    callback(Box.Text)
                end)
                
                if tooltip then AddTooltip(InputFrame, tooltip) end
                Resize()
            end
            
            --// KEYBIND
            function Elements:Keybind(text, defaultKey, callback, tooltip)
                local Key = defaultKey or Enum.KeyCode.E
                local Binding = false
                
                local BindFrame = Create("Frame", {
                    Parent = Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30)
                })
                
                Create("TextLabel", {
                    Parent = BindFrame,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(0.6, 0, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local BindBtn = Create("TextButton", {
                    Parent = BindFrame,
                    Text = Key.Name,
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Theme.TextDim,
                    TextSize = 11,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                    Size = UDim2.new(0, 60, 0, 20),
                    Position = UDim2.new(1, -60, 0.5, -10),
                    AutoButtonColor = false
                })
                Create("UICorner", {Parent = BindBtn, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = BindBtn, Color = Theme.Stroke, Thickness = 1})

                BindBtn.MouseButton1Click:Connect(function()
                    Binding = true
                    BindBtn.Text = "..."
                    
                    local con
                    con = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            Key = input.KeyCode
                            BindBtn.Text = Key.Name
                            Binding = false
                            callback(Key)
                            con:Disconnect()
                        end
                    end)
                end)
                
                if tooltip then AddTooltip(BindFrame, tooltip) end
                Resize()
            end

            --// SLIDER
            function Elements:Slider(text, min, max, default, callback)
                local Value = default or min
                local SFrame = Create("Frame", {Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40)})
                
                Create("TextLabel", {
                    Parent = SFrame,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(0.7, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local ValLabel = Create("TextLabel", {
                    Parent = SFrame,
                    Text = tostring(Value),
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Theme.Accent,
                    TextSize = 12,
                    Size = UDim2.new(0.3, 0, 0, 20),
                    Position = UDim2.new(0.7, 0, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right
                })

                local Bar = Create("Frame", {
                    Parent = SFrame,
                    BackgroundColor3 = Color3.fromRGB(40,40,45),
                    Size = UDim2.new(1, 0, 0, 4),
                    Position = UDim2.new(0, 0, 0, 28)
                })
                Create("UICorner", {Parent = Bar, CornerRadius = UDim.new(1,0)})
                
                local Fill = Create("Frame", {
                    Parent = Bar,
                    BackgroundColor3 = Theme.Accent,
                    Size = UDim2.new((Value-min)/(max-min), 0, 1, 0)
                })
                Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1,0)})

                local function Update(input)
                    local P = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    Value = math.floor(min + (max-min)*P)
                    ValLabel.Text = tostring(Value)
                    TweenService:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(P, 0, 1, 0)}):Play()
                    callback(Value)
                end

                local Dragging = false
                Bar.InputBegan:Connect(function(input) 
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
                        Dragging = true; Update(input) 
                    end 
                end)
                UserInputService.InputEnded:Connect(function(input) 
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = false end 
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then Update(input) end
                end)
                Resize()
            end

            --// DROPDOWN
            function Elements:Dropdown(text, items, callback)
                local DropFrame = Create("Frame", {Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), ClipsDescendants = true})
                local Open = false
                
                local Header = Create("TextButton", {
                    Parent = DropFrame,
                    Text = "",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    AutoButtonColor = false
                })
                
                Create("TextLabel", {
                    Parent = Header,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(1, -25, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Arrow = Create("ImageLabel", {
                    Parent = Header,
                    Image = "rbxassetid://6031091004",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(1, -16, 0.5, -8),
                    ImageColor3 = Theme.Accent
                })

                local ListFrame = Create("Frame", {
                    Parent = DropFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 30),
                    Size = UDim2.new(1, 0, 0, 0)
                })
                local ItemList = Create("UIListLayout", {Parent = ListFrame, SortOrder = Enum.SortOrder.LayoutOrder})

                local function Toggle()
                    Open = not Open
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = Open and 180 or 0}):Play()
                    TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, Open and (30 + ItemList.AbsoluteContentSize.Y) or 30)}):Play()
                    wait(0.05); Resize(); wait(0.3); Resize()
                end
                Header.MouseButton1Click:Connect(Toggle)

                for _, item in pairs(items) do
                    local IB = Create("TextButton", {
                        Parent = ListFrame,
                        Text = item,
                        Font = Enum.Font.Gotham,
                        TextColor3 = Theme.TextDim,
                        TextSize = 12,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 24)
                    })
                    IB.MouseButton1Click:Connect(function()
                        callback(item)
                        Toggle()
                    end)
                end
                Resize()
            end

            --// MULTI DROPDOWN
            function Elements:MultiDropdown(text, items, callback)
                local DropFrame = Create("Frame", {Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), ClipsDescendants = true})
                local Open = false
                local Selected = {}
                
                local Header = Create("TextButton", {
                    Parent = DropFrame,
                    Text = "",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    AutoButtonColor = false
                })
                
                local TitleLbl = Create("TextLabel", {
                    Parent = Header,
                    Text = text .. " [...]",
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(1, -25, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local Arrow = Create("ImageLabel", {
                    Parent = Header,
                    Image = "rbxassetid://6031091004",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(1, -16, 0.5, -8),
                    ImageColor3 = Theme.Accent
                })

                local ListFrame = Create("Frame", {
                    Parent = DropFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 30),
                    Size = UDim2.new(1, 0, 0, 0)
                })
                local ItemList = Create("UIListLayout", {Parent = ListFrame, SortOrder = Enum.SortOrder.LayoutOrder})

                local function UpdateTitle()
                    local count = 0
                    for k, v in pairs(Selected) do if v then count = count + 1 end end
                    TitleLbl.Text = (count == 0) and (text .. " [...]") or (text .. " [" .. count .. "]")
                end

                local function Toggle()
                    Open = not Open
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = Open and 180 or 0}):Play()
                    TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, Open and (30 + ItemList.AbsoluteContentSize.Y) or 30)}):Play()
                    wait(0.05); Resize(); wait(0.3); Resize()
                end
                Header.MouseButton1Click:Connect(Toggle)

                for _, item in pairs(items) do
                    Selected[item] = false
                    local IB = Create("TextButton", {
                        Parent = ListFrame,
                        Text = item,
                        Font = Enum.Font.Gotham,
                        TextColor3 = Theme.TextDim,
                        TextSize = 12,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 24)
                    })
                    
                    IB.MouseButton1Click:Connect(function()
                        Selected[item] = not Selected[item]
                        IB.TextColor3 = Selected[item] and Theme.Accent or Theme.TextDim
                        UpdateTitle()
                        callback(Selected)
                    end)
                end
                Resize()
            end

            --// COLOR PICKER
            function Elements:ColorPicker(text, defaultColor, defaultAlpha, callback)
                local h, s, v = Color3.toHSV(defaultColor or Color3.new(1,1,1))
                local alpha = defaultAlpha or 0
                local Color = Color3.fromHSV(h,s,v)
                local Open = false
                
                local CPFrame = Create("Frame", {
                    Parent = Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    ClipsDescendants = true
                })
                
                local Header = Create("TextButton", {
                    Parent = CPFrame,
                    Text = "",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    AutoButtonColor = false
                })

                Create("TextLabel", {
                    Parent = Header,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(1, -40, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local PreviewBg = Create("ImageLabel", {
                    Parent = Header,
                    Image = "rbxassetid://382766746",
                    ScaleType = Enum.ScaleType.Tile,
                    TileSize = UDim2.new(0,10,0,10),
                    Size = UDim2.new(0, 30, 0, 16),
                    Position = UDim2.new(1, -30, 0.5, -8),
                    BorderSizePixel = 0
                })
                Create("UICorner", {Parent = PreviewBg, CornerRadius = UDim.new(0, 4)})

                local Preview = Create("Frame", {
                    Parent = PreviewBg,
                    BackgroundColor3 = Color,
                    BackgroundTransparency = alpha,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                Create("UICorner", {Parent = Preview, CornerRadius = UDim.new(0, 4)})

                local Palette = Create("Frame", {
                    Parent = CPFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 30),
                    Size = UDim2.new(1, 0, 0, 195)
                })

                -- 1. SV
                local SVMap = Create("Frame", {
                    Parent = Palette,
                    Size = UDim2.new(1, 0, 0, 100),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                    BorderSizePixel = 0
                })
                Create("UICorner", {Parent = SVMap, CornerRadius = UDim.new(0, 4)})
                
                local SatGradient = Create("Frame", {
                    Parent = SVMap,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.new(1,1,1),
                    BorderSizePixel = 0,
                    ZIndex = 2
                })
                Create("UICorner", {Parent = SatGradient, CornerRadius = UDim.new(0, 4)})
                Create("UIGradient", {Parent = SatGradient, Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}})

                local ValGradient = Create("Frame", {
                    Parent = SVMap,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.new(0,0,0),
                    BorderSizePixel = 0,
                    ZIndex = 3
                })
                Create("UICorner", {Parent = ValGradient, CornerRadius = UDim.new(0, 4)})
                Create("UIGradient", {
                    Parent = ValGradient, 
                    Rotation = -90,
                    Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}
                })

                local SVCursor = Create("ImageLabel", {
                    Parent = ValGradient,
                    Image = "rbxassetid://4953646208",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(s, -6, 1 - v, -6),
                    ZIndex = 4
                })

                -- 2. Hue
                local HueBar = Create("Frame", {
                    Parent = Palette,
                    Size = UDim2.new(1, 0, 0, 18),
                    Position = UDim2.new(0, 0, 0, 110),
                    BackgroundColor3 = Color3.new(1,1,1),
                    BorderSizePixel = 0
                })
                Create("UICorner", {Parent = HueBar, CornerRadius = UDim.new(0, 4)})
                Create("UIGradient", {
                    Parent = HueBar,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
                    }
                })

                local HueCursor = Create("Frame", {
                    Parent = HueBar,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 2, 1, 0),
                    Position = UDim2.new(h, -1, 0, 0),
                    BorderSizePixel = 0,
                    ZIndex = 5
                })
                Create("UIStroke", {Parent = HueCursor, Color = Color3.new(0,0,0), Thickness = 1})

                -- 3. Alpha
                local AlphaBar = Create("ImageLabel", {
                    Parent = Palette,
                    Image = "rbxassetid://382766746",
                    ScaleType = Enum.ScaleType.Tile,
                    TileSize = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, 0, 0, 18),
                    Position = UDim2.new(0, 0, 0, 135)
                })
                Create("UICorner", {Parent = AlphaBar, CornerRadius = UDim.new(0, 4)})
                
                local AlphaGradient = Create("Frame", {
                    Parent = AlphaBar,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                Create("UICorner", {Parent = AlphaGradient, CornerRadius = UDim.new(0, 4)})
                Create("UIGradient", {Parent = AlphaGradient, Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}})

                local AlphaCursor = Create("Frame", {
                    Parent = AlphaBar,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 2, 1, 0),
                    Position = UDim2.new(alpha, -1, 0, 0),
                    BorderSizePixel = 0,
                    ZIndex = 5
                })
                Create("UIStroke", {Parent = AlphaCursor, Color = Color3.new(0,0,0), Thickness = 1})

                -- 4. INPUTS
                local InputFrame = Create("Frame", {
                    Parent = Palette,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 160),
                    Size = UDim2.new(1, 0, 0, 30)
                })

                local Inputs = {}
                local function CreateInput(name, ph, sizeX, posX)
                    local BoxFrame = Create("Frame", {
                        Parent = InputFrame,
                        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                        Size = UDim2.new(sizeX, 0, 1, 0),
                        Position = UDim2.new(posX, 0, 0, 0)
                    })
                    Create("UICorner", {Parent = BoxFrame, CornerRadius = UDim.new(0, 4)})
                    Create("UIStroke", {Parent = BoxFrame, Color = Theme.Stroke, Thickness = 1})
                    
                    local Box = Create("TextBox", {
                        Parent = BoxFrame,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        Font = Enum.Font.GothamBold,
                        Text = "",
                        PlaceholderText = ph,
                        TextColor3 = Theme.TextMain,
                        PlaceholderColor3 = Theme.TextDim,
                        TextSize = 11
                    })
                    Inputs[name] = Box
                    return Box
                end

                CreateInput("R", "R", 0.18, 0)
                CreateInput("G", "G", 0.18, 0.22)
                CreateInput("B", "B", 0.18, 0.44)
                CreateInput("Hex", "Hex", 0.32, 0.68)

                local IgnoreUpdate = false

                local function UpdateColor()
                    Color = Color3.fromHSV(h, s, v)
                    Preview.BackgroundColor3 = Color
                    Preview.BackgroundTransparency = alpha
                    SVMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    
                    if not IgnoreUpdate then
                        IgnoreUpdate = true
                        Inputs.R.Text = tostring(math.floor(Color.R * 255))
                        Inputs.G.Text = tostring(math.floor(Color.G * 255))
                        Inputs.B.Text = tostring(math.floor(Color.B * 255))
                        Inputs.Hex.Text = "#" .. Color:ToHex()
                        IgnoreUpdate = false
                    end
                    
                    callback(Color, alpha)
                end

                local function SetRGB()
                    local r = tonumber(Inputs.R.Text) or 0
                    local g = tonumber(Inputs.G.Text) or 0
                    local b = tonumber(Inputs.B.Text) or 0
                    Color = Color3.fromRGB(r, g, b)
                    h, s, v = Color3.toHSV(Color)
                    TweenService:Create(HueCursor, TweenInfo.new(0.2), {Position = UDim2.new(h, -1, 0, 0)}):Play()
                    TweenService:Create(SVCursor, TweenInfo.new(0.2), {Position = UDim2.new(s, -6, 1-v, -6)}):Play()
                    UpdateColor()
                end

                local function SetHex()
                    local hex = Inputs.Hex.Text:gsub("#", "")
                    local s, result = pcall(function() return Color3.fromHex(hex) end)
                    if s and result then
                        Color = result
                        h, s, v = Color3.toHSV(Color)
                        TweenService:Create(HueCursor, TweenInfo.new(0.2), {Position = UDim2.new(h, -1, 0, 0)}):Play()
                        TweenService:Create(SVCursor, TweenInfo.new(0.2), {Position = UDim2.new(s, -6, 1-v, -6)}):Play()
                        UpdateColor()
                    end
                end

                Inputs.R.FocusLost:Connect(SetRGB)
                Inputs.G.FocusLost:Connect(SetRGB)
                Inputs.B.FocusLost:Connect(SetRGB)
                Inputs.Hex.FocusLost:Connect(SetHex)

                local Dragging = {SV = false, Hue = false, Alpha = false}

                local function MonitorInput(input, type)
                    if type == "SV" then
                        local relativeX = math.clamp((input.Position.X - SVMap.AbsolutePosition.X) / SVMap.AbsoluteSize.X, 0, 1)
                        local relativeY = math.clamp((input.Position.Y - SVMap.AbsolutePosition.Y) / SVMap.AbsoluteSize.Y, 0, 1)
                        s = relativeX
                        v = 1 - relativeY
                        TweenService:Create(SVCursor, TweenInfo.new(0.05), {Position = UDim2.new(s, -6, 1-v, -6)}):Play()
                    elseif type == "Hue" then
                        local relativeX = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
                        h = relativeX
                        TweenService:Create(HueCursor, TweenInfo.new(0.05), {Position = UDim2.new(h, -1, 0, 0)}):Play()
                    elseif type == "Alpha" then
                        local relativeX = math.clamp((input.Position.X - AlphaBar.AbsolutePosition.X) / AlphaBar.AbsoluteSize.X, 0, 1)
                        alpha = relativeX
                        TweenService:Create(AlphaCursor, TweenInfo.new(0.05), {Position = UDim2.new(alpha, -1, 0, 0)}):Play()
                    end
                    UpdateColor()
                end

                SVMap.InputBegan:Connect(function(input) 
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging.SV = true; MonitorInput(input, "SV") end 
                end)
                HueBar.InputBegan:Connect(function(input) 
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging.Hue = true; MonitorInput(input, "Hue") end 
                end)
                AlphaBar.InputBegan:Connect(function(input) 
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging.Alpha = true; MonitorInput(input, "Alpha") end 
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        if Dragging.SV then MonitorInput(input, "SV")
                        elseif Dragging.Hue then MonitorInput(input, "Hue")
                        elseif Dragging.Alpha then MonitorInput(input, "Alpha") end
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging.SV = false; Dragging.Hue = false; Dragging.Alpha = false
                    end
                end)

                Header.MouseButton1Click:Connect(function()
                    Open = not Open
                    TweenService:Create(CPFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, Open and 225 or 30)}):Play()
                    task.wait(0.05); Resize(); task.wait(0.3); Resize()
                end)
                
                UpdateColor()
                Resize()
            end
            
            --// BUTTON
            function Elements:Button(text, callback)
                 local Btn = Create("TextButton", {
                    Parent = Container,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                    Size = UDim2.new(1, 0, 0, 30),
                    AutoButtonColor = false
                })
                Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = Btn, Color = Theme.Stroke, Thickness = 1})

                Btn.MouseButton1Click:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent, TextColor3 = Color3.new(0,0,0)}):Play()
                    wait(0.15)
                    TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40), TextColor3 = Theme.TextMain}):Play()
                    callback()
                end)
                Resize()
            end

            return Elements
        end
        return Tab
    end
    return Window
end

return Library
