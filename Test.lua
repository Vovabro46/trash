local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local Library = {
    Flags = {},
    Items = {},
    Registry = {}, -- Реестр для поиска
    ActivePicker = nil,
    WatermarkObj = nil,
    NotifyContainer = nil,
    Preview = nil,
    ConfigFolder = "RedOnyx_Configs",
    ConfigExt = ".json",
    WatermarkSettings = {
        Enabled = true,
        Text = "RedOnyx"
    },
    Theme = {
        Background = Color3.fromRGB(15, 15, 15),
        Sidebar    = Color3.fromRGB(20, 20, 20),
        Groupbox   = Color3.fromRGB(25, 25, 25),
        Outline    = Color3.fromRGB(45, 45, 45),
        Accent     = Color3.fromRGB(255, 40, 40),
        Text       = Color3.fromRGB(235, 235, 235),
        TextDark   = Color3.fromRGB(140, 140, 140),
        Header     = Color3.fromRGB(100, 100, 100)
    }
}

--// TOOLTIP SYSTEM //--
local TooltipObj = nil
local function CreateTooltipSystem(ScreenGui)
    local Tooltip = Instance.new("TextLabel")
    Tooltip.Name = "Tooltip"
    Tooltip.Size = UDim2.new(0, 0, 0, 0)
    Tooltip.AutomaticSize = Enum.AutomaticSize.XY
    Tooltip.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tooltip.Font = Enum.Font.Gotham
    Tooltip.TextSize = 12
    Tooltip.TextWrapped = false
    Tooltip.Visible = false
    Tooltip.ZIndex = 1000
    Tooltip.Parent = ScreenGui

    Instance.new("UICorner", Tooltip).CornerRadius = UDim.new(0, 4)
    local TStroke = Instance.new("UIStroke", Tooltip)
    TStroke.Color = Color3.fromRGB(60, 60, 60)
    TStroke.Thickness = 1
    Instance.new("UIPadding", Tooltip).PaddingLeft = UDim.new(0, 6)
    Instance.new("UIPadding", Tooltip).PaddingRight = UDim.new(0, 6)
    Instance.new("UIPadding", Tooltip).PaddingTop = UDim.new(0, 4)
    Instance.new("UIPadding", Tooltip).PaddingBottom = UDim.new(0, 4)

    RunService.RenderStepped:Connect(function()
        if Tooltip.Visible then
            local MPos = UserInputService:GetMouseLocation()
            Tooltip.Position = UDim2.new(0, MPos.X + 15, 0, MPos.Y + 15)
        end
    end)

    TooltipObj = Tooltip
end

local function AddTooltip(HoverObject, Text)
    if not Text or Text == "" or not TooltipObj then return end
    HoverObject.MouseEnter:Connect(function()
        TooltipObj.Text = Text
        TooltipObj.Visible = true
    end)
    HoverObject.MouseLeave:Connect(function()
        TooltipObj.Visible = false
    end)
end

--// NOTIFICATIONS //--
function Library:InitNotifications(ScreenGui)
    local Holder = Instance.new("Frame")
    Holder.Name = "Notifications"
    Holder.Size = UDim2.new(0, 300, 1, -20)
    Holder.Position = UDim2.new(1, -310, 0, 10)
    Holder.AnchorPoint = Vector2.new(0, 0)
    Holder.BackgroundTransparency = 1
    Holder.ZIndex = 1000 
    Holder.Parent = ScreenGui

    local List = Instance.new("UIListLayout", Holder)
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.VerticalAlignment = Enum.VerticalAlignment.Bottom
    List.Padding = UDim.new(0, 6)

    Library.NotifyContainer = Holder
end

function Library:Notify(Title, Content, Duration)
    if not Library.NotifyContainer then return end
    Duration = Duration or 3

    local Wrapper = Instance.new("Frame")
    Wrapper.Name = "NotifyWrapper"
    Wrapper.Size = UDim2.new(1, 0, 0, 0)
    Wrapper.BackgroundTransparency = 1
    Wrapper.ClipsDescendants = true
    Wrapper.Parent = Library.NotifyContainer

    local Box = Instance.new("Frame")
    Box.Name = "Box"
    Box.Size = UDim2.new(1, 0, 1, 0)
    Box.Position = UDim2.new(1, 20, 0, 0)
    Box.BackgroundColor3 = Library.Theme.Background
    Box.Parent = Wrapper

    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
    local Stroke = Instance.new("UIStroke", Box)
    Stroke.Thickness = 1
    Stroke.Color = Library.Theme.Outline

    local Line = Instance.new("Frame", Box)
    Line.Size = UDim2.new(0, 2, 1, 0)
    Line.BackgroundColor3 = Library.Theme.Accent
    Instance.new("UICorner", Line).CornerRadius = UDim.new(0, 4)

    local TLab = Instance.new("TextLabel", Box)
    TLab.Size = UDim2.new(1, -15, 0, 20)
    TLab.Position = UDim2.new(0, 10, 0, 5)
    TLab.BackgroundTransparency = 1
    TLab.Text = Title
    TLab.Font = Enum.Font.GothamBold
    TLab.TextSize = 13
    TLab.TextColor3 = Library.Theme.Text
    TLab.TextXAlignment = Enum.TextXAlignment.Left

    local CLab = Instance.new("TextLabel", Box)
    CLab.Size = UDim2.new(1, -15, 0, 20)
    CLab.Position = UDim2.new(0, 10, 0, 25)
    CLab.BackgroundTransparency = 1
    CLab.Text = Content
    CLab.Font = Enum.Font.Gotham
    CLab.TextSize = 12
    CLab.TextColor3 = Library.Theme.TextDark
    CLab.TextXAlignment = Enum.TextXAlignment.Left

    TweenService:Create(Wrapper, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 50)}):Play()
    TweenService:Create(Box, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    task.delay(Duration, function()
        if not Box or not Wrapper then return end
        local OutTween = TweenService:Create(Box, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, 0, 0)})
        OutTween:Play()
        OutTween.Completed:Wait()
        local ShrinkTween = TweenService:Create(Wrapper, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)})
        ShrinkTween:Play()
        ShrinkTween.Completed:Wait()
        Wrapper:Destroy()
    end)
end

--// CONFIG SYSTEM //--
function Library:InitConfig()
    if writefile and readfile and makefolder and listfiles then
        if not isfolder(Library.ConfigFolder) then makefolder(Library.ConfigFolder) end
        return true
    end
    return false
end

function Library:SaveConfig(Name)
    if not Library:InitConfig() or not Name or Name == "" then return end
    local Encoded = HttpService:JSONEncode(Library.Flags)
    writefile(Library.ConfigFolder.."/"..Name..Library.ConfigExt, Encoded)
    Library:Notify("Config Saved", "Successfully saved: " .. Name, 3)
end

function Library:LoadConfig(Name)
    if not Library:InitConfig() or not Name then return end
    local Path = Library.ConfigFolder.."/"..Name..Library.ConfigExt
    if isfile(Path) then
        local Data = HttpService:JSONDecode(readfile(Path))
        if Data then
            for Flag, Value in pairs(Data) do
                if Library.Items[Flag] and Library.Items[Flag].Set then
                    Library.Items[Flag].Set(Value)
                end
            end
            Library:Notify("Config Loaded", "Loaded settings: " .. Name, 3)
        end
    end
end

function Library:GetConfigs()
    if not Library:InitConfig() then return {} end
    local Configs = {}
    if listfiles then
        for _, File in pairs(listfiles(Library.ConfigFolder)) do
            if File:sub(-#Library.ConfigExt) == Library.ConfigExt then
                local Name = File:match("([^/]+)"..Library.ConfigExt.."$") or File
                table.insert(Configs, Name)
            end
        end
    end
    return Configs
end

--// THEME & DRAGGING //--
local ThemeObjects = {}
function Library:RegisterTheme(Obj, Prop, Key)
    if not ThemeObjects[Key] then ThemeObjects[Key] = {} end
    table.insert(ThemeObjects[Key], {Obj = Obj, Prop = Prop})
    Obj[Prop] = Library.Theme[Key]
end

function Library:UpdateTheme(Key, Col)
    Library.Theme[Key] = Col
    if ThemeObjects[Key] then
        for _, D in pairs(ThemeObjects[Key]) do
            pcall(function() TweenService:Create(D.Obj, TweenInfo.new(0.2), {[D.Prop] = Col}):Play() end)
        end
    end
end

local function MakeDraggable(dragFrame, moveFrame)
    local dragging, dragInput, dragStart, startPos
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = moveFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            moveFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

--// WATERMARK //--
function Library:Watermark(Name)
    Library.WatermarkSettings.Text = Name
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Watermark"
    ScreenGui.ResetOnSpawn = false
    if RunService:IsStudio() then ScreenGui.Parent = Player:WaitForChild("PlayerGui") else pcall(function() ScreenGui.Parent = CoreGui end) end

    Library:InitNotifications(ScreenGui)

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 0, 0, 22)
    Frame.Position = UDim2.new(0.01, 0, 0.01, 0)
    Frame.BackgroundColor3 = Library.Theme.Background
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
    Library:RegisterTheme(Frame, "BackgroundColor3", "Background")

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Thickness = 1
    Library:RegisterTheme(Stroke, "Color", "Outline")

    local TopLine = Instance.new("Frame")
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    TopLine.BorderSizePixel = 0
    TopLine.Parent = Frame
    Library:RegisterTheme(TopLine, "BackgroundColor3", "Accent")

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, -10, 1, 0)
    Text.Position = UDim2.new(0, 5, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Font = Enum.Font.GothamBold
    Text.TextSize = 12
    Text.Text = Name
    Text.Parent = Frame
    Library:RegisterTheme(Text, "TextColor3", "Text")

    RunService.RenderStepped:Connect(function()
        ScreenGui.Enabled = Library.WatermarkSettings.Enabled
        if ScreenGui.Enabled then
            local FPS = math.floor(1 / math.max(RunService.RenderStepped:Wait(), 0.001))
            local PingVal = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
            local Ping = math.floor(PingVal:split(" ")[1] or 0)
            local CurrentName = Library.WatermarkSettings.Text
            Text.Text = string.format("%s | FPS: %d | Ping: %d | %s", CurrentName, FPS, Ping, os.date("%H:%M:%S"))
            Frame.Size = UDim2.new(0, Text.TextBounds.X + 14, 0, 24)
        end
    end)
    Library.WatermarkObj = ScreenGui
end

--// MAIN WINDOW //--
function Library:Window(TitleText)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RedOnyxV17_CheckBox"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global 
    if RunService:IsStudio() then ScreenGui.Parent = Player:WaitForChild("PlayerGui") else pcall(function() ScreenGui.Parent = CoreGui end) end

    CreateTooltipSystem(ScreenGui)

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 750, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -375, 0.5, -250)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    Library:RegisterTheme(MainFrame, "BackgroundColor3", "Background")

    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Thickness = 1
    Library:RegisterTheme(MainStroke, "Color", "Outline")
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 4)

    --// SIDEBAR //--
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.Parent = MainFrame
    Sidebar.ZIndex = 2 
    Library:RegisterTheme(Sidebar, "BackgroundColor3", "Sidebar")
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 4)

    local Logo = Instance.new("TextLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(1, 0, 0, 50)
    Logo.BackgroundTransparency = 1
    Logo.Text = TitleText
    Logo.Font = Enum.Font.GothamBlack
    Logo.TextSize = 22
    Logo.Parent = Sidebar
    Logo.ZIndex = 5 
    Library:RegisterTheme(Logo, "TextColor3", "Accent")

    --// SEARCH BAR //--
    local SearchBar = Instance.new("TextBox")
    SearchBar.Name = "SearchBar"
    SearchBar.Size = UDim2.new(1, -20, 0, 30)
    SearchBar.Position = UDim2.new(0, 10, 0, 55)
    SearchBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SearchBar.BorderSizePixel = 0
    SearchBar.PlaceholderText = "Search..."
    SearchBar.Text = ""
    SearchBar.TextColor3 = Library.Theme.Text
    SearchBar.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    SearchBar.Font = Enum.Font.Gotham
    SearchBar.TextSize = 13
    SearchBar.Parent = Sidebar
    SearchBar.ZIndex = 5 
    Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 4)
    local SBStroke = Instance.new("UIStroke", SearchBar)
    SBStroke.Color = Library.Theme.Outline
    SBStroke.Thickness = 1
    SBStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    --// TAB CONTAINER //--
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, -95)
    TabContainer.Position = UDim2.new(0, 0, 0, 95)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar
    TabContainer.ZIndex = 3 
    TabContainer.Visible = true 
    local TabLayout = Instance.new("UIListLayout", TabContainer)
    TabLayout.Padding = UDim.new(0, 2)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    --// SEARCH RESULTS //--
    local SearchResults = Instance.new("ScrollingFrame")
    SearchResults.Name = "SearchResults"
    SearchResults.Size = UDim2.new(1, 0, 1, -95)
    SearchResults.Position = UDim2.new(0, 0, 0, 95)
    SearchResults.BackgroundTransparency = 1
    SearchResults.BackgroundColor3 = Library.Theme.Sidebar 
    SearchResults.ScrollBarThickness = 2
    SearchResults.ScrollBarImageColor3 = Library.Theme.Accent
    SearchResults.Visible = false 
    SearchResults.Parent = Sidebar
    SearchResults.ZIndex = 10 
    local SearchLayout = Instance.new("UIListLayout", SearchResults)
    SearchLayout.Padding = UDim.new(0, 2)
    SearchLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local PagesArea = Instance.new("Frame")
    PagesArea.Name = "PagesArea"
    PagesArea.Size = UDim2.new(1, -180, 1, 0)
    PagesArea.Position = UDim2.new(0, 180, 0, 0)
    PagesArea.BackgroundTransparency = 1
    PagesArea.Parent = MainFrame

    MakeDraggable(Sidebar, MainFrame)
    MakeDraggable(PagesArea, MainFrame)

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleUI"
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
    ToggleBtn.Text = "UI"
    ToggleBtn.TextColor3 = Library.Theme.Accent
    ToggleBtn.Font = Enum.Font.GothamBlack
    ToggleBtn.Parent = ScreenGui
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", ToggleBtn).Color = Library.Theme.Accent
    MakeDraggable(ToggleBtn, ToggleBtn)
    ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    local DropdownHolder = Instance.new("Frame")
    DropdownHolder.Name = "DropdownHolder"
    DropdownHolder.Size = UDim2.new(1,0,1,0)
    DropdownHolder.BackgroundTransparency = 1
    DropdownHolder.Visible = false
    DropdownHolder.ZIndex = 100
    DropdownHolder.Parent = ScreenGui 

    --// SEARCH LOGIC //--
    SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local Input = SearchBar.Text:lower()
        if #Input == 0 then
            TabContainer.Visible = true
            SearchResults.Visible = false
        else
            TabContainer.Visible = false
            SearchResults.Visible = true
            
            for _, v in pairs(SearchResults:GetChildren()) do
                if v:IsA("TextButton") then v:Destroy() end
            end

            for _, ItemData in pairs(Library.Registry) do
                if string.find(ItemData.Name:lower(), Input, 1, true) then
                    local ResBtn = Instance.new("TextButton")
                    ResBtn.Size = UDim2.new(1, 0, 0, 25)
                    ResBtn.BackgroundTransparency = 1
                    ResBtn.Text = "  " .. ItemData.Name
                    ResBtn.Font = Enum.Font.Gotham
                    ResBtn.TextSize = 12
                    ResBtn.TextColor3 = Library.Theme.TextDark
                    ResBtn.TextXAlignment = Enum.TextXAlignment.Left
                    ResBtn.Parent = SearchResults
                    ResBtn.ZIndex = 11
                    
                    local P = Instance.new("UIPadding", ResBtn)
                    P.PaddingLeft = UDim.new(0, 15)

                    ResBtn.MouseButton1Click:Connect(function()
                        if ItemData.TabBtn then
                            for _, v in pairs(TabContainer:GetChildren()) do
                                if v:IsA("TextButton") then
                                    TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextDark}):Play()
                                    if v:FindFirstChild("ActiveIndicator") then v.ActiveIndicator.Visible = false end
                                end
                            end
                            for _, v in pairs(PagesArea:GetChildren()) do v.Visible = false end
                            
                            TweenService:Create(ItemData.TabBtn, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Text}):Play()
                            if ItemData.TabBtn:FindFirstChild("ActiveIndicator") then ItemData.TabBtn.ActiveIndicator.Visible = true end
                            
                            local PageFrame = ItemData.TabBtn:FindFirstChild("PageRef") and ItemData.TabBtn.PageRef.Value
                            if PageFrame then PageFrame.Visible = true end
                        end

                        if ItemData.SubTabBtn and ItemData.SubPage then
                            for _, v in pairs(ItemData.SubPage.Parent:GetChildren()) do 
                                if v:IsA("Frame") then v.Visible = false end 
                            end
                            for _, v in pairs(ItemData.SubTabBtn.Parent:GetChildren()) do 
                                if v:IsA("TextButton") then 
                                    TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextDark}):Play() 
                                end 
                            end
                            
                            ItemData.SubPage.Visible = true
                            TweenService:Create(ItemData.SubTabBtn, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Accent}):Play()
                        end
                        
                        -- Подсветка
                        if ItemData.Object then
                            local OriginalColor = ItemData.Object.BackgroundColor3
                            local HighlightTween = TweenService:Create(ItemData.Object, TweenInfo.new(0.5), {BackgroundColor3 = Library.Theme.Accent})
                            local RestoreTween = TweenService:Create(ItemData.Object, TweenInfo.new(0.5), {BackgroundColor3 = OriginalColor})
                            HighlightTween:Play()
                            HighlightTween.Completed:Wait()
                            RestoreTween:Play()
                        end
                    end)
                end
            end
            SearchResults.CanvasSize = UDim2.new(0, 0, 0, SearchLayout.AbsoluteContentSize.Y)
        end
    end)


    local WindowFuncs = {}
    local FirstTab = true

    function WindowFuncs:Section(Text)
        local L = Instance.new("TextLabel")
        L.Size = UDim2.new(1,0,0,25)
        L.BackgroundTransparency=1
        L.Text="  "..string.upper(Text)
        L.Font=Enum.Font.GothamBold
        L.TextSize=11
        L.TextXAlignment=Enum.TextXAlignment.Left
        L.Parent=TabContainer
        L.ZIndex = 5 
        Library:RegisterTheme(L, "TextColor3", "Header")
        local P=Instance.new("UIPadding",L)
        P.PaddingTop=UDim.new(0,10)
        P.PaddingLeft=UDim.new(0,15)
    end

    function WindowFuncs:Tab(Name)
        local Btn = Instance.new("TextButton")
        Btn.Name = Name
        Btn.Size = UDim2.new(1,0,0,30)
        Btn.BackgroundTransparency=1
        Btn.Text=Name
        Btn.Font=Enum.Font.GothamBold
        Btn.TextSize=14
        Btn.TextXAlignment=Enum.TextXAlignment.Left
        Btn.Parent=TabContainer
        Btn.ZIndex = 4
        Library:RegisterTheme(Btn,"TextColor3","TextDark")
        local P=Instance.new("UIPadding",Btn)
        P.PaddingLeft=UDim.new(0,25)
        
        local Ind=Instance.new("Frame")
        Ind.Name = "ActiveIndicator" 
        Ind.Size=UDim2.new(0,3,0.6,0)
        Ind.Position=UDim2.new(0,-25,0.2,0)
        Ind.Visible=false
        Ind.Parent=Btn
        Ind.ZIndex = 5 
        Library:RegisterTheme(Ind,"BackgroundColor3","Accent")

        local Page=Instance.new("Frame")
        Page.Name = Name.."_Page"
        Page.Size=UDim2.new(1,0,1,0)
        Page.BackgroundTransparency=1
        Page.Visible=false
        Page.Parent=PagesArea
        
        local PageRef = Instance.new("ObjectValue", Btn)
        PageRef.Name = "PageRef"
        PageRef.Value = Page

        local SubTabArea = Instance.new("Frame")
        SubTabArea.Size = UDim2.new(1, -20, 0, 30)
        SubTabArea.Position = UDim2.new(0, 10, 0, 10)
        SubTabArea.BackgroundTransparency = 1
        SubTabArea.Parent = Page
        local SubLayout = Instance.new("UIListLayout", SubTabArea)
        SubLayout.FillDirection = Enum.FillDirection.Horizontal
        SubLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SubLayout.Padding = UDim.new(0, 10)
        local ContentArea = Instance.new("Frame")
        ContentArea.Size = UDim2.new(1, 0, 1, -40)
        ContentArea.Position = UDim2.new(0, 0, 0, 40)
        ContentArea.BackgroundTransparency = 1
        ContentArea.Parent = Page

        if FirstTab then
            FirstTab=false
            Btn.TextColor3=Library.Theme.Text
            Ind.Visible=true
            Page.Visible=true
        end

        Btn.MouseButton1Click:Connect(function()
            for _,v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v,TweenInfo.new(0.2),{TextColor3=Library.Theme.TextDark}):Play()
                    if v:FindFirstChild("ActiveIndicator") then v.ActiveIndicator.Visible=false end
                end
            end
            for _,v in pairs(PagesArea:GetChildren()) do v.Visible=false end
            TweenService:Create(Btn,TweenInfo.new(0.2),{TextColor3=Library.Theme.Text}):Play()
            Ind.Visible=true
            Page.Visible=true
        end)

        local TabFuncs = {}
        local FirstSubTab = true
        
        function TabFuncs:SubTab(SubName)
            local SBtn = Instance.new("TextButton")
            SBtn.Size = UDim2.new(0, 0, 1, 0)
            SBtn.AutomaticSize = Enum.AutomaticSize.X
            SBtn.BackgroundTransparency = 1
            SBtn.Text = SubName
            SBtn.Font = Enum.Font.GothamBold
            SBtn.TextSize = 13
            SBtn.Parent = SubTabArea
            Library:RegisterTheme(SBtn, "TextColor3", "TextDark")
            
            local SubPage = Instance.new("Frame")
            SubPage.Name = SubName.."_SubPage"
            SubPage.Size = UDim2.new(1,0,1,0)
            SubPage.BackgroundTransparency = 1
            SubPage.Visible = false
            SubPage.Parent = ContentArea
            
            local LCol=Instance.new("ScrollingFrame")
            LCol.Size=UDim2.new(0.5,-10,1,-10)
            LCol.Position=UDim2.new(0,10,0,0)
            LCol.BackgroundTransparency=1
            LCol.ScrollBarThickness=0
            LCol.Parent=SubPage
            local RCol=Instance.new("ScrollingFrame")
            RCol.Size=UDim2.new(0.5,-10,1,-10)
            RCol.Position=UDim2.new(0.5,5,0,0)
            RCol.BackgroundTransparency=1
            RCol.ScrollBarThickness=0
            RCol.Parent=SubPage

            local function Setup(f)
                local l=Instance.new("UIListLayout",f)
                l.Padding=UDim.new(0,12)
                l.SortOrder=Enum.SortOrder.LayoutOrder
                local p=Instance.new("UIPadding",f)
                p.PaddingBottom=UDim.new(0,10)
            end
            Setup(LCol)
            Setup(RCol)

            if FirstSubTab then
                FirstSubTab = false
                SBtn.TextColor3 = Library.Theme.Accent
                SubPage.Visible = true
                table.insert(ThemeObjects["Accent"], {Obj = SBtn, Prop = "TextColor3", CustomCheck = function() return SubPage.Visible end})
            else
                table.insert(ThemeObjects["TextDark"], {Obj = SBtn, Prop = "TextColor3", CustomCheck = function() return not SubPage.Visible end})
            end

            SBtn.MouseButton1Click:Connect(function()
                for _, v in pairs(ContentArea:GetChildren()) do v.Visible = false end
                for _, v in pairs(SubTabArea:GetChildren()) do 
                    if v:IsA("TextButton") then TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextDark}):Play() end 
                end
                SubPage.Visible = true
                TweenService:Create(SBtn, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Accent}):Play()
            end)

            local SubFuncs = {}
            
            function SubFuncs:Groupbox(Name, Side)
                local P = (Side=="Right") and RCol or LCol
                local Box = Instance.new("Frame")
                Box.Size = UDim2.new(1,0,0,100)
                Box.Parent = P
                Library:RegisterTheme(Box,"BackgroundColor3","Groupbox")
                Instance.new("UICorner",Box).CornerRadius=UDim.new(0,4)
                local S=Instance.new("UIStroke",Box)
                S.Thickness=1
                Library:RegisterTheme(S,"Color","Outline")
                
                local H=Instance.new("TextLabel")
                H.Size=UDim2.new(1,-20,0,25)
                H.Position=UDim2.new(0,10,0,0)
                H.BackgroundTransparency=1
                H.Text=Name
                H.Font=Enum.Font.GothamBold
                H.TextSize=13
                H.TextXAlignment=Enum.TextXAlignment.Left
                H.Parent=Box
                Library:RegisterTheme(H,"TextColor3","Accent")

                local C=Instance.new("Frame")
                C.Size=UDim2.new(1,0,0,0)
                C.Position=UDim2.new(0,0,0,30)
                C.BackgroundTransparency=1
                C.Parent=Box
                local L=Instance.new("UIListLayout",C)
                L.SortOrder=Enum.SortOrder.LayoutOrder
                L.Padding=UDim.new(0,12)
                local Pa=Instance.new("UIPadding",C)
                Pa.PaddingLeft=UDim.new(0,10)
                Pa.PaddingRight=UDim.new(0,10)
                Pa.PaddingBottom=UDim.new(0,10)
                Pa.PaddingTop=UDim.new(0,5)
                
                L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Box.Size=UDim2.new(1,0,0,L.AbsoluteContentSize.Y+45)
                end)

                local function RegisterItem(ItemName, ItemObj)
                    if not Btn or not SBtn or not SubPage then return end 
                    table.insert(Library.Registry, {
                        Name = ItemName,
                        Object = ItemObj,
                        TabBtn = Btn,
                        SubTabBtn = SBtn,
                        SubPage = SubPage
                    })
                end

                local BoxFuncs = {}
                
                local function CheckActivePicker()
                    if Library.ActivePicker then
                        Library.ActivePicker.Visible = false
                        Library.ActivePicker = nil
                    end
                end
        
                function BoxFuncs:ESPPreview()
                    local F = Instance.new("Frame", C)
                    F.Size = UDim2.new(1, 0, 0, 200)
                    F.BackgroundTransparency = 1
                    
                    local VP = Instance.new("ViewportFrame", F)
                    VP.Size = UDim2.new(1, -10, 1, 0)
                    VP.Position = UDim2.new(0, 5, 0, 0)
                    VP.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                    VP.BorderColor3 = Library.Theme.Outline
                    Instance.new("UICorner", VP).CornerRadius = UDim.new(0, 4)
                    Instance.new("UIStroke", VP).Color = Library.Theme.Outline
                    
                    local Cam = Instance.new("Camera", VP)
                    VP.CurrentCamera = Cam
                    
                    task.spawn(function()
                        local Char = Player.Character or Player.CharacterAdded:Wait()
                        if not Char then return end
                        local CharClone = Char:Clone()
                        CharClone.Parent = VP
                        
                        local HRP = CharClone:FindFirstChild("HumanoidRootPart")
                        if HRP then
                            Cam.CFrame = CFrame.new(HRP.Position + (HRP.CFrame.LookVector * 6) + Vector3.new(0, 1, 0), HRP.Position)
                        end
                    
                        local BoxESP = Instance.new("Frame", VP)
                        BoxESP.Size = UDim2.new(0.5, 0, 0.8, 0)
                        BoxESP.Position = UDim2.new(0.25, 0, 0.1, 0)
                        BoxESP.BackgroundTransparency = 1
                        BoxESP.BorderColor3 = Color3.new(1, 0, 0)
                        BoxESP.BorderSizePixel = 2
                        BoxESP.Visible = false
                        
                        local NameESP = Instance.new("TextLabel", VP)
                        NameESP.Text = Player.Name
                        NameESP.Size = UDim2.new(1, 0, 0, 20)
                        NameESP.Position = UDim2.new(0, 0, 0, 5)
                        NameESP.BackgroundTransparency = 1
                        NameESP.TextColor3 = Color3.new(1, 1, 1)
                        NameESP.Font = Enum.Font.GothamBold
                        NameESP.TextSize = 12
                        NameESP.Visible = false
                        
                        local HealthBar = Instance.new("Frame", VP)
                        HealthBar.Size = UDim2.new(0, 3, 0.8, 0)
                        HealthBar.Position = UDim2.new(0.23, 0, 0.1, 0)
                        HealthBar.BackgroundColor3 = Color3.new(0, 1, 0)
                        HealthBar.BorderSizePixel = 0
                        HealthBar.Visible = false
                        
                        local Highlight = Instance.new("Highlight", CharClone)
                        Highlight.FillColor = Color3.new(1, 0, 0)
                        Highlight.FillTransparency = 0.5
                        Highlight.OutlineTransparency = 0
                        Highlight.Enabled = false
                        
                        Library.Preview = {
                            Box = BoxESP,
                            Name = NameESP,
                            Health = HealthBar,
                            Chams = Highlight
                        }
                    end)
                end

                function BoxFuncs:AddLabel(Config)
                    local Text = type(Config) == "table" and Config.Title or Config
                    local F=Instance.new("Frame",C)
                    F.Size=UDim2.new(1,0,0,15)
                    F.BackgroundTransparency=1
                    local Lb=Instance.new("TextLabel",F)
                    Lb.Size=UDim2.new(1,0,1,0)
                    Lb.BackgroundTransparency=1
                    Lb.Text=Text
                    Lb.Font=Enum.Font.Gotham
                    Lb.TextSize=12
                    Lb.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb,"TextColor3","Text")
                end
                
                function BoxFuncs:AddParagraph(Config)
                    local Head = Config.Title or "Paragraph"
                    local Cont = Config.Content or ""
                    
                    local F = Instance.new("Frame", C)
                    F.BackgroundTransparency = 1
                    F.Size = UDim2.new(1, 0, 0, 0)
                    
                    local H1 = Instance.new("TextLabel", F)
                    H1.Size = UDim2.new(1, 0, 0, 15)
                    H1.BackgroundTransparency = 1
                    H1.Text = Head
                    H1.Font = Enum.Font.GothamBold
                    H1.TextSize = 12
                    H1.TextXAlignment = Enum.TextXAlignment.Left
                    Library:RegisterTheme(H1, "TextColor3", "Text")
                    
                    local C1 = Instance.new("TextLabel", F)
                    C1.Position = UDim2.new(0, 0, 0, 20)
                    C1.BackgroundTransparency = 1
                    C1.Text = Cont
                    C1.Font = Enum.Font.Gotham
                    C1.TextSize = 11
                    C1.TextXAlignment = Enum.TextXAlignment.Left
                    C1.TextYAlignment = Enum.TextYAlignment.Top
                    C1.TextWrapped = true
                    Library:RegisterTheme(C1, "TextColor3", "TextDark")
                    
                    local WrapWidth = C.AbsoluteSize.X
                    if WrapWidth < 50 then WrapWidth = 230 end
                    WrapWidth = WrapWidth - 10 
                    
                    local TextBounds = game:GetService("TextService"):GetTextSize(Cont, 11, Enum.Font.Gotham, Vector2.new(WrapWidth, 9999))
                    local TextHeight = TextBounds.Y
                    C1.Size = UDim2.new(1, 0, 0, TextHeight)
                    F.Size = UDim2.new(1, 0, 0, TextHeight + 25)
                    
                    RegisterItem(Head, F)
                end

                function BoxFuncs:AddToggle(Config)
                    local Text = Config.Title or "Toggle"
                    local Default = Config.Default or false
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description
                    local Risky = Config.Risky

                    local F=Instance.new("TextButton",C)
                    F.Size=UDim2.new(1,0,0,20)
                    F.BackgroundTransparency=1
                    F.Text=""
                    if Desc then AddTooltip(F, Desc) end

                    local Lb=Instance.new("TextLabel",F)
                    Lb.Size=UDim2.new(1,-45,1,0)
                    Lb.BackgroundTransparency=1
                    Lb.Text=Text
                    Lb.Font=Enum.Font.Gotham
                    Lb.TextSize=12
                    Lb.TextXAlignment=Enum.TextXAlignment.Left
                    if Risky then
                        Lb.TextColor3 = Color3.fromRGB(255, 80, 80)
                    else
                        Library:RegisterTheme(Lb,"TextColor3","Text")
                    end

                    local T=Instance.new("Frame",F)
                    T.Size=UDim2.new(0,34,0,18)
                    T.Position=UDim2.new(1,-34,0.5,-9)
                    T.BackgroundColor3=Default and Library.Theme.Accent or Color3.fromRGB(50,50,50)
                    Instance.new("UICorner",T).CornerRadius=UDim.new(1,0)
                    local Cir=Instance.new("Frame",T)
                    Cir.Size=UDim2.new(0,14,0,14)
                    Cir.Position=Default and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
                    Cir.BackgroundColor3=Library.Theme.Text
                    Instance.new("UICorner",Cir).CornerRadius=UDim.new(1,0)

                    local function Set(v)
                        Library.Flags[Flag]=v
                        TweenService:Create(Cir,TweenInfo.new(0.15),{Position=v and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)}):Play()
                        TweenService:Create(T,TweenInfo.new(0.15),{BackgroundColor3=v and Library.Theme.Accent or Color3.fromRGB(50,50,50)}):Play()
                        pcall(Callback,v)
                    end
                    Library.Items[Flag]={Set=Set}
                    F.MouseButton1Click:Connect(function() Set(not Library.Flags[Flag]) end)
                    Library.Flags[Flag]=Default

                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddCheckbox(Config)
                    local Text = Config.Title or "Checkbox"
                    local Default = Config.Default or false
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description
                    local Risky = Config.Risky

                    local F=Instance.new("TextButton",C)
                    F.Size=UDim2.new(1,0,0,20)
                    F.BackgroundTransparency=1
                    F.Text=""
                    if Desc then AddTooltip(F, Desc) end

                    local Lb=Instance.new("TextLabel",F)
                    Lb.Size=UDim2.new(1,-30,1,0)
                    Lb.BackgroundTransparency=1
                    Lb.Text=Text
                    Lb.Font=Enum.Font.Gotham
                    Lb.TextSize=12
                    Lb.TextXAlignment=Enum.TextXAlignment.Left
                    if Risky then
                        Lb.TextColor3 = Color3.fromRGB(255, 80, 80)
                    else
                        Library:RegisterTheme(Lb,"TextColor3","Text")
                    end

                    -- Внешний квадрат
                    local Outer=Instance.new("Frame",F)
                    Outer.Size=UDim2.new(0,18,0,18)
                    Outer.Position=UDim2.new(1,-20,0.5,-9)
                    Outer.BackgroundColor3=Color3.fromRGB(35,35,35)
                    Instance.new("UICorner",Outer).CornerRadius=UDim.new(0,4)
                    local S=Instance.new("UIStroke",Outer)
                    S.Color=Library.Theme.Outline
                    S.Thickness=1

                    -- Внутренний квадрат (индикатор)
                    local Inner=Instance.new("Frame",Outer)
                    Inner.Size=UDim2.new(1,-6,1,-6)
                    Inner.Position=UDim2.new(0,3,0,3)
                    Inner.BackgroundColor3=Library.Theme.Accent
                    Inner.BackgroundTransparency=1 -- Скрыт по умолчанию
                    Instance.new("UICorner",Inner).CornerRadius=UDim.new(0,2)

                    local function Set(v)
                        Library.Flags[Flag]=v
                        if v then
                            TweenService:Create(Inner,TweenInfo.new(0.15),{BackgroundTransparency=0}):Play()
                            TweenService:Create(Outer,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(50,50,50)}):Play()
                        else
                            TweenService:Create(Inner,TweenInfo.new(0.15),{BackgroundTransparency=1}):Play()
                            TweenService:Create(Outer,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(35,35,35)}):Play()
                        end
                        pcall(Callback,v)
                    end

                    Library.Items[Flag]={Set=Set}
                    Library.Flags[Flag]=Default
                    
                    -- Применяем начальное состояние без анимации
                    if Default then
                        Inner.BackgroundTransparency=0
                        Outer.BackgroundColor3=Color3.fromRGB(50,50,50)
                    end

                    F.MouseButton1Click:Connect(function() Set(not Library.Flags[Flag]) end)

                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddSlider(Config)
                    local Text = Config.Title or "Slider"
                    local Min = Config.Min or 0
                    local Max = Config.Max or 100
                    local Def = Config.Default or Min
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Rounding = Config.Rounding or 0
                    local Suffix = Config.Suffix or ""
                    local Desc = Config.Description

                    local F=Instance.new("Frame",C)
                    F.Size=UDim2.new(1,0,0,38)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end

                    local Lb=Instance.new("TextLabel",F)
                    Lb.Size=UDim2.new(1,0,0,15)
                    Lb.BackgroundTransparency=1
                    Lb.Text=Text
                    Lb.Font=Enum.Font.Gotham
                    Lb.TextSize=12
                    Lb.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb,"TextColor3","Text")
                    local Vl=Instance.new("TextLabel",F)
                    Vl.Size=UDim2.new(0,80,0,15)
                    Vl.Position=UDim2.new(1,-80,0,0)
                    Vl.BackgroundTransparency=1
                    Vl.Text=tostring(Def)..Suffix
                    Vl.Font=Enum.Font.Gotham
                    Vl.TextSize=12
                    Vl.TextXAlignment=Enum.TextXAlignment.Right
                    Library:RegisterTheme(Vl,"TextColor3","Accent")
                    local B=Instance.new("Frame",F)
                    B.Size=UDim2.new(1,0,0,5)
                    B.Position=UDim2.new(0,0,0,25)
                    B.BackgroundColor3=Color3.fromRGB(40,40,40)
                    Instance.new("UICorner",B).CornerRadius=UDim.new(1,0)
                    local Fil=Instance.new("Frame",B)
                    Fil.Size=UDim2.new((Def-Min)/(Max-Min),0,1,0)
                    Library:RegisterTheme(Fil,"BackgroundColor3","Accent")
                    Instance.new("UICorner",Fil).CornerRadius=UDim.new(1,0)
                    local Btn=Instance.new("TextButton",F)
                    Btn.Size=UDim2.new(1,0,0,25)
                    Btn.Position=UDim2.new(0,0,0,15)
                    Btn.BackgroundTransparency=1
                    Btn.Text=""
                    
                    local function Set(v)
                        v=math.clamp(v,Min,Max)
                        if Rounding > 0 then
                            v = math.floor(v * (10^Rounding)) / (10^Rounding)
                        else
                            v = math.floor(v)
                        end
                        
                        Library.Flags[Flag]=v
                        Vl.Text=tostring(v)..Suffix
                        TweenService:Create(Fil,TweenInfo.new(0.1),{Size=UDim2.new((v-Min)/(Max-Min),0,1,0)}):Play()
                        pcall(Callback,v)
                    end
                    Library.Items[Flag]={Set=Set}
                    Library.Flags[Flag]=Def
                    local drag=false
                    local function Upd(i)
                        local x=math.clamp((i.Position.X-B.AbsolutePosition.X)/B.AbsoluteSize.X,0,1)
                        local newVal = ((Max-Min)*x)+Min
                        Set(newVal)
                    end
                    Btn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true Upd(i) end end)
                    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end)
                    UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then Upd(i) end end)

                    RegisterItem(Text, F)
                end
                
                function BoxFuncs:AddColorPicker(Config)
                    local Text = Config.Title or "Color"
                    local Def = Config.Default or Color3.new(1,1,1)
                    local Callback = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description

                    local F=Instance.new("Frame",C)
                    F.Size=UDim2.new(1,0,0,25)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end

                    local Lb=Instance.new("TextLabel",F)
                    Lb.Size=UDim2.new(0.7,0,1,0)
                    Lb.BackgroundTransparency=1
                    Lb.Text=Text
                    Lb.Font=Enum.Font.Gotham
                    Lb.TextSize=12
                    Lb.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(Lb,"TextColor3","Text")
                    local P=Instance.new("TextButton",F)
                    P.Size=UDim2.new(0,35,0,18)
                    P.Position=UDim2.new(1,-35,0.5,-9)
                    P.BackgroundColor3=Def
                    P.Text=""
                    Instance.new("UICorner",P).CornerRadius=UDim.new(0,4)
                    
                    local Win=Instance.new("Frame",ScreenGui)
                    Win.Size=UDim2.new(0,200,0,190)
                    Win.BackgroundColor3=Color3.fromRGB(25,25,25)
                    Win.Visible=false
                    Win.ZIndex=200 
                    Instance.new("UIStroke",Win).Color=Library.Theme.Outline
                    Instance.new("UICorner",Win).CornerRadius=UDim.new(0,4)
                    local SV=Instance.new("ImageButton",Win)
                    SV.Size=UDim2.new(0,180,0,130)
                    SV.Position=UDim2.new(0,10,0,10)
                    SV.BackgroundColor3=Def
                    SV.Image="rbxassetid://4155801252"
                    SV.ZIndex=201
                    local H=Instance.new("ImageButton",Win)
                    H.Size=UDim2.new(0,180,0,25)
                    H.Position=UDim2.new(0,10,0,150)
                    H.BackgroundColor3=Color3.new(1,1,1)
                    H.Image=""
                    H.ZIndex=201
                    local Gr=Instance.new("UIGradient",H)
                    Gr.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),ColorSequenceKeypoint.new(0.17,Color3.new(1,1,0)),ColorSequenceKeypoint.new(0.33,Color3.new(0,1,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0,1,1)),ColorSequenceKeypoint.new(0.67,Color3.new(0,0,1)),ColorSequenceKeypoint.new(0.83,Color3.new(1,0,1)),ColorSequenceKeypoint.new(1,Color3.new(1,0,0))}
                    
                    local h,s,v = Def:ToHSV()
                    local function Upd()
                        local c=Color3.fromHSV(h,s,v)
                        P.BackgroundColor3=c
                        SV.BackgroundColor3=Color3.fromHSV(h,1,1)
                        Library.Flags[Flag]={R=c.R,G=c.G,B=c.B}
                        pcall(Callback,c)
                    end
                    Library.Items[Flag]={Set=function(t) if type(t)=="table" then local c=Color3.new(t.R,t.G,t.B) h,s,v=c:ToHSV() Upd() end end}
                    Library.Flags[Flag]={R=Def.R,G=Def.G,B=Def.B}

                    local d1,d2=false,false
                    local function Hand(i,mode)
                        if mode=="H" then h=math.clamp((i.Position.X-H.AbsolutePosition.X)/H.AbsoluteSize.X,0,1)
                        else s=math.clamp((i.Position.X-SV.AbsolutePosition.X)/SV.AbsoluteSize.X,0,1) v=1-math.clamp((i.Position.Y-SV.AbsolutePosition.Y)/SV.AbsoluteSize.Y,0,1) end
                        Upd()
                    end
                    H.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d1=true Hand(i,"H") end end)
                    SV.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d2=true Hand(i,"S") end end)
                    UserInputService.InputEnded:Connect(function() d1=false d2=false end)
                    UserInputService.InputChanged:Connect(function(i) if d1 and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then Hand(i,"H") elseif d2 and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then Hand(i,"S") end end)
                    P.MouseButton1Click:Connect(function() 
                        if Win.Visible then Win.Visible = false Library.ActivePicker = nil else
                            if Library.ActivePicker then Library.ActivePicker.Visible = false end
                            Win.Visible = true
                            Win.Position = UDim2.new(0, P.AbsolutePosition.X + 50, 0, P.AbsolutePosition.Y)
                            Library.ActivePicker = Win
                        end
                    end)
                    DropdownHolder.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then Win.Visible=false if Library.ActivePicker==Win then Library.ActivePicker=nil end end end)
                
                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddDropdown(Config)
                    local Text = Config.Title or "Dropdown"
                    local Opt = Config.Values or {}
                    local Default = Config.Default
                    local Callback = Config.Callback or function() end
                    local Multi = Config.Multi or false
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description

                    local F=Instance.new("Frame",C)
                    F.Size=UDim2.new(1,0,0,40)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end

                    local L=Instance.new("TextLabel",F)
                    L.Size=UDim2.new(1,0,0,15)
                    L.BackgroundTransparency=1
                    L.Text=Text
                    L.Font=Enum.Font.Gotham
                    L.TextSize=12
                    L.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(L,"TextColor3","Text")
                    local B=Instance.new("TextButton",F)
                    B.Size=UDim2.new(1,0,0,22)
                    B.Position=UDim2.new(0,0,0,18)
                    B.BackgroundColor3=Color3.fromRGB(35,35,35)
                    B.Font=Enum.Font.Gotham
                    B.TextSize=12
                    B.TextColor3=Color3.fromRGB(200,200,200)
                    B.TextXAlignment=Enum.TextXAlignment.Left
                    Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
                    
                    local List=Instance.new("ScrollingFrame",ScreenGui)
                    List.Visible=false
                    List.BackgroundColor3=Color3.fromRGB(35,35,35)
                    List.BorderSizePixel=0
                    List.ZIndex=200
                    List.AutomaticCanvasSize = Enum.AutomaticSize.Y
                    Instance.new("UIStroke",List).Color=Library.Theme.Outline
                    local LL=Instance.new("UIListLayout",List)
                    LL.SortOrder=Enum.SortOrder.LayoutOrder

                    if not Multi then
                        -- SINGLE DROPDOWN
                        B.Text = "  " .. (Default or "Select...")
                        local function Set(v)
                            B.Text="  "..v
                            Library.Flags[Flag]=v
                            pcall(Callback,v)
                            List.Visible=false
                            DropdownHolder.Visible=false
                            CheckActivePicker()
                        end
                        
                        Library.Items[Flag]={Set=Set, Refresh=function(New)
                            for _,v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                            for _,v in pairs(New) do
                                local bt=Instance.new("TextButton",List)
                                bt.Size=UDim2.new(1,0,0,25)
                                bt.BackgroundTransparency=1
                                bt.Text=v
                                bt.TextColor3=Color3.fromRGB(200,200,200)
                                bt.Font=Enum.Font.Gotham
                                bt.TextSize=12
                                bt.MouseButton1Click:Connect(function() Set(v) end)
                            end
                        end}
                        Library.Items[Flag].Refresh(Opt)
                        if Default then Set(Default) end

                        B.MouseButton1Click:Connect(function()
                            if List.Visible then List.Visible=false DropdownHolder.Visible=false else
                                CheckActivePicker()
                                List.Position=UDim2.new(0,B.AbsolutePosition.X,0,B.AbsolutePosition.Y+25)
                                local ContentH = LL.AbsoluteContentSize.Y
                                List.Size=UDim2.new(0,B.AbsoluteSize.X,0,math.min(ContentH, 150))
                                List.CanvasSize=UDim2.new(0,0,0,ContentH)
                                List.Visible=true
                                DropdownHolder.Visible=true
                            end
                        end)

                    else
                        -- MULTI DROPDOWN
                        local Sel={}
                        if type(Default) == "table" then
                            for _, val in pairs(Default) do Sel[val] = true end
                        end
                        
                        Library.Flags[Flag]=Sel
                        
                        local function Upd()
                            local t={} for k,v in pairs(Sel) do if v then table.insert(t,k) end end
                            B.Text=#t==0 and "  None" or (#t==1 and "  "..t[1] or "  "..#t.." Selected")
                            pcall(Callback,Sel)
                        end
                        Upd()

                        for _,v in pairs(Opt) do
                            local bt=Instance.new("TextButton",List)
                            bt.Size=UDim2.new(1,0,0,25)
                            bt.BackgroundTransparency=1
                            bt.Text=v
                            bt.TextColor3=Color3.fromRGB(200,200,200)
                            bt.Font=Enum.Font.Gotham
                            bt.TextSize=12
                            bt.MouseButton1Click:Connect(function()
                                Sel[v]=not Sel[v]
                                bt.TextColor3=Sel[v] and Library.Theme.Accent or Color3.fromRGB(200,200,200)
                                Upd()
                            end)
                            if Sel[v] then bt.TextColor3 = Library.Theme.Accent end
                        end
                        
                        B.MouseButton1Click:Connect(function()
                            if List.Visible then List.Visible=false DropdownHolder.Visible=false else
                                CheckActivePicker()
                                List.Position=UDim2.new(0,B.AbsolutePosition.X,0,B.AbsolutePosition.Y+25)
                                local ContentH = LL.AbsoluteContentSize.Y
                                List.Size=UDim2.new(0,B.AbsoluteSize.X,0,math.min(ContentH, 150))
                                List.CanvasSize=UDim2.new(0,0,0,ContentH)
                                List.Visible=true
                                DropdownHolder.Visible=true
                            end
                        end)
                    end

                    DropdownHolder.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then List.Visible=false DropdownHolder.Visible=false end end)
                    
                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddKeybind(Config)
                    local Text = Config.Title or "Keybind"
                    local Def = Config.Default or Enum.KeyCode.RightShift
                    local Call = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description

                    local F=Instance.new("Frame",C)
                    F.Size=UDim2.new(1,0,0,20)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end

                    local L=Instance.new("TextLabel",F)
                    L.Size=UDim2.new(1,0,1,0)
                    L.BackgroundTransparency=1
                    L.Text=Text
                    L.Font=Enum.Font.Gotham
                    L.TextSize=12
                    L.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(L,"TextColor3","Text")
                    local B=Instance.new("TextButton",F)
                    B.Size=UDim2.new(0,60,0,18)
                    B.Position=UDim2.new(1,-60,0.5,-9)
                    B.BackgroundColor3=Color3.fromRGB(35,35,35)
                    B.Text=Def.Name
                    B.Font=Enum.Font.Gotham
                    B.TextSize=11
                    B.TextColor3=Color3.fromRGB(200,200,200)
                    Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
                    local bind=false
                    B.MouseButton1Click:Connect(function() bind=true B.Text="..." end)
                    UserInputService.InputBegan:Connect(function(i) if bind and i.UserInputType==Enum.UserInputType.Keyboard then bind=false B.Text=i.KeyCode.Name pcall(Call,i.KeyCode) end end)
                
                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddTextbox(Config)
                    local Text = Config.Title or "Textbox"
                    local Ph = Config.Placeholder or ""
                    local Call = Config.Callback or function() end
                    local Flag = Config.Flag or Text
                    local Desc = Config.Description
                    local Clear = Config.ClearOnFocus

                    local F=Instance.new("Frame",C)
                    F.Size=UDim2.new(1,0,0,40)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end

                    local L=Instance.new("TextLabel",F)
                    L.Size=UDim2.new(1,0,0,15)
                    L.BackgroundTransparency=1
                    L.Text=Text
                    L.Font=Enum.Font.Gotham
                    L.TextSize=12
                    L.TextXAlignment=Enum.TextXAlignment.Left
                    Library:RegisterTheme(L,"TextColor3","Text")
                    local B=Instance.new("TextBox",F)
                    B.Size=UDim2.new(1,0,0,20)
                    B.Position=UDim2.new(0,0,0,18)
                    B.BackgroundColor3=Color3.fromRGB(35,35,35)
                    B.Text=""
                    B.PlaceholderText=Ph
                    B.TextColor3=Color3.fromRGB(230,230,230)
                    B.Font=Enum.Font.Gotham
                    B.TextSize=12
                    B.ClearTextOnFocus = Clear or false
                    Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
                    B.FocusLost:Connect(function() Library.Flags[Flag]=B.Text pcall(Call,B.Text) end)
                
                    RegisterItem(Text, F)
                end

                function BoxFuncs:AddButton(Config)
                    local Text = Config.Title or "Button"
                    local Call = Config.Callback or function() end
                    local Desc = Config.Description

                    local F=Instance.new("Frame",C)
                    F.Size=UDim2.new(1,0,0,32)
                    F.BackgroundTransparency=1
                    if Desc then AddTooltip(F, Desc) end
                    
                    local B=Instance.new("TextButton",F)
                    B.Size=UDim2.new(1,0,1,0)
                    B.BackgroundColor3=Color3.fromRGB(35,35,35)
                    B.Text=Text
                    B.TextColor3=Library.Theme.Text
                    B.Font=Enum.Font.Gotham
                    B.TextSize=12
                    Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
                    B.MouseButton1Click:Connect(function()
                        TweenService:Create(B,TweenInfo.new(0.1),{BackgroundColor3=Library.Theme.Accent}):Play()
                        wait(0.1)
                        TweenService:Create(B,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(35,35,35)}):Play()
                        pcall(Call)
                    end)
                
                    RegisterItem(Text, F)
                end

                return BoxFuncs
            end
            return SubFuncs
        end
        return TabFuncs
    end
    return WindowFuncs
end

return Library
