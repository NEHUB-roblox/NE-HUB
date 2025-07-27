local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/UI-Libraries/main/ModernUI.lua"))()

local ModernUI = {}
ModernUI.__index = ModernUI

function ModernUI.new(title, theme)
    -- Wait for game to load
    repeat task.wait() until game:IsLoaded()
    
    -- Configuration
    local config = {
        MainColor = Color3.fromRGB(20, 20, 30),
        SecondaryColor = Color3.fromRGB(30, 30, 45),
        AccentColor = Color3.fromRGB(0, 180, 255),
        TextColor = Color3.fromRGB(240, 240, 240),
        DarkText = Color3.fromRGB(50, 50, 50),
        
        -- Element colors
        ButtonColor = Color3.fromRGB(35, 35, 50),
        ToggleOn = Color3.fromRGB(0, 200, 150),
        ToggleOff = Color3.fromRGB(70, 70, 90),
        SliderTrack = Color3.fromRGB(50, 50, 70),
        SliderFill = Color3.fromRGB(0, 180, 255),
        DropdownColor = Color3.fromRGB(40, 40, 60),
        TextboxColor = Color3.fromRGB(40, 40, 60),
        
        -- Glow effects
        GlowColor = Color3.fromRGB(0, 150, 255),
        GlowIntensity = 0.2,
        
        -- Corner radius
        CornerRadius = UDim.new(0, 8),
        SmallCorner = UDim.new(0, 6)
    }
    
    -- Merge theme if provided
    if theme then
        for k,v in pairs(theme) do
            config[k] = v
        end
    end
    
    -- Create main UI
    local ui = setmetatable({}, ModernUI)
    ui.flags = {}
    ui.currentTab = nil
    ui.tabs = {}
    ui.minimized = false
    
    -- Main screen gui
    local ScreenGui = Instance.new("ScreenGui")
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    end
    ScreenGui.Name = "ModernUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    -- Main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = config.MainColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Parent = ScreenGui
    
    -- Glow effect
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://5028857084"
    Glow.ImageColor3 = config.GlowColor
    Glow.ImageTransparency = 0.9
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(24, 24, 276, 276)
    Glow.Size = UDim2.new(1, 40, 1, 40)
    Glow.Position = UDim2.new(0.5, -20, 0.5, -20)
    Glow.AnchorPoint = Vector2.new(0.5, 0.5)
    Glow.ZIndex = -1
    Glow.Parent = MainFrame
    
    -- Corner rounding
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = config.CornerRadius
    Corner.Parent = MainFrame
    
    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = config.SecondaryColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = title or "Modern UI"
    Title.TextColor3 = config.TextColor
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Minimize button
    local Minimize = Instance.new("TextButton")
    Minimize.Name = "Minimize"
    Minimize.BackgroundTransparency = 1
    Minimize.Position = UDim2.new(1, -40, 0, 0)
    Minimize.Size = UDim2.new(0, 40, 1, 0)
    Minimize.Font = Enum.Font.GothamBold
    Minimize.Text = "-"
    Minimize.TextColor3 = config.TextColor
    Minimize.TextSize = 20
    Minimize.Parent = TitleBar
    
    Minimize.MouseButton1Click:Connect(function()
        ui:ToggleMinimize()
    end)
    
    -- Search box
    local SearchBox = Instance.new("Frame")
    SearchBox.Name = "SearchBox"
    SearchBox.BackgroundColor3 = config.SecondaryColor
    SearchBox.BorderSizePixel = 0
    SearchBox.Position = UDim2.new(0, 15, 0, 50)
    SearchBox.Size = UDim2.new(1, -30, 0, 35)
    SearchBox.Parent = MainFrame
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = config.SmallCorner
    SearchCorner.Parent = SearchBox
    
    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Name = "SearchIcon"
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = "rbxassetid://3926305904"
    SearchIcon.ImageColor3 = config.TextColor
    SearchIcon.ImageRectOffset = Vector2.new(964, 324)
    SearchIcon.ImageRectSize = Vector2.new(36, 36)
    SearchIcon.Position = UDim2.new(0, 8, 0.5, -10)
    SearchIcon.Size = UDim2.new(0, 20, 0, 20)
    SearchIcon.Parent = SearchBox
    
    local SearchInput = Instance.new("TextBox")
    SearchInput.Name = "SearchInput"
    SearchInput.BackgroundTransparency = 1
    SearchInput.Position = UDim2.new(0, 35, 0, 0)
    SearchInput.Size = UDim2.new(1, -35, 1, 0)
    SearchInput.Font = Enum.Font.Gotham
    SearchInput.PlaceholderText = "Search features..."
    SearchInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    SearchInput.Text = ""
    SearchInput.TextColor3 = config.TextColor
    SearchInput.TextSize = 14
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.Parent = SearchBox
    
    -- Tab buttons
    local TabButtons = Instance.new("ScrollingFrame")
    TabButtons.Name = "TabButtons"
    TabButtons.BackgroundTransparency = 1
    TabButtons.BorderSizePixel = 0
    TabButtons.Position = UDim2.new(0, 15, 0, 95)
    TabButtons.Size = UDim2.new(0, 150, 0, 340)
    TabButtons.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabButtons.ScrollBarThickness = 3
    TabButtons.ScrollBarImageColor3 = config.AccentColor
    TabButtons.Parent = MainFrame
    
    local TabList = Instance.new("UIListLayout")
    TabList.Name = "TabList"
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabButtons
    
    TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabButtons.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y)
    end)
    
    -- Content frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 180, 0, 95)
    ContentFrame.Size = UDim2.new(1, -195, 0, 340)
    ContentFrame.Parent = MainFrame
    
    -- Make draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Search functionality
    local function searchFeatures(text)
        text = string.lower(text)
        
        for _, tab in pairs(ui.tabs) do
            for _, section in pairs(tab.sections) do
                for _, element in pairs(section.elements) do
                    if element:IsA("TextButton") or element:IsA("Frame") then
                        local elementText = element:FindFirstChild("TextLabel") or element:FindFirstChild("Text")
                        if elementText then
                            if string.find(string.lower(elementText.Text), text) then
                                element.Visible = true
                            else
                                element.Visible = false
                            end
                        end
                    end
                end
            end
        end
    end
    
    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        if SearchInput.Text == "" then
            -- Show all when search is empty
            for _, tab in pairs(ui.tabs) do
                for _, section in pairs(tab.sections) do
                    for _, element in pairs(section.elements) do
                        element.Visible = true
                    end
                end
            end
        else
            searchFeatures(SearchInput.Text)
        end
    end)
    
    -- UI methods
    function ui:ToggleMinimize()
        self.minimized = not self.minimized
        if self.minimized then
            MainFrame.Size = UDim2.new(0, 600, 0, 40)
            TitleBar.Size = UDim2.new(1, 0, 1, 0)
            Minimize.Text = "+"
        else
            MainFrame.Size = UDim2.new(0, 600, 0, 450)
            TitleBar.Size = UDim2.new(1, 0, 0, 40)
            Minimize.Text = "-"
        end
    end
    
    function ui:Tab(name, icon)
        local tab = {}
        tab.name = name
        tab.sections = {}
        
        -- Tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name.."Tab"
        TabButton.BackgroundColor3 = config.SecondaryColor
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.AutoButtonColor = false
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = "   "..name
        TabButton.TextColor3 = config.TextColor
        TabButton.TextSize = 14
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = TabButtons
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = config.SmallCorner
        TabCorner.Parent = TabButton
        
        if icon then
            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Name = "Icon"
            TabIcon.BackgroundTransparency = 1
            TabIcon.Image = icon
            TabIcon.Size = UDim2.new(0, 20, 0, 20)
            TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
            TabIcon.Parent = TabButton
        end
        
        -- Tab content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name.."Content"
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = config.AccentColor
        TabContent.Visible = false
        TabContent.Parent = ContentFrame
        
        local TabContentList = Instance.new("UIListLayout")
        TabContentList.Name = "List"
        TabContentList.Padding = UDim.new(0, 10)
        TabContentList.Parent = TabContent
        
        TabContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentList.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab switching
        TabButton.MouseButton1Click:Connect(function()
            if ui.currentTab == tab then return end
            
            if ui.currentTab then
                ui.currentTab.button.BackgroundColor3 = config.SecondaryColor
                ui.currentTab.content.Visible = false
            end
            
            ui.currentTab = tab
            tab.button.BackgroundColor3 = config.AccentColor
            tab.content.Visible = true
        end)
        
        tab.button = TabButton
        tab.content = TabContent
        
        function tab:Section(name)
            local section = {}
            section.name = name
            section.elements = {}
            
            -- Section frame
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name.."Section"
            SectionFrame.BackgroundColor3 = config.SecondaryColor
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.Parent = tab.content
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = config.SmallCorner
            SectionCorner.Parent = SectionFrame
            
            -- Section title
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 15, 0, 10)
            SectionTitle.Size = UDim2.new(1, -30, 0, 20)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = name
            SectionTitle.TextColor3 = config.TextColor
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame
            
            -- Section content
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 10, 0, 35)
            SectionContent.Size = UDim2.new(1, -20, 0, 0)
            SectionContent.Parent = SectionFrame
            
            local SectionList = Instance.new("UIListLayout")
            SectionList.Name = "List"
            SectionList.Padding = UDim.new(0, 10)
            SectionList.Parent = SectionContent
            
            SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionContent.Size = UDim2.new(1, -20, 0, SectionList.AbsoluteContentSize.Y)
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y + 45)
            end)
            
            -- Section methods
            function section:Button(text, callback)
                local Button = Instance.new("TextButton")
                Button.Name = text.."Button"
                Button.BackgroundColor3 = config.ButtonColor
                Button.BorderSizePixel = 0
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.AutoButtonColor = false
                Button.Font = Enum.Font.GothamSemibold
                Button.Text = text
                Button.TextColor3 = config.TextColor
                Button.TextSize = 14
                Button.Parent = SectionContent
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = config.SmallCorner
                ButtonCorner.Parent = Button
                
                -- Hover effect
                Button.MouseEnter:Connect(function()
                    game:GetService("TweenService"):Create(Button, TweenInfo.new(0.2), {
                        BackgroundColor3 = config.ButtonColor:lerp(Color3.new(1,1,1), 0.1)
                    }):Play()
                end)
                
                Button.MouseLeave:Connect(function()
                    game:GetService("TweenService"):Create(Button, TweenInfo.new(0.2), {
                        BackgroundColor3 = config.ButtonColor
                    }):Play()
                end)
                
                -- Click effect
                Button.MouseButton1Click:Connect(function()
                    spawn(callback)
                    
                    -- Ripple effect
                    local Ripple = Instance.new("Frame")
                    Ripple.Name = "Ripple"
                    Ripple.BackgroundColor3 = Color3.new(1,1,1)
                    Ripple.BackgroundTransparency = 0.8
                    Ripple.Size = UDim2.new(0, 0, 0, 0)
                    Ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                    Ripple.Parent = Button
                    
                    local RippleCorner = Instance.new("UICorner")
                    RippleCorner.CornerRadius = UDim.new(1, 0)
                    RippleCorner.Parent = Ripple
                    
                    game:GetService("TweenService"):Create(Ripple, TweenInfo.new(0.5), {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1
                    }):Play()
                    
                    game:GetService("Debris"):AddItem(Ripple, 0.5)
                end)
                
                table.insert(section.elements, Button)
            end
            
            function section:Toggle(text, flag, default, callback)
                local Toggle = Instance.new("Frame")
                Toggle.Name = text.."Toggle"
                Toggle.BackgroundTransparency = 1
                Toggle.Size = UDim2.new(1, 0, 0, 35)
                Toggle.Parent = SectionContent
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "Label"
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.Text = text
                ToggleLabel.TextColor3 = config.TextColor
                ToggleLabel.TextSize = 14
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = Toggle
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "Toggle"
                ToggleButton.BackgroundColor3 = default and config.ToggleOn or config.ToggleOff
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Position = UDim2.new(1, -50, 0.5, -12)
                ToggleButton.Size = UDim2.new(0, 50, 0, 24)
                ToggleButton.AutoButtonColor = false
                ToggleButton.Font = Enum.Font.GothamBold
                ToggleButton.Text = default and "ON" or "OFF"
                ToggleButton.TextColor3 = config.DarkText
                ToggleButton.TextSize = 12
                ToggleButton.Parent = Toggle
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(1, 0)
                ToggleCorner.Parent = ToggleButton
                
                -- Store state
                ui.flags[flag] = default or false
                
                -- Toggle function
                local function setState(state)
                    state = state or not ui.flags[flag]
                    ui.flags[flag] = state
                    
                    game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = state and config.ToggleOn or config.ToggleOff,
                        Text = state and "ON" or "OFF"
                    }):Play()
                    
                    if callback then
                        callback(state)
                    end
                end
                
                -- Click handler
                ToggleButton.MouseButton1Click:Connect(function()
                    setState()
                end)
                
                table.insert(section.elements, Toggle)
                
                return {
                    SetState = setState
                }
            end
            
            function section:Slider(text, flag, min, max, default, callback)
                local Slider = Instance.new("Frame")
                Slider.Name = text.."Slider"
                Slider.BackgroundTransparency = 1
                Slider.Size = UDim2.new(1, 0, 0, 50)
                Slider.Parent = SectionContent
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "Label"
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Size = UDim2.new(1, 0, 0, 20)
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.Text = text
                SliderLabel.TextColor3 = config.TextColor
                SliderLabel.TextSize = 14
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = Slider
                
                local SliderTrack = Instance.new("Frame")
                SliderTrack.Name = "Track"
                SliderTrack.BackgroundColor3 = config.SliderTrack
                SliderTrack.BorderSizePixel = 0
                SliderTrack.Position = UDim2.new(0, 0, 0, 25)
                SliderTrack.Size = UDim2.new(1, 0, 0, 6)
                SliderTrack.Parent = Slider
                
                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = SliderTrack
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.BackgroundColor3 = config.SliderFill
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
                SliderFill.Parent = SliderTrack
                
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Name = "Value"
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(1, -60, 0, 0)
                SliderValue.Size = UDim2.new(0, 60, 0, 20)
                SliderValue.Font = Enum.Font.Gotham
                SliderValue.Text = tostring(default or min)
                SliderValue.TextColor3 = config.TextColor
                SliderValue.TextSize = 14
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.Parent = Slider
                
                -- Store state
                ui.flags[flag] = default or min
                
                -- Slider function
                local function setValue(value)
                    value = math.clamp(value, min, max)
                    ui.flags[flag] = value
                    
                    local percent = (value - min) / (max - min)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    SliderValue.Text = tostring(math.floor(value))
                    
                    if callback then
                        callback(value)
                    end
                end
                
                -- Drag handler
                local dragging = false
                
                SliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        
                        local percent = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
                        setValue(min + (max - min) * percent)
                    end
                end)
                
                SliderTrack.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
                        setValue(min + (max - min) * percent)
                    end
                end)
                
                -- Set initial value
                setValue(default or min)
                
                table.insert(section.elements, Slider)
                
                return {
                    SetValue = setValue
                }
            end
            
            function section:Dropdown(text, flag, options, callback)
                local Dropdown = Instance.new("Frame")
                Dropdown.Name = text.."Dropdown"
                Dropdown.BackgroundTransparency = 1
                Dropdown.Size = UDim2.new(1, 0, 0, 35)
                Dropdown.Parent = SectionContent
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Name = "Label"
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Size = UDim2.new(1, -60, 1, 0)
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.Text = text
                DropdownLabel.TextColor3 = config.TextColor
                DropdownLabel.TextSize = 14
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = Dropdown
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "Button"
                DropdownButton.BackgroundColor3 = config.DropdownColor
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Position = UDim2.new(1, -50, 0, 0)
                DropdownButton.Size = UDim2.new(0, 50, 0, 35)
                DropdownButton.AutoButtonColor = false
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.Text = "▼"
                DropdownButton.TextColor3 = config.TextColor
                DropdownButton.TextSize = 14
                DropdownButton.Parent = Dropdown
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = config.SmallCorner
                ButtonCorner.Parent = DropdownButton
                
                -- Dropdown list
                local DropdownList = Instance.new("Frame")
                DropdownList.Name = "List"
                DropdownList.BackgroundColor3 = config.DropdownColor
                DropdownList.BorderSizePixel = 0
                DropdownList.Position = UDim2.new(0, 0, 1, 5)
                DropdownList.Size = UDim2.new(1, 0, 0, 0)
                DropdownList.Visible = false
                DropdownList.ZIndex = 2
                DropdownList.Parent = Dropdown
                
                local ListCorner = Instance.new("UICorner")
                ListCorner.CornerRadius = config.SmallCorner
                ListCorner.Parent = DropdownList
                
                local ListLayout = Instance.new("UIListLayout")
                ListLayout.Padding = UDim.new(0, 2)
                ListLayout.Parent = DropdownList
                
                ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    DropdownList.Size = UDim2.new(1, 0, 0, ListLayout.AbsoluteContentSize.Y + 4)
                end)
                
                -- Store state
                ui.flags[flag] = nil
                
                -- Dropdown function
                local function setOption(option)
                    ui.flags[flag] = option
                    DropdownLabel.Text = text..": "..option
                    
                    if callback then
                        callback(option)
                    end
                end
                
                -- Toggle dropdown
                local open = false
                
                DropdownButton.MouseButton1Click:Connect(function()
                    open = not open
                    DropdownList.Visible = open
                    DropdownButton.Text = open and "▲" or "▼"
                end)
                
                -- Add options
                for _, option in pairs(options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = option
                    OptionButton.BackgroundColor3 = config.ButtonColor
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Size = UDim2.new(1, -4, 0, 30)
                    OptionButton.Position = UDim2.new(0, 2, 0, 2)
                    OptionButton.AutoButtonColor = false
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Text = option
                    OptionButton.TextColor3 = config.TextColor
                    OptionButton.TextSize = 14
                    OptionButton.Parent = DropdownList
                    
                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = config.SmallCorner
                    OptionCorner.Parent = OptionButton
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        setOption(option)
                        open = false
                        DropdownList.Visible = false
                        DropdownButton.Text = "▼"
                    end)
                end
                
                table.insert(section.elements, Dropdown)
                
                return {
                    SetOption = setOption,
                    AddOption = function(option)
                        -- Add new option to dropdown
                    end,
                    RemoveOption = function(option)
                        -- Remove option from dropdown
                    end
                }
            end
            
            table.insert(tab.sections, section)
            return section
        end
        
        table.insert(ui.tabs, tab)
        return tab
    end
    
    -- Set first tab as default
    if #ui.tabs > 0 then
        ui.currentTab = ui.tabs[1]
        ui.currentTab.button.BackgroundColor3 = config.AccentColor
        ui.currentTab.content.Visible = true
    end
    
    return ui
end

return ModernUI