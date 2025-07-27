local library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Modern color palette with cyberpunk/tech theme
local colors = {
    main = Color3.fromRGB(10, 10, 20),
    secondary = Color3.fromRGB(20, 20, 40),
    accent = Color3.fromRGB(0, 255, 255),
    accent2 = Color3.fromRGB(255, 0, 255),
    text = Color3.fromRGB(240, 240, 240),
    highlight = Color3.fromRGB(50, 50, 80),
    slider = Color3.fromRGB(0, 200, 200),
    toggleOn = Color3.fromRGB(0, 255, 200),
    toggleOff = Color3.fromRGB(80, 80, 100),
    button = Color3.fromRGB(30, 30, 60),
    buttonHover = Color3.fromRGB(50, 50, 90)
}

-- Animation settings
local animationSettings = {
    speed = 0.25,
    easingStyle = Enum.EasingStyle.Quint,
    easingDirection = Enum.EasingDirection.Out
}

local function createRipple(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "RippleEffect"
    ripple.BackgroundColor3 = colors.accent
    ripple.BackgroundTransparency = 0.7
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.ZIndex = 10
    ripple.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local buttonPos = button.AbsolutePosition
    local relativePos = mousePos - buttonPos
    
    ripple.Position = UDim2.new(0, relativePos.X, 0, relativePos.Y)
    
    TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(2, 0, 2, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    game.Debris:AddItem(ripple, 0.5)
end

local function createGlow(frame)
    local glow = Instance.new("ImageLabel")
    glow.Name = "GlowEffect"
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = colors.accent
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(24, 24, 24, 24)
    glow.BackgroundTransparency = 1
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.ZIndex = -1
    glow.Parent = frame
    
    TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
        ImageColor3 = colors.accent2
    }):Play()
end

function library.new(title)
    -- Main UI Container
    local ui = Instance.new("ScreenGui")
    ui.Name = "TechUI"
    ui.ResetOnSpawn = false
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    if syn and syn.protect_gui then
        syn.protect_gui(ui)
    end
    ui.Parent = game:GetService("CoreGui")
    
    -- Main Frame (will slide in/out)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.85, 0, 1, 0)
    mainFrame.Position = UDim2.new(1, 0, 0, 0)
    mainFrame.AnchorPoint = Vector2.new(1, 0)
    mainFrame.BackgroundColor3 = colors.main
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.ZIndex = 1
    mainFrame.Parent = ui
    
    -- Corner radius for modern look
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Add glow effect
    createGlow(mainFrame)
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = colors.secondary
    header.BorderSizePixel = 0
    header.ZIndex = 2
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = title or "Tech UI"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextColor3 = colors.text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    titleLabel.ZIndex = 3
    titleLabel.Parent = header
    
    -- Close button (triangle)
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Text = "◀"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 24
    closeButton.TextColor3 = colors.accent
    closeButton.BackgroundTransparency = 1
    closeButton.Size = UDim2.new(0, 50, 1, 0)
    closeButton.Position = UDim2.new(1, -50, 0, 0)
    closeButton.ZIndex = 3
    closeButton.Parent = header
    
    -- Search box
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.PlaceholderText = "Search features..."
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 14
    searchBox.TextColor3 = colors.text
    searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    searchBox.BackgroundColor3 = colors.highlight
    searchBox.BackgroundTransparency = 0.5
    searchBox.Size = UDim2.new(0.4, 0, 0.6, 0)
    searchBox.Position = UDim2.new(0.55, 0, 0.2, 0)
    searchBox.ZIndex = 3
    searchBox.Parent = header
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchBox
    
    local searchPadding = Instance.new("UIPadding")
    searchPadding.PaddingLeft = UDim.new(0, 10)
    searchPadding.Parent = searchBox
    
    -- Tab container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 120, 1, -50)
    tabContainer.Position = UDim2.new(0, 0, 0, 50)
    tabContainer.BackgroundColor3 = colors.secondary
    tabContainer.BorderSizePixel = 0
    tabContainer.ZIndex = 2
    tabContainer.Parent = mainFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 12)
    tabCorner.Parent = tabContainer
    
    -- Content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -120, 1, -50)
    contentContainer.Position = UDim2.new(0, 120, 0, 50)
    contentContainer.BackgroundTransparency = 1
    contentContainer.BorderSizePixel = 0
    contentContainer.ZIndex = 2
    contentContainer.Parent = mainFrame
    
    -- Tab buttons list
    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, 0, 1, 0)
    tabList.BackgroundTransparency = 1
    tabList.ScrollBarThickness = 4
    tabList.ScrollBarImageColor3 = colors.accent
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.Parent = tabContainer
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.Parent = tabList
    
    -- UI toggle button (triangle on the side)
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Text = "▶"
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 24
    toggleButton.TextColor3 = colors.accent
    toggleButton.BackgroundColor3 = colors.main
    toggleButton.BackgroundTransparency = 0.5
    toggleButton.Size = UDim2.new(0, 40, 0, 80)
    toggleButton.Position = UDim2.new(1, -40, 0.5, -40)
    toggleButton.AnchorPoint = Vector2.new(1, 0.5)
    toggleButton.ZIndex = 5
    toggleButton.Parent = ui
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleButton
    
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = colors.accent
    toggleStroke.Thickness = 2
    toggleStroke.Parent = toggleButton
    
    -- Animation state
    local isOpen = false
    
    -- Function to toggle UI
    local function toggleUI()
        isOpen = not isOpen
        
        if isOpen then
            TweenService:Create(mainFrame, TweenInfo.new(animationSettings.speed, animationSettings.easingStyle, animationSettings.easingDirection), {
                Position = UDim2.new(1, -20, 0, 0)
            }):Play()
            
            TweenService:Create(toggleButton, TweenInfo.new(animationSettings.speed, animationSettings.easingStyle, animationSettings.easingDirection), {
                Position = UDim2.new(1, -40, 0.5, -40),
                Text = "◀"
            }):Play()
        else
            TweenService:Create(mainFrame, TweenInfo.new(animationSettings.speed, animationSettings.easingStyle, animationSettings.easingDirection), {
                Position = UDim2.new(1, 0, 0, 0)
            }):Play()
            
            TweenService:Create(toggleButton, TweenInfo.new(animationSettings.speed, animationSettings.easingStyle, animationSettings.easingDirection), {
                Position = UDim2.new(1, 0, 0.5, -40),
                Text = "▶"
            }):Play()
        end
    end
    
    -- Connect toggle buttons
    toggleButton.MouseButton1Click:Connect(toggleUI)
    closeButton.MouseButton1Click:Connect(toggleUI)
    
    -- Make header draggable
    local dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragStart = nil
                end
            end)
        end
    end)
    
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Window object
    local window = {}
    window.currentTab = nil
    window.flags = {}
    
    function window:Tab(name, icon)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "TabButton"
        tabButton.Text = "  " .. name
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.TextSize = 14
        tabButton.TextColor3 = colors.text
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.BackgroundColor3 = colors.highlight
        tabButton.BackgroundTransparency = 0.9
        tabButton.Size = UDim2.new(1, -10, 0, 35)
        tabButton.AutoButtonColor = false
        tabButton.Parent = tabList
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton
        
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.Image = "rbxassetid://" .. (icon or "3926305904")
        tabIcon.Size = UDim2.new(0, 20, 0, 20)
        tabIcon.Position = UDim2.new(0, 5, 0.5, -10)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Parent = tabButton
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name .. "TabContent"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = colors.accent
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = false
        tabContent.Parent = contentContainer
        
        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.Padding = UDim.new(0, 10)
        tabContentLayout.Parent = tabContent
        
        -- Update canvas size
        tabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, tabContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab selection
        tabButton.MouseButton1Click:Connect(function()
            createRipple(tabButton)
            
            if window.currentTab then
                window.currentTab.button.BackgroundTransparency = 0.9
                window.currentTab.content.Visible = false
            end
            
            window.currentTab = {
                button = tabButton,
                content = tabContent
            }
            
            tabButton.BackgroundTransparency = 0.7
            tabContent.Visible = true
        end)
        
        -- Select first tab by default
        if not window.currentTab then
            window.currentTab = {
                button = tabButton,
                content = tabContent
            }
            
            tabButton.BackgroundTransparency = 0.7
            tabContent.Visible = true
        end
        
        -- Tab object
        local tab = {}
        
        function tab:Section(title, side)
            -- Split content container into two columns if side is specified
            local sectionContainer = contentContainer
            if side == "left" or side == "right" then
                -- Create columns if they don't exist
                if not contentContainer:FindFirstChild("LeftColumn") then
                    local leftColumn = Instance.new("ScrollingFrame")
                    leftColumn.Name = "LeftColumn"
                    leftColumn.Size = UDim2.new(0.5, -5, 1, 0)
                    leftColumn.Position = UDim2.new(0, 0, 0, 0)
                    leftColumn.BackgroundTransparency = 1
                    leftColumn.ScrollBarThickness = 4
                    leftColumn.ScrollBarImageColor3 = colors.accent
                    leftColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
                    leftColumn.Parent = contentContainer
                    
                    local leftLayout = Instance.new("UIListLayout")
                    leftLayout.Padding = UDim.new(0, 10)
                    leftLayout.Parent = leftColumn
                    
                    leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        leftColumn.CanvasSize = UDim2.new(0, 0, 0, leftLayout.AbsoluteContentSize.Y + 20)
                    end)
                    
                    local rightColumn = Instance.new("ScrollingFrame")
                    rightColumn.Name = "RightColumn"
                    rightColumn.Size = UDim2.new(0.5, -5, 1, 0)
                    rightColumn.Position = UDim2.new(0.5, 5, 0, 0)
                    rightColumn.BackgroundTransparency = 1
                    rightColumn.ScrollBarThickness = 4
                    rightColumn.ScrollBarImageColor3 = colors.accent
                    rightColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
                    rightColumn.Parent = contentContainer
                    
                    local rightLayout = Instance.new("UIListLayout")
                    rightLayout.Padding = UDim.new(0, 10)
                    rightLayout.Parent = rightColumn
                    
                    rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        rightColumn.CanvasSize = UDim2.new(0, 0, 0, rightLayout.AbsoluteContentSize.Y + 20)
                    end)
                end
                
                sectionContainer = contentContainer:FindFirstChild(side == "left" and "LeftColumn" or "RightColumn")
            end
            
            local section = Instance.new("Frame")
            section.Name = title .. "Section"
            section.BackgroundColor3 = colors.secondary
            section.BackgroundTransparency = 0.5
            section.Size = UDim2.new(1, 0, 0, 0)
            section.AutomaticSize = Enum.AutomaticSize.Y
            section.Parent = sectionContainer
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 8)
            sectionCorner.Parent = section
            
            local sectionStroke = Instance.new("UIStroke")
            sectionStroke.Color = colors.accent
            sectionStroke.Thickness = 1
            sectionStroke.Transparency = 0.7
            sectionStroke.Parent = section
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "Title"
            sectionTitle.Text = title
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.TextSize = 16
            sectionTitle.TextColor3 = colors.accent
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Size = UDim2.new(1, -20, 0, 30)
            sectionTitle.Position = UDim2.new(0, 10, 0, 0)
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.Parent = section
            
            local sectionContent = Instance.new("Frame")
            sectionContent.Name = "Content"
            sectionContent.BackgroundTransparency = 1
            sectionContent.Size = UDim2.new(1, -20, 0, 0)
            sectionContent.Position = UDim2.new(0, 10, 0, 30)
            sectionContent.AutomaticSize = Enum.AutomaticSize.Y
            sectionContent.Parent = section
            
            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.Padding = UDim.new(0, 10)
            sectionLayout.Parent = sectionContent
            
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sectionContent.Size = UDim2.new(1, -20, 0, sectionLayout.AbsoluteContentSize.Y)
                section.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y + 40)
            end)
            
            -- Section object
            local sectionObj = {}
            
            function sectionObj:Button(text, callback)
                local button = Instance.new("TextButton")
                button.Name = text .. "Button"
                button.Text = text
                button.Font = Enum.Font.GothamSemibold
                button.TextSize = 14
                button.TextColor3 = colors.text
                button.BackgroundColor3 = colors.button
                button.Size = UDim2.new(1, 0, 0, 35)
                button.AutoButtonColor = false
                button.Parent = sectionContent
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 6)
                buttonCorner.Parent = button
                
                local buttonStroke = Instance.new("UIStroke")
                buttonStroke.Color = colors.accent
                buttonStroke.Thickness = 1
                buttonStroke.Transparency = 0.7
                buttonStroke.Parent = button
                
                button.MouseEnter:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.15), {
                        BackgroundColor3 = colors.buttonHover
                    }):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.15), {
                        BackgroundColor3 = colors.button
                    }):Play()
                end)
                
                button.MouseButton1Click:Connect(function()
                    createRipple(button)
                    if callback then callback() end
                end)
                
                return button
            end
            
            function sectionObj:Toggle(text, flag, default, callback)
                window.flags[flag] = default or false
                
                local toggle = Instance.new("TextButton")
                toggle.Name = text .. "Toggle"
                toggle.Text = "  " .. text
                toggle.Font = Enum.Font.GothamSemibold
                toggle.TextSize = 14
                toggle.TextColor3 = colors.text
                toggle.BackgroundColor3 = colors.button
                toggle.Size = UDim2.new(1, 0, 0, 35)
                toggle.AutoButtonColor = false
                toggle.TextXAlignment = Enum.TextXAlignment.Left
                toggle.Parent = sectionContent
                
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 6)
                toggleCorner.Parent = toggle
                
                local toggleStroke = Instance.new("UIStroke")
                toggleStroke.Color = colors.accent
                toggleStroke.Thickness = 1
                toggleStroke.Transparency = 0.7
                toggleStroke.Parent = toggle
                
                local toggleIndicator = Instance.new("Frame")
                toggleIndicator.Name = "Indicator"
                toggleIndicator.Size = UDim2.new(0, 50, 0, 20)
                toggleIndicator.Position = UDim2.new(1, -60, 0.5, -10)
                toggleIndicator.BackgroundColor3 = colors.toggleOff
                toggleIndicator.Parent = toggle
                
                local toggleIndicatorCorner = Instance.new("UICorner")
                toggleIndicatorCorner.CornerRadius = UDim.new(1, 0)
                toggleIndicatorCorner.Parent = toggleIndicator
                
                local toggleSwitch = Instance.new("Frame")
                toggleSwitch.Name = "Switch"
                toggleSwitch.Size = UDim2.new(0, 16, 0, 16)
                toggleSwitch.Position = UDim2.new(0, 2, 0.5, -8)
                toggleSwitch.BackgroundColor3 = colors.text
                toggleSwitch.Parent = toggleIndicator
                
                local toggleSwitchCorner = Instance.new("UICorner")
                toggleSwitchCorner.CornerRadius = UDim.new(1, 0)
                toggleSwitchCorner.Parent = toggleSwitch
                
                local function updateToggle(value)
                    window.flags[flag] = value
                    
                    TweenService:Create(toggleSwitch, TweenInfo.new(0.2), {
                        Position = UDim2.new(0, value and 32 or 2, 0.5, -8),
                        BackgroundColor3 = value and colors.accent or colors.text
                    }):Play()
                    
                    TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {
                        BackgroundColor3 = value and colors.toggleOn or colors.toggleOff
                    }):Play()
                    
                    if callback then callback(value) end
                end
                
                toggle.MouseButton1Click:Connect(function()
                    createRipple(toggle)
                    updateToggle(not window.flags[flag])
                end)
                
                updateToggle(default or false)
                
                return {
                    Set = function(_, value)
                        updateToggle(value)
                    end
                }
            end
            
            function sectionObj:Slider(text, flag, min, max, default, callback)
                window.flags[flag] = default or min
                
                local slider = Instance.new("Frame")
                slider.Name = text .. "Slider"
                slider.BackgroundTransparency = 1
                slider.Size = UDim2.new(1, 0, 0, 50)
                slider.Parent = sectionContent
                
                local sliderTitle = Instance.new("TextLabel")
                sliderTitle.Name = "Title"
                sliderTitle.Text = "  " .. text
                sliderTitle.Font = Enum.Font.GothamSemibold
                sliderTitle.TextSize = 14
                sliderTitle.TextColor3 = colors.text
                sliderTitle.BackgroundTransparency = 1
                sliderTitle.Size = UDim2.new(1, 0, 0, 20)
                sliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                sliderTitle.Parent = slider
                
                local sliderBar = Instance.new("Frame")
                sliderBar.Name = "Bar"
                sliderBar.Size = UDim2.new(1, -20, 0, 6)
                sliderBar.Position = UDim2.new(0, 10, 0, 30)
                sliderBar.BackgroundColor3 = colors.highlight
                sliderBar.Parent = slider
                
                local sliderBarCorner = Instance.new("UICorner")
                sliderBarCorner.CornerRadius = UDim.new(1, 0)
                sliderBarCorner.Parent = sliderBar
                
                local sliderFill = Instance.new("Frame")
                sliderFill.Name = "Fill"
                sliderFill.Size = UDim2.new(0, 0, 1, 0)
                sliderFill.BackgroundColor3 = colors.slider
                sliderFill.Parent = sliderBar
                
                local sliderFillCorner = Instance.new("UICorner")
                sliderFillCorner.CornerRadius = UDim.new(1, 0)
                sliderFillCorner.Parent = sliderFill
                
                local sliderValue = Instance.new("TextLabel")
                sliderValue.Name = "Value"
                sliderValue.Text = tostring(default or min)
                sliderValue.Font = Enum.Font.Gotham
                sliderValue.TextSize = 12
                sliderValue.TextColor3 = colors.text
                sliderValue.BackgroundTransparency = 1
                sliderValue.Size = UDim2.new(0, 60, 0, 20)
                sliderValue.Position = UDim2.new(1, -60, 0, 30)
                sliderValue.TextXAlignment = Enum.TextXAlignment.Right
                sliderValue.Parent = slider
                
                local sliderButton = Instance.new("TextButton")
                sliderButton.Name = "Button"
                sliderButton.Text = ""
                sliderButton.BackgroundTransparency = 1
                sliderButton.Size = UDim2.new(1, 0, 0, 30)
                sliderButton.Position = UDim2.new(0, 0, 0, 20)
                sliderButton.Parent = slider
                
                local dragging = false
                
                local function updateSlider(value)
                    value = math.clamp(value, min, max)
                    window.flags[flag] = value
                    
                    local percent = (value - min) / (max - min)
                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    sliderValue.Text = tostring(math.floor(value))
                    
                    if callback then callback(value) end
                end
                
                sliderButton.MouseButton1Down:Connect(function()
                    dragging = true
                    updateSlider(min + ((Mouse.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X) * (max - min))
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(min + ((Mouse.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X) * (max - min))
                    end
                end)
                
                updateSlider(default or min)
                
                return {
                    Set = function(_, value)
                        updateSlider(value)
                    end
                }
            end
            
            function sectionObj:Dropdown(text, flag, options, callback)
                window.flags[flag] = nil
                
                local dropdown = Instance.new("Frame")
                dropdown.Name = text .. "Dropdown"
                dropdown.BackgroundTransparency = 1
                dropdown.Size = UDim2.new(1, 0, 0, 35)
                dropdown.Parent = sectionContent
                
                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Name = "Button"
                dropdownButton.Text = "  " .. text
                dropdownButton.Font = Enum.Font.GothamSemibold
                dropdownButton.TextSize = 14
                dropdownButton.TextColor3 = colors.text
                dropdownButton.BackgroundColor3 = colors.button
                dropdownButton.Size = UDim2.new(1, 0, 0, 35)
                dropdownButton.AutoButtonColor = false
                dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                dropdownButton.Parent = dropdown
                
                local dropdownButtonCorner = Instance.new("UICorner")
                dropdownButtonCorner.CornerRadius = UDim.new(0, 6)
                dropdownButtonCorner.Parent = dropdownButton
                
                local dropdownButtonStroke = Instance.new("UIStroke")
                dropdownButtonStroke.Color = colors.accent
                dropdownButtonStroke.Thickness = 1
                dropdownButtonStroke.Transparency = 0.7
                dropdownButtonStroke.Parent = dropdownButton
                
                local dropdownArrow = Instance.new("ImageLabel")
                dropdownArrow.Name = "Arrow"
                dropdownArrow.Image = "rbxassetid://3926307971"
                dropdownArrow.ImageRectOffset = Vector2.new(364, 284)
                dropdownArrow.ImageRectSize = Vector2.new(36, 36)
                dropdownArrow.Size = UDim2.new(0, 20, 0, 20)
                dropdownArrow.Position = UDim2.new(1, -30, 0.5, -10)
                dropdownArrow.BackgroundTransparency = 1
                dropdownArrow.Parent = dropdownButton
                
                local dropdownValue = Instance.new("TextLabel")
                dropdownValue.Name = "Value"
                dropdownValue.Text = "None"
                dropdownValue.Font = Enum.Font.Gotham
                dropdownValue.TextSize = 12
                dropdownValue.TextColor3 = colors.text
                dropdownValue.BackgroundTransparency = 1
                dropdownValue.Size = UDim2.new(0, 100, 0, 20)
                dropdownValue.Position = UDim2.new(1, -130, 0.5, -10)
                dropdownValue.TextXAlignment = Enum.TextXAlignment.Right
                dropdownValue.Parent = dropdownButton
                
                local dropdownContent = Instance.new("Frame")
                dropdownContent.Name = "Content"
                dropdownContent.BackgroundColor3 = colors.secondary
                dropdownContent.Size = UDim2.new(1, 0, 0, 0)
                dropdownContent.Position = UDim2.new(0, 0, 0, 40)
                dropdownContent.ClipsDescendants = true
                dropdownContent.Visible = false
                dropdownContent.Parent = dropdown
                
                local dropdownContentCorner = Instance.new("UICorner")
                dropdownContentCorner.CornerRadius = UDim.new(0, 6)
                dropdownContentCorner.Parent = dropdownContent
                
                local dropdownContentStroke = Instance.new("UIStroke")
                dropdownContentStroke.Color = colors.accent
                dropdownContentStroke.Thickness = 1
                dropdownContentStroke.Transparency = 0.7
                dropdownContentStroke.Parent = dropdownContent
                
                local dropdownList = Instance.new("UIListLayout")
                dropdownList.Padding = UDim.new(0, 5)
                dropdownList.Parent = dropdownContent
                
                dropdownList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    dropdownContent.Size = UDim2.new(1, 0, 0, dropdownList.AbsoluteContentSize.Y)
                end)
                
                local isOpen = false
                
                local function toggleDropdown()
                    isOpen = not isOpen
                    
                    if isOpen then
                        dropdownContent.Visible = true
                        TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {
                            Rotation = 180
                        }):Play()
                        
                        TweenService:Create(dropdownContent, TweenInfo.new(0.2), {
                            Size = UDim2.new(1, 0, 0, dropdownList.AbsoluteContentSize.Y)
                        }):Play()
                    else
                        TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {
                            Rotation = 0
                        }):Play()
                        
                        TweenService:Create(dropdownContent, TweenInfo.new(0.2), {
                            Size = UDim2.new(1, 0, 0, 0)
                        }):Play()
                        
                        wait(0.2)
                        dropdownContent.Visible = false
                    end
                end
                
                dropdownButton.MouseButton1Click:Connect(function()
                    createRipple(dropdownButton)
                    toggleDropdown()
                end)
                
                local function addOption(option)
                    local optionButton = Instance.new("TextButton")
                    optionButton.Name = option .. "Option"
                    optionButton.Text = "  " .. option
                    optionButton.Font = Enum.Font.Gotham
                    optionButton.TextSize = 14
                    optionButton.TextColor3 = colors.text
                    optionButton.BackgroundColor3 = colors.highlight
                    optionButton.BackgroundTransparency = 0.8
                    optionButton.Size = UDim2.new(1, -10, 0, 30)
                    optionButton.AutoButtonColor = false
                    optionButton.TextXAlignment = Enum.TextXAlignment.Left
                    optionButton.Parent = dropdownContent
                    
                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, 4)
                    optionCorner.Parent = optionButton
                    
                    optionButton.MouseButton1Click:Connect(function()
                        createRipple(optionButton)
                        window.flags[flag] = option
                        dropdownValue.Text = option
                        toggleDropdown()
                        if callback then callback(option) end
                    end)
                end
                
                for _, option in pairs(options) do
                    addOption(option)
                end
                
                return {
                    AddOption = function(_, option)
                        addOption(option)
                    end,
                    RemoveOption = function(_, option)
                        local optionButton = dropdownContent:FindFirstChild(option .. "Option")
                        if optionButton then
                            optionButton:Destroy()
                        end
                    end,
                    SetOptions = function(_, newOptions)
                        for _, child in pairs(dropdownContent:GetChildren()) do
                            if child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end
                        
                        for _, option in pairs(newOptions) do
                            addOption(option)
                        end
                    end
                }
            end
            
            function sectionObj:Label(text)
                local label = Instance.new("TextLabel")
                label.Name = text .. "Label"
                label.Text = text
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextColor3 = colors.text
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 0, 20)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = sectionContent
                
                return label
            end
            
            return sectionObj
        end
        
        return tab
    end
    
    -- Search functionality
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = searchBox.Text:lower()
        
        for _, tab in pairs(contentContainer:GetDescendants()) do
            if tab:IsA("ScrollingFrame") and tab.Name:match("TabContent$") then
                for _, section in pairs(tab:GetDescendants()) do
                    if section:IsA("Frame") and section.Name:match("Section$") then
                        local showSection = false
                        
                        for _, element in pairs(section:GetDescendants()) do
                            if element:IsA("TextButton") or element:IsA("TextLabel") then
                                if element.Text and element.Text:lower():find(searchText) then
                                    showSection = true
                                    element.Visible = true
                                else
                                    element.Visible = searchText == ""
                                end
                            end
                        end
                        
                        section.Visible = showSection or searchText == ""
                    end
                end
            end
        end
    end)
    
    -- Initial animation
    toggleUI()
    
    return window
end

return library