do
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local CoreGui = game:GetService("CoreGui")
    
    -- Ищем GUI, созданное библиотекой
    local ScreenGui = (RunService:IsStudio() and LocalPlayer.PlayerGui:FindFirstChild("EternesusUltimate")) 
                   or CoreGui:FindFirstChild("EternesusUltimate")

    -- Контейнер для уведомлений
    local NotifyContainer = Instance.new("Frame")
    NotifyContainer.Name = "NotifyContainer"
    NotifyContainer.Parent = ScreenGui
    NotifyContainer.BackgroundTransparency = 1
    NotifyContainer.Size = UDim2.new(0, 300, 1, -20)
    NotifyContainer.Position = UDim2.new(1, -320, 0, 10)
    NotifyContainer.ZIndex = 100
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = NotifyContainer
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

    -- Иконки и Цвета
    local NotifyIcons = {
        Success = "6031094667",
        Error = "6031094678",
        Warning = "6031094670",
        Info = "6031094674"
    }
    local Colors = {
        Success = Color3.fromRGB(0, 255, 127),
        Error = Color3.fromRGB(255, 65, 65),
        Warning = Color3.fromRGB(255, 190, 40),
        Info = Color3.fromRGB(60, 150, 255)
    }

    function Window:Notify(config)
        local Title = config.Title or "Notification"
        local Content = config.Content or ""
        local Time = config.Duration or 5
        local Type = config.Type or "Info" -- Success, Error, Warning, Info
        
        local TypeColor = Colors[Type] or Colors.Info
        local IconID = NotifyIcons[Type] or NotifyIcons.Info

        -- Звук
        local Sound = Instance.new("Sound")
        Sound.SoundId = "rbxassetid://4590662766"
        Sound.Volume = 0.5
        Sound.Parent = ScreenGui
        Sound:Play()
        Sound.Ended:Connect(function() Sound:Destroy() end)

        -- Фрейм уведомления
        local NotifyFrame = Instance.new("Frame")
        NotifyFrame.Parent = NotifyContainer
        NotifyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30) -- Sidebar color
        NotifyFrame.Size = UDim2.new(1, 0, 0, 60)
        NotifyFrame.Position = UDim2.new(1, 320, 0, 0) -- За экраном
        NotifyFrame.BackgroundTransparency = 0.1

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = NotifyFrame

        -- Градиентная обводка
        local Stroke = Instance.new("UIStroke")
        Stroke.Parent = NotifyFrame
        Stroke.Color = Color3.new(1,1,1)
        Stroke.Thickness = 1.5
        
        local Gradient = Instance.new("UIGradient")
        Gradient.Parent = Stroke
        Gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, TypeColor),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
        }
        Gradient.Rotation = 45

        -- Иконка
        local IconBg = Instance.new("Frame")
        IconBg.Parent = NotifyFrame
        IconBg.BackgroundColor3 = TypeColor
        IconBg.BackgroundTransparency = 0.85
        IconBg.Size = UDim2.new(0, 40, 0, 40)
        IconBg.Position = UDim2.new(0, 10, 0.5, -20)
        
        local IconCorner = Instance.new("UICorner")
        IconCorner.CornerRadius = UDim.new(0, 8)
        IconCorner.Parent = IconBg

        local IconImg = Instance.new("ImageLabel")
        IconImg.Parent = IconBg
        IconImg.Image = "rbxassetid://" .. IconID
        IconImg.BackgroundTransparency = 1
        IconImg.Size = UDim2.new(0, 24, 0, 24)
        IconImg.Position = UDim2.new(0.5, -12, 0.5, -12)
        IconImg.ImageColor3 = TypeColor

        -- Текст
        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Parent = NotifyFrame
        TitleLbl.Text = Title
        TitleLbl.Font = Enum.Font.GothamBold
        TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLbl.TextSize = 14
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Size = UDim2.new(1, -60, 0, 20)
        TitleLbl.Position = UDim2.new(0, 60, 0, 8)
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

        local DescLbl = Instance.new("TextLabel")
        DescLbl.Parent = NotifyFrame
        DescLbl.Text = Content
        DescLbl.Font = Enum.Font.Gotham
        DescLbl.TextColor3 = Color3.fromRGB(145, 145, 155)
        DescLbl.TextSize = 12
        DescLbl.BackgroundTransparency = 1
        DescLbl.Size = UDim2.new(1, -60, 0, 24)
        DescLbl.Position = UDim2.new(0, 60, 0, 28)
        DescLbl.TextXAlignment = Enum.TextXAlignment.Left
        DescLbl.TextTruncate = Enum.TextTruncate.AtEnd

        -- Таймер
        local TimerBarBg = Instance.new("Frame")
        TimerBarBg.Parent = NotifyFrame
        TimerBarBg.BackgroundColor3 = Color3.fromRGB(40,40,45)
        TimerBarBg.Size = UDim2.new(1, -20, 0, 2)
        TimerBarBg.Position = UDim2.new(0, 10, 1, -2)
        TimerBarBg.BorderSizePixel = 0
        TimerBarBg.BackgroundTransparency = 0.5

        local TimerFill = Instance.new("Frame")
        TimerFill.Parent = TimerBarBg
        TimerFill.BackgroundColor3 = TypeColor
        TimerFill.Size = UDim2.new(1, 0, 1, 0)
        TimerFill.BorderSizePixel = 0
        
        -- Анимация появления
        TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(TimerFill, TweenInfo.new(Time, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

        -- Удаление
        task.delay(Time, function()
            local OutTween = TweenService:Create(NotifyFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 50, 0, 0),
                BackgroundTransparency = 1
            })
            OutTween:Play()
            TweenService:Create(TitleLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(DescLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(IconImg, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            
            OutTween.Completed:Wait()
            NotifyFrame:Destroy()
        end)
    end
end
