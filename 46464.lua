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
		Ripple.ImageColor3 = Color3.fromRGB(255, 255, 255)
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
		if v.Name == "AL V3 -- Make 123fa98" then
			v:Destroy()
		end
	end

	local config = {
		MainColor = Color3.fromRGB(16, 16, 16),
		TabColor = Color3.fromRGB(22, 22, 22),
		Bg_Color = Color3.fromRGB(17, 17, 17),
		Zy_Color = Color3.fromRGB(17, 17, 17),

		Button_Color = Color3.fromRGB(22, 22, 22),
		Textbox_Color = Color3.fromRGB(22, 22, 22),
		Dropdown_Color = Color3.fromRGB(22, 22, 22),
		Keybind_Color = Color3.fromRGB(22, 22, 22),
		Label_Color = Color3.fromRGB(22, 22, 22),

		Slider_Color = Color3.fromRGB(22, 22, 22),
		SliderBar_Color = Color3.fromRGB(37, 254, 152),

		Toggle_Color = Color3.fromRGB(22, 22, 22),
		Toggle_Off = Color3.fromRGB(34, 34, 34),
		Toggle_On = Color3.fromRGB(37, 254, 152),
	}

	local dogent = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local TabMain = Instance.new("Frame")
	local MainC = Instance.new("UICorner")
	local SB = Instance.new("Frame")
	local SBC = Instance.new("UICorner")
	local Side = Instance.new("Frame")
	local SideG = Instance.new("UIGradient")
	local TabBtns = Instance.new("ScrollingFrame")
	local TabBtnsL = Instance.new("UIListLayout")
	local ScriptTitle = Instance.new("TextLabel")
	local SBG = Instance.new("UIGradient")
	local DropShadowHolder = Instance.new("Frame")
	local DropShadow = Instance.new("ImageLabel")
	local UICornerMain = Instance.new("UICorner")
	local UIGradient = Instance.new("UIGradient")
	local UIGradientTitle = Instance.new("UIGradient")

	if syn and syn.protect_gui then
		syn.protect_gui(dogent)
	end
	dogent.Name = "AL V3 -- Make 123fa98"
	dogent.Parent = services.CoreGui
	function UiDestroy()
		dogent:Destroy()
	end
	function ToggleUILib()
		if not ToggleUI then
			dogent.Enabled = false
			ToggleUI = true
		else
			ToggleUI = false
			dogent.Enabled = true
		end
	end

	Main.Name = "Main"
	Main.Parent = dogent
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = config.Bg_Color
	Main.BorderColor3 = config.MainColor
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = UDim2.new(0, 700, 0, 500) -- Increased size
	Main.ZIndex = 1
	Main.Active = true
	Main.Draggable = true
	services.UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.LeftControl then
			Main.Visible = not Main.Visible
		end
	end)

	local Open = Instance.new("ImageButton")
	local UICorner = Instance.new("UICorner")

	Open.Name = "Open"
	Open.Parent = dogent
	Open.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Open.BackgroundTransparency = 1
	Open.Position = UDim2.new(0.00829315186, 0, 0.13107837, 0)
	Open.Size = UDim2.new(0, 66, 0, 66)
	Open.Active = true
	Open.Draggable = true
	Open.Image = "rbxassetid://93774288685915"

	UICorner.Parent = Open

	function toggleui()
		toggled = not toggled
		spawn(function()
			if toggled then
				wait(0.3)
			end
		end)
		Tween(Main, { 0.3, "Sine", "InOut" }, { Size = UDim2.new(0, 700, 0, (toggled and 500 or 0)) }) -- Increased size
	end

	TabMain.Name = "TabMain"
	TabMain.Parent = Main
	TabMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabMain.BackgroundTransparency = 1.000
	TabMain.Position = UDim2.new(0.217000037, 0, 0, 3)
	TabMain.Size = UDim2.new(0, 500, 0, 450) -- Increased size
	MainC.CornerRadius = UDim.new(0, 10) -- Increased corner radius
	MainC.Name = "MainC"
	MainC.Parent = Main
	SB.Name = "SB"
	SB.Parent = Main
	SB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SB.BorderColor3 = config.MainColor
	SB.Size = UDim2.new(0, 10, 0, 500) -- Increased size
	SBC.CornerRadius = UDim.new(0, 10) -- Increased corner radius
	SBC.Name = "SBC"
	SBC.Parent = SB
	Side.Name = "Side"
	Side.Parent = SB
	Side.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Side.BorderColor3 = Color3.fromRGB(255, 255, 255)
	Side.BorderSizePixel = 0
	Side.ClipsDescendants = true
	Side.Position = UDim2.new(1, 0, 0, 0)
	Side.Size = UDim2.new(0, 150, 0, 500) -- Increased size
	SideG.Color =
		ColorSequence.new({ ColorSequenceKeypoint.new(0.00, config.Zy_Color), ColorSequenceKeypoint.new(1.00, config.Zy_Color) })
	SideG.Rotation = 90
	SideG.Name = "SideG"
	SideG.Parent = Side
	TabBtns.Name = "TabBtns"
	TabBtns.Parent = Side
	TabBtns.Active = true
	TabBtns.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabBtns.BackgroundTransparency = 1.000
	TabBtns.BorderSizePixel = 0
	TabBtns.Position = UDim2.new(0, 0, 0.0973535776, 0)
	TabBtns.Size = UDim2.new(0, 150, 0, 450) -- Increased size
	TabBtns.CanvasSize = UDim2.new(0, 0, 1, 0)
	TabBtns.ScrollBarThickness = 0
	TabBtnsL.Name = "TabBtnsL"
	TabBtnsL.Parent = TabBtns
	TabBtnsL.SortOrder = Enum.SortOrder.LayoutOrder
	TabBtnsL.Padding = UDim.new(0, 12)
	ScriptTitle.Name = "ScriptTitle"
	ScriptTitle.Parent = Side
	ScriptTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScriptTitle.BackgroundTransparency = 1.000
	ScriptTitle.Position = UDim2.new(0, 0, 0.00953488424, 0)
	ScriptTitle.Size = UDim2.new(0, 132, 0, 30) -- Increased size
	ScriptTitle.Font = Enum.Font.GothamSemibold
	ScriptTitle.Text = name
	ScriptTitle.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
	ScriptTitle.TextSize = 18.000 -- Increased text size
	ScriptTitle.TextScaled = true
	ScriptTitle.TextXAlignment = Enum.TextXAlignment.Left

	SBG.Color =
		ColorSequence.new({ ColorSequenceKeypoint.new(0.00, config.Zy_Color), ColorSequenceKeypoint.new(1.00, config.Zy_Color) })
	SBG.Rotation = 90
	SBG.Name = "SBG"
	SBG.Parent = SB
	TabBtnsL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabBtns.CanvasSize = UDim2.new(0, 0, 0, TabBtnsL.AbsoluteContentSize.Y + 18)
	end)

	local window = {}
	function window.Tab(window, name, icon)
		local Tab = Instance.new("ScrollingFrame")
		local TabIco = Instance.new("ImageLabel")
		local TabText = Instance.new("TextLabel")
		local TabBtn = Instance.new("TextButton")
		local TabL = Instance.new("UIListLayout")
		Tab.Name = "Tab"
		Tab.Parent = TabMain
		Tab.Active = true
		Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Tab.BackgroundTransparency = 1.000
		Tab.Size = UDim2.new(1, 0, 1, 0)
		Tab.ScrollBarThickness = 2
		Tab.Visible = false
		TabIco.Name = "TabIco"
		TabIco.Parent = TabBtns
		TabIco.BackgroundTransparency = 1.000
		TabIco.BorderSizePixel = 0
		TabIco.Size = UDim2.new(0, 30, 0, 30) -- Increased size
		TabIco.Image = ("rbxassetid://%s"):format((icon or 4370341699))
		TabIco.ImageTransparency = 0.2
		TabText.Name = "TabText"
		TabText.Parent = TabIco
		TabText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabText.BackgroundTransparency = 1.000
		TabText.Position = UDim2.new(1.41666663, 0, 0, 0)
		TabText.Size = UDim2.new(0, 100, 0, 30) -- Increased size
		TabText.Font = Enum.Font.GothamSemibold
		TabText.Text = name
		TabText.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
		TabText.TextSize = 18.000 -- Increased text size
		TabText.TextXAlignment = Enum.TextXAlignment.Left
		TabText.TextTransparency = 0.2
		TabBtn.Name = "TabBtn"
		TabBtn.Parent = TabIco
		TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabBtn.BackgroundTransparency = 1.000
		TabBtn.BorderSizePixel = 0
		TabBtn.Size = UDim2.new(0, 150, 0, 30) -- Increased size
		TabBtn.AutoButtonColor = false
		TabBtn.Font = Enum.Font.SourceSans
		TabBtn.Text = ""
		TabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
		TabBtn.TextSize = 14.000
		TabL.Name = "TabL"
		TabL.Parent = Tab
		TabL.SortOrder = Enum.SortOrder.LayoutOrder
		TabL.Padding = UDim.new(0, 4)
		TabBtn.MouseButton1Click:Connect(function()
			spawn(function()
				Ripple(TabBtn)
			end)
			switchTab({ TabIco, Tab })
		end)
		if library.currentTab == nil then
			switchTab({ TabIco, Tab })
		end
		TabL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Tab.CanvasSize = UDim2.new(0, 0, 0, TabL.AbsoluteContentSize.Y + 8)
		end)
		local tab = {}
		function tab.section(tab, name, TabVal)
			local Section = Instance.new("Frame")
			local SectionC = Instance.new("UICorner")
			local SectionText = Instance.new("TextLabel")
			local SectionOpen = Instance.new("ImageLabel")
			local SectionOpened = Instance.new("ImageLabel")
			local SectionToggle = Instance.new("ImageButton")
			local Objs = Instance.new("Frame")
			local ObjsL = Instance.new("UIListLayout")
			Section.Name = "Section"
			Section.Parent = Tab
			Section.BackgroundColor3 = config.TabColor
			Section.BackgroundTransparency = 1.000
			Section.BorderSizePixel = 0
			Section.ClipsDescendants = true
			Section.Size = UDim2.new(0.981000006, 0, 0, 50) -- Increased size
			SectionC.CornerRadius = UDim.new(0, 10) -- Increased corner radius
			SectionC.Name = "SectionC"
			SectionC.Parent = Section
			SectionText.Name = "SectionText"
			SectionText.Parent = Section
			SectionText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionText.BackgroundTransparency = 1.000
			SectionText.Position = UDim2.new(0.0887396261, 0, 0, 0)
			SectionText.Size = UDim2.new(0, 450, 0, 50) -- Increased size
			SectionText.Font = Enum.Font.GothamSemibold
			SectionText.Text = name
			SectionText.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
			SectionText.TextSize = 20.000 -- Increased text size
			SectionText.TextXAlignment = Enum.TextXAlignment.Left
			SectionOpen.Name = "SectionOpen"
			SectionOpen.Parent = SectionText
			SectionOpen.BackgroundTransparency = 1
			SectionOpen.BorderSizePixel = 0
			SectionOpen.Position = UDim2.new(0, -40, 0, 5)
			SectionOpen.Size = UDim2.new(0, 30, 0, 30) -- Increased size
			SectionOpen.Image = "rbxassetid://6031302934"
			SectionOpened.Name = "SectionOpened"
			SectionOpened.Parent = SectionOpen
			SectionOpened.BackgroundTransparency = 1.000
			SectionOpened.BorderSizePixel = 0
			SectionOpened.Size = UDim2.new(0, 30, 0, 30) -- Increased size
			SectionOpened.Image = "rbxassetid://6031302932"
			SectionOpened.ImageTransparency = 1.000
			SectionToggle.Name = "SectionToggle"
			SectionToggle.Parent = SectionOpen
			SectionToggle.BackgroundTransparency = 1
			SectionToggle.BorderSizePixel = 0
			SectionToggle.Size = UDim2.new(0, 30, 0, 30) -- Increased size
			Objs.Name = "Objs"
			Objs.Parent = Section
			Objs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Objs.BackgroundTransparency = 1
			Objs.BorderSizePixel = 0
			Objs.Position = UDim2.new(0, 10, 0, 50) -- Increased size
			Objs.Size = UDim2.new(0.986347735, 0, 0, 0)
			ObjsL.Name = "ObjsL"
			ObjsL.Parent = Objs
			ObjsL.SortOrder = Enum.SortOrder.LayoutOrder
			ObjsL.Padding = UDim.new(0, 10) -- Increased padding
			local open = TabVal
			if TabVal ~= false then
				Section.Size = UDim2.new(0.981000006, 0, 0, open and 50 + ObjsL.AbsoluteContentSize.Y + 10 or 50) -- Increased size
				SectionOpened.ImageTransparency = (open and 0 or 1)
				SectionOpen.ImageTransparency = (open and 1 or 0)
			end
			SectionToggle.MouseButton1Click:Connect(function()
				open = not open
				Section.Size = UDim2.new(0.981000006, 0, 0, open and 50 + ObjsL.AbsoluteContentSize.Y + 10 or 50) -- Increased size
				SectionOpened.ImageTransparency = (open and 0 or 1)
				SectionOpen.ImageTransparency = (open and 1 or 0)
			end)
			ObjsL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if not open then
					return
				end
				Section.Size = UDim2.new(0.981000006, 0, 0, 50 + ObjsL.AbsoluteContentSize.Y + 10) -- Increased size
			end)
			local section = {}
			function section.Button(section, text, callback)
				local callback = callback or function() end
				local BtnModule = Instance.new("Frame")
				local Btn = Instance.new("TextButton")
				local BtnC = Instance.new("UICorner")
				BtnModule.Name = "BtnModule"
				BtnModule.Parent = Objs
				BtnModule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				BtnModule.BackgroundTransparency = 1.000
				BtnModule.BorderSizePixel = 0
				BtnModule.Position = UDim2.new(0, 0, 0, 0)
				BtnModule.Size = UDim2.new(0, 450, 0, 50) -- Increased size
				Btn.Name = "Btn"
				Btn.Parent = BtnModule
				Btn.BackgroundColor3 = config.Button_Color
				Btn.BorderSizePixel = 0
				Btn.Size = UDim2.new(0, 450, 0, 50) -- Increased size
				Btn.AutoButtonColor = false
				Btn.Font = Enum.Font.GothamSemibold
				Btn.Text = "   " .. text
				Btn.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				Btn.TextSize = 20.000 -- Increased text size
				Btn.TextXAlignment = Enum.TextXAlignment.Left
				BtnC.CornerRadius = UDim.new(0, 10) -- Increased corner radius
				BtnC.Name = "BtnC"
				BtnC.Parent = Btn
				Btn.MouseButton1Click:Connect(function()
					spawn(function()
						Ripple(Btn)
					end)
					spawn(callback)
				end)
			end
			function section:Label(text)
				local LabelModule = Instance.new("Frame")
				local TextLabel = Instance.new("TextLabel")
				local LabelC = Instance.new("UICorner")
				LabelModule.Name = "LabelModule"
				LabelModule.Parent = Objs
				LabelModule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				LabelModule.BackgroundTransparency = 1.000
				LabelModule.BorderSizePixel = 0
				LabelModule.Position = UDim2.new(0, 0, NAN, 0)
				LabelModule.Size = UDim2.new(0, 450, 0, 30) -- Increased size
				TextLabel.Parent = LabelModule
				TextLabel.BackgroundColor3 = config.Label_Color
				TextLabel.Size = UDim2.new(0, 450, 0, 30) -- Increased size
				TextLabel.Font = Enum.Font.GothamSemibold
				TextLabel.Text = text
				TextLabel.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				TextLabel.TextSize = 18.000 -- Increased text size
				LabelC.CornerRadius = UDim.new(0, 10) -- Increased corner radius
				LabelC.Name = "LabelC"
				LabelC.Parent = TextLabel
				return TextLabel
			end
			function section.Toggle(section, text, flag, enabled, callback)
				local callback = callback or function() end
				local enabled = enabled or false
				assert(text, "No text provided")
				assert(flag, "No flag provided")
				library.flags[flag] = enabled
				local ToggleModule = Instance.new("Frame")
				local ToggleBtn = Instance.new("TextButton")
				local ToggleBtnC = Instance.new("UICorner")
				local ToggleDisable = Instance.new("Frame")
				local ToggleSwitch = Instance.new("Frame")
				local ToggleSwitchC = Instance.new("UICorner")
				local ToggleDisableC = Instance.new("UICorner")
				ToggleModule.Name = "ToggleModule"
				ToggleModule.Parent = Objs
				ToggleModule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleModule.BackgroundTransparency = 1.000
				ToggleModule.BorderSizePixel = 0
				ToggleModule.Position = UDim2.new(0, 0, 0, 0)
				ToggleModule.Size = UDim2.new(0, 450, 0, 50) -- Increased size
				ToggleBtn.Name = "ToggleBtn"
				ToggleBtn.Parent = ToggleModule
				ToggleBtn.BackgroundColor3 = config.Toggle_Color
				ToggleBtn.BorderSizePixel = 0
				ToggleBtn.Size = UDim2.new(0, 450, 0, 50) -- Increased size
				ToggleBtn.AutoButtonColor = false
				ToggleBtn.Font = Enum.Font.GothamSemibold
				ToggleBtn.Text = "   " .. text
				ToggleBtn.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				ToggleBtn.TextSize = 20.000 -- Increased text size
				ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
				ToggleBtnC.CornerRadius = UDim.new(0, 10) -- Increased corner radius
				ToggleBtnC.Name = "ToggleBtnC"
				ToggleBtnC.Parent = ToggleBtn
				ToggleDisable.Name = "ToggleDisable"
				ToggleDisable.Parent = ToggleBtn
				ToggleDisable.BackgroundColor3 = config.Bg_Color
				ToggleDisable.BorderSizePixel = 0
				ToggleDisable.Position = UDim2.new(0.85, 0, 0.15, 0)
				ToggleDisable.Size = UDim2.new(0, 60, 0, 40) -- Increased size
				ToggleSwitch.Name = "ToggleSwitch"
				ToggleSwitch.Parent = ToggleDisable
				ToggleSwitch.BackgroundColor3 = config.Toggle_Off
				ToggleSwitch.Size = UDim2.new(0, 40, 0, 40) -- Increased size
				ToggleSwitchC.CornerRadius = UDim.new(0, 20) -- Increased corner radius
				ToggleSwitchC.Name = "ToggleSwitchC"
				ToggleSwitchC.Parent = ToggleSwitch
				ToggleDisableC.CornerRadius = UDim.new(0, 20) -- Increased corner radius
				ToggleDisableC.Name = "ToggleDisableC"
				ToggleDisableC.Parent = ToggleDisable
				local funcs = {
					SetState = function(self, state)
						if state == nil then
							state = not library.flags[flag]
						end
						if library.flags[flag] == state then
							return
						end
						services.TweenService
							:Create(ToggleSwitch, TweenInfo.new(0.2), {
								Position = UDim2.new(0, (state and ToggleSwitch.Size.X.Offset / 2 or 0), 0, 0),
								BackgroundColor3 = (state and config.Toggle_On or config.Toggle_Off),
							})
							:Play()
						library.flags[flag] = state
						callback(state)
					end,
					Module = ToggleModule,
				}
				if enabled ~= false then
					funcs:SetState(flag, true)
				end
				ToggleBtn.MouseButton1Click:Connect(function()
					funcs:SetState()
				end)
				return funcs
			end
			function section.Keybind(section, text, default, callback)
				local callback = callback or function() end
				assert(text, "No text provided")
				assert(default, "No default key provided")
				local default = (typeof(default) == "string" and Enum.KeyCode[default] or default)
				local banned = {
					Return = true,
					Space = true,
					Tab = true,
					Backquote = true,
					CapsLock = true,
					Escape = true,
					Unknown = true,
				}
				local shortNames = {
					RightControl = "Right Ctrl",
					LeftControl = "Left Ctrl",
					LeftShift = "Left Shift",
					RightShift = "Right Shift",
					Semicolon = ";",
					Quote = '"',
					LeftBracket = "[",
					RightBracket = "]",
					Equals = "=",
					Minus = "-",
					RightAlt = "Right Alt",
					LeftAlt = "Left Alt",
				}
				local bindKey = default
				local keyTxt = (default and (shortNames[default.Name] or default.Name) or "None")
				local KeybindModule = Instance.new("Frame")
				local KeybindBtn = Instance.new("TextButton")
				local KeybindBtnC = Instance.new("UICorner")
				local KeybindValue = Instance.new("TextButton")
				local KeybindValueC = Instance.new("UICorner")
				local KeybindL = Instance.new("UIListLayout")
				local UIPadding = Instance.new("UIPadding")
				KeybindModule.Name = "KeybindModule"
				KeybindModule.Parent = Objs
				KeybindModule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				KeybindModule.BackgroundTransparency = 1.000
				KeybindModule.BorderSizePixel = 0
				KeybindModule.Position = UDim2.new(0, 0, 0, 0)
				KeybindModule.Size = UDim2.new(0, 450, 0, 50) -- Increased size
				KeybindBtn.Name = "KeybindBtn"
				KeybindBtn.Parent = KeybindModule
				KeybindBtn.BackgroundColor3 = config.Keybind_Color
				KeybindBtn.BorderSizePixel = 0
				KeybindBtn.Size = UDim2.new(0, 450, 0, 50) -- Increased size
				KeybindBtn.AutoButtonColor = false
				KeybindBtn.Font = Enum.Font.GothamSemibold
				KeybindBtn.Text = "   " .. text
				KeybindBtn.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				KeybindBtn.TextSize = 20.000 -- Increased text size
				KeybindBtn.TextXAlignment = Enum.TextXAlignment.Left
				KeybindBtnC.CornerRadius = UDim.new(0, 10) -- Increased corner radius
				KeybindBtnC.Name = "KeybindBtnC"
				KeybindBtnC.Parent = KeybindBtn
				KeybindValue.Name = "KeybindValue"
				KeybindValue.Parent = KeybindBtn
				KeybindValue.BackgroundColor3 = config.Bg_Color
				KeybindValue.BorderSizePixel = 0
				KeybindValue.Position = UDim2.new(0.7, 0, 0.15, 0)
				KeybindValue.Size = UDim2.new(0, 120, 0, 40) -- Increased size
				KeybindValue.AutoButtonColor = false
				KeybindValue.Font = Enum.Font.Gotham
				KeybindValue.Text = keyTxt
				KeybindValue.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				KeybindValue.TextSize = 18.000 -- Increased text size
				KeybindValueC.CornerRadius = UDim.new(0, 10) -- Increased corner radius
				KeybindValueC.Name = "KeybindValueC"
				KeybindValueC.Parent = KeybindValue
				KeybindL.Name = "KeybindL"
				KeybindL.Parent = KeybindBtn
				KeybindL.HorizontalAlignment = Enum.HorizontalAlignment.Right
				KeybindL.SortOrder = Enum.SortOrder.LayoutOrder
				KeybindL.VerticalAlignment = Enum.VerticalAlignment.Center
				UIPadding.Parent = KeybindBtn
				UIPadding.PaddingRight = UDim.new(0, 10)
				services.UserInputService.InputBegan:Connect(function(inp, gpe)
					if gpe then
						return
					end
					if inp.UserInputType ~= Enum.UserInputType.Keyboard then
						return
					end
					if inp.KeyCode ~= bindKey then
						return
					end
					callback(bindKey.Name)
				end)
				KeybindValue.MouseButton1Click:Connect(function()
					KeybindValue.Text = "..."
					wait()
					local key, uwu = services.UserInputService.InputEnded:Wait()
					local keyName = tostring(key.KeyCode.Name)
					if key.UserInputType ~= Enum.UserInputType.Keyboard then
						KeybindValue.Text = keyTxt
						return
					end
					if banned[keyName] then
						KeybindValue.Text = keyTxt
						return
					end
					wait()
					bindKey = Enum.KeyCode[keyName]
					KeybindValue.Text = shortNames[keyName] or keyName
				end)
				KeybindValue:GetPropertyChangedSignal("TextBounds"):Connect(function()
					KeybindValue.Size = UDim2.new(0, KeybindValue.TextBounds.X + 30, 0, 40) -- Increased size
				end)
				KeybindValue.Size = UDim2.new(0, KeybindValue.TextBounds.X + 30, 0, 40) -- Increased size
			end
			function section.Textbox(section, text, flag, default, callback)
				local callback = callback or function() end
				assert(text, "No text provided")
				assert(flag, "No flag provided")
				assert(default, "No default text provided")
				library.flags[flag] = default
				local TextboxModule = Instance.new("Frame")
				local TextboxBack = Instance.new("TextButton")
				local TextboxBackC = Instance.new("UICorner")
				local BoxBG = Instance.new("TextButton")
				local BoxBGC = Instance.new("UICorner")
				local TextBox = Instance.new("TextBox")
				local TextboxBackL = Instance.new("UIListLayout")
				local TextboxBackP = Instance.new("UIPadding")
				TextboxModule.Name = "TextboxModule"
				TextboxModule.Parent = Objs
				TextboxModule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextboxModule.BackgroundTransparency = 1.000
				TextboxModule.BorderSizePixel = 0
				TextboxModule.Position = UDim2.new(0, 0, 0, 0)
				TextboxModule.Size = UDim2.new(0, 450, 0, 50) -- Increased size
				TextboxBack.Name = "TextboxBack"
				TextboxBack.Parent = TextboxModule
				TextboxBack.BackgroundColor3 = config.Textbox_Color
				TextboxBack.BorderSizePixel = 0
				TextboxBack.Size = UDim2.new(0, 450, 0, 50) -- Increased size
				TextboxBack.AutoButtonColor = false
				TextboxBack.Font = Enum.Font.GothamSemibold
				TextboxBack.Text = "   " .. text
				TextboxBack.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				TextboxBack.TextSize = 20.000 -- Increased text size
				TextboxBack.TextXAlignment = Enum.TextXAlignment.Left
				TextboxBackC.CornerRadius = UDim.new(0, 10) -- Increased corner radius
				TextboxBackC.Name = "TextboxBackC"
				TextboxBackC.Parent = TextboxBack
				BoxBG.Name = "BoxBG"
				BoxBG.Parent = TextboxBack
				BoxBG.BackgroundColor3 = config.Bg_Color
				BoxBG.BorderSizePixel = 0
				BoxBG.Position = UDim2.new(0.7, 0, 0.15, 0)
				BoxBG.Size = UDim2.new(0, 120, 0, 40) -- Increased size
				BoxBG.AutoButtonColor = false
				BoxBG.Font = Enum.Font.Gotham
				BoxBG.Text = ""
				BoxBG.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				BoxBG.TextSize = 18.000 -- Increased text size
				BoxBGC.CornerRadius = UDim.new(0, 10) -- Increased corner radius
				BoxBGC.Name = "BoxBGC"
				BoxBGC.Parent = BoxBG
				TextBox.Parent = BoxBG
				TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextBox.BackgroundTransparency = 1.000
				TextBox.BorderSizePixel = 0
				TextBox.Size = UDim2.new(1, 0, 1, 0)
				TextBox.Font = Enum.Font.Gotham
				TextBox.Text = default
				TextBox.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				TextBox.TextSize = 18.000 -- Increased text size
				TextboxBackL.Name = "TextboxBackL"
				TextboxBackL.Parent = TextboxBack
				TextboxBackL.HorizontalAlignment = Enum.HorizontalAlignment.Right
				TextboxBackL.SortOrder = Enum.SortOrder.LayoutOrder
				TextboxBackL.VerticalAlignment = Enum.VerticalAlignment.Center
				TextboxBackP.Name = "TextboxBackP"
				TextboxBackP.Parent = TextboxBack
				TextboxBackP.PaddingRight = UDim.new(0, 10)
				TextBox.FocusLost:Connect(function()
					if TextBox.Text == "" then
						TextBox.Text = default
					end
					library.flags[flag] = TextBox.Text
					callback(TextBox.Text)
				end)
				TextBox:GetPropertyChangedSignal("TextBounds"):Connect(function()
					BoxBG.Size = UDim2.new(0, TextBox.TextBounds.X + 30, 0, 40) -- Increased size
				end)
				BoxBG.Size = UDim2.new(0, TextBox.TextBounds.X + 30, 0, 40) -- Increased size
			end
			function section.Slider(section, text, flag, default, min, max, precise, callback)
				local callback = callback or function() end
				local min = min or 1
				local max = max or 10
				local default = default or min
				local precise = precise or false
				library.flags[flag] = default
				assert(text, "No text provided")
				assert(flag, "No flag provided")
				assert(default, "No default value provided")
				local SliderModule = Instance.new("Frame")
				local SliderBack = Instance.new("TextButton")
				local SliderBackC = Instance.new("UICorner")
				local SliderBar = Instance.new("Frame")
				local SliderBarC = Instance.new("UICorner")
				local SliderPart = Instance.new("Frame")
				local SliderPartC = Instance.new("UICorner")
				local SliderValBG = Instance.new("TextButton")
				local SliderValBGC = Instance.new("UICorner")
				local SliderValue = Instance.new("TextBox")
				local MinSlider = Instance.new("TextButton")
				local AddSlider = Instance.new("TextButton")
				SliderModule.Name = "SliderModule"
				SliderModule.Parent = Objs
				SliderModule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderModule.BackgroundTransparency = 1.000
				SliderModule.BorderSizePixel = 0
				SliderModule.Position = UDim2.new(0, 0, 0, 0)
				SliderModule.Size = UDim2.new(0, 450, 0, 50) -- Increased size
				SliderBack.Name = "SliderBack"
				SliderBack.Parent = SliderModule
				SliderBack.BackgroundColor3 = config.Slider_Color
				SliderBack.BorderSizePixel = 0
				SliderBack.Size = UDim2.new(0, 450, 0, 50) -- Increased size
				SliderBack.AutoButtonColor = false
				SliderBack.Font = Enum.Font.GothamSemibold
				SliderBack.Text = "   " .. text
				SliderBack.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				SliderBack.TextSize = 20.000 -- Increased text size
				SliderBack.TextXAlignment = Enum.TextXAlignment.Left
				SliderBackC.CornerRadius = UDim.new(0, 10) -- Increased corner radius
				SliderBackC.Name = "SliderBackC"
				SliderBackC.Parent = SliderBack
				SliderBar.Name = "SliderBar"
				SliderBar.Parent = SliderBack
				SliderBar.AnchorPoint = Vector2.new(0, 0.5)
				SliderBar.BackgroundColor3 = config.Bg_Color
				SliderBar.BorderSizePixel = 0
				SliderBar.Position = UDim2.new(0.3, 0, 0.5, 0)
				SliderBar.Size = UDim2.new(0, 200, 0, 10) -- Increased size
				SliderBarC.CornerRadius = UDim.new(0, 5)
				SliderBarC.Name = "SliderBarC"
				SliderBarC.Parent = SliderBar
				SliderPart.Name = "SliderPart"
				SliderPart.Parent = SliderBar
				SliderPart.BackgroundColor3 = config.SliderBar_Color
				SliderPart.BorderSizePixel = 0
				SliderPart.Size = UDim2.new(0, 50, 0, 10) -- Increased size
				SliderPartC.CornerRadius = UDim.new(0, 5)
				SliderPartC.Name = "SliderPartC"
				SliderPartC.Parent = SliderPart
				SliderValBG.Name = "SliderValBG"
				SliderValBG.Parent = SliderBack
				SliderValBG.BackgroundColor3 = config.Bg_Color
				SliderValBG.BorderSizePixel = 0
				SliderValBG.Position = UDim2.new(0.85, 0, 0.15, 0)
				SliderValBG.Size = UDim2.new(0, 60, 0, 40) -- Increased size
				SliderValBG.AutoButtonColor = false
				SliderValBG.Font = Enum.Font.Gotham
				SliderValBG.Text = ""
				SliderValBG.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				SliderValBG.TextSize = 18.000 -- Increased text size
				SliderValBGC.CornerRadius = UDim.new(0, 10) -- Increased corner radius
				SliderValBGC.Name = "SliderValBGC"
				SliderValBGC.Parent = SliderValBG
				SliderValue.Name = "SliderValue"
				SliderValue.Parent = SliderValBG
				SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderValue.BackgroundTransparency = 1.000
				SliderValue.BorderSizePixel = 0
				SliderValue.Size = UDim2.new(1, 0, 1, 0)
				SliderValue.Font = Enum.Font.Gotham
				SliderValue.Text = tostring(default)
				SliderValue.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				SliderValue.TextSize = 18.000 -- Increased text size
				MinSlider.Name = "MinSlider"
				MinSlider.Parent = SliderModule
				MinSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				MinSlider.BackgroundTransparency = 1.000
				MinSlider.BorderSizePixel = 0
				MinSlider.Position = UDim2.new(0.2, 0, 0.2, 0)
				MinSlider.Size = UDim2.new(0, 30, 0, 30) -- Increased size
				MinSlider.Font = Enum.Font.Gotham
				MinSlider.Text = "-"
				MinSlider.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				MinSlider.TextSize = 24.000
				MinSlider.TextWrapped = true
				AddSlider.Name = "AddSlider"
				AddSlider.Parent = SliderModule
				AddSlider.AnchorPoint = Vector2.new(0, 0.5)
				AddSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				AddSlider.BackgroundTransparency = 1.000
				AddSlider.BorderSizePixel = 0
				AddSlider.Position = UDim2.new(0.8, 0, 0.5, 0)
				AddSlider.Size = UDim2.new(0, 30, 0, 30) -- Increased size
				AddSlider.Font = Enum.Font.Gotham
				AddSlider.Text = "+"
				AddSlider.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				AddSlider.TextSize = 24.000
				AddSlider.TextWrapped = true
				local funcs = {
					SetValue = function(self, value)
						local percent = (mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
						if value then
							percent = (value - min) / (max - min)
						end
						percent = math.clamp(percent, 0, 1)
						if precise then
							value = value or tonumber(string.format("%.1f", tostring(min + (max - min) * percent)))
						else
							value = value or math.floor(min + (max - min) * percent)
						end
						library.flags[flag] = tonumber(value)
						SliderValue.Text = tostring(value)
						SliderPart.Size = UDim2.new(percent, 0, 1, 0)
						callback(tonumber(value))
					end,
				}
				MinSlider.MouseButton1Click:Connect(function()
					local currentValue = library.flags[flag]
					currentValue = math.clamp(currentValue - 1, min, max)
					funcs:SetValue(currentValue)
				end)
				AddSlider.MouseButton1Click:Connect(function()
					local currentValue = library.flags[flag]
					currentValue = math.clamp(currentValue + 1, min, max)
					funcs:SetValue(currentValue)
				end)
				funcs:SetValue(default)
				local dragging, boxFocused, allowed = false, false, { [""] = true, ["-"] = true }
				SliderBar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						funcs:SetValue()
						dragging = true
					end
				end)
				services.UserInputService.InputEnded:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)
				services.UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						funcs:SetValue()
					end
				end)
				SliderBar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Touch then
						funcs:SetValue()
						dragging = true
					end
				end)
				services.UserInputService.InputEnded:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)
				services.UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.Touch then
						funcs:SetValue()
					end
				end)
				SliderValue.Focused:Connect(function()
					boxFocused = true
				end)
				SliderValue.FocusLost:Connect(function()
					boxFocused = false
					if SliderValue.Text == "" then
						funcs:SetValue(default)
					end
				end)
				SliderValue:GetPropertyChangedSignal("Text"):Connect(function()
					if not boxFocused then
						return
					end
					SliderValue.Text = SliderValue.Text:gsub("%D+", "")
					local text = SliderValue.Text
					if not tonumber(text) then
						SliderValue.Text = SliderValue.Text:gsub("%D+", "")
					elseif not allowed[text] then
						if tonumber(text) > max then
							text = max
							SliderValue.Text = tostring(max)
						end
						funcs:SetValue(tonumber(text))
					end
				end)
				return funcs
			end
			function section.Dropdown(section, text, flag, options, callback)
				local callback = callback or function() end
				local options = options or {}
				assert(text, "No text provided")
				assert(flag, "No flag provided")
				library.flags[flag] = nil
				local DropdownModule = Instance.new("Frame")
				local DropdownTop = Instance.new("TextButton")
				local DropdownTopC = Instance.new("UICorner")
				local DropdownOpen = Instance.new("TextButton")
				local DropdownText = Instance.new("TextBox")
				local DropdownModuleL = Instance.new("UIListLayout")
				local Option = Instance.new("TextButton")
				local OptionC = Instance.new("UICorner")
				DropdownModule.Name = "DropdownModule"
				DropdownModule.Parent = Objs
				DropdownModule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownModule.BackgroundTransparency = 1.000
				DropdownModule.BorderSizePixel = 0
				DropdownModule.ClipsDescendants = true
				DropdownModule.Position = UDim2.new(0, 0, 0, 0)
				DropdownModule.Size = UDim2.new(0, 450, 0, 50) -- Increased size
				DropdownTop.Name = "DropdownTop"
				DropdownTop.Parent = DropdownModule
				DropdownTop.BackgroundColor3 = config.Dropdown_Color
				DropdownTop.BorderSizePixel = 0
				DropdownTop.Size = UDim2.new(0, 450, 0, 50) -- Increased size
				DropdownTop.AutoButtonColor = false
				DropdownTop.Font = Enum.Font.GothamSemibold
				DropdownTop.Text = ""
				DropdownTop.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				DropdownTop.TextSize = 20.000 -- Increased text size
				DropdownTop.TextXAlignment = Enum.TextXAlignment.Left
				DropdownTopC.CornerRadius = UDim.new(0, 10) -- Increased corner radius
				DropdownTopC.Name = "DropdownTopC"
				DropdownTopC.Parent = DropdownTop
				DropdownOpen.Name = "DropdownOpen"
				DropdownOpen.Parent = DropdownTop
				DropdownOpen.AnchorPoint = Vector2.new(0, 0.5)
				DropdownOpen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownOpen.BackgroundTransparency = 1.000
				DropdownOpen.BorderSizePixel = 0
				DropdownOpen.Position = UDim2.new(0.9, 0, 0.5, 0)
				DropdownOpen.Size = UDim2.new(0, 30, 0, 30) -- Increased size
				DropdownOpen.Font = Enum.Font.Gotham
				DropdownOpen.Text = "+"
				DropdownOpen.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				DropdownOpen.TextSize = 24.000
				DropdownOpen.TextWrapped = true
				DropdownText.Name = "DropdownText"
				DropdownText.Parent = DropdownTop
				DropdownText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownText.BackgroundTransparency = 1.000
				DropdownText.BorderSizePixel = 0
				DropdownText.Position = UDim2.new(0.05, 0, 0, 0)
				DropdownText.Size = UDim2.new(0, 350, 0, 50) -- Increased size
				DropdownText.Font = Enum.Font.GothamSemibold
				DropdownText.PlaceholderColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				DropdownText.PlaceholderText = text
				DropdownText.Text = ""
				DropdownText.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
				DropdownText.TextSize = 20.000 -- Increased text size
				DropdownText.TextXAlignment = Enum.TextXAlignment.Left
				DropdownModuleL.Name = "DropdownModuleL"
				DropdownModuleL.Parent = DropdownModule
				DropdownModuleL.SortOrder = Enum.SortOrder.LayoutOrder
				DropdownModuleL.Padding = UDim.new(0, 10) -- Increased padding
				local setAllVisible = function()
					local options = DropdownModule:GetChildren()
					for i = 1, #options do
						local option = options[i]
						if option:IsA("TextButton") and option.Name:match("Option_") then
							option.Visible = true
						end
					end
				end
				local searchDropdown = function(text)
					local options = DropdownModule:GetChildren()
					for i = 1, #options do
						local option = options[i]
						if text == "" then
							setAllVisible()
						else
							if option:IsA("TextButton") and option.Name:match("Option_") then
								if option.Text:lower():match(text:lower()) then
									option.Visible = true
								else
									option.Visible = false
								end
							end
						end
					end
				end
				local open = false
				local ToggleDropVis = function()
					open = not open
					if open then
						setAllVisible()
					end
					DropdownOpen.Text = (open and "-" or "+")
					DropdownModule.Size =
						UDim2.new(0, 450, 0, (open and DropdownModuleL.AbsoluteContentSize.Y + 10 or 50)) -- Increased size
				end
				DropdownOpen.MouseButton1Click:Connect(ToggleDropVis)
				DropdownText.Focused:Connect(function()
					if open then
						return
					end
					ToggleDropVis()
				end)
				DropdownText:GetPropertyChangedSignal("Text"):Connect(function()
					if not open then
						return
					end
					searchDropdown(DropdownText.Text)
				end)
				DropdownModuleL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					if not open then
						return
					end
					DropdownModule.Size = UDim2.new(0, 450, 0, (DropdownModuleL.AbsoluteContentSize.Y + 10)) -- Increased size
				end)
				local funcs = {}
				funcs.AddOption = function(self, option)
					local Option = Instance.new("TextButton")
					local OptionC = Instance.new("UICorner")
					Option.Name = "Option_" .. option
					Option.Parent = DropdownModule
					Option.BackgroundColor3 = config.TabColor
					Option.BorderSizePixel = 0
					Option.Position = UDim2.new(0, 0, 0.328125, 0)
					Option.Size = UDim2.new(0, 450, 0, 40) -- Increased size
					Option.AutoButtonColor = false
					Option.Font = Enum.Font.Gotham
					Option.Text = option
					Option.TextColor3 = Color3.fromRGB(255, 182, 213) -- Pink color
					Option.TextSize = 18.000 -- Increased text size
					OptionC.CornerRadius = UDim.new(0, 10) -- Increased corner radius
					OptionC.Name = "OptionC"
					OptionC.Parent = Option
					Option.MouseButton1Click:Connect(function()
						ToggleDropVis()
						callback(Option.Text)
						DropdownText.Text = Option.Text
						library.flags[flag] = Option.Text
					end)
				end
				funcs.RemoveOption = function(self, option)
					local option = DropdownModule:FindFirstChild("Option_" .. option)
					if option then
						option:Destroy()
					end
				end
				funcs.SetOptions = function(self, options)
					for _, v in next, DropdownModule:GetChildren() do
						if v.Name:match("Option_") then
							v:Destroy()
						end
					end
					for _, v in next, options do
						funcs:AddOption(v)
					end
				end
				funcs:SetOptions(options)
				return funcs
			end
			return section
		end
		return tab
	end
	return window
end
return library
