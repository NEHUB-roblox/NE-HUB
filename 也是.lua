local library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Modern color scheme with cyberpunk/tech aesthetic
local colors = {
    primary = Color3.fromRGB(20, 20, 30),
    secondary = Color3.fromRGB(30, 30, 45),
    accent = Color3.fromRGB(0, 255, 255),
    accent2 = Color3.fromRGB(255, 0, 255),
    text = Color3.fromRGB(240, 240, 240),
    darkText = Color3.fromRGB(50, 50, 70),
    slider = Color3.fromRGB(0, 200, 200),
    toggleOn = Color3.fromRGB(0, 255, 200),
    toggleOff = Color3.fromRGB(70, 70, 90),
    button = Color3.fromRGB(40, 40, 60),
    buttonHover = Color3.fromRGB(60, 60, 80),
    dropdown = Color3.fromRGB(35, 35, 50),
    dropdownHover = Color3.fromRGB(50, 50, 70),
    section = Color3.fromRGB(30, 30, 45, 0.8),
    background = Color3.fromRGB(15, 15, 25, 0.9),
    border = Color3.fromRGB(0, 200, 255)
}

-- Animation presets
local tweenInfo = {
    fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    medium = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    slow = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    elastic = TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
}

-- Utility functions
local function createRipple(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = colors.accent
    ripple.BackgroundTransparency = 0.7
    ripple.ZIndex = 10
    ripple.Size = UDim2.new(0, 10, 0, 10)
    ripple.Position = UDim2.new(
        (Mouse.X - button.AbsolutePosition.X) / button.AbsoluteSize.X,
        0,
        (Mouse.Y - button.AbsolutePosition.Y) / button.AbsoluteSize.Y,
        0
    )
    ripple.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    TweenService:Create(ripple, tweenInfo.fast, {
        Size = UDim2.new(2, 0, 2, 0),
        Position = UDim2.new(-0.5, 0, -0.5, 0),
        BackgroundTransparency = 1
    }):Play()
    
    game.Debris:AddItem(ripple, 0.5)
end

local function createGlow(frame)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = colors.accent
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(24, 24, 24, 24)
    glow.BackgroundTransparency = 1
    glow.Size = UDim2.new(1, 12, 1, 12)
    glow.Position = UDim2.new(0, -6, 0, -6)
    glow.ZIndex = -1
    glow.Parent = frame
    
    TweenService:Create(glow, tweenInfo.medium, {
        ImageTransparency = 0.7
    }):Play()
    
    return glow
end

-- Main UI creation
function library.new(title)
    local ui = {}
    local flags = {}
    local currentTab = nil
    local minimized = false
    local hidden = false
    
    -- Main container
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TechUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
    end
    screenGui.Parent = game:GetService("CoreGui")
    
    -- Main frame that slides in/out
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = colors.background
    mainFrame.BorderSizePixel = 0
    mainFrame.Size = UDim2.new(0.85, 0, 1, 0)
    mainFrame.Position = UDim2.new(1, 0, 0, 0)
    mainFrame.AnchorPoint = Vector2.new(1, 0)
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    local mainBorder = Instance.new("UIStroke")
    mainBorder.Color = colors.border
    mainBorder.Thickness = 2
    mainBorder.Parent = mainFrame
    
    -- Minimize button (triangle on the right)
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Size = UDim2.new(0, 40, 0, 80)
    minimizeBtn.Position = UDim2.new(1, 0, 0.5, -40)
    minimizeBtn.AnchorPoint = Vector2.new(1, 0.5)
    minimizeBtn.Text = "◀"
    minimizeBtn.TextColor3 = colors.accent
    minimizeBtn.TextSize = 24
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.ZIndex = 10
    minimizeBtn.Parent = screenGui
    
    -- Header with title and search
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundColor3 = colors.primary
    header.BorderSizePixel = 0
    header.Size = UDim2.new(1, 0, 0, 60)
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = title or "Tech UI"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 24
    titleLabel.TextColor3 = colors.accent
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
    titleLabel.Size = UDim2.new(0.4, 0, 1, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    -- Search box
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.PlaceholderText = "Search features..."
    searchBox.Text = ""
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 14
    searchBox.TextColor3 = colors.text
    searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    searchBox.BackgroundColor3 = colors.secondary
    searchBox.BorderSizePixel = 0
    searchBox.Position = UDim2.new(0.5, 0, 0.2, 0)
    searchBox.Size = UDim2.new(0.45, 0, 0.6, 0)
    searchBox.Parent = header
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchBox
    
    local searchPadding = Instance.new("UIPadding")
    searchPadding.PaddingLeft = UDim.new(0, 10)
    searchPadding.Parent = searchBox
    
    -- Tab buttons container
    local tabButtons = Instance.new("ScrollingFrame")
    tabButtons.Name = "TabButtons"
    tabButtons.BackgroundTransparency = 1
    tabButtons.BorderSizePixel = 0
    tabButtons.Size = UDim2.new(0.25, 0, 1, -60)
    tabButtons.Position = UDim2.new(0, 0, 0, 60)
    tabButtons.ScrollBarThickness = 4
    tabButtons.ScrollBarImageColor3 = colors.accent
    tabButtons.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabButtons.Parent = mainFrame
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Name = "TabListLayout"
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Parent = tabButtons
    
    -- Tab content container
    local tabContent = Instance.new("Frame")
    tabContent.Name = "TabContent"
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.Size = UDim2.new(0.75, -20, 1, -80)
    tabContent.Position = UDim2.new(0.25, 20, 0, 60)
    tabContent.Parent = mainFrame
    
    local tabContentScroller = Instance.new("ScrollingFrame")
    tabContentScroller.Name = "TabContentScroller"
    tabContentScroller.BackgroundTransparency = 1
    tabContentScroller.BorderSizePixel = 0
    tabContentScroller.Size = UDim2.new(1, 0, 1, 0)
    tabContentScroller.ScrollBarThickness = 4
    tabContentScroller.ScrollBarImageColor3 = colors.accent
    tabContentScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContentScroller.Parent = tabContent
    
    local contentListLayout = Instance.new("UIListLayout")
    contentListLayout.Name = "ContentListLayout"
    contentListLayout.Padding = UDim.new(0, 10)
    contentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentListLayout.Parent = tabContentScroller
    
    -- Animation for showing/hiding UI
    local function toggleUI()
        hidden = not hidden
        if hidden then
            TweenService:Create(mainFrame, tweenInfo.elastic, {
                Position = UDim2.new(1, 0, 0, 0)
            }):Play()
            TweenService:Create(minimizeBtn, tweenInfo.elastic, {
                Position = UDim2.new(1, 20, 0.5, -40),
                Text = "▶"
            }):Play()
        else
            TweenService:Create(mainFrame, tweenInfo.elastic, {
                Position = UDim2.new(0.15, 0, 0, 0)
            }):Play()
            TweenService:Create(minimizeBtn, tweenInfo.elastic, {
                Position = UDim2.new(1, 0, 0.5, -40),
                Text = "◀"
            }):Play()
        end
    end
    
    minimizeBtn.MouseButton1Click:Connect(toggleUI)
    
    -- Initialize UI position
    task.spawn(function()
        wait(0.5)
        TweenService:Create(mainFrame, tweenInfo.elastic, {
            Position = UDim2.new(0.15, 0, 0, 0)
        }):Play()
    end)
    
    -- Tab switching function
    local function switchTab(newTab)
        if currentTab then
            TweenService:Create(currentTab.button, tweenInfo.fast, {
                BackgroundColor3 = colors.secondary,
                TextColor3 = colors.text
            }):Play()
            currentTab.content.Visible = false
        end
        
        currentTab = newTab
        TweenService:Create(newTab.button, tweenInfo.fast, {
            BackgroundColor3 = colors.accent,
            TextColor3 = colors.darkText
        }):Play()
        newTab.content.Visible = true
    end
    
    -- Search functionality
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = string.lower(searchBox.Text)
        
        for _, tab in pairs(ui.tabs) do
            for _, section in pairs(tab.sections) do
                local sectionVisible = false
                
                for _, element in pairs(section.elements) do
                    if element:IsA("TextLabel") or element:IsA("TextButton") then
                        local elementText = string.lower(element.Text)
                        if string.find(elementText, searchText) then
                            element.Visible = true
                            sectionVisible = true
                        else
                            element.Visible = false
                        end
                    end
                end
                
                section.frame.Visible = sectionVisible
            end
        end
    end)
    
    -- Tab creation function
    function ui:CreateTab(name, icon)
        local tab = {}
        tab.sections = {}
        
        -- Tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "TabButton"
        tabButton.Text = "   " .. name
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 16
        tabButton.TextColor3 = colors.text
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.BackgroundColor3 = colors.secondary
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(0.9, 0, 0, 40)
        tabButton.Position = UDim2.new(0.05, 0, 0, 0)
        tabButton.AutoButtonColor = false
        tabButton.Parent = tabButtons
        
        local tabButtonCorner = Instance.new("UICorner")
        tabButtonCorner.CornerRadius = UDim.new(0, 8)
        tabButtonCorner.Parent = tabButton
        
        if icon then
            local tabIcon = Instance.new("ImageLabel")
            tabIcon.Name = "Icon"
            tabIcon.Image = "rbxassetid://" .. tostring(icon)
            tabIcon.Size = UDim2.new(0, 20, 0, 20)
            tabIcon.Position = UDim2.new(0, 10, 0.5, -10)
            tabIcon.BackgroundTransparency = 1
            tabIcon.Parent = tabButton
        end
        
        -- Tab content frame
        local tabContentFrame = Instance.new("ScrollingFrame")
        tabContentFrame.Name = name .. "Content"
        tabContentFrame.BackgroundTransparency = 1
        tabContentFrame.BorderSizePixel = 0
        tabContentFrame.Size = UDim2.new(1, 0, 1, 0)
        tabContentFrame.ScrollBarThickness = 4
        tabContentFrame.ScrollBarImageColor3 = colors.accent
        tabContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContentFrame.Visible = false
        tabContentFrame.Parent = tabContentScroller
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Name = "ContentLayout"
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContentFrame
        
        tab.button = tabButton
        tab.content = tabContentFrame
        
        tabButton.MouseButton1Click:Connect(function()
            createRipple(tabButton)
            switchTab(tab)
        end)
        
        -- Section creation function
        function tab:CreateSection(name)
            local section = {}
            section.elements = {}
            
            -- Section frame
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = name .. "Section"
            sectionFrame.BackgroundColor3 = colors.section
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Size = UDim2.new(1, -10, 0, 0)
            sectionFrame.Parent = tabContentFrame
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 8)
            sectionCorner.Parent = sectionFrame
            
            local sectionStroke = Instance.new("UIStroke")
            sectionStroke.Color = colors.border
            sectionStroke.Thickness = 1
            sectionStroke.Parent = sectionFrame
            
            -- Section header
            local sectionHeader = Instance.new("TextButton")
            sectionHeader.Name = "Header"
            sectionHeader.Text = name
            sectionHeader.Font = Enum.Font.GothamBold
            sectionHeader.TextSize = 18
            sectionHeader.TextColor3 = colors.accent
            sectionHeader.TextXAlignment = Enum.TextXAlignment.Left
            sectionHeader.BackgroundColor3 = Color3.new(0, 0, 0)
            sectionHeader.BackgroundTransparency = 0.8
            sectionHeader.BorderSizePixel = 0
            sectionHeader.Size = UDim2.new(1, 0, 0, 40)
            sectionHeader.AutoButtonColor = false
            sectionHeader.Parent = sectionFrame
            
            local headerPadding = Instance.new("UIPadding")
            headerPadding.PaddingLeft = UDim.new(0, 15)
            headerPadding.Parent = sectionHeader
            
            -- Section content
            local sectionContent = Instance.new("Frame")
            sectionContent.Name = "Content"
            sectionContent.BackgroundTransparency = 1
            sectionContent.BorderSizePixel = 0
            sectionContent.Position = UDim2.new(0, 0, 0, 40)
            sectionContent.Size = UDim2.new(1, 0, 0, 0)
            sectionContent.Parent = sectionFrame
            
            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.Name = "SectionLayout"
            sectionLayout.Padding = UDim.new(0, 5)
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionLayout.Parent = sectionContent
            
            section.frame = sectionFrame
            section.content = sectionContent
            
            -- Update section size when content changes
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sectionContent.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y)
                sectionFrame.Size = UDim2.new(1, -10, 0, sectionLayout.AbsoluteContentSize.Y + 40)
            end)
            
            -- Button element
            function section:AddButton(text, callback)
                local button = Instance.new("TextButton")
                button.Name = text .. "Button"
                button.Text = text
                button.Font = Enum.Font.Gotham
                button.TextSize = 14
                button.TextColor3 = colors.text
                button.BackgroundColor3 = colors.button
                button.BorderSizePixel = 0
                button.Size = UDim2.new(1, -10, 0, 35)
                button.Position = UDim2.new(0, 5, 0, 0)
                button.AutoButtonColor = false
                button.Parent = sectionContent
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 6)
                buttonCorner.Parent = button
                
                local buttonStroke = Instance.new("UIStroke")
                buttonStroke.Color = colors.border
                buttonStroke.Thickness = 1
                buttonStroke.Parent = button
                
                -- Hover effect
                button.MouseEnter:Connect(function()
                    TweenService:Create(button, tweenInfo.fast, {
                        BackgroundColor3 = colors.buttonHover
                    }):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    TweenService:Create(button, tweenInfo.fast, {
                        BackgroundColor3 = colors.button
                    }):Play()
                end)
                
                button.MouseButton1Click:Connect(function()
                    createRipple(button)
                    callback()
                end)
                
                table.insert(section.elements, button)
                return button
            end
            
            -- Toggle element
            function section:AddToggle(text, flag, default, callback)
                flags[flag] = default or false
                
                local toggle = Instance.new("TextButton")
                toggle.Name = text .. "Toggle"
                toggle.Text = "   " .. text
                toggle.Font = Enum.Font.Gotham
                toggle.TextSize = 14
                toggle.TextColor3 = colors.text
                toggle.BackgroundColor3 = colors.button
                toggle.BorderSizePixel = 0
                toggle.Size = UDim2.new(1, -10, 0, 35)
                toggle.Position = UDim2.new(0, 5, 0, 0)
                toggle.AutoButtonColor = false
                toggle.Parent = sectionContent
                
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 6)
                toggleCorner.Parent = toggle
                
                local toggleStroke = Instance.new("UIStroke")
                toggleStroke.Color = colors.border
                toggleStroke.Thickness = 1
                toggleStroke.Parent = toggle
                
                local toggleIndicator = Instance.new("Frame")
                toggleIndicator.Name = "Indicator"
                toggleIndicator.BackgroundColor3 = default and colors.toggleOn or colors.toggleOff
                toggleIndicator.BorderSizePixel = 0
                toggleIndicator.Size = UDim2.new(0, 20, 0, 20)
                toggleIndicator.Position = UDim2.new(1, -30, 0.5, -10)
                toggleIndicator.AnchorPoint = Vector2.new(1, 0.5)
                toggleIndicator.Parent = toggle
                
                local indicatorCorner = Instance.new("UICorner")
                indicatorCorner.CornerRadius = UDim.new(0.5, 0)
                indicatorCorner.Parent = toggleIndicator
                
                local function setState(state)
                    flags[flag] = state
                    TweenService:Create(toggleIndicator, tweenInfo.fast, {
                        BackgroundColor3 = state and colors.toggleOn or colors.toggleOff
                    }):Play()
                    callback(state)
                end
                
                toggle.MouseButton1Click:Connect(function()
                    createRipple(toggle)
                    setState(not flags[flag])
                end)
                
                table.insert(section.elements, toggle)
                return {
                    SetState = setState
                }
            end
            
            -- Slider element
            function section:AddSlider(text, flag, min, max, default, callback)
                flags[flag] = default or min
                
                local slider = Instance.new("Frame")
                slider.Name = text .. "Slider"
                slider.BackgroundColor3 = colors.button
                slider.BorderSizePixel = 0
                slider.Size = UDim2.new(1, -10, 0, 60)
                slider.Position = UDim2.new(0, 5, 0, 0)
                slider.Parent = sectionContent
                
                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 6)
                sliderCorner.Parent = slider
                
                local sliderStroke = Instance.new("UIStroke")
                sliderStroke.Color = colors.border
                sliderStroke.Thickness = 1
                sliderStroke.Parent = slider
                
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Name = "Label"
                sliderLabel.Text = text .. ": " .. tostring(default)
                sliderLabel.Font = Enum.Font.Gotham
                sliderLabel.TextSize = 14
                sliderLabel.TextColor3 = colors.text
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Size = UDim2.new(1, -20, 0, 20)
                sliderLabel.Position = UDim2.new(0, 10, 0, 5)
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                sliderLabel.Parent = slider
                
                local sliderBar = Instance.new("Frame")
                sliderBar.Name = "Bar"
                sliderBar.BackgroundColor3 = colors.secondary
                sliderBar.BorderSizePixel = 0
                sliderBar.Size = UDim2.new(1, -20, 0, 5)
                sliderBar.Position = UDim2.new(0, 10, 0, 35)
                sliderBar.Parent = slider
                
                local barCorner = Instance.new("UICorner")
                barCorner.CornerRadius = UDim.new(0.5, 0)
                barCorner.Parent = sliderBar
                
                local sliderFill = Instance.new("Frame")
                sliderFill.Name = "Fill"
                sliderFill.BackgroundColor3 = colors.slider
                sliderFill.BorderSizePixel = 0
                sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                sliderFill.Parent = sliderBar
                
                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(0.5, 0)
                fillCorner.Parent = sliderFill
                
                local sliderButton = Instance.new("TextButton")
                sliderButton.Name = "Button"
                sliderButton.Text = ""
                sliderButton.BackgroundColor3 = colors.accent
                sliderButton.BorderSizePixel = 0
                sliderButton.Size = UDim2.new(0, 15, 0, 15)
                sliderButton.Position = UDim2.new((default - min) / (max - min), -7.5, 0.5, -7.5)
                sliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
                sliderButton.AutoButtonColor = false
                sliderButton.Parent = sliderBar
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0.5, 0)
                buttonCorner.Parent = sliderButton
                
                local dragging = false
                
                local function setValue(value)
                    value = math.clamp(value, min, max)
                    flags[flag] = value
                    local percent = (value - min) / (max - min)
                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    sliderButton.Position = UDim2.new(percent, -7.5, 0.5, -7.5)
                    sliderLabel.Text = text .. ": " .. tostring(math.floor(value))
                    callback(value)
                end
                
                sliderButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                
                sliderButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local percent = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                        setValue(min + (max - min) * percent)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                        setValue(min + (max - min) * percent)
                    end
                end)
                
                table.insert(section.elements, slider)
                return {
                    SetValue = setValue
                }
            end
            
            -- Dropdown element
            function section:AddDropdown(text, flag, options, callback)
                flags[flag] = nil
                
                local dropdown = Instance.new("Frame")
                dropdown.Name = text .. "Dropdown"
                dropdown.BackgroundColor3 = colors.button
                dropdown.BorderSizePixel = 0
                dropdown.Size = UDim2.new(1, -10, 0, 35)
                dropdown.Position = UDim2.new(0, 5, 0, 0)
                dropdown.ClipsDescendants = true
                dropdown.Parent = sectionContent
                
                local dropdownCorner = Instance.new("UICorner")
                dropdownCorner.CornerRadius = UDim.new(0, 6)
                dropdownCorner.Parent = dropdown
                
                local dropdownStroke = Instance.new("UIStroke")
                dropdownStroke.Color = colors.border
                dropdownStroke.Thickness = 1
                dropdownStroke.Parent = dropdown
                
                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Name = "Button"
                dropdownButton.Text = "   " .. text
                dropdownButton.Font = Enum.Font.Gotham
                dropdownButton.TextSize = 14
                dropdownButton.TextColor3 = colors.text
                dropdownButton.BackgroundColor3 = colors.dropdown
                dropdownButton.BorderSizePixel = 0
                dropdownButton.Size = UDim2.new(1, 0, 0, 35)
                dropdownButton.AutoButtonColor = false
                dropdownButton.Parent = dropdown
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 6)
                buttonCorner.Parent = dropdownButton
                
                local dropdownArrow = Instance.new("TextLabel")
                dropdownArrow.Name = "Arrow"
                dropdownArrow.Text = "▼"
                dropdownArrow.Font = Enum.Font.GothamBold
                dropdownArrow.TextSize = 14
                dropdownArrow.TextColor3 = colors.accent
                dropdownArrow.BackgroundTransparency = 1
                dropdownArrow.Size = UDim2.new(0, 20, 0, 20)
                dropdownArrow.Position = UDim2.new(1, -25, 0.5, -10)
                dropdownArrow.AnchorPoint = Vector2.new(1, 0.5)
                dropdownArrow.Parent = dropdownButton
                
                local dropdownContent = Instance.new("Frame")
                dropdownContent.Name = "Content"
                dropdownContent.BackgroundColor3 = colors.dropdown
                dropdownContent.BorderSizePixel = 0
                dropdownContent.Position = UDim2.new(0, 0, 0, 35)
                dropdownContent.Size = UDim2.new(1, 0, 0, 0)
                dropdownContent.Visible = false
                dropdownContent.Parent = dropdown
                
                local contentLayout = Instance.new("UIListLayout")
                contentLayout.Name = "ContentLayout"
                contentLayout.Padding = UDim.new(0, 5)
                contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
                contentLayout.Parent = dropdownContent
                
                local contentPadding = Instance.new("UIPadding")
                contentPadding.PaddingTop = UDim.new(0, 5)
                contentPadding.PaddingBottom = UDim.new(0, 5)
                contentPadding.Parent = dropdownContent
                
                local expanded = false
                
                local function toggleDropdown()
                    expanded = not expanded
                    dropdownContent.Visible = expanded
                    dropdown.Size = UDim2.new(1, -10, 0, expanded and (35 + contentLayout.AbsoluteContentSize.Y + 10) or 35)
                    dropdownArrow.Text = expanded and "▲" or "▼"
                end
                
                dropdownButton.MouseButton1Click:Connect(function()
                    createRipple(dropdownButton)
                    toggleDropdown()
                end)
                
                contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    if expanded then
                        dropdown.Size = UDim2.new(1, -10, 0, 35 + contentLayout.AbsoluteContentSize.Y + 10)
                    end
                end)
                
                local function addOption(option)
                    local optionButton = Instance.new("TextButton")
                    optionButton.Name = option .. "Option"
                    optionButton.Text = "   " .. option
                    optionButton.Font = Enum.Font.Gotham
                    optionButton.TextSize = 14
                    optionButton.TextColor3 = colors.text
                    optionButton.BackgroundColor3 = colors.dropdownHover
                    optionButton.BorderSizePixel = 0
                    optionButton.Size = UDim2.new(1, -10, 0, 30)
                    optionButton.Position = UDim2.new(0, 5, 0, 0)
                    optionButton.AutoButtonColor = false
                    optionButton.Parent = dropdownContent
                    
                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, 4)
                    optionCorner.Parent = optionButton
                    
                    optionButton.MouseButton1Click:Connect(function()
                        createRipple(optionButton)
                        flags[flag] = option
                        dropdownButton.Text = "   " .. text .. ": " .. option
                        callback(option)
                        toggleDropdown()
                    end)
                end
                
                for _, option in pairs(options) do
                    addOption(option)
                end
                
                table.insert(section.elements, dropdown)
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
            
            -- Label element
            function section:AddLabel(text)
                local label = Instance.new("TextLabel")
                label.Name = text .. "Label"
                label.Text = text
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextColor3 = colors.text
                label.BackgroundColor3 = colors.button
                label.BorderSizePixel = 0
                label.Size = UDim2.new(1, -10, 0, 30)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = sectionContent
                
                local labelCorner = Instance.new("UICorner")
                labelCorner.CornerRadius = UDim.new(0, 6)
                labelCorner.Parent = label
                
                local labelStroke = Instance.new("UIStroke")
                labelStroke.Color = colors.border
                labelStroke.Thickness = 1
                labelStroke.Parent = label
                
                local labelPadding = Instance.new("UIPadding")
                labelPadding.PaddingLeft = UDim.new(0, 10)
                labelPadding.Parent = label
                
                table.insert(section.elements, label)
                return label
            end
            
            table.insert(tab.sections, section)
            return section
        end
        
        if not ui.tabs then ui.tabs = {} end
        table.insert(ui.tabs, tab)
        return tab
    end
    
    -- Update tab button layout
    tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabButtons.CanvasSize = UDim2.new(0, 0, 0, tabListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Update content layout
    contentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContentScroller.CanvasSize = UDim2.new(0, 0, 0, contentListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Toggle UI with keybind
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightControl then
            toggleUI()
        end
    end)
    
    return ui
end

return library