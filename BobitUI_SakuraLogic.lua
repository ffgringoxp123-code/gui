--[[
	Bobit UI (merged build)
	- UI/skin: Bobit — dark/blue theme, mobile scaling (s()), image-icon
	  minimize button that shrinks the whole window to a corner pill,
	  flat icon+label sidebar tabs with a slide-in indicator bar.
	- Logic: Sakura — expandable modules with real AutomaticSize-driven
	  height animation, full control set (toggle/slider/dropdown/
	  multi-dropdown/color picker/textbox/keybind/button), JSON settings
	  persistence, live theme switching via the auto-appended Settings tab.
--]]

local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")
local Players        = game:GetService("Players")
local HttpService    = game:GetService("HttpService")
local Lighting       = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}
Library.__index = Library

----------------------------------------------------------------
-- UI: Bobit-style mobile scaling (kept from Bobit's UI layer)
----------------------------------------------------------------
local function getMobileScale()
	local ok, viewport = pcall(function() return workspace.CurrentCamera.ViewportSize end)
	local isMobile = UserInputService.TouchEnabled and ok and viewport.X < 1024
	if isMobile then return 0.8 end
	return 1
end
local Scale = getMobileScale()
local function s(n)
	return math.round(n * Scale)
end

----------------------------------------------------------------
-- THEMES
----------------------------------------------------------------
Library.Themes = {
	["Bobit Dark"] = {
		Background            = Color3.fromRGB(15, 15, 18),
		BackgroundTransparency = 0,
		Sidebar                = Color3.fromRGB(22, 22, 26),
		SidebarTransparency    = 1,
		Module                 = Color3.fromRGB(20, 20, 24),
		ModuleTransparency     = 0,
		Primary                = Color3.fromRGB(0, 80, 255),
		Border                 = Color3.fromRGB(0, 80, 255),
		Text                   = Color3.fromRGB(0, 80, 255),
		SubText                = Color3.fromRGB(0, 80, 255),
		Icon                   = Color3.fromRGB(0, 80, 255),
	},
	["Sakura Light"] = {
		Background            = Color3.fromRGB(255, 205, 224),
		BackgroundTransparency = 1,
		Sidebar                = Color3.fromRGB(255, 196, 219),
		SidebarTransparency    = 1,
		Module                 = Color3.fromRGB(255, 224, 236),
		ModuleTransparency     = 1,
		Primary                = Color3.fromRGB(255, 133, 178),
		Border                 = Color3.fromRGB(219, 90, 138),
		Text                   = Color3.fromRGB(138, 88, 103),
		SubText                = Color3.fromRGB(178, 128, 143),
		Icon                   = Color3.fromRGB(255, 133, 178),
	},
	["Sakura Dark"] = {
		Background            = Color3.fromRGB(42, 22, 32),
		BackgroundTransparency = 1,
		Sidebar                = Color3.fromRGB(34, 17, 26),
		SidebarTransparency    = 1,
		Module                 = Color3.fromRGB(50, 27, 38),
		ModuleTransparency     = 1,
		Primary                = Color3.fromRGB(255, 133, 178),
		Border                 = Color3.fromRGB(196, 74, 122),
		Text                   = Color3.fromRGB(240, 222, 227),
		SubText                = Color3.fromRGB(173, 145, 154),
		Icon                   = Color3.fromRGB(255, 133, 178),
	},
}

local SETTINGS_FOLDER = "Bobit_UI"
local SETTINGS_FILE   = "Bobit_UI/Settings.json"

----------------------------------------------------------------
-- UTILITIES
----------------------------------------------------------------
local function Create(class, props, children)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do
		inst[k] = v
	end
	for _, child in ipairs(children or {}) do
		child.Parent = inst
	end
	return inst
end

local function Tween(inst, props, duration, style, direction)
	duration = duration or 0.25
	style = style or Enum.EasingStyle.Quint
	direction = direction or Enum.EasingDirection.Out
	local tw = TweenService:Create(inst, TweenInfo.new(duration, style, direction), props)
	tw:Play()
	return tw
end

local function Corner(radius)
	return Create("UICorner", {CornerRadius = UDim.new(0, radius or 12)})
end

local function Stroke(color, thickness)
	return Create("UIStroke", {
		Color = color,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end

local function Ripple(button, color)
	color = color or Color3.new(1, 1, 1)
	local ok, mouse = pcall(function() return UserInputService:GetMouseLocation() end)
	if not ok then return end

	local rel = mouse - button.AbsolutePosition
	local rip = Create("Frame", {
		Name = "Ripple",
		BackgroundColor3 = color,
		BackgroundTransparency = 0.65,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0, rel.X, 0, rel.Y),
		ZIndex = (button.ZIndex or 1) + 5,
		Parent = button,
	})
	Corner(50).Parent = rip

	local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.6
	Tween(rip, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.5)
	task.delay(0.5, function()
		if rip then rip:Destroy() end
	end)
end

local function Hover(inst, hoverColor, normalColorFn)
	inst.MouseEnter:Connect(function()
		Tween(inst, {BackgroundColor3 = hoverColor, BackgroundTransparency = 0.8}, 0.15)
	end)
	inst.MouseLeave:Connect(function()
		Tween(inst, {BackgroundColor3 = normalColorFn(), BackgroundTransparency = 1}, 0.15)
	end)
end

local function Fade(inst, visible, duration)
	duration = duration or 0.2
	if visible then
		inst.Visible = true
		if inst:IsA("Frame") or inst:IsA("ScrollingFrame") then
			Tween(inst, {BackgroundTransparency = inst:GetAttribute("_bgT") or 0}, duration)
		end
	else
		if inst:IsA("Frame") or inst:IsA("ScrollingFrame") then
			inst:SetAttribute("_bgT", inst.BackgroundTransparency)
			Tween(inst, {BackgroundTransparency = 1}, duration)
		end
		task.delay(duration, function()
			if inst then inst.Visible = false end
		end)
	end
end

local function ApplyShine(label, baseColor)
	local grad = Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, baseColor),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 250, 235)),
			ColorSequenceKeypoint.new(1, baseColor),
		}),
		Offset = Vector2.new(-1, 0),
		Parent = label,
	})
	task.spawn(function()
		while grad.Parent do
			grad.Offset = Vector2.new(-1, 0)
			local tw = Tween(grad, {Offset = Vector2.new(1, 0)}, 2.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
			tw.Completed:Wait()
			task.wait(0.4)
		end
	end)
	return grad
end

----------------------------------------------------------------
-- PERSISTENCE
----------------------------------------------------------------
local function SaveJSON(data)
	local ok = pcall(function()
		if not isfolder or not isfolder(SETTINGS_FOLDER) then
			if makefolder then makefolder(SETTINGS_FOLDER) end
		end
		writefile(SETTINGS_FILE, HttpService:JSONEncode(data))
	end)
	return ok
end

local function LoadJSON()
	local result
	pcall(function()
		if isfile and isfile(SETTINGS_FILE) then
			result = HttpService:JSONDecode(readfile(SETTINGS_FILE))
		end
	end)
	return result
end

----------------------------------------------------------------
-- LIBRARY CONSTRUCTOR
----------------------------------------------------------------
function Library.new(config)
	config = config or {}
	local self = setmetatable({}, Library)

	self.Title = config.Title or "Bobit Free"
	self.ThemeName = config.Theme or "Bobit Dark"
	self.Theme = Library.Themes[self.ThemeName] or Library.Themes["Bobit Dark"]
	self.Tabs = {}
	self.Minimized = false

	-- try to load saved settings (theme/colors) before building
	local saved = LoadJSON()
	if saved then
		if saved.Theme and Library.Themes[saved.Theme] then
			self.ThemeName = saved.Theme
			self.Theme = Library.Themes[saved.Theme]
		end
		if saved.Custom then
			for k, v in pairs(saved.Custom) do
				if self.Theme[k] and typeof(v) == "table" then
					self.Theme[k] = Color3.fromRGB(v[1], v[2], v[3])
				end
			end
		end
	end
	self.SavedSettings = saved

	----------------------------------------------------------------
	-- ROOT GUI (Bobit-style: destroy previous instance, mobile-scaled size)
	----------------------------------------------------------------
	local ParentUI = PlayerGui
	local okCore, coregui = pcall(function() return game:GetService("CoreGui") end)
	if okCore and coregui then ParentUI = coregui end

	local OldUI = ParentUI:FindFirstChild("Bobit_UI")
	if OldUI then OldUI:Destroy() end

	local screenGui = Create("ScreenGui", {
		Name = "Bobit_UI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = ParentUI,
	})
	self.ScreenGui = screenGui

	local BASE_W, BASE_H = 580, 340
	local BASE_MINI_W, BASE_MINI_H = 135, 42
	self.FullSize = UDim2.new(0, s(BASE_W), 0, s(BASE_H))
	self.MiniSize = UDim2.new(0, s(BASE_MINI_W), 0, s(BASE_MINI_H))
	self.SidebarWidth = s(115)

	local main = Create("Frame", {
		Name = "Main",
		Size = self.FullSize,
		Position = UDim2.new(0.5, -s(BASE_W / 2), 0.5, -s(BASE_H / 2)),
		BackgroundColor3 = self.Theme.Background,
		BackgroundTransparency = self.Theme.BackgroundTransparency or 0,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = screenGui,
	})
	Corner(s(14)).Parent = main
	local mainStroke = Stroke(self.Theme.Border, 1.5)
	mainStroke.Parent = main
	self.Main = main
	self.MainStroke = mainStroke

	-- drop shadow
	local shadow = Create("ImageLabel", {
		Name = "Shadow",
		BackgroundTransparency = 1,
		Image = "rbxassetid://1316045217",
		ImageColor3 = Color3.new(0, 0, 0),
		ImageTransparency = 0.5,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 118, 118),
		Size = UDim2.new(1, 60, 1, 60),
		Position = UDim2.new(0, -30, 0, -30),
		ZIndex = 0,
		Parent = main,
	})
	self.Shadow = shadow

	-- optional background blur
	if config.Blur then
		local blur = Create("BlurEffect", {Size = 14, Parent = Lighting})
		self.Blur = blur
	end

	----------------------------------------------------------------
	-- TOP BAR (title, minimize) — Bobit style
	----------------------------------------------------------------
	local topBar = Create("Frame", {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, s(42)),
		BackgroundTransparency = 1,
		Parent = main,
	})

	-- invisible hit-area behind the bar's visible elements: handles dragging and,
	-- while minimized, reopening the UI by clicking anywhere on the collapsed bar
	local hitArea = Create("TextButton", {
		Name = "HitArea",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		Parent = topBar,
	})

	local titleLabel = Create("TextLabel", {
		Name = "Title",
		Size = UDim2.new(0, s(150), 1, 0),
		Position = UDim2.new(0, s(17), 0, 0),
		BackgroundTransparency = 1,
		Text = self.Title,
		Font = Enum.Font.GothamBold,
		TextSize = s(15),
		TextColor3 = Color3.fromRGB(0, 120, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 2,
		Parent = topBar,
	})
	self.TitleLabel = titleLabel
	self.TitleGradient = Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 80, 80)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 255)),
		}),
		Parent = titleLabel,
	})
	task.spawn(function()
		while screenGui.Parent do
			local tw = TweenService:Create(self.TitleGradient, TweenInfo.new(2, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)})
			self.TitleGradient.Offset = Vector2.new(-1, 0)
			tw:Play()
			tw.Completed:Wait()
		end
	end)

	local minimizeBtn = Create("ImageButton", {
		Name = "MinBtn",
		Size = UDim2.new(0, s(26), 0, s(26)),
		Position = UDim2.new(1, -s(35), 0.5, -s(13)),
		BackgroundColor3 = Color3.fromRGB(35, 35, 40),
		BackgroundTransparency = 0,
		Image = "rbxassetid://74409172057180",
		ScaleType = Enum.ScaleType.Fit,
		ZIndex = 3,
		Parent = topBar,
	})
	Corner(s(8)).Parent = minimizeBtn

	----------------------------------------------------------------
	-- SIDEBAR
	----------------------------------------------------------------
	local sidebar = Create("Frame", {
		Name = "Sidebar",
		Size = UDim2.new(0, self.SidebarWidth, 1, -s(44)),
		Position = UDim2.new(0, 1, 0, s(43)),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = main,
	})
	self.Sidebar = sidebar

	local tabList = Create("Frame", {
		Name = "TabList",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = sidebar,
	})
	Create("UIListLayout", {
		Padding = UDim.new(0, s(5)),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
	}).Parent = tabList
	Create("UIPadding", {
		PaddingTop = UDim.new(0, s(10)),
	}).Parent = tabList
	self.TabList = tabList

	local sep = Create("Frame", {
		Name = "Sep",
		BackgroundColor3 = self.Theme.Primary,
		BackgroundTransparency = 0.8,
		BorderSizePixel = 0,
		Position = UDim2.new(0, self.SidebarWidth, 0, s(10)),
		Size = UDim2.new(0, 1, 1, -s(20)),
		Parent = main,
	})
	self.Sep = sep

	----------------------------------------------------------------
	-- CONTENT AREA
	----------------------------------------------------------------
	local content = Create("Frame", {
		Name = "Content",
		Size = UDim2.new(1, -self.SidebarWidth - 2, 1, -s(44)),
		Position = UDim2.new(0, self.SidebarWidth + 1, 0, s(43)),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = main,
	})
	self.Content = content

	----------------------------------------------------------------
	-- MINIMIZE BEHAVIOR (Bobit style: shrink whole window to a small
	-- corner pill; ClipsDescendants on Main hides sidebar/content)
	----------------------------------------------------------------
	local function setMinimized(state)
		self.Minimized = state
		Tween(main, {Size = state and self.MiniSize or self.FullSize}, 0.4, Enum.EasingStyle.Quart)
	end
	self.SetMinimized = setMinimized

	minimizeBtn.MouseButton1Click:Connect(function()
		setMinimized(not self.Minimized)
	end)

	----------------------------------------------------------------
	-- DRAGGING + CLICK-TO-REOPEN (shared on the top-bar hit area)
	----------------------------------------------------------------
	do
		local dragging, dragStart, startPos, draggedFar
		hitArea.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				draggedFar = false
				dragStart = input.Position
				startPos = main.Position
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - dragStart
				if delta.Magnitude > 5 then draggedFar = true end
				main.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch) then
				dragging = false
				if not draggedFar and self.Minimized then
					setMinimized(false)
				end
			end
		end)
	end

	self:_BuildSettingsTabLater()

	return self
end

----------------------------------------------------------------
-- APPLY THEME (used by Settings tab live-preview)
----------------------------------------------------------------
function Library:ApplyTheme()
	local t = self.Theme
	self.Main.BackgroundColor3 = t.Background
	self.Main.BackgroundTransparency = t.BackgroundTransparency or 0
	if self.MainStroke then self.MainStroke.Color = t.Border end
	self.Sidebar.BackgroundTransparency = t.SidebarTransparency or 0
	self.TitleLabel.TextColor3 = Color3.fromRGB(0, 120, 255)
	if self.TitleGradient then
		self.TitleGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 80, 80)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 255)),
		})
	end
	if self.Sep then self.Sep.BackgroundColor3 = t.Primary end
	for _, tab in ipairs(self.Tabs) do
		tab.Indicator.BackgroundColor3 = t.Primary
		tab.Update(self.ActiveTab == tab)
		for _, scroll in ipairs({tab.LeftScroll, tab.RightScroll}) do
			for _, mod in ipairs(scroll:GetChildren()) do
				if mod:IsA("Frame") and mod:GetAttribute("IsModule") then
					mod.BackgroundColor3 = t.Module
					mod.BackgroundTransparency = t.ModuleTransparency or 0
					local st = mod:FindFirstChildOfClass("UIStroke")
					if st then st.Color = t.Border end
				end
			end
		end
	end
end

function Library:SaveSettings()
	local custom = {}
	for k, v in pairs(self.Theme) do
		if typeof(v) == "Color3" then
			custom[k] = {math.floor(v.R * 255), math.floor(v.G * 255), math.floor(v.B * 255)}
		end
	end
	SaveJSON({Theme = self.ThemeName, Custom = custom})
end

----------------------------------------------------------------
-- TAB CREATION
----------------------------------------------------------------
function Library:CreateTab(name, icon)
	local t = self.Theme
	local isFirst = (#self.Tabs == 0)

	-- outer button only participates in the sidebar's list layout / hit area;
	-- the inner "Card" is what actually moves when the tab becomes active,
	-- so it can rise without UIListLayout fighting a manual Position tween
	local btn = Create("TextButton", {
		Name = name,
		Size = UDim2.new(0.9, 0, 0, s(35)),
		BackgroundColor3 = Color3.fromRGB(15, 15, 18),
		BackgroundTransparency = 0,
		AutoButtonColor = false,
		Text = "",
		LayoutOrder = #self.Tabs + 1,
		Parent = self.TabList,
	})
	Corner(s(6)).Parent = btn

	local indicator = Create("Frame", {
		Name = "Indicator",
		Size = UDim2.new(0, s(2), 0, s(16)),
		Position = UDim2.new(0, s(6), 0.5, -s(8)),
		BackgroundColor3 = t.Primary,
		BorderSizePixel = 0,
		Visible = false,
		Parent = btn,
	})
	Corner(s(50)).Parent = indicator

	local ic = Create("ImageLabel", {
		Size = UDim2.new(0, s(18), 0, s(18)),
		Position = UDim2.new(0, s(16), 0.5, -s(9)),
		BackgroundTransparency = 1,
		Image = icon or "rbxassetid://7733960981",
		ImageColor3 = Color3.fromRGB(150, 150, 150),
		Parent = btn,
	})

	local lbl = Create("TextLabel", {
		Size = UDim2.new(1, -s(40), 1, 0),
		Position = UDim2.new(0, s(40), 0, 0),
		BackgroundTransparency = 1,
		Text = name,
		Font = Enum.Font.GothamBold,
		TextSize = s(11),
		TextColor3 = Color3.fromRGB(150, 150, 150),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = btn,
	})

	local function updateVisuals(selected)
		local targetColor = selected and t.Primary or Color3.fromRGB(150, 150, 150)
		local bgColor = selected and Color3.fromRGB(17, 17, 22) or Color3.fromRGB(15, 15, 18)
		Tween(btn, {BackgroundColor3 = bgColor}, 0.2)
		Tween(ic, {ImageColor3 = targetColor}, 0.2)
		Tween(lbl, {TextColor3 = targetColor}, 0.2)
		indicator.Visible = selected
	end

	-- page holding two scroll columns
	local page = Create("Frame", {
		Name = name .. "_Page",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Visible = isFirst,
		Parent = self.Content,
	})
	page:SetAttribute("_bgT", 1) -- keep pages fully transparent through Fade()

	local leftScroll = Create("ScrollingFrame", {
		Size = UDim2.new(0.5, -s(12), 1, -s(16)),
		Position = UDim2.new(0, s(8), 0, s(8)),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = t.Primary,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = page,
	})
	Create("UIListLayout", {Padding = UDim.new(0, s(8)), SortOrder = Enum.SortOrder.LayoutOrder}).Parent = leftScroll

	local rightScroll = Create("ScrollingFrame", {
		Size = UDim2.new(0.5, -s(12), 1, -s(16)),
		Position = UDim2.new(0.5, s(4), 0, s(8)),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = t.Primary,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = page,
	})
	Create("UIListLayout", {Padding = UDim.new(0, s(8)), SortOrder = Enum.SortOrder.LayoutOrder}).Parent = rightScroll

	local tabObj = {
		Name = name,
		Button = btn,
		Card = btn,
		Indicator = indicator,
		Icon = ic,
		Label = lbl,
		Update = updateVisuals,
		Page = page,
		LeftScroll = leftScroll,
		RightScroll = rightScroll,
		Library = self,
	}
	setmetatable(tabObj, {__index = Library.TabMeta})

	table.insert(self.Tabs, tabObj)

	btn.MouseButton1Click:Connect(function()
		self:SelectTab(tabObj)
	end)

	if isFirst then
		task.defer(function()
			self:SelectTab(tabObj)
		end)
	end

	return tabObj
end

function Library:SelectTab(tabObj)
	for _, tab in ipairs(self.Tabs) do
		if tab ~= tabObj then
			tab.Update(false)
			if tab.Page.Visible then
				Fade(tab.Page, false, 0.15)
			end
		end
	end
	tabObj.Update(true)
	Fade(tabObj.Page, true, 0.15)
	self.ActiveTab = tabObj
end

----------------------------------------------------------------
-- TAB METATABLE (module creation)
----------------------------------------------------------------
Library.TabMeta = {}
Library.TabMeta.__index = Library.TabMeta

local HEADER_HEIGHT = s(46)
local DIVIDER_HEIGHT = s(9)

function Library.TabMeta:CreateModule(config)
	config = config or {}
	local t = self.Library.Theme
	local side = config.Side == "Right" and self.RightScroll or self.LeftScroll

	local moduleFrame = Create("Frame", {
		Name = config.Title or "Module",
		Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
		BackgroundColor3 = t.Module,
		BackgroundTransparency = t.ModuleTransparency or 0,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = side,
	})
	moduleFrame:SetAttribute("IsModule", true)
	Corner(16).Parent = moduleFrame
	Stroke(t.Border, 1.2).Parent = moduleFrame

	-- header
	local header = Create("Frame", {
		Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
		BackgroundTransparency = 1,
		Parent = moduleFrame,
	})

	local titleLbl = Create("TextLabel", {
		Size = UDim2.new(1, -90, 0, 20),
		Position = UDim2.new(0, 12, 0, 6),
		BackgroundTransparency = 1,
		Text = config.Title or "Module",
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextColor3 = t.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = header,
	})

	local descLbl = Create("TextLabel", {
		Size = UDim2.new(1, -90, 0, 16),
		Position = UDim2.new(0, 12, 0, 24),
		BackgroundTransparency = 1,
		Text = config.Description or "",
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = t.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = header,
	})

	-- keybind (optional) in header
	local keybindBtn
	if config.Keybind ~= nil then
		keybindBtn = Create("TextButton", {
			Size = UDim2.new(0, 46, 0, 20),
			Position = UDim2.new(1, -78, 0, 6),
			BackgroundColor3 = t.Sidebar,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = typeof(config.Keybind) == "EnumItem" and config.Keybind.Name or "None",
			Font = Enum.Font.Gotham,
			TextSize = 11,
			TextColor3 = t.Text,
			Parent = header,
		})
		Corner(10).Parent = keybindBtn
	end

	-- master enable toggle top-right
	local toggleBg = Create("Frame", {
		Size = UDim2.new(0, 34, 0, 18),
		Position = UDim2.new(1, -46, 0, 8),
		BackgroundColor3 = t.Sidebar,
		BackgroundTransparency = 1,
		Parent = header,
	})
	Corner(9).Parent = toggleBg
	local toggleDot = Create("Frame", {
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(0, 2, 0.5, -7),
		BackgroundColor3 = Color3.new(1, 1, 1),
		Parent = toggleBg,
	})
	Corner(7).Parent = toggleDot

	-- divider
	local divider = Create("Frame", {
		Size = UDim2.new(1, -24, 0, 1),
		Position = UDim2.new(0, 12, 0, HEADER_HEIGHT),
		BackgroundColor3 = t.Border,
		BorderSizePixel = 0,
		Parent = moduleFrame,
	})

	-- options container
	local options = Create("Frame", {
		Name = "Options",
		Size = UDim2.new(1, -24, 0, 0),
		Position = UDim2.new(0, 12, 0, HEADER_HEIGHT + DIVIDER_HEIGHT),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = moduleFrame,
	})
	local optLayout = Create("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	optLayout.Parent = options

	local moduleObj = {
		Instance = moduleFrame,
		Options = options,
		Header = header,
		Enabled = config.Enabled or false,
		Theme = t,
		_toggleBg = toggleBg,
		_toggleDot = toggleDot,
		_callback = config.Callback,
	}
	setmetatable(moduleObj, {__index = Library.ModuleMeta})

	local function recalc(animate)
		local target
		if moduleObj.Enabled then
			target = HEADER_HEIGHT + DIVIDER_HEIGHT + optLayout.AbsoluteContentSize.Y + 8
		else
			target = HEADER_HEIGHT
		end
		if animate then
			Tween(moduleFrame, {Size = UDim2.new(1, 0, 0, target)}, 0.3)
		else
			moduleFrame.Size = UDim2.new(1, 0, 0, target)
		end
	end
	moduleObj._Recalc = recalc
	optLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		recalc(moduleObj.Enabled)
	end)

	local function setEnabled(state, fromUser)
		moduleObj.Enabled = state
		if state then
			Tween(toggleDot, {Position = UDim2.new(1, -16, 0.5, -7), BackgroundColor3 = t.Primary}, 0.2)
		else
			Tween(toggleDot, {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.new(1, 1, 1)}, 0.2)
		end
		recalc(true)
		if fromUser and moduleObj._callback then
			task.spawn(moduleObj._callback, state)
		end
	end
	moduleObj._SetEnabled = setEnabled

	local clickArea = Create("TextButton", {
		Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 2,
		Parent = header,
	})
	clickArea.MouseButton1Click:Connect(function()
		setEnabled(not moduleObj.Enabled, true)
	end)

	if keybindBtn then
		local listening = false
		keybindBtn.MouseButton1Click:Connect(function()
			listening = true
			keybindBtn.Text = "..."
		end)
		UserInputService.InputBegan:Connect(function(input, gpe)
			if listening and not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
				config.Keybind = input.KeyCode
				keybindBtn.Text = input.KeyCode.Name
				listening = false
			elseif not listening and input.UserInputType == Enum.UserInputType.Keyboard
				and config.Keybind and input.KeyCode == config.Keybind then
				setEnabled(not moduleObj.Enabled, true)
			end
		end)
	end

	setEnabled(moduleObj.Enabled, false)

	return moduleObj
end

----------------------------------------------------------------
-- MODULE METATABLE (controls)
----------------------------------------------------------------
Library.ModuleMeta = {}
Library.ModuleMeta.__index = Library.ModuleMeta

function Library.ModuleMeta:CreateLabel(config)
	config = config or {}
	local t = self.Theme
	local lbl = Create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		Text = config.Text or "Label",
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = t.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = self.Options,
	})
	return lbl
end

function Library.ModuleMeta:CreateParagraph(config)
	config = config or {}
	local t = self.Theme
	local para = Create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Text = (config.Title and (config.Title .. "\n") or "") .. (config.Content or ""),
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = t.SubText,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = self.Options,
	})
	return para
end

function Library.ModuleMeta:CreateDivider()
	local t = self.Theme
	local div = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = t.Border,
		BorderSizePixel = 0,
		Parent = self.Options,
	})
	return div
end

function Library.ModuleMeta:CreateButton(config)
	config = config or {}
	local t = self.Theme
	local btn = Create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = t.Sidebar,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = config.Text or "Button",
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = t.Text,
		Parent = self.Options,
	})
	Corner(12).Parent = btn
	Hover(btn, t.Primary, function() return t.Sidebar end)
	btn.MouseButton1Click:Connect(function()
		Ripple(btn, t.Primary)
		if config.Callback then task.spawn(config.Callback) end
	end)
	return btn
end

function Library.ModuleMeta:CreateToggle(config)
	config = config or {}
	local t = self.Theme
	local state = config.Default or false

	local row = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Parent = self.Options,
	})
	local lbl = Create("TextLabel", {
		Size = UDim2.new(1, -46, 1, 0),
		BackgroundTransparency = 1,
		Text = config.Text or "Toggle",
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = t.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	local bg = Create("Frame", {
		Size = UDim2.new(0, 34, 0, 18),
		Position = UDim2.new(1, -34, 0.5, -9),
		BackgroundColor3 = state and t.Primary or t.Sidebar,
		BackgroundTransparency = 1,
		Parent = row,
	})
	Corner(9).Parent = bg
	local dot = Create("Frame", {
		Size = UDim2.new(0, 14, 0, 14),
		Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
		BackgroundColor3 = state and t.Primary or Color3.new(1, 1, 1),
		Parent = bg,
	})
	Corner(7).Parent = dot

	local click = Create("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		Parent = row,
	})
	click.MouseButton1Click:Connect(function()
		state = not state
		Tween(dot, {
			Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
			BackgroundColor3 = state and t.Primary or Color3.new(1, 1, 1),
		}, 0.15)
		if config.Callback then task.spawn(config.Callback, state) end
	end)

	return {
		Set = function(_, v)
			state = v
			Tween(dot, {
				Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
				BackgroundColor3 = state and t.Primary or Color3.new(1, 1, 1),
			}, 0.15)
		end,
		Get = function() return state end,
	}
end

function Library.ModuleMeta:CreateSlider(config)
	config = config or {}
	local t = self.Theme
	local min, max = config.Min or 0, config.Max or 100
	local value = config.Default or min
	local suffix = config.Suffix or ""

	local row = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundTransparency = 1,
		Parent = self.Options,
	})
	local lbl = Create("TextLabel", {
		Size = UDim2.new(1, -50, 0, 16),
		BackgroundTransparency = 1,
		Text = config.Text or "Slider",
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = t.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	local valLbl = Create("TextLabel", {
		Size = UDim2.new(0, 50, 0, 16),
		Position = UDim2.new(1, -50, 0, 0),
		BackgroundTransparency = 1,
		Text = tostring(value) .. suffix,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = t.SubText,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = row,
	})
	local track = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 6),
		Position = UDim2.new(0, 0, 0, 24),
		BackgroundColor3 = t.Sidebar,
		BackgroundTransparency = 1,
		Parent = row,
	})
	Corner(3).Parent = track
	local fill = Create("Frame", {
		Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
		BackgroundColor3 = t.Primary,
		Parent = track,
	})
	Corner(3).Parent = fill

	local dragging = false
	local function update(input)
		local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		value = math.floor(min + (max - min) * pct)
		fill.Size = UDim2.new(pct, 0, 1, 0)
		valLbl.Text = tostring(value) .. suffix
		if config.Callback then task.spawn(config.Callback, value) end
	end
	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			update(input)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	return {
		Set = function(_, v)
			value = math.clamp(v, min, max)
			local pct = (value - min) / (max - min)
			fill.Size = UDim2.new(pct, 0, 1, 0)
			valLbl.Text = tostring(value) .. suffix
		end,
		Get = function() return value end,
	}
end

function Library.ModuleMeta:CreateDropdown(config)
	config = config or {}
	local t = self.Theme
	local options = config.Options or {}
	local selected = config.Default or options[1]
	local open = false

	local row = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = t.Sidebar,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = self.Options,
	})
	Corner(12).Parent = row

	local head = Create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = row,
	})
	local lbl = Create("TextLabel", {
		Size = UDim2.new(1, -30, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Text = (config.Text or "Dropdown") .. ": " .. tostring(selected),
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = t.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = head,
	})
	local arrow = Create("TextLabel", {
		Size = UDim2.new(0, 20, 0, 20),
		Position = UDim2.new(1, -26, 0, 5),
		BackgroundTransparency = 1,
		Text = "v",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = t.SubText,
		Parent = head,
	})

	local list = Create("Frame", {
		Size = UDim2.new(1, -8, 0, 0),
		Position = UDim2.new(0, 4, 0, 32),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = row,
	})
	Create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}).Parent = list

	local function rebuild()
		for _, c in ipairs(list:GetChildren()) do
			if c:IsA("TextButton") then c:Destroy() end
		end
		for _, opt in ipairs(options) do
			local optBtn = Create("TextButton", {
				Size = UDim2.new(1, 0, 0, 24),
				BackgroundColor3 = t.Module,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Text = tostring(opt),
				Font = Enum.Font.Gotham,
				TextSize = 12,
				TextColor3 = t.Text,
				Parent = list,
			})
			Corner(10).Parent = optBtn
			Hover(optBtn, t.Primary, function() return t.Module end)
			optBtn.MouseButton1Click:Connect(function()
				selected = opt
				lbl.Text = (config.Text or "Dropdown") .. ": " .. tostring(opt)
				if config.Callback then task.spawn(config.Callback, opt) end
				open = false
				Tween(row, {Size = UDim2.new(1, 0, 0, 30)}, 0.2)
				Tween(arrow, {Rotation = 0}, 0.2)
			end)
		end
	end
	rebuild()

	head.MouseButton1Click:Connect(function()
		open = not open
		if open then
			local h = 30 + 8 + (#options * 28)
			Tween(row, {Size = UDim2.new(1, 0, 0, h)}, 0.25)
			Tween(arrow, {Rotation = 180}, 0.25)
		else
			Tween(row, {Size = UDim2.new(1, 0, 0, 30)}, 0.25)
			Tween(arrow, {Rotation = 0}, 0.25)
		end
	end)

	return {
		Set = function(_, v)
			selected = v
			lbl.Text = (config.Text or "Dropdown") .. ": " .. tostring(v)
		end,
		Refresh = function(_, newOptions)
			options = newOptions
			rebuild()
		end,
		Get = function() return selected end,
	}
end

function Library.ModuleMeta:CreateMultiDropdown(config)
	config = config or {}
	local t = self.Theme
	local options = config.Options or {}
	local selected = {}
	for _, v in ipairs(config.Default or {}) do selected[v] = true end
	local open = false

	local row = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = t.Sidebar,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = self.Options,
	})
	Corner(12).Parent = row

	local head = Create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = row,
	})

	local function countText()
		local n = 0
		for _ in pairs(selected) do n += 1 end
		return (config.Text or "Multi Dropdown") .. " (" .. n .. ")"
	end

	local lbl = Create("TextLabel", {
		Size = UDim2.new(1, -30, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Text = countText(),
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = t.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = head,
	})

	local list = Create("Frame", {
		Size = UDim2.new(1, -8, 0, 0),
		Position = UDim2.new(0, 4, 0, 32),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = row,
	})
	Create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}).Parent = list

	for _, opt in ipairs(options) do
		local optBtn = Create("TextButton", {
			Size = UDim2.new(1, 0, 0, 24),
			BackgroundColor3 = selected[opt] and t.Primary or t.Module,
			BackgroundTransparency = selected[opt] and 0 or 1,
			AutoButtonColor = false,
			Text = tostring(opt),
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = t.Text,
			Parent = list,
		})
		Corner(10).Parent = optBtn
		optBtn.MouseButton1Click:Connect(function()
			selected[opt] = not selected[opt] or nil
			optBtn.BackgroundColor3 = selected[opt] and t.Primary or t.Module
			optBtn.BackgroundTransparency = selected[opt] and 0 or 1
			lbl.Text = countText()
			if config.Callback then
				local arr = {}
				for k in pairs(selected) do table.insert(arr, k) end
				task.spawn(config.Callback, arr)
			end
		end)
	end

	head.MouseButton1Click:Connect(function()
		open = not open
		if open then
			local h = 30 + 8 + (#options * 28)
			Tween(row, {Size = UDim2.new(1, 0, 0, h)}, 0.25)
		else
			Tween(row, {Size = UDim2.new(1, 0, 0, 30)}, 0.25)
		end
	end)

	return {
		Get = function()
			local arr = {}
			for k in pairs(selected) do table.insert(arr, k) end
			return arr
		end,
	}
end

function Library.ModuleMeta:CreateColorPicker(config)
	config = config or {}
	local t = self.Theme
	local color = config.Default or Color3.fromRGB(255, 133, 178)

	local row = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Parent = self.Options,
	})
	Create("TextLabel", {
		Size = UDim2.new(1, -40, 1, 0),
		BackgroundTransparency = 1,
		Text = config.Text or "Color",
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = t.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	local swatch = Create("TextButton", {
		Size = UDim2.new(0, 26, 0, 20),
		Position = UDim2.new(1, -26, 0.5, -10),
		BackgroundColor3 = color,
		AutoButtonColor = false,
		Text = "",
		Parent = row,
	})
	Corner(10).Parent = swatch
	Stroke(t.Border, 1).Parent = swatch

	-- popout picker (hue/sat/val simplified via 3 sliders)
	local picker = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 90),
		BackgroundColor3 = t.Module,
		BackgroundTransparency = 1,
		Visible = false,
		ClipsDescendants = true,
		ZIndex = 10,
		Parent = self.Options,
	})
	Corner(12).Parent = picker
	Stroke(t.Border, 1).Parent = picker

	local function makeChannelSlider(labelText, order, initial, onChange)
		local r = Create("Frame", {
			Size = UDim2.new(1, -16, 0, 20),
			Position = UDim2.new(0, 8, 0, 6 + (order * 24)),
			BackgroundTransparency = 1,
			Parent = picker,
		})
		local track = Create("Frame", {
			Size = UDim2.new(1, -30, 0, 6),
			Position = UDim2.new(0, 0, 0.5, -3),
			BackgroundColor3 = t.Sidebar,
			BackgroundTransparency = 1,
			Parent = r,
		})
		Corner(3).Parent = track
		local fill = Create("Frame", {
			Size = UDim2.new(initial / 255, 0, 1, 0),
			BackgroundColor3 = t.Primary,
			Parent = track,
		})
		Corner(3).Parent = fill
		local valLbl = Create("TextLabel", {
			Size = UDim2.new(0, 26, 0, 20),
			Position = UDim2.new(1, -26, 0, 0),
			BackgroundTransparency = 1,
			Text = tostring(initial),
			Font = Enum.Font.Gotham,
			TextSize = 11,
			TextColor3 = t.SubText,
			Parent = r,
		})
		local dragging = false
		local function upd(input)
			local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			fill.Size = UDim2.new(pct, 0, 1, 0)
			local val = math.floor(pct * 255)
			valLbl.Text = tostring(val)
			onChange(val)
		end
		track.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				upd(input)
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				upd(input)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
		end)
	end

	local rC, gC, bC = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
	local function refreshSwatch()
		local c = Color3.fromRGB(rC, gC, bC)
		swatch.BackgroundColor3 = c
		color = c
		if config.Callback then task.spawn(config.Callback, c) end
	end
	makeChannelSlider("R", 0, rC, function(v) rC = v; refreshSwatch() end)
	makeChannelSlider("G", 1, gC, function(v) gC = v; refreshSwatch() end)
	makeChannelSlider("B", 2, bC, function(v) bC = v; refreshSwatch() end)

	local open = false
	swatch.MouseButton1Click:Connect(function()
		open = not open
		picker.Visible = true
		Tween(picker, {Size = UDim2.new(1, 0, 0, open and 90 or 0)}, 0.25)
		if not open then
			task.delay(0.25, function() picker.Visible = false end)
		end
	end)

	return {
		Set = function(_, c)
			color = c
			swatch.BackgroundColor3 = c
		end,
		Get = function() return color end,
	}
end

function Library.ModuleMeta:CreateTextbox(config)
	config = config or {}
	local t = self.Theme
	local row = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = t.Sidebar,
		BackgroundTransparency = 1,
		Parent = self.Options,
	})
	Corner(12).Parent = row
	local box = Create("TextBox", {
		Size = UDim2.new(1, -16, 1, 0),
		Position = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1,
		Text = config.Default or "",
		PlaceholderText = config.Placeholder or "Enter text...",
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = t.Text,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	box.FocusLost:Connect(function(enterPressed)
		if config.Callback then task.spawn(config.Callback, box.Text, enterPressed) end
	end)
	return {
		Set = function(_, v) box.Text = v end,
		Get = function() return box.Text end,
	}
end

function Library.ModuleMeta:CreateKeybind(config)
	config = config or {}
	local t = self.Theme
	local current = config.Default
	local listening = false

	local row = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Parent = self.Options,
	})
	Create("TextLabel", {
		Size = UDim2.new(1, -70, 1, 0),
		BackgroundTransparency = 1,
		Text = config.Text or "Keybind",
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = t.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	local btn = Create("TextButton", {
		Size = UDim2.new(0, 64, 0, 22),
		Position = UDim2.new(1, -64, 0.5, -11),
		BackgroundColor3 = t.Sidebar,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = current and current.Name or "None",
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = t.Text,
		Parent = row,
	})
	Corner(10).Parent = btn

	btn.MouseButton1Click:Connect(function()
		listening = true
		btn.Text = "..."
	end)
	UserInputService.InputBegan:Connect(function(input, gpe)
		if listening and not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
			current = input.KeyCode
			btn.Text = current.Name
			listening = false
			if config.Callback then task.spawn(config.Callback, current) end
		end
	end)

	return {
		Get = function() return current end,
	}
end

----------------------------------------------------------------
-- SETTINGS TAB (auto-appended, always last)
----------------------------------------------------------------
function Library:_BuildSettingsTabLater()
	task.defer(function()
		local settingsTab = self:CreateTab("Settings", "rbxassetid://7733964719")
		local appearance = settingsTab:CreateModule({
			Title = "Appearance",
			Description = "Theme & color customization",
			Side = "Left",
			Enabled = true,
		})

		local themeDropdown = appearance:CreateDropdown({
			Text = "Theme",
			Options = {"Sakura Light", "Sakura Dark"},
			Default = self.ThemeName,
			Callback = function(choice)
				self.ThemeName = choice
				self.Theme = Library.Themes[choice]
				self:ApplyTheme()
				self:SaveSettings()
			end,
		})

		appearance:CreateDivider()

		local colorFields = {
			{Key = "Primary", Text = "Primary Color"},
			{Key = "Background", Text = "Background"},
			{Key = "Border", Text = "Border"},
			{Key = "Text", Text = "Text Color"},
			{Key = "Icon", Text = "Icon Color"},
		}
		for _, field in ipairs(colorFields) do
			appearance:CreateColorPicker({
				Text = field.Text,
				Default = self.Theme[field.Key],
				Callback = function(c)
					self.Theme[field.Key] = c
					self:ApplyTheme()
					self:SaveSettings()
				end,
			})
		end

		local dataModule = settingsTab:CreateModule({
			Title = "Data",
			Description = "Save or reset settings",
			Side = "Right",
			Enabled = true,
		})
		dataModule:CreateButton({
			Text = "Save Settings",
			Callback = function() self:SaveSettings() end,
		})
		dataModule:CreateButton({
			Text = "Reset To Default",
			Callback = function()
				self.ThemeName = "Sakura Light"
				self.Theme = table.clone(Library.Themes["Sakura Light"])
				self:ApplyTheme()
				self:SaveSettings()
			end,
		})
	end)
end

return Library
