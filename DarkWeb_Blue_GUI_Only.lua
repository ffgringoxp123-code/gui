
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarkWeb_Blue_GUI_Only"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Name = "Container"
Main.Size = UDim2.new(0,700,0,450)
Main.Position = UDim2.new(0.5,-350,0.5,-225)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.BorderColor3 = Color3.fromRGB(0,170,255)
Main.Parent = ScreenGui

local TopBar = Instance.new("TextButton")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1,0,0,35)
TopBar.Text = "DarkWeb.Blue"
TopBar.Parent = Main

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0,40,0,40)
Toggle.Position = UDim2.new(0,10,0,10)
Toggle.Text = "DW"
Toggle.Parent = ScreenGui

local Open = true
Toggle.MouseButton1Click:Connect(function()
	Open = not Open
	Main.Visible = Open
end)

local UIS = game:GetService("UserInputService")
local dragging, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(
			startPos.X.Scale,startPos.X.Offset + delta.X,
			startPos.Y.Scale,startPos.Y.Offset + delta.Y
		)
	end
end)
