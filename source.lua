-- UI Library Module
local UI = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Helper functions
local function addCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = parent
	return corner
end

local function addGradient(parent, color1, color2)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color1),
		ColorSequenceKeypoint.new(1, color2)
	})
	gradient.Rotation = 180
	gradient.Parent = parent
	return gradient
end

local function addPadding(parent, left, right, top, bottom)
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, left or 8)
	padding.PaddingRight = UDim.new(0, right or 8)
	padding.PaddingTop = UDim.new(0, top or 0)
	padding.PaddingBottom = UDim.new(0, bottom or 0)
	padding.Parent = parent
	return padding
end

-- Theme colors
local ThemeColors = {
	MainBg = Color3.fromRGB(235, 240, 252),
	ContainerBg = Color3.fromRGB(235, 240, 252),
	TabBarBg = Color3.fromRGB(242, 246, 255),
	TopBarBg = Color3.fromRGB(250, 252, 255),
	RowBg = Color3.fromRGB(240, 244, 255),
	ButtonBg = Color3.fromRGB(255, 255, 255),
	TextColor = Color3.fromRGB(40, 50, 70),
	ButtonTextColor = Color3.fromRGB(30, 40, 60),
	AccentColor = Color3.fromRGB(255, 193, 7),
	AccentBlue = Color3.fromRGB(59, 130, 255),
	SliderBarBg = Color3.fromRGB(225, 232, 245),
	SliderFillBg = Color3.fromRGB(255, 193, 7),
}

-- Window class
function UI:CreateWindow(config)
	config = config or {}
	local window = {}
	local tabs = {}
	local currentTab = nil
	local isMinimized = false

	-- Create ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = config.Title or "UILibrary"
	screenGui.Parent = CoreGui
	screenGui.ResetOnSpawn = false

	-- Main frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.fromOffset(560, 400)
	mainFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
	mainFrame.BackgroundColor3 = ThemeColors.MainBg
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui
	addCorner(mainFrame, 12)
	addGradient(mainFrame, Color3.fromRGB(245, 248, 255), Color3.fromRGB(228, 234, 250))

	-- Top bar
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 32)
	topBar.Position = UDim2.new(0, 0, 0, 0)
	topBar.BackgroundColor3 = ThemeColors.TopBarBg
	topBar.BorderSizePixel = 0
	topBar.Parent = mainFrame
	addGradient(topBar, Color3.fromRGB(255, 255, 255), Color3.fromRGB(244, 247, 255))

	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Text = config.Title or "Window"
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14
	titleLabel.TextColor3 = ThemeColors.TextColor
	titleLabel.Size = UDim2.new(1, -80, 1, 0)
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = topBar

	-- Close button
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Text = "X"
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 14
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.Size = UDim2.new(0, 28, 0, 24)
	closeButton.Position = UDim2.new(1, -32, 0.5, -12)
	closeButton.BackgroundColor3 = Color3.fromRGB(255, 36, 0)
	closeButton.BorderSizePixel = 0
	closeButton.Parent = topBar
	addCorner(closeButton, 12)

	-- Minimize button
	local minimizeButton = Instance.new("TextButton")
	minimizeButton.Name = "MinimizeButton"
	minimizeButton.Text = "—"
	minimizeButton.Font = Enum.Font.GothamBold
	minimizeButton.TextSize = 14
	minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	minimizeButton.Size = UDim2.new(0, 28, 0, 24)
	minimizeButton.Position = UDim2.new(1, -64, 0.5, -12)
	minimizeButton.BackgroundColor3 = ThemeColors.AccentColor
	minimizeButton.BorderSizePixel = 0
	minimizeButton.Parent = topBar
	addCorner(minimizeButton, 12)

	-- Tab bar
	local tabBar = Instance.new("Frame")
	tabBar.Name = "TabBar"
	tabBar.Size = UDim2.new(0, 140, 1, -32)
	tabBar.Position = UDim2.new(0, 0, 0, 32)
	tabBar.BackgroundColor3 = ThemeColors.TabBarBg
	tabBar.BorderSizePixel = 0
	tabBar.Parent = mainFrame
	addGradient(tabBar, Color3.fromRGB(248, 250, 255), Color3.fromRGB(235, 240, 252))

	local tabBarLayout = Instance.new("UIListLayout")
	tabBarLayout.Padding = UDim.new(0, 5)
	tabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabBarLayout.FillDirection = Enum.FillDirection.Vertical
	tabBarLayout.Parent = tabBar

	local tabBarPadding = Instance.new("UIPadding")
	tabBarPadding.PaddingTop = UDim.new(0, 20)
	tabBarPadding.PaddingLeft = UDim.new(0, 12)
	tabBarPadding.PaddingRight = UDim.new(0, 12)
	tabBarPadding.Parent = tabBar

	-- Content container
	local contentContainer = Instance.new("Frame")
	contentContainer.Name = "ContentContainer"
	contentContainer.Size = UDim2.new(1, -140, 1, -32)
	contentContainer.Position = UDim2.new(0, 140, 0, 32)
	contentContainer.BackgroundColor3 = ThemeColors.ContainerBg
	contentContainer.BorderSizePixel = 0
	contentContainer.Parent = mainFrame
	addGradient(contentContainer, Color3.fromRGB(245, 248, 255), Color3.fromRGB(228, 234, 250))

	-- Add tab method
	function window:AddTab(config)
		config = config or {}
		local tab = {}
		local elements = {}

		-- Tab button
		local tabButton = Instance.new("TextButton")
		tabButton.Name = "TabButton"
		tabButton.Text = config.Title or "Tab"
		tabButton.Font = Enum.Font.GothamMedium
		tabButton.TextSize = 14
		tabButton.TextColor3 = ThemeColors.ButtonTextColor
		tabButton.Size = UDim2.new(1, 0, 0, 33)
		tabButton.BackgroundColor3 = ThemeColors.ButtonBg
		tabButton.BorderSizePixel = 0
		tabButton.LayoutOrder = #tabs + 1
		tabButton.Parent = tabBar
		addCorner(tabButton, 8)

		-- Tab page
		local tabPage = Instance.new("ScrollingFrame")
		tabPage.Name = "TabPage"
		tabPage.Size = UDim2.new(1, 0, 1, 0)
		tabPage.BackgroundTransparency = 1
		tabPage.BorderSizePixel = 0
		tabPage.Visible = false
		tabPage.ScrollingDirection = Enum.ScrollingDirection.Y
		tabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
		tabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
		tabPage.ScrollBarThickness = 3
		tabPage.Parent = contentContainer

		local tabPageLayout = Instance.new("UIListLayout")
		tabPageLayout.Padding = UDim.new(0, 5)
		tabPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		tabPageLayout.Parent = tabPage

		local tabPagePadding = Instance.new("UIPadding")
		tabPagePadding.PaddingTop = UDim.new(0, 10)
		tabPagePadding.PaddingBottom = UDim.new(0, 20)
		tabPagePadding.PaddingLeft = UDim.new(0, 20)
		tabPagePadding.PaddingRight = UDim.new(0, 20)
		tabPagePadding.Parent = tabPage

		-- Switch to this tab
		tabButton.MouseButton1Click:Connect(function()
			for _, t in ipairs(tabs) do
				t.page.Visible = false
				t.button.BackgroundColor3 = ThemeColors.ButtonBg
			end
			tabPage.Visible = true
			tabButton.BackgroundColor3 = ThemeColors.AccentColor
			tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			currentTab = tab
		end)

		-- Add toggle method
		function tab:AddToggle(config)
			config = config or {}
			local toggle = {
				Value = false,
			}

			local row = Instance.new("Frame")
			row.Name = "ToggleRow"
			row.Size = UDim2.new(1, 0, 0, 50)
			row.BackgroundColor3 = ThemeColors.RowBg
			row.BorderSizePixel = 0
			row.LayoutOrder = #elements + 1
			row.Parent = tabPage
			addCorner(row, 8)
			addGradient(row, Color3.fromRGB(255, 255, 255), Color3.fromRGB(244, 247, 255))

			local label = Instance.new("TextLabel")
			label.Text = config.Title or "Toggle"
			label.Font = Enum.Font.GothamMedium
			label.TextSize = 14
			label.TextColor3 = ThemeColors.TextColor
			label.Size = UDim2.new(0, 100, 1, 0)
			label.BackgroundTransparency = 1
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = row

			local toggleButton = Instance.new("TextButton")
			toggleButton.Text = ""
			toggleButton.Size = UDim2.new(0, 44, 0, 22)
			toggleButton.Position = UDim2.new(1, -54, 0.5, -11)
			toggleButton.BackgroundColor3 = ThemeColors.SliderBarBg
			toggleButton.BorderSizePixel = 0
			toggleButton.Parent = row
			addCorner(toggleButton, 11)

			local toggleGradient = Instance.new("UIGradient")
			toggleGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 220, 240)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 238, 250))
			})
			toggleGradient.Rotation = 180
			toggleGradient.Parent = toggleButton

			local knob = Instance.new("Frame")
			knob.Size = UDim2.new(0, 18, 0, 18)
			knob.Position = UDim2.new(0, 2, 0.5, 0)
			knob.AnchorPoint = Vector2.new(0, 0.5)
			knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			knob.BorderSizePixel = 0
			knob.Parent = toggleButton
			addCorner(knob, 9)

			toggleButton.MouseButton1Click:Connect(function()
				toggle.Value = not toggle.Value
				local targetPos = toggle.Value and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
				local knobTween = TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos})
				knobTween:Play()
				if toggle.Value then
					toggleGradient.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 193, 7)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 220, 100))
					})
				else
					toggleGradient.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 220, 240)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 238, 250))
					})
				end
				if config.Callback then
					config.Callback(toggle.Value)
				end
			end)

			table.insert(elements, row)
			return toggle
		end

		-- Add slider method
		function tab:AddSlider(config)
			config = config or {}
			local slider = {
				Value = config.Default or 50,
			}

			local row = Instance.new("Frame")
			row.Name = "SliderRow"
			row.Size = UDim2.new(1, 0, 0, 50)
			row.BackgroundColor3 = ThemeColors.RowBg
			row.BorderSizePixel = 0
			row.LayoutOrder = #elements + 1
			row.Parent = tabPage
			addCorner(row, 8)
			addGradient(row, Color3.fromRGB(255, 255, 255), Color3.fromRGB(244, 247, 255))

			local label = Instance.new("TextLabel")
			label.Text = config.Title or "Slider"
			label.Font = Enum.Font.GothamMedium
			label.TextSize = 14
			label.TextColor3 = ThemeColors.TextColor
			label.Size = UDim2.new(0, 100, 1, 0)
			label.BackgroundTransparency = 1
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = row

			local valueLabel = Instance.new("TextLabel")
			valueLabel.Text = tostring(slider.Value) .. "%"
			valueLabel.Font = Enum.Font.Gotham
			valueLabel.TextSize = 14
			valueLabel.TextColor3 = ThemeColors.TextColor
			valueLabel.Size = UDim2.new(0, 40, 1, 0)
			valueLabel.Position = UDim2.new(1, -50, 0, 0)
			valueLabel.BackgroundTransparency = 1
			valueLabel.TextXAlignment = Enum.TextXAlignment.Right
			valueLabel.Parent = row

			local sliderBar = Instance.new("Frame")
			sliderBar.Size = UDim2.new(1, -150, 0, 10)
			sliderBar.Position = UDim2.new(0, 105, 0.5, -5)
			sliderBar.BackgroundColor3 = ThemeColors.SliderBarBg
			sliderBar.BorderSizePixel = 0
			sliderBar.Parent = row
			addCorner(sliderBar, 5)

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new(slider.Value / 100, 0, 1, 0)
			fill.BackgroundColor3 = ThemeColors.SliderFillBg
			fill.BorderSizePixel = 0
			fill.Parent = sliderBar
			addCorner(fill, 5)

			sliderBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local function update(inputPos)
						local relX = (inputPos.Position.X - sliderBar.AbsolutePosition.X) / math.max(sliderBar.AbsoluteSize.X, 1)
						relX = math.clamp(relX, 0, 1)
						slider.Value = math.floor(relX * 100 + 0.5)
						fill.Size = UDim2.new(relX, 0, 1, 0)
						valueLabel.Text = tostring(slider.Value) .. "%"
					end
					update(input)
					local conn
					conn = UserInputService.InputChanged:Connect(function(changed)
						if changed.UserInputType == Enum.UserInputType.MouseMovement then
							update(changed)
						end
					end)
					UserInputService.InputEnded:Connect(function(endInput)
						if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
							conn:Disconnect()
							if config.Callback then
								config.Callback(slider.Value)
							end
						end
					end)
				end
			end)

			table.insert(elements, row)
			return slider
		end

		-- Add dropdown method
		function tab:AddDropdown(config)
			config = config or {}
			local dropdown = {
				Value = nil,
			}

			local row = Instance.new("Frame")
			row.Name = "DropdownRow"
			row.Size = UDim2.new(1, 0, 0, 50)
			row.BackgroundColor3 = ThemeColors.RowBg
			row.BorderSizePixel = 0
			row.LayoutOrder = #elements + 1
			row.Parent = tabPage
			addCorner(row, 8)
			addGradient(row, Color3.fromRGB(255, 255, 255), Color3.fromRGB(244, 247, 255))

			local label = Instance.new("TextLabel")
			label.Text = config.Title or "Dropdown"
			label.Font = Enum.Font.GothamMedium
			label.TextSize = 14
			label.TextColor3 = ThemeColors.TextColor
			label.Size = UDim2.new(0, 100, 1, 0)
			label.BackgroundTransparency = 1
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = row

			local button = Instance.new("TextButton")
			button.Text = config.Placeholder or "Select..."
			button.Font = Enum.Font.GothamMedium
			button.TextSize = 14
			button.TextColor3 = ThemeColors.ButtonTextColor
			button.Size = UDim2.new(1, -110, 0, 30)
			button.Position = UDim2.new(0, 105, 0.5, -15)
			button.BackgroundColor3 = ThemeColors.ButtonBg
			button.BorderSizePixel = 0
			button.TextXAlignment = Enum.TextXAlignment.Left
			button.Parent = row
			addCorner(button, 8)
			addPadding(button, 8, 8)

			local isOpen = false
			local dropdownGui = nil

			button.MouseButton1Click:Connect(function()
				if isOpen then
					if dropdownGui then dropdownGui:Destroy() end
					isOpen = false
					return
				end
				isOpen = true

				dropdownGui = Instance.new("ScreenGui")
				dropdownGui.Parent = screenGui
				dropdownGui.DisplayOrder = 100

				local listFrame = Instance.new("Frame")
				listFrame.Size = UDim2.fromOffset(button.AbsoluteSize.X, 0)
				listFrame.Position = UDim2.fromOffset(button.AbsolutePosition.X, button.AbsolutePosition.Y + button.AbsoluteSize.Y + 4)
				listFrame.BackgroundColor3 = ThemeColors.ButtonBg
				listFrame.BorderSizePixel = 0
				listFrame.ClipsDescendants = true
				listFrame.Parent = dropdownGui
				addCorner(listFrame, 8)

				local scroll = Instance.new("ScrollingFrame")
				scroll.Size = UDim2.new(1, -8, 0, 170)
				scroll.Position = UDim2.new(0, 4, 0, 4)
				scroll.BackgroundTransparency = 1
				scroll.BorderSizePixel = 0
				scroll.ScrollingDirection = Enum.ScrollingDirection.Y
				scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
				scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
				scroll.ScrollBarThickness = 3
				scroll.Parent = listFrame

				local layout = Instance.new("UIListLayout")
				layout.Padding = UDim.new(0, 4)
				layout.Parent = scroll

				for i, option in ipairs(config.Options or {}) do
					local optButton = Instance.new("TextButton")
					optButton.Text = option
					optButton.Font = Enum.Font.GothamMedium
					optButton.TextSize = 14
					optButton.TextColor3 = ThemeColors.ButtonTextColor
					optButton.Size = UDim2.new(1, 0, 0, 30)
					optButton.BackgroundColor3 = ThemeColors.ButtonBg
					optButton.BorderSizePixel = 0
					optButton.TextXAlignment = Enum.TextXAlignment.Left
					optButton.LayoutOrder = i
					optButton.Parent = scroll
					addCorner(optButton, 8)
					addPadding(optButton, 8, 8)

					optButton.MouseButton1Click:Connect(function()
						button.Text = option
						dropdown.Value = option
						if dropdownGui then dropdownGui:Destroy() end
						isOpen = false
						if config.Callback then
							config.Callback(option)
						end
					end)
				end

				local targetHeight = math.min(#(config.Options or {}) * 34 + 8, 178)
				local openTween = TweenService:Create(listFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(button.AbsoluteSize.X, targetHeight)})
				openTween:Play()
			end)

			table.insert(elements, row)
			return dropdown
		end

		table.insert(tabs, {button = tabButton, page = tabPage, tab = tab})
		
		-- Show first tab
		if #tabs == 1 then
			tabPage.Visible = true
			tabButton.BackgroundColor3 = ThemeColors.AccentColor
			tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			currentTab = tab
		end

		return tab
	end

	-- Close button
	closeButton.MouseButton1Click:Connect(function()
		screenGui:Destroy()
	end)

	-- Minimize button
	minimizeButton.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		if isMinimized then
			mainFrame.Size = UDim2.fromOffset(560, 32)
		else
			mainFrame.Size = UDim2.fromOffset(560, 400)
		end
	end)

	-- Dragging
	local dragging = false
	local dragStart = nil
	local frameStart = nil

	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			frameStart = mainFrame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	-- Keybind to toggle
	if config.MinimizeKey then
		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if not gameProcessed and input.KeyCode == config.MinimizeKey then
				mainFrame.Visible = not mainFrame.Visible
			end
		end)
	end

	return window
end

return UI	local CoreGui = game:GetService("CoreGui")

	if CoreGui:FindFirstChild("UI") then
		CoreGui["UI"]:Destroy()
		warn("Previous ScreenGui Destroyed!")
	end


	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "UI"
	ScreenGui.Parent = CoreGui
	ScreenGui.ResetOnSpawn = false

	local TweenService = game:GetService("TweenService")

	-- FUNCTIONS --

	local function addCorner(parentInstance, topLeft, topRight, bottomLeft, bottomRight)
		local corner = Instance.new("UICorner")
		local function toUDim(val)
			if type(val) == "table" then
				return UDim.new(val[1] or 0, val[2] or 0) 
			elseif type(val) == "number" then
				return UDim.new(0, val) 
			end
			return UDim.new(0, 0)
		end

		corner.TopLeftRadius = toUDim(topLeft)
		corner.TopRightRadius = toUDim(topRight)
		corner.BottomLeftRadius = toUDim(bottomLeft)
		corner.BottomRightRadius = toUDim(bottomRight)

		corner.Parent = parentInstance
		return corner
	end



	local function addGradient(parentInstance, color1, color2, rotation, offset)
		local gradient = Instance.new("UIGradient")

		local c1 = color1 or Color3.fromRGB(245, 248, 255)
		local c2 = color2 or Color3.fromRGB(225, 232, 250)
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, c1),
			ColorSequenceKeypoint.new(1, c2)
		})

		gradient.Rotation = rotation or 180

		gradient.Offset = offset or Vector2.new(0, 0)

		gradient.Parent = parentInstance
		return gradient
	end

	local function addLayout(parentInstance, listPadding, top, bottom, left, right, fillDirection, verticalAlign)
		local function toUDim(val)
			if type(val) == "table" then
				return UDim.new(val[1] or 0, val[2] or 0)
			elseif type(val) == "number" then
				return UDim.new(0, val)
			end
			return UDim.new(0, 0)
		end

		local list = nil
		if listPadding then
			list = Instance.new("UIListLayout")
			list.Padding = toUDim(listPadding)
			list.SortOrder = Enum.SortOrder.LayoutOrder

			-- Выставляем направление списка
			if fillDirection == "vertical" then
				list.FillDirection = Enum.FillDirection.Vertical
			else
				list.FillDirection = Enum.FillDirection.Horizontal
			end

			-- Настройка вертикального выравнивания по строке (Center, Top, Bottom)
			if verticalAlign == "Center" then
				list.VerticalAlignment = Enum.VerticalAlignment.Center
			elseif verticalAlign == "Bottom" then
				list.VerticalAlignment = Enum.VerticalAlignment.Bottom
			else
				list.VerticalAlignment = Enum.VerticalAlignment.Top
			end

			list.Parent = parentInstance
		end

		local padding = nil
		if top or bottom or left or right then
			padding = Instance.new("UIPadding")
			padding.PaddingTop = toUDim(top)
			padding.PaddingBottom = toUDim(bottom)
			padding.PaddingLeft = toUDim(left)
			padding.PaddingRight = toUDim(right)
			padding.Parent = parentInstance
		end

		return list, padding 
	end



	-- FRAMES --

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.fromOffset(560, 400)
	MainFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
	MainFrame.BackgroundColor3 = Color3.fromRGB(235, 240, 252) -- Чисто белый под градиент
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui
	MainFrame.ClipsDescendants = true

	local MinimizedBar = Instance.new("Frame")
	MinimizedBar.Name = "MinimizedBar"
	MinimizedBar.Size = UDim2.fromOffset(560, 32)
	MinimizedBar.Position = MainFrame.Position
	MinimizedBar.BackgroundColor3 = Color3.fromRGB(235, 240, 252)
	MinimizedBar.BorderSizePixel = 0
	MinimizedBar.Visible = false
	MinimizedBar.Parent = ScreenGui

	local ContentFrame = Instance.new("Frame")
	ContentFrame.Name = "ContentFrame"
	ContentFrame.Size = UDim2.new(1, -140, 1, -32)
	ContentFrame.Position = UDim2.new(0, 140, 0, 36)
	ContentFrame.BackgroundColor3 = Color3.fromRGB(235, 240, 252)
	ContentFrame.BorderSizePixel = 0
	ContentFrame.Parent = MainFrame

	local TabBarFrame = Instance.new("Frame")
	TabBarFrame.Name = "TabBar"
	TabBarFrame.Size = UDim2.new(-0.036, 140, 1.028, -32)
	TabBarFrame.Position = UDim2.new(0, 0, 0, 21)
	TabBarFrame.BackgroundColor3 = Color3.fromRGB(242, 246, 255)
	TabBarFrame.BorderSizePixel = 0
	TabBarFrame.Parent = MainFrame

	local TopBarFrame = Instance.new("Frame")
	TopBarFrame.Name = "TopBar"
	TopBarFrame.Size = UDim2.new(1, 0, 0, 32)
	TopBarFrame.Position = UDim2.new(0, 0, 0, 0)
	TopBarFrame.BackgroundColor3 = Color3.fromRGB(250, 252, 255)
	TopBarFrame.BorderSizePixel = 0
	TopBarFrame.Parent = MainFrame

	-- SCROLLING FRAMES -- 

	local SettingsContainer = Instance.new("ScrollingFrame")
	SettingsContainer.Name = "SettingsContainer"
	SettingsContainer.Size = UDim2.new(1, 0, 1, 0)
	SettingsContainer.Position = UDim2.new(0, 0, 0, 0)
	SettingsContainer.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
	SettingsContainer.BackgroundTransparency = 1
	SettingsContainer.BorderSizePixel = 0
	SettingsContainer.Parent = ContentFrame

	-- BUTTONS --

	local CloseButton = Instance.new("TextButton")
	CloseButton.Name = "CloseButton"
	CloseButton.Text = "X"
	CloseButton.Font = "Montserrat"
	CloseButton.TextSize = 14
	CloseButton.TextColor = BrickColor.new(255, 255, 255)
	CloseButton.Size = UDim2.new(0, 28, 0, 24)
	CloseButton.Position = UDim2.new(1, -32, 0.5, -12)
	CloseButton.BackgroundColor3 = Color3.fromRGB(255, 36, 0)
	CloseButton.BorderSizePixel = 0
	CloseButton.Parent = TopBarFrame

	local MinimizeButton = Instance.new("TextButton")
	MinimizeButton.Name = "MinimizeButton"
	MinimizeButton.Text = "—"
	MinimizeButton.Font = "Montserrat"
	MinimizeButton.TextSize = 14
	MinimizeButton.TextColor = BrickColor.new(255, 255, 255)
	MinimizeButton.Size = UDim2.new(0, 28, 0, 24)
	MinimizeButton.Position = UDim2.new(1, -64, 0.5, -12)
	MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
	MinimizeButton.BorderSizePixel = 0
	MinimizeButton.Parent = TopBarFrame

	local MinimizedCloseButton = CloseButton:Clone()
	MinimizedCloseButton.Name = "MinimizedCloseButton"
	MinimizedCloseButton.Parent = MinimizedBar

	local MinimizedRestoreButton = MinimizeButton:Clone()
	MinimizedRestoreButton.Name = "MinimizedRestoreButton"
	MinimizedRestoreButton.Parent = MinimizedBar


	-- TextLabels --

	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Text = "BGS Auto Hatch v2.9"
	Title.Font = "Montserrat"
	Title.TextSize = 14
	Title.TextColor3 = Color3.fromRGB(40, 50, 70)
	Title.Size = UDim2.new(1, -80, 1, 0)
	Title.Position = UDim2.new(0, 12, 0, 0)
	Title.BackgroundTransparency = 1
	Title.BorderSizePixel = 0
	Title.Parent = TopBarFrame
	Title.TextXAlignment = "Left"

	-- TABS SETTINGS --

	-- TABS --

	local MainTabFrame = Instance.new("Frame")
	MainTabFrame.Name = "MainTabFrame"
	MainTabFrame.Size = UDim2.new(0, 94, 0, 33)
	MainTabFrame.Position = UDim2.new(0, 0, 0, 0)
	MainTabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MainTabFrame.BackgroundTransparency = 1
	MainTabFrame.BorderSizePixel = 0
	MainTabFrame.Parent = TabBarFrame

	local MainTabButton = Instance.new("TextButton")
	MainTabButton.Name = "MainTab"
	MainTabButton.Text = "Main"
	MainTabButton.Font = "Montserrat"
	MainTabButton.TextSize = 14
	MainTabButton.TextColor3 = Color3.fromRGB(30, 40, 60)
	MainTabButton.Size = UDim2.new(1, 0, 1, 0)
	MainTabButton.Position = UDim2.new(0, 0, 0, 0)
	MainTabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MainTabButton.BorderSizePixel = 0
	MainTabButton.Parent = MainTabFrame


	local SettingsTabFrame = Instance.new("Frame")
	SettingsTabFrame.Name = "SettingsTabFrame"
	SettingsTabFrame.Size = UDim2.new(0, 94, 0, 33)
	SettingsTabFrame.Position = UDim2.new(0, 0, 0, 0)
	SettingsTabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SettingsTabFrame.BackgroundTransparency = 1
	SettingsTabFrame.BorderSizePixel = 0
	SettingsTabFrame.Parent = TabBarFrame


	local SettingsTabButton = Instance.new("TextButton")
	SettingsTabButton.Name = "SettingsTab"
	SettingsTabButton.Text = "Settings"
	SettingsTabButton.Font = "Montserrat"
	SettingsTabButton.TextSize = 14
	SettingsTabButton.TextColor3 = Color3.fromRGB(30, 40, 60)
	SettingsTabButton.Size = UDim2.new(1, 0, 1, 0)
	SettingsTabButton.Position = UDim2.new(0, 0, 0, 0)
	SettingsTabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SettingsTabButton.BorderSizePixel = 0
	SettingsTabButton.Parent = SettingsTabFrame


	local ConfigTitle = Instance.new("TextButton")
	ConfigTitle.Text = "Configs managment     ▼"
	ConfigTitle.Name = "1ConfigsTitle"
	ConfigTitle.Font = "Montserrat"
	ConfigTitle.TextSize = 14
	ConfigTitle.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold)
	ConfigTitle.TextColor3 = Color3.fromRGB(40, 50, 70)
	ConfigTitle.Size = UDim2.new(1, 0, 0, 30)
	ConfigTitle.Position = UDim2.new(0, 0, 0, 0)
	ConfigTitle.BackgroundTransparency = 1
	ConfigTitle.BorderSizePixel = 0
	ConfigTitle.TextXAlignment = "Left"
	ConfigTitle.AutoButtonColor = false
	ConfigTitle.Parent = SettingsContainer

	-- ROWS -- 

	local ConfigRow = Instance.new("Frame")
	ConfigRow.Name = "2ConfigRow"
	ConfigRow.Size = UDim2.new(1, 0, 0, 50)
	ConfigRow.Position = UDim2.new(0, 0, 0, 0)
	ConfigRow.BackgroundColor3 = Color3.fromRGB(240, 244, 255)
	ConfigRow.BorderSizePixel = 0
	ConfigRow.Parent = SettingsContainer

	local ConfigManagerButtonsRow = Instance.new("Frame")
	ConfigManagerButtonsRow.Name = "ConfigManagerButtonsRow"
	ConfigManagerButtonsRow.Size = UDim2.new(1, 0, 0, 50)
	ConfigManagerButtonsRow.Position = UDim2.new(0, 0, 0, 0)
	ConfigManagerButtonsRow.BackgroundColor3 = Color3.fromRGB(240, 244, 255)
	ConfigManagerButtonsRow.BorderSizePixel = 0
	ConfigManagerButtonsRow.Parent = SettingsContainer

	local LoadButton = Instance.new("TextButton")
	LoadButton.Name = "LoadButton"
	LoadButton.Text = "Load"
	LoadButton.Font = "Montserrat"
	LoadButton.TextSize = 14
	LoadButton.TextColor3 = Color3.fromRGB(40, 50, 70)
	LoadButton.Size = UDim2.new(0, 60, 0, 30)
	LoadButton.Position = UDim2.new(1, -64, 0.5, -12)
	LoadButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LoadButton.BorderSizePixel = 0
	LoadButton.TextXAlignment = "Center"
	LoadButton.Parent = ConfigManagerButtonsRow

	local SaveButton = Instance.new("TextButton")
	SaveButton.Name = "SaveButton"
	SaveButton.Text = "Save"
	SaveButton.Font = "Montserrat"
	SaveButton.TextSize = 14
	SaveButton.TextColor3 = Color3.fromRGB(40, 50, 70)
	SaveButton.Size = UDim2.new(0, 60, 0, 30)
	SaveButton.Position = UDim2.new(1, -64, 0.5, -12)
	SaveButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SaveButton.BorderSizePixel = 0
	SaveButton.TextXAlignment = "Center"
	SaveButton.Parent = ConfigManagerButtonsRow

	local DeleteButton = Instance.new("TextButton")
	DeleteButton.Name = "DeleteButton"
	DeleteButton.Text = "Delete config"
	DeleteButton.Font = "Montserrat"
	DeleteButton.TextSize = 14
	DeleteButton.TextColor3 = Color3.fromRGB(40, 50, 70)
	DeleteButton.Size = UDim2.new(0, 100, 0, 30)
	DeleteButton.Position = UDim2.new(1, -64, 0.5, -12)
	DeleteButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DeleteButton.BorderSizePixel = 0
	DeleteButton.TextXAlignment = "Center"
	DeleteButton.Parent = ConfigManagerButtonsRow

	local AutoLoadButton = Instance.new("TextButton")
	AutoLoadButton.Name = "AutoLoadButton"
	AutoLoadButton.Text = "Set as autoload"
	AutoLoadButton.Font = "Montserrat"
	AutoLoadButton.TextSize = 14
	AutoLoadButton.TextColor3 = Color3.fromRGB(40, 50, 70)
	AutoLoadButton.Size = UDim2.new(0, 130, 0, 30)
	AutoLoadButton.Position = UDim2.new(1, -64, 0.5, -12)
	AutoLoadButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AutoLoadButton.BorderSizePixel = 0
	AutoLoadButton.TextXAlignment = "Center"
	AutoLoadButton.Parent = ConfigManagerButtonsRow

	local ThemeRow = Instance.new("Frame")
	ThemeRow.Name = "3ThemeRow"
	ThemeRow.Size = UDim2.new(1, 0, 0, 50)
	ThemeRow.Position = UDim2.new(0, 0, 0, 0)
	ThemeRow.BackgroundColor3 = Color3.fromRGB(240, 244, 255)
	ThemeRow.BorderSizePixel = 0
	ThemeRow.Parent = SettingsContainer

	local ThemeLabel = Instance.new("TextLabel")
	ThemeLabel.Text = "Themes"
	ThemeLabel.Name = "1ThemeLabel"
	ThemeLabel.Font = "Montserrat"
	ThemeLabel.TextSize = 14
	ThemeLabel.TextColor3 = Color3.fromRGB(40, 50, 70)
	ThemeLabel.Size = UDim2.new(-0.019, 100, 1, 0)
	ThemeLabel.Position = UDim2.new(0, 0, 0, 0)
	ThemeLabel.BackgroundTransparency = 1
	ThemeLabel.BorderSizePixel = 0
	ThemeLabel.TextXAlignment = "Left"
	ThemeLabel.Parent = ThemeRow

	local ThemeDropdown = Instance.new("TextButton")
	ThemeDropdown.Name = "2ThemeDropdown"
	ThemeDropdown.Text = "Default"
	ThemeDropdown.Font = "Montserrat"
	ThemeDropdown.TextSize = 14
    ThemeDropdown.TextColor3 = Color3.fromRGB(40, 50, 70)
	ThemeDropdown.Size = UDim2.new(1, -100, 0, 30)
	ThemeDropdown.Position = UDim2.new(1, -64, 0.5, -12)
	ThemeDropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ThemeDropdown.BorderSizePixel = 0
	ThemeDropdown.TextXAlignment = "Left"
	ThemeDropdown.Parent = ThemeRow

	local MenyKeyRow = Instance.new("Frame")
	MenyKeyRow.Name = "4MenyKeyRow"
	MenyKeyRow.Size = UDim2.new(1, 0, 0, 50)
	MenyKeyRow.Position = UDim2.new(0, 0, 0, 0)
	MenyKeyRow.BackgroundColor3 = Color3.fromRGB(240, 244, 255)
	MenyKeyRow.BorderSizePixel = 0
	MenyKeyRow.Parent = SettingsContainer

	local MenuKeybindLabel = Instance.new("TextLabel")
	MenuKeybindLabel.Text = "Menu key"
	MenuKeybindLabel.Name = "7MenuKeybindLabel"
	MenuKeybindLabel.Font = "Montserrat"
	MenuKeybindLabel.TextSize = 14
	MenuKeybindLabel.TextColor3 = Color3.fromRGB(40, 50, 70)
	MenuKeybindLabel.Size = UDim2.new(-0.019, 100, 1, 0)
	MenuKeybindLabel.Position = UDim2.new(0, 0, 0, 0)
	MenuKeybindLabel.BackgroundTransparency = 1
	MenuKeybindLabel.BorderSizePixel = 0
	MenuKeybindLabel.TextXAlignment = "Left"
	MenuKeybindLabel.Parent = MenyKeyRow

	local MenuKeyBind = Instance.new("TextButton")
	MenuKeyBind.Name = "5MenuKeyBind"
	MenuKeyBind.Text = "L"
	MenuKeyBind.Font = "Montserrat"
	MenuKeyBind.TextSize = 14
	MenuKeyBind.TextColor3 = Color3.fromRGB(40, 50, 70)
	MenuKeyBind.Size = UDim2.new(0, 60,0, 30)
	MenuKeyBind.Position = UDim2.new(0, 0, 0, 0)
	MenuKeyBind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MenuKeyBind.BorderSizePixel = 0
	MenuKeyBind.TextXAlignment = "Center"
	MenuKeyBind.Parent = MenyKeyRow

	-- Toggle Row
	local ToggleRow = Instance.new("Frame")
	ToggleRow.Name = "7ToggleRow"
	ToggleRow.Size = UDim2.new(1, 0, 0, 50)
	ToggleRow.Position = UDim2.new(0, 0, 0, 0)
	ToggleRow.BackgroundColor3 = Color3.fromRGB(240, 244, 255)
	ToggleRow.BorderSizePixel = 0
	ToggleRow.Parent = SettingsContainer

	local ToggleLabel = Instance.new("TextLabel")
	ToggleLabel.Text = "Test Toggle"
	ToggleLabel.Name = "1ToggleLabel"
	ToggleLabel.Font = "Montserrat"
	ToggleLabel.TextSize = 14
	ToggleLabel.TextColor3 = Color3.fromRGB(40, 50, 70)
	ToggleLabel.Size = UDim2.new(-0.019, 100, 1, 0)
	ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
	ToggleLabel.BackgroundTransparency = 1
	ToggleLabel.BorderSizePixel = 0
	ToggleLabel.TextXAlignment = "Left"
	ToggleLabel.Parent = ToggleRow

	local ToggleButton = Instance.new("TextButton")
	ToggleButton.Name = "2ToggleButton"
	ToggleButton.Text = ""
	ToggleButton.Font = "Montserrat"
	ToggleButton.TextSize = 14
	ToggleButton.Size = UDim2.new(0, 44, 0, 22)
	ToggleButton.Position = UDim2.new(1, -64, 0.5, -11)
	ToggleButton.BackgroundColor3 = Color3.fromRGB(225, 232, 245)
	ToggleButton.BorderSizePixel = 0
	ToggleButton.Parent = ToggleRow

	local toggleButtonGradient = Instance.new("UIGradient")
	toggleButtonGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 220, 240)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 238, 250))
	})
	toggleButtonGradient.Rotation = 180
	toggleButtonGradient.Parent = ToggleButton

	local toggleKnob = Instance.new("Frame")
	toggleKnob.Name = "ToggleKnob"
	toggleKnob.Size = UDim2.new(0, 18, 0, 18)
	toggleKnob.Position = UDim2.new(0, 2, 0.5, 0)
	toggleKnob.AnchorPoint = Vector2.new(0, 0.5)
	toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	toggleKnob.BorderSizePixel = 0
	toggleKnob.Parent = ToggleButton

	local toggleKnobCorner = Instance.new("UICorner")
	toggleKnobCorner.CornerRadius = UDim.new(1, 0)
	toggleKnobCorner.Parent = toggleKnob

	local toggleButtonCorner = Instance.new("UICorner")
	toggleButtonCorner.CornerRadius = UDim.new(1, 0)
	toggleButtonCorner.Parent = ToggleButton

	-- Options Title
	local OptionsTitle = Instance.new("TextButton")
	OptionsTitle.Text = "Options     ▼"
	OptionsTitle.Name = "6OptionsTitle"
	OptionsTitle.Font = "Montserrat"
	OptionsTitle.TextSize = 14
	OptionsTitle.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold)
	OptionsTitle.TextColor3 = Color3.fromRGB(40, 50, 70)
	OptionsTitle.Size = UDim2.new(1, 0, 0, 30)
	OptionsTitle.Position = UDim2.new(0, 0, 0, 0)
	OptionsTitle.BackgroundTransparency = 1
	OptionsTitle.BorderSizePixel = 0
	OptionsTitle.TextXAlignment = "Left"
	OptionsTitle.AutoButtonColor = false
	OptionsTitle.Parent = SettingsContainer

	-- Multi Dropdown Row
	local MultiDropdownRow = Instance.new("Frame")
	MultiDropdownRow.Name = "6MultiDropdownRow"
	MultiDropdownRow.Size = UDim2.new(1, 0, 0, 50)
	MultiDropdownRow.Position = UDim2.new(0, 0, 0, 0)
	MultiDropdownRow.BackgroundColor3 = Color3.fromRGB(240, 244, 255)
	MultiDropdownRow.BorderSizePixel = 0
	MultiDropdownRow.Parent = SettingsContainer

	local MultiDropdownLabel = Instance.new("TextLabel")
	MultiDropdownLabel.Text = "Multi Select"
	MultiDropdownLabel.Name = "1MultiDropdownLabel"
	MultiDropdownLabel.Font = "Montserrat"
	MultiDropdownLabel.TextSize = 14
	MultiDropdownLabel.TextColor3 = Color3.fromRGB(40, 50, 70)
	MultiDropdownLabel.Size = UDim2.new(-0.019, 100, 1, 0)
	MultiDropdownLabel.Position = UDim2.new(0, 0, 0, 0)
	MultiDropdownLabel.BackgroundTransparency = 1
	MultiDropdownLabel.BorderSizePixel = 0
	MultiDropdownLabel.TextXAlignment = "Left"
	MultiDropdownLabel.Parent = MultiDropdownRow

	local MultiDropdownButton = Instance.new("TextButton")
	MultiDropdownButton.Name = "2MultiDropdownButton"
	MultiDropdownButton.Text = "Select..."
	MultiDropdownButton.Font = "Montserrat"
	MultiDropdownButton.TextSize = 14
	MultiDropdownButton.TextColor3 = Color3.fromRGB(40, 50, 70)
	MultiDropdownButton.Size = UDim2.new(1, -100, 0, 30)
	MultiDropdownButton.Position = UDim2.new(1, -64, 0.5, -12)
	MultiDropdownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MultiDropdownButton.BorderSizePixel = 0
	MultiDropdownButton.TextXAlignment = "Left"
	MultiDropdownButton.Parent = MultiDropdownRow

	local multiDropdownPadding = Instance.new("UIPadding")
	multiDropdownPadding.PaddingLeft = UDim.new(0, 8)
	multiDropdownPadding.PaddingRight = UDim.new(0, 8)
	multiDropdownPadding.Parent = MultiDropdownButton

	-- Menu Transparency Slider Row
	local MenuTransparencyRow = Instance.new("Frame")
	MenuTransparencyRow.Name = "5MenuTransparencyRow"
	MenuTransparencyRow.Size = UDim2.new(1, 0, 0, 50)
	MenuTransparencyRow.Position = UDim2.new(0, 0, 0, 0)
	MenuTransparencyRow.BackgroundColor3 = Color3.fromRGB(240, 244, 255)
	MenuTransparencyRow.BorderSizePixel = 0
	MenuTransparencyRow.Parent = SettingsContainer

	local MenuTransparencyLabel = Instance.new("TextLabel")
	MenuTransparencyLabel.Text = "Menu Transparency"
	MenuTransparencyLabel.Name = "1MenuTransparencyLabel"
	MenuTransparencyLabel.Font = "Montserrat"
	MenuTransparencyLabel.TextSize = 12
	MenuTransparencyLabel.TextColor3 = Color3.fromRGB(40, 50, 70)
	MenuTransparencyLabel.Size = UDim2.new(0, 120, 1, 0)
	MenuTransparencyLabel.Position = UDim2.new(0, 0, 0, 0)
	MenuTransparencyLabel.BackgroundTransparency = 1
	MenuTransparencyLabel.BorderSizePixel = 0
	MenuTransparencyLabel.TextXAlignment = "Left"
	MenuTransparencyLabel.TextTruncate = Enum.TextTruncate.AtEnd
	MenuTransparencyLabel.Parent = MenuTransparencyRow

	local MenuTransparencyBar = Instance.new("Frame")
	MenuTransparencyBar.Name = "2MenuTransparencyBar"
	MenuTransparencyBar.Size = UDim2.new(1, -210, 0, 10)
	MenuTransparencyBar.BackgroundColor3 = Color3.fromRGB(225, 232, 245)
	MenuTransparencyBar.BorderSizePixel = 0
	MenuTransparencyBar.Parent = MenuTransparencyRow

	local MenuTransparencyFill = Instance.new("Frame")
	MenuTransparencyFill.Name = "MenuTransparencyFill"
	MenuTransparencyFill.Size = UDim2.new(1, 0, 1, 0)
	MenuTransparencyFill.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
	MenuTransparencyFill.BorderSizePixel = 0
	MenuTransparencyFill.Parent = MenuTransparencyBar

	local MenuTransparencyKnob = Instance.new("Frame")
	MenuTransparencyKnob.Name = "MenuTransparencyKnob"
	MenuTransparencyKnob.Size = UDim2.new(0, 14, 0, 14)
	MenuTransparencyKnob.Position = UDim2.new(1, -7, 0.5, 0)
	MenuTransparencyKnob.AnchorPoint = Vector2.new(0.5, 0.5)
	MenuTransparencyKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MenuTransparencyKnob.BorderSizePixel = 0
	MenuTransparencyKnob.Parent = MenuTransparencyBar

	local MenuTransparencyValue = Instance.new("TextLabel")
	MenuTransparencyValue.Text = "100%"
	MenuTransparencyValue.Name = "3MenuTransparencyValue"
	MenuTransparencyValue.Font = "Montserrat"
	MenuTransparencyValue.TextSize = 14
	MenuTransparencyValue.TextColor3 = Color3.fromRGB(40, 50, 70)
	MenuTransparencyValue.Size = UDim2.new(0, 40, 1, 0)
	MenuTransparencyValue.BackgroundTransparency = 1
	MenuTransparencyValue.BorderSizePixel = 0
	MenuTransparencyValue.TextXAlignment = "Right"
	MenuTransparencyValue.Parent = MenuTransparencyRow

	-- TEXTBOX -- 

	local ConfigLabel = Instance.new("TextLabel")
	ConfigLabel.Text = "Config"
	ConfigLabel.Name = "1ConfigLabel"
	ConfigLabel.Font = "Montserrat"
	ConfigLabel.TextSize = 14
	ConfigLabel.TextColor3 = Color3.fromRGB(40, 50, 70)
	ConfigLabel.Size = UDim2.new(-0.019, 100, 1, 0)
	ConfigLabel.Position = UDim2.new(0, 0, 0, 0)
	ConfigLabel.BackgroundTransparency = 1
	ConfigLabel.BorderSizePixel = 0
	ConfigLabel.TextXAlignment = "Left"
	ConfigLabel.Parent = ConfigRow


	local ConfigTextbox = Instance.new("TextBox")
	ConfigTextbox.Name = "ConfigTextbox"
	ConfigTextbox.Size = UDim2.new(1, -100, 0, 30)
	ConfigTextbox.Position = UDim2.new(0, 0, 0, 0)
	ConfigTextbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConfigTextbox.Text = "Enter config name..."
	ConfigTextbox.PlaceholderText = "Enter config name..."
	ConfigTextbox.TextXAlignment = "Left"
	ConfigTextbox.ClipsDescendants = true
	ConfigTextbox.Parent = ConfigRow


	-- CORNERS --

	addCorner(MainFrame, 12, 12, 12, 12)
	addCorner(MinimizedBar, 12, 12, 12, 12)
	addCorner(MinimizedCloseButton, {1, 0}, {1, 0}, {1, 0}, {1, 0})
	addCorner(MinimizedRestoreButton, {1, 0}, {1, 0}, {1, 0}, {1, 0})
	addCorner(ContentFrame, 12, 12, 12, 12)
	addCorner(TabBarFrame, 12, 12, 0, 0)
	addCorner(TopBarFrame, {0.25, 0}, {0.25, 0}, {0.25, 0}, {0.25, 0})
	addCorner(CloseButton, {1, 0}, {1, 0}, {1, 0}, {1, 0})
	addCorner(MinimizeButton, {1, 0}, {1, 0}, {1, 0}, {1, 0})
	addCorner(SettingsTabButton, {0, 0}, {0, 0}, {0, 8}, {0, 8})
	addCorner(MainTabButton, {0, 8}, {0, 8}, {0, 0}, {0, 0})
	addCorner(ConfigRow, {0, 8}, {0, 8}, {0, 8}, {0, 8})
	addCorner(ConfigManagerButtonsRow, {0, 8}, {0, 8}, {0, 8}, {0, 8})
	addCorner(ThemeRow, {0, 8}, {0, 8}, {0, 8}, {0, 8})
	addCorner(MenyKeyRow, {0, 8}, {0, 8}, {0, 8}, {0, 8})
	addCorner(MenuTransparencyRow, {0, 8}, {0, 8}, {0, 8}, {0, 8})
	addCorner(MultiDropdownRow, {0, 8}, {0, 8}, {0, 8}, {0, 8})
	addCorner(ToggleRow, {0, 8}, {0, 8}, {0, 8}, {0, 8})
	addCorner(MultiDropdownButton, {0, 8}, {0, 8}, {0, 8}, {0, 8})
	addCorner(MenuTransparencyBar, {0, 5}, {0, 5}, {0, 5}, {0, 5})
	addCorner(MenuTransparencyFill, {0, 5}, {0, 5}, {0, 5}, {0, 5})
	addCorner(MenuTransparencyKnob, {0, 7}, {0, 7}, {0, 7}, {0, 7})
	addCorner(ConfigTextbox, {0, 8}, {0, 8}, {0, 8}, {0, 8})
    addCorner(ThemeDropdown, {0, 8}, {0, 8}, {0, 8}, {0, 8})
	addCorner(MenuKeyBind, {0, 8}, {0, 8}, {0, 8}, {0, 8})
	addCorner(SaveButton, {0, 8}, {0, 8}, {0, 8}, {0, 8})
	addCorner(LoadButton, {0, 8}, {0, 8}, {0, 8}, {0, 8})
	addCorner(DeleteButton, {0, 8}, {0, 8}, {0, 8}, {0, 8})
	addCorner(AutoLoadButton, {0, 8}, {0, 8}, {0, 8}, {0, 8})
	-- GRADIENTS --

	addGradient(MainFrame, Color3.fromRGB(245, 248, 255), Color3.fromRGB(228, 234, 250), 180, Vector2.new(0, 0))
	addGradient(ContentFrame, Color3.fromRGB(245, 248, 255), Color3.fromRGB(228, 234, 250), 180, Vector2.new(0, 0))
	addGradient(TabBarFrame, Color3.fromRGB(248, 250, 255), Color3.fromRGB(235, 240, 252), 180, Vector2.new(0, 0))
	addGradient(TopBarFrame, Color3.fromRGB(255, 255, 255), Color3.fromRGB(244, 247, 255), 180, Vector2.new(0, 0))
	addGradient(ConfigRow, Color3.fromRGB(255, 255, 255), Color3.fromRGB(244, 247, 255), 180, Vector2.new(0, 0))
	addGradient(ConfigManagerButtonsRow, Color3.fromRGB(255, 255, 255), Color3.fromRGB(244, 247, 255), 180, Vector2.new(0, 0))
	addGradient(ThemeRow, Color3.fromRGB(255, 255, 255), Color3.fromRGB(244, 247, 255), 180, Vector2.new(0, 0))
	addGradient(MenyKeyRow, Color3.fromRGB(255, 255, 255), Color3.fromRGB(244, 247, 255), 180, Vector2.new(0, 0))
	addGradient(MenuTransparencyRow, Color3.fromRGB(255, 255, 255), Color3.fromRGB(244, 247, 255), 180, Vector2.new(0, 0))
	addGradient(MultiDropdownRow, Color3.fromRGB(255, 255, 255), Color3.fromRGB(244, 247, 255), 180, Vector2.new(0, 0))
	addGradient(ToggleRow, Color3.fromRGB(255, 255, 255), Color3.fromRGB(244, 247, 255), 180, Vector2.new(0, 0))
	addGradient(MenuTransparencyBar, Color3.fromRGB(210, 220, 240), Color3.fromRGB(230, 238, 250), 180, Vector2.new(0, 0))
	addGradient(MenuTransparencyFill, Color3.fromRGB(255, 193, 7), Color3.fromRGB(255, 220, 100), 180, Vector2.new(0, 0))
	addGradient(MenuTransparencyKnob, Color3.fromRGB(255, 255, 255), Color3.fromRGB(220, 230, 250), 180, Vector2.new(0, 0))
	-- PADDING --

	local padding1 = Instance.new("UIPadding")
	padding1.PaddingTop = UDim.new(0, 0)
	padding1.PaddingBottom = UDim.new(0, 0)
	padding1.PaddingLeft = UDim.new(0, 8)
	padding1.PaddingRight = UDim.new(0, 8)
	padding1.Parent = ConfigTextbox

	local padding2 = Instance.new("UIPadding")
	padding2.PaddingTop = UDim.new(0, 0)
	padding2.PaddingBottom = UDim.new(0, 0)
	padding2.PaddingLeft = UDim.new(0, 8)
	padding2.PaddingRight = UDim.new(0, 8)
	padding2.Parent = ThemeDropdown

	local padding3 = Instance.new("UIPadding")
	padding3.PaddingTop = UDim.new(0, 0)
	padding3.PaddingBottom = UDim.new(0, 0)
	padding3.PaddingLeft = UDim.new(0, 8)
	padding3.PaddingRight = UDim.new(0, 8)
	padding3.Parent = LoadButton

	local padding4 = Instance.new("UIPadding")
	padding4.PaddingTop = UDim.new(0, 0)
	padding4.PaddingBottom = UDim.new(0, 0)
	padding4.PaddingLeft = UDim.new(0, 8)
	padding4.PaddingRight = UDim.new(0, 8)
	padding4.Parent = SaveButton

	local padding5 = Instance.new("UIPadding")
	padding5.PaddingTop = UDim.new(0, 0)
	padding5.PaddingBottom = UDim.new(0, 0)
	padding5.PaddingLeft = UDim.new(0, 8)
	padding5.PaddingRight = UDim.new(0, 8)
	padding5.Parent = DeleteButton

	local padding6 = Instance.new("UIPadding")
	padding6.PaddingTop = UDim.new(0, 0)
	padding6.PaddingBottom = UDim.new(0, 0)
	padding6.PaddingLeft = UDim.new(0, 8)
	padding6.PaddingRight = UDim.new(0, 8)
	padding6.Parent = AutoLoadButton
	
	-- LAYOUTS --

	addLayout(TabBarFrame, 5, 20, 10, 12, 10, "vertical", "Top") 
	addLayout(SettingsContainer, 5, 10, 20, 0, 20, "vertical", "Top") 
	addLayout(ConfigRow, 10, 0, 0, 10, 10, "horizontal", "Center")
	addLayout(ConfigManagerButtonsRow, 10, 0, 0, 10, 10, "horizontal", "Center")
	addLayout(ThemeRow, 10, 0, 0, 10, 10, "horizontal", "Center")
	addLayout(MenyKeyRow, 10, 0, 0, 10, 10, "horizontal", "Center")
	addLayout(MenuTransparencyRow, 10, 0, 0, 10, 10, "horizontal", "Center")
	addLayout(MultiDropdownRow, 10, 0, 0, 10, 10, "horizontal", "Center")
	addLayout(ToggleRow, 10, 0, 0, 10, 10, "horizontal", "Center")

	local MenuTransparencyRowPadding = Instance.new("UIPadding")
	MenuTransparencyRowPadding.PaddingRight = UDim.new(0, 10)
	MenuTransparencyRowPadding.Parent = MenuTransparencyRow

	-- DRAG LOGIC --

	local UserInputService = game:GetService("UserInputService")
	local dragging = false
	local dragStartPos = nil
	local frameStartPos = nil
	local velocity = Vector2.new(0, 0)
	local lastInputPos = nil
	local lastInputTime = 0
	local slideTween

	TopBarFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStartPos = input.Position
			if isMinimized then
				frameStartPos = MinimizedBar.Position
			else
				frameStartPos = MainFrame.Position
			end
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local now = tick()
			if lastInputPos and lastInputTime > 0 then
				local dt = now - lastInputTime
				if dt > 0 then
					velocity = (input.Position - lastInputPos) / dt
				end
			end
			lastInputPos = input.Position
			lastInputTime = now

			local delta = input.Position - dragStartPos
			local newPos = UDim2.new(
				frameStartPos.X.Scale,
				frameStartPos.X.Offset + delta.X,
				frameStartPos.Y.Scale,
				frameStartPos.Y.Offset + delta.Y
			)
			if isMinimized then
				MinimizedBar.Position = newPos
			else
				MainFrame.Position = newPos
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false

			local speed = velocity.Magnitude
			if speed > 50 then
				local targetFrame = if isMinimized then MinimizedBar else MainFrame
				local currentPos = targetFrame.Position
				local slideDistance = math.clamp(speed * 0.12, 20, 180)
				local direction = velocity.Unit
				local targetPos = UDim2.new(
					currentPos.X.Scale,
					currentPos.X.Offset + direction.X * slideDistance,
					currentPos.Y.Scale,
					currentPos.Y.Offset + direction.Y * slideDistance
				)

				if slideTween then slideTween:Cancel() end
				slideTween = TweenService:Create(
					targetFrame,
					TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{Position = targetPos}
				)
				slideTween:Play()
			end

			velocity = Vector2.new(0, 0)
			lastInputPos = nil
			lastInputTime = 0
		end
	end)

	-- MINIMIZE LOGIC --

	local isMinimized = false
	local minimizeTween, restoreTween

	local function restoreButtonState()
		Title.Parent = TopBarFrame
		MinimizeButton.Parent = TopBarFrame
		CloseButton.Parent = TopBarFrame
		MinimizedBar.Visible = false
	end

	local function applyMinimizedState()
		MinimizedBar.Position = MainFrame.Position
		MinimizedBar.Visible = true
		Title.Parent = MinimizedBar
		MinimizeButton.Parent = MinimizedBar
		CloseButton.Parent = MinimizedBar
		MainFrame.Visible = false
	end

	local function minimize()
		if minimizeTween then minimizeTween:Cancel() end
		if restoreTween then restoreTween:Cancel() end

		minimizeTween = TweenService:Create(
			MainFrame,
			TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
			{Size = UDim2.fromOffset(560, 32), Position = UDim2.new(0.5, -280, 0.5, -16)}
		)
		minimizeTween:Play()
		minimizeTween.Completed:Connect(function()
			if minimizeTween then minimizeTween = nil end
			applyMinimizedState()
		end)
	end

	local function restore()
		if restoreTween then restoreTween:Cancel() end
		if minimizeTween then minimizeTween:Cancel() end

		restoreButtonState()
		MainFrame.Size = UDim2.fromOffset(560, 32)
		MainFrame.Position = UDim2.new(0.5, -280, 0.5, -16)
		MainFrame.Visible = true

		restoreTween = TweenService:Create(
			MainFrame,
			TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
			{Size = UDim2.fromOffset(560, 400), Position = UDim2.new(0.5, -280, 0.5, -200)}
		)
		restoreTween:Play()
		restoreTween.Completed:Connect(function()
			if restoreTween then restoreTween = nil end
			MainFrame.Size = UDim2.fromOffset(560, 400)
			MainFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
		end)
	end

	MinimizeButton.MouseButton1Click:Connect(function()
		if isMinimized then
			isMinimized = false
			restore()
		else
			isMinimized = true
			minimize()
		end
	end)

	local function printButton(buttonName)
		print("[UI] Button pressed: " .. buttonName)
	end

	local function bindButton(button, buttonName)
		button.MouseButton1Click:Connect(function()
			printButton(buttonName)
		end)
	end

	bindButton(MainTabButton, "MainTab")
	bindButton(SettingsTabButton, "SettingsTab")
	bindButton(LoadButton, "LoadButton")
	bindButton(SaveButton, "SaveButton")
	bindButton(DeleteButton, "DeleteButton")
	bindButton(AutoLoadButton, "AutoLoadButton")

	-- Theme Dropdown Logic
	local isThemeDropdownOpen = false
	local themeDropdownGui = nil
local themeOptions = {"Light", "Dark", "Forest", "Honey", "Moonlight", "Strawberry", "Ocean", "Desert", "Frost", "Matcha", "Mint", "Vanilla", "Coffee", "Sunset", "Midnight", "Aurora", "Lavender", "Amber", "Cyber"}
	local favoriteThemes = {}
	local favoriteOrder = {}

	local function closeThemeDropdown(fast)
		if not themeDropdownGui then
			isThemeDropdownOpen = false
			return
		end
		isThemeDropdownOpen = false

		local guiToDestroy = themeDropdownGui
		themeDropdownGui = nil

		local listFrame = guiToDestroy:FindFirstChildOfClass("Frame")
		if listFrame then
			local duration = fast and 0.15 or 0.25
			local closeTween = TweenService:Create(
				listFrame,
				TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{Size = UDim2.fromOffset(listFrame.AbsoluteSize.X, 0)}
			)
			closeTween:Play()
			closeTween.Completed:Connect(function()
				guiToDestroy:Destroy()
			end)
		else
			guiToDestroy:Destroy()
		end
	end

	local function renderThemeOptions(listFrame, searchText)
		-- Clear existing option containers (keep search box)
		for _, child in ipairs(listFrame:GetChildren()) do
			if child:IsA("Frame") and child.Name == "OptionContainer" then
				child:Destroy()
			end
		end

		local sortedOptions = {}
		-- Add favorites first (newest first)
		for i = #favoriteOrder, 1, -1 do
			local opt = favoriteOrder[i]
			if favoriteThemes[opt] then
				table.insert(sortedOptions, opt)
			end
		end
		-- Add non-favorites
		for _, opt in ipairs(themeOptions) do
			if not favoriteThemes[opt] then
				table.insert(sortedOptions, opt)
			end
		end

		local searchLower = searchText and searchText:lower() or ""
		local filteredOptions = {}
		for _, opt in ipairs(sortedOptions) do
			if searchLower == "" or string.find(opt:lower(), searchLower, 1, true) then
				table.insert(filteredOptions, opt)
			end
		end

		local layoutOrder = 2 -- Search box is layout order 1
		for _, option in ipairs(filteredOptions) do
			local optionContainer = Instance.new("Frame")
			optionContainer.Name = "OptionContainer"
			optionContainer.Size = UDim2.new(1, 0, 0, 30)
			optionContainer.Position = UDim2.new(0, 0, 0, 0)
			optionContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			optionContainer.BorderSizePixel = 0
			optionContainer.LayoutOrder = layoutOrder
			optionContainer.Parent = listFrame
			layoutOrder = layoutOrder + 1

			-- Option button (full width)
			local optionButton = Instance.new("TextButton")
			optionButton.Name = "OptionButton"
			optionButton.Text = option
			optionButton.Font = "Montserrat"
			optionButton.TextSize = 14
			optionButton.TextColor3 = favoriteThemes[option] and Color3.fromRGB(255, 193, 7) or Color3.fromRGB(40, 50, 70)
			optionButton.Size = UDim2.new(1, 0, 1, 0)
			optionButton.Position = UDim2.new(0, 0, 0, 0)
			optionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			optionButton.BorderSizePixel = 0
			optionButton.TextXAlignment = "Left"
			optionButton.Parent = optionContainer

			local optionButtonCorner = Instance.new("UICorner")
			optionButtonCorner.CornerRadius = UDim.new(0, 8)
			optionButtonCorner.Parent = optionButton

			local optionPadding = Instance.new("UIPadding")
			optionPadding.PaddingLeft = UDim.new(0, 8)
			optionPadding.Parent = optionButton

			optionButton.MouseButton1Click:Connect(function()
				ThemeDropdown.Text = option
				print("[UI] Theme selected: " .. option)
				closeThemeDropdown(true)
			end)

			optionButton.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton3 then
					favoriteThemes[option] = not favoriteThemes[option]
					if favoriteThemes[option] then
						for i = #favoriteOrder, 1, -1 do
							if favoriteOrder[i] == option then
								table.remove(favoriteOrder, i)
							end
						end
						table.insert(favoriteOrder, option)
					else
						for i = #favoriteOrder, 1, -1 do
							if favoriteOrder[i] == option then
								table.remove(favoriteOrder, i)
							end
						end
					end
					renderThemeOptions(listFrame, searchText)
				end
			end)

			-- Hover effect
			optionButton.MouseEnter:Connect(function()
				optionContainer.BackgroundColor3 = Color3.fromRGB(240, 244, 255)
				optionButton.BackgroundColor3 = Color3.fromRGB(240, 244, 255)
			end)
			optionButton.MouseLeave:Connect(function()
				optionContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				optionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			end)
		end
	end

	local function openThemeDropdown()
		if isThemeDropdownOpen then
			closeThemeDropdown(true)
			return
		end

		if themeDropdownGui then
			themeDropdownGui:Destroy()
			themeDropdownGui = nil
		end

		isThemeDropdownOpen = true

		-- Create dropdown as child of ScreenGui, positioned relative to ThemeDropdown
		themeDropdownGui = Instance.new("ScreenGui")
		themeDropdownGui.Name = "ThemeDropdownList"
		themeDropdownGui.Parent = ScreenGui
		themeDropdownGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		themeDropdownGui.DisplayOrder = 100

		local listFrame = Instance.new("Frame")
		listFrame.Name = "ListFrame"
		listFrame.Size = UDim2.fromOffset(ThemeDropdown.AbsoluteSize.X, 0)
		listFrame.Position = UDim2.fromOffset(ThemeDropdown.AbsolutePosition.X, ThemeDropdown.AbsolutePosition.Y + ThemeDropdown.AbsoluteSize.Y + 4)
		listFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		listFrame.BorderSizePixel = 0
		listFrame.ClipsDescendants = true
		listFrame.Parent = themeDropdownGui

		local listCorner = Instance.new("UICorner")
		listCorner.CornerRadius = UDim.new(0, 8)
		listCorner.Parent = listFrame

		-- Search box (fixed)
		local searchBox = Instance.new("TextBox")
		searchBox.Name = "SearchBox"
		searchBox.PlaceholderText = "Type to search"
		searchBox.Text = "Tap to search"
		searchBox.Font = "Montserrat"
		searchBox.TextSize = 13
		searchBox.TextColor3 = Color3.fromRGB(40, 50, 70)
		searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
		searchBox.Size = UDim2.new(1, -8, 0, 28)
		searchBox.Position = UDim2.new(0, 4, 0, 4)
		searchBox.BackgroundColor3 = Color3.fromRGB(240, 244, 255)
		searchBox.BorderSizePixel = 0
		searchBox.TextXAlignment = "Left"
		searchBox.Parent = listFrame

		local searchCorner = Instance.new("UICorner")
		searchCorner.CornerRadius = UDim.new(0, 4)
		searchCorner.Parent = searchBox

		local searchPadding = Instance.new("UIPadding")
		searchPadding.PaddingLeft = UDim.new(0, 8)
		searchPadding.Parent = searchBox

		-- Scrollable options
		local optionsScroll = Instance.new("ScrollingFrame")
		optionsScroll.Name = "OptionsScroll"
		optionsScroll.Size = UDim2.new(1, -8, 0, 170)
		optionsScroll.Position = UDim2.new(0, 4, 0, 36)
		optionsScroll.BackgroundTransparency = 1
		optionsScroll.BorderSizePixel = 0
		optionsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
		optionsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
		optionsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
		optionsScroll.ScrollBarThickness = 3
		optionsScroll.Parent = listFrame

		local optionsLayout = Instance.new("UIListLayout")
		optionsLayout.Padding = UDim.new(0, 4)
		optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
		optionsLayout.Parent = optionsScroll

		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			renderThemeOptions(optionsScroll, searchBox.Text)
		end)

		-- Hint label
		local hintLabel = Instance.new("TextLabel")
		hintLabel.Name = "HintLabel"
		hintLabel.Text = "Middle click to Favorite!"
		hintLabel.Font = "Montserrat"
		hintLabel.TextSize = 10
		hintLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		hintLabel.Size = UDim2.new(1, -8, 0, 14)
		hintLabel.Position = UDim2.new(0, 4, 0, 36 + 170 + 2)
		hintLabel.BackgroundTransparency = 1
		hintLabel.BorderSizePixel = 0
		hintLabel.TextXAlignment = "Center"
		hintLabel.Parent = listFrame

		renderThemeOptions(optionsScroll, "")

		local targetHeight = 36 + 170 + 8 + 16
		local openTween = TweenService:Create(
			listFrame,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Size = UDim2.fromOffset(ThemeDropdown.AbsoluteSize.X, targetHeight)}
		)
		openTween:Play()
	end

	ThemeDropdown.MouseButton1Click:Connect(function()
		openThemeDropdown()
	end)

	-- Close dropdown when clicking elsewhere
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not isThemeDropdownOpen then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not themeDropdownGui then return end
			local listFrame = themeDropdownGui:FindFirstChildOfClass("Frame")
			if listFrame then
				local mousePos = input.Position
				local guiPos = listFrame.AbsolutePosition
				local guiSize = listFrame.AbsoluteSize
				local themeBtnPos = ThemeDropdown.AbsolutePosition
				local themeBtnSize = ThemeDropdown.AbsoluteSize
				
				local inDropdown = mousePos.X >= guiPos.X and mousePos.X <= guiPos.X + guiSize.X and mousePos.Y >= guiPos.Y and mousePos.Y <= guiPos.Y + guiSize.Y
				local onThemeButton = mousePos.X >= themeBtnPos.X and mousePos.X <= themeBtnPos.X + themeBtnSize.X and mousePos.Y >= themeBtnPos.Y and mousePos.Y <= themeBtnPos.Y + themeBtnSize.Y
				
				if not inDropdown and not onThemeButton then
					closeThemeDropdown(true)
				end
			end
		end
	end)

	-- Update dropdown position when scrolling
	SettingsContainer:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		if isThemeDropdownOpen and themeDropdownGui then
			local listFrame = themeDropdownGui:FindFirstChildOfClass("Frame")
			if listFrame then
				local newY = ThemeDropdown.AbsolutePosition.Y + ThemeDropdown.AbsoluteSize.Y + 4
				local dropdownHeight = listFrame.AbsoluteSize.Y
				local mainFrameTop = MainFrame.AbsolutePosition.Y
				local mainFrameBottom = MainFrame.AbsolutePosition.Y + MainFrame.AbsoluteSize.Y
				
				-- If ThemeDropdown goes above MainFrame (scrolled too far up), close
				if ThemeDropdown.AbsolutePosition.Y < mainFrameTop then
					closeThemeDropdown(true)
				-- If dropdown would go below MainFrame, close
				elseif newY + dropdownHeight > mainFrameBottom then
					closeThemeDropdown(true)
				else
					listFrame.Position = UDim2.fromOffset(ThemeDropdown.AbsolutePosition.X, newY)
				end
			end
		end
	end)

	-- Prevent dropdown from closing when scrolling with mouse wheel over it
	local optionsScroll = nil
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseWheel and isThemeDropdownOpen and themeDropdownGui then
			local listFrame = themeDropdownGui:FindFirstChildOfClass("Frame")
			if listFrame then
				local mousePos = input.Position
				local guiPos = listFrame.AbsolutePosition
				local guiSize = listFrame.AbsoluteSize
				if mousePos.X >= guiPos.X and mousePos.X <= guiPos.X + guiSize.X and mousePos.Y >= guiPos.Y and mousePos.Y <= guiPos.Y + guiSize.Y then
					-- Mouse is over dropdown, don't close
					return
				end
			end
		end
	end)

	-- Multi Dropdown Logic
	local isMultiDropdownOpen = false
	local multiDropdownGui = nil
	local multiOptions = {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10"}
	local selectedMultiOptions = {}

	local function closeMultiDropdown(fast)
		if not multiDropdownGui then
			isMultiDropdownOpen = false
			return
		end
		isMultiDropdownOpen = false

		local guiToDestroy = multiDropdownGui
		multiDropdownGui = nil

		local listFrame = guiToDestroy:FindFirstChildOfClass("Frame")
		if listFrame then
			local duration = fast and 0.15 or 0.25
			local closeTween = TweenService:Create(
				listFrame,
				TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{Size = UDim2.fromOffset(listFrame.AbsoluteSize.X, 0)}
			)
			closeTween:Play()
			closeTween.Completed:Connect(function()
				guiToDestroy:Destroy()
			end)
		else
			guiToDestroy:Destroy()
		end
	end

	local function updateMultiDropdownText()
		local selected = {}
		for _, opt in ipairs(multiOptions) do
			if selectedMultiOptions[opt] then
				table.insert(selected, opt)
			end
		end
		if #selected == 0 then
			MultiDropdownButton.Text = "Select..."
		elseif #selected <= 2 then
			MultiDropdownButton.Text = table.concat(selected, ", ")
		else
			MultiDropdownButton.Text = #selected .. " selected"
		end
	end

	local function renderMultiOptions(optionsScroll, searchText)
		for _, child in ipairs(optionsScroll:GetChildren()) do
			if child:IsA("Frame") and child.Name == "MultiOptionContainer" then
				child:Destroy()
			end
		end

		local searchLower = searchText and searchText:lower() or ""
		local filteredOptions = {}
		for _, opt in ipairs(multiOptions) do
			if searchLower == "" or string.find(opt:lower(), searchLower, 1, true) then
				table.insert(filteredOptions, opt)
			end
		end

		for i, option in ipairs(filteredOptions) do
			local optionContainer = Instance.new("Frame")
			optionContainer.Name = "MultiOptionContainer"
			optionContainer.Size = UDim2.new(1, 0, 0, 30)
			optionContainer.Position = UDim2.new(0, 0, 0, 0)
			optionContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			optionContainer.BorderSizePixel = 0
			optionContainer.LayoutOrder = i
			optionContainer.Parent = optionsScroll

			local optionButton = Instance.new("TextButton")
			optionButton.Name = "MultiOptionButton"
			optionButton.Text = option
			optionButton.Font = "Montserrat"
			optionButton.TextSize = 14
			optionButton.TextColor3 = selectedMultiOptions[option] and Color3.fromRGB(255, 193, 7) or Color3.fromRGB(40, 50, 70)
			optionButton.Size = UDim2.new(1, 0, 1, 0)
			optionButton.Position = UDim2.new(0, 0, 0, 0)
			optionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			optionButton.BorderSizePixel = 0
			optionButton.TextXAlignment = "Left"
			optionButton.Parent = optionContainer

			local optionButtonCorner = Instance.new("UICorner")
			optionButtonCorner.CornerRadius = UDim.new(0, 8)
			optionButtonCorner.Parent = optionButton

			local optionPadding = Instance.new("UIPadding")
			optionPadding.PaddingLeft = UDim.new(0, 8)
			optionPadding.Parent = optionButton

			optionButton.MouseButton1Click:Connect(function()
				selectedMultiOptions[option] = not selectedMultiOptions[option]
				optionButton.TextColor3 = selectedMultiOptions[option] and Color3.fromRGB(255, 193, 7) or Color3.fromRGB(40, 50, 70)
				updateMultiDropdownText()
				print("[UI] Multi Select: " .. option .. " = " .. tostring(selectedMultiOptions[option]))
			end)

			optionButton.MouseEnter:Connect(function()
				optionContainer.BackgroundColor3 = Color3.fromRGB(240, 244, 255)
				optionButton.BackgroundColor3 = Color3.fromRGB(240, 244, 255)
			end)
			optionButton.MouseLeave:Connect(function()
				optionContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				optionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			end)
		end
	end

	local function openMultiDropdown()
		if isMultiDropdownOpen then
			closeMultiDropdown(true)
			return
		end

		if multiDropdownGui then
			multiDropdownGui:Destroy()
			multiDropdownGui = nil
		end

		isMultiDropdownOpen = true

		multiDropdownGui = Instance.new("ScreenGui")
		multiDropdownGui.Name = "MultiDropdownList"
		multiDropdownGui.Parent = ScreenGui
		multiDropdownGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		multiDropdownGui.DisplayOrder = 100

		local listFrame = Instance.new("Frame")
		listFrame.Name = "MultiListFrame"
		listFrame.Size = UDim2.fromOffset(MultiDropdownButton.AbsoluteSize.X, 0)
		listFrame.Position = UDim2.fromOffset(MultiDropdownButton.AbsolutePosition.X, MultiDropdownButton.AbsolutePosition.Y + MultiDropdownButton.AbsoluteSize.Y + 4)
		listFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		listFrame.BorderSizePixel = 0
		listFrame.ClipsDescendants = true
		listFrame.Parent = multiDropdownGui

		local listCorner = Instance.new("UICorner")
		listCorner.CornerRadius = UDim.new(0, 8)
		listCorner.Parent = listFrame

		-- Search box
		local searchBox = Instance.new("TextBox")
		searchBox.Name = "MultiSearchBox"
		searchBox.PlaceholderText = "Type to search"
		searchBox.Text = "Tap to search"
		searchBox.Font = "Montserrat"
		searchBox.TextSize = 13
		searchBox.TextColor3 = Color3.fromRGB(40, 50, 70)
		searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
		searchBox.Size = UDim2.new(1, -8, 0, 28)
		searchBox.Position = UDim2.new(0, 4, 0, 4)
		searchBox.BackgroundColor3 = Color3.fromRGB(240, 244, 255)
		searchBox.BorderSizePixel = 0
		searchBox.TextXAlignment = "Left"
		searchBox.Parent = listFrame

		local searchCorner = Instance.new("UICorner")
		searchCorner.CornerRadius = UDim.new(0, 4)
		searchCorner.Parent = searchBox

		local searchPadding = Instance.new("UIPadding")
		searchPadding.PaddingLeft = UDim.new(0, 8)
		searchPadding.Parent = searchBox

		-- Scrollable options
		local optionsScroll = Instance.new("ScrollingFrame")
		optionsScroll.Name = "MultiOptionsScroll"
		optionsScroll.Size = UDim2.new(1, -8, 0, 170)
		optionsScroll.Position = UDim2.new(0, 4, 0, 36)
		optionsScroll.BackgroundTransparency = 1
		optionsScroll.BorderSizePixel = 0
		optionsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
		optionsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
		optionsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
		optionsScroll.ScrollBarThickness = 3
		optionsScroll.Parent = listFrame

		local optionsLayout = Instance.new("UIListLayout")
		optionsLayout.Padding = UDim.new(0, 4)
		optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
		optionsLayout.Parent = optionsScroll

		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			renderMultiOptions(optionsScroll, searchBox.Text)
		end)

		renderMultiOptions(optionsScroll, "")

		local targetHeight = 36 + 170 + 8
		local openTween = TweenService:Create(
			listFrame,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Size = UDim2.fromOffset(MultiDropdownButton.AbsoluteSize.X, targetHeight)}
		)
		openTween:Play()
	end

	MultiDropdownButton.MouseButton1Click:Connect(function()
		openMultiDropdown()
	end)

	-- Close multi dropdown when clicking elsewhere
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not isMultiDropdownOpen then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not multiDropdownGui then return end
			local listFrame = multiDropdownGui:FindFirstChildOfClass("Frame")
			if listFrame then
				local mousePos = input.Position
				local guiPos = listFrame.AbsolutePosition
				local guiSize = listFrame.AbsoluteSize
				local btnPos = MultiDropdownButton.AbsolutePosition
				local btnSize = MultiDropdownButton.AbsoluteSize
				
				local inDropdown = mousePos.X >= guiPos.X and mousePos.X <= guiPos.X + guiSize.X and mousePos.Y >= guiPos.Y and mousePos.Y <= guiPos.Y + guiSize.Y
				local onButton = mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + btnSize.X and mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + btnSize.Y
				
				if not inDropdown and not onButton then
					closeMultiDropdown(true)
				end
			end
		end
	end)

	-- Update multi dropdown position when scrolling
	SettingsContainer:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		if isMultiDropdownOpen and multiDropdownGui then
			local listFrame = multiDropdownGui:FindFirstChildOfClass("Frame")
			if listFrame then
				local newY = MultiDropdownButton.AbsolutePosition.Y + MultiDropdownButton.AbsoluteSize.Y + 4
				local dropdownHeight = listFrame.AbsoluteSize.Y
				local mainFrameTop = MainFrame.AbsolutePosition.Y
				local mainFrameBottom = MainFrame.AbsolutePosition.Y + MainFrame.AbsoluteSize.Y
				
				if MultiDropdownButton.AbsolutePosition.Y < mainFrameTop then
					closeMultiDropdown(true)
				elseif newY + dropdownHeight > mainFrameBottom then
					closeMultiDropdown(true)
				else
					listFrame.Position = UDim2.fromOffset(MultiDropdownButton.AbsolutePosition.X, newY)
				end
			end
		end
	end)

	-- Section collapse/expand logic
	local isConfigsExpanded = true
	local isOptionsExpanded = true

	local function setSectionExpanded(sectionName, expanded)
		local rows = {}
		if sectionName == "Configs" then
			rows = {ConfigRow, ConfigManagerButtonsRow, ThemeRow, MenyKeyRow, ToggleRow}
			isConfigsExpanded = expanded
			ConfigTitle.Text = expanded and "Configs managment     ▼" or "Configs managment     ▲"
		elseif sectionName == "Options" then
			rows = {MultiDropdownRow, MenuTransparencyRow}
			isOptionsExpanded = expanded
			OptionsTitle.Text = expanded and "Options     ▼" or "Options     ▲"
		end

		-- Animate all rows together as one unit
		local duration = expanded and 0.15 or 0.125
		local easingStyle = expanded and Enum.EasingStyle.Quad or Enum.EasingStyle.Quad
		local easingDirection = expanded and Enum.EasingDirection.Out or Enum.EasingDirection.In

		for _, row in ipairs(rows) do
			if expanded then
				row.Visible = true
				row.Size = UDim2.new(1, 0, 0, 0)
				local openTween = TweenService:Create(
					row,
					TweenInfo.new(duration, easingStyle, easingDirection),
					{Size = UDim2.new(1, 0, 0, 50)}
				)
				openTween:Play()
			else
				local closeTween = TweenService:Create(
					row,
					TweenInfo.new(duration, easingStyle, easingDirection),
					{Size = UDim2.new(1, 0, 0, 0)}
				)
				closeTween:Play()
				closeTween.Completed:Connect(function()
					row.Visible = false
				end)
			end
		end
	end

	ConfigTitle.MouseButton1Click:Connect(function()
		setSectionExpanded("Configs", not isConfigsExpanded)
	end)

	OptionsTitle.MouseButton1Click:Connect(function()
		setSectionExpanded("Options", not isOptionsExpanded)
	end)

	-- Toggle Logic
	local isToggleOn = false
	local toggleTween

	local function updateToggleVisual(animate)
		local targetKnobPos = isToggleOn and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)

		if animate then
			if toggleTween then toggleTween:Cancel() end

			local knobTween = TweenService:Create(
				toggleKnob,
				TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Position = targetKnobPos}
			)
			knobTween:Play()

			if isToggleOn then
				toggleButtonGradient.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 193, 7)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 220, 100))
				})
			else
				toggleButtonGradient.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 220, 240)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 238, 250))
				})
			end
		else
			toggleKnob.Position = targetKnobPos
		end
	end

	ToggleButton.MouseButton1Click:Connect(function()
		isToggleOn = not isToggleOn
		updateToggleVisual(true)
		print("[UI] Toggle: " .. (isToggleOn and "ON" or "OFF"))
	end)

	-- Menu key bind logic
	local currentMenuKey = "L"
	local isBindingMenuKey = false
	local menuKeyBindConn = nil

	local function hideMenuWithAnimation()
		if slideTween then slideTween:Cancel() end
		if minimizeTween then minimizeTween:Cancel() end
		if restoreTween then restoreTween:Cancel() end

		local fadeElements = {MainFrame, MinimizedBar, TopBarFrame, ContentFrame, TabBarFrame, SettingsContainer}
		for _, element in ipairs(fadeElements) do
			local fadeTween = TweenService:Create(
				element,
				TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
				{BackgroundTransparency = 1}
			)
			fadeTween:Play()
		end

		local centerPos = UDim2.new(
			MainFrame.Position.X.Scale,
			MainFrame.Position.X.Offset + MainFrame.Size.X.Offset / 2,
			MainFrame.Position.Y.Scale,
			MainFrame.Position.Y.Offset + MainFrame.Size.Y.Offset / 2
		)

		local scaleTween = TweenService:Create(
			MainFrame,
			TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
			{
				Size = UDim2.fromOffset(0, 0),
				Position = centerPos
			}
		)
		scaleTween:Play()
		scaleTween.Completed:Connect(function()
			MainFrame.Visible = false
		end)
	end

	local originalColors = {}
	local function saveOriginalColors()
		local fadeElements = {MainFrame, MinimizedBar, TopBarFrame, ContentFrame, TabBarFrame, SettingsContainer}
		for _, element in ipairs(fadeElements) do
			originalColors[element] = {
				bg = element.BackgroundColor3,
				transparency = element.BackgroundTransparency
			}
		end
	end

	local function restoreOriginalColors()
		for element, colors in pairs(originalColors) do
			element.BackgroundColor3 = colors.bg
			element.BackgroundTransparency = colors.transparency
		end
	end

	saveOriginalColors()

	local function showMenuWithAnimation()
		MainFrame.Visible = true
		restoreOriginalColors()

		MainFrame.Size = UDim2.fromOffset(0, 0)
		local centerPos = UDim2.new(0.5, 0, 0.5, 0)
		MainFrame.Position = centerPos

		local restoreTweenAnim = TweenService:Create(
			MainFrame,
			TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{Size = UDim2.fromOffset(560, 400), Position = UDim2.new(0.5, -280, 0.5, -200)}
		)
		restoreTweenAnim:Play()
	end

	local menuKeyJustBound = false

	MenuKeyBind.MouseButton1Click:Connect(function()
		if isBindingMenuKey then return end
		isBindingMenuKey = true
		MenuKeyBind.Text = "..."
		MenuKeyBind.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
		MenuKeyBind.BackgroundTransparency = 0.1

		if menuKeyBindConn then menuKeyBindConn:Disconnect() end
		menuKeyBindConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
				currentMenuKey = input.KeyCode.Name
				MenuKeyBind.Text = currentMenuKey
				MenuKeyBind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				MenuKeyBind.BackgroundTransparency = 0
				isBindingMenuKey = false
				menuKeyJustBound = true
				task.delay(0.3, function()
					menuKeyJustBound = false
				end)
				if menuKeyBindConn then
					menuKeyBindConn:Disconnect()
					menuKeyBindConn = nil
				end
			end
		end)
	end)

	-- Global keybind to toggle menu
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if isBindingMenuKey then return end
		if menuKeyJustBound then return end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == currentMenuKey then
			if MainFrame.Visible then
				hideMenuWithAnimation()
			else
				showMenuWithAnimation()
			end
		end
	end)

	ConfigTextbox.FocusLost:Connect(function(enterPressed)
		print("[UI] TextBox submitted: " .. ConfigTextbox.Text)
	end)

	-- Menu Transparency Slider Logic
	local function getMenuTransparencyFraction(input)
		local relX = (input.Position.X - MenuTransparencyBar.AbsolutePosition.X) / math.max(MenuTransparencyBar.AbsoluteSize.X, 1)
		return math.clamp(relX, 0, 1)
	end

	local menuTransparencyTweenFill
	local menuTransparencyTweenKnob

	local function applyMenuTransparency(fraction, useTween)
		local percent = math.floor(fraction * 100 + 0.5)
		MenuTransparencyValue.Text = percent .. "%"
		print("[UI] Menu Transparency: " .. percent .. "%")

		if useTween then
			if menuTransparencyTweenFill then menuTransparencyTweenFill:Cancel() end
			if menuTransparencyTweenKnob then menuTransparencyTweenKnob:Cancel() end

			menuTransparencyTweenFill = TweenService:Create(
				MenuTransparencyFill,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Size = UDim2.new(fraction, 0, 1, 0)}
			)
			menuTransparencyTweenFill:Play()

			menuTransparencyTweenKnob = TweenService:Create(
				MenuTransparencyKnob,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Position = UDim2.new(fraction, 0, 0.5, 0)}
			)
			menuTransparencyTweenKnob:Play()
		else
			MenuTransparencyFill.Size = UDim2.new(fraction, 0, 1, 0)
			MenuTransparencyKnob.Position = UDim2.new(fraction, 0, 0.5, 0)
		end
	end

	local isDraggingMenuTransparency = false
	local menuTransparencyDragConn = nil
	local menuTransparencyEndConn = nil

	MenuTransparencyBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and not isDraggingMenuTransparency then
			isDraggingMenuTransparency = true
			applyMenuTransparency(getMenuTransparencyFraction(input), true)

			if menuTransparencyDragConn then menuTransparencyDragConn:Disconnect() end
			if menuTransparencyEndConn then menuTransparencyEndConn:Disconnect() end

			menuTransparencyDragConn = UserInputService.InputChanged:Connect(function(changed)
				if changed.UserInputType == Enum.UserInputType.MouseMovement and isDraggingMenuTransparency then
					applyMenuTransparency(getMenuTransparencyFraction(changed), false)
				end
			end)

			menuTransparencyEndConn = UserInputService.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
					isDraggingMenuTransparency = false
					if menuTransparencyDragConn then
						menuTransparencyDragConn:Disconnect()
						menuTransparencyDragConn = nil
					end
					if menuTransparencyEndConn then
						menuTransparencyEndConn:Disconnect()
						menuTransparencyEndConn = nil
					end
				end
			end)
		end
	end)

	local function onClose()
		if slideTween then slideTween:Cancel() end
		if minimizeTween then minimizeTween:Cancel() end
		if restoreTween then restoreTween:Cancel() end

		local fadeElements = {MainFrame, MinimizedBar, TopBarFrame, ContentFrame, TabBarFrame, SettingsContainer}
		local fadeTweens = {}

		for _, element in ipairs(fadeElements) do
			local fadeTween = TweenService:Create(
				element,
				TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
				{BackgroundTransparency = 1}
			)
			fadeTween:Play()
			table.insert(fadeTweens, fadeTween)
		end

		local centerPos = UDim2.new(
			MainFrame.Position.X.Scale,
			MainFrame.Position.X.Offset + MainFrame.Size.X.Offset / 2,
			MainFrame.Position.Y.Scale,
			MainFrame.Position.Y.Offset + MainFrame.Size.Y.Offset / 2
		)

		local scaleTween = TweenService:Create(
			MainFrame,
			TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
			{
				Size = UDim2.fromOffset(0, 0),
				Position = centerPos
			}
		)
		scaleTween:Play()

		scaleTween.Completed:Connect(function()
			ScreenGui:Destroy()
		end)
	end

	CloseButton.MouseButton1Click:Connect(onClose)
	MinimizedCloseButton.MouseButton1Click:Connect(onClose)
