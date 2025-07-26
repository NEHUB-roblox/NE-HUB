-- Enhanced UI Library with Dynamic Visuals and Search Functionality
local library = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Wait for game to load
repeat task.wait() until game:IsLoaded()

-- Configuration
local config = {
    MainColor = Color3.fromRGB(15, 15, 25),
    TabColor = Color3.fromRGB(22, 22, 22),
    BgColor = Color3.fromRGB(17, 17, 17),
    AccentColor = Color3.fromRGB(37, 254, 152),
    
    -- Dynamic effects
    BorderThickness = 2,
    BorderAnimationSpeed = 2,
    ParticleCount = 20,
    ParticleSpeed = 0.5,
    
    -- Text colors
    TextColor = Color3.fromRGB(255, 255, 255),
    PlaceholderColor = Color3.fromRGB(180, 180, 180),
    
    -- Element colors
    ButtonColor = Color3.fromRGB(30, 30, 40),
    ToggleOnColor = Color3.fromRGB(37, 254, 152),
    ToggleOffColor = Color3.fromRGB(70, 70, 80),
    SliderBarColor = Color3.fromRGB(37, 254, 152),
    DropdownColor = Color3.fromRGB(30, 30, 40)
}

-- Helper functions
local function createRipple(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.Size = UDim2.new(0, 1, 0, 1)
    ripple.Position = UDim2.new(
        (UserInputService:GetMouseLocation().X - button.AbsolutePosition.X) / button.AbsoluteSize.X,
        0,
        (UserInputService:GetMouseLocation().Y - button.AbsolutePosition.Y) / button.AbsoluteSize.Y,
        0
    )
    ripple.Parent = button
    ripple.ZIndex = 10
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    TweenService:Create(ripple, TweenInfo.new(0.5), {
        Size = UDim2.new(0, button.AbsoluteSize.X * 2, 0, button.AbsoluteSize.X * 2),
        Position = UDim2.new(-0.5, 0, -0.5, 0),
        BackgroundTransparency = 1
    }):Play()
    
    game:GetService("Debris"):AddItem(ripple, 0.5)
end

local function tween(obj, props, duration, style, direction)
    TweenService:Create(obj, TweenInfo.new(duration or 0.2, Enum.EasingStyle[style or "Sine"], Enum.EasingDirection[direction or "Out"]), props):Play()
end

-- Main library function
function library.new(title)
    -- Create main UI container
    local ui = Instance.new("ScreenGui")
    ui.Name = "DynamicUILibrary"
    ui.ResetOnSpawn = false
    if syn and syn.protect_gui then
        syn.protect_gui(ui)
    end
    ui.Parent = game:GetService("CoreGui")

    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = config.BgColor
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = ui

    -- Animated border
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Size = UDim2.new(1, config.BorderThickness * 2, 1, config.BorderThickness * 2)
    border.Position = UDim2.new(0, -config.BorderThickness, 0, -config.BorderThickness)
    border.BackgroundTransparency = 1
    border.Parent = mainFrame

    local borderGradient = Instance.new("UIGradient")
    borderGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
    })
    borderGradient.Rotation = 45
    borderGradient.Parent = border

    -- Animate border gradient
    spawn(function()
        while ui.Parent do
            borderGradient.Offset = Vector2.new(0, 0)
            tween(borderGradient, {Offset = Vector2.new(1, 1)}, config.BorderAnimationSpeed, "Linear")
            wait(config.BorderAnimationSpeed)
        end
    end)

    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame

    -- Background particles
    local particles = Instance.new("Frame")
    particles.Name = "Particles"
    particles.Size = UDim2.new(1, 0, 1, 0)
    particles.BackgroundTransparency = 1
    particles.Parent = mainFrame

    for i = 1, config.ParticleCount do
        local particle = Instance.new("Frame")
        particle.Name = "Particle_"..i
        particle.Size = UDim2.new(0, math.random(4, 8), 0, math.random(4, 8))
        particle.BackgroundColor3 = Color3.fromHSV(math.random(), 0.5, 1)
        particle.BackgroundTransparency = 0.7
        particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
        particle.Parent = particles
        
        local particleCorner = Instance.new("UICorner")
        particleCorner.CornerRadius = UDim.new(1, 0)
        particleCorner.Parent = particle
        
        spawn(function()
            while particle.Parent do
                local xPos = math.sin(tick() * config.ParticleSpeed + i) * 0.4 + 0.5
                local yPos = (tick() * config.ParticleSpeed * 0.5 + i * 0.1) % 1.2 - 0.1
                particle.Position = UDim2.new(xPos, 0, yPos, 0)
                particle.Rotation = tick() * 20 % 360
                wait(0.03)
            end
        end)
    end

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = config.MainColor
    titleBar.BackgroundTransparency = 0.2
    titleBar.Parent = mainFrame

    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(0, 200, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title or "UI Library"
    titleText.TextColor3 = config.TextColor
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 18
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar

    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0.5, -15)
    closeButton.AnchorPoint = Vector2.new(1, 0.5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.BackgroundTransparency = 0.5
    closeButton.Text = "X"
    closeButton.TextColor3 = config.TextColor
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    closeButton.Parent = titleBar

    closeButton.MouseEnter:Connect(function()
        tween(closeButton, {BackgroundTransparency = 0})
    end)
    
    closeButton.MouseLeave:Connect(function()
        tween(closeButton, {BackgroundTransparency = 0.5})
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        ui:Destroy()
    end)

    -- Tab system
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 120, 1, -40)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame

    local tabContent = Instance.new("Frame")
    tabContent.Name = "TabContent"
    tabContent.Size = UDim2.new(1, -120, 1, -40)
    tabContent.Position = UDim2.new(0, 120, 0, 40)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.Parent = mainFrame

    -- Make draggable
    local dragging
    local dragInput
    local dragStart
    local startPos

    titleBar.InputBegan:Connect(function(input)
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

    titleBar.InputChanged:Connect(function(input)
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

    -- Toggle UI keybind
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightControl then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    -- Window object
    local window = {}
    window.currentTab = nil
    window.tabs = {}

    function window:Tab(name, icon)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "TabButton_"..name
        tabButton.Size = UDim2.new(1, -10, 0, 40)
        tabButton.Position = UDim2.new(0, 5, 0, #window.tabs * 45)
        tabButton.BackgroundColor3 = config.TabColor
        tabButton.BackgroundTransparency = 0.5
        tabButton.Text = ""
        tabButton.AutoButtonColor = false
        tabButton.Parent = tabContainer

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tabButton

        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.Size = UDim2.new(0, 24, 0, 24)
        tabIcon.Position = UDim2.new(0, 10, 0.5, -12)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Image = icon or "rbxassetid://3926305904"
        tabIcon.ImageColor3 = config.TextColor
        tabIcon.ImageTransparency = 0.5
        tabIcon.Parent = tabButton

        local tabText = Instance.new("TextLabel")
        tabText.Name = "Text"
        tabText.Size = UDim2.new(1, -40, 1, 0)
        tabText.Position = UDim2.new(0, 40, 0, 0)
        tabText.BackgroundTransparency = 1
        tabText.Text = name
        tabText.TextColor3 = config.TextColor
        tabText.Font = Enum.Font.Gotham
        tabText.TextSize = 14
        tabText.TextXAlignment = Enum.TextXAlignment.Left
        tabText.TextTransparency = 0.5
        tabText.Parent = tabButton

        -- Tab content frame
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Name = "TabFrame_"..name
        tabFrame.Size = UDim2.new(1, 0, 1, -50)
        tabFrame.Position = UDim2.new(0, 0, 0, 50)
        tabFrame.BackgroundTransparency = 1
        tabFrame.ScrollBarThickness = 4
        tabFrame.Visible = false
        tabFrame.Parent = tabContent

        local tabLayout = Instance.new("UIListLayout")
        tabLayout.Name = "Layout"
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 5)
        tabLayout.Parent = tabFrame

        -- Search box for this tab
        local searchBox = Instance.new("TextBox")
        searchBox.Name = "SearchBox"
        searchBox.Size = UDim2.new(1, -20, 0, 30)
        searchBox.Position = UDim2.new(0, 10, 0, 10)
        searchBox.BackgroundColor3 = config.TabColor
        searchBox.BackgroundTransparency = 0.5
        searchBox.Text = ""
        searchBox.PlaceholderText = "Search "..name.."..."
        searchBox.PlaceholderColor3 = config.PlaceholderColor
        searchBox.TextColor3 = config.TextColor
        searchBox.Font = Enum.Font.Gotham
        searchBox.TextSize = 14
        searchBox.ClearTextOnFocus = false
        searchBox.Parent = tabContent

        local searchCorner = Instance.new("UICorner")
        searchCorner.CornerRadius = UDim.new(0, 6)
        searchCorner.Parent = searchBox

        local searchIcon = Instance.new("ImageLabel")
        searchIcon.Name = "SearchIcon"
        searchIcon.Size = UDim2.new(0, 20, 0, 20)
        searchIcon.Position = UDim2.new(1, -30, 0.5, -10)
        searchIcon.BackgroundTransparency = 1
        searchIcon.Image = "rbxassetid://3926305904"
        searchIcon.ImageColor3 = config.TextColor
        searchIcon.ImageTransparency = 0.5
        searchIcon.Parent = searchBox

        -- Function to filter elements based on search
        local function filterElements(searchText)
            for _, element in pairs(tabFrame:GetChildren()) do
                if element:IsA("Frame") and element.Name:match("Section_") then
                    local visible = false
                    
                    -- Check section title
                    if element:FindFirstChild("Title") and element.Title.Text:lower():find(searchText:lower()) then
                        visible = true
                    end
                    
                    -- Check elements within section
                    for _, child in pairs(element:GetChildren()) do
                        if child:IsA("TextButton") or child:IsA("TextLabel") then
                            if child.Text and child.Text:lower():find(searchText:lower()) then
                                visible = true
                            end
                        end
                    end
                    
                    element.Visible = visible or searchText == ""
                end
            end
        end

        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            filterElements(searchBox.Text)
        end)

        -- Tab switching logic
        tabButton.MouseButton1Click:Connect(function()
            if window.currentTab == tabFrame then return end
            
            -- Fade out current tab
            if window.currentTab then
                window.currentTab.Visible = false
                local currentButton = tabContainer:FindFirstChild("TabButton_"..window.currentTab.Name:match("TabFrame_(.+)"))
                if currentButton then
                    tween(currentButton, {BackgroundTransparency = 0.5})
                    tween(currentButton.Icon, {ImageTransparency = 0.5})
                    tween(currentButton.Text, {TextTransparency = 0.5})
                end
            end
            
            -- Fade in new tab
            window.currentTab = tabFrame
            tabFrame.Visible = true
            tween(tabButton, {BackgroundTransparency = 0})
            tween(tabIcon, {ImageTransparency = 0})
            tween(tabText, {TextTransparency = 0})
            
            -- Reset search when switching tabs
            searchBox.Text = ""
        end)

        -- Add ripple effect
        tabButton.MouseButton1Down:Connect(function()
            createRipple(tabButton)
        end)

        -- Add to tabs list
        table.insert(window.tabs, {button = tabButton, frame = tabFrame})
        
        -- Select first tab by default
        if #window.tabs == 1 then
            tabButton.BackgroundTransparency = 0
            tabIcon.ImageTransparency = 0
            tabText.TextTransparency = 0
            tabFrame.Visible = true
            window.currentTab = tabFrame
        end

        -- Tab object
        local tab = {}
        
        function tab:Section(title)
            local section = Instance.new("Frame")
            section.Name = "Section_"..title
            section.Size = UDim2.new(1, -20, 0, 0) -- Height will be adjusted
            section.Position = UDim2.new(0, 10, 0, 0)
            section.BackgroundColor3 = config.TabColor
            section.BackgroundTransparency = 0.5
            section.ClipsDescendants = true
            section.Parent = tabFrame

            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 6)
            sectionCorner.Parent = section

            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "Title"
            sectionTitle.Size = UDim2.new(1, 0, 0, 40)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = title
            sectionTitle.TextColor3 = config.TextColor
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.TextSize = 16
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.Parent = section

            local sectionPadding = Instance.new("UIPadding")
            sectionPadding.PaddingLeft = UDim.new(0, 15)
            sectionPadding.Parent = sectionTitle

            local sectionContent = Instance.new("Frame")
            sectionContent.Name = "Content"
            sectionContent.Size = UDim2.new(1, 0, 0, 0) -- Height will be adjusted
            sectionContent.Position = UDim2.new(0, 0, 0, 40)
            sectionContent.BackgroundTransparency = 1
            sectionContent.Parent = section

            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.Name = "Layout"
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionLayout.Padding = UDim.new(0, 5)
            sectionLayout.Parent = sectionContent

            -- Update section size when content changes
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sectionContent.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y)
                section.Size = UDim2.new(1, -20, 0, sectionLayout.AbsoluteContentSize.Y + 40)
            end)

            -- Section object
            local sectionObj = {}

            function sectionObj:Button(text, callback)
                local button = Instance.new("TextButton")
                button.Name = "Button_"..text
                button.Size = UDim2.new(1, 0, 0, 40)
                button.BackgroundColor3 = config.ButtonColor
                button.BackgroundTransparency = 0.5
                button.Text = text
                button.TextColor3 = config.TextColor
                button.Font = Enum.Font.Gotham
                button.TextSize = 14
                button.AutoButtonColor = false
                button.Parent = sectionContent

                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 4)
                buttonCorner.Parent = button

                button.MouseButton1Click:Connect(function()
                    createRipple(button)
                    if callback then callback() end
                end)

                return button
            end

            function sectionObj:Toggle(text, default, callback)
                local toggle = Instance.new("TextButton")
                toggle.Name = "Toggle_"..text
                toggle.Size = UDim2.new(1, 0, 0, 40)
                toggle.BackgroundColor3 = config.ButtonColor
                toggle.BackgroundTransparency = 0.5
                toggle.Text = "   "..text
                toggle.TextColor3 = config.TextColor
                toggle.Font = Enum.Font.Gotham
                toggle.TextSize = 14
                toggle.TextXAlignment = Enum.TextXAlignment.Left
                toggle.AutoButtonColor = false
                toggle.Parent = sectionContent

                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 4)
                toggleCorner.Parent = toggle

                local toggleState = Instance.new("Frame")
                toggleState.Name = "State"
                toggleState.Size = UDim2.new(0, 20, 0, 20)
                toggleState.Position = UDim2.new(1, -30, 0.5, -10)
                toggleState.BackgroundColor3 = default and config.ToggleOnColor or config.ToggleOffColor
                toggleState.Parent = toggle

                local toggleCorner2 = Instance.new("UICorner")
                toggleCorner2.CornerRadius = UDim.new(0, 4)
                toggleCorner2.Parent = toggleState

                local state = default or false

                toggle.MouseButton1Click:Connect(function()
                    createRipple(toggle)
                    state = not state
                    tween(toggleState, {BackgroundColor3 = state and config.ToggleOnColor or config.ToggleOffColor})
                    if callback then callback(state) end
                end)

                return {
                    SetState = function(newState)
                        state = newState
                        toggleState.BackgroundColor3 = state and config.ToggleOnColor or config.ToggleOffColor
                    end,
                    GetState = function() return state end
                }
            end

            function sectionObj:Slider(text, min, max, default, callback)
                local slider = Instance.new("Frame")
                slider.Name = "Slider_"..text
                slider.Size = UDim2.new(1, 0, 0, 60)
                slider.BackgroundTransparency = 1
                slider.Parent = sectionContent

                local sliderText = Instance.new("TextLabel")
                sliderText.Name = "Text"
                sliderText.Size = UDim2.new(1, 0, 0, 20)
                sliderText.BackgroundTransparency = 1
                sliderText.Text = text
                sliderText.TextColor3 = config.TextColor
                sliderText.Font = Enum.Font.Gotham
                sliderText.TextSize = 14
                sliderText.TextXAlignment = Enum.TextXAlignment.Left
                sliderText.Parent = slider

                local sliderBar = Instance.new("Frame")
                sliderBar.Name = "Bar"
                sliderBar.Size = UDim2.new(1, 0, 0, 10)
                sliderBar.Position = UDim2.new(0, 0, 0, 30)
                sliderBar.BackgroundColor3 = config.TabColor
                sliderBar.BackgroundTransparency = 0.7
                sliderBar.Parent = slider

                local sliderBarCorner = Instance.new("UICorner")
                sliderBarCorner.CornerRadius = UDim.new(1, 0)
                sliderBarCorner.Parent = sliderBar

                local sliderFill = Instance.new("Frame")
                sliderFill.Name = "Fill"
                sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
                sliderFill.BackgroundColor3 = config.SliderBarColor
                sliderFill.Parent = sliderBar

                local sliderFillCorner = Instance.new("UICorner")
                sliderFillCorner.CornerRadius = UDim.new(1, 0)
                sliderFillCorner.Parent = sliderFill

                local sliderValue = Instance.new("TextLabel")
                sliderValue.Name = "Value"
                sliderValue.Size = UDim2.new(0, 60, 0, 20)
                sliderValue.Position = UDim2.new(1, -60, 0, 0)
                sliderValue.BackgroundTransparency = 1
                sliderValue.Text = tostring(default or min)
                sliderValue.TextColor3 = config.TextColor
                sliderValue.Font = Enum.Font.Gotham
                sliderValue.TextSize = 14
                sliderValue.TextXAlignment = Enum.TextXAlignment.Right
                sliderValue.Parent = sliderText

                local value = math.clamp(default or min, min, max)
                local dragging = false

                local function updateValue(newValue)
                    value = math.clamp(newValue, min, max)
                    local percent = (value - min) / (max - min)
                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    sliderValue.Text = tostring(math.floor(value))
                    if callback then callback(value) end
                end

                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local percent = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                        updateValue(min + (max - min) * percent)
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
                        updateValue(min + (max - min) * percent)
                    end
                end)

                updateValue(value)

                return {
                    SetValue = updateValue,
                    GetValue = function() return value end
                }
            end

            -- Add more element types here (Dropdown, Keybind, etc.)

            return sectionObj
        end

        return tab
    end

    return window
end

return library