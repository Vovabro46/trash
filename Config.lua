--[[
    FILE: ConfigLogic.lua (BACKEND)
    Залей это на GitHub.
    Этот скрипт возвращает ТАБЛИЦУ ФУНКЦИЙ, а не создает кнопки.
]]

local HttpService = game:GetService("HttpService")

return function(Library, Window, FolderName)
    -- 1. Подготовка папки
    local RootFolder = FolderName or "EternesusConfigs"
    if not isfolder(RootFolder) then
        makefolder(RootFolder)
    end

    -- Объект, который мы вернем в главный скрипт
    local API = {}

    -- Функция получения списка файлов (возвращает таблицу имен)
    function API.GetFiles()
        local Files = listfiles(RootFolder)
        local Names = {}
        for _, file in ipairs(Files) do
            local fileName = file:match("([^/]+)$"):gsub(".json", "")
            table.insert(Names, fileName)
        end
        return Names
    end

    -- Функция сохранения
    function API.Save(name)
        if not name or name == "" then
            Window:Notify({Title = "Config", Content = "Enter a name first!", Duration = 2, Type = "Error"})
            return false
        end
        
        -- Получаем флаги из библиотеки
        local json = HttpService:JSONEncode(Library.flags)
        writefile(RootFolder .. "/" .. name .. ".json", json)
        
        Window:Notify({Title = "Saved", Content = "Config saved: " .. name, Duration = 2, Type = "Success"})
        return true
    end

    -- Функция загрузки
    function API.Load(name)
        if not name or not isfile(RootFolder .. "/" .. name .. ".json") then
            Window:Notify({Title = "Config", Content = "File not found!", Duration = 2, Type = "Error"})
            return false
        end

        local content = readfile(RootFolder .. "/" .. name .. ".json")
        local data = HttpService:JSONDecode(content)

        -- Применяем настройки
        for flag, value in pairs(data) do
            if Library.flags[flag] ~= nil then
                Library.flags[flag] = value
                -- В некоторых версиях Aurora нужно вызывать обновление вручную, 
                -- но обычно смена флага срабатывает при следующем действии.
                -- Если у элементов есть callback, он может не сработать автоматически без доп. кода.
                if Window.Elements and Window.Elements[flag] and Window.Elements[flag].Set then
                     Window.Elements[flag]:Set(value)
                end
            end
        end
        
        Window:Notify({Title = "Loaded", Content = "Settings applied.", Duration = 2, Type = "Success"})
        return true
    end

    -- Функция удаления
    function API.Delete(name)
        if not name or not isfile(RootFolder .. "/" .. name .. ".json") then 
            return false 
        end
        delfile(RootFolder .. "/" .. name .. ".json")
        Window:Notify({Title = "Deleted", Content = "Config removed.", Duration = 2, Type = "Warning"})
        return true
    end

    return API -- Возвращаем набор функций главному скрипту
end
