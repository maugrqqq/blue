--   local Blue = require(game.ReplicatedStorage.Blue)
--   local win = Blue:CreateWindow({Title = "Tittle"})
--   local tab = win:CreateTab("Main")
--   tab:CreateToggle({Text = "Toggle", Default = false, Callback = function(v) end})
--   tab:CreateSlider({Text = "Slider", Min = 0, Max = 100, Default = 50, Callback = function(v) end})
--   tab:CreateDropdown({Text = "Dropdown", Options = {"Option 1", "Option 2"}, Callback = function(v) end})
--   tab:CreateKeybind({Text = "Menu Key", Default = "L", Callback = function(k) end})
--   tab:CreateButton({Text = "Save", Callback = function() end})

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Blue = {}
Blue.__index = Blue

-- Цветовая палитра
local COLORS = {
    Background = Color3.fromRGB(15, 23, 42),
    Surface = Color3.fromRGB(20, 28, 52),
    SurfaceLight = Color3.fromRGB(40, 55, 95),
    Accent = Color3.fromRGB(59, 130, 255),
    AccentLight = Color3.fromRGB(110, 165, 255),
    Text = Color3.fromRGB(150, 164, 200),
    TextDark = Color3.fromRGB(40, 50, 70),
    TextLight = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(180, 192, 220),
}

-- Вспомогательные функции
local function createInstance(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props) do
        inst[k] = v
    end
    return inst
end

local function applyCorner(inst, topLeft, topRight, bottomLeft, bottomRight)
    local corner = Instance.new("UICorner")
    corner.TopLeftRadius = UDim.new(0, topLeft or 8)
    corner.TopRightRadius = UDim.new(0, topRight or 8)
    corner.BottomLeftRadius = UDim.new(0, bottomLeft or 8)
    corner.BottomRightRadius = UDim.new(0, bottomRight or 8)
    corner.Parent = inst
    return corner
end

-- Создание окна
function Blue:CreateWindow(config)
    config = config or {}
    local screenGui = createInstance("ScreenGui", {
        Name = config.Name or "BlueUI",
        Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
    })

    local mainFrame = createInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 560),
        Position = UDim2.new(0.5, -250, 0.5, -280),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        Parent = screenGui,
    })
    applyCorner(mainFrame, 12, 12, 12, 12)

    -- TopBar
    local topBar = createInstance("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        Parent = mainFrame,
    })
    applyCorner(topBar, 12, 12, 0, 0)

    local title = createInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "Blue UI",
        TextColor3 = COLORS.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar,
    })

    -- TabBar
    local tabBar = createInstance("Frame", {
        Name = "TabBar",
        Size = UDim2.new(0, 120, 1, -32),
        Position = UDim2.new(0, 0, 0, 32),
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        Parent = mainFrame,
    })
    applyCorner(tabBar, 0, 0, 0, 12)

    local tabList = createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = tabBar,
    })

    local tabPadding = createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        Parent = tabBar,
    })

    -- ContentContainer
    local contentContainer = createInstance("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -120, 1, -32),
        Position = UDim2.new(0, 120, 0, 32),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        Parent = mainFrame,
    })
    applyCorner(contentContainer, 0, 12, 12, 0)

    local window = setmetatable({
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        TabBar = tabBar,
        ContentContainer = contentContainer,
        Tabs = {},
    }, Blue)

    return window
end

-- Создание вкладки
function Blue:CreateTab(name)
    local tabFrame = createInstance("Frame", {
        Name = name .. "TabFrame",
        Size = UDim2.new(1, 0, 0, 33),
        BackgroundTransparency = 1,
        Parent = self.TabBar,
    })

    local tabButton = createInstance("TextButton", {
        Name = name .. "Tab",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = COLORS.SurfaceLight,
        BorderSizePixel = 1,
        BorderColor3 = COLORS.Border,
        Text = name,
        TextColor3 = COLORS.Text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        AutoButtonColor = true,
        Parent = tabFrame,
    })

    -- Закругления: первый таб сверху, последний снизу (обновим после)
    applyCorner(tabButton, 0, 0, 0, 0)

    -- Страница
    local page = createInstance("ScrollingFrame", {
        Name = name .. "Page",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = COLORS.Background,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 575),
        ScrollingDirection = Enum.ScrollingDirection.XY,
        Parent = self.ContentContainer,
    })

    local pageList = createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = page,
    })

    local pagePadding = createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        Parent = page,
    })

    local tabObj = setmetatable({
        Frame = tabFrame,
        Button = tabButton,
        Page = page,
        Window = self,
        Name = name,
        LayoutOrder = #self.Tabs + 1,
    }, Blue)

    table.insert(self.Tabs, tabObj)
    tabFrame.LayoutOrder = tabObj.LayoutOrder

    -- Пересчитать закругления табов
    self:RefreshTabCorners()

    -- Переключение страниц
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(tabObj)
    end)

    -- Выбрать первую вкладку
    if #self.Tabs == 1 then
        self:SelectTab(tabObj)
    end

    return tabObj
end

function Blue:RefreshTabCorners()
    local tabs = self.Tabs
    for i, tab in ipairs(tabs) do
        local corner = tab.Button:FindFirstChild("UICorner")
        if not corner then
            corner = Instance.new("UICorner")
            corner.Parent = tab.Button
        end
        if i == 1 then
            corner.TopLeftRadius = UDim.new(0, 8)
            corner.TopRightRadius = UDim.new(0, 8)
            corner.BottomLeftRadius = UDim.new(0, 0)
            corner.BottomRightRadius = UDim.new(0, 0)
        elseif i == #tabs then
            corner.TopLeftRadius = UDim.new(0, 0)
            corner.TopRightRadius = UDim.new(0, 0)
            corner.BottomLeftRadius = UDim.new(0, 8)
            corner.BottomRightRadius = UDim.new(0, 8)
        else
            corner.TopLeftRadius = UDim.new(0, 0)
            corner.TopRightRadius = UDim.new(0, 0)
            corner.BottomLeftRadius = UDim.new(0, 0)
            corner.BottomRightRadius = UDim.new(0, 0)
        end
    end
end

function Blue:SelectTab(tab)
    for _, t in ipairs(self.Tabs) do
        t.Page.Visible = t == tab
        if t == tab then
            t.Button.BackgroundColor3 = COLORS.Accent
            t.Button.TextColor3 = COLORS.TextLight
        else
            t.Button.BackgroundColor3 = COLORS.SurfaceLight
            t.Button.TextColor3 = COLORS.Text
        end
    end
end

-- Создание лейбла
function Blue:CreateLabel(text)
    local label = createInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = COLORS.TextDark,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 0,
        Parent = self.Page,
    })
    return label
end

-- Создание кнопки
function Blue:CreateButton(config)
    config = config or {}
    local button = createInstance("TextButton", {
        Size = UDim2.new(0, 100, 0, 30),
        BackgroundColor3 = COLORS.SurfaceLight,
        BorderSizePixel = 1,
        BorderColor3 = COLORS.Border,
        Text = config.Text or "Button",
        TextColor3 = COLORS.TextDark,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        AutoButtonColor = true,
        Parent = self.Page,
    })
    applyCorner(button, 6, 6, 6, 6)

    if config.Callback then
        button.MouseButton1Click:Connect(config.Callback)
    end

    return button
end

-- Создание тоггла
function Blue:CreateToggle(config)
    config = config or {}
    local row = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        Parent = self.Page,
    })
    applyCorner(row, 8, 8, 8, 8)

    local rowList = createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = row,
    })

    local rowPadding = createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = row,
    })

    local label = createInstance("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Toggle",
        TextColor3 = COLORS.TextDark,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Parent = row,
    })

    local toggleButton = createInstance("TextButton", {
        Size = UDim2.new(0, 60, 0, 30),
        BackgroundColor3 = COLORS.SurfaceLight,
        BorderSizePixel = 1,
        BorderColor3 = COLORS.Border,
        Text = config.Default and "ON" or "OFF",
        TextColor3 = COLORS.TextDark,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        AutoButtonColor = true,
        LayoutOrder = 2,
        Parent = row,
    })
    applyCorner(toggleButton, 6, 6, 6, 6)

    local state = config.Default or false
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        toggleButton.Text = state and "ON" or "OFF"
        if config.Callback then
            config.Callback(state)
        end
    end)

    return toggleButton
end

-- Создание слайдера
function Blue:CreateSlider(config)
    config = config or {}
    local row = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        Parent = self.Page,
    })
    applyCorner(row, 8, 8, 8, 8)

    local rowList = createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = row,
    })

    local rowPadding = createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = row,
    })

    local label = createInstance("TextLabel", {
        Size = UDim2.new(0, 80, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Slider",
        TextColor3 = COLORS.TextDark,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Parent = row,
    })

    local sliderBar = createInstance("Frame", {
        Size = UDim2.new(1, -130, 0, 10),
        BackgroundColor3 = COLORS.Border,
        BorderSizePixel = 0,
        LayoutOrder = 2,
        Parent = row,
    })
    applyCorner(sliderBar, 5, 5, 5, 5)

    local sliderFill = createInstance("Frame", {
        Size = UDim2.new((config.Default or 0) / 100, 0, 1, 0),
        BackgroundColor3 = COLORS.Accent,
        BorderSizePixel = 0,
        Parent = sliderBar,
    })
    applyCorner(sliderFill, 5, 5, 5, 5)

    local sliderKnob = createInstance("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new((config.Default or 0) / 100, -7, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = COLORS.TextLight,
        BorderSizePixel = 0,
        Parent = sliderBar,
    })
    applyCorner(sliderKnob, 7, 7, 7, 7)

    local valueLabel = createInstance("TextLabel", {
        Size = UDim2.new(0, 50, 1, 0),
        BackgroundTransparency = 1,
        Text = (config.Default or 0) .. "%",
        TextColor3 = COLORS.TextDark,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
        LayoutOrder = 3,
        Parent = row,
    })

    local function updateSlider(input)
        local relX = (input.Position.X - sliderBar.AbsolutePosition.X) / math.max(sliderBar.AbsoluteSize.X, 1)
        local fraction = math.clamp(relX, 0, 1)
        local percent = math.floor(fraction * 100 + 0.5)
        sliderFill.Size = UDim2.new(fraction, 0, 1, 0)
        sliderKnob.Position = UDim2.new(fraction, -7, 0.5, 0)
        valueLabel.Text = percent .. "%"
        if config.Callback then
            config.Callback(percent)
        end
    end

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input)
            local conn
            conn = UserInputService.InputChanged:Connect(function(changed)
                if changed.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(changed)
                end
            end)
            UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                    conn:Disconnect()
                end
            end)
        end
    end)

    return sliderBar
end

-- Создание дропдауна
function Blue:CreateDropdown(config)
    config = config or {}
    local row = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        Parent = self.Page,
    })
    applyCorner(row, 8, 8, 8, 8)

    local rowList = createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = row,
    })

    local rowPadding = createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = row,
    })

    local label = createInstance("TextLabel", {
        Size = UDim2.new(1, -180, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Dropdown",
        TextColor3 = COLORS.TextDark,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Parent = row,
    })

    local dropdownButton = createInstance("TextButton", {
        Size = UDim2.new(0, 170, 0, 30),
        BackgroundColor3 = COLORS.SurfaceLight,
        BorderSizePixel = 1,
        BorderColor3 = COLORS.Border,
        Text = config.Default or (config.Options and config.Options[1]) or "Select",
        TextColor3 = COLORS.TextDark,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        AutoButtonColor = true,
        LayoutOrder = 2,
        Parent = row,
    })
    applyCorner(dropdownButton, 6, 6, 6, 6)

    local options = config.Options or {}
    dropdownButton.MouseButton1Click:Connect(function()
        -- Простая реализация: циклически переключать опции
        if #options > 0 then
            local currentText = dropdownButton.Text
            local currentIndex = table.find(options, currentText) or 0
            local nextIndex = (currentIndex % #options) + 1
            dropdownButton.Text = options[nextIndex]
            if config.Callback then
                config.Callback(options[nextIndex])
            end
        end
    end)

    return dropdownButton
end

-- Создание кейбинда
function Blue:CreateKeybind(config)
    config = config or {}
    local row = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = COLORS.Surface,
        BorderSizePixel = 0,
        Parent = self.Page,
    })
    applyCorner(row, 8, 8, 8, 8)

    local rowList = createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = row,
    })

    local rowPadding = createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = row,
    })

    local label = createInstance("TextLabel", {
        Size = UDim2.new(1, -120, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Keybind",
        TextColor3 = COLORS.TextDark,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Parent = row,
    })

    local keyButton = createInstance("TextButton", {
        Size = UDim2.new(0, 110, 0, 30),
        BackgroundColor3 = COLORS.SurfaceLight,
        BorderSizePixel = 1,
        BorderColor3 = COLORS.Border,
        Text = config.Default or "None",
        TextColor3 = COLORS.TextDark,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        AutoButtonColor = true,
        LayoutOrder = 2,
        Parent = row,
    })
    applyCorner(keyButton, 6, 6, 6, 6)

    keyButton.MouseButton1Click:Connect(function()
        keyButton.Text = "Press key..."
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                keyButton.Text = input.KeyCode.Name
                if config.Callback then
                    config.Callback(input.KeyCode.Name)
                end
                conn:Disconnect()
            end
        end)
    end)

    return keyButton
end

return Blue
