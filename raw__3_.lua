local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.__index = Library

local GlobalCorner = UDim.new(0, 14)

local function getMobileScale()
    local viewport = workspace.CurrentCamera.ViewportSize
    local isMobile = UIS.TouchEnabled and viewport.X < 1024
    if isMobile then
        return 0.8
    end
    return 1
end

local scale = getMobileScale()

local BASE_W, BASE_H = 580, 340
local BASE_MINI_W, BASE_MINI_H = 135, 42

local FullSize = UDim2.new(0, BASE_W * scale, 0, BASE_H * scale)
local MiniSize = UDim2.new(0, BASE_MINI_W * scale, 0, BASE_MINI_H * scale)

local function s(n)
    return math.round(n * scale)
end

function Library:CreateWindow(config)
    local Window = {}
    Window.Tabs = {}
    Window.FirstTab = nil

    local ParentUI
    local success, coregui = pcall(function() return game:GetService("CoreGui") end)
    if success and coregui then
        ParentUI = coregui
    else
        ParentUI = LocalPlayer:WaitForChild("PlayerGui")
    end

    local OldUI = ParentUI:FindFirstChild("Bobit_UI")
    if OldUI then OldUI:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Bobit_UI"
    ScreenGui.Parent = ParentUI
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    MainFrame.Position = UDim2.new(0.5, -s(290), 0.5, -s(170))
    MainFrame.Size = FullSize
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true 
    MainFrame.ClipsDescendants = true

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, s(14))
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(0, 80, 255)
    MainStroke.Thickness = 1.5
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    Topbar.Size = UDim2.new(1, 0, 0, s(42))
    Topbar.BorderSizePixel = 0
    Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, s(14))

    local Title = Instance.new("TextLabel")
    Title.Parent = Topbar
    Title.Text = config.Title or "Bobit Free"
    Title.TextColor3 = Color3.fromRGB(0, 120, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = s(15)
    Title.Size = UDim2.new(0, s(120), 1, 0)
    Title.Position = UDim2.new(0, s(17), 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 2

    local Shimmer = Instance.new("UIGradient")
    Shimmer.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 80, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 255))
    })
    Shimmer.Parent = Title

    task.spawn(function()
        while ScreenGui.Parent do
            local tween = TweenService:Create(Shimmer, TweenInfo.new(2, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)})
            Shimmer.Offset = Vector2.new(-1, 0)
            tween:Play()
            tween.Completed:Wait()
        end
    end)

    local MinBtn = Instance.new("ImageButton")
    MinBtn.Name = "MinBtn"
    MinBtn.Parent = Topbar
    MinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    MinBtn.Size = UDim2.new(0, s(26), 0, s(26))
    MinBtn.Position = UDim2.new(1, -s(35), 0.5, -s(13))
    MinBtn.ZIndex = 3
    MinBtn.Image = "rbxassetid://74409172057180" 
    MinBtn.ScaleType = Enum.ScaleType.Fit
    MinBtn.BackgroundTransparency = 0
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, s(8))

    local TopOverlap = Instance.new("Frame")
    TopOverlap.Name = "TopOverlap"
    TopOverlap.Parent = MainFrame
    TopOverlap.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    TopOverlap.Size = UDim2.new(1, 0, 0, s(6))
    TopOverlap.Position = UDim2.new(0, 0, 0, s(36))
    TopOverlap.BorderSizePixel = 0
    TopOverlap.ZIndex = 0

    local dragModule, dragStart, startPos, dragTouchObject
    Topbar.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragModule = true; dragStart = input.Position; startPos = MainFrame.Position; dragTouchObject = input
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragModule = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragModule and input == dragTouchObject then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        end
    end)

    local SidebarWidth = s(115)
    local Container = Instance.new("Frame")
    Container.Parent = MainFrame
    Container.Size = UDim2.new(1, -2, 1, -s(44))
    Container.Position = UDim2.new(0, 1, 0, s(43))
    Container.BackgroundTransparency = 1
    Container.ClipsDescendants = true

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Container
    Sidebar.Size = UDim2.new(0, SidebarWidth, 1, 0)
    Sidebar.BackgroundTransparency = 1

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.Padding = UDim.new(0, s(5))
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.Parent = Sidebar
    SidebarPadding.PaddingTop = UDim.new(0, s(10))

    local Pages = Instance.new("Frame")
    Pages.Name = "Pages"
    Pages.Parent = Container
    Pages.Size = UDim2.new(1, -SidebarWidth, 1, -2)
    Pages.Position = UDim2.new(0, SidebarWidth, 0, 1)
    Pages.BackgroundTransparency = 1
    Pages.ClipsDescendants = true

    local Sep = Instance.new("Frame")
    Sep.Parent = Container
    Sep.BackgroundColor3 = Color3.fromRGB(0, 80, 255)
    Sep.BackgroundTransparency = 0.8
    Sep.Position = UDim2.new(0, SidebarWidth, 0, s(10))
    Sep.Size = UDim2.new(0, 1, 1, -s(20))

    local isMainOpen = true
    MinBtn.MouseButton1Click:Connect(function()
        isMainOpen = not isMainOpen
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
            Size = isMainOpen and FullSize or MiniSize
        }):Play()
        Container.Visible = isMainOpen
        TopOverlap.Visible = isMainOpen
        MinBtn.Image = "rbxassetid://74409172057180"
    end)

    Window.ScreenGui = ScreenGui
    Window.MainFrame = MainFrame
    Window.Sidebar = Sidebar
    Window.Pages = Pages
    
    function Window:Tab(config)
        local Tab = {}
        local tabName = config.Title or "Tab"
        local imageId = config.Icon or "rbxassetid://76499042599127"
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName.."_Tab"
        TabBtn.Parent = Sidebar
        TabBtn.Size = UDim2.new(0.9, 0, 0, s(35))
        TabBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.LayoutOrder = #Window.Tabs + 1
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, s(6))

        local Indicator = Instance.new("Frame")
        Indicator.Name = "Indicator"
        Indicator.Parent = TabBtn
        Indicator.Size = UDim2.new(0, s(2), 0, s(16))
        Indicator.Position = UDim2.new(0, s(6), 0.5, -s(8))
        Indicator.BackgroundColor3 = Color3.fromRGB(0, 80, 255)
        Indicator.BorderSizePixel = 0
        Indicator.Visible = false
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Parent = TabBtn
        TabIcon.Size = UDim2.new(0, s(18), 0, s(18))
        TabIcon.Position = UDim2.new(0, s(16), 0.5, -s(9))
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = imageId
        TabIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)

        local TabText = Instance.new("TextLabel")
        TabText.Parent = TabBtn
        TabText.Text = tabName
        TabText.Size = UDim2.new(1, -s(40), 1, 0)
        TabText.Position = UDim2.new(0, s(40), 0, 0)
        TabText.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabText.Font = Enum.Font.GothamBold
        TabText.TextSize = s(11)
        TabText.BackgroundTransparency = 1
        TabText.TextXAlignment = Enum.TextXAlignment.Left

        local function UpdateTabVisuals(selected)
            local targetColor = selected and Color3.fromRGB(0, 80, 255) or Color3.fromRGB(150, 150, 150)
            local bgColor = selected and Color3.fromRGB(17, 17, 22) or Color3.fromRGB(15, 15, 18)
            local textColor = selected and Color3.fromRGB(0, 80, 255) or Color3.fromRGB(150, 150, 150)

            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = bgColor}):Play()
            TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = targetColor}):Play()
            TweenService:Create(TabText, TweenInfo.new(0.2), {TextColor3 = textColor}):Play()
            Indicator.Visible = selected
        end

        local Page = Instance.new("Frame")
        Page.Name = tabName.."_Page"
        Page.Parent = Pages
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Visible = false

        local LeftCol = Instance.new("ScrollingFrame")
        LeftCol.Name = "Left"
        LeftCol.Parent = Page
        LeftCol.Size = UDim2.new(0.5, -s(12), 1, 0)
        LeftCol.Position = UDim2.new(0, s(6), 0, 0)
        LeftCol.BackgroundTransparency = 1
        LeftCol.BorderSizePixel = 0
        LeftCol.ScrollBarThickness = 0
        LeftCol.ScrollBarImageTransparency = 1
        LeftCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
        LeftCol.CanvasSize = UDim2.new(0, 0, 0, 0)
        LeftCol.ClipsDescendants = false

        local RightCol = Instance.new("ScrollingFrame")
        RightCol.Name = "Right"
        RightCol.Parent = Page
        RightCol.Size = UDim2.new(0.5, -s(12), 1, 0)
        RightCol.Position = UDim2.new(0.5, s(6), 0, 0)
        RightCol.BackgroundTransparency = 1
        RightCol.BorderSizePixel = 0
        RightCol.ScrollBarThickness = 0
        RightCol.ScrollBarImageTransparency = 1
        RightCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
        RightCol.CanvasSize = UDim2.new(0, 0, 0, 0)
        RightCol.ClipsDescendants = false

        for _, col in pairs({LeftCol, RightCol}) do
            local l = Instance.new("UIListLayout")
            l.Parent = col
            l.Padding = UDim.new(0, s(12))
            l.HorizontalAlignment = Enum.HorizontalAlignment.Center
            local p = Instance.new("UIPadding")
            p.Parent = col
            p.PaddingTop = UDim.new(0, s(15))
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Window.Tabs) do
                v.Page.Visible = false
                v.Update(false)
            end
            Page.Visible = true
            UpdateTabVisuals(true)
        end)

        Window.Tabs[#Window.Tabs + 1] = {
            Btn = TabBtn,
            Page = Page,
            Update = UpdateTabVisuals,
            Left = LeftCol,
            Right = RightCol,
            Count = 0,
            Name = tabName
        }
        
        if not Window.FirstTab then
            Window.FirstTab = tabName
            Page.Visible = true
            UpdateTabVisuals(true)
        end
        
        Tab.Name = tabName
        Tab.LeftCol = LeftCol
        Tab.RightCol = RightCol
        Tab.Count = 0
        
        function Tab:Select()
            for _, v in pairs(Window.Tabs) do
                v.Page.Visible = false
                v.Update(false)
            end
            Page.Visible = true
            UpdateTabVisuals(true)
        end
        
        function Tab:GetSide(section)
            if section then
                if section:lower() == "left" then
                    return self.LeftCol
                elseif section:lower() == "right" then
                    return self.RightCol
                end
            end
            return nil
        end
        
        function Tab:Module(config)
            local parent = self:GetSide(config.Section)
            if not parent then return end
            local hasSlider = config.Min and config.Max
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            
            if hasSlider then
                if default < min then default = min end
                if default > max then default = max end
            end
            
            local ModuleFrame = Instance.new("Frame")
            ModuleFrame.Parent = parent
            ModuleFrame.Size = UDim2.new(1, 0, 0, hasSlider and s(85) or s(58))
            ModuleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
            Instance.new("UICorner", ModuleFrame).CornerRadius = UDim.new(0, s(14))
            
            local BoxStroke = Instance.new("UIStroke")
            BoxStroke.Color = Color3.fromRGB(0, 80, 255)
            BoxStroke.Thickness = 1.2
            BoxStroke.Transparency = 0.6
            BoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            BoxStroke.Parent = ModuleFrame

            local ModuleText = Instance.new("TextLabel")
            ModuleText.Parent = ModuleFrame
            ModuleText.Text = " "..(config.Title or "Module")
            ModuleText.Size = UDim2.new(1, -s(10), 0, s(25))
            ModuleText.Position = UDim2.new(0, s(10), 0, s(10))
            ModuleText.TextColor3 = Color3.fromRGB(0, 80, 255)
            ModuleText.Font = Enum.Font.GothamBold
            ModuleText.TextSize = s(12)
            ModuleText.BackgroundTransparency = 1
            ModuleText.TextXAlignment = Enum.TextXAlignment.Left

            local DescText = Instance.new("TextLabel")
            DescText.Parent = ModuleFrame
            DescText.Text = " "..(config.Description or "")
            DescText.Size = UDim2.new(1, -s(10), 0, s(15))
            DescText.Position = UDim2.new(0, s(10), 0, s(32))
            DescText.TextColor3 = Color3.fromRGB(0, 80, 255)
            DescText.Font = Enum.Font.Gotham
            DescText.TextSize = s(9)
            DescText.BackgroundTransparency = 1
            DescText.TextXAlignment = Enum.TextXAlignment.Left

            local Switch = Instance.new("Frame")
            Switch.Parent = ModuleFrame
            Switch.Size = UDim2.new(0, s(34), 0, s(18))
            Switch.Position = UDim2.new(1, -s(46), 0, s(21))
            Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
            
            local Dot = Instance.new("Frame")
            Dot.Parent = Switch
            Dot.Size = UDim2.new(0, s(14), 0, s(14))
            Dot.Position = UDim2.new(0, s(2), 0.5, -s(7))
            Dot.BackgroundColor3 = Color3.fromRGB(120, 120, 125)
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

            local Moduled = type(config.Default) == "boolean" and config.Default or false
            local currentVal = default
            
            if Moduled then
                Dot.Position = UDim2.new(0, s(18), 0.5, -s(7))
                Dot.BackgroundColor3 = Color3.fromRGB(0, 80, 255)
            end
            
            local Btn = Instance.new("TextButton")
            Btn.Parent = ModuleFrame
            Btn.Size = UDim2.new(1, 0, 0, s(50))
            Btn.BackgroundTransparency = 1
            Btn.Text = ""
            
            Btn.MouseButton1Click:Connect(function()
                Moduled = not Moduled
                TweenService:Create(Dot, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
                    Position = Moduled and UDim2.new(0, s(18), 0.5, -s(7)) or UDim2.new(0, s(2), 0.5, -s(7)),
                    BackgroundColor3 = Moduled and Color3.fromRGB(0, 80, 255) or Color3.fromRGB(120, 120, 125)
                }):Play()
                if config.Callback then
                    config.Callback(Moduled, currentVal)
                end
            end)

            if hasSlider then
                local initialPos = (currentVal - min) / (max - min)
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Parent = ModuleFrame
                SliderBar.Size = UDim2.new(1, -s(20), 0, s(4))
                SliderBar.Position = UDim2.new(0, s(10), 0, s(68))
                SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)
                
                local Fill = Instance.new("Frame")
                Fill.Parent = SliderBar
                Fill.Size = UDim2.new(initialPos, 0, 1, 0)
                Fill.BackgroundColor3 = Color3.fromRGB(0, 80, 255)
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
                
                local SliderDot = Instance.new("Frame")
                SliderDot.Parent = SliderBar
                SliderDot.Size = UDim2.new(0, s(12), 0, s(12))
                SliderDot.Position = UDim2.new(initialPos, 0, 0.5, 0)
                SliderDot.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderDot.BackgroundColor3 = Color3.fromRGB(0, 80, 255)
                SliderDot.ZIndex = 11
                Instance.new("UICorner", SliderDot).CornerRadius = UDim.new(1, 0)
                
                local ValLabel = Instance.new("TextLabel")
                ValLabel.Parent = ModuleFrame
                ValLabel.Text = tostring(currentVal)
                ValLabel.Size = UDim2.new(0, s(40), 0, s(20))
                ValLabel.Position = UDim2.new(1, -s(50), 0, s(45))
                ValLabel.TextColor3 = Color3.fromRGB(0, 80, 255)
                ValLabel.Font = Enum.Font.GothamBold
                ValLabel.TextSize = s(10)
                ValLabel.BackgroundTransparency = 1
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right
                
                local drag = false
                local function move(input)
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    currentVal = math.floor(min + (max - min) * pos)
                    ValLabel.Text = tostring(currentVal)
                    TweenService:Create(Fill, TweenInfo.new(0.24, Enum.EasingStyle.Quart), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                    TweenService:Create(SliderDot, TweenInfo.new(0.24, Enum.EasingStyle.Quart), {Position = UDim2.new(pos, 0, 0.5, 0)}):Play()
                    if config.Callback and Moduled then
                        config.Callback(Moduled, currentVal)
                    end
                end
                
                SliderBar.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        drag = true
                        move(i)
                    end
                end)
                
                UIS.InputChanged:Connect(function(i)
                    if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        move(i)
                    end
                end)
                
                UIS.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        drag = false
                    end
                end)
            end
            
            return {
                GetState = function() return Moduled end,
                GetValue = function() return currentVal end,
                SetState = function(state)
                    Moduled = state
                    TweenService:Create(Dot, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
                        Position = Moduled and UDim2.new(0, s(18), 0.5, -s(7)) or UDim2.new(0, s(2), 0.5, -s(7)),
                        BackgroundColor3 = Moduled and Color3.fromRGB(0, 80, 255) or Color3.fromRGB(120, 120, 125)
                    }):Play()
                    if config.Callback then
                        config.Callback(Moduled, currentVal)
                    end
                end,
                SetValue = function(value)
                    currentVal = math.clamp(value, min, max)
                    local pos = (currentVal - min) / (max - min)
                    ValLabel.Text = tostring(currentVal)
                    TweenService:Create(Fill, TweenInfo.new(0.24, Enum.EasingStyle.Quart), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                    TweenService:Create(SliderDot, TweenInfo.new(0.24, Enum.EasingStyle.Quart), {Position = UDim2.new(pos, 0, 0.5, 0)}):Play()
                    if config.Callback and Moduled then
                        config.Callback(Moduled, currentVal)
                    end
                end
            }
        end
        
        function Tab:Dropdown(config)
            local parent = self:GetSide(config.Section)
            if not parent then return end
            local options = config.Options or {"Option 1"}
            
            local DropFrame = Instance.new("Frame")
            DropFrame.Parent = parent
            DropFrame.Size = UDim2.new(1, 0, 0, s(58))
            DropFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
            DropFrame.ClipsDescendants = false
            DropFrame.ZIndex = 5
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, s(14))
            
            local BoxStroke = Instance.new("UIStroke")
            BoxStroke.Color = Color3.fromRGB(0, 80, 255)
            BoxStroke.Thickness = 1.2
            BoxStroke.Transparency = 0.6
            BoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            BoxStroke.Parent = DropFrame

            local TitleText = Instance.new("TextLabel")
            TitleText.Parent = DropFrame
            TitleText.Text = " "..(config.Title or "Dropdown")
            TitleText.Size = UDim2.new(1, -s(10), 0, s(25))
            TitleText.Position = UDim2.new(0, s(10), 0, s(5))
            TitleText.TextColor3 = Color3.fromRGB(0, 80, 255)
            TitleText.Font = Enum.Font.GothamBold
            TitleText.TextSize = s(12)
            TitleText.BackgroundTransparency = 1
            TitleText.TextXAlignment = Enum.TextXAlignment.Left
            TitleText.ZIndex = 6

            local Selected = Instance.new("Frame")
            Selected.Parent = DropFrame
            Selected.Size = UDim2.new(1, -s(20), 0, s(18))
            Selected.Position = UDim2.new(0, s(10), 0, s(30))
            Selected.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            Selected.ZIndex = 6
            Instance.new("UICorner", Selected).CornerRadius = UDim.new(0, s(6))
            
            local SelectedText = Instance.new("TextLabel")
            SelectedText.Parent = Selected
            SelectedText.Text = config.Default or options[1] or "Select"
            SelectedText.Size = UDim2.new(1, -s(10), 1, 0)
            SelectedText.Position = UDim2.new(0, s(8), 0, 0)
            SelectedText.TextColor3 = Color3.fromRGB(200, 200, 200)
            SelectedText.Font = Enum.Font.GothamBold
            SelectedText.TextSize = s(10)
            SelectedText.BackgroundTransparency = 1
            SelectedText.TextXAlignment = Enum.TextXAlignment.Left
            SelectedText.ZIndex = 7
            
            local DropdownBtn = Instance.new("TextButton")
            DropdownBtn.Parent = Selected
            DropdownBtn.Size = UDim2.new(1, 0, 1, 0)
            DropdownBtn.BackgroundTransparency = 1
            DropdownBtn.Text = ""
            DropdownBtn.ZIndex = 11

            local OptionsHolder = Instance.new("Frame")
            OptionsHolder.Parent = DropFrame
            OptionsHolder.Size = UDim2.new(1, 0, 0, 0)
            OptionsHolder.Position = UDim2.new(0, 0, 0, s(60))
            OptionsHolder.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
            OptionsHolder.Visible = false
            OptionsHolder.ZIndex = 100
            OptionsHolder.ClipsDescendants = true
            Instance.new("UICorner", OptionsHolder).CornerRadius = UDim.new(0, s(8))
            
            local HolderStroke = Instance.new("UIStroke")
            HolderStroke.Color = Color3.fromRGB(0, 80, 255)
            HolderStroke.Thickness = 1.2
            HolderStroke.Parent = OptionsHolder

            local OptionsScroll = Instance.new("ScrollingFrame")
            OptionsScroll.Parent = OptionsHolder
            OptionsScroll.Size = UDim2.new(1, -s(10), 1, -s(10))
            OptionsScroll.Position = UDim2.new(0, s(5), 0, s(5))
            OptionsScroll.BackgroundTransparency = 1
            OptionsScroll.ScrollBarThickness = 0
            OptionsScroll.ZIndex = 101
            OptionsScroll.CanvasSize = UDim2.new(0, 0, 0, #options * s(25))
            Instance.new("UIListLayout", OptionsScroll).Padding = UDim.new(0, s(3))

            local isOpen = false
            local selectedOption = config.Default or options[1]
            
            for i, option in ipairs(options) do
                local OptionBtn = Instance.new("TextButton")
                OptionBtn.Parent = OptionsScroll
                OptionBtn.Size = UDim2.new(1, 0, 0, s(22))
                OptionBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
                OptionBtn.Text = "  "..option
                OptionBtn.TextColor3 = Color3.fromRGB(0, 80, 255)
                OptionBtn.Font = Enum.Font.GothamBold
                OptionBtn.TextSize = s(10)
                OptionBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptionBtn.ZIndex = 102
                Instance.new("UICorner", OptionBtn).CornerRadius = UDim.new(0, s(4))

                OptionBtn.MouseButton1Click:Connect(function()
                    selectedOption = option
                    SelectedText.Text = option
                    isOpen = false
                    OptionsHolder.Visible = false
                    TweenService:Create(OptionsHolder, TweenInfo.new(0.4), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    if config.Callback then
                        config.Callback(option)
                    end
                end)
            end

            DropdownBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                OptionsHolder.Visible = isOpen
                TweenService:Create(OptionsHolder, TweenInfo.new(0.2), {
                    Size = isOpen and UDim2.new(1, 0, 0, math.min(s(110), #options * s(25) + s(10))) or UDim2.new(1, 0, 0, 0)
                }):Play()
            end)
            
            return {
                GetValue = function() return selectedOption end,
                SetValue = function(value)
                    selectedOption = value
                    SelectedText.Text = value
                    if config.Callback then
                        config.Callback(value)
                    end
                end
            }
        end
        
        function Tab:Checkbox(config)
            local parent = self:GetSide(config.Section)
            if not parent then return end
            
            local CheckFrame = Instance.new("Frame")
            CheckFrame.Parent = parent
            CheckFrame.Size = UDim2.new(1, 0, 0, s(35))
            CheckFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
            Instance.new("UICorner", CheckFrame).CornerRadius = UDim.new(0, s(14))
            
            local BoxStroke = Instance.new("UIStroke")
            BoxStroke.Color = Color3.fromRGB(0, 80, 255)
            BoxStroke.Thickness = 1.2
            BoxStroke.Transparency = 0.6
            BoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            BoxStroke.Parent = CheckFrame

            local Label = Instance.new("TextLabel")
            Label.Parent = CheckFrame
            Label.Text = "  "..(config.Title or "Checkbox")
            Label.Size = UDim2.new(1, -s(40), 1, 0)
            Label.Position = UDim2.new(0, s(10), 0, 0)
            Label.TextColor3 = Color3.fromRGB(0, 80, 255)
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = s(11)
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local Box = Instance.new("Frame")
            Box.Parent = CheckFrame
            Box.Size = UDim2.new(0, s(18), 0, s(18))
            Box.Position = UDim2.new(1, -s(28), 0.5, -s(9))
            Box.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, s(4))
            
            local CheckStroke = Instance.new("UIStroke")
            CheckStroke.Color = Color3.fromRGB(0, 80, 255)
            CheckStroke.Thickness = 1
            CheckStroke.Transparency = 0.6
            CheckStroke.Parent = Box
            
            local Fill = Instance.new("Frame")
            Fill.Parent = Box
            Fill.Size = UDim2.new(0, 0, 0, 0)
            Fill.Position = UDim2.new(0.5, 0, 0.5, 0)
            Fill.AnchorPoint = Vector2.new(0.5, 0.5)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 80, 255)
            Fill.ZIndex = 2
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, s(2))
            
            local checked = config.Default or false
            if checked then
                Fill.Size = UDim2.new(0.7, 0, 0.7, 0)
            end
            
            local Btn = Instance.new("TextButton")
            Btn.Parent = CheckFrame
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""
            Btn.ZIndex = 3
            
            Btn.MouseButton1Click:Connect(function()
                checked = not checked
                TweenService:Create(Fill, TweenInfo.new(0.15), {
                    Size = checked and UDim2.new(0.7, 0, 0.7, 0) or UDim2.new(0, 0, 0, 0)
                }):Play()
                if config.Callback then
                    config.Callback(checked)
                end
            end)
            
            return {
                GetState = function() return checked end,
                SetState = function(state)
                    checked = state
                    TweenService:Create(Fill, TweenInfo.new(0.15), {
                        Size = checked and UDim2.new(0.7, 0, 0.7, 0) or UDim2.new(0, 0, 0, 0)
                    }):Play()
                end
            }
        end
        
        function Tab:TextBox(config)
            local parent = self:GetSide(config.Section)
            if not parent then return end

            local isOpen = type(config.Default) == "boolean" and config.Default or false
            local currentText = config.DefaultText or ""

            local TBFrame = Instance.new("Frame")
            TBFrame.Parent = parent
            TBFrame.Size = UDim2.new(1, 0, 0, s(85))
            TBFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
            TBFrame.ClipsDescendants = false
            Instance.new("UICorner", TBFrame).CornerRadius = UDim.new(0, s(14))

            local BoxStroke = Instance.new("UIStroke")
            BoxStroke.Color = Color3.fromRGB(0, 80, 255)
            BoxStroke.Thickness = 1.2
            BoxStroke.Transparency = 0.6
            BoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            BoxStroke.Parent = TBFrame

            local TitleText = Instance.new("TextLabel")
            TitleText.Parent = TBFrame
            TitleText.Text = " "..(config.Title or "TextBox")
            TitleText.Size = UDim2.new(1, -s(50), 0, s(25))
            TitleText.Position = UDim2.new(0, s(10), 0, s(10))
            TitleText.TextColor3 = Color3.fromRGB(0, 80, 255)
            TitleText.Font = Enum.Font.GothamBold
            TitleText.TextSize = s(12)
            TitleText.BackgroundTransparency = 1
            TitleText.TextXAlignment = Enum.TextXAlignment.Left

            local DescText = Instance.new("TextLabel")
            DescText.Parent = TBFrame
            DescText.Text = " "..(config.Description or "")
            DescText.Size = UDim2.new(1, -s(50), 0, s(15))
            DescText.Position = UDim2.new(0, s(10), 0, s(32))
            DescText.TextColor3 = Color3.fromRGB(0, 80, 255)
            DescText.Font = Enum.Font.Gotham
            DescText.TextSize = s(9)
            DescText.BackgroundTransparency = 1
            DescText.TextXAlignment = Enum.TextXAlignment.Left

            local InputWrapper = Instance.new("Frame")
            InputWrapper.Parent = TBFrame
            InputWrapper.Size = UDim2.new(1, -s(20), 0, s(22))
            InputWrapper.Position = UDim2.new(0, s(10), 0, s(58))
            InputWrapper.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            InputWrapper.ZIndex = 2
            Instance.new("UICorner", InputWrapper).CornerRadius = UDim.new(0, s(6))

            local InputStroke = Instance.new("UIStroke")
            InputStroke.Color = Color3.fromRGB(50, 50, 55)
            InputStroke.Thickness = 1
            InputStroke.Transparency = 0
            InputStroke.Parent = InputWrapper

            local InputBox = Instance.new("TextBox")
            InputBox.Parent = InputWrapper
            InputBox.Size = UDim2.new(1, 0, 1, 0)
            InputBox.BackgroundTransparency = 1
            InputBox.TextColor3 = Color3.fromRGB(0, 120, 255)
            InputBox.PlaceholderText = config.Placeholder or "Type here..."
            InputBox.PlaceholderColor3 = Color3.fromRGB(0, 80, 255)
            InputBox.Text = currentText
            InputBox.Font = Enum.Font.Gotham
            InputBox.TextSize = s(11)
            InputBox.TextXAlignment = Enum.TextXAlignment.Left
            InputBox.ClearTextOnFocus = false
            InputBox.ZIndex = 3
            Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, s(6))

            local InputPad = Instance.new("UIPadding")
            InputPad.Parent = InputBox
            InputPad.PaddingLeft = UDim.new(0, s(8))

            InputBox.FocusLost:Connect(function(enterPressed)
                currentText = InputBox.Text
                if config.Callback then config.Callback(currentText, enterPressed) end
            end)

            return {
                GetText = function() return currentText end,
                SetText = function(text)
                    currentText = text
                    InputBox.Text = text
                end,
            }
        end

        function Tab:Group(config)
            local parent = self:GetSide(config.Section)
            if not parent then return end

            local checkboxes = config.Checkboxes or {}
            local textboxes = config.TextBoxes or {}
            local dropdowns = config.Dropdowns or {}
            if config.Dropdown ~= nil then
                table.insert(dropdowns, 1, config.Dropdown)
            end
            local sliders = config.Sliders or {}
            if config.Min and config.Max then
                table.insert(sliders, 1, {
                    Min = config.Min,
                    Max = config.Max,
                    Default = config.SliderDefault or config.Min,
                    Description = config.SliderDescription or ""
                })
            end

            local baseHeight = s(58)
            local CollapsedHeight = baseHeight
            for _, d in ipairs(dropdowns) do
                baseHeight = baseHeight + s(28)
                if d.Description and d.Description ~= "" then baseHeight = baseHeight + s(14) end
            end
            for _, sl in ipairs(sliders) do
                baseHeight = baseHeight + s(35)
                if sl.Description and sl.Description ~= "" then baseHeight = baseHeight + s(6) end
            end
            if #checkboxes > 0 then baseHeight = baseHeight + (#checkboxes * s(28)) end
            for _, tb in ipairs(textboxes) do
                baseHeight = baseHeight + s(32)
                if tb.Description and tb.Description ~= "" then baseHeight = baseHeight + s(14) end
            end

            local GroupFrame = Instance.new("Frame")
            GroupFrame.Parent = parent
            GroupFrame.Size = UDim2.new(1, 0, 0, baseHeight)
            GroupFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
            GroupFrame.ClipsDescendants = true
            GroupFrame.ZIndex = 5
            Instance.new("UICorner", GroupFrame).CornerRadius = UDim.new(0, s(14))

            local BoxStroke = Instance.new("UIStroke")
            BoxStroke.Color = Color3.fromRGB(0, 80, 255)
            BoxStroke.Thickness = 1.2
            BoxStroke.Transparency = 0.6
            BoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            BoxStroke.Parent = GroupFrame

            local TitleText = Instance.new("TextLabel")
            TitleText.Parent = GroupFrame
            TitleText.Text = " "..(config.Title or "Group")
            TitleText.Size = UDim2.new(1, -s(50), 0, s(25))
            TitleText.Position = UDim2.new(0, s(10), 0, s(10))
            TitleText.TextColor3 = Color3.fromRGB(0, 80, 255)
            TitleText.Font = Enum.Font.GothamBold
            TitleText.TextSize = s(12)
            TitleText.BackgroundTransparency = 1
            TitleText.TextXAlignment = Enum.TextXAlignment.Left
            TitleText.ZIndex = 6

            local DescText = Instance.new("TextLabel")
            DescText.Parent = GroupFrame
            DescText.Text = " "..(config.Description or "")
            DescText.Size = UDim2.new(1, -s(50), 0, s(15))
            DescText.Position = UDim2.new(0, s(10), 0, s(32))
            DescText.TextColor3 = Color3.fromRGB(0, 80, 255)
            DescText.Font = Enum.Font.Gotham
            DescText.TextSize = s(9)
            DescText.BackgroundTransparency = 1
            DescText.TextXAlignment = Enum.TextXAlignment.Left
            DescText.ZIndex = 6

            local Switch = Instance.new("Frame")
            Switch.Parent = GroupFrame
            Switch.Size = UDim2.new(0, s(34), 0, s(18))
            Switch.Position = UDim2.new(1, -s(46), 0, s(21))
            Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            Switch.ZIndex = 6
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

            local Dot = Instance.new("Frame")
            Dot.Parent = Switch
            Dot.Size = UDim2.new(0, s(14), 0, s(14))
            Dot.Position = UDim2.new(0, s(2), 0.5, -s(7))
            Dot.BackgroundColor3 = Color3.fromRGB(120, 120, 125)
            Dot.ZIndex = 7
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

            local Moduled = type(config.Default) == "boolean" and config.Default or false
            local sliderValues = {}
            local checkboxStates = {}
            local dropdownValues = {}
            for idx, d in ipairs(dropdowns) do
                dropdownValues[idx] = d.Default or (d.Options and d.Options[1]) or ""
            end
            local selectedOption = dropdownValues[1]

            if Moduled then
                Dot.Position = UDim2.new(0, s(18), 0.5, -s(7))
                Dot.BackgroundColor3 = Color3.fromRGB(0, 80, 255)
            end

            local ExpandedHeight = baseHeight

            local MainBtn = Instance.new("TextButton")
            MainBtn.Parent = GroupFrame
            MainBtn.Size = UDim2.new(1, 0, 0, s(50))
            MainBtn.BackgroundTransparency = 1
            MainBtn.Text = ""
            MainBtn.ZIndex = 10

            MainBtn.MouseButton1Click:Connect(function()
                Moduled = not Moduled
                TweenService:Create(Dot, TweenInfo.new(0.2), {
                    Position = Moduled and UDim2.new(0, s(18), 0.5, -s(7)) or UDim2.new(0, s(2), 0.5, -s(7)),
                    BackgroundColor3 = Moduled and Color3.fromRGB(0, 80, 255) or Color3.fromRGB(120, 120, 125)
                }):Play()
                TweenService:Create(GroupFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                    Size = UDim2.new(1, 0, 0, Moduled and ExpandedHeight or CollapsedHeight)
                }):Play()
                if config.Callback then
                    config.Callback(Moduled, dropdownValues, sliderValues, checkboxStates)
                end
            end)

            local currentYPos = s(55)

            for didx, dropCfg in ipairs(dropdowns) do
                local dropdownOptions = dropCfg.Options or {"Option 1"}
                local dropdownDesc = dropCfg.Description or ""

                if dropdownDesc ~= "" then
                    local DropLabel = Instance.new("TextLabel")
                    DropLabel.Parent = GroupFrame
                    DropLabel.Text = dropdownDesc
                    DropLabel.Size = UDim2.new(1, -s(20), 0, s(12))
                    DropLabel.Position = UDim2.new(0, s(10), 0, currentYPos)
                    DropLabel.TextColor3 = Color3.fromRGB(0, 80, 255)
                    DropLabel.Font = Enum.Font.Gotham
                    DropLabel.TextSize = s(9)
                    DropLabel.BackgroundTransparency = 1
                    DropLabel.TextXAlignment = Enum.TextXAlignment.Left
                    DropLabel.ZIndex = 6
                    currentYPos = currentYPos + s(14)
                    baseHeight = baseHeight + s(14)
                    GroupFrame.Size = UDim2.new(1, 0, 0, baseHeight)
                end

                local Selected = Instance.new("Frame")
                Selected.Parent = GroupFrame
                Selected.Size = UDim2.new(1, -s(20), 0, s(18))
                Selected.Position = UDim2.new(0, s(10), 0, currentYPos)
                Selected.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                Selected.ZIndex = 6
                Instance.new("UICorner", Selected).CornerRadius = UDim.new(0, s(6))

                local SelectedText = Instance.new("TextLabel")
                SelectedText.Parent = Selected
                SelectedText.Text = dropdownValues[didx]
                SelectedText.Size = UDim2.new(1, -s(10), 1, 0)
                SelectedText.Position = UDim2.new(0, s(8), 0, 0)
                SelectedText.TextColor3 = Color3.fromRGB(0, 80, 255)
                SelectedText.Font = Enum.Font.GothamBold
                SelectedText.TextSize = s(10)
                SelectedText.BackgroundTransparency = 1
                SelectedText.TextXAlignment = Enum.TextXAlignment.Left
                SelectedText.ZIndex = 7

                local DropdownBtn = Instance.new("TextButton")
                DropdownBtn.Parent = Selected
                DropdownBtn.Size = UDim2.new(1, 0, 1, 0)
                DropdownBtn.BackgroundTransparency = 1
                DropdownBtn.Text = ""
                DropdownBtn.ZIndex = 11

                local OptionsHolder = Instance.new("Frame")
                OptionsHolder.Parent = GroupFrame
                OptionsHolder.Size = UDim2.new(1, 0, 0, 0)
                OptionsHolder.Position = UDim2.new(0, 0, 0, currentYPos + s(20))
                OptionsHolder.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
                OptionsHolder.Visible = false
                OptionsHolder.ZIndex = 100
                OptionsHolder.ClipsDescendants = true
                Instance.new("UICorner", OptionsHolder).CornerRadius = UDim.new(0, s(8))

                local HolderStroke = Instance.new("UIStroke")
                HolderStroke.Color = Color3.fromRGB(0, 80, 255)
                HolderStroke.Thickness = 1.2
                HolderStroke.Parent = OptionsHolder

                local OptionsScroll = Instance.new("ScrollingFrame")
                OptionsScroll.Parent = OptionsHolder
                OptionsScroll.Size = UDim2.new(1, -s(10), 1, -s(10))
                OptionsScroll.Position = UDim2.new(0, s(5), 0, s(5))
                OptionsScroll.BackgroundTransparency = 1
                OptionsScroll.ScrollBarThickness = 0
                OptionsScroll.ZIndex = 101
                OptionsScroll.CanvasSize = UDim2.new(0, 0, 0, #dropdownOptions * s(25))
                Instance.new("UIListLayout", OptionsScroll).Padding = UDim.new(0, s(3))

                local isOpen = false
                local capturedDidx = didx
                for i, option in ipairs(dropdownOptions) do
                    local OptionBtn = Instance.new("TextButton")
                    OptionBtn.Parent = OptionsScroll
                    OptionBtn.Size = UDim2.new(1, 0, 0, s(22))
                    OptionBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
                    OptionBtn.Text = "  "..option
                    OptionBtn.TextColor3 = Color3.fromRGB(0, 80, 255)
                    OptionBtn.Font = Enum.Font.GothamBold
                    OptionBtn.TextSize = s(10)
                    OptionBtn.TextXAlignment = Enum.TextXAlignment.Left
                    OptionBtn.ZIndex = 102
                    Instance.new("UICorner", OptionBtn).CornerRadius = UDim.new(0, s(4))
                    OptionBtn.MouseButton1Click:Connect(function()
                        dropdownValues[capturedDidx] = option
                        selectedOption = dropdownValues[1]
                        SelectedText.Text = option
                        isOpen = false
                        OptionsHolder.Visible = false
                        TweenService:Create(OptionsHolder, TweenInfo.new(0.4), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                        if config.Callback then
                            config.Callback(Moduled, dropdownValues, sliderValues, checkboxStates)
                        end
                    end)
                end

                DropdownBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    OptionsHolder.Visible = isOpen
                    TweenService:Create(OptionsHolder, TweenInfo.new(0.2), {
                        Size = isOpen and UDim2.new(1, 0, 0, math.min(s(110), #dropdownOptions * s(25) + s(10))) or UDim2.new(1, 0, 0, 0)
                    }):Play()
                end)

                currentYPos = currentYPos + s(28)
            end

            for idx, sliderCfg in ipairs(sliders) do
                local sMin = sliderCfg.Min or 0
                local sMax = sliderCfg.Max or 100
                local sDefault = sliderCfg.Default or sMin
                sDefault = math.clamp(sDefault, sMin, sMax)
                local sDesc = sliderCfg.Description or ""
                local sVal = sDefault
                sliderValues[idx] = sVal

                if sDesc ~= "" then
                    local SliderLabel = Instance.new("TextLabel")
                    SliderLabel.Parent = GroupFrame
                    SliderLabel.Text = sDesc
                    SliderLabel.Size = UDim2.new(1, -s(20), 0, s(12))
                    SliderLabel.Position = UDim2.new(0, s(10), 0, currentYPos + s(2))
                    SliderLabel.TextColor3 = Color3.fromRGB(0, 80, 255)
                    SliderLabel.Font = Enum.Font.Gotham
                    SliderLabel.TextSize = s(9)
                    SliderLabel.BackgroundTransparency = 1
                    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                    SliderLabel.ZIndex = 6
                end

                local initialPos = (sVal - sMin) / (sMax - sMin)

                local SliderBar = Instance.new("Frame")
                SliderBar.Parent = GroupFrame
                SliderBar.Size = UDim2.new(1, -s(20), 0, s(4))
                SliderBar.Position = UDim2.new(0, s(10), 0, currentYPos + (sDesc ~= "" and s(18) or s(13)))
                SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                SliderBar.ZIndex = 6
                Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

                local Fill = Instance.new("Frame")
                Fill.Parent = SliderBar
                Fill.Size = UDim2.new(initialPos, 0, 1, 0)
                Fill.BackgroundColor3 = Color3.fromRGB(0, 80, 255)
                Fill.ZIndex = 6
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

                local SliderDot = Instance.new("Frame")
                SliderDot.Parent = SliderBar
                SliderDot.Size = UDim2.new(0, s(12), 0, s(12))
                SliderDot.Position = UDim2.new(initialPos, 0, 0.5, 0)
                SliderDot.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderDot.BackgroundColor3 = Color3.fromRGB(0, 80, 255)
                SliderDot.ZIndex = 11
                Instance.new("UICorner", SliderDot).CornerRadius = UDim.new(1, 0)

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Parent = GroupFrame
                ValLabel.Text = tostring(sVal)
                ValLabel.Size = UDim2.new(0, s(40), 0, s(20))
                ValLabel.Position = UDim2.new(1, -s(50), 0, currentYPos + (sDesc ~= "" and -s(8) or -s(10)))
                ValLabel.TextColor3 = Color3.fromRGB(0, 80, 255)
                ValLabel.Font = Enum.Font.GothamBold
                ValLabel.TextSize = s(10)
                ValLabel.BackgroundTransparency = 1
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValLabel.ZIndex = 6

                local drag = false
                local capturedIdx = idx
                local function move(input)
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    sliderValues[capturedIdx] = math.floor(sMin + (sMax - sMin) * pos)
                    ValLabel.Text = tostring(sliderValues[capturedIdx])
                    TweenService:Create(Fill, TweenInfo.new(0.24, Enum.EasingStyle.Quart), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                    TweenService:Create(SliderDot, TweenInfo.new(0.24, Enum.EasingStyle.Quart), {Position = UDim2.new(pos, 0, 0.5, 0)}):Play()
                    if config.Callback and Moduled then
                        config.Callback(Moduled, selectedOption, sliderValues, checkboxStates)
                    end
                end

                SliderBar.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        drag = true
                        move(i)
                    end
                end)
                UIS.InputChanged:Connect(function(i)
                    if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        move(i)
                    end
                end)
                UIS.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        drag = false
                    end
                end)

                currentYPos = currentYPos + (sDesc ~= "" and s(41) or s(35))
            end
            
            if #checkboxes > 0 then
                local checkboxDesc = config.CheckboxesDescription or ""
                
                if checkboxDesc ~= "" then
                    local CheckboxLabel = Instance.new("TextLabel")
                    CheckboxLabel.Parent = GroupFrame
                    CheckboxLabel.Text = checkboxDesc
                    CheckboxLabel.Size = UDim2.new(1, -s(20), 0, s(12))
                    CheckboxLabel.Position = UDim2.new(0, s(10), 0, currentYPos)
                    CheckboxLabel.TextColor3 = Color3.fromRGB(0, 80, 255)
                    CheckboxLabel.Font = Enum.Font.Gotham
                    CheckboxLabel.TextSize = s(9)
                    CheckboxLabel.BackgroundTransparency = 1
                    CheckboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                    CheckboxLabel.ZIndex = 6
                    currentYPos = currentYPos + s(14)
                    baseHeight = baseHeight + s(14)
                    GroupFrame.Size = UDim2.new(1, 0, 0, baseHeight)
                end
                
                local CheckContainer = Instance.new("Frame")
                CheckContainer.Parent = GroupFrame
                CheckContainer.Size = UDim2.new(1, -s(20), 0, #checkboxes * s(28))
                CheckContainer.Position = UDim2.new(0, s(10), 0, currentYPos)
                CheckContainer.BackgroundTransparency = 1
                CheckContainer.ZIndex = 6
                
                local CL = Instance.new("UIListLayout")
                CL.Parent = CheckContainer
                CL.Padding = UDim.new(0, s(4))

                for _, name in ipairs(checkboxes) do
                    checkboxStates[name] = false
                    
                    local CF = Instance.new("Frame")
                    CF.Parent = CheckContainer
                    CF.Size = UDim2.new(1, 0, 0, s(24))
                    CF.BackgroundTransparency = 1
                    CF.ZIndex = 6
                    
                    local Label = Instance.new("TextLabel")
                    Label.Parent = CF
                    Label.Text = name
                    Label.Size = UDim2.new(1, -s(30), 1, 0)
                    Label.Position = UDim2.new(0, s(5), 0, 0)
                    Label.TextColor3 = Color3.fromRGB(0, 80, 255)
                    Label.Font = Enum.Font.Gotham
                    Label.TextSize = s(10)
                    Label.BackgroundTransparency = 1
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.ZIndex = 6
                    
                    local Box = Instance.new("Frame")
                    Box.Parent = CF
                    Box.Size = UDim2.new(0, s(16), 0, s(16))
                    Box.Position = UDim2.new(1, -s(20), 0.5, -s(8))
                    Box.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
                    Box.ZIndex = 6
                    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, s(4))
                    
                    local BoxStrokeInner = Instance.new("UIStroke")
                    BoxStrokeInner.Color = Color3.fromRGB(0, 80, 255)
                    BoxStrokeInner.Thickness = 1
                    BoxStrokeInner.Transparency = 0.6
                    BoxStrokeInner.Parent = Box
                    
                    local Fill = Instance.new("Frame")
                    Fill.Parent = Box
                    Fill.Size = UDim2.new(0, 0, 0, 0)
                    Fill.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Fill.AnchorPoint = Vector2.new(0.5, 0.5)
                    Fill.BackgroundColor3 = Color3.fromRGB(0, 80, 255)
                    Fill.ZIndex = 7
                    Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, s(2))
                    
                    local CbBtn = Instance.new("TextButton")
                    CbBtn.Parent = CF
                    CbBtn.Size = UDim2.new(1, 0, 1, 0)
                    CbBtn.BackgroundTransparency = 1
                    CbBtn.Text = ""
                    CbBtn.ZIndex = 8
                    
                    CbBtn.MouseButton1Click:Connect(function()
                        checkboxStates[name] = not checkboxStates[name]
                        TweenService:Create(Fill, TweenInfo.new(0.15), {
                            Size = checkboxStates[name] and UDim2.new(0.7, 0, 0.7, 0) or UDim2.new(0, 0, 0, 0)
                        }):Play()
                        if config.Callback then
                            config.Callback(Moduled, dropdownValues, sliderValues, checkboxStates, textboxValues)
                        end
                    end)
                end
                currentYPos = currentYPos + (#checkboxes * s(28))
            end

            local textboxValues = {}
            if #textboxes > 0 then
                currentYPos = currentYPos + s(8)
                for tidx, tbCfg in ipairs(textboxes) do
                    local tbDesc = tbCfg.Description or ""
                    local tbDefault = tbCfg.Default or ""
                    textboxValues[tidx] = tbDefault

                    if tbDesc ~= "" then
                        local TBLabel = Instance.new("TextLabel")
                        TBLabel.Parent = GroupFrame
                        TBLabel.Text = tbDesc
                        TBLabel.Size = UDim2.new(1, -s(20), 0, s(12))
                        TBLabel.Position = UDim2.new(0, s(10), 0, currentYPos)
                        TBLabel.TextColor3 = Color3.fromRGB(0, 80, 255)
                        TBLabel.Font = Enum.Font.Gotham
                        TBLabel.TextSize = s(9)
                        TBLabel.BackgroundTransparency = 1
                        TBLabel.TextXAlignment = Enum.TextXAlignment.Left
                        TBLabel.ZIndex = 6
                        currentYPos = currentYPos + s(14)
                        baseHeight = baseHeight + s(14)
                        GroupFrame.Size = UDim2.new(1, 0, 0, baseHeight)
                    end

                    local InputWrapper = Instance.new("Frame")
                    InputWrapper.Parent = GroupFrame
                    InputWrapper.Size = UDim2.new(1, -s(20), 0, s(22))
                    InputWrapper.Position = UDim2.new(0, s(10), 0, currentYPos)
                    InputWrapper.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                    InputWrapper.ZIndex = 6
                    Instance.new("UICorner", InputWrapper).CornerRadius = UDim.new(0, s(6))

                    local InputStroke = Instance.new("UIStroke")
                    InputStroke.Color = Color3.fromRGB(50, 50, 55)
                    InputStroke.Thickness = 1
                    InputStroke.Transparency = 0
                    InputStroke.Parent = InputWrapper

                    local InputBox = Instance.new("TextBox")
                    InputBox.Parent = InputWrapper
                    InputBox.Size = UDim2.new(1, 0, 1, 0)
                    InputBox.BackgroundTransparency = 1
                    InputBox.TextColor3 = Color3.fromRGB(0, 120, 255)
                    InputBox.PlaceholderText = tbCfg.Placeholder or "Type here..."
                    InputBox.PlaceholderColor3 = Color3.fromRGB(0, 80, 255)
                    InputBox.Text = tbDefault
                    InputBox.Font = Enum.Font.Gotham
                    InputBox.TextSize = s(11)
                    InputBox.TextXAlignment = Enum.TextXAlignment.Left
                    InputBox.ClearTextOnFocus = false
                    InputBox.ZIndex = 7
                    Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, s(6))

                    local InputPad = Instance.new("UIPadding")
                    InputPad.Parent = InputBox
                    InputPad.PaddingLeft = UDim.new(0, s(8))

                    local capturedTidx = tidx
                    InputBox.FocusLost:Connect(function(enterPressed)
                        textboxValues[capturedTidx] = InputBox.Text
                        if tbCfg.Callback then
                            tbCfg.Callback(InputBox.Text, enterPressed)
                        end
                    end)

                    currentYPos = currentYPos + s(30)
                end
            end

            ExpandedHeight = baseHeight
            GroupFrame.Size = UDim2.new(1, 0, 0, Moduled and ExpandedHeight or CollapsedHeight)

            return {
                GetModuleState = function() return Moduled end,
                GetDropdownValues = function() return dropdownValues end,
                GetDropdownValue = function(idx) return dropdownValues[idx or 1] end,
                GetSliderValues = function() return sliderValues end,
                GetSliderValue = function(idx) return sliderValues[idx or 1] end,
                GetCheckboxStates = function() return checkboxStates end,
                GetTextBoxValues = function() return textboxValues end,
                GetTextBoxValue = function(idx) return textboxValues[idx or 1] end,
                SetModuleState = function(state)
                    Moduled = state
                    TweenService:Create(Dot, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
                        Position = Moduled and UDim2.new(0, s(18), 0.5, -s(7)) or UDim2.new(0, s(2), 0.5, -s(7)),
                        BackgroundColor3 = Moduled and Color3.fromRGB(0, 80, 255) or Color3.fromRGB(120, 120, 125)
                    }):Play()
                    TweenService:Create(GroupFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                        Size = UDim2.new(1, 0, 0, Moduled and ExpandedHeight or CollapsedHeight)
                    }):Play()
                    if config.Callback then
                        config.Callback(Moduled, dropdownValues, sliderValues, checkboxStates, textboxValues)
                    end
                end,
                SetCheckboxState = function(name, state)
                    if checkboxStates[name] ~= nil then
                        checkboxStates[name] = state
                        if config.Callback then
                            config.Callback(Moduled, dropdownValues, sliderValues, checkboxStates, textboxValues)
                        end
                    end
                end
            }
        end
        
        return Tab
    end
    
    return Window
end

return Library