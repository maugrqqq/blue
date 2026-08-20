--[[
	Reusable UI constructor library
	Usage:
	local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/maugrqqq/blue/refs/heads/main/source.lua"))()
	local Window = UI:CreateWindow({ Title = "Window Title", MinimizeKey = Enum.KeyCode.LeftControl })
	local Tab = Window:AddTab({ Title = "Main" })
	local Toggle = Tab:AddToggle({ Title = "Auto Hatch Eggs" })
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {}
Library.Windows = {}
Library.Theme = {
	Background = Color3.fromRGB(235, 240, 252),
	GradientTop = Color3.fromRGB(245, 248, 255),
	GradientBottom = Color3.fromRGB(228, 234, 250),
	TopBar = Color3.fromRGB(250, 252, 255),
	TopBarGradientTop = Color3.fromRGB(255, 255, 255),
	TopBarGradientBottom = Color3.fromRGB(244, 247, 255),
	TabBar = Color3.fromRGB(242, 246, 255),
	TabBarGradientTop = Color3.fromRGB(248, 250, 255),
	TabBarGradientBottom = Color3.fromRGB(235, 240, 252),
	Row = Color3.fromRGB(240, 244, 255),
	RowGradientTop = Color3.fromRGB(255, 255, 255),
	RowGradientBottom = Color3.fromRGB(244, 247, 255),
	Button = Color3.fromRGB(255, 255, 255),
	Text = Color3.fromRGB(40, 50, 70),
	TextDim = Color3.fromRGB(150, 150, 150),
	Accent = Color3.fromRGB(255, 193, 7),
	AccentLight = Color3.fromRGB(255, 220, 100),
	ToggleOff = Color3.fromRGB(225, 232, 245),
	ToggleOffGradientTop = Color3.fromRGB(210, 220, 240),
	ToggleOffGradientBottom = Color3.fromRGB(230, 238, 250),
	Close = Color3.fromRGB(255, 36, 0),
	Minimize = Color3.fromRGB(255, 193, 7),
	Font = "Montserrat",
}

local function addCorner(parent, radius)
	local corner = Instance.new("UICorner")
	if type(radius) == "table" then
		corner.TopLeftRadius = UDim.new(radius[1] or 0, radius[2] or 0)
		corner.TopRightRadius = UDim.new(radius[1] or 0, radius[2] or 0)
		corner.BottomLeftRadius = UDim.new(radius[1] or 0, radius[2] or 0)
		corner.BottomRightRadius = UDim.new(radius[1] or 0, radius[2] or 0)
	elseif type(radius) == "number" then
		corner.CornerRadius = UDim.new(0, radius)
	end
	corner.Parent = parent
	return corner
end

local function addGradient(parent, color1, color2, rotation)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color1),
		ColorSequenceKeypoint.new(1, color2)
	})
	gradient.Rotation = rotation or 180
	gradient.Parent = parent
	return gradient
end

local function addPadding(parent, top, bottom, left, right)
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, top or 0)
	padding.PaddingBottom = UDim.new(0, bottom or 0)
	padding.PaddingLeft = UDim.new(0, left or 0)
	padding.PaddingRight = UDim.new(0, right or 0)
	padding.Parent = parent
	return padding
end

local function addListLayout(parent, padding, direction, verticalAlign, horizontalAlign)
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, padding or 0)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.FillDirection = direction or Enum.FillDirection.Vertical
	layout.VerticalAlignment = verticalAlign or Enum.VerticalAlignment.Top
	layout.HorizontalAlignment = horizontalAlign or Enum.HorizontalAlignment.Left
	layout.Parent = parent
	return layout
end

local function createElement(className, props)
	local element = Instance.new(className)
	for key, value in pairs(props or {}) do
		element[key] = value
	end
	return element
end

-- ==================== WINDOW ====================
local Window = {}
Window.__index = Window

function Window:SetTitle(newTitle)
	self.TitleLabel.Text = newTitle
end

function Window:SetMinimizeKey(newKey)
	self.MinimizeKey = newKey
end

function Window:Show()
	if not self.MainFrame.Visible then
		self:_showWithAnimation()
	end
end

function Window:Hide()
	if self.MainFrame.Visible then
		self:_hideWithAnimation()
	end
end

function Window:Destroy()
	if self.ScreenGui then
		self.ScreenGui:Destroy()
	end
	for i, w in ipairs(Library.Windows) do
		if w == self then
			table.remove(Library.Windows, i)
			break
		end
	end
end

function Window:Minimize()
	if not self.IsMinimized then
		self:_minimize()
	end
end

function Window:Restore()
	if self.IsMinimized then
		self:_restore()
	end
end

function Window:AddTab(tabData)
	return self:_createTab(tabData)
end

function Window:_showWithAnimation()
	self.MainFrame.Visible = true
	self:_restoreOriginalColors()
	self.MainFrame.Size = UDim2.fromOffset(0, 0)
	self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	local tween = TweenService:Create(
		self.MainFrame,
		TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size = UDim2.fromOffset(self.Width, self.Height), Position = UDim2.new(0.5, -self.Width/2, 0.5, -self.Height/2)}
	)
	tween:Play()
end

function Window:_hideWithAnimation()
	if self.SlideTween then self.SlideTween:Cancel() end
	if self.MinimizeTween then self.MinimizeTween:Cancel() end
	if self.RestoreTween then self.RestoreTween:Cancel() end

	local fadeElements = {self.MainFrame, self.MinimizedBar, self.TopBarFrame, self.ContentFrame, self.TabBarFrame}
	for _, element in ipairs(fadeElements) do
		local fadeTween = TweenService:Create(
			element,
			TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
			{BackgroundTransparency = 1}
		)
		fadeTween:Play()
	end

	local centerPos = UDim2.new(
		self.MainFrame.Position.X.Scale,
		self.MainFrame.Position.X.Offset + self.MainFrame.Size.X.Offset / 2,
		self.MainFrame.Position.Y.Scale,
		self.MainFrame.Position.Y.Offset + self.MainFrame.Size.Y.Offset / 2
	)

	local scaleTween = TweenService:Create(
		self.MainFrame,
		TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
		{Size = UDim2.fromOffset(0, 0), Position = centerPos}
	)
	scaleTween:Play()
	scaleTween.Completed:Connect(function()
		self.MainFrame.Visible = false
	end)
end

function Window:_saveOriginalColors()
	local fadeElements = {self.MainFrame, self.MinimizedBar, self.TopBarFrame, self.ContentFrame, self.TabBarFrame}
	self.OriginalColors = {}
	for _, element in ipairs(fadeElements) do
		self.OriginalColors[element] = {
			bg = element.BackgroundColor3,
			transparency = element.BackgroundTransparency
		}
	end
end

function Window:_restoreOriginalColors()
	for element, colors in pairs(self.OriginalColors) do
		element.BackgroundColor3 = colors.bg
		element.BackgroundTransparency = colors.transparency
	end
end

function Window:_minimize()
	if self.MinimizeTween then self.MinimizeTween:Cancel() end
	if self.RestoreTween then self.RestoreTween:Cancel() end

	self.MinimizeTween = TweenService:Create(
		self.MainFrame,
		TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
		{Size = UDim2.fromOffset(self.Width, 32), Position = UDim2.new(0.5, -self.Width/2, 0.5, -16)}
	)
	self.MinimizeTween:Play()
	self.MinimizeTween.Completed:Connect(function()
		self.MinimizeTween = nil
		self:_applyMinimizedState()
	end)
end

function Window:_restore()
	if self.RestoreTween then self.RestoreTween:Cancel() end
	if self.MinimizeTween then self.MinimizeTween:Cancel() end

	self:_restoreButtonState()
	self.MainFrame.Size = UDim2.fromOffset(self.Width, 32)
	self.MainFrame.Position = UDim2.new(0.5, -self.Width/2, 0.5, -16)
	self.MainFrame.Visible = true

	self.RestoreTween = TweenService:Create(
		self.MainFrame,
		TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
		{Size = UDim2.fromOffset(self.Width, self.Height), Position = UDim2.new(0.5, -self.Width/2, 0.5, -self.Height/2)}
	)
	self.RestoreTween:Play()
	self.RestoreTween.Completed:Connect(function()
		self.RestoreTween = nil
		self.MainFrame.Size = UDim2.fromOffset(self.Width, self.Height)
		self.MainFrame.Position = UDim2.new(0.5, -self.Width/2, 0.5, -self.Height/2)
	end)
end

function Window:_restoreButtonState()
	self.TitleLabel.Parent = self.TopBarFrame
	self.MinimizeButton.Parent = self.TopBarFrame
	self.CloseButton.Parent = self.TopBarFrame
	self.MinimizedBar.Visible = false
end

function Window:_applyMinimizedState()
	self.MinimizedBar.Position = self.MainFrame.Position
	self.MinimizedBar.Visible = true
	self.TitleLabel.Parent = self.MinimizedBar
	self.MinimizeButton.Parent = self.MinimizedBar
	self.CloseButton.Parent = self.MinimizedBar
	self.MainFrame.Visible = false
end

function Window:_createTab(tabData)
	tabData = tabData or {}
	local tab = {}
	tab.Window = self
	tab.Title = tabData.Title or "Tab"
	tab.Elements = {}
	tab.Container = createElement("ScrollingFrame", {
		Name = tab.Title .. "Container",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Library.Theme.Background,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 3,
		Visible = false,
		Parent = self.ContentFrame,
	})
	addListLayout(tab.Container, 5, Enum.FillDirection.Vertical)

	local tabFrame = createElement("Frame", {
		Name = tab.Title .. "TabFrame",
		Size = UDim2.new(0, 94, 0, 33),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = self.TabBarFrame,
	})
	local tabButton = createElement("TextButton", {
		Name = tab.Title .. "TabButton",
		Text = tab.Title,
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Library.Theme.Text,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = tabFrame,
	})
	addCorner(tabButton, {0, 8})

	tab.Frame = tabFrame
	tab.Button = tabButton

	tabButton.MouseButton1Click:Connect(function()
		self:_selectTab(tab)
	end)

	table.insert(self.Tabs, tab)

	if #self.Tabs == 1 then
		self:_selectTab(tab)
	end

	function tab:AddToggle(toggleData)
		return self.Window:_createToggle(self, toggleData)
	end
	function tab:AddButton(buttonData)
		return self.Window:_createButton(self, buttonData)
	end
	function tab:AddLabel(labelData)
		return self.Window:_createLabel(self, labelData)
	end
	function tab:AddSlider(sliderData)
		return self.Window:_createSlider(self, sliderData)
	end
	function tab:AddDropdown(dropdownData)
		return self.Window:_createDropdown(self, dropdownData)
	end
	function tab:AddMultiDropdown(dropdownData)
		return self.Window:_createMultiDropdown(self, dropdownData)
	end
	function tab:AddTextbox(textboxData)
		return self.Window:_createTextbox(self, textboxData)
	end
	function tab:AddKeybind(keybindData)
		return self.Window:_createKeybind(self, keybindData)
	end
	function tab:AddSection(sectionData)
		return self.Window:_createSection(self, sectionData)
	end
	function tab:AddParagraph(paragraphData)
		return self.Window:_createParagraph(self, paragraphData)
	end

	return tab
end

function Window:_selectTab(tab)
	for _, t in ipairs(self.Tabs) do
		t.Container.Visible = false
		t.Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		t.Button.BackgroundTransparency = 0
	end
	tab.Container.Visible = true
	tab.Button.BackgroundColor3 = Library.Theme.Accent
	tab.Button.BackgroundTransparency = 0.1
	self.CurrentTab = tab
end

-- ==================== ELEMENT CREATORS ====================
function Window:_createRow(tab, name)
	local row = createElement("Frame", {
		Name = name,
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundColor3 = Library.Theme.Row,
		BorderSizePixel = 0,
		Parent = tab.Container,
	})
	addCorner(row, {0, 8})
	addGradient(row, Library.Theme.RowGradientTop, Library.Theme.RowGradientBottom, 180)
	addListLayout(row, 10, Enum.FillDirection.Horizontal, Enum.VerticalAlignment.Center)
	addPadding(row, 0, 0, 10, 10)
	return row
end

function Window:_createLabel(tab, labelData)
	labelData = labelData or {}
	local label = createElement("TextLabel", {
		Name = labelData.Name or "Label",
		Text = labelData.Title or labelData.Text or "Label",
		Font = Library.Theme.Font,
		TextSize = labelData.TextSize or 14,
		TextColor3 = labelData.TextColor or Library.Theme.Text,
		Size = UDim2.new(1, 0, 0, 25),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = tab.Container,
	})
	return label
end

function Window:_createParagraph(tab, paragraphData)
	paragraphData = paragraphData or {}
	local paragraph = createElement("TextLabel", {
		Name = paragraphData.Name or "Paragraph",
		Text = paragraphData.Title or paragraphData.Text or "",
		Font = Library.Theme.Font,
		TextSize = paragraphData.TextSize or 12,
		TextColor3 = paragraphData.TextColor or Library.Theme.TextDim,
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Parent = tab.Container,
	})
	return paragraph
end

function Window:_createButton(tab, buttonData)
	buttonData = buttonData or {}
	local button = {}
	button.Type = "Button"
	button.Title = buttonData.Title or "Button"
	button.Callback = buttonData.Callback
	button.Connections = {}

	local row = self:_createRow(tab, button.Title .. "Row")
	local label = createElement("TextLabel", {
		Text = button.Title,
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Library.Theme.Text,
		Size = UDim2.new(1, -110, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	local btn = createElement("TextButton", {
		Text = buttonData.ButtonText or "Execute",
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Library.Theme.Text,
		Size = UDim2.new(0, 90, 0, 30),
		BackgroundColor3 = Library.Theme.Button,
		BorderSizePixel = 0,
		Parent = row,
	})
	addCorner(btn, {0, 8})
	addPadding(btn, 0, 0, 8, 8)

	button.Row = row
	button.Label = label
	button.Button = btn

	local clickConn = btn.MouseButton1Click:Connect(function()
		if button.Callback then button.Callback() end
	end)
	table.insert(button.Connections, clickConn)

	function button:Connect(callback)
		button.Callback = callback
	end
	function button:SetText(newText)
		btn.Text = newText
	end
	function button:SetTitle(newTitle)
		button.Title = newTitle
		label.Text = newTitle
	end
	function button:Destroy()
		for _, conn in ipairs(button.Connections) do conn:Disconnect() end
		row:Destroy()
	end

	table.insert(tab.Elements, button)
	return button
end

function Window:_createToggle(tab, toggleData)
	toggleData = toggleData or {}
	local toggle = {}
	toggle.Type = "Toggle"
	toggle.Title = toggleData.Title or "Toggle"
	toggle.Value = toggleData.Default or false
	toggle.Callback = toggleData.Callback
	toggle.Connections = {}

	local row = self:_createRow(tab, toggle.Title .. "Row")
	local label = createElement("TextLabel", {
		Text = toggle.Title,
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Library.Theme.Text,
		Size = UDim2.new(1, -80, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	local toggleBtn = createElement("TextButton", {
		Text = "",
		Size = UDim2.new(0, 44, 0, 22),
		BackgroundColor3 = Library.Theme.ToggleOff,
		BorderSizePixel = 0,
		Parent = row,
	})
	addCorner(toggleBtn, {1, 0})
	local toggleGradient = addGradient(toggleBtn, Library.Theme.ToggleOffGradientTop, Library.Theme.ToggleOffGradientBottom, 180)
	local knob = createElement("Frame", {
		Size = UDim2.new(0, 18, 0, 18),
		Position = UDim2.new(0, 2, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = toggleBtn,
	})
	addCorner(knob, {1, 0})

	toggle.Row = row
	toggle.Label = label
	toggle.Button = toggleBtn
	toggle.Knob = knob
	toggle.Gradient = toggleGradient

	local function updateVisual(animate)
		local targetPos = toggle.Value and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
		if animate then
			local knobTween = TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos})
			knobTween:Play()
			if toggle.Value then
				toggleGradient.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Library.Theme.Accent),
					ColorSequenceKeypoint.new(1, Library.Theme.AccentLight)
				})
			else
				toggleGradient.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Library.Theme.ToggleOffGradientTop),
					ColorSequenceKeypoint.new(1, Library.Theme.ToggleOffGradientBottom)
				})
			end
		else
			knob.Position = targetPos
		end
	end

	updateVisual(false)

	local clickConn = toggleBtn.MouseButton1Click:Connect(function()
		toggle:SetValue(not toggle.Value)
	end)
	table.insert(toggle.Connections, clickConn)

	function toggle:SetValue(value)
		toggle.Value = value
		updateVisual(true)
		if toggle.Callback then toggle.Callback(toggle.Value) end
	end
	function toggle:GetValue()
		return toggle.Value
	end
	function toggle:Connect(callback)
		toggle.Callback = callback
	end
	function toggle:SetTitle(newTitle)
		toggle.Title = newTitle
		label.Text = newTitle
	end
	function toggle:Destroy()
		for _, conn in ipairs(toggle.Connections) do conn:Disconnect() end
		row:Destroy()
	end

	table.insert(tab.Elements, toggle)
	return toggle
end

function Window:_createSlider(tab, sliderData)
	sliderData = sliderData or {}
	local slider = {}
	slider.Type = "Slider"
	slider.Title = sliderData.Title or "Slider"
	slider.Min = sliderData.Min or 0
	slider.Max = sliderData.Max or 100
	slider.Value = sliderData.Default or slider.Min
	slider.Callback = sliderData.Callback
	slider.Connections = {}

	local row = self:_createRow(tab, slider.Title .. "Row")
	local label = createElement("TextLabel", {
		Text = slider.Title,
		Font = Library.Theme.Font,
		TextSize = 12,
		TextColor3 = Library.Theme.Text,
		Size = UDim2.new(0, 120, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = row,
	})
	local bar = createElement("Frame", {
		Size = UDim2.new(1, -210, 0, 10),
		BackgroundColor3 = Library.Theme.ToggleOff,
		BorderSizePixel = 0,
		Parent = row,
	})
	addCorner(bar, {0, 5})
	addGradient(bar, Library.Theme.ToggleOffGradientTop, Library.Theme.ToggleOffGradientBottom, 180)
	local fill = createElement("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Library.Theme.Accent,
		BorderSizePixel = 0,
		Parent = bar,
	})
	addCorner(fill, {0, 5})
	addGradient(fill, Library.Theme.Accent, Library.Theme.AccentLight, 180)
	local knob = createElement("Frame", {
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = bar,
	})
	addCorner(knob, {0, 7})
	local valueLabel = createElement("TextLabel", {
		Text = tostring(slider.Value),
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Library.Theme.Text,
		Size = UDim2.new(0, 40, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = row,
	})

	slider.Row = row
	slider.Label = label
	slider.Bar = bar
	slider.Fill = fill
	slider.Knob = knob
	slider.ValueLabel = valueLabel

	local function getFraction(input)
		local relX = (input.Position.X - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1)
		return math.clamp(relX, 0, 1)
	end

	local function applyValue(fraction, useTween)
		slider.Value = slider.Min + (slider.Max - slider.Min) * fraction
		slider.Value = math.floor(slider.Value * 100 + 0.5) / 100
		valueLabel.Text = tostring(slider.Value)
		if useTween then
			local fillTween = TweenService:Create(fill, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(fraction, 0, 1, 0)})
			fillTween:Play()
			local knobTween = TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(fraction, 0, 0.5, 0)})
			knobTween:Play()
		else
			fill.Size = UDim2.new(fraction, 0, 1, 0)
			knob.Position = UDim2.new(fraction, 0, 0.5, 0)
		end
		if slider.Callback then slider.Callback(slider.Value) end
	end

	local initialFraction = (slider.Value - slider.Min) / math.max(slider.Max - slider.Min, 1)
	applyValue(initialFraction, false)

	local isDragging = false
	local dragConn, endConn

	local beginConn = bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and not isDragging then
			isDragging = true
			applyValue(getFraction(input), true)
			if dragConn then dragConn:Disconnect() end
			if endConn then endConn:Disconnect() end
			dragConn = UserInputService.InputChanged:Connect(function(changed)
				if changed.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
					applyValue(getFraction(changed), false)
				end
			end)
			endConn = UserInputService.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
					isDragging = false
					if dragConn then dragConn:Disconnect(); dragConn = nil end
					if endConn then endConn:Disconnect(); endConn = nil end
				end
			end)
		end
	end)
	table.insert(slider.Connections, beginConn)

	function slider:SetValue(value)
		value = math.clamp(value, slider.Min, slider.Max)
		slider.Value = value
		local fraction = (value - slider.Min) / math.max(slider.Max - slider.Min, 1)
		applyValue(fraction, true)
	end
	function slider:GetValue()
		return slider.Value
	end
	function slider:Connect(callback)
		slider.Callback = callback
	end
	function slider:SetTitle(newTitle)
		slider.Title = newTitle
		label.Text = newTitle
	end
	function slider:Destroy()
		for _, conn in ipairs(slider.Connections) do conn:Disconnect() end
		row:Destroy()
	end

	table.insert(tab.Elements, slider)
	return slider
end

function Window:_createDropdown(tab, dropdownData)
	dropdownData = dropdownData or {}
	local dropdown = {}
	dropdown.Type = "Dropdown"
	dropdown.Title = dropdownData.Title or "Dropdown"
	dropdown.Options = dropdownData.Options or {}
	dropdown.Value = dropdownData.Default or (dropdownData.Options and dropdownData.Options[1]) or nil
	dropdown.Callback = dropdownData.Callback
	dropdown.Connections = {}
	dropdown.IsOpen = false
	dropdown.DropdownGui = nil

	local row = self:_createRow(tab, dropdown.Title .. "Row")
	local label = createElement("TextLabel", {
		Text = dropdown.Title,
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Library.Theme.Text,
		Size = UDim2.new(0, 100, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	local btn = createElement("TextButton", {
		Text = dropdown.Value or "Select...",
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Library.Theme.Text,
		Size = UDim2.new(1, -120, 0, 30),
		BackgroundColor3 = Library.Theme.Button,
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	addCorner(btn, {0, 8})
	addPadding(btn, 0, 0, 8, 8)

	dropdown.Row = row
	dropdown.Label = label
	dropdown.Button = btn

	local function closeDropdown(fast)
		if not dropdown.DropdownGui then
			dropdown.IsOpen = false
			return
		end
		dropdown.IsOpen = false
		local guiToDestroy = dropdown.DropdownGui
		dropdown.DropdownGui = nil
		local listFrame = guiToDestroy:FindFirstChildOfClass("Frame")
		if listFrame then
			local duration = fast and 0.15 or 0.25
			local closeTween = TweenService:Create(listFrame, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.fromOffset(listFrame.AbsoluteSize.X, 0)})
			closeTween:Play()
			closeTween.Completed:Connect(function()
				guiToDestroy:Destroy()
			end)
		else
			guiToDestroy:Destroy()
		end
	end

	local function openDropdown()
		if dropdown.IsOpen then
			closeDropdown(true)
			return
		end
		if dropdown.DropdownGui then
			dropdown.DropdownGui:Destroy()
			dropdown.DropdownGui = nil
		end
		dropdown.IsOpen = true

		dropdown.DropdownGui = createElement("ScreenGui", {
			Name = dropdown.Title .. "DropdownList",
			Parent = self.ScreenGui,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = 100,
		})

		local listFrame = createElement("Frame", {
			Name = "ListFrame",
			Size = UDim2.fromOffset(btn.AbsoluteSize.X, 0),
			Position = UDim2.fromOffset(btn.AbsolutePosition.X, btn.AbsolutePosition.Y + btn.AbsoluteSize.Y + 4),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Parent = dropdown.DropdownGui,
		})
		addCorner(listFrame, {0, 8})

		local optionsScroll = createElement("ScrollingFrame", {
			Name = "OptionsScroll",
			Size = UDim2.new(1, -8, 0, 170),
			Position = UDim2.new(0, 4, 0, 4),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollBarThickness = 3,
			Parent = listFrame,
		})
		addListLayout(optionsScroll, 4, Enum.FillDirection.Vertical)

		local targetHeight = 170 + 8
		local openTween = TweenService:Create(listFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(btn.AbsoluteSize.X, targetHeight)})
		openTween:Play()

		for i, option in ipairs(dropdown.Options) do
			local optionButton = createElement("TextButton", {
				Name = "OptionButton",
				Text = option,
				Font = Library.Theme.Font,
				TextSize = 14,
				TextColor3 = Library.Theme.Text,
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = optionsScroll,
				LayoutOrder = i,
			})
			addCorner(optionButton, {0, 8})
			addPadding(optionButton, 0, 0, 8, 8)

			optionButton.MouseButton1Click:Connect(function()
				dropdown:SetValue(option)
				closeDropdown(true)
			end)

			optionButton.MouseEnter:Connect(function()
				optionButton.BackgroundColor3 = Library.Theme.Row
			end)
			optionButton.MouseLeave:Connect(function()
				optionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			end)
		end
	end

	btn.MouseButton1Click:Connect(openDropdown)

	local closeConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not dropdown.IsOpen then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not dropdown.DropdownGui then return end
			local listFrame = dropdown.DropdownGui:FindFirstChildOfClass("Frame")
			if listFrame then
				local mousePos = input.Position
				local guiPos = listFrame.AbsolutePosition
				local guiSize = listFrame.AbsoluteSize
				local btnPos = btn.AbsolutePosition
				local btnSize = btn.AbsoluteSize
				local inDropdown = mousePos.X >= guiPos.X and mousePos.X <= guiPos.X + guiSize.X and mousePos.Y >= guiPos.Y and mousePos.Y <= guiPos.Y + guiSize.Y
				local onButton = mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + btnSize.X and mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + btnSize.Y
				if not inDropdown and not onButton then
					closeDropdown(true)
				end
			end
		end
	end)
	table.insert(dropdown.Connections, closeConn)

	function dropdown:SetValue(value)
		dropdown.Value = value
		btn.Text = value
		if dropdown.Callback then dropdown.Callback(value) end
	end
	function dropdown:GetValue()
		return dropdown.Value
	end
	function dropdown:Connect(callback)
		dropdown.Callback = callback
	end
	function dropdown:SetOptions(options)
		dropdown.Options = options
	end
	function dropdown:SetTitle(newTitle)
		dropdown.Title = newTitle
		label.Text = newTitle
	end
	function dropdown:Destroy()
		closeDropdown(true)
		for _, conn in ipairs(dropdown.Connections) do conn:Disconnect() end
		row:Destroy()
	end

	table.insert(tab.Elements, dropdown)
	return dropdown
end

function Window:_createMultiDropdown(tab, dropdownData)
	dropdownData = dropdownData or {}
	local dropdown = {}
	dropdown.Type = "MultiDropdown"
	dropdown.Title = dropdownData.Title or "MultiDropdown"
	dropdown.Options = dropdownData.Options or {}
	dropdown.Selected = {}
	dropdown.Callback = dropdownData.Callback
	dropdown.Connections = {}
	dropdown.IsOpen = false
	dropdown.DropdownGui = nil

	local row = self:_createRow(tab, dropdown.Title .. "Row")
	local label = createElement("TextLabel", {
		Text = dropdown.Title,
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Library.Theme.Text,
		Size = UDim2.new(0, 100, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	local btn = createElement("TextButton", {
		Text = "Select...",
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Library.Theme.Text,
		Size = UDim2.new(1, -120, 0, 30),
		BackgroundColor3 = Library.Theme.Button,
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	addCorner(btn, {0, 8})
	addPadding(btn, 0, 0, 8, 8)

	dropdown.Row = row
	dropdown.Label = label
	dropdown.Button = btn

	local function updateText()
		local selected = {}
		for _, opt in ipairs(dropdown.Options) do
			if dropdown.Selected[opt] then
				table.insert(selected, opt)
			end
		end
		if #selected == 0 then
			btn.Text = "Select..."
		elseif #selected <= 2 then
			btn.Text = table.concat(selected, ", ")
		else
			btn.Text = #selected .. " selected"
		end
	end

	local function closeDropdown(fast)
		if not dropdown.DropdownGui then
			dropdown.IsOpen = false
			return
		end
		dropdown.IsOpen = false
		local guiToDestroy = dropdown.DropdownGui
		dropdown.DropdownGui = nil
		local listFrame = guiToDestroy:FindFirstChildOfClass("Frame")
		if listFrame then
			local duration = fast and 0.15 or 0.25
			local closeTween = TweenService:Create(listFrame, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.fromOffset(listFrame.AbsoluteSize.X, 0)})
			closeTween:Play()
			closeTween.Completed:Connect(function()
				guiToDestroy:Destroy()
			end)
		else
			guiToDestroy:Destroy()
		end
	end

	local function openDropdown()
		if dropdown.IsOpen then
			closeDropdown(true)
			return
		end
		if dropdown.DropdownGui then
			dropdown.DropdownGui:Destroy()
			dropdown.DropdownGui = nil
		end
		dropdown.IsOpen = true

		dropdown.DropdownGui = createElement("ScreenGui", {
			Name = dropdown.Title .. "MultiDropdownList",
			Parent = self.ScreenGui,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = 100,
		})

		local listFrame = createElement("Frame", {
			Name = "ListFrame",
			Size = UDim2.fromOffset(btn.AbsoluteSize.X, 0),
			Position = UDim2.fromOffset(btn.AbsolutePosition.X, btn.AbsolutePosition.Y + btn.AbsoluteSize.Y + 4),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Parent = dropdown.DropdownGui,
		})
		addCorner(listFrame, {0, 8})

		local optionsScroll = createElement("ScrollingFrame", {
			Name = "OptionsScroll",
			Size = UDim2.new(1, -8, 0, 170),
			Position = UDim2.new(0, 4, 0, 4),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollBarThickness = 3,
			Parent = listFrame,
		})
		addListLayout(optionsScroll, 4, Enum.FillDirection.Vertical)

		local targetHeight = 170 + 8
		local openTween = TweenService:Create(listFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(btn.AbsoluteSize.X, targetHeight)})
		openTween:Play()

		for i, option in ipairs(dropdown.Options) do
			local optionButton = createElement("TextButton", {
				Name = "OptionButton",
				Text = option,
				Font = Library.Theme.Font,
				TextSize = 14,
				TextColor3 = dropdown.Selected[option] and Library.Theme.Accent or Library.Theme.Text,
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = optionsScroll,
				LayoutOrder = i,
			})
			addCorner(optionButton, {0, 8})
			addPadding(optionButton, 0, 0, 8, 8)

			optionButton.MouseButton1Click:Connect(function()
				dropdown:ToggleOption(option)
				optionButton.TextColor3 = dropdown.Selected[option] and Library.Theme.Accent or Library.Theme.Text
			end)

			optionButton.MouseEnter:Connect(function()
				optionButton.BackgroundColor3 = Library.Theme.Row
			end)
			optionButton.MouseLeave:Connect(function()
				optionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			end)
		end
	end

	btn.MouseButton1Click:Connect(openDropdown)

	local closeConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not dropdown.IsOpen then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not dropdown.DropdownGui then return end
			local listFrame = dropdown.DropdownGui:FindFirstChildOfClass("Frame")
			if listFrame then
				local mousePos = input.Position
				local guiPos = listFrame.AbsolutePosition
				local guiSize = listFrame.AbsoluteSize
				local btnPos = btn.AbsolutePosition
				local btnSize = btn.AbsoluteSize
				local inDropdown = mousePos.X >= guiPos.X and mousePos.X <= guiPos.X + guiSize.X and mousePos.Y >= guiPos.Y and mousePos.Y <= guiPos.Y + guiSize.Y
				local onButton = mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + btnSize.X and mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + btnSize.Y
				if not inDropdown and not onButton then
					closeDropdown(true)
				end
			end
		end
	end)
	table.insert(dropdown.Connections, closeConn)

	function dropdown:ToggleOption(option)
		dropdown.Selected[option] = not dropdown.Selected[option]
		updateText()
		if dropdown.Callback then dropdown.Callback(option, dropdown.Selected[option]) end
	end
	function dropdown:SetSelected(options)
		dropdown.Selected = {}
		for _, opt in ipairs(options) do
			dropdown.Selected[opt] = true
		end
		updateText()
	end
	function dropdown:GetSelected()
		local selected = {}
		for _, opt in ipairs(dropdown.Options) do
			if dropdown.Selected[opt] then
				table.insert(selected, opt)
			end
		end
		return selected
	end
	function dropdown:Connect(callback)
		dropdown.Callback = callback
	end
	function dropdown:SetTitle(newTitle)
		dropdown.Title = newTitle
		label.Text = newTitle
	end
	function dropdown:Destroy()
		closeDropdown(true)
		for _, conn in ipairs(dropdown.Connections) do conn:Disconnect() end
		row:Destroy()
	end

	table.insert(tab.Elements, dropdown)
	return dropdown
end

function Window:_createTextbox(tab, textboxData)
	textboxData = textboxData or {}
	local textbox = {}
	textbox.Type = "Textbox"
	textbox.Title = textboxData.Title or "Textbox"
	textbox.Placeholder = textboxData.Placeholder or "Enter text..."
	textbox.Value = textboxData.Default or ""
	textbox.Callback = textboxData.Callback
	textbox.Connections = {}

	local row = self:_createRow(tab, textbox.Title .. "Row")
	local label = createElement("TextLabel", {
		Text = textbox.Title,
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Library.Theme.Text,
		Size = UDim2.new(0, 100, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	local txtBox = createElement("TextBox", {
		Text = textbox.Value,
		PlaceholderText = textbox.Placeholder,
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Library.Theme.Text,
		PlaceholderColor3 = Library.Theme.TextDim,
		Size = UDim2.new(1, -120, 0, 30),
		BackgroundColor3 = Library.Theme.Button,
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	addCorner(txtBox, {0, 8})
	addPadding(txtBox, 0, 0, 8, 8)

	textbox.Row = row
	textbox.Label = label
	textbox.TextBox = txtBox

	local focusLostConn = txtBox.FocusLost:Connect(function(enterPressed)
		textbox.Value = txtBox.Text
		if textbox.Callback then textbox.Callback(txtBox.Text, enterPressed) end
	end)
	table.insert(textbox.Connections, focusLostConn)

	function textbox:SetValue(value)
		textbox.Value = value
		txtBox.Text = value
	end
	function textbox:GetValue()
		return txtBox.Text
	end
	function textbox:Connect(callback)
		textbox.Callback = callback
	end
	function textbox:SetTitle(newTitle)
		textbox.Title = newTitle
		label.Text = newTitle
	end
	function textbox:Destroy()
		for _, conn in ipairs(textbox.Connections) do conn:Disconnect() end
		row:Destroy()
	end

	table.insert(tab.Elements, textbox)
	return textbox
end

function Window:_createKeybind(tab, keybindData)
	keybindData = keybindData or {}
	local keybind = {}
	keybind.Type = "Keybind"
	keybind.Title = keybindData.Title or "Keybind"
	keybind.Value = keybindData.Default or Enum.KeyCode.L
	keybind.Callback = keybindData.Callback
	keybind.Connections = {}
	keybind.IsBinding = false

	local row = self:_createRow(tab, keybind.Title .. "Row")
	local label = createElement("TextLabel", {
		Text = keybind.Title,
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Library.Theme.Text,
		Size = UDim2.new(1, -80, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	local btn = createElement("TextButton", {
		Text = keybind.Value.Name,
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Library.Theme.Text,
		Size = UDim2.new(0, 60, 0, 30),
		BackgroundColor3 = Library.Theme.Button,
		BorderSizePixel = 0,
		Parent = row,
	})
	addCorner(btn, {0, 8})
	addPadding(btn, 0, 0, 8, 8)

	keybind.Row = row
	keybind.Label = label
	keybind.Button = btn

	local bindConn
	btn.MouseButton1Click:Connect(function()
		if keybind.IsBinding then return end
		keybind.IsBinding = true
		btn.Text = "..."
		if bindConn then bindConn:Disconnect() end
		bindConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
				keybind:SetValue(input.KeyCode)
				keybind.IsBinding = false
				if bindConn then bindConn:Disconnect(); bindConn = nil end
			end
		end)
	end)

	function keybind:SetValue(newKey)
		keybind.Value = newKey
		btn.Text = newKey.Name
		if keybind.Callback then keybind.Callback(newKey) end
	end
	function keybind:GetValue()
		return keybind.Value
	end
	function keybind:Connect(callback)
		keybind.Callback = callback
	end
	function keybind:SetTitle(newTitle)
		keybind.Title = newTitle
		label.Text = newTitle
	end
	function keybind:Destroy()
		if bindConn then bindConn:Disconnect() end
		for _, conn in ipairs(keybind.Connections) do conn:Disconnect() end
		row:Destroy()
	end

	table.insert(tab.Elements, keybind)
	return keybind
end

function Window:_createSection(tab, sectionData)
	sectionData = sectionData or {}
	local section = {}
	section.Type = "Section"
	section.Title = sectionData.Title or "Section"
	section.Connections = {}

	local titleButton = createElement("TextButton", {
		Text = section.Title .. "     ▼",
		Font = Library.Theme.Font,
		TextSize = 14,
		FontFace = Font.fromName(Library.Theme.Font, Enum.FontWeight.Bold),
		TextColor3 = Library.Theme.Text,
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutoButtonColor = false,
		Parent = tab.Container,
	})

	local rows = {}
	local isExpanded = true

	section.TitleButton = titleButton

	local function setExpanded(expanded)
		isExpanded = expanded
		titleButton.Text = section.Title .. (expanded and "     ▼" or "     ▲")
		for _, row in ipairs(rows) do
			if expanded then
				row.Visible = true
				row.Size = UDim2.new(1, 0, 0, 0)
				local openTween = TweenService:Create(row, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 50)})
				openTween:Play()
			else
				local closeTween = TweenService:Create(row, TweenInfo.new(0.125, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0)})
				closeTween:Play()
				closeTween.Completed:Connect(function()
					row.Visible = false
				end)
			end
		end
	end

	local clickConn = titleButton.MouseButton1Click:Connect(function()
		setExpanded(not isExpanded)
	end)
	table.insert(section.Connections, clickConn)

	function section:AddToggle(toggleData)
		local toggle = self.Window:_createToggle(tab, toggleData)
		table.insert(rows, toggle.Row)
		return toggle
	end
	function section:AddButton(buttonData)
		local button = self.Window:_createButton(tab, buttonData)
		table.insert(rows, button.Row)
		return button
	end
	function section:AddSlider(sliderData)
		local slider = self.Window:_createSlider(tab, sliderData)
		table.insert(rows, slider.Row)
		return slider
	end
	function section:AddDropdown(dropdownData)
		local dropdown = self.Window:_createDropdown(tab, dropdownData)
		table.insert(rows, dropdown.Row)
		return dropdown
	end
	function section:AddMultiDropdown(dropdownData)
		local dropdown = self.Window:_createMultiDropdown(tab, dropdownData)
		table.insert(rows, dropdown.Row)
		return dropdown
	end
	function section:AddTextbox(textboxData)
		local textbox = self.Window:_createTextbox(tab, textboxData)
		table.insert(rows, textbox.Row)
		return textbox
	end
	function section:AddKeybind(keybindData)
		local keybind = self.Window:_createKeybind(tab, keybindData)
		table.insert(rows, keybind.Row)
		return keybind
	end
	function section:SetTitle(newTitle)
		section.Title = newTitle
		titleButton.Text = newTitle .. (isExpanded and "     ▼" or "     ▲")
	end
	function section:Destroy()
		for _, conn in ipairs(section.Connections) do conn:Disconnect() end
		titleButton:Destroy()
		for _, row in ipairs(rows) do row:Destroy() end
	end

	table.insert(tab.Elements, section)
	return section
end

-- ==================== CREATE WINDOW ====================
function Library:CreateWindow(windowData)
	windowData = windowData or {}

	if CoreGui:FindFirstChild("UI") then
		CoreGui["UI"]:Destroy()
	end

	local screenGui = createElement("ScreenGui", {
		Name = "UI",
		Parent = CoreGui,
		ResetOnSpawn = false,
	})

	local self = setmetatable({}, Window)
	self.ScreenGui = screenGui
	self.Width = windowData.Width or 560
	self.Height = windowData.Height or 400
	self.MinimizeKey = windowData.MinimizeKey or Enum.KeyCode.LeftControl
	self.Tabs = {}
	self.CurrentTab = nil
	self.IsMinimized = false
	self.SlideTween = nil
	self.MinimizeTween = nil
	self.RestoreTween = nil
	self.OriginalColors = {}

	-- Main frame
	self.MainFrame = createElement("Frame", {
		Name = "MainFrame",
		Size = UDim2.fromOffset(self.Width, self.Height),
		Position = UDim2.new(0.5, -self.Width/2, 0.5, -self.Height/2),
		BackgroundColor3 = Library.Theme.Background,
		BorderSizePixel = 0,
		Parent = screenGui,
		ClipsDescendants = true,
	})
	addCorner(self.MainFrame, 12)
	addGradient(self.MainFrame, Library.Theme.GradientTop, Library.Theme.GradientBottom, 180)

	-- Minimized bar
	self.MinimizedBar = createElement("Frame", {
		Name = "MinimizedBar",
		Size = UDim2.fromOffset(self.Width, 32),
		Position = self.MainFrame.Position,
		BackgroundColor3 = Library.Theme.Background,
		BorderSizePixel = 0,
		Visible = false,
		Parent = screenGui,
	})
	addCorner(self.MinimizedBar, 12)
	addGradient(self.MinimizedBar, Library.Theme.GradientTop, Library.Theme.GradientBottom, 180)

	-- Content frame
	self.ContentFrame = createElement("Frame", {
		Name = "ContentFrame",
		Size = UDim2.new(1, -140, 1, -32),
		Position = UDim2.new(0, 140, 0, 36),
		BackgroundColor3 = Library.Theme.Background,
		BorderSizePixel = 0,
		Parent = self.MainFrame,
	})
	addCorner(self.ContentFrame, 12)
	addGradient(self.ContentFrame, Library.Theme.GradientTop, Library.Theme.GradientBottom, 180)

	-- Tab bar
	self.TabBarFrame = createElement("Frame", {
		Name = "TabBar",
		Size = UDim2.new(-0.036, 140, 1.028, -32),
		Position = UDim2.new(0, 0, 0, 21),
		BackgroundColor3 = Library.Theme.TabBar,
		BorderSizePixel = 0,
		Parent = self.MainFrame,
	})
	addCorner(self.TabBarFrame, 12)
	addGradient(self.TabBarFrame, Library.Theme.TabBarGradientTop, Library.Theme.TabBarGradientBottom, 180)
	addListLayout(self.TabBarFrame, 5, Enum.FillDirection.Vertical)
	addPadding(self.TabBarFrame, 20, 10, 12, 10)

	-- Top bar
	self.TopBarFrame = createElement("Frame", {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 32),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Library.Theme.TopBar,
		BorderSizePixel = 0,
		Parent = self.MainFrame,
	})
	addCorner(self.TopBarFrame, 12)
	addGradient(self.TopBarFrame, Library.Theme.TopBarGradientTop, Library.Theme.TopBarGradientBottom, 180)

	-- Title
	self.TitleLabel = createElement("TextLabel", {
		Name = "Title",
		Text = windowData.Title or "Window",
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Library.Theme.Text,
		Size = UDim2.new(1, -80, 1, 0),
		Position = UDim2.new(0, 12, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = self.TopBarFrame,
	})

	-- Close button
	self.CloseButton = createElement("TextButton", {
		Name = "CloseButton",
		Text = "X",
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Size = UDim2.new(0, 28, 0, 24),
		Position = UDim2.new(1, -32, 0.5, -12),
		BackgroundColor3 = Library.Theme.Close,
		BorderSizePixel = 0,
		Parent = self.TopBarFrame,
	})
	addCorner(self.CloseButton, {1, 0})

	-- Minimize button
	self.MinimizeButton = createElement("TextButton", {
		Name = "MinimizeButton",
		Text = "—",
		Font = Library.Theme.Font,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Size = UDim2.new(0, 28, 0, 24),
		Position = UDim2.new(1, -64, 0.5, -12),
		BackgroundColor3 = Library.Theme.Minimize,
		BorderSizePixel = 0,
		Parent = self.TopBarFrame,
	})
	addCorner(self.MinimizeButton, {1, 0})

	-- Minimized buttons
	self.MinimizedCloseButton = self.CloseButton:Clone()
	self.MinimizedCloseButton.Name = "MinimizedCloseButton"
	self.MinimizedCloseButton.Parent = self.MinimizedBar
	self.MinimizedRestoreButton = self.MinimizeButton:Clone()
	self.MinimizedRestoreButton.Name = "MinimizedRestoreButton"
	self.MinimizedRestoreButton.Parent = self.MinimizedBar

	-- Drag logic
	local dragging = false
	local dragStartPos = nil
	local frameStartPos = nil
	local velocity = Vector2.new(0, 0)
	local lastInputPos = nil
	local lastInputTime = 0

	self.TopBarFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStartPos = input.Position
			if self.IsMinimized then
				frameStartPos = self.MinimizedBar.Position
			else
				frameStartPos = self.MainFrame.Position
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
			if self.IsMinimized then
				self.MinimizedBar.Position = newPos
			else
				self.MainFrame.Position = newPos
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			local speed = velocity.Magnitude
			if speed > 50 then
				local targetFrame = if self.IsMinimized then self.MinimizedBar else self.MainFrame
				local currentPos = targetFrame.Position
				local slideDistance = math.clamp(speed * 0.12, 20, 180)
				local direction = velocity.Unit
				local targetPos = UDim2.new(
					currentPos.X.Scale,
					currentPos.X.Offset + direction.X * slideDistance,
					currentPos.Y.Scale,
					currentPos.Y.Offset + direction.Y * slideDistance
				)
				if self.SlideTween then self.SlideTween:Cancel() end
				self.SlideTween = TweenService:Create(
					targetFrame,
					TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{Position = targetPos}
				)
				self.SlideTween:Play()
			end
			velocity = Vector2.new(0, 0)
			lastInputPos = nil
			lastInputTime = 0
		end
	end)

	-- Minimize button logic
	self.MinimizeButton.MouseButton1Click:Connect(function()
		if self.IsMinimized then
			self.IsMinimized = false
			self:_restore()
		else
			self.IsMinimized = true
			self:_minimize()
		end
	end)

	-- Close button logic
	local function onClose()
		if self.SlideTween then self.SlideTween:Cancel() end
		if self.MinimizeTween then self.MinimizeTween:Cancel() end
		if self.RestoreTween then self.RestoreTween:Cancel() end

		local fadeElements = {self.MainFrame, self.MinimizedBar, self.TopBarFrame, self.ContentFrame, self.TabBarFrame}
		for _, element in ipairs(fadeElements) do
			local fadeTween = TweenService:Create(
				element,
				TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
				{BackgroundTransparency = 1}
			)
			fadeTween:Play()
		end

		local centerPos = UDim2.new(
			self.MainFrame.Position.X.Scale,
			self.MainFrame.Position.X.Offset + self.MainFrame.Size.X.Offset / 2,
			self.MainFrame.Position.Y.Scale,
			self.MainFrame.Position.Y.Offset + self.MainFrame.Size.Y.Offset / 2
		)

		local scaleTween = TweenService:Create(
			self.MainFrame,
			TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
			{Size = UDim2.fromOffset(0, 0), Position = centerPos}
		)
		scaleTween:Play()
		scaleTween.Completed:Connect(function()
			screenGui:Destroy()
		end)
	end

	self.CloseButton.MouseButton1Click:Connect(onClose)
	self.MinimizedCloseButton.MouseButton1Click:Connect(onClose)

	-- Global keybind
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self.MinimizeKey then
			if self.MainFrame.Visible then
				self:_hideWithAnimation()
			else
				self:_showWithAnimation()
			end
		end
	end)

	self:_saveOriginalColors()
	table.insert(Library.Windows, self)
	return self
end

return Library
