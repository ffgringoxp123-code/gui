local CoreGui = game:GetService("CoreGui")

local gui = Instance.new("ScreenGui")
gui.Name = "DarkWebBlue_GUI_Only"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.new(0,680,0,460)
Container.Position = UDim2.new(0.5,-340,0.5,-230)
Container.BackgroundColor3 = Color3.fromRGB(0,0,0)
Container.BorderSizePixel = 0
Container.Parent = gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0,12)
Corner.Parent = Container

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0,170,255)
Stroke.Parent = Container

local Handler = Instance.new("Frame")
Handler.BackgroundTransparency = 1
Handler.Size = UDim2.new(1,0,1,0)
Handler.Parent = Container

local Icon = Instance.new("ImageLabel")
Icon.Name = "Icon"
Icon.Image = "rbxassetid://129430365420845"
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0.025,0,0.03,0)
Icon.Size = UDim2.new(0,24,0,24)
Icon.Parent = Handler

local ClientName = Instance.new("TextLabel")
ClientName.Text = "DarkWeb.Blue"
ClientName.TextColor3 = Color3.fromRGB(0,170,255)
ClientName.BackgroundTransparency = 1
ClientName.Position = UDim2.new(0.07,0,0.02,0)
ClientName.Size = UDim2.new(0,200,0,30)
ClientName.TextXAlignment = Enum.TextXAlignment.Left
ClientName.Parent = Handler

local TopDivider = Instance.new("Frame")
TopDivider.Size = UDim2.new(0.85,0,0,1)
TopDivider.Position = UDim2.new(0.075,0,0.08,0)
TopDivider.BackgroundColor3 = Color3.fromRGB(0,120,255)
TopDivider.BorderSizePixel = 0
TopDivider.Parent = Handler

local Tabs = Instance.new("ScrollingFrame")
Tabs.Name = "Tabs"
Tabs.Size = UDim2.new(0,129,0,401)
Tabs.Position = UDim2.new(0.026,0,0.111,0)
Tabs.BackgroundTransparency = 1
Tabs.ScrollBarThickness = 0
Tabs.Parent = Handler

local SideDivider = Instance.new("Frame")
SideDivider.Size = UDim2.new(0,2,0,340)
SideDivider.Position = UDim2.new(0.235,0,0.18,0)
SideDivider.BackgroundColor3 = Color3.fromRGB(0,120,255)
SideDivider.BorderSizePixel = 0
SideDivider.Parent = Handler

local Sections = Instance.new("Folder")
Sections.Name = "Sections"
Sections.Parent = Handler

print("DarkWeb.Blue GUI Only Loaded")
