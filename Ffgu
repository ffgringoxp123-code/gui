local Library = {}

function Library.CreateLib(WindowTitle, WindowIcon, ToggleKey)
	if typeof(WindowIcon) == "EnumItem" then
		ToggleKey = WindowIcon
		WindowIcon = nil
	end

	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local CoreGui = game:GetService("CoreGui")
	local Players = game:GetService("Players")

	local GuiName = tostring(WindowTitle or "Sakura")
	local parentGui = CoreGui

	local old = parentGui:FindFirstChild(GuiName)
	if old then
		old:Destroy()
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = GuiName
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.IgnoreGuiInset = true
	gui.Parent = parentGui

	local C = {
		Background = Color3.fromRGB(8, 10, 12),
		Main = Color3.fromRGB(12, 14, 17),
		Surface = Color3.fromRGB(16, 19, 22),
		Surface2 = Color3.fromRGB(20, 24, 28),
		Stroke = Color3.fromRGB(34, 44, 58),
		DeepBlue = Color3.fromRGB(23, 69, 122),
		LightBlue = Color3.fromRGB(139, 216, 255),
		Hover = Color3.fromRGB(24, 34, 46),
		Text = Color3.fromRGB(235, 239, 244),
		SubText = Color3.fromRGB(155, 165, 175),
		Success = Color3.fromRGB(210, 241, 255),
		Danger = Color3.fromRGB(255, 95, 95),
	}

	local function Corner(obj, radius)
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, radius or 6)
		c.Parent = obj
		return c
	end

	local function Stroke(obj, color, transparency, thickness)
		local s = Instance.new("UIStroke")
		s.Color = color or C.Stroke
		s.Transparency = transparency or 0
		s.Thickness = thickness or 1
		s.Parent = obj
		return s
	end

	local function Label(parent, text, size, font, pos, sizeUDim, color, align)
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Text = text or ""
		label.Font = font or Enum.Font.Gotham
		label.TextSize = size or 12
		label.TextColor3 = color or C.Text
		label.TextXAlignment = align or Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Center
		label.Position = pos or UDim2.new()
		label.Size = sizeUDim or UDim2.new()
		label.Parent = parent
		return label
	end

	local function HoverColor(btn, normal, hover)
		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.14), {
				BackgroundColor3 = hover
			}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.14), {
				BackgroundColor3 = normal
			}):Play()
		end)
	end

	local Window = {}
	Window.Hidden = false
	Window.CurrentDropdown = nil
	Window.CurrentColorPicker = nil
	Window.PageLayouts = {}
	Window.Pages = {}
	Window.NavButtons = {}
	Window.FirstTabName = nil

	local main = Instance.new("Frame")
	main.Size = UDim2.fromOffset(730, 430)
	main.Position = UDim2.new(0.5, -365, 0.5, -215)
	main.BackgroundColor3 = C.Background
	main.BorderSizePixel = 0
	main.Parent = gui
	Corner(main, 8)
	Stroke(main, C.Stroke, 0.25, 1)

	local scale = Instance.new("UIScale")
	scale.Scale = 0.96
	scale.Parent = main

	main.BackgroundTransparency = 1
	main.Position = main.Position + UDim2.fromOffset(0, 10)

	TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0,
		Position = UDim2.new(0.5, -365, 0.5, -215)
	}):Play()

	TweenService:Create(scale, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Scale = 1
	}):Play()

	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 54)
	header.BackgroundColor3 = C.Main
	header.BorderSizePixel = 0
	header.Parent = main
	Corner(header, 8)
	Stroke(header, C.Stroke, 0.25, 1)

	local headerFix = Instance.new("Frame")
	headerFix.Size = UDim2.new(1, 0, 0, 10)
	headerFix.Position = UDim2.new(0, 0, 1, -10)
	headerFix.BackgroundColor3 = C.Main
	headerFix.BorderSizePixel = 0
	headerFix.Parent = header

	local titleX = 16
	if WindowIcon and tostring(WindowIcon) ~= "" then
		local logoHolder = Instance.new("Frame")
		logoHolder.BackgroundColor3 = C.Surface2
		logoHolder.Size = UDim2.fromOffset(36, 36)
		logoHolder.Position = UDim2.fromOffset(11, 9)
		logoHolder.BorderSizePixel = 0
		logoHolder.Parent = header
		Corner(logoHolder, 10)
		Stroke(logoHolder, C.Stroke, 0.15, 1)

		local logo = Instance.new("ImageLabel")
		logo.BackgroundTransparency = 1
		logo.Size = UDim2.fromOffset(22, 22)
		logo.AnchorPoint = Vector2.new(0.5, 0.5)
		logo.Position = UDim2.new(0.5, 0, 0.5, 0)
		logo.Image = WindowIcon
		logo.ScaleType = Enum.ScaleType.Fit
		logo.BorderSizePixel = 0
		logo.Parent = logoHolder

		titleX = 58
	end

	Label(header, WindowTitle or "UI Library", 14, Enum.Font.GothamBold, UDim2.new(0, titleX, 0, 0), UDim2.new(0, 320, 1, 0), C.Text)

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.fromOffset(30, 30)
	closeBtn.Position = UDim2.new(1, -40, 0, 12)
	closeBtn.BackgroundColor3 = C.Surface
	closeBtn.BorderSizePixel = 0
	closeBtn.Text = "X"
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 12
	closeBtn.TextColor3 = C.Text
	closeBtn.AutoButtonColor = false
	closeBtn.Parent = header
	Corner(closeBtn, 6)

	closeBtn.MouseEnter:Connect(function()
		TweenService:Create(closeBtn, TweenInfo.new(0.14), {
			BackgroundColor3 = C.Danger
		}):Play()
	end)

	closeBtn.MouseLeave:Connect(function()
		TweenService:Create(closeBtn, TweenInfo.new(0.14), {
			BackgroundColor3 = C.Surface
		}):Play()
	end)

	local sidebar = Instance.new("Frame")
	sidebar.Size = UDim2.fromOffset(170, 352)
	sidebar.Position = UDim2.fromOffset(12, 66)
	sidebar.BackgroundColor3 = C.Main
	sidebar.BorderSizePixel = 0
	sidebar.Parent = main
	Corner(sidebar, 8)
	Stroke(sidebar, C.Stroke, 0.25, 1)

	local navHolder = Instance.new("Frame")
	navHolder.Size = UDim2.new(1, -16, 1, -16)
	navHolder.Position = UDim2.new(0, 8, 0, 8)
	navHolder.BackgroundTransparency = 1
	navHolder.Parent = sidebar

	local navLayout = Instance.new("UIListLayout")
	navLayout.Padding = UDim.new(0, 6)
	navLayout.Parent = navHolder

	local content = Instance.new("Frame")
	content.Size = UDim2.fromOffset(524, 352)
	content.Position = UDim2.fromOffset(194, 66)
	content.BackgroundTransparency = 1
	content.Parent = main

	local function CloseCurrentDropdown()
		if Window.CurrentDropdown and Window.CurrentDropdown.Close then
			Window.CurrentDropdown:Close()
			Window.CurrentDropdown = nil
		end
	end

	local function CloseCurrentColorPicker(except)
		if Window.CurrentColorPicker and Window.CurrentColorPicker ~= except then
			if Window.CurrentColorPicker.Close then
				Window.CurrentColorPicker:Close()
			end
		end
	end

	local function UpdatePageLayout(page)
		local data = Window.PageLayouts[page]
		if not data then return end

		local count = #data.Sections
		if count <= 1 then
			data.Left.Size = UDim2.fromOffset(524, 352)
			data.Right.Visible = false
		else
			data.Left.Size = UDim2.fromOffset(256, 352)
			data.Right.Visible = true
		end
	end

	local function ShowTab(name)
		for tabName, page in pairs(Window.Pages) do
			page.Visible = (tabName == name)
		end

		for tabName, data in pairs(Window.NavButtons) do
			local active = tabName == name
			data.Button.BackgroundColor3 = active and C.Surface2 or C.Surface
			data.Stroke.Color = active and C.LightBlue or C.Stroke
			data.Stroke.Transparency = active and 0.15 or 0.3
			data.Accent.BackgroundColor3 = active and C.LightBlue or C.DeepBlue
		end

		CloseCurrentDropdown()

		if Window.Pages[name] then
			UpdatePageLayout(Window.Pages[name])
		end
	end

	local function CreateNavButton(name, active)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 30)
		btn.BackgroundColor3 = active and C.Surface2 or C.Surface
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.Parent = navHolder
		Corner(btn, 6)

		local st = Stroke(btn, active and C.LightBlue or C.Stroke, active and 0.15 or 0.3, 1)

		local leftAccent = Instance.new("Frame")
		leftAccent.Size = UDim2.fromOffset(3, 14)
		leftAccent.Position = UDim2.new(0, 8, 0.5, -7)
		leftAccent.BackgroundColor3 = active and C.LightBlue or C.DeepBlue
		leftAccent.BorderSizePixel = 0
		leftAccent.Parent = btn
		Corner(leftAccent, 99)

		Label(btn, name, 11, Enum.Font.GothamMedium, UDim2.new(0, 18, 0, 0), UDim2.new(1, -24, 1, 0), C.Text)
		HoverColor(btn, btn.BackgroundColor3, C.Hover)

		btn.MouseButton1Click:Connect(function()
			ShowTab(name)
		end)

		Window.NavButtons[name] = {
			Button = btn,
			Stroke = st,
			Accent = leftAccent
		}
	end

	local function CreateColumn(parent, position, width)
		local column = Instance.new("ScrollingFrame")
		column.Size = UDim2.fromOffset(width, 352)
		column.Position = position
		column.BackgroundTransparency = 1
		column.BorderSizePixel = 0
		column.ScrollBarThickness = 0
		column.CanvasSize = UDim2.new(0, 0, 0, 0)
		column.ScrollingDirection = Enum.ScrollingDirection.Y
		column.Parent = parent

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 12)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Parent = column

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			column.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
		end)

		return column
	end

	local function CreateSection(parentColumn, title)
		local sec = Instance.new("Frame")
		sec.Size = UDim2.new(1, 0, 0, 38)
		sec.AutomaticSize = Enum.AutomaticSize.Y
		sec.BackgroundColor3 = C.Main
		sec.BorderSizePixel = 0
		sec.Parent = parentColumn
		Corner(sec, 8)
		Stroke(sec, C.Stroke, 0.35, 1)

		Label(sec, title, 12, Enum.Font.GothamMedium, UDim2.new(0, 10, 0, 8), UDim2.new(1, -20, 0, 16), C.Text)

		local holder = Instance.new("Frame")
		holder.BackgroundTransparency = 1
		holder.Position = UDim2.new(0, 0, 0, 28)
		holder.Size = UDim2.new(1, 0, 0, 0)
		holder.AutomaticSize = Enum.AutomaticSize.Y
		holder.Parent = sec

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 8)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Parent = holder

		local pad = Instance.new("UIPadding")
		pad.PaddingLeft = UDim.new(0, 8)
		pad.PaddingRight = UDim.new(0, 8)
		pad.PaddingTop = UDim.new(0, 8)
		pad.PaddingBottom = UDim.new(0, 8)
		pad.Parent = holder

		return sec, holder
	end

	local function CreateButton(parent, text, callback)
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(1, 0, 0, 32)
		button.BackgroundColor3 = C.Surface
		button.BorderSizePixel = 0
		button.Text = ""
		button.AutoButtonColor = false
		button.Parent = parent
		Corner(button, 6)

		local leftAccent = Instance.new("Frame")
		leftAccent.Size = UDim2.fromOffset(3, 14)
		leftAccent.Position = UDim2.new(0, 8, 0.5, -7)
		leftAccent.BackgroundColor3 = C.DeepBlue
		leftAccent.BorderSizePixel = 0
		leftAccent.Parent = button
		Corner(leftAccent, 99)

		local txt = Label(button, text, 11, Enum.Font.GothamMedium, UDim2.new(0, 18, 0, 0), UDim2.new(1, -24, 1, 0), C.Text)
		HoverColor(button, C.Surface, C.Hover)

		button.MouseButton1Click:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.08), {
				BackgroundColor3 = C.DeepBlue
			}):Play()
			task.wait(0.08)
			TweenService:Create(button, TweenInfo.new(0.12), {
				BackgroundColor3 = C.Surface
			}):Play()
			if callback then callback() end
		end)

		local obj = {}
		function obj:SetText(newText) txt.Text = tostring(newText) end
		function obj:GetText() return txt.Text end
		obj.Instance = button
		return obj
	end

	local function CreateToggle(parent, text, default, callback)
		local state = default or false

		local holder = Instance.new("TextButton")
		holder.Size = UDim2.new(1, 0, 0, 32)
		holder.BackgroundColor3 = C.Surface
		holder.BorderSizePixel = 0
		holder.Text = ""
		holder.AutoButtonColor = false
		holder.Parent = parent
		Corner(holder, 6)
		HoverColor(holder, C.Surface, C.Hover)

		Label(holder, text, 11, Enum.Font.GothamMedium, UDim2.new(0, 10, 0, 0), UDim2.new(1, -56, 1, 0), C.Text)

		local switch = Instance.new("Frame")
		switch.Size = UDim2.fromOffset(34, 16)
		switch.Position = UDim2.new(1, -42, 0.5, -8)
		switch.BackgroundColor3 = state and C.DeepBlue or C.Background
		switch.BorderSizePixel = 0
		switch.Parent = holder
		Corner(switch, 99)

		local knob = Instance.new("Frame")
		knob.Size = UDim2.fromOffset(12, 12)
		knob.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
		knob.BackgroundColor3 = state and C.Success or C.SubText
		knob.BorderSizePixel = 0
		knob.Parent = switch
		Corner(knob, 99)

		local function setValue(v)
			state = v
			TweenService:Create(switch, TweenInfo.new(0.14), {
				BackgroundColor3 = state and C.DeepBlue or C.Background
			}):Play()
			TweenService:Create(knob, TweenInfo.new(0.14), {
				Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
				BackgroundColor3 = state and C.Success or C.SubText
			}):Play()
			if callback then callback(state) end
		end

		holder.MouseButton1Click:Connect(function() setValue(not state) end)

		return {
			Set = setValue,
			Get = function() return state end
		}
	end

	local function CreateSlider(parent, text, min, max, default, hideValue, callback)
		local value = default or min
		local dragging = false

		local holder = Instance.new("Frame")
		holder.Size = UDim2.new(1, 0, 0, 42)
		holder.BackgroundColor3 = C.Surface
		holder.BorderSizePixel = 0
		holder.Parent = parent
		Corner(holder, 6)

		Label(holder, text, 11, Enum.Font.GothamMedium, UDim2.new(0, 10, 0, 8), UDim2.new(0.5, 0, 0, 12), C.Text)

		local valueText
		if not hideValue then
			valueText = Label(holder, "", 10, Enum.Font.GothamMedium, UDim2.new(1, -56, 0, 8), UDim2.new(0, 46, 0, 12), C.SubText, Enum.TextXAlignment.Right)
		end

		local sliderBack = Instance.new("Frame")
		sliderBack.Size = UDim2.new(1, -20, 0, 8)
		sliderBack.Position = UDim2.new(0, 10, 0, 26)
		sliderBack.BackgroundColor3 = C.Background
		sliderBack.BorderSizePixel = 0
		sliderBack.Parent = holder
		Corner(sliderBack, 99)

		local sliderFill = Instance.new("Frame")
		sliderFill.Size = UDim2.new(0, 0, 1, 0)
		sliderFill.BackgroundColor3 = C.DeepBlue
		sliderFill.BorderSizePixel = 0
		sliderFill.Parent = sliderBack
		Corner(sliderFill, 99)

		local knob = Instance.new("Frame")
		knob.Size = UDim2.fromOffset(12, 12)
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.Position = UDim2.new(1, 0, 0.5, 0)
		knob.BackgroundColor3 = C.Success
		knob.BorderSizePixel = 0
		knob.Parent = sliderFill
		Corner(knob, 99)

		local dragButton = Instance.new("TextButton")
		dragButton.Size = UDim2.new(1, 0, 1, 8)
		dragButton.Position = UDim2.new(0, 0, 0, -4)
		dragButton.BackgroundTransparency = 1
		dragButton.Text = ""
		dragButton.AutoButtonColor = false
		dragButton.Parent = sliderBack

		local function setValue(newValue)
			value = math.clamp(newValue, min, max)
			local alpha = (value - min) / (max - min)
			sliderFill.Size = UDim2.new(alpha, 0, 1, 0)
			if valueText then
				valueText.Text = tostring(math.floor(value))
			end
			if callback then callback(value) end
		end

		local function updateFromMouse(mouseX)
			local pos = sliderBack.AbsolutePosition.X
			local size = sliderBack.AbsoluteSize.X
			local alpha = math.clamp((mouseX - pos) / size, 0, 1)
			local calc = min + ((max - min) * alpha)
			setValue(math.floor(calc + 0.5))
		end

		dragButton.MouseButton1Down:Connect(function()
			dragging = true
			updateFromMouse(UserInputService:GetMouseLocation().X)
		end)

		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				updateFromMouse(input.Position.X)
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)

		setValue(default or min)

		return {
			Set = setValue,
			Get = function() return value end
		}
	end

	local function CreateTextbox(parent, text, placeholder, callback)
		local holder = Instance.new("Frame")
		holder.Size = UDim2.new(1, 0, 0, 32)
		holder.BackgroundColor3 = C.Surface
		holder.BorderSizePixel = 0
		holder.Parent = parent
		Corner(holder, 6)

		Label(holder, text, 11, Enum.Font.GothamMedium, UDim2.new(0, 10, 0, 0), UDim2.new(0.35, 0, 1, 0), C.Text)

		local box = Instance.new("TextBox")
		box.Size = UDim2.new(0.55, 0, 1, 0)
		box.Position = UDim2.new(1, -10, 0, 0)
		box.AnchorPoint = Vector2.new(1, 0)
		box.BackgroundTransparency = 1
		box.BorderSizePixel = 0
		box.Text = ""
		box.PlaceholderText = placeholder or "Type here..."
		box.TextColor3 = C.SubText
		box.PlaceholderColor3 = C.SubText
		box.Font = Enum.Font.GothamMedium
		box.TextSize = 11
		box.TextXAlignment = Enum.TextXAlignment.Right
		box.ClearTextOnFocus = false
		box.Parent = holder

		box.FocusLost:Connect(function()
			if callback then callback(box.Text) end
		end)

		return {
			Set = function(v) box.Text = tostring(v) end,
			Get = function() return box.Text end
		}
	end

	local function CreateKeybind(parent, text, default, callback)
		local current = default or Enum.KeyCode.F
		local waiting = false

		local holder = Instance.new("TextButton")
		holder.Size = UDim2.new(1, 0, 0, 32)
		holder.BackgroundColor3 = C.Surface
		holder.BorderSizePixel = 0
		holder.Text = ""
		holder.AutoButtonColor = false
		holder.Parent = parent
		Corner(holder, 6)
		HoverColor(holder, C.Surface, C.Hover)

		Label(holder, text, 11, Enum.Font.GothamMedium, UDim2.new(0, 10, 0, 0), UDim2.new(1, -80, 1, 0), C.Text)

		local bindBox = Instance.new("TextButton")
		bindBox.Size = UDim2.fromOffset(60, 20)
		bindBox.Position = UDim2.new(1, -68, 0.5, -10)
		bindBox.BackgroundColor3 = C.Surface2
		bindBox.BorderSizePixel = 0
		bindBox.Text = current.Name
		bindBox.Font = Enum.Font.GothamMedium
		bindBox.TextSize = 10
		bindBox.TextColor3 = C.SubText
		bindBox.AutoButtonColor = false
		bindBox.Parent = holder
		Corner(bindBox, 5)

		bindBox.MouseButton1Click:Connect(function()
			waiting = true
			bindBox.Text = "..."
		end)

		UserInputService.InputBegan:Connect(function(input, gp)
			if gp then return end
			if waiting and input.UserInputType == Enum.UserInputType.Keyboard then
				current = input.KeyCode
				bindBox.Text = current.Name
				waiting = false
				return
			end
			if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == current then
				if callback then callback() end
			end
		end)

		return {
			Set = function(key)
				current = key
				bindBox.Text = key.Name
			end,
			Get = function() return current end
		}
	end

	local function CreateDropdown(parent, text, items, default, callback)
		items = items or {}
		local current = default or items[1] or ""
		local open = false
		local closedHeight = 32

		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, closedHeight)
		row.BackgroundTransparency = 1
		row.ClipsDescendants = true
		row.Parent = parent

		local mainBtn = Instance.new("TextButton")
		mainBtn.Size = UDim2.new(1, 0, 0, 32)
		mainBtn.BackgroundColor3 = C.Surface
		mainBtn.BorderSizePixel = 0
		mainBtn.Text = ""
		mainBtn.AutoButtonColor = false
		mainBtn.Parent = row
		Corner(mainBtn, 6)
		HoverColor(mainBtn, C.Surface, C.Hover)

		Label(mainBtn, text, 11, Enum.Font.GothamMedium, UDim2.new(0, 10, 0, 0), UDim2.new(0.42, 0, 1, 0), C.Text)
		local valueText = Label(mainBtn, tostring(current), 11, Enum.Font.GothamMedium, UDim2.new(0.5, 0, 0, 0), UDim2.new(0.5, -10, 1, 0), C.SubText, Enum.TextXAlignment.Right)

		local list = Instance.new("Frame")
		list.Size = UDim2.new(1, 0, 0, 0)
		list.Position = UDim2.new(0, 0, 0, 36)
		list.BackgroundColor3 = C.Main
		list.BorderSizePixel = 0
		list.ClipsDescendants = true
		list.Parent = row
		Corner(list, 6)

		local listPadding = Instance.new("UIPadding")
		listPadding.PaddingTop = UDim.new(0, 4)
		listPadding.PaddingBottom = UDim.new(0, 4)
		listPadding.PaddingLeft = UDim.new(0, 4)
		listPadding.PaddingRight = UDim.new(0, 4)
		listPadding.Parent = list

		local listLayout = Instance.new("UIListLayout")
		listLayout.Padding = UDim.new(0, 4)
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Parent = list

		local function getListHeight()
			if #items <= 0 then return 0 end
			return (#items * 24) + ((#items - 1) * 4) + 8
		end

		local function getOpenHeight()
			return 36 + getListHeight()
		end

		local function setValue(v)
			current = v
			valueText.Text = tostring(v)
			if callback then callback(v) end
		end

		local dropdownObj = {}

		function dropdownObj:Close()
			open = false
			TweenService:Create(list, TweenInfo.new(0.16), { Size = UDim2.new(1, 0, 0, 0) }):Play()
			TweenService:Create(row, TweenInfo.new(0.16), { Size = UDim2.new(1, 0, 0, closedHeight) }):Play()
			if Window.CurrentDropdown == dropdownObj then
				Window.CurrentDropdown = nil
			end
		end

		function dropdownObj:Open()
			if #items <= 0 then return end
			if Window.CurrentDropdown and Window.CurrentDropdown ~= dropdownObj then
				Window.CurrentDropdown:Close()
			end
			open = true
			Window.CurrentDropdown = dropdownObj

			TweenService:Create(row, TweenInfo.new(0.16), { Size = UDim2.new(1, 0, 0, getOpenHeight()) }):Play()
			TweenService:Create(list, TweenInfo.new(0.16), { Size = UDim2.new(1, 0, 0, getListHeight()) }):Play()
		end

		local function buildOptions()
			for _, child in ipairs(list:GetChildren()) do
				if child:IsA("TextButton") then child:Destroy() end
			end
			for _, item in ipairs(items) do
				local option = Instance.new("TextButton")
				option.Size = UDim2.new(1, 0, 0, 24)
				option.BackgroundColor3 = C.Surface2
				option.BorderSizePixel = 0
				option.Text = tostring(item)
				option.Font = Enum.Font.GothamMedium
				option.TextSize = 10
				option.TextColor3 = C.Text
				option.TextXAlignment = Enum.TextXAlignment.Left
				option.AutoButtonColor = false
				option.Parent = list
				Corner(option, 5)

				local p = Instance.new("UIPadding")
				p.PaddingLeft = UDim.new(0, 8)
				p.Parent = option
				HoverColor(option, C.Surface2, C.Hover)

				option.MouseButton1Click:Connect(function()
					setValue(item)
					dropdownObj:Close()
				end)
			end
		end

		buildOptions()
		row.Size = UDim2.new(1, 0, 0, closedHeight)
		list.Size = UDim2.new(1, 0, 0, 0)

		mainBtn.MouseButton1Click:Connect(function()
			if open then dropdownObj:Close() else dropdownObj:Open() end
		end)

		local obj = {}
		function obj:Set(v) setValue(v) end
		function obj:Get() return current end
		function obj:Refresh(newItems)
			items = newItems or {}
			if not table.find(items, current) then current = items[1] or "" end
			valueText.Text = tostring(current)
			buildOptions()
			if open then
				row.Size = UDim2.new(1, 0, 0, getOpenHeight())
				list.Size = UDim2.new(1, 0, 0, getListHeight())
			else
				row.Size = UDim2.new(1, 0, 0, closedHeight)
				list.Size = UDim2.new(1, 0, 0, 0)
			end
		end
		function obj:Close() dropdownObj:Close() end
		return obj
	end

	local function CreateLabelComponent(parent, text)
		local holder = Instance.new("Frame")
		holder.Size = UDim2.new(1, 0, 0, 28)
		holder.BackgroundColor3 = C.Surface
		holder.BorderSizePixel = 0
		holder.Parent = parent
		Corner(holder, 6)

		local lbl = Label(holder, text, 11, Enum.Font.GothamMedium, UDim2.new(0, 10, 0, 0), UDim2.new(1, -20, 1, 0), C.SubText)

		local obj = {}
		function obj:SetText(newText) lbl.Text = tostring(newText) end
		function obj:GetText() return lbl.Text end
		return obj
	end

	local function CreateColorPicker(parent, text, default, callback)
		local current = default or Color3.fromRGB(255, 255, 255)
		local open = false

		local holder = Instance.new("TextButton")
		holder.Size = UDim2.new(1, 0, 0, 32)
		holder.BackgroundColor3 = C.Surface
		holder.BorderSizePixel = 0
		holder.Text = ""
		holder.AutoButtonColor = false
		holder.Parent = parent
		Corner(holder, 6)
		HoverColor(holder, C.Surface, C.Hover)

		Label(holder, text, 11, Enum.Font.GothamMedium, UDim2.new(0, 10, 0, 0), UDim2.new(0.6, 0, 1, 0), C.Text)

		local preview = Instance.new("Frame")
		preview.Size = UDim2.fromOffset(18, 18)
		preview.Position = UDim2.new(1, -28, 0.5, -9)
		preview.BackgroundColor3 = current
		preview.BorderSizePixel = 0
		preview.Parent = holder
		Corner(preview, 5)

		local pickerPanel = Instance.new("Frame")
		pickerPanel.Size = UDim2.fromOffset(188, 170)
		pickerPanel.BackgroundColor3 = C.Main
		pickerPanel.BorderSizePixel = 0
		pickerPanel.Visible = false
		pickerPanel.Parent = main 
		pickerPanel.AnchorPoint = Vector2.new(0, 0)
		Corner(pickerPanel, 8)
		Stroke(pickerPanel, C.Stroke, 0.2, 1)

		local satVal = Instance.new("ImageLabel")
		satVal.Size = UDim2.fromOffset(150, 150)
		satVal.Position = UDim2.fromOffset(10, 10)
		satVal.BackgroundColor3 = Color3.fromHSV(0, 1, 1)
		satVal.BorderSizePixel = 0
		satVal.Image = "rbxassetid://4155801252"
		satVal.ScaleType = Enum.ScaleType.Stretch
		satVal.Parent = pickerPanel
		Corner(satVal, 6)

		local satValBtn = Instance.new("TextButton")
		satValBtn.Size = UDim2.new(1, 0, 1, 0)
		satValBtn.BackgroundTransparency = 1
		satValBtn.Text = ""
		satValBtn.Parent = satVal

		local hueBar = Instance.new("Frame")
		hueBar.Size = UDim2.fromOffset(14, 150)
		hueBar.Position = UDim2.fromOffset(164, 10)
		hueBar.BorderSizePixel = 0
		hueBar.Parent = pickerPanel
		Corner(hueBar, 6)

		local hueGradient = Instance.new("UIGradient")
		hueGradient.Rotation = 90
		hueGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
		})
		hueGradient.Parent = hueBar

		local hueBtn = Instance.new("TextButton")
		hueBtn.Size = UDim2.new(1, 0, 1, 0)
		hueBtn.BackgroundTransparency = 1
		hueBtn.Text = ""
		hueBtn.Parent = hueBar

		local hue = 0
		local sat = 1
		local val = 1

		local function applyColor()
			local col = Color3.fromHSV(hue, sat, val)
			current = col
			preview.BackgroundColor3 = col
			satVal.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
			if callback then callback(col) end
		end

		do
			local h, s, v = Color3.toHSV(current)
			hue = h
			sat = s
			val = v
			applyColor()
		end

		local function dragSV()
			local moveConn, endConn
			local function update()
				local mouse = UserInputService:GetMouseLocation()
				local x = math.clamp(mouse.X - satVal.AbsolutePosition.X, 0, satVal.AbsoluteSize.X)
				local y = math.clamp(mouse.Y - satVal.AbsolutePosition.Y, 0, satVal.AbsoluteSize.Y)
				sat = x / satVal.AbsoluteSize.X
				val = 1 - (y / satVal.AbsoluteSize.Y)
				applyColor()
			end
			update()
			moveConn = UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then update() end
			end)
			endConn = UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					moveConn:Disconnect()
					endConn:Disconnect()
				end
			end)
		end

		local function dragHue()
			local moveConn, endConn
			local function update()
				local mouse = UserInputService:GetMouseLocation()
				local y = math.clamp(mouse.Y - hueBar.AbsolutePosition.Y, 0, hueBar.AbsoluteSize.Y)
				hue = y / hueBar.AbsoluteSize.Y
				applyColor()
			end
			update()
			moveConn = UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then update() end
			end)
			endConn = UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					moveConn:Disconnect()
					endConn:Disconnect()
				end
			end)
		end

		satValBtn.MouseButton1Down:Connect(dragSV)
		hueBtn.MouseButton1Down:Connect(dragHue)

		local pickerObj = {}

		function pickerObj:Close()
			open = false
			pickerPanel.Visible = false
			if Window.CurrentColorPicker == pickerObj then
				Window.CurrentColorPicker = nil
			end
		end

		function pickerObj:Open()
			CloseCurrentColorPicker(pickerObj)
			open = true
			Window.CurrentColorPicker = pickerObj
			pickerPanel.AnchorPoint = Vector2.new(0, 0)
			pickerPanel.Position = UDim2.new(1, 10, 0, 0) 
			pickerPanel.Visible = true
		end

		holder.MouseButton1Click:Connect(function()
			if open then pickerObj:Close() else pickerObj:Open() end
		end)

		pickerObj.Panel = pickerPanel

		local obj = {}
		function obj:Set(col)
			current = col
			local h, s, v = Color3.toHSV(col)
			hue = h
			sat = s
			val = v
			applyColor()
		end
		function obj:Get() return current end
		function obj:Close() pickerObj:Close() end
		return obj
	end

	function Window:NewTab(name)
		local Tab = {}

		local page = Instance.new("Frame")
		page.Name = name
		page.Size = UDim2.new(1, 0, 1, 0)
		page.BackgroundTransparency = 1
		page.Visible = false
		page.Parent = content

		Window.Pages[name] = page

		local leftColumn = CreateColumn(page, UDim2.fromOffset(0, 0), 256)
		local rightColumn = CreateColumn(page, UDim2.fromOffset(268, 0), 256)
		rightColumn.Visible = false

		Window.PageLayouts[page] = {
			Left = leftColumn,
			Right = rightColumn,
			Sections = {}
		}

		local isFirst = Window.FirstTabName == nil
		if isFirst then
			Window.FirstTabName = name
		end

		CreateNavButton(name, isFirst)

		if isFirst then
			ShowTab(name)
		end

		function Tab:NewSection(title)
			local layoutData = Window.PageLayouts[page]
			local count = #layoutData.Sections
			
			local targetColumn = (count % 2 == 0) and layoutData.Left or layoutData.Right

			local _, secHolder = CreateSection(targetColumn, title)
			table.insert(layoutData.Sections, secHolder)
			
			UpdatePageLayout(page)

			local Section = {}

			function Section:NewButton(text, callback) return CreateButton(secHolder, text, callback) end
			function Section:NewToggle(text, default, callback) return CreateToggle(secHolder, text, default, callback) end
			function Section:NewSlider(text, min, max, default, hideValue, callback) return CreateSlider(secHolder, text, min, max, default, hideValue, callback) end
			function Section:NewTextbox(text, placeholder, callback) return CreateTextbox(secHolder, text, placeholder, callback) end
			function Section:NewDropdown(text, items, default, callback) return CreateDropdown(secHolder, text, items, default, callback) end
			function Section:NewKeybind(text, default, callback) return CreateKeybind(secHolder, text, default, callback) end
			function Section:NewLabel(text) return CreateLabelComponent(secHolder, text) end
			function Section:NewColorPicker(text, default, callback) return CreateColorPicker(secHolder, text, default, callback) end

			return Section
		end

		return Tab
	end

	function Window:Toggle()
		Window.Hidden = not Window.Hidden
		gui.Enabled = not Window.Hidden
		if Window.Hidden then
			CloseCurrentDropdown()
			CloseCurrentColorPicker()
		end
	end

	function Window:Destroy()
		gui:Destroy()
	end

	closeBtn.MouseButton1Click:Connect(function() Window:Destroy() end)

	if ToggleKey then
		UserInputService.InputBegan:Connect(function(input, gp)
			if gp then return end
			if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == ToggleKey then
				Window:Toggle()
			end
		end)
	end

	do
		local dragging = false
		local dragStart
		local startPos

		header.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = input.Position
				startPos = main.Position
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = input.Position - dragStart
				main.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)
	end

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			CloseCurrentDropdown()
		end
	end)


	-- Sakura Falling Petals Effect
	do
		local RunService = game:GetService("RunService")

		local petalHolder = Instance.new("Frame")
		petalHolder.Size = UDim2.new(1,0,1,0)
		petalHolder.BackgroundTransparency = 1
		petalHolder.ZIndex = 0
		petalHolder.Parent = gui

		task.spawn(function()
			while gui.Parent do
				local petal = Instance.new("TextLabel")
				petal.BackgroundTransparency = 1
				petal.Text = "❀"
				petal.TextColor3 = Color3.fromRGB(255,182,193)
				petal.TextSize = math.random(18,32)
				petal.Size = UDim2.fromOffset(30,30)
				petal.Position = UDim2.new(math.random(),0,-0.1,0)
				petal.Rotation = math.random(-45,45)
				petal.Parent = petalHolder

				task.spawn(function()
					local start = tick()
					local duration = math.random(5,9)
					local startX = petal.Position.X.Scale
					while petal.Parent and tick()-start < duration do
						local t = (tick()-start)/duration
						petal.Position = UDim2.new(
							startX + math.sin(t*6)*0.03,
							0,
							-0.1 + (1.2*t),
							0
						)
						petal.Rotation += 0.5
						RunService.RenderStepped:Wait()
					end
					petal:Destroy()
				end)

				task.wait(0.25)
			end
		end)
	end

	return Window
end

return Library
