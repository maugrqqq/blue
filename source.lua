-- UILib - универсальная библиотека чит-меню
-- Использование: local UILib = loadstring(game:HttpGet("URL"))()
-- local win = UILib:CreateWindow({Title = "BGS Auto Hatch"})
-- local tab = win:CreateTab("Auto Hatch")
-- tab:CreateToggle({Text = "Auto Hatch", Flag = "AutoHatch", Default = false, Callback = function(v) end})

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local UILib = {}
UILib.__index = UILib

-- ТЕМЫ (1:1 как DarkBlueUtility)
local THEMES = {
	["Rose"] = {
		ContainerGradTop = Color3.fromRGB(60, 28, 40),
		ContainerGradBottom = Color3.fromRGB(45, 18, 28),
		TabBarGradTop = Color3.fromRGB(70, 35, 48),
		TabBarGradBottom = Color3.fromRGB(55, 25, 35),
		TopBarGradTop = Color3.fromRGB(80, 42, 55),
		TopBarGradBottom = Color3.fromRGB(65, 30, 42),
		RowGradTop = Color3.fromRGB(80, 42, 55),
		RowGradBottom = Color3.fromRGB(65, 28, 40),
		SliderBarGradTop = Color3.fromRGB(90, 50, 65),
		SliderBarGradBottom = Color3.fromRGB(105, 65, 80),
		AccentGradTop = Color3.fromRGB(255, 100, 140),
		AccentGradBottom = Color3.fromRGB(255, 150, 180),
		ButtonBg = Color3.fromRGB(75, 35, 48),
		ButtonTextColor = Color3.fromRGB(255, 255, 255),
		PlaceholderColor = Color3.fromRGB(140, 90, 105),
	},
	["Ocean"] = {
		ContainerGradTop = Color3.fromRGB(18, 48, 76),
		ContainerGradBottom = Color3.fromRGB(10, 30, 50),
		TabBarGradTop = Color3.fromRGB(25, 58, 88),
		TabBarGradBottom = Color3.fromRGB(15, 38, 60),
		TopBarGradTop = Color3.fromRGB(30, 68, 100),
		TopBarGradBottom = Color3.fromRGB(20, 45, 70),
		RowGradTop = Color3.fromRGB(30, 68, 100),
		RowGradBottom = Color3.fromRGB(22, 48, 74),
		SliderBarGradTop = Color3.fromRGB(40, 80, 110),
		SliderBarGradBottom = Color3.fromRGB(55, 95, 125),
		AccentGradTop = Color3.fromRGB(0, 180, 216),
		AccentGradBottom = Color3.fromRGB(72, 202, 228),
		ButtonBg = Color3.fromRGB(28, 55, 78),
		ButtonTextColor = Color3.fromRGB(255, 255, 255),
		PlaceholderColor = Color3.fromRGB(100, 130, 150),
	},
	["Dark"] = {
		ContainerGradTop = Color3.fromRGB(20, 28, 48),
		ContainerGradBottom = Color3.fromRGB(12, 18, 34),
		TabBarGradTop = Color3.fromRGB(28, 36, 58),
		TabBarGradBottom = Color3.fromRGB(18, 26, 44),
		TopBarGradTop = Color3.fromRGB(35, 45, 70),
		TopBarGradBottom = Color3.fromRGB(22, 30, 50),
		RowGradTop = Color3.fromRGB(35, 45, 70),
		RowGradBottom = Color3.fromRGB(25, 33, 53),
		SliderBarGradTop = Color3.fromRGB(40, 50, 75),
		SliderBarGradBottom = Color3.fromRGB(55, 65, 90),
		AccentGradTop = Color3.fromRGB(59, 130, 255),
		AccentGradBottom = Color3.fromRGB(110, 180, 255),
		ButtonBg = Color3.fromRGB(38, 43, 56),
		ButtonTextColor = Color3.fromRGB(255, 255, 255),
		PlaceholderColor = Color3.fromRGB(100, 110, 130),
	},
	["Mint"] = {
		ContainerGradTop = Color3.fromRGB(225, 250, 242),
		ContainerGradBottom = Color3.fromRGB(205, 238, 226),
		TabBarGradTop = Color3.fromRGB(235, 252, 247),
		TabBarGradBottom = Color3.fromRGB(215, 242, 232),
		TopBarGradTop = Color3.fromRGB(248, 255, 252),
		TopBarGradBottom = Color3.fromRGB(228, 245, 237),
		RowGradTop = Color3.fromRGB(248, 255, 252),
		RowGradBottom = Color3.fromRGB(228, 245, 237),
		SliderBarGradTop = Color3.fromRGB(200, 225, 212),
		SliderBarGradBottom = Color3.fromRGB(218, 238, 228),
		AccentGradTop = Color3.fromRGB(0, 170, 120),
		AccentGradBottom = Color3.fromRGB(70, 210, 160),
		ButtonBg = Color3.fromRGB(230, 248, 240),
		ButtonTextColor = Color3.fromRGB(25, 60, 45),
		PlaceholderColor = Color3.fromRGB(120, 150, 135),
	},
	["Forest"] = {
		ContainerGradTop = Color3.fromRGB(28, 50, 38),
		ContainerGradBottom = Color3.fromRGB(18, 35, 26),
		TabBarGradTop = Color3.fromRGB(35, 60, 45),
		TabBarGradBottom = Color3.fromRGB(25, 45, 35),
		TopBarGradTop = Color3.fromRGB(42, 70, 52),
		TopBarGradBottom = Color3.fromRGB(30, 50, 38),
		RowGradTop = Color3.fromRGB(42, 70, 52),
		RowGradBottom = Color3.fromRGB(32, 55, 42),
		SliderBarGradTop = Color3.fromRGB(50, 80, 60),
		SliderBarGradBottom = Color3.fromRGB(65, 95, 75),
		AccentGradTop = Color3.fromRGB(80, 180, 100),
		AccentGradBottom = Color3.fromRGB(120, 220, 140),
		ButtonBg = Color3.fromRGB(45, 65, 52),
		ButtonTextColor = Color3.fromRGB(255, 255, 255),
		PlaceholderColor = Color3.fromRGB(110, 130, 118),
	},
	["Crimson"] = {
		ContainerGradTop = Color3.fromRGB(65, 22, 28),
		ContainerGradBottom = Color3.fromRGB(45, 14, 18),
		TabBarGradTop = Color3.fromRGB(75, 28, 34),
		TabBarGradBottom = Color3.fromRGB(55, 18, 24),
		TopBarGradTop = Color3.fromRGB(85, 34, 40),
		TopBarGradBottom = Color3.fromRGB(62, 22, 28),
		RowGradTop = Color3.fromRGB(85, 34, 40),
		RowGradBottom = Color3.fromRGB(65, 24, 30),
		SliderBarGradTop = Color3.fromRGB(95, 42, 48),
		SliderBarGradBottom = Color3.fromRGB(110, 55, 60),
		AccentGradTop = Color3.fromRGB(220, 40, 55),
		AccentGradBottom = Color3.fromRGB(255, 90, 100),
		ButtonBg = Color3.fromRGB(78, 28, 34),
		ButtonTextColor = Color3.fromRGB(255, 255, 255),
		PlaceholderColor = Color3.fromRGB(145, 95, 100),
	},
	["Coral"] = {
		ContainerGradTop = Color3.fromRGB(255, 240, 235),
		ContainerGradBottom = Color3.fromRGB(250, 218, 210),
		TabBarGradTop = Color3.fromRGB(255, 245, 240),
		TabBarGradBottom = Color3.fromRGB(250, 225, 218),
		TopBarGradTop = Color3.fromRGB(255, 250, 247),
		TopBarGradBottom = Color3.fromRGB(250, 232, 226),
		RowGradTop = Color3.fromRGB(255, 250, 247),
		RowGradBottom = Color3.fromRGB(250, 232, 226),
		SliderBarGradTop = Color3.fromRGB(245, 215, 205),
		SliderBarGradBottom = Color3.fromRGB(255, 228, 220),
		AccentGradTop = Color3.fromRGB(255, 95, 85),
		AccentGradBottom = Color3.fromRGB(255, 150, 130),
		ButtonBg = Color3.fromRGB(255, 240, 235),
		ButtonTextColor = Color3.fromRGB(80, 35, 28),
		PlaceholderColor = Color3.fromRGB(150, 110, 100),
	},
	["Lavender"] = {
		ContainerGradTop = Color3.fromRGB(235, 228, 255),
		ContainerGradBottom = Color3.fromRGB(218, 208, 245),
		TabBarGradTop = Color3.fromRGB(242, 237, 255),
		TabBarGradBottom = Color3.fromRGB(225, 216, 248),
		TopBarGradTop = Color3.fromRGB(250, 247, 255),
		TopBarGradBottom = Color3.fromRGB(235, 228, 252),
		RowGradTop = Color3.fromRGB(250, 247, 255),
		RowGradBottom = Color3.fromRGB(235, 228, 252),
		SliderBarGradTop = Color3.fromRGB(215, 205, 240),
		SliderBarGradBottom = Color3.fromRGB(230, 220, 250),
		AccentGradTop = Color3.fromRGB(130, 90, 230),
		AccentGradBottom = Color3.fromRGB(170, 140, 255),
		ButtonBg = Color3.fromRGB(238, 232, 255),
		ButtonTextColor = Color3.fromRGB(45, 30, 80),
		PlaceholderColor = Color3.fromRGB(130, 115, 160),
	},
	["Slate"] = {
		ContainerGradTop = Color3.fromRGB(45, 52, 65),
		ContainerGradBottom = Color3.fromRGB(32, 38, 48),
		TabBarGradTop = Color3.fromRGB(52, 60, 74),
		TabBarGradBottom = Color3.fromRGB(38, 44, 56),
		TopBarGradTop = Color3.fromRGB(60, 68, 82),
		TopBarGradBottom = Color3.fromRGB(44, 50, 62),
		RowGradTop = Color3.fromRGB(60, 68, 82),
		RowGradBottom = Color3.fromRGB(46, 52, 64),
		SliderBarGradTop = Color3.fromRGB(70, 78, 92),
		SliderBarGradBottom = Color3.fromRGB(85, 93, 107),
		AccentGradTop = Color3.fromRGB(100, 130, 170),
		AccentGradBottom = Color3.fromRGB(140, 170, 200),
		ButtonBg = Color3.fromRGB(55, 62, 75),
		ButtonTextColor = Color3.fromRGB(255, 255, 255),
		PlaceholderColor = Color3.fromRGB(120, 130, 145),
	},
	["Light"] = {
		ContainerGradTop = Color3.fromRGB(245, 248, 255),
		ContainerGradBottom = Color3.fromRGB(228, 234, 250),
		TabBarGradTop = Color3.fromRGB(248, 250, 255),
		TabBarGradBottom = Color3.fromRGB(235, 240, 252),
		TopBarGradTop = Color3.fromRGB(255, 255, 255),
		TopBarGradBottom = Color3.fromRGB(244, 247, 255),
		RowGradTop = Color3.fromRGB(255, 255, 255),
		RowGradBottom = Color3.fromRGB(244, 247, 255),
		SliderBarGradTop = Color3.fromRGB(210, 220, 240),
		SliderBarGradBottom = Color3.fromRGB(230, 238, 250),
		AccentGradTop = Color3.fromRGB(59, 130, 255),
		AccentGradBottom = Color3.fromRGB(110, 180, 255),
		ButtonBg = Color3.fromRGB(255, 255, 255),
		ButtonTextColor = Color3.fromRGB(30, 40, 60),
		PlaceholderColor = Color3.fromRGB(140, 150, 175),
	},
}
local THEME_NAMES = {"Light", "Dark", "Forest", "Rose", "Ocean", "Mint", "Lavender", "Coral", "Slate", "Crimson"}
-- Вспомогательные функции
local function createInstance(className, props)
	local inst = Instance.new(className)
	for k, v in pairs(props) do inst[k] = v end
	return inst
end

local function applyCorner(inst, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = inst
	return corner
end

local function applyGradient(inst, color1, color2)
	local gradient = inst:FindFirstChild("UIGradient")
	if not gradient then gradient = Instance.new("UIGradient"); gradient.Parent = inst end
	gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, color1), ColorSequenceKeypoint.new(1, color2 or color1)})
end

-- Сохранение настроек
function UILib:SaveSettings()
	if self.Config.SaveSettings == false then return end
	local settingsFolder = game.ReplicatedStorage:FindFirstChild("UILibSettings_" .. (self.Config and self.Config.Name or "UILib"))
	if not settingsFolder then
		settingsFolder = Instance.new("Folder")
		settingsFolder.Name = "UILibSettings_" .. (self.Config and self.Config.Name or "UILib")
		settingsFolder.Parent = game.ReplicatedStorage
	end
	for k, v in pairs(self.Settings) do
		settingsFolder:SetAttribute(k, v)
	end
end

function UILib:LoadSettings()
	if self.Config.SaveSettings == false then return end
	local settingsFolder = game.ReplicatedStorage:FindFirstChild("UILibSettings_" .. (self.Config and self.Config.Name or "UILib"))
	if settingsFolder then
		for _, attr in ipairs(settingsFolder:GetAttributes()) do
			self.Settings[attr] = settingsFolder:GetAttribute(attr)
		end
	end
end

-- Применение темы
function UILib:ApplyTheme(themeName)
	local theme = THEMES[themeName]
	if not theme then return end
	self.CurrentTheme = themeName
	self.Settings.Theme = themeName
	self:SaveSettings()
	
	applyGradient(self.MainFrame, theme.ContainerGradTop, theme.ContainerGradBottom)
	applyGradient(self.ContentContainer, theme.ContainerGradTop, theme.ContainerGradBottom)
	applyGradient(self.TabBar, theme.TabBarGradTop, theme.TabBarGradBottom)
	local topBar = self.MainFrame:FindFirstChild("TopBar")
	if topBar then applyGradient(topBar, theme.TopBarGradTop, theme.TopBarGradBottom) end
	
	for _, tab in ipairs(self.Tabs) do
		applyGradient(tab.Page, theme.ContainerGradTop, theme.ContainerGradBottom)
		tab.Button.BackgroundColor3 = theme.ButtonBg
		tab.Button.TextColor3 = theme.ButtonTextColor
		for _, desc in ipairs(tab.Page:GetDescendants()) do
			if desc:IsA("Frame") then
				if desc:FindFirstChild("UIGradient") then
					if desc.Name == "SliderBar" then
						applyGradient(desc, theme.SliderBarGradTop, theme.SliderBarGradBottom)
					else
						applyGradient(desc, theme.RowGradTop, theme.RowGradBottom)
					end
				end
			elseif desc:IsA("TextButton") or desc:IsA("TextBox") then
				desc.BackgroundColor3 = theme.ButtonBg
				desc.TextColor3 = theme.ButtonTextColor
			elseif desc:IsA("TextLabel") then
				desc.TextColor3 = theme.ButtonTextColor
			end
		end
	end
	
	local minimizeBtn = self.MainFrame.TopBar:FindFirstChild("MinimizeButton")
	local closeBtn = self.MainFrame.TopBar:FindFirstChild("CloseButton")
	if minimizeBtn then minimizeBtn.BackgroundColor3 = theme.AccentGradTop; minimizeBtn.BorderColor3 = theme.AccentGradBottom end
	if closeBtn then closeBtn.BackgroundColor3 = theme.AccentGradTop; closeBtn.BorderColor3 = theme.AccentGradBottom end
end

-- Перетаскивание окна
function UILib:SetupDrag(dragZone, mainFrame)
	local dragging = false
	local dragStart = nil
	local startPos = nil
	local dragInput = nil
	
	dragZone.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
		end
	end)
	
	dragZone.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
end

-- Создание окна (1:1 как DarkBlueUtility)
function UILib:CreateWindow(config)
	config = config or {}
	local parent = config.Parent
	if not parent then
		if game.Players.LocalPlayer then
			parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
		else
			parent = game.StarterGui
		end
	end
	local screenGui = createInstance("ScreenGui", {Name = config.Name or "UILib", Parent = parent, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
	local mainFrame = createInstance("Frame", {Name = "MainFrame", Size = config.Size or UDim2.new(0, 560, 0, 400), Position = config.Position or UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(235, 240, 252), BorderSizePixel = 0, ClipsDescendants = true, Parent = screenGui})
	applyCorner(mainFrame, 12)
	
	local topBar = createInstance("Frame", {Name = "TopBar", Size = UDim2.new(1, 0, 0, 32), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(250, 252, 255), BorderSizePixel = 0, ZIndex = 10, Parent = mainFrame})
	applyCorner(topBar, 12)
	createInstance("TextLabel", {Name = "Title", Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = config.Title or "UI", TextColor3 = Color3.fromRGB(40, 50, 70), Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = topBar})
	
	local minimizeButton = createInstance("TextButton", {Name = "MinimizeButton", Size = UDim2.new(0, 28, 0, 24), Position = UDim2.new(1, -64, 0.5, -12), BackgroundColor3 = Color3.fromRGB(59, 130, 255), BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(180, 192, 220), Text = "—", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Gotham, TextSize = 14, ZIndex = 11, Parent = topBar})
	applyCorner(minimizeButton, 6)
	local closeButton = createInstance("TextButton", {Name = "CloseButton", Size = UDim2.new(0, 28, 0, 24), Position = UDim2.new(1, -32, 0.5, -12), BackgroundColor3 = Color3.fromRGB(59, 130, 255), BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(180, 192, 220), Text = "X", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Gotham, TextSize = 14, ZIndex = 11, Parent = topBar})
	applyCorner(closeButton, 6)
	
	local tabBar = createInstance("Frame", {Name = "TabBar", Size = UDim2.new(0, 140, 1, -32), Position = UDim2.new(0, 0, 0, 21), BackgroundColor3 = Color3.fromRGB(242, 246, 255), BorderSizePixel = 0, Parent = mainFrame})
	applyCorner(tabBar, 0)
	createInstance("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = tabBar})
	createInstance("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), Parent = tabBar})
	
	local contentContainer = createInstance("Frame", {Name = "ContentContainer", Size = UDim2.new(1, -140, 1, -32), Position = UDim2.new(0, 140, 0, 36), BackgroundColor3 = Color3.fromRGB(235, 240, 252), BorderSizePixel = 0, Parent = mainFrame})
	applyCorner(contentContainer, 0)
	
	local window = setmetatable({ScreenGui = screenGui, MainFrame = mainFrame, TabBar = tabBar, ContentContainer = contentContainer, Tabs = {}, CurrentTheme = "Light", Settings = {}, Config = config}, UILib)
	window:LoadSettings()
	window:ApplyTheme(window.Settings.Theme or "Light")
	window:SetupDrag(topBar, mainFrame)
	window:SetupDrag(tabBar, mainFrame)
	
	local isMinimized = false
	local ORIGINAL_SIZE = mainFrame.Size
	minimizeButton.MouseButton1Click:Connect(function()
		if isMinimized then
			tabBar.Visible = true
			contentContainer.Visible = true
			TweenService:Create(mainFrame, TweenInfo.new(0.25), {Size = ORIGINAL_SIZE}):Play()
			isMinimized = false
		else
			TweenService:Create(mainFrame, TweenInfo.new(0.25), {Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, 32)}):Play()
			task.wait(0.25)
			tabBar.Visible = false
			contentContainer.Visible = false
			isMinimized = true
		end
	end)
	
	closeButton.MouseButton1Click:Connect(function() mainFrame.Visible = false end)
	
	-- Кейбинд для открытия/закрытия меню
	local menuKey = config.Keybind or window.Settings.MenuKey or "L"
	local function updateMenuKey(newKey)
		menuKey = newKey
	end
	window.UpdateMenuKey = updateMenuKey
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == menuKey then
			mainFrame.Visible = not mainFrame.Visible
		end
	end)
	
	-- Всегда создаём Settings вкладку
	window:CreateSettingsTab()
	
	return window
end

-- Создание Settings вкладки (автоматически)
function UILib:CreateSettingsTab()
	local settingsTab = self:CreateTab("Settings")
	settingsTab.LayoutOrder = 999 -- Всегда последняя
	
	-- Заголовок Configs
	settingsTab:CreateLabel("Configs")
	
	-- Config textbox
	local configRow = createInstance("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = THEMES[self.CurrentTheme].RowGradTop, BorderSizePixel = 0, Parent = settingsTab.Page})
	applyCorner(configRow, 8)
	createInstance("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Center, Parent = configRow})
	createInstance("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = configRow})
	createInstance("TextLabel", {Size = UDim2.new(0, 70, 1, 0), BackgroundTransparency = 1, Text = "Config", TextColor3 = THEMES[self.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1, Parent = configRow})
	local configTextbox = createInstance("TextBox", {Size = UDim2.new(1, -80, 0, 30), BackgroundColor3 = THEMES[self.CurrentTheme].ButtonBg, BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(180, 192, 220), Text = self.Settings.Config or "", TextColor3 = THEMES[self.CurrentTheme].ButtonTextColor, PlaceholderColor3 = Color3.fromRGB(140, 150, 175), PlaceholderText = "Enter config...", Font = Enum.Font.Gotham, TextSize = 14, ClearTextOnFocus = false, LayoutOrder = 2, Parent = configRow})
	applyCorner(configTextbox, 6)
	configTextbox.FocusLost:Connect(function()
		self.Settings.Config = configTextbox.Text
		self:SaveSettings()
	end)
	
	-- Тема
	local themeRow = createInstance("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = THEMES[self.CurrentTheme].RowGradTop, BorderSizePixel = 0, Parent = settingsTab.Page})
	applyCorner(themeRow, 8)
	createInstance("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Center, Parent = themeRow})
	createInstance("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = themeRow})
	createInstance("TextLabel", {Size = UDim2.new(1, -180, 1, 0), BackgroundTransparency = 1, Text = "Theme", TextColor3 = THEMES[self.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1, Parent = themeRow})
	local themeDropdown = createInstance("TextButton", {Size = UDim2.new(0, 170, 0, 30), BackgroundColor3 = THEMES[self.CurrentTheme].ButtonBg, BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(180, 192, 220), Text = self.Settings.Theme or "Light", TextColor3 = THEMES[self.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamMedium, TextSize = 14, LayoutOrder = 2, Parent = themeRow})
	applyCorner(themeDropdown, 6)
	themeDropdown.MouseButton1Click:Connect(function()
		local currentText = themeDropdown.Text
		local currentIndex = table.find(THEME_NAMES, currentText) or 0
		local nextIndex = (currentIndex % #THEME_NAMES) + 1
		themeDropdown.Text = THEME_NAMES[nextIndex]
		self:ApplyTheme(THEME_NAMES[nextIndex])
	end)
	
	-- Меню keybind
	local menuKeyRow = createInstance("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = THEMES[self.CurrentTheme].RowGradTop, BorderSizePixel = 0, Parent = settingsTab.Page})
	applyCorner(menuKeyRow, 8)
	createInstance("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Center, Parent = menuKeyRow})
	createInstance("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = menuKeyRow})
	createInstance("TextLabel", {Size = UDim2.new(1, -120, 1, 0), BackgroundTransparency = 1, Text = "Menu Key", TextColor3 = THEMES[self.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1, Parent = menuKeyRow})
	local menuKeyButton = createInstance("TextButton", {Size = UDim2.new(0, 110, 0, 30), BackgroundColor3 = THEMES[self.CurrentTheme].ButtonBg, BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(180, 192, 220), Text = self.Settings.MenuKey or "L", TextColor3 = THEMES[self.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamMedium, TextSize = 14, LayoutOrder = 2, Parent = menuKeyRow})
	applyCorner(menuKeyButton, 6)
	menuKeyButton.MouseButton1Click:Connect(function()
		menuKeyButton.Text = "Press key..."
		local conn
		conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
				self.Settings.MenuKey = input.KeyCode.Name
				menuKeyButton.Text = input.KeyCode.Name
				self:SaveSettings()
				if self.UpdateMenuKey then self.UpdateMenuKey(input.KeyCode.Name) end
				conn:Disconnect()
			end
		end)
	end)
	
	-- Save/Load кнопки
	local buttonRow = createInstance("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = THEMES[self.CurrentTheme].RowGradTop, BorderSizePixel = 0, Parent = settingsTab.Page})
	applyCorner(buttonRow, 8)
	createInstance("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Center, Parent = buttonRow})
	createInstance("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = buttonRow})
	local saveButton = createInstance("TextButton", {Size = UDim2.new(0, 100, 0, 30), BackgroundColor3 = THEMES[self.CurrentTheme].ButtonBg, BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(180, 192, 220), Text = "Save", TextColor3 = THEMES[self.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamBold, TextSize = 14, LayoutOrder = 1, Parent = buttonRow})
	applyCorner(saveButton, 6)
	saveButton.MouseButton1Click:Connect(function()
		self:SaveSettings()
		saveButton.Text = "Saved!"
		task.wait(1)
		saveButton.Text = "Save"
	end)
	local loadButton = createInstance("TextButton", {Size = UDim2.new(0, 100, 0, 30), BackgroundColor3 = THEMES[self.CurrentTheme].ButtonBg, BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(180, 192, 220), Text = "Load", TextColor3 = THEMES[self.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamBold, TextSize = 14, LayoutOrder = 2, Parent = buttonRow})
	applyCorner(loadButton, 6)
	loadButton.MouseButton1Click:Connect(function()
		self:LoadSettings()
		configTextbox.Text = self.Settings.Config or ""
		themeDropdown.Text = self.Settings.Theme or "Light"
		menuKeyButton.Text = self.Settings.MenuKey or "L"
		self:ApplyTheme(self.Settings.Theme or "Light")
		loadButton.Text = "Loaded!"
		task.wait(1)
		loadButton.Text = "Load"
	end)
	
	return settingsTab
end

-- Создание вкладки
function UILib:CreateTab(name)
	local tabFrame = createInstance("Frame", {Name = name .. "TabFrame", Size = UDim2.new(1, 0, 0, 33), BackgroundTransparency = 1, Parent = self.TabBar})
	local tabButton = createInstance("TextButton", {Name = name .. "Tab", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = THEMES[self.CurrentTheme].ButtonBg, BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(180, 192, 220), Text = name, TextColor3 = THEMES[self.CurrentTheme].ButtonTextColor, Font = Enum.Font.Gotham, TextSize = 14, Parent = tabFrame})
	applyCorner(tabButton, 6)
	
	local page = createInstance("ScrollingFrame", {Name = name .. "Page", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = THEMES[self.CurrentTheme].ContainerGradTop, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 500), ScrollingDirection = Enum.ScrollingDirection.Y, Parent = self.ContentContainer})
	createInstance("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = page})
	createInstance("UIPadding", {PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), Parent = page})
	
	local tabObj = setmetatable({Frame = tabFrame, Button = tabButton, Page = page, Window = self, Name = name, LayoutOrder = #self.Tabs + 1}, UILib)
	table.insert(self.Tabs, tabObj)
	tabFrame.LayoutOrder = tabObj.LayoutOrder
	
	tabButton.MouseButton1Click:Connect(function() self:SelectTab(tabObj) end)
	if #self.Tabs == 1 then self:SelectTab(tabObj) end
	return tabObj
end

function UILib:SelectTab(tab)
	for _, t in ipairs(self.Tabs) do
		t.Page.Visible = t == tab
		if t == tab then
			t.Button.BackgroundColor3 = THEMES[self.CurrentTheme].AccentGradTop
			t.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			t.Button.BackgroundColor3 = THEMES[self.CurrentTheme].ButtonBg
			t.Button.TextColor3 = THEMES[self.CurrentTheme].ButtonTextColor
		end
	end
end

-- Элементы
function UILib:CreateLabel(text)
	return createInstance("TextLabel", {Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = text, TextColor3 = THEMES[self.Window.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = self.Page})
end

function UILib:CreateButton(config)
	config = config or {}
	local button = createInstance("TextButton", {Size = UDim2.new(0, 100, 0, 30), BackgroundColor3 = THEMES[self.Window.CurrentTheme].ButtonBg, BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(180, 192, 220), Text = config.Text or "Button", TextColor3 = THEMES[self.Window.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamBold, TextSize = 14, Parent = self.Page})
	applyCorner(button, 6)
	if config.Callback then button.MouseButton1Click:Connect(config.Callback) end
	return button
end

function UILib:CreateToggle(config)
	config = config or {}
	local row = createInstance("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = THEMES[self.Window.CurrentTheme].RowGradTop, BorderSizePixel = 0, Parent = self.Page})
	applyCorner(row, 8)
	createInstance("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Center, Parent = row})
	createInstance("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = row})
	createInstance("TextLabel", {Size = UDim2.new(1, -70, 1, 0), BackgroundTransparency = 1, Text = config.Text or "Toggle", TextColor3 = THEMES[self.Window.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1, Parent = row})
	local toggleButton = createInstance("TextButton", {Size = UDim2.new(0, 60, 0, 30), BackgroundColor3 = THEMES[self.Window.CurrentTheme].ButtonBg, BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(180, 192, 220), Text = "OFF", TextColor3 = THEMES[self.Window.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamBold, TextSize = 14, LayoutOrder = 2, Parent = row})
	applyCorner(toggleButton, 6)
	local state = config.Default or false
	if config.Flag then state = self.Window.Settings[config.Flag] or state end
	local function update()
		toggleButton.Text = state and "ON" or "OFF"
		if config.Flag then self.Window.Settings[config.Flag] = state; self.Window:SaveSettings() end
		if config.Callback then config.Callback(state) end
	end
	update()
	toggleButton.MouseButton1Click:Connect(function() state = not state; update() end)
	return toggleButton
end

function UILib:CreateSlider(config)
	config = config or {}
	local row = createInstance("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = THEMES[self.Window.CurrentTheme].RowGradTop, BorderSizePixel = 0, Parent = self.Page})
	applyCorner(row, 8)
	createInstance("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Center, Parent = row})
	createInstance("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = row})
	createInstance("TextLabel", {Size = UDim2.new(0, 80, 1, 0), BackgroundTransparency = 1, Text = config.Text or "Slider", TextColor3 = THEMES[self.Window.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1, Parent = row})
	local sliderBar = createInstance("Frame", {Size = UDim2.new(1, -130, 0, 10), BackgroundColor3 = THEMES[self.Window.CurrentTheme].SliderBarGradTop, BorderSizePixel = 0, LayoutOrder = 2, Parent = row})
	applyCorner(sliderBar, 5)
	local sliderFill = createInstance("Frame", {Size = UDim2.new((config.Default or 0) / 100, 0, 1, 0), BackgroundColor3 = THEMES[self.Window.CurrentTheme].AccentGradTop, BorderSizePixel = 0, Parent = sliderBar})
	applyCorner(sliderFill, 5)
	local sliderKnob = createInstance("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new((config.Default or 0) / 100, -7, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = THEMES[self.Window.CurrentTheme].ButtonBg, BorderSizePixel = 0, Parent = sliderBar})
	applyCorner(sliderKnob, 7)
	local valueLabel = createInstance("TextLabel", {Size = UDim2.new(0, 50, 1, 0), BackgroundTransparency = 1, Text = (config.Default or 0) .. "%", TextColor3 = THEMES[self.Window.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right, LayoutOrder = 3, Parent = row})
	
	local function updateSlider(input)
		local relX = (input.Position.X - sliderBar.AbsolutePosition.X) / math.max(sliderBar.AbsoluteSize.X, 1)
		local fraction = math.clamp(relX, 0, 1)
		local percent = math.floor(fraction * 100 + 0.5)
		sliderFill.Size = UDim2.new(fraction, 0, 1, 0)
		sliderKnob.Position = UDim2.new(fraction, -7, 0.5, 0)
		valueLabel.Text = percent .. "%"
		if config.Flag then self.Window.Settings[config.Flag] = percent; self.Window:SaveSettings() end
		if config.Callback then config.Callback(percent) end
	end
	
	sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			updateSlider(input)
			local conn
			conn = UserInputService.InputChanged:Connect(function(changed)
				if changed.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(changed) end
			end)
			UserInputService.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == Enum.UserInputType.MouseButton1 then conn:Disconnect() end
			end)
		end
	end)
	return sliderBar
end

function UILib:CreateDropdown(config)
	config = config or {}
	local row = createInstance("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = THEMES[self.Window.CurrentTheme].RowGradTop, BorderSizePixel = 0, Parent = self.Page})
	applyCorner(row, 8)
	createInstance("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Center, Parent = row})
	createInstance("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = row})
	createInstance("TextLabel", {Size = UDim2.new(1, -180, 1, 0), BackgroundTransparency = 1, Text = config.Text or "Dropdown", TextColor3 = THEMES[self.Window.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1, Parent = row})
	local dropdownButton = createInstance("TextButton", {Size = UDim2.new(0, 170, 0, 30), BackgroundColor3 = THEMES[self.Window.CurrentTheme].ButtonBg, BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(180, 192, 220), Text = config.Default or (config.Options and config.Options[1]) or "Select", TextColor3 = THEMES[self.Window.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamMedium, TextSize = 14, LayoutOrder = 2, Parent = row})
	applyCorner(dropdownButton, 6)
	local options = config.Options or {}
	dropdownButton.MouseButton1Click:Connect(function()
		if #options > 0 then
			local currentText = dropdownButton.Text
			local currentIndex = table.find(options, currentText) or 0
			local nextIndex = (currentIndex % #options) + 1
			dropdownButton.Text = options[nextIndex]
			if config.Flag then self.Window.Settings[config.Flag] = options[nextIndex]; self.Window:SaveSettings() end
			if config.Callback then config.Callback(options[nextIndex]) end
		end
	end)
	return dropdownButton
end

function UILib:CreateKeybind(config)
	config = config or {}
	local row = createInstance("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = THEMES[self.Window.CurrentTheme].RowGradTop, BorderSizePixel = 0, Parent = self.Page})
	applyCorner(row, 8)
	createInstance("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Center, Parent = row})
	createInstance("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = row})
	createInstance("TextLabel", {Size = UDim2.new(1, -120, 1, 0), BackgroundTransparency = 1, Text = config.Text or "Keybind", TextColor3 = THEMES[self.Window.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1, Parent = row})
	local keyButton = createInstance("TextButton", {Size = UDim2.new(0, 110, 0, 30), BackgroundColor3 = THEMES[self.Window.CurrentTheme].ButtonBg, BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(180, 192, 220), Text = config.Default or "+", TextColor3 = THEMES[self.Window.CurrentTheme].ButtonTextColor, Font = Enum.Font.GothamMedium, TextSize = 14, LayoutOrder = 2, Parent = row})
	applyCorner(keyButton, 6)
	keyButton.MouseButton1Click:Connect(function()
		keyButton.Text = "Press key..."
		local conn
		conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
				keyButton.Text = input.KeyCode.Name
				if config.Flag then self.Window.Settings[config.Flag] = input.KeyCode.Name; self.Window:SaveSettings() end
				if config.Callback then config.Callback(input.KeyCode.Name) end
				conn:Disconnect()
			end
		end)
	end)
	return keyButton
end

return UILib
