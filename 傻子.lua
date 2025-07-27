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

local Players = services.Players
local TweenService = services.TweenService
local UserInputService = services.UserInputService
local RunService = services.RunService

-- Config
local config = {
    MainColor = Color3.fromRGB(20, 20, 30),
    TabColor = Color3.fromRGB(30, 30, 45),
    BgColor = Color3.fromRGB(25, 25, 40),
    AccentColor = Color3.fromRGB(0, 180, 255),
    SecondaryColor = Color3.fromRGB(100, 255, 200),
    
    TextColor = Color3.fromRGB(240, 240, 255),
    DisabledTextColor = Color3.fromRGB(150, 150, 170),
    
    ButtonColor = Color3.fromRGB(40, 40, 60),
    ButtonHoverColor = Color3.fromRGB(50, 50, 75),
    
    ToggleOnColor = Color3.fromRGB(0, 200, 150),
    ToggleOffColor = Color3.fromRGB(60, 60, 80),
    
    SliderColor = Color3.fromRGB(40, 40, 60),
    SliderBarColor = Color3.fromRGB(0, 180, 255),
    
    DropdownColor = Color3.fromRGB(40, 40, 60),
    DropdownHoverColor = Color3.fromRGB(50, 50, 75),
    
    TextboxColor = Color3.fromRGB(40, 40, 60),
    TextboxHoverColor = Color3.fromRGB(50, 50, 75),
    
    BorderSize = 2,
    CornerRadius = 8,
    Transparency = 0.2
}

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
        
        local Ripple = Instance.new("Frame")
        Ripple.Name = "Ripple"
        Ripple.Parent = obj
        Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Ripple.BackgroundTransparency = 0.9
        Ripple.ZIndex = 10
        Ripple.Size = UDim2.new(0, 0, 0, 0)
        Ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        
        local mouse = Players.LocalPlayer:GetMouse()
        local posX = (mouse.X - obj.AbsolutePosition.X) / obj.AbsoluteSize.X
        local posY = (mouse.Y - obj.AbsolutePosition.Y) / obj.AbsoluteSize.Y
        
        Ripple.Position = UDim2.new(posX, 0, posY, 0)
        
        Tween(Ripple, {0.5, "Quad", "Out"}, {
            Size = UDim2.new(2, 0, 2, 0),
            BackgroundTransparency = 1,
            Position = UDim2.new(posX, 0, posY, 0)
        })
        
        wait(0.5)
        Ripple:Destroy()
    end)
end

-- UI Creation
function library.new(name)
    -- Create main UI container
    local ui = Instance.new("ScreenGui")
    ui.Name = "ModernTechUI"
    ui.ResetOnSpawn = false
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    if syn and syn.protect_gui then
        syn.protect_gui(ui)
    end
    ui.Parent = game:GetService("CoreGui")
    
    -- Main container
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.85, 0, 0.95, 0)
    mainFrame.Position = UDim2.new(1, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(1, 0.5)
    mainFrame.BackgroundColor3 = config.MainColor
    mainFrame.BackgroundTransparency = config.Transparency
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = ui
    
    -- Border effect
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    border.BorderColor3 = config.AccentColor
    border.BorderSizePixel = config.BorderSize
    border.ZIndex = 2
    border.Parent = mainFrame
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, config.CornerRadius)
    corner.Parent = mainFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = config.TabColor
    header.BackgroundTransparency = config.Transparency
    header.BorderSizePixel = 0
    header.ZIndex = 3
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, config.CornerRadius)
    headerCorner.Parent = header
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = name
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = config.TextColor
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 4
    title.Parent = header
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Text = ">"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 24
    closeBtn.TextColor3 = config.TextColor
    closeBtn.BackgroundTransparency = 1
    closeBtn.Size = UDim2.new(0, 50, 1, 0)
    closeBtn.Position = UDim2.new(1, -50, 0, 0)
    closeBtn.ZIndex = 4
    closeBtn.Parent = header
    
    -- Tab buttons container
    local tabButtons = Instance.new("Frame")
    tabButtons.Name = "TabButtons"
    tabButtons.Size = UDim2.new(0, 150, 1, -50)
    tabButtons.Position = UDim2.new(0, 0, 0, 50)
    tabButtons.BackgroundTransparency = 1
    tabButtons.BorderSizePixel = 0
    tabButtons.ZIndex = 2
    tabButtons.Parent = mainFrame
    
    local tabList = Instance.new("UIListLayout")
    tabList.Name = "TabList"
    tabList.Padding = UDim.new(0, 5)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabButtons
    
    -- Tab content container
    local tabContent = Instance.new("Frame")
    tabContent.Name = "TabContent"
    tabContent.Size = UDim2.new(1, -170, 1, -60)
    tabContent.Position = UDim2.new(0, 170, 0, 50)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ZIndex = 2
    tabContent.Parent = mainFrame
    
    -- Search box
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(0.5, -20, 0, 30)
    searchBox.Position = UDim2.new(0.5, 10, 0, 10)
    searchBox.BackgroundColor3 = config.TextboxColor
    searchBox.BackgroundTransparency = config.Transparency
    searchBox.TextColor3 = config.TextColor
    searchBox.PlaceholderColor3 = config.DisabledTextColor
    searchBox.PlaceholderText = "Search..."
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 14
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ZIndex = 3
    searchBox.Parent = tabContent
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, config.CornerRadius)
    searchCorner.Parent = searchBox
    
    local searchPadding = Instance.new("UIPadding")
    searchPadding.PaddingLeft = UDim.new(0, 10)
    searchPadding.Parent = searchBox
    
    -- Minimized button (triangle)
    local minimizedBtn = Instance.new("TextButton")
    minimizedBtn.Name = "MinimizedButton"
    minimizedBtn.Text = "<"
    minimizedBtn.Font = Enum.Font.GothamBold
    minimizedBtn.TextSize = 24
    minimizedBtn.TextColor3 = config.TextColor
    minimizedBtn.BackgroundTransparency = 1
    minimizedBtn.Size = UDim2.new(0, 40, 0, 40)
    minimizedBtn.Position = UDim2.new(1, -20, 0.5, -20)
    minimizedBtn.Visible = false
    minimizedBtn.ZIndex = 10
    minimizedBtn.Parent = ui
    
    -- Animation variables
    local isOpen = true
    local isAnimating = false
    
    -- Toggle UI function
    local function toggleUI()
        if isAnimating then return end
        isAnimating = true
        
        if isOpen then
            -- Close animation
            Tween(mainFrame, {0.3, "Quint", "Out"}, {
                Position = UDim2.new(1.15, 0, 0.5, 0)
            })
            
            Tween(minimizedBtn, {0.3, "Quint", "Out"}, {
                Position = UDim2.new(1, -30, 0.5, -20),
                TextTransparency = 0
            })
            
            wait(0.3)
            minimizedBtn.Visible = true
            mainFrame.Visible = false
        else
            -- Open animation
            mainFrame.Visible = true
            minimizedBtn.Visible = false
            
            Tween(mainFrame, {0.3, "Quint", "Out"}, {
                Position = UDim2.new(1, 0, 0.5, 0)
            })
            
            Tween(minimizedBtn, {0.3, "Quint", "Out"}, {
                Position = UDim2.new(1.15, -20, 0.5, -20),
                TextTransparency = 1
            })
        end
        
        isOpen = not isOpen
        isAnimating = false
    end
    
    -- Connect close button
    closeBtn.MouseButton1Click:Connect(toggleUI)
    minimizedBtn.MouseButton1Click:Connect(toggleUI)
    
    -- Initial animation
    spawn(function()
        wait()
        Tween(mainFrame, {0.5, "Quint", "Out"}, {
            Position = UDim2.new(1, 0, 0.5, 0)
        })
    end)
    
    -- Window functions
    local window = {}
    
    function window:Tab(name, icon)
        local tab = {}
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name.."TabButton"
        tabButton.Text = "   "..name
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 16
        tabButton.TextColor3 = config.TextColor
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.BackgroundColor3 = config.TabColor
        tabButton.BackgroundTransparency = config.Transparency
        tabButton.Size = UDim2.new(1, -20, 0, 40)
        tabButton.Position = UDim2.new(0, 10, 0, 0)
        tabButton.AutoButtonColor = false
        tabButton.ZIndex = 3
        tabButton.Parent = tabButtons
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, config.CornerRadius)
        tabCorner.Parent = tabButton
        
        local tabContentFrame = Instance.new("ScrollingFrame")
        tabContentFrame.Name = name.."Content"
        tabContentFrame.Size = UDim2.new(1, 0, 1, -40)
        tabContentFrame.Position = UDim2.new(0, 0, 0, 40)
        tabContentFrame.BackgroundTransparency = 1
        tabContentFrame.BorderSizePixel = 0
        tabContentFrame.ScrollBarThickness = 5
        tabContentFrame.ScrollBarImageColor3 = config.AccentColor
        tabContentFrame.Visible = false
        tabContentFrame.ZIndex = 2
        tabContentFrame.Parent = tabContent
        
        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.Padding = UDim.new(0, 10)
        tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabContentLayout.Parent = tabContentFrame
        
        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if library.currentTab ~= tab then
                Tween(tabButton, {0.2, "Linear", "Out"}, {
                    BackgroundColor3 = Color3.fromRGB(
                        math.floor(config.TabColor.R * 255 + 10),
                        math.floor(config.TabColor.G * 255 + 10),
                        math.floor(config.TabColor.B * 255 + 10)
                    )
                })
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if library.currentTab ~= tab then
                Tween(tabButton, {0.2, "Linear", "Out"}, {
                    BackgroundColor3 = config.TabColor
                })
            end
        end)
        
        -- Tab switching
        tabButton.MouseButton1Click:Connect(function()
            if library.currentTab == tab then return end
            
            -- Deselect current tab
            if library.currentTab then
                Tween(library.currentTab.button, {0.2, "Linear", "Out"}, {
                    BackgroundColor3 = config.TabColor
                })
                library.currentTab.content.Visible = false
            end
            
            -- Select new tab
            library.currentTab = tab
            Tween(tabButton, {0.2, "Linear", "Out"}, {
                BackgroundColor3 = Color3.fromRGB(
                    math.floor(config.TabColor.R * 255 + 20),
                    math.floor(config.TabColor.G * 255 + 20),
                    math.floor(config.TabColor.B * 255 + 20)
                )
            })
            tabContentFrame.Visible = true
            
            -- Update content size
            spawn(function()
                wait()
                tabContentFrame.CanvasSize = UDim2.new(0, 0, 0, tabContentLayout.AbsoluteContentSize.Y + 20)
            end)
        end)
        
        -- Store references
        tab.button = tabButton
        tab.content = tabContentFrame
        
        -- Section function
        function tab:Section(name)
            local section = {}
            
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = name.."Section"
            sectionFrame.Size = UDim2.new(1, -20, 0, 0)
            sectionFrame.BackgroundColor3 = config.TabColor
            sectionFrame.BackgroundTransparency = config.Transparency
            sectionFrame.BorderSizePixel = 0
            sectionFrame.ClipsDescendants = true
            sectionFrame.LayoutOrder = 1
            sectionFrame.ZIndex = 3
            sectionFrame.Parent = tabContentFrame
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, config.CornerRadius)
            sectionCorner.Parent = sectionFrame
            
            local sectionHeader = Instance.new("TextButton")
            sectionHeader.Name = "Header"
            sectionHeader.Text = name
            sectionHeader.Font = Enum.Font.GothamBold
            sectionHeader.TextSize = 16
            sectionHeader.TextColor3 = config.TextColor
            sectionHeader.TextXAlignment = Enum.TextXAlignment.Left
            sectionHeader.BackgroundColor3 = config.TabColor
            sectionHeader.BackgroundTransparency = config.Transparency
            sectionHeader.Size = UDim2.new(1, 0, 0, 40)
            sectionHeader.AutoButtonColor = false
            sectionHeader.ZIndex = 4
            sectionHeader.Parent = sectionFrame
            
            local headerPadding = Instance.new("UIPadding")
            headerPadding.PaddingLeft = UDim.new(0, 15)
            headerPadding.Parent = sectionHeader
            
            local sectionContent = Instance.new("Frame")
            sectionContent.Name = "Content"
            sectionContent.Size = UDim2.new(1, 0, 0, 0)
            sectionContent.Position = UDim2.new(0, 0, 0, 40)
            sectionContent.BackgroundTransparency = 1
            sectionContent.BorderSizePixel = 0
            sectionContent.ZIndex = 3
            sectionContent.Parent = sectionFrame
            
            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Padding = UDim.new(0, 10)
            contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            contentLayout.Parent = sectionContent
            
            local isOpen = true
            
            -- Toggle section
            sectionHeader.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    sectionFrame.Size = UDim2.new(1, -20, 0, 40 + contentLayout.AbsoluteContentSize.Y)
                else
                    sectionFrame.Size = UDim2.new(1, -20, 0, 40)
                end
            end)
            
            -- Update size when content changes
            contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isOpen then
                    sectionFrame.Size = UDim2.new(1, -20, 0, 40 + contentLayout.AbsoluteContentSize.Y)
                    tabContentFrame.CanvasSize = UDim2.new(0, 0, 0, tabContentLayout.AbsoluteContentSize.Y + 20)
                end
            end)
            
            -- Button
            function section:Button(text, callback)
                local button = Instance.new("TextButton")
                button.Name = text.."Button"
                button.Text = text
                button.Font = Enum.Font.Gotham
                button.TextSize = 14
                button.TextColor3 = config.TextColor
                button.BackgroundColor3 = config.ButtonColor
                button.BackgroundTransparency = config.Transparency
                button.Size = UDim2.new(1, 0, 0, 35)
                button.AutoButtonColor = false
                button.ZIndex = 4
                button.LayoutOrder = 1
                button.Parent = sectionContent
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, config.CornerRadius)
                buttonCorner.Parent = button
                
                -- Hover effects
                button.MouseEnter:Connect(function()
                    Tween(button, {0.2, "Linear", "Out"}, {
                        BackgroundColor3 = config.ButtonHoverColor
                    })
                end)
                
                button.MouseLeave:Connect(function()
                    Tween(button, {0.2, "Linear", "Out"}, {
                        BackgroundColor3 = config.ButtonColor
                    })
                end)
                
                -- Click effect
                button.MouseButton1Click:Connect(function()
                    Ripple(button)
                    if callback then callback() end
                end)
            end
            
            -- Toggle
            function section:Toggle(text, flag, default, callback)
                library.flags[flag] = default or false
                
                local toggle = Instance.new("TextButton")
                toggle.Name = text.."Toggle"
                toggle.Text = "   "..text
                toggle.Font = Enum.Font.Gotham
                toggle.TextSize = 14
                toggle.TextColor3 = config.TextColor
                toggle.BackgroundColor3 = config.ButtonColor
                toggle.BackgroundTransparency = config.Transparency
                toggle.Size = UDim2.new(1, 0, 0, 35)
                toggle.AutoButtonColor = false
                toggle.ZIndex = 4
                toggle.LayoutOrder = 1
                toggle.Parent = sectionContent
                
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, config.CornerRadius)
                toggleCorner.Parent = toggle
                
                local toggleIndicator = Instance.new("Frame")
                toggleIndicator.Name = "Indicator"
                toggleIndicator.BackgroundColor3 = default and config.ToggleOnColor or config.ToggleOffColor
                toggleIndicator.Size = UDim2.new(0, 20, 0, 20)
                toggleIndicator.Position = UDim2.new(1, -30, 0.5, -10)
                toggleIndicator.AnchorPoint = Vector2.new(1, 0.5)
                toggleIndicator.ZIndex = 5
                toggleIndicator.Parent = toggle
                
                local indicatorCorner = Instance.new("UICorner")
                indicatorCorner.CornerRadius = UDim.new(0.5, 0)
                indicatorCorner.Parent = toggleIndicator
                
                -- Hover effects
                toggle.MouseEnter:Connect(function()
                    Tween(toggle, {0.2, "Linear", "Out"}, {
                        BackgroundColor3 = config.ButtonHoverColor
                    })
                end)
                
                toggle.MouseLeave:Connect(function()
                    Tween(toggle, {0.2, "Linear", "Out"}, {
                        BackgroundColor3 = config.ButtonColor
                    })
                end)
                
                -- Click effect
                toggle.MouseButton1Click:Connect(function()
                    Ripple(toggle)
                    library.flags[flag] = not library.flags[flag]
                    
                    if library.flags[flag] then
                        Tween(toggleIndicator, {0.2, "Linear", "Out"}, {
                            BackgroundColor3 = config.ToggleOnColor
                        })
                    else
                        Tween(toggleIndicator, {0.2, "Linear", "Out"}, {
                            BackgroundColor3 = config.ToggleOffColor
                        })
                    end
                    
                    if callback then callback(library.flags[flag]) end
                end)
                
                return {
                    SetState = function(self, state)
                        library.flags[flag] = state
                        
                        if state then
                            toggleIndicator.BackgroundColor3 = config.ToggleOnColor
                        else
                            toggleIndicator.BackgroundColor3 = config.ToggleOffColor
                        end
                        
                        if callback then callback(state) end
                    end
                }
            end
            
            -- Slider
            function section:Slider(text, flag, min, max, default, callback)
                library.flags[flag] = default or min
                
                local slider = Instance.new("Frame")
                slider.Name = text.."Slider"
                slider.Size = UDim2.new(1, 0, 0, 60)
                slider.BackgroundTransparency = 1
                slider.LayoutOrder = 1
                slider.ZIndex = 4
                slider.Parent = sectionContent
                
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Name = "Label"
                sliderLabel.Text = text
                sliderLabel.Font = Enum.Font.Gotham
                sliderLabel.TextSize = 14
                sliderLabel.TextColor3 = config.TextColor
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Size = UDim2.new(1, 0, 0, 20)
                sliderLabel.ZIndex = 4
                sliderLabel.Parent = slider
                
                local sliderBar = Instance.new("Frame")
                sliderBar.Name = "Bar"
                sliderBar.Size = UDim2.new(1, 0, 0, 10)
                sliderBar.Position = UDim2.new(0, 0, 0, 25)
                sliderBar.BackgroundColor3 = config.SliderColor
                sliderBar.ZIndex = 4
                sliderBar.Parent = slider
                
                local barCorner = Instance.new("UICorner")
                barCorner.CornerRadius = UDim.new(0.5, 0)
                barCorner.Parent = sliderBar
                
                local sliderFill = Instance.new("Frame")
                sliderFill.Name = "Fill"
                sliderFill.Size = UDim2.new(0, 0, 1, 0)
                sliderFill.BackgroundColor3 = config.SliderBarColor
                sliderFill.ZIndex = 5
                sliderFill.Parent = sliderBar
                
                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(0.5, 0)
                fillCorner.Parent = sliderFill
                
                local sliderValue = Instance.new("TextLabel")
                sliderValue.Name = "Value"
                sliderValue.Text = tostring(default or min)
                sliderValue.Font = Enum.Font.Gotham
                sliderValue.TextSize = 14
                sliderValue.TextColor3 = config.TextColor
                sliderValue.TextXAlignment = Enum.TextXAlignment.Right
                sliderValue.BackgroundTransparency = 1
                sliderValue.Size = UDim2.new(1, 0, 0, 20)
                sliderValue.Position = UDim2.new(0, 0, 0, 35)
                sliderValue.ZIndex = 4
                sliderValue.Parent = slider
                
                -- Calculate initial fill
                local percent = (default - min) / (max - min)
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                
                -- Slider dragging
                local dragging = false
                
                local function updateSlider(input)
                    local pos = UDim2.new(
                        math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1),
                        0, 1, 0
                    )
                    
                    sliderFill.Size = pos
                    local value = math.floor(min + (max - min) * pos.X.Scale)
                    sliderValue.Text = tostring(value)
                    library.flags[flag] = value
                    
                    if callback then callback(value) end
                end
                
                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateSlider(input)
                    end
                end)
                
                sliderBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                return {
                    SetValue = function(self, value)
                        value = math.clamp(value, min, max)
                        local percent = (value - min) / (max - min)
                        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                        sliderValue.Text = tostring(value)
                        library.flags[flag] = value
                        
                        if callback then callback(value) end
                    end
                }
            end
            
            -- Dropdown
            function section:Dropdown(text, flag, options, callback)
                library.flags[flag] = nil
                
                local dropdown = Instance.new("Frame")
                dropdown.Name = text.."Dropdown"
                dropdown.Size = UDim2.new(1, 0, 0, 35)
                dropdown.BackgroundTransparency = 1
                dropdown.ClipsDescendants = true
                dropdown.LayoutOrder = 1
                dropdown.ZIndex = 4
                dropdown.Parent = sectionContent
                
                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Name = "Button"
                dropdownButton.Text = "   "..text
                dropdownButton.Font = Enum.Font.Gotham
                dropdownButton.TextSize = 14
                dropdownButton.TextColor3 = config.TextColor
                dropdownButton.BackgroundColor3 = config.DropdownColor
                dropdownButton.BackgroundTransparency = config.Transparency
                dropdownButton.Size = UDim2.new(1, 0, 0, 35)
                dropdownButton.AutoButtonColor = false
                dropdownButton.ZIndex = 5
                dropdownButton.Parent = dropdown
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, config.CornerRadius)
                buttonCorner.Parent = dropdownButton
                
                local dropdownArrow = Instance.new("ImageLabel")
                dropdownArrow.Name = "Arrow"
                dropdownArrow.Image = "rbxassetid://6031091004"
                dropdownArrow.Size = UDim2.new(0, 20, 0, 20)
                dropdownArrow.Position = UDim2.new(1, -25, 0.5, -10)
                dropdownArrow.AnchorPoint = Vector2.new(1, 0.5)
                dropdownArrow.BackgroundTransparency = 1
                dropdownArrow.ZIndex = 6
                dropdownArrow.Parent = dropdownButton
                
                local dropdownContent = Instance.new("Frame")
                dropdownContent.Name = "Content"
                dropdownContent.Size = UDim2.new(1, 0, 0, 0)
                dropdownContent.Position = UDim2.new(0, 0, 0, 40)
                dropdownContent.BackgroundTransparency = 1
                dropdownContent.ZIndex = 4
                dropdownContent.Parent = dropdown
                
                local contentLayout = Instance.new("UIListLayout")
                contentLayout.Padding = UDim.new(0, 5)
                contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
                contentLayout.Parent = dropdownContent
                
                local isOpen = false
                
                local function toggleDropdown()
                    isOpen = not isOpen
                    
                    if isOpen then
                        dropdown.Size = UDim2.new(1, 0, 0, 35 + dropdownContent.AbsoluteSize.Y + 5)
                        Tween(dropdownArrow, {0.2, "Linear", "Out"}, {Rotation = 180})
                    else
                        dropdown.Size = UDim2.new(1, 0, 0, 35)
                        Tween(dropdownArrow, {0.2, "Linear", "Out"}, {Rotation = 0})
                    end
                end
                
                -- Hover effects
                dropdownButton.MouseEnter:Connect(function()
                    Tween(dropdownButton, {0.2, "Linear", "Out"}, {
                        BackgroundColor3 = config.DropdownHoverColor
                    })
                end)
                
                dropdownButton.MouseLeave:Connect(function()
                    Tween(dropdownButton, {0.2, "Linear", "Out"}, {
                        BackgroundColor3 = config.DropdownColor
                    })
                end)
                
                -- Click effect
                dropdownButton.MouseButton1Click:Connect(function()
                    Ripple(dropdownButton)
                    toggleDropdown()
                end)
                
                -- Add options
                local function addOption(option)
                    local optionButton = Instance.new("TextButton")
                    optionButton.Name = option.."Option"
                    optionButton.Text = "   "..option
                    optionButton.Font = Enum.Font.Gotham
                    optionButton.TextSize = 14
                    optionButton.TextColor3 = config.TextColor
                    optionButton.BackgroundColor3 = config.DropdownColor
                    optionButton.BackgroundTransparency = config.Transparency
                    optionButton.Size = UDim2.new(1, 0, 0, 30)
                    optionButton.AutoButtonColor = false
                    optionButton.LayoutOrder = 1
                    optionButton.ZIndex = 5
                    optionButton.Parent = dropdownContent
                    
                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, config.CornerRadius)
                    optionCorner.Parent = optionButton
                    
                    -- Hover effects
                    optionButton.MouseEnter:Connect(function()
                        Tween(optionButton, {0.2, "Linear", "Out"}, {
                            BackgroundColor3 = config.DropdownHoverColor
                        })
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        Tween(optionButton, {0.2, "Linear", "Out"}, {
                            BackgroundColor3 = config.DropdownColor
                        })
                    end)
                    
                    -- Click effect
                    optionButton.MouseButton1Click:Connect(function()
                        Ripple(optionButton)
                        dropdownButton.Text = "   "..text..": "..option
                        library.flags[flag] = option
                        if callback then callback(option) end
                        toggleDropdown()
                    end)
                end
                
                -- Add all options
                for _, option in pairs(options) do
                    addOption(option)
                end
                
                -- Update content size when changed
                contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    if isOpen then
                        dropdown.Size = UDim2.new(1, 0, 0, 35 + dropdownContent.AbsoluteContentSize.Y + 5)
                    end
                end)
                
                return {
                    AddOption = function(self, option)
                        addOption(option)
                    end,
                    RemoveOption = function(self, option)
                        local optionButton = dropdownContent:FindFirstChild(option.."Option")
                        if optionButton then
                            optionButton:Destroy()
                        end
                    end,
                    SetOptions = function(self, newOptions)
                        -- Clear existing options
                        for _, child in pairs(dropdownContent:GetChildren()) do
                            if child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end
                        
                        -- Add new options
                        for _, option in pairs(newOptions) do
                            addOption(option)
                        end
                    end
                }
            end
            
            -- Textbox
            function section:Textbox(text, flag, placeholder, default, callback)
                library.flags[flag] = default or ""
                
                local textbox = Instance.new("Frame")
                textbox.Name = text.."Textbox"
                textbox.Size = UDim2.new(1, 0, 0, 35)
                textbox.BackgroundTransparency = 1
                textbox.LayoutOrder = 1
                textbox.ZIndex = 4
                textbox.Parent = sectionContent
                
                local textboxLabel = Instance.new("TextLabel")
                textboxLabel.Name = "Label"
                textboxLabel.Text = text
                textboxLabel.Font = Enum.Font.Gotham
                textboxLabel.TextSize = 14
                textboxLabel.TextColor3 = config.TextColor
                textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                textboxLabel.BackgroundTransparency = 1
                textboxLabel.Size = UDim2.new(1, 0, 0, 20)
                textboxLabel.ZIndex = 4
                textboxLabel.Parent = textbox
                
                local inputBox = Instance.new("TextBox")
                inputBox.Name = "Input"
                inputBox.Text = default or ""
                inputBox.PlaceholderText = placeholder or ""
                inputBox.Font = Enum.Font.Gotham
                inputBox.TextSize = 14
                inputBox.TextColor3 = config.TextColor
                inputBox.PlaceholderColor3 = config.DisabledTextColor
                inputBox.BackgroundColor3 = config.TextboxColor
                inputBox.BackgroundTransparency = config.Transparency
                inputBox.Size = UDim2.new(1, 0, 0, 35)
                inputBox.Position = UDim2.new(0, 0, 0, 20)
                inputBox.ZIndex = 5
                inputBox.Parent = textbox
                
                local inputCorner = Instance.new("UICorner")
                inputCorner.CornerRadius = UDim.new(0, config.CornerRadius)
                inputCorner.Parent = inputBox
                
                local inputPadding = Instance.new("UIPadding")
                inputPadding.PaddingLeft = UDim.new(0, 10)
                inputPadding.Parent = inputBox
                
                -- Hover effects
                inputBox.MouseEnter:Connect(function()
                    Tween(inputBox, {0.2, "Linear", "Out"}, {
                        BackgroundColor3 = config.TextboxHoverColor
                    })
                end)
                
                inputBox.MouseLeave:Connect(function()
                    Tween(inputBox, {0.2, "Linear", "Out"}, {
                        BackgroundColor3 = config.TextboxColor
                    })
                end)
                
                -- Text changed
                inputBox.FocusLost:Connect(function()
                    library.flags[flag] = inputBox.Text
                    if callback then callback(inputBox.Text) end
                end)
                
                return {
                    SetText = function(self, text)
                        inputBox.Text = text
                        library.flags[flag] = text
                    end
                }
            end
            
            -- Label
            function section:Label(text)
                local label = Instance.new("TextLabel")
                label.Name = text.."Label"
                label.Text = text
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextColor3 = config.TextColor
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 0, 20)
                label.LayoutOrder = 1
                label.ZIndex = 4
                label.Parent = sectionContent
                
                return {
                    SetText = function(self, newText)
                        label.Text = newText
                    end
                }
            end
            
            -- Initialize section size
            sectionFrame.Size = UDim2.new(1, -20, 0, 40 + contentLayout.AbsoluteContentSize.Y)
            
            return section
        end
        
        return tab
    end
    
    -- Search functionality
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = string.lower(searchBox.Text)
        
        if searchText == "" then
            -- Show all elements when search is empty
            for _, child in pairs(tabContent:GetChildren()) do
                if child:IsA("ScrollingFrame") and child ~= library.currentTab.content then
                    for _, element in pairs(child:GetDescendants()) do
                        if element:IsA("Frame") and element.Name:match("Section$") then
                            element.Visible = true
                            
                            for _, content in pairs(element:GetDescendants()) do
                                if content:IsA("Frame") and content.Name == "Content" then
                                    for _, control in pairs(content:GetChildren()) do
                                        if control:IsA("Frame") or control:IsA("TextButton") then
                                            control.Visible = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            -- Filter elements based on search text
            for _, child in pairs(tabContent:GetChildren()) do
                if child:IsA("ScrollingFrame") and child ~= library.currentTab.content then
                    for _, element in pairs(child:GetDescendants()) do
                        if element:IsA("Frame") and element.Name:match("Section$") then
                            local sectionVisible = false
                            
                            -- Check if section name matches
                            if string.find(string.lower(element.Header.Text), searchText) then
                                sectionVisible = true
                            end
                            
                            -- Check controls in section
                            for _, content in pairs(element:GetDescendants()) do
                                if content:IsA("Frame") and content.Name == "Content" then
                                    for _, control in pairs(content:GetChildren()) do
                                        if control:IsA("Frame") or control:IsA("TextButton") then
                                            local controlText = ""
                                            
                                            if control:FindFirstChild("Label") then
                                                controlText = control.Label.Text
                                            elseif control:FindFirstChild("Text") then
                                                controlText = control.Text
                                            elseif control.Text then
                                                controlText = control.Text
                                            end
                                            
                                            if string.find(string.lower(controlText), searchText) then
                                                control.Visible = true
                                                sectionVisible = true
                                            else
                                                control.Visible = false
                                            end
                                        end
                                    end
                                end
                            end
                            
                            element.Visible = sectionVisible
                        end
                    end
                end
            end
        end
    end)
    
    return window
end

return library