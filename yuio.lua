repeat
	task.wait()
until game:IsLoaded()

local library = {}
local ToggleUI = false
library.currentTab = nil
library.flags = {}

local services = setmetatable({}, {
	__index = function(t, k)
		return game.GetService(game, k)
	end,
})

local mouse = services.Players.LocalPlayer:GetMouse()

-- Modern color scheme
local colors = {
    Main = Color3.fromRGB(10, 10, 20),
    Secondary = Color3.fromRGB(20, 20, 40),
    Accent = Color3.fromRGB(0, 150, 255),
    Text = Color3.fromRGB(240, 240, 240),
    DarkText = Color3.fromRGB(50, 50, 70),
    Slider = Color3.fromRGB(0, 120, 215),
    ToggleOn = Color3.fromRGB(0, 200, 100),
    ToggleOff = Color3.fromRGB(70, 70, 90),
    Dropdown = Color3.fromRGB(30, 30, 50),
    Button = Color3.fromRGB(0, 100, 200),
    ButtonHover = Color3.fromRGB(0, 120, 230),
    Section = Color3.fromRGB(25, 25, 45)
}

-- Animation functions
function Tween(obj, t, data)
	services.TweenService
		:Create(obj, TweenInfo.new(t[1], Enum.EasingStyle[t[2]], Enum.EasingDirection[t[3]]), data)
		:Play()
	return true
end

function Ripple(obj)
	spawn(function()
		if obj.ClipsDescendants ~= true then
			obj.ClipsDescendants = true
		end
		local Ripple = Instance.new("ImageLabel")
		Ripple.Name = "Ripple"
		Ripple.Parent = obj
		Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Ripple.BackgroundTransparency = 1.000
		Ripple.ZIndex = 8
		Ripple.Image = "rbxassetid://2708891598"
		Ripple.ImageTransparency = 0.800
		Ripple.ScaleType = Enum.ScaleType.Fit
		Ripple.ImageColor3 = colors.Accent
		Ripple.Position = UDim2.new(
			(mouse.X - Ripple.AbsolutePosition.X) / obj.AbsoluteSize.X,
			0,
			(mouse.Y - Ripple.AbsolutePosition.Y) / obj.AbsoluteSize.Y,
			0
		)
		Tween(
			Ripple,
			{ 0.3, "Linear", "InOut" },
			{ Position = UDim2.new(-5.5, 0, -5.5, 0), Size = UDim2.new(12, 0, 12, 0) }
		)
		wait(0.15)
		Tween(Ripple, { 0.3, "Linear", "InOut" }, { ImageTransparency = 1 })
		wait(0.3)
		Ripple:Destroy()
	end)
end

local toggled = false
local switchingTabs = false

function switchTab(new)
	if switchingTabs then
		return
	end
	local old = library.currentTab
	if old == nil then
		new[2].Visible = true
		library.currentTab = new
		services.TweenService:Create(new[1], TweenInfo.new(0.1), { ImageTransparency = 0 }):Play()
		services.TweenService:Create(new[1].TabText, TweenInfo.new(0.1), { TextTransparency = 0 }):Play()
		return
	end
	if old[1] == new[1] then
		return
	end
	switchingTabs = true
	library.currentTab = new
	services.TweenService:Create(old[1], TweenInfo.new(0.1), { ImageTransparency = 0.2 }):Play()
	services.TweenService:Create(new[1], TweenInfo.new(0.1), { ImageTransparency = 0 }):Play()
	services.TweenService:Create(old[1].TabText, TweenInfo.new(0.1), { TextTransparency = 0.2 }):Play()
	services.TweenService:Create(new[1].TabText, TweenInfo.new(0.1), { TextTransparency = 0 }):Play()
	old[2].Visible = false
	new[2].Visible = true
	task.wait(0.1)
	switchingTabs = false
end

function drag(frame, hold)
	if not hold then
		hold = frame
	end
	local dragging
	local dragInput
	local dragStart
	local startPos
	local function update(input)
		local delta = input.Position - dragStart
		frame.Position =
			UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	hold.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	services.UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

function library.new(library, name, theme)
	for _, v in next, services.CoreGui:GetChildren() do
		if v.Name == "FrostyModernUI" then
			v:Destroy()
		end
	end

	local dogent = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local MainCorner = Instance.new("UICorner")
	local TabMain = Instance.new("Frame")
	local SidePanel = Instance.new("Frame")
	local SideCorner = Instance.new("UICorner")
	local TabButtons = Instance.new("ScrollingFrame")
	local TabListLayout = Instance.new("UIListLayout")
	local Title = Instance.new("TextLabel")
	local GlowEffect = Instance.new("ImageLabel")
	local MinimizeButton = Instance.new("ImageButton")
	local SearchBox = Instance.new("TextBox")
	local SearchIcon = Instance.new("ImageLabel")
	
	-- UI Creation
	dogent.Name = "FrostyModernUI"
	dogent.Parent = services.CoreGui
	dogent.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	if syn and syn.protect_gui then
		syn.protect_gui(dogent)
	end

	Main.Name = "Main"
	Main.Parent = dogent
	Main.BackgroundColor3 = colors.Main
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(1, -450, 0.5, -200)
	Main.Size = UDim2.new(0, 450, 0, 500)
	Main.ZIndex = 2
	Main.ClipsDescendants = true
	
	MainCorner.CornerRadius = UDim.new(0, 8)
	MainCorner.Name = "MainCorner"
	MainCorner.Parent = Main
	
	-- Glow effect
	GlowEffect.Name = "GlowEffect"
	GlowEffect.Parent = Main
	GlowEffect.BackgroundTransparency = 1
	GlowEffect.BorderSizePixel = 0
	GlowEffect.Size = UDim2.new(1, 0, 1, 0)
	GlowEffect.ZIndex = 1
	GlowEffect.Image = "rbxassetid://4996891970"
	GlowEffect.ImageColor3 = colors.Accent
	GlowEffect.ScaleType = Enum.ScaleType.Slice
	GlowEffect.SliceCenter = Rect.new(49, 49, 451, 451)
	
	-- Title bar
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Parent = Main
	TitleBar.BackgroundColor3 = colors.Secondary
	TitleBar.BorderSizePixel = 0
	TitleBar.Size = UDim2.new(1, 0, 0, 40)
	
	local TitleCorner = Instance.new("UICorner")
	TitleCorner.Name = "TitleCorner"
	TitleCorner.Parent = TitleBar
	TitleCorner.CornerRadius = UDim.new(0, 8)
	
	Title.Name = "Title"
	Title.Parent = TitleBar
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.Size = UDim2.new(0.5, 0, 1, 0)
	Title.Font = Enum.Font.GothamBold
	Title.Text = name
	Title.TextColor3 = colors.Text
	Title.TextSize = 18
	Title.TextXAlignment = Enum.TextXAlignment.Left
	
	-- Minimize button
	MinimizeButton.Name = "MinimizeButton"
	MinimizeButton.Parent = TitleBar
	MinimizeButton.AnchorPoint = Vector2.new(1, 0.5)
	MinimizeButton.BackgroundTransparency = 1
	MinimizeButton.Position = UDim2.new(1, -10, 0.5, 0)
	MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
	MinimizeButton.Image = "rbxassetid://3926305904"
	MinimizeButton.ImageColor3 = colors.Text
	MinimizeButton.ImageRectOffset = Vector2.new(284, 4)
	MinimizeButton.ImageRectSize = Vector2.new(24, 24)
	
	-- Search box
	local SearchContainer = Instance.new("Frame")
	SearchContainer.Name = "SearchContainer"
	SearchContainer.Parent = Main
	SearchContainer.BackgroundColor3 = colors.Secondary
	SearchContainer.Position = UDim2.new(0, 15, 0, 50)
	SearchContainer.Size = UDim2.new(1, -30, 0, 35)
	
	local SearchCorner = Instance.new("UICorner")
	SearchCorner.Name = "SearchCorner"
	SearchCorner.Parent = SearchContainer
	SearchCorner.CornerRadius = UDim.new(0, 6)
	
	SearchIcon.Name = "SearchIcon"
	SearchIcon.Parent = SearchContainer
	SearchIcon.BackgroundTransparency = 1
	SearchIcon.Position = UDim2.new(0, 10, 0.5, -10)
	SearchIcon.Size = UDim2.new(0, 20, 0, 20)
	SearchIcon.Image = "rbxassetid://3926305904"
	SearchIcon.ImageColor3 = colors.Text
	SearchIcon.ImageRectOffset = Vector2.new(964, 324)
	SearchIcon.ImageRectSize = Vector2.new(36, 36)
	
	SearchBox.Name = "SearchBox"
	SearchBox.Parent = SearchContainer
	SearchBox.BackgroundTransparency = 1
	SearchBox.Position = UDim2.new(0, 40, 0, 0)
	SearchBox.Size = UDim2.new(1, -40, 1, 0)
	SearchBox.Font = Enum.Font.Gotham
	SearchBox.PlaceholderText = "Search..."
	SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
	SearchBox.Text = ""
	SearchBox.TextColor3 = colors.Text
	SearchBox.TextSize = 14
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left
	
	-- Side panel with tabs
	SidePanel.Name = "SidePanel"
	SidePanel.Parent = Main
	SidePanel.BackgroundColor3 = colors.Secondary
	SidePanel.Position = UDim2.new(0, 0, 0, 100)
	SidePanel.Size = UDim2.new(0, 120, 1, -100)
	
	SideCorner.CornerRadius = UDim.new(0, 8)
	SideCorner.Name = "SideCorner"
	SideCorner.Parent = SidePanel
	
	TabButtons.Name = "TabButtons"
	TabButtons.Parent = SidePanel
	TabButtons.Active = true
	TabButtons.BackgroundTransparency = 1
	TabButtons.BorderSizePixel = 0
	TabButtons.Position = UDim2.new(0, 10, 0, 10)
	TabButtons.Size = UDim2.new(1, -20, 1, -20)
	TabButtons.ScrollBarThickness = 3
	TabButtons.ScrollBarImageColor3 = colors.Accent
	
	TabListLayout.Name = "TabListLayout"
	TabListLayout.Parent = TabButtons
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim.new(0, 10)
	
	-- Main content area
	TabMain.Name = "TabMain"
	TabMain.Parent = Main
	TabMain.BackgroundTransparency = 1
	TabMain.Position = UDim2.new(0, 130, 0, 100)
	TabMain.Size = UDim2.new(1, -140, 1, -110)
	
	-- Toggle button (when UI is minimized)
	local ToggleButton = Instance.new("ImageButton")
	ToggleButton.Name = "ToggleButton"
	ToggleButton.Parent = dogent
	ToggleButton.BackgroundTransparency = 1
	ToggleButton.Position = UDim2.new(1, -50, 0.5, -25)
	ToggleButton.Size = UDim2.new(0, 50, 0, 50)
	ToggleButton.Image = "rbxassetid://3926305904"
	ToggleButton.ImageColor3 = colors.Accent
	ToggleButton.ImageRectOffset = Vector2.new(884, 324)
	ToggleButton.ImageRectSize = Vector2.new(36, 36)
	ToggleButton.Visible = false
	
	-- Animation variables
	local uiVisible = true
	local animating = false
	
	-- Toggle UI function
	local function toggleUI()
		if animating then return end
		animating = true
		
		if uiVisible then
			-- Slide out to the right
			Tween(Main, {0.3, "Quad", "Out"}, {Position = UDim2.new(1, -50, 0.5, -200)})
			wait(0.3)
			ToggleButton.Visible = true
		else
			ToggleButton.Visible = false
			-- Slide in from the right
			Tween(Main, {0.3, "Quad", "Out"}, {Position = UDim2.new(1, -450, 0.5, -200)})
		end
		
		uiVisible = not uiVisible
		animating = false
	end
	
	-- Connect toggle button
	MinimizeButton.MouseButton1Click:Connect(toggleUI)
	ToggleButton.MouseButton1Click:Connect(toggleUI)
	
	-- Make window draggable
	drag(Main, TitleBar)
	
	-- Function to destroy UI
	function UiDestroy()
		dogent:Destroy()
	end
	
	-- Function to toggle UI visibility
	function ToggleUILib()
		toggleUI()
	end
	
	-- Search functionality
	local function searchContent(text)
		-- This will be implemented per tab/section
	end
	
	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		searchContent(SearchBox.Text)
	end)
	
	local window = {}
	
	function window.Tab(window, name, icon)
		local Tab = Instance.new("ScrollingFrame")
		local TabListLayout = Instance.new("UIListLayout")
		local TabPadding = Instance.new("UIPadding")
		
		local TabButton = Instance.new("TextButton")
		local TabButtonCorner = Instance.new("UICorner")
		local TabIcon = Instance.new("ImageLabel")
		local TabLabel = Instance.new("TextLabel")
		
		-- Create tab button
		TabButton.Name = "TabButton"
		TabButton.Parent = TabButtons
		TabButton.BackgroundColor3 = colors.Dropdown
		TabButton.Size = UDim2.new(1, 0, 0, 40)
		TabButton.AutoButtonColor = false
		TabButton.Font = Enum.Font.SourceSans
		TabButton.Text = ""
		TabButton.TextColor3 = colors.Text
		TabButton.TextSize = 14
		
		TabButtonCorner.CornerRadius = UDim.new(0, 6)
		TabButtonCorner.Name = "TabButtonCorner"
		TabButtonCorner.Parent = TabButton
		
		TabIcon.Name = "TabIcon"
		TabIcon.Parent = TabButton
		TabIcon.BackgroundTransparency = 1
		TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
		TabIcon.Size = UDim2.new(0, 20, 0, 20)
		TabIcon.Image = ("rbxassetid://%s"):format(icon or 3926307971)
		TabIcon.ImageColor3 = colors.Text
		
		TabLabel.Name = "TabLabel"
		TabLabel.Parent = TabButton
		TabLabel.BackgroundTransparency = 1
		TabLabel.Position = UDim2.new(0, 40, 0, 0)
		TabLabel.Size = UDim2.new(1, -40, 1, 0)
		TabLabel.Font = Enum.Font.GothamSemibold
		TabLabel.Text = name
		TabLabel.TextColor3 = colors.Text
		TabLabel.TextSize = 14
		TabLabel.TextXAlignment = Enum.TextXAlignment.Left
		
		-- Create tab content
		Tab.Name = "Tab"
		Tab.Parent = TabMain
		Tab.Active = true
		Tab.BackgroundTransparency = 1
		Tab.Size = UDim2.new(1, 0, 1, 0)
		Tab.ScrollBarThickness = 3
		Tab.ScrollBarImageColor3 = colors.Accent
		Tab.Visible = false
		
		TabListLayout.Name = "TabListLayout"
		TabListLayout.Parent = Tab
		TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		TabListLayout.Padding = UDim.new(0, 10)
		
		TabPadding.Name = "TabPadding"
		TabPadding.Parent = Tab
		TabPadding.PaddingLeft = UDim.new(0, 5)
		TabPadding.PaddingTop = UDim.new(0, 5)
		
		TabButton.MouseButton1Click:Connect(function()
			Ripple(TabButton)
			switchTab({TabButton, Tab})
		end)
		
		if library.currentTab == nil then
			switchTab({TabButton, Tab})
		end
		
		TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Tab.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
		end)
		
		local tab = {}
		
		function tab.section(tab, name, TabVal)
			local Section = Instance.new("Frame")
			local SectionCorner = Instance.new("UICorner")
			local SectionTitle = Instance.new("TextLabel")
			local SectionToggle = Instance.new("ImageButton")
			local SectionContent = Instance.new("Frame")
			local ContentLayout = Instance.new("UIListLayout")
			
			Section.Name = "Section"
			Section.Parent = Tab
			Section.BackgroundColor3 = colors.Section
			Section.Size = UDim2.new(1, 0, 0, 40)
			Section.ClipsDescendants = true
			
			SectionCorner.CornerRadius = UDim.new(0, 6)
			SectionCorner.Name = "SectionCorner"
			SectionCorner.Parent = Section
			
			SectionTitle.Name = "SectionTitle"
			SectionTitle.Parent = Section
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.Position = UDim2.new(0, 15, 0, 0)
			SectionTitle.Size = UDim2.new(1, -40, 0, 40)
			SectionTitle.Font = Enum.Font.GothamSemibold
			SectionTitle.Text = name
			SectionTitle.TextColor3 = colors.Text
			SectionTitle.TextSize = 14
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			
			SectionToggle.Name = "SectionToggle"
			SectionToggle.Parent = Section
			SectionToggle.AnchorPoint = Vector2.new(1, 0.5)
			SectionToggle.BackgroundTransparency = 1
			SectionToggle.Position = UDim2.new(1, -10, 0.5, 0)
			SectionToggle.Size = UDim2.new(0, 20, 0, 20)
			SectionToggle.Image = "rbxassetid://3926305904"
			SectionToggle.ImageColor3 = colors.Text
			SectionToggle.ImageRectOffset = Vector2.new(884, 324)
			SectionToggle.ImageRectSize = Vector2.new(36, 36)
			
			SectionContent.Name = "SectionContent"
			SectionContent.Parent = Section
			SectionContent.BackgroundTransparency = 1
			SectionContent.Position = UDim2.new(0, 5, 0, 45)
			SectionContent.Size = UDim2.new(1, -10, 0, 0)
			
			ContentLayout.Name = "ContentLayout"
			ContentLayout.Parent = SectionContent
			ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ContentLayout.Padding = UDim.new(0, 5)
			
			local isOpen = TabVal ~= false
			
			local function toggleSection()
				isOpen = not isOpen
				if isOpen then
					Section.Size = UDim2.new(1, 0, 0, 45 + ContentLayout.AbsoluteContentSize.Y)
					SectionToggle.ImageRectOffset = Vector2.new(884, 324) -- Down arrow
				else
					Section.Size = UDim2.new(1, 0, 0, 40)
					SectionToggle.ImageRectOffset = Vector2.new(924, 324) -- Right arrow
				end
			end
			
			SectionToggle.MouseButton1Click:Connect(toggleSection)
			
			ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if isOpen then
					Section.Size = UDim2.new(1, 0, 0, 45 + ContentLayout.AbsoluteContentSize.Y)
				end
			end)
			
			if TabVal ~= false then
				toggleSection()
			end
			
			local section = {}
			
			function section.Button(section, text, callback)
				local callback = callback or function() end
				
				local Button = Instance.new("TextButton")
				local ButtonCorner = Instance.new("UICorner")
				
				Button.Name = "Button"
				Button.Parent = SectionContent
				Button.BackgroundColor3 = colors.Button
				Button.Size = UDim2.new(1, 0, 0, 35)
				Button.AutoButtonColor = false
				Button.Font = Enum.Font.GothamSemibold
				Button.Text = "   " .. text
				Button.TextColor3 = colors.Text
				Button.TextSize = 14
				Button.TextXAlignment = Enum.TextXAlignment.Left
				
				ButtonCorner.CornerRadius = UDim.new(0, 6)
				ButtonCorner.Name = "ButtonCorner"
				ButtonCorner.Parent = Button
				
				Button.MouseEnter:Connect(function()
					Tween(Button, {0.2, "Quad", "Out"}, {BackgroundColor3 = colors.ButtonHover})
				end)
				
				Button.MouseLeave:Connect(function()
					Tween(Button, {0.2, "Quad", "Out"}, {BackgroundColor3 = colors.Button})
				end)
				
				Button.MouseButton1Click:Connect(function()
					Ripple(Button)
					callback()
				end)
				
				return Button
			end
			
			-- Other element functions (Toggle, Slider, Dropdown, etc.) would follow similar patterns
			-- with modern styling and animations
			
			return section
		end
		
		return tab
	end
	
	return window
end

return library