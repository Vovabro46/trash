--[[ 
    ВСТАВЬ ЭТОТ КОД В ФАЙЛ НА GITHUB 
    Например: MyNotify.lua
    Он возвращает функцию, которая подключает уведомления к твоему окну.
]]

return function(Window)
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- 1. БЕЗОПАСНЫЙ ПОИСК GUI
    -- Мы ищем GUI, созданное Aurora, или создаем слой поверх него
    local function GetTargetGui()
        local PossibleNames = {"Aurora", "EternesusFull", "ScreenGui"}
        local Target = nil
        
        -- Пытаемся найти существующий GUI библиотеки
        for _, name in pairs(PossibleNames) do
            if CoreGui:FindFirstChild(name) then Target = CoreGui:FindFirstChild(name) break end
            if LocalPlayer.PlayerGui:FindFirstChild(name) then Target = LocalPlayer.PlayerGui:FindFirstChild(name) break end
        end

        -- Если не нашли или хотим быть уверены - создаем свой контейнер
        if not Target then
            Target = Instance.new("ScreenGui")
            Target.Name = "EternesusNotifyLayer"
            pcall(function() Target.Parent = CoreGui end)
            if not Target.Parent then Target.Parent = LocalPlayer.PlayerGui end
        end
        return Target
    end

    local ScreenGui = GetTargetGui()

    -- 2. СОЗДАНИЕ КОНТЕЙНЕРА
    local NotifyContainer = ScreenGui:FindFirstChild("NotifyContainer")
    if not NotifyContainer then
        NotifyContainer = Instance.new("Frame")
        NotifyContainer.Name = "NotifyContainer"
        NotifyContainer.Parent = ScreenGui
        NotifyContainer.BackgroundTransparency = 1
        NotifyContainer.Size = UDim2.new(0, 300, 1, -20)
        NotifyContainer.Position = UDim2.new(1, -320, 0, 10)
        NotifyContainer.ZIndex = 10000 -- Поверх всего
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Parent = NotifyContainer
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 10)
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    end

    -- 3. НАСТРОЙКИ (Иконки и цвета)
    local NotifyIcons = {
        Success = "6031094667", Error = "6031094678", Warning = "6031094670", Info = "6031094674"
    }
    local Colors = {
        Success = Color3.fromRGB(0, 255, 127), Error = Color3.fromRGB(255, 65, 65),
        Warning = Color3.fromRGB(255, 190, 40), Info = Color3.fromRGB(60, 150, 255)
    }

    -- 4. ПОДМЕНА ФУНКЦИИ В ОКНЕ
    function Window:Notify(config)
        task.spawn(function()
            local Title = config.Title or "Notification"
            local Content = config.Content or ""
            local Duration = config.Duration or 5
            local Type = config.Type or "Info"
            
            local TypeColor = Colors[Type] or Colors.Info
            local IconID = NotifyIcons[Type] or NotifyIcons.Info

            -- Звук
            pcall(function()
                local Sound = Instance.new("Sound")
                Sound.SoundId = "rbxassetid://4590662766"
                Sound.Volume = 0.5
                Sound.Parent = ScreenGui
                Sound:Play()
                Sound.Ended:Connect(function() Sound:Destroy() end)
            end)

            -- Элементы UI
            local Frame = Instance.new("Frame")
            Frame.Name = "NotifyFrame"
            Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            Frame.Size = UDim2.new(1, 0, 0, 60)
            Frame.Position = UDim2.new(1, 320, 0, 0) -- Скрыто справа
            Frame.Parent = NotifyContainer
            Frame.BackgroundTransparency = 0.1

            local UICorner = Instance.new("UICorner", Frame)
            UICorner.CornerRadius = UDim.new(0, 6)

            local Stroke = Instance.new("UIStroke", Frame)
            Stroke.Thickness = 1.5
            local Gradient = Instance.new("UIGradient", Stroke)
            Gradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, TypeColor),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
            }
            Gradient.Rotation = 45

            -- Иконка
            local IconBg = Instance.new("Frame", Frame)
            IconBg.BackgroundColor3 = TypeColor
            IconBg.BackgroundTransparency = 0.85
            IconBg.Size = UDim2.new(0, 40, 0, 40)
            IconBg.Position = UDim2.new(0, 10, 0.5, -20)
            Instance.new("UICorner", IconBg).CornerRadius = UDim.new(0, 8)

            local IconImg = Instance.new("ImageLabel", IconBg)
            IconImg.BackgroundTransparency = 1
            IconImg.Image = "rbxassetid://" .. IconID
            IconImg.ImageColor3 = TypeColor
            IconImg.Size = UDim2.new(0, 24, 0, 24)
            IconImg.Position = UDim2.new(0.5, -12, 0.5, -12)

            -- Текст
            local TxtTitle = Instance.new("TextLabel", Frame)
            TxtTitle.Text = Title
            TxtTitle.Font = Enum.Font.GothamBold
            TxtTitle.TextColor3 = Color3.new(1,1,1)
            TxtTitle.TextSize = 14
            TxtTitle.BackgroundTransparency = 1
            TxtTitle.Size = UDim2.new(1, -60, 0, 20)
            TxtTitle.Position = UDim2.new(0, 60, 0, 8)
            TxtTitle.TextXAlignment = Enum.TextXAlignment.Left

            local TxtDesc = Instance.new("TextLabel", Frame)
            TxtDesc.Text = Content
            TxtDesc.Font = Enum.Font.Gotham
            TxtDesc.TextColor3 = Color3.fromRGB(180, 180, 190)
            TxtDesc.TextSize = 12
            TxtDesc.BackgroundTransparency = 1
            TxtDesc.Size = UDim2.new(1, -60, 0, 24)
            TxtDesc.Position = UDim2.new(0, 60, 0, 28)
            TxtDesc.TextXAlignment = Enum.TextXAlignment.Left
            TxtDesc.TextTruncate = Enum.TextTruncate.AtEnd

            -- Таймер
            local TimerBg = Instance.new("Frame", Frame)
            TimerBg.BackgroundColor3 = TypeColor
            TimerBg.BorderSizePixel = 0
            TimerBg.Size = UDim2.new(0, 0, 0, 2)
            TimerBg.Position = UDim2.new(0, 10, 1, -2)

            -- Анимации
            TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)}):Play()
            TweenService:Create(TimerBg, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, -20, 0, 2)}):Play()

            -- Удаление
            task.delay(Duration, function()
                if not Frame.Parent then return end
                local OutTween = TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Position = UDim2.new(1, 50, 0, 0),
                    BackgroundTransparency = 1
                })
                OutTween:Play()
                task.wait(0.4)
                Frame:Destroy()
            end)
        end)
    end
end
