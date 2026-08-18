-- UILib - универсальная библиотека чит-меню
-- Использование: local UILib = loadstring(game:HttpGet("URL"))()
-- local win = UILib:CreateWindow({Title = "BGS Auto Hatch"})
-- local tab = win:CreateTab("Auto Hatch")
-- tab:CreateToggle({Text = "Auto Hatch", Flag = "AutoHatch", Default = false, Callback = function(v) end})

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local UILib = {}
UILib.__index = UILib

-- ТЕМЫ (кратко)
local THEMES = {}
local THEME_NAMES = {"Light", "Dark", "Forest", "Rose", "Ocean", "Mint", "Lavender", "Coral", "Slate", "Crimson"}

local function defineTheme(name, c1, c2, tab1, tab2, top1, top2, row1, row2, sl1, sl2, acc1, acc2, btnBg, btnText)
	THEMES[name] = {
		ContainerGradTop = Color3.fromRGB(c1), ContainerGradBottom = Color3.fromRGB(c2),
		TabBarGradTop = Color3.fromRGB(tab1), TabBarGradBottom = Color3.fromRGB(tab2),
		TopBarGradTop = Color3.fromRGB(top1), TopBarGradBottom = Color3.fromRGB(top2),
		RowGradTop = Color3.fromRGB(row1), RowGradBottom = Color3.fromRGB(row2),
		SliderBarGradTop = Color3.fromRGB(sl1), SliderBarGradBottom = Color3.fromRGB(sl2),
		AccentGradTop = Color3.fromRGB(acc1), AccentGradBottom = Color3.fromRGB(acc2),
		ButtonBg = Color3.fromRGB(btnBg), ButtonTextColor = Color3.fromRGB(btnText),
	}
end

defineTheme("Light", 245, 248, 255, 228, 234, 250, 248, 250, 255, 235, 240, 252, 255, 255, 255, 244, 247, 255, 255, 255, 255, 244, 247, 255, 210, 220, 240, 230, 238, 250, 59, 130, 255, 110, 180, 255, 255, 255, 255, 30, 40, 60)
defineTheme("Dark", 20, 28, 48, 12, 18, 34, 28, 36, 58, 18, 26, 44, 35, 45, 70, 22, 30, 50, 35, 45, 70, 25, 33, 53, 40, 50, 75, 55, 65, 90, 59, 130, 255, 110, 180, 255, 38, 43, 56, 255, 255, 255)
defineTheme("Forest", 28, 50, 38, 18, 35, 26, 35, 60, 45, 25, 45, 35, 42, 70, 52, 30, 50, 38, 42, 70, 52, 32, 55, 42, 50, 80, 60, 65, 95, 75, 80, 180, 100, 120, 220, 140, 45, 65, 52, 255, 255, 255)
defineTheme("Rose", 60, 28, 40, 45, 18, 28, 70, 35, 48, 55, 25, 35, 80, 42, 55, 65, 30, 42, 80, 42, 55, 65, 28, 40, 90, 50, 65, 105, 65, 80, 255, 100, 140, 255, 150, 180, 75, 35, 48, 255, 255, 255)
defineTheme("Ocean", 18, 48, 76, 10, 30, 50, 25, 58, 88, 15, 38, 60, 30, 68, 100, 20, 45, 70, 30, 68, 100, 22, 48, 74, 40, 80, 110, 55, 95, 125, 0, 180, 216, 72, 202, 228, 28, 55, 78, 255, 255, 255)
defineTheme("Mint", 225, 250, 242, 205, 238, 226, 235, 252, 247, 215, 242, 232, 248, 255, 252, 228, 245, 237, 248, 255, 252, 228, 245, 237, 200, 225, 212, 218, 238, 228, 0, 170, 120, 70, 210, 160, 230, 248, 240, 25, 60, 45)
defineTheme("Lavender", 235, 228, 255, 218, 208, 245, 242, 237, 255, 225, 216, 248, 250, 247, 255, 235, 228, 252, 250, 247, 255, 235, 228, 252, 215, 205, 240, 230, 220, 250, 130, 90, 230, 170, 140, 255, 238, 232, 255, 45, 30, 80)
defineTheme("Coral", 255, 240, 235, 250, 218, 210, 255, 245, 240, 250, 225, 218, 255, 250, 247, 250, 232, 226, 255, 250, 247, 250, 232, 226, 245, 215, 205, 255, 228, 220, 255, 95, 85, 255, 150, 130, 255, 240, 235, 80, 35, 28)
defineTheme("Slate", 45, 52, 65, 32, 38, 48, 52, 60, 74, 38, 44, 56, 60, 68, 82, 44, 50, 62, 60, 68, 82, 46, 52, 64, 70, 78, 92, 85, 93, 107, 100, 130, 170, 140, 170, 200, 55, 62, 75, 255, 255, 255)
defineTheme("Crimson", 65, 22, 28, 45, 14, 18, 75, 28, 34, 55, 18, 24, 85, 34, 40, 62, 22, 28, 85, 34, 40, 65, 24, 30, 95, 42, 48, 110, 55, 60, 220, 40, 55, 255, 90, 100, 78, 28, 34, 255, 255, 255)

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
	local settingsFolder = game.ReplicatedStorage:FindFirstChild("UILibSettings_" .. self.Config.Name)
	if not settingsFolder then
		settingsFolder = Instance.new("Folder")
		settingsFolder.Name = "UILibSettings_" .. self.Config.Name
		settingsFolder.Parent = game.ReplicatedStorage
	end
	for k, v in pairs(self.Settings) do
		settingsFolder:SetAttribute(k, v)
	end
end

function UILib:LoadSettings()
	if self.Config.SaveSettings == false then return end
	local settingsFolder = game.ReplicatedStorage:FindFirstChild("UILibSettings_" .. self.Config.Name)
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
	if minimizeBtn then minimizeBtn.BackgroundColor3 = theme.AccentGradTop end
	if closeBtn then closeBtn.BackgroundColor3 = Color3.fromRGB(255, 36, 0) end
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

-- Создание окна
function UILib:CreateWindow(config)
	config = config or {}
	local screenGui = createInstance("ScreenGui", {Name = config.Name or "UILib", Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"), ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
	local mainFrame = createInstance("Frame", {Name = "MainFrame", Size = config.Size or UDim2.new(0, 500, 0, 560), Position = config.Position or UDim2.new(0.5, -250, 0.5, -280), BackgroundColor3 = Color3.fromRGB(235, 240, 252), BorderSizePixel = 0, Parent = screenGui})
	applyCorner(mainFrame, 12)
	
	local topBar = createInstance("Frame", {Name = "TopBar", Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Color3.fromRGB(250, 252, 255), BorderSizePixel = 0, Parent = mainFrame})
	applyCorner(topBar, 12)
	createInstance("TextLabel", {Name = "Title", Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = config.Title or "UI", TextColor3 = Color3.fromRGB(40, 50, 70), Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = topBar})
	
	local minimizeButton = createInstance("TextButton", {Name = "MinimizeButton", Size = UDim2.new(0, 28, 0, 24), Position = UDim2.new(1, -64, 0.5, -12), BackgroundColor3 = Color3.fromRGB(59, 130, 255), BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(180, 192, 220), Text = "—", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Gotham, TextSize = 14, Parent = topBar})
	applyCorner(minimizeButton, 6)
	local closeButton = createInstance("TextButton", {Name = "CloseButton", Size = UDim2.new(0, 28, 0, 24), Position = UDim2.new(1, -32, 0.5, -12), BackgroundColor3 = Color3.fromRGB(255, 36, 0), BorderSizePixel = 1, BorderColor3 = Color3.fromRGB(180, 20, 0), Text = "X", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Gotham, TextSize = 14, Parent = topBar})
	applyCorner(closeButton, 6)
	
	local tabBar = createInstance("Frame", {Name = "TabBar", Size = UDim2.new(0, 140, 1, -32), Position = UDim2.new(0, 0, 0, 32), BackgroundColor3 = Color3.fromRGB(242, 246, 255), BorderSizePixel = 0, Parent = mainFrame})
	applyCorner(tabBar, 0)
	createInstance("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = tabBar})
	createInstance("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), Parent = tabBar})
	
	local contentContainer = createInstance("Frame", {Name = "ContentContainer", Size = UDim2.new(1, -140, 1, -32), Position = UDim2.new(0, 140, 0, 32), BackgroundColor3 = Color3.fromRGB(235, 240, 252), BorderSizePixel = 0, Parent = mainFrame})
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
	
	if config.Keybind then
		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == config.Keybind then
				mainFrame.Visible = not mainFrame.Visible
			end
		end)
	end
	
	return window
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
