local library = {}
local ToggleUI = false
library.currentTab = nil
library.flags = {}

-- Services
local services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end
})
local UserInputService = services.UserInputService
local TweenService = services.TweenService
local RunService = services.RunService
local Players = services.Players
local mouse = Players.LocalPlayer:GetMouse()

-- Utility functions
local function Tween(obj, t, data)
    TweenService:Create(obj, TweenInfo.new(t[1], Enum.EasingStyle[t[2]], Enum.EasingDirection[t[3]]), data):Play()
    return true
end

local function Ripple(obj)
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
        
        Tween(Ripple, {0.3, "Linear", "InOut"}, {Position = UDim2.new(-5.5, 0, -5.5, 0), Size = UDim2.new(12, 0, 12, 0)})
        wait(0.15)
        Tween(Ripple, {0.3, "Linear", "InOut"}, {ImageTransparency = 1})
        wait(0.3)
        Ripple:Destroy()
    end)
end

-- Color configuration
local config = {
    MainColor = Color3.fromRGB(20, 20, 30),
    TabColor = Color3.fromRGB(30, 30, 45),
    BgColor = Color3.fromRGB(25, 25, 40),
    AccentColor = Color3.fromRGB(0, 180, 255),
    
    ButtonColor = Color3.fromRGB(40, 40, 60),
    TextboxColor = Color3.fromRGB(40, 40, 60),
    DropdownColor = Color3.fromRGB(40, 40, 60),
    KeybindColor = Color3.fromRGB(40, 40, 60),
    LabelColor = Color3.fromRGB(40, 40, 60),
    
    SliderColor = Color3.fromRGB(40, 40, 60),
    SliderBarColor = Color3.fromRGB(0, 180, 255),
    
    ToggleColor = Color3.fromRGB(40, 40, 60),
    ToggleOff = Color3.fromRGB(80, 80, 80),
    ToggleOn = Color3.fromRGB(0, 180, 255),
    
    TextColor = Color3.fromRGB(255, 255, 255),
    PlaceholderColor = Color3.fromRGB(180, 180, 180)
}

-- Main UI creation
function library.new(name)
    -- Create main UI container
    local ui = Instance.new("ScreenGui")
    if syn and syn.protect_gui then
        syn.protect_gui(ui)
    end
    ui.Name = "ModernTechUI"
    ui.Parent = game:GetService("CoreGui")
    
    -- Main frame with sliding animation
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = ui
    mainFrame.BackgroundColor3 = config.MainColor
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(1, 0, 0.5, -200)
    mainFrame.Size = UDim2.new(0, 450, 0, 500)
    mainFrame.AnchorPoint = Vector2.new(1, 0.5)
    mainFrame.ClipsDescendants = true
    
    -- Modern corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Glowing border effect
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Parent = mainFrame
    border.BackgroundColor3 = config.AccentColor
    border.BackgroundTransparency = 0.7
    border.BorderSizePixel = 0
    border.Size = UDim2.new(1, 0, 1, 0)
    border.ZIndex = 0
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 12)
    borderCorner.Parent = border
    
    -- Animate border glow
    spawn(function()
        while border.Parent do
            for i = 0, 1, 0.01 do
                border.BackgroundTransparency = 0.7 + math.sin(i * math.pi) * 0.2
                wait()
            end
        end
    end)
    
    -- Header with title and toggle button
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Parent = mainFrame
    header.BackgroundColor3 = config.TabColor
    header.BackgroundTransparency = 0.1
    header.BorderSizePixel = 0
    header.Size = UDim2.new(1, 0, 0, 40)
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = header
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.Text = name
    title.TextColor3 = config.TextColor
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Toggle button (>) to hide/show UI
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleButton"
    toggleBtn.Parent = header
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Position = UDim2.new(1, -40, 0, 0)
    toggleBtn.Size = UDim2.new(0, 40, 1, 0)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Text = ">"
    toggleBtn.TextColor3 = config.TextColor
    toggleBtn.TextSize = 20
    
    -- Search box
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Parent = header
    searchBox.BackgroundColor3 = config.BgColor
    searchBox.BackgroundTransparency = 0.2
    searchBox.Position = UDim2.new(0, 220, 0.5, -15)
    searchBox.Size = UDim2.new(0, 180, 0, 30)
    searchBox.Font = Enum.Font.Gotham
    searchBox.PlaceholderText = "Search..."
    searchBox.PlaceholderColor3 = config.PlaceholderColor
    searchBox.Text = ""
    searchBox.TextColor3 = config.TextColor
    searchBox.TextSize = 14
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    
    local searchPadding = Instance.new("UIPadding")
    searchPadding.Parent = searchBox
    searchPadding.PaddingLeft = UDim.new(0, 10)
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchBox
    
    -- Tab container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = mainFrame
    tabContainer.BackgroundTransparency = 1
    tabContainer.Position = UDim2.new(0, 0, 0, 45)
    tabContainer.Size = UDim2.new(1, 0, 1, -45)
    
    -- Tab buttons
    local tabButtons = Instance.new("Frame")
    tabButtons.Name = "TabButtons"
    tabButtons.Parent = tabContainer
    tabButtons.BackgroundColor3 = config.TabColor
    tabButtons.BackgroundTransparency = 0.1
    tabButtons.BorderSizePixel = 0
    tabButtons.Size = UDim2.new(0, 120, 1, 0)
    
    local tabButtonsCorner = Instance.new("UICorner")
    tabButtonsCorner.CornerRadius = UDim.new(0, 12)
    tabButtonsCorner.Parent = tabButtons
    
    local tabList = Instance.new("UIListLayout")
    tabList.Parent = tabButtons
    tabList.Padding = UDim.new(0, 5)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Tab content area
    local tabContent = Instance.new("Frame")
    tabContent.Name = "TabContent"
    tabContent.Parent = tabContainer
    tabContent.BackgroundTransparency = 1
    tabContent.Position = UDim2.new(0, 125, 0, 0)
    tabContent.Size = UDim2.new(1, -125, 1, 0)
    
    -- Minimized button (shown when UI is hidden)
    local minimizedBtn = Instance.new("TextButton")
    minimizedBtn.Name = "MinimizedButton"
    minimizedBtn.Parent = ui
    minimizedBtn.BackgroundColor3 = config.MainColor
    minimizedBtn.BackgroundTransparency = 0.1
    minimizedBtn.BorderSizePixel = 0
    minimizedBtn.Position = UDim2.new(1, -60, 0.1, 0)
    minimizedBtn.Size = UDim2.new(0, 50, 0, 50)
    minimizedBtn.Visible = false
    minimizedBtn.Font = Enum.Font.GothamBold
    minimizedBtn.Text = "<"
    minimizedBtn.TextColor3 = config.TextColor
    minimizedBtn.TextSize = 24
    
    local minimizedCorner = Instance.new("UICorner")
    minimizedCorner.CornerRadius = UDim.new(0, 12)
    minimizedCorner.Parent = minimizedBtn
    
    -- UI state management
    local isVisible = true
    
    local function toggleVisibility()
        isVisible = not isVisible
        if isVisible then
            minimizedBtn.Visible = false
            Tween(mainFrame, {0.3, "Quint", "Out"}, {Position = UDim2.new(1, 0, 0.5, -200)})
            Tween(toggleBtn, {0.2, "Linear", "Out"}, {Text = ">"})
        else
            Tween(mainFrame, {0.3, "Quint", "Out"}, {Position = UDim2.new(1, 450, 0.5, -200)})
            Tween(toggleBtn, {0.2, "Linear", "Out"}, {Text = "<"})
            wait(0.3)
            minimizedBtn.Visible = true
        end
    end
    
    toggleBtn.MouseButton1Click:Connect(toggleVisibility)
    minimizedBtn.MouseButton1Click:Connect(toggleVisibility)
    
    -- Drag functionality
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Window object
    local window = {}
    
    function window:Tab(name, icon)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "TabButton"
        tabButton.BackgroundColor3 = config.TabColor
        tabButton.BackgroundTransparency = 0.1
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1, -10, 0, 40)
        tabButton.Font = Enum.Font.GothamBold
        tabButton.Text = "  " .. name
        tabButton.TextColor3 = config.TextColor
        tabButton.TextSize = 14
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.AutoButtonColor = false
        tabButton.Parent = tabButtons
        
        local tabButtonCorner = Instance.new("UICorner")
        tabButtonCorner.CornerRadius = UDim.new(0, 8)
        tabButtonCorner.Parent = tabButton
        
        local tabHighlight = Instance.new("Frame")
        tabHighlight.Name = "Highlight"
        tabHighlight.Parent = tabButton
        tabHighlight.BackgroundColor3 = config.AccentColor
        tabHighlight.BorderSizePixel = 0
        tabHighlight.Size = UDim2.new(0, 4, 1, 0)
        tabHighlight.Visible = false
        
        local tabContentFrame = Instance.new("ScrollingFrame")
        tabContentFrame.Name = name .. "TabContent"
        tabContentFrame.Parent = tabContent
        tabContentFrame.BackgroundTransparency = 1
        tabContentFrame.BorderSizePixel = 0
        tabContentFrame.Size = UDim2.new(1, 0, 1, 0)
        tabContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContentFrame.ScrollBarThickness = 5
        tabContentFrame.ScrollBarImageColor3 = config.AccentColor
        tabContentFrame.Visible = false
        
        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.Parent = tabContentFrame
        tabContentLayout.Padding = UDim.new(0, 10)
        tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        tabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContentFrame.CanvasSize = UDim2.new(0, 0, 0, tabContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab selection logic
        tabButton.MouseButton1Click:Connect(function()
            Ripple(tabButton)
            
            -- Hide all tab contents
            for _, child in pairs(tabContent:GetChildren()) do
                if child:IsA("ScrollingFrame") and child.Name:match("TabContent$") then
                    child.Visible = false
                end
            end
            
            -- Remove highlights from all buttons
            for _, child in pairs(tabButtons:GetChildren()) do
                if child:IsA("TextButton") and child:FindFirstChild("Highlight") then
                    child.Highlight.Visible = false
                end
            end
            
            -- Show selected tab
            tabContentFrame.Visible = true
            tabHighlight.Visible = true
        end)
        
        -- Select first tab by default
        if #tabButtons:GetChildren() == 1 then
            tabContentFrame.Visible = true
            tabHighlight.Visible = true
        end
        
        local tab = {}
        
        function tab:Section(name)
            local section = Instance.new("Frame")
            section.Name = name .. "Section"
            section.BackgroundColor3 = config.TabColor
            section.BackgroundTransparency = 0.1
            section.BorderSizePixel = 0
            section.Size = UDim2.new(1, -10, 0, 0)
            section.Parent = tabContentFrame
            section.ClipsDescendants = true
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 8)
            sectionCorner.Parent = section
            
            local sectionHeader = Instance.new("TextButton")
            sectionHeader.Name = "Header"
            sectionHeader.BackgroundTransparency = 1
            sectionHeader.BorderSizePixel = 0
            sectionHeader.Size = UDim2.new(1, 0, 0, 40)
            sectionHeader.Font = Enum.Font.GothamBold
            sectionHeader.Text = "  " .. name
            sectionHeader.TextColor3 = config.TextColor
            sectionHeader.TextSize = 16
            sectionHeader.TextXAlignment = Enum.TextXAlignment.Left
            sectionHeader.Parent = section
            
            local sectionToggle = Instance.new("ImageButton")
            sectionToggle.Name = "Toggle"
            sectionToggle.BackgroundTransparency = 1
            sectionToggle.Position = UDim2.new(1, -40, 0.5, -10)
            sectionToggle.Size = UDim2.new(0, 20, 0, 20)
            sectionToggle.Image = "rbxassetid://3926305904"
            sectionToggle.ImageRectOffset = Vector2.new(284, 4)
            sectionToggle.ImageRectSize = Vector2.new(24, 24)
            sectionToggle.Parent = sectionHeader
            
            local sectionContent = Instance.new("Frame")
            sectionContent.Name = "Content"
            sectionContent.BackgroundTransparency = 1
            sectionContent.BorderSizePixel = 0
            sectionContent.Position = UDim2.new(0, 0, 0, 40)
            sectionContent.Size = UDim2.new(1, 0, 0, 0)
            sectionContent.Parent = section
            
            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.Parent = sectionContent
            sectionLayout.Padding = UDim.new(0, 8)
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            local isOpen = true
            
            local function updateSection()
                if isOpen then
                    sectionToggle.ImageRectOffset = Vector2.new(364, 4)
                    section.Size = UDim2.new(1, -10, 0, 40 + sectionLayout.AbsoluteContentSize.Y + 10)
                    sectionContent.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y)
                else
                    sectionToggle.ImageRectOffset = Vector2.new(284, 4)
                    section.Size = UDim2.new(1, -10, 0, 40)
                    sectionContent.Size = UDim2.new(1, 0, 0, 0)
                end
            end
            
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isOpen then
                    updateSection()
                end
            end)
            
            sectionHeader.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                updateSection()
            end)
            
            sectionToggle.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                updateSection()
            end)
            
            updateSection()
            
            local sectionObj = {}
            
            function sectionObj:Button(text, callback)
                local button = Instance.new("TextButton")
                button.Name = text .. "Button"
                button.BackgroundColor3 = config.ButtonColor
                button.BackgroundTransparency = 0.1
                button.BorderSizePixel = 0
                button.Size = UDim2.new(1, 0, 0, 36)
                button.Font = Enum.Font.GothamBold
                button.Text = "  " .. text
                button.TextColor3 = config.TextColor
                button.TextSize = 14
                button.TextXAlignment = Enum.TextXAlignment.Left
                button.AutoButtonColor = false
                button.Parent = sectionContent
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 6)
                buttonCorner.Parent = button
                
                local buttonHighlight = Instance.new("Frame")
                buttonHighlight.Name = "Highlight"
                buttonHighlight.Parent = button
                buttonHighlight.BackgroundColor3 = config.AccentColor
                buttonHighlight.BorderSizePixel = 0
                buttonHighlight.Position = UDim2.new(0, 0, 1, -3)
                buttonHighlight.Size = UDim2.new(0, 0, 0, 3)
                buttonHighlight.Visible = false
                
                button.MouseButton1Click:Connect(function()
                    Ripple(button)
                    if callback then
                        callback()
                    end
                    
                    -- Animate highlight
                    buttonHighlight.Visible = true
                    buttonHighlight.Size = UDim2.new(0, 0, 0, 3)
                    Tween(buttonHighlight, {0.2, "Quint", "Out"}, {Size = UDim2.new(1, 0, 0, 3)})
                    wait(0.5)
                    Tween(buttonHighlight, {0.2, "Quint", "Out"}, {Size = UDim2.new(0, 0, 0, 3)})
                    wait(0.2)
                    buttonHighlight.Visible = false
                end)
                
                return button
            end
            
            function sectionObj:Toggle(text, flag, default, callback)
                local toggle = Instance.new("TextButton")
                toggle.Name = text .. "Toggle"
                toggle.BackgroundColor3 = config.ToggleColor
                toggle.BackgroundTransparency = 0.1
                toggle.BorderSizePixel = 0
                toggle.Size = UDim2.new(1, 0, 0, 36)
                toggle.Font = Enum.Font.GothamBold
                toggle.Text = "  " .. text
                toggle.TextColor3 = config.TextColor
                toggle.TextSize = 14
                toggle.TextXAlignment = Enum.TextXAlignment.Left
                toggle.AutoButtonColor = false
                toggle.Parent = sectionContent
                
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 6)
                toggleCorner.Parent = toggle
                
                local toggleSwitch = Instance.new("Frame")
                toggleSwitch.Name = "Switch"
                toggleSwitch.Parent = toggle
                toggleSwitch.BackgroundColor3 = default and config.ToggleOn or config.ToggleOff
                toggleSwitch.BorderSizePixel = 0
                toggleSwitch.Position = UDim2.new(1, -50, 0.5, -10)
                toggleSwitch.Size = UDim2.new(0, 40, 0, 20)
                
                local toggleSwitchCorner = Instance.new("UICorner")
                toggleSwitchCorner.CornerRadius = UDim.new(0, 10)
                toggleSwitchCorner.Parent = toggleSwitch
                
                local toggleKnob = Instance.new("Frame")
                toggleKnob.Name = "Knob"
                toggleKnob.Parent = toggleSwitch
                toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleKnob.BorderSizePixel = 0
                toggleKnob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                toggleKnob.Size = UDim2.new(0, 16, 0, 16)
                
                local toggleKnobCorner = Instance.new("UICorner")
                toggleKnobCorner.CornerRadius = UDim.new(0, 8)
                toggleKnobCorner.Parent = toggleKnob
                
                local state = default or false
                library.flags[flag] = state
                
                local function updateToggle()
                    if state then
                        Tween(toggleKnob, {0.2, "Quint", "Out"}, {Position = UDim2.new(1, -18, 0.5, -8)})
                        Tween(toggleSwitch, {0.2, "Quint", "Out"}, {BackgroundColor3 = config.ToggleOn})
                    else
                        Tween(toggleKnob, {0.2, "Quint", "Out"}, {Position = UDim2.new(0, 2, 0.5, -8)})
                        Tween(toggleSwitch, {0.2, "Quint", "Out"}, {BackgroundColor3 = config.ToggleOff})
                    end
                end
                
                toggle.MouseButton1Click:Connect(function()
                    Ripple(toggle)
                    state = not state
                    library.flags[flag] = state
                    updateToggle()
                    if callback then
                        callback(state)
                    end
                end)
                
                updateToggle()
                
                local toggleObj = {}
                
                function toggleObj:SetValue(value)
                    state = value
                    library.flags[flag] = state
                    updateToggle()
                    if callback then
                        callback(state)
                    end
                end
                
                return toggleObj
            end
            
            function sectionObj:Slider(text, flag, min, max, default, callback)
                local slider = Instance.new("Frame")
                slider.Name = text .. "Slider"
                slider.BackgroundColor3 = config.SliderColor
                slider.BackgroundTransparency = 0.1
                slider.BorderSizePixel = 0
                slider.Size = UDim2.new(1, 0, 0, 60)
                slider.Parent = sectionContent
                
                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 6)
                sliderCorner.Parent = slider
                
                local sliderText = Instance.new("TextLabel")
                sliderText.Name = "Text"
                sliderText.Parent = slider
                sliderText.BackgroundTransparency = 1
                sliderText.Position = UDim2.new(0, 10, 0, 5)
                sliderText.Size = UDim2.new(1, -20, 0, 20)
                sliderText.Font = Enum.Font.GothamBold
                sliderText.Text = text
                sliderText.TextColor3 = config.TextColor
                sliderText.TextSize = 14
                sliderText.TextXAlignment = Enum.TextXAlignment.Left
                
                local sliderBar = Instance.new("Frame")
                sliderBar.Name = "Bar"
                sliderBar.Parent = slider
                sliderBar.BackgroundColor3 = config.BgColor
                sliderBar.BackgroundTransparency = 0.2
                sliderBar.BorderSizePixel = 0
                sliderBar.Position = UDim2.new(0, 10, 0, 30)
                sliderBar.Size = UDim2.new(1, -20, 0, 10)
                
                local sliderBarCorner = Instance.new("UICorner")
                sliderBarCorner.CornerRadius = UDim.new(0, 5)
                sliderBarCorner.Parent = sliderBar
                
                local sliderFill = Instance.new("Frame")
                sliderFill.Name = "Fill"
                sliderFill.Parent = sliderBar
                sliderFill.BackgroundColor3 = config.SliderBarColor
                sliderFill.BorderSizePixel = 0
                sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                
                local sliderFillCorner = Instance.new("UICorner")
                sliderFillCorner.CornerRadius = UDim.new(0, 5)
                sliderFillCorner.Parent = sliderFill
                
                local sliderKnob = Instance.new("Frame")
                sliderKnob.Name = "Knob"
                sliderKnob.Parent = sliderBar
                sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderKnob.BorderSizePixel = 0
                sliderKnob.Position = UDim2.new((default - min) / (max - min), -5, 0, -5)
                sliderKnob.Size = UDim2.new(0, 10, 0, 20)
                
                local sliderKnobCorner = Instance.new("UICorner")
                sliderKnobCorner.CornerRadius = UDim.new(0, 5)
                sliderKnobCorner.Parent = sliderKnob
                
                local sliderValue = Instance.new("TextBox")
                sliderValue.Name = "Value"
                sliderValue.Parent = slider
                sliderValue.BackgroundColor3 = config.BgColor
                sliderValue.BackgroundTransparency = 0.2
                sliderValue.BorderSizePixel = 0
                sliderValue.Position = UDim2.new(1, -60, 0, 5)
                sliderValue.Size = UDim2.new(0, 50, 0, 20)
                sliderValue.Font = Enum.Font.Gotham
                sliderValue.Text = tostring(default)
                sliderValue.TextColor3 = config.TextColor
                sliderValue.TextSize = 14
                sliderValue.ClearTextOnFocus = false
                
                local sliderValueCorner = Instance.new("UICorner")
                sliderValueCorner.CornerRadius = UDim.new(0, 4)
                sliderValueCorner.Parent = sliderValue
                
                local sliderValuePadding = Instance.new("UIPadding")
                sliderValuePadding.Parent = sliderValue
                sliderValuePadding.PaddingLeft = UDim.new(0, 5)
                sliderValuePadding.PaddingRight = UDim.new(0, 5)
                
                library.flags[flag] = default
                
                local dragging = false
                local function updateSlider(value)
                    value = math.clamp(value, min, max)
                    local percent = (value - min) / (max - min)
                    
                    Tween(sliderFill, {0.1, "Linear", "Out"}, {Size = UDim2.new(percent, 0, 1, 0)})
                    Tween(sliderKnob, {0.1, "Linear", "Out"}, {Position = UDim2.new(percent, -5, 0, -5)})
                    
                    sliderValue.Text = tostring(math.floor(value * 100) / 100)
                    library.flags[flag] = value
                    
                    if callback then
                        callback(value)
                    end
                end
                
                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local percent = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                        updateSlider(min + (max - min) * percent)
                    end
                end)
                
                sliderBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                        updateSlider(min + (max - min) * percent)
                    end
                end)
                
                sliderValue.FocusLost:Connect(function()
                    local num = tonumber(sliderValue.Text)
                    if num then
                        updateSlider(num)
                    else
                        sliderValue.Text = tostring(library.flags[flag])
                    end
                end)
                
                updateSlider(default)
                
                local sliderObj = {}
                
                function sliderObj:SetValue(value)
                    updateSlider(value)
                end
                
                return sliderObj
            end
            
            -- Add more elements here (Dropdown, Keybind, etc.)
            
            return sectionObj
        end
        
        return tab
    end
    
    -- Search functionality
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = searchBox.Text:lower()
        
        for _, tab in pairs(tabContent:GetChildren()) do
            if tab:IsA("ScrollingFrame") and tab.Name:match("TabContent$") then
                for _, section in pairs(tab:GetChildren()) do
                    if section:IsA("Frame") and section.Name:match("Section$") then
                        local foundInSection = false
                        
                        for _, element in pairs(section.Content:GetChildren()) do
                            if element:IsA("Frame") or element:IsA("TextButton") then
                                local elementText = element:FindFirstChild("Text") or element
                                if elementText:IsA("TextLabel") or elementText:IsA("TextButton") then
                                    local text = elementText.Text:lower()
                                    if searchText == "" or text:find(searchText) then
                                        element.Visible = true
                                        foundInSection = true
                                    else
                                        element.Visible = false
                                    end
                                end
                            end
                        end
                        
                        section.Visible = foundInSection or searchText == ""
                    end
                end
            end
        end
    end)
    
    return window
end

return library