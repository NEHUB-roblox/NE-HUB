-- Enhanced Panda UI Library with search functionality and modern design
local library = {}

-- Utility functions
local function CreateRipple(button)
    spawn(function()
        if button.ClipsDescendants ~= true then
            button.ClipsDescendants = true
        end
        
        local Ripple = Instance.new("ImageLabel")
        Ripple.Name = "Ripple"
        Ripple.Parent = button
        Ripple.BackgroundTransparency = 1
        Ripple.ZIndex = 8
        Ripple.Image = "rbxassetid://2708891598"
        Ripple.ImageTransparency = 0.8
        Ripple.ScaleType = Enum.ScaleType.Fit
        Ripple.ImageColor3 = Color3.fromRGB(200, 200, 255)
        
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        Ripple.Position = UDim2.new(
            (mouse.X - Ripple.AbsolutePosition.X) / button.AbsoluteSize.X,
            0,
            (mouse.Y - Ripple.AbsolutePosition.Y) / button.AbsoluteSize.Y,
            0
        )
        
        game:GetService("TweenService"):Create(Ripple, TweenInfo.new(0.3), {
            Position = UDim2.new(-5.5, 0, -5.5, 0),
            Size = UDim2.new(12, 0, 12, 0)
        }):Play()
        
        wait(0.15)
        game:GetService("TweenService"):Create(Ripple, TweenInfo.new(0.3), {
            ImageTransparency = 1
        }):Play()
        
        wait(0.3)
        Ripple:Destroy()
    end)
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    
    local function Update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    
    handle.InputBegan:Connect(function(input)
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
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            Update(input)
        end
    end)
end

-- Main library functions
function library.new(name)
    -- Cleanup existing UI
    for _, v in next, game:GetService("CoreGui"):GetChildren() do
        if v.Name == "PandaUI" then
            v:Destroy()
        end
    end

    -- Color configuration
    local config = {
        MainColor = Color3.fromRGB(20, 20, 30),
        TabColor = Color3.fromRGB(25, 25, 40),
        BgColor = Color3.fromRGB(15, 15, 25),
        AccentColor = Color3.fromRGB(100, 150, 255),
        
        ButtonColor = Color3.fromRGB(30, 30, 50),
        TextboxColor = Color3.fromRGB(30, 30, 50),
        DropdownColor = Color3.fromRGB(30, 30, 50),
        KeybindColor = Color3.fromRGB(30, 30, 50),
        LabelColor = Color3.fromRGB(30, 30, 50),
        
        SliderColor = Color3.fromRGB(30, 30, 50),
        SliderBarColor = Color3.fromRGB(100, 150, 255),
        
        ToggleColor = Color3.fromRGB(30, 30, 50),
        ToggleOff = Color3.fromRGB(40, 40, 60),
        ToggleOn = Color3.fromRGB(100, 150, 255),
        
        TextColor = Color3.fromRGB(220, 220, 255)
    }

    -- Create main UI elements
    local PandaUI = Instance.new("ScreenGui")
    PandaUI.Name = "PandaUI"
    PandaUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if syn and syn.protect_gui then
        syn.protect_gui(PandaUI)
    end
    PandaUI.Parent = game:GetService("CoreGui")

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = PandaUI
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = config.BgColor
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.ZIndex = 1
    Main.Active = true
    
    -- Main UI corner
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main
    
    -- Glow effect
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.Parent = Main
    Glow.BackgroundTransparency = 1
    Glow.BorderSizePixel = 0
    Glow.Size = UDim2.new(1, 40, 1, 40)
    Glow.Position = UDim2.new(0, -20, 0, -20)
    Glow.Image = "rbxassetid://5028857084"
    Glow.ImageColor3 = Color3.fromRGB(50, 100, 200)
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(24, 24, 276, 276)
    Glow.ZIndex = 0
    
    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = Main
    TitleBar.BackgroundColor3 = config.MainColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Parent = TitleBar
    TitleText.BackgroundTransparency = 1
    TitleText.Position = UDim2.new(0, 15, 0, 0)
    TitleText.Size = UDim2.new(0, 200, 1, 0)
    TitleText.Font = Enum.Font.GothamSemibold
    TitleText.Text = name or "Panda UI"
    TitleText.TextColor3 = config.TextColor
    TitleText.TextSize = 16
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Search box
    local SearchBox = Instance.new("TextBox")
    SearchBox.Name = "SearchBox"
    SearchBox.Parent = TitleBar
    SearchBox.AnchorPoint = Vector2.new(1, 0.5)
    SearchBox.BackgroundColor3 = config.TextboxColor
    SearchBox.Position = UDim2.new(1, -50, 0.5, 0)
    SearchBox.Size = UDim2.new(0, 200, 0, 25)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.PlaceholderText = "Search..."
    SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 180)
    SearchBox.TextColor3 = config.TextColor
    SearchBox.TextSize = 14
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.ClearTextOnFocus = false
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 4)
    SearchCorner.Parent = SearchBox
    
    local SearchPadding = Instance.new("UIPadding")
    SearchPadding.Parent = SearchBox
    SearchPadding.PaddingLeft = UDim.new(0, 8)
    
    -- Minimize button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Parent = TitleBar
    MinimizeBtn.AnchorPoint = Vector2.new(1, 0.5)
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Position = UDim2.new(1, -10, 0.5, 0)
    MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = config.TextColor
    MinimizeBtn.TextSize = 18
    
    -- Tab buttons area
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Parent = Main
    TabButtons.BackgroundColor3 = config.MainColor
    TabButtons.BorderSizePixel = 0
    TabButtons.Position = UDim2.new(0, 0, 0, 40)
    TabButtons.Size = UDim2.new(0, 150, 0, 360)
    
    local TabButtonsCorner = Instance.new("UICorner")
    TabButtonsCorner.CornerRadius = UDim.new(0, 8)
    TabButtonsCorner.Parent = TabButtons
    
    local TabButtonsList = Instance.new("ScrollingFrame")
    TabButtonsList.Name = "TabButtonsList"
    TabButtonsList.Parent = TabButtons
    TabButtonsList.BackgroundTransparency = 1
    TabButtonsList.BorderSizePixel = 0
    TabButtonsList.Position = UDim2.new(0, 5, 0, 5)
    TabButtonsList.Size = UDim2.new(1, -10, 1, -10)
    TabButtonsList.ScrollBarThickness = 3
    TabButtonsList.ScrollBarImageColor3 = config.AccentColor
    
    local TabButtonsLayout = Instance.new("UIListLayout")
    TabButtonsLayout.Parent = TabButtonsList
    TabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabButtonsLayout.Padding = UDim.new(0, 5)
    
    -- Tab content area
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.Parent = Main
    TabContent.BackgroundTransparency = 1
    TabContent.Position = UDim2.new(0, 155, 0, 45)
    TabContent.Size = UDim2.new(0, 435, 0, 345)
    
    -- Make draggable
    MakeDraggable(Main, TitleBar)
    
    -- Minimize functionality
    local minimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Main.Size = UDim2.new(0, 600, 0, 40)
            MinimizeBtn.Text = "+"
        else
            Main.Size = UDim2.new(0, 600, 0, 400)
            MinimizeBtn.Text = "-"
        end
    end)
    
    -- Window functionality
    local window = {}
    window.currentTab = nil
    window.flags = {}
    
    function window:Tab(name, icon)
        local Tab = Instance.new("ScrollingFrame")
        Tab.Name = "Tab_" .. name
        Tab.Parent = TabContent
        Tab.BackgroundTransparency = 1
        Tab.BorderSizePixel = 0
        Tab.Size = UDim2.new(1, 0, 1, 0)
        Tab.ScrollBarThickness = 3
        Tab.ScrollBarImageColor3 = config.AccentColor
        Tab.Visible = false
        
        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Parent = Tab
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Padding = UDim.new(0, 5)
        
        -- Tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton_" .. name
        TabButton.Parent = TabButtonsList
        TabButton.BackgroundColor3 = config.TabColor
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.AutoButtonColor = false
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = "  " .. name
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 220)
        TabButton.TextSize = 14
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 4)
        TabButtonCorner.Parent = TabButton
        
        local TabButtonIcon = Instance.new("ImageLabel")
        TabButtonIcon.Name = "Icon"
        TabButtonIcon.Parent = TabButton
        TabButtonIcon.BackgroundTransparency = 1
        TabButtonIcon.Position = UDim2.new(0, 8, 0.5, -10)
        TabButtonIcon.Size = UDim2.new(0, 20, 0, 20)
        TabButtonIcon.Image = "rbxassetid://" .. (icon or "4370341699")
        TabButtonIcon.ImageColor3 = Color3.fromRGB(180, 180, 220)
        
        -- Tab switching
        TabButton.MouseButton1Click:Connect(function()
            CreateRipple(TabButton)
            
            if window.currentTab then
                window.currentTab[1].BackgroundColor3 = config.TabColor
                window.currentTab[1].TextColor3 = Color3.fromRGB(180, 180, 220)
                window.currentTab[2].Visible = false
            end
            
            TabButton.BackgroundColor3 = config.AccentColor
            TabButton.TextColor3 = Color3.new(1, 1, 1)
            TabButtonIcon.ImageColor3 = Color3.new(1, 1, 1)
            Tab.Visible = true
            
            window.currentTab = {TabButton, Tab}
        end)
        
        -- Set first tab as active if none selected
        if not window.currentTab then
            TabButton.BackgroundColor3 = config.AccentColor
            TabButton.TextColor3 = Color3.new(1, 1, 1)
            TabButtonIcon.ImageColor3 = Color3.new(1, 1, 1)
            Tab.Visible = true
            window.currentTab = {TabButton, Tab}
        end
        
        local tab = {}
        
        function tab:Section(name, initiallyOpen)
            local Section = Instance.new("Frame")
            Section.Name = "Section_" .. name
            Section.Parent = Tab
            Section.BackgroundColor3 = config.TabColor
            Section.BorderSizePixel = 0
            Section.Size = UDim2.new(1, 0, 0, 40)
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = Section
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Parent = Section
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 10, 0, 0)
            SectionTitle.Size = UDim2.new(1, -40, 1, 0)
            SectionTitle.Font = Enum.Font.GothamSemibold
            SectionTitle.Text = name
            SectionTitle.TextColor3 = config.TextColor
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local SectionToggle = Instance.new("ImageButton")
            SectionToggle.Name = "Toggle"
            SectionToggle.Parent = Section
            SectionToggle.AnchorPoint = Vector2.new(1, 0.5)
            SectionToggle.BackgroundTransparency = 1
            SectionToggle.Position = UDim2.new(1, -10, 0.5, 0)
            SectionToggle.Size = UDim2.new(0, 20, 0, 20)
            SectionToggle.Image = "rbxassetid://6031302934"
            SectionToggle.ImageColor3 = config.TextColor
            
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.Parent = Section
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 5, 0, 45)
            SectionContent.Size = UDim2.new(1, -10, 0, 0)
            
            local SectionContentLayout = Instance.new("UIListLayout")
            SectionContentLayout.Parent = SectionContent
            SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionContentLayout.Padding = UDim.new(0, 5)
            
            -- Section toggle functionality
            local isOpen = initiallyOpen ~= false
            SectionToggle.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    SectionToggle.Image = "rbxassetid://6031302932"
                    Section.Size = UDim2.new(1, 0, 0, 45 + SectionContentLayout.AbsoluteContentSize.Y)
                else
                    SectionToggle.Image = "rbxassetid://6031302934"
                    Section.Size = UDim2.new(1, 0, 0, 40)
                end
            end)
            
            -- Update size when content changes
            SectionContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isOpen then
                    Section.Size = UDim2.new(1, 0, 0, 45 + SectionContentLayout.AbsoluteContentSize.Y)
                end
            end)
            
            -- Initialize state
            if isOpen then
                SectionToggle.Image = "rbxassetid://6031302932"
                Section.Size = UDim2.new(1, 0, 0, 45 + SectionContentLayout.AbsoluteContentSize.Y)
            else
                SectionToggle.Image = "rbxassetid://6031302934"
                Section.Size = UDim2.new(1, 0, 0, 40)
            end
            
            local section = {}
            
            function section:Button(text, callback)
                local Button = Instance.new("TextButton")
                Button.Name = "Button_" .. text
                Button.Parent = SectionContent
                Button.BackgroundColor3 = config.ButtonColor
                Button.BorderSizePixel = 0
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.AutoButtonColor = false
                Button.Font = Enum.Font.GothamSemibold
                Button.Text = "  " .. text
                Button.TextColor3 = config.TextColor
                Button.TextSize = 14
                Button.TextXAlignment = Enum.TextXAlignment.Left
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = Button
                
                Button.MouseButton1Click:Connect(function()
                    CreateRipple(Button)
                    if callback then callback() end
                end)
                
                return Button
            end
            
            function section:Toggle(text, flag, default, callback)
                assert(text, "No text provided")
                assert(flag, "No flag provided")
                
                window.flags[flag] = default or false
                
                local Toggle = Instance.new("TextButton")
                Toggle.Name = "Toggle_" .. text
                Toggle.Parent = SectionContent
                Toggle.BackgroundColor3 = config.ToggleColor
                Toggle.BorderSizePixel = 0
                Toggle.Size = UDim2.new(1, 0, 0, 35)
                Toggle.AutoButtonColor = false
                Toggle.Font = Enum.Font.GothamSemibold
                Toggle.Text = "  " .. text
                Toggle.TextColor3 = config.TextColor
                Toggle.TextSize = 14
                Toggle.TextXAlignment = Enum.TextXAlignment.Left
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 4)
                ToggleCorner.Parent = Toggle
                
                local ToggleSwitch = Instance.new("Frame")
                ToggleSwitch.Name = "Switch"
                ToggleSwitch.Parent = Toggle
                ToggleSwitch.AnchorPoint = Vector2.new(1, 0.5)
                ToggleSwitch.BackgroundColor3 = config.ToggleOff
                ToggleSwitch.Position = UDim2.new(1, -10, 0.5, 0)
                ToggleSwitch.Size = UDim2.new(0, 50, 0, 25)
                
                local ToggleSwitchCorner = Instance.new("UICorner")
                ToggleSwitchCorner.CornerRadius = UDim.new(0, 12)
                ToggleSwitchCorner.Parent = ToggleSwitch
                
                local ToggleKnob = Instance.new("Frame")
                ToggleKnob.Name = "Knob"
                ToggleKnob.Parent = ToggleSwitch
                ToggleKnob.BackgroundColor3 = Color3.new(1, 1, 1)
                ToggleKnob.BorderSizePixel = 0
                ToggleKnob.Position = UDim2.new(0, 2, 0.5, -10)
                ToggleKnob.Size = UDim2.new(0, 21, 0, 21)
                
                local ToggleKnobCorner = Instance.new("UICorner")
                ToggleKnobCorner.CornerRadius = UDim.new(0, 10)
                ToggleKnobCorner.Parent = ToggleKnob
                
                local function UpdateToggle(state)
                    window.flags[flag] = state
                    if state then
                        game:GetService("TweenService"):Create(ToggleKnob, TweenInfo.new(0.2), {
                            Position = UDim2.new(1, -23, 0.5, -10),
                            BackgroundColor3 = Color3.new(1, 1, 1)
                        }):Play()
                        game:GetService("TweenService"):Create(ToggleSwitch, TweenInfo.new(0.2), {
                            BackgroundColor3 = config.ToggleOn
                        }):Play()
                    else
                        game:GetService("TweenService"):Create(ToggleKnob, TweenInfo.new(0.2), {
                            Position = UDim2.new(0, 2, 0.5, -10),
                            BackgroundColor3 = Color3.new(1, 1, 1)
                        }):Play()
                        game:GetService("TweenService"):Create(ToggleSwitch, TweenInfo.new(0.2), {
                            BackgroundColor3 = config.ToggleOff
                        }):Play()
                    end
                    if callback then callback(state) end
                end
                
                Toggle.MouseButton1Click:Connect(function()
                    CreateRipple(Toggle)
                    UpdateToggle(not window.flags[flag])
                end)
                
                UpdateToggle(default or false)
                
                return {
                    SetState = function(self, state)
                        UpdateToggle(state)
                    end
                }
            end
            
            function section:Slider(text, flag, min, max, default, callback)
                assert(text, "No text provided")
                assert(flag, "No flag provided")
                
                min = min or 0
                max = max or 100
                default = default or min
                window.flags[flag] = default
                
                local Slider = Instance.new("TextButton")
                Slider.Name = "Slider_" .. text
                Slider.Parent = SectionContent
                Slider.BackgroundColor3 = config.SliderColor
                Slider.BorderSizePixel = 0
                Slider.Size = UDim2.new(1, 0, 0, 45)
                Slider.AutoButtonColor = false
                Slider.Font = Enum.Font.GothamSemibold
                Slider.Text = ""
                Slider.TextColor3 = config.TextColor
                Slider.TextSize = 14
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 4)
                SliderCorner.Parent = Slider
                
                local SliderTitle = Instance.new("TextLabel")
                SliderTitle.Name = "Title"
                SliderTitle.Parent = Slider
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 10, 0, 5)
                SliderTitle.Size = UDim2.new(1, -20, 0, 15)
                SliderTitle.Font = Enum.Font.GothamSemibold
                SliderTitle.Text = text
                SliderTitle.TextColor3 = config.TextColor
                SliderTitle.TextSize = 14
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Name = "Bar"
                SliderBar.Parent = Slider
                SliderBar.BackgroundColor3 = config.BgColor
                SliderBar.BorderSizePixel = 0
                SliderBar.Position = UDim2.new(0, 10, 0, 25)
                SliderBar.Size = UDim2.new(1, -20, 0, 10)
                
                local SliderBarCorner = Instance.new("UICorner")
                SliderBarCorner.CornerRadius = UDim.new(0, 5)
                SliderBarCorner.Parent = SliderBar
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.Parent = SliderBar
                SliderFill.BackgroundColor3 = config.SliderBarColor
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(0, 5)
                SliderFillCorner.Parent = SliderFill
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Name = "Value"
                SliderValue.Parent = Slider
                SliderValue.BackgroundTransparency = 1
                SliderValue.AnchorPoint = Vector2.new(1, 0)
                SliderValue.Position = UDim2.new(1, -10, 0, 5)
                SliderValue.Size = UDim2.new(0, 50, 0, 15)
                SliderValue.Font = Enum.Font.Gotham
                SliderValue.Text = tostring(default)
                SliderValue.TextColor3 = config.TextColor
                SliderValue.TextSize = 14
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                
                local dragging = false
                
                local function UpdateSlider(value)
                    value = math.clamp(value, min, max)
                    window.flags[flag] = value
                    SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    SliderValue.Text = tostring(math.floor(value))
                    if callback then callback(value) end
                end
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local percent = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                        UpdateSlider(min + (max - min) * percent)
                    end
                end)
                
                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                        UpdateSlider(min + (max - min) * percent)
                    end
                end)
                
                return {
                    SetValue = function(self, value)
                        UpdateSlider(value)
                    end
                }
            end
            
            function section:Dropdown(text, flag, options, callback)
                assert(text, "No text provided")
                assert(flag, "No flag provided")
                options = options or {}
                
                window.flags[flag] = nil
                
                local Dropdown = Instance.new("Frame")
                Dropdown.Name = "Dropdown_" .. text
                Dropdown.Parent = SectionContent
                Dropdown.BackgroundColor3 = config.DropdownColor
                Dropdown.BorderSizePixel = 0
                Dropdown.ClipsDescendants = true
                Dropdown.Size = UDim2.new(1, 0, 0, 35)
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 4)
                DropdownCorner.Parent = Dropdown
                
                local DropdownTitle = Instance.new("TextLabel")
                DropdownTitle.Name = "Title"
                DropdownTitle.Parent = Dropdown
                DropdownTitle.BackgroundTransparency = 1
                DropdownTitle.Position = UDim2.new(0, 10, 0, 0)
                DropdownTitle.Size = UDim2.new(0.7, -10, 1, 0)
                DropdownTitle.Font = Enum.Font.GothamSemibold
                DropdownTitle.Text = text
                DropdownTitle.TextColor3 = config.TextColor
                DropdownTitle.TextSize = 14
                DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local DropdownValue = Instance.new("TextLabel")
                DropdownValue.Name = "Value"
                DropdownValue.Parent = Dropdown
                DropdownValue.BackgroundTransparency = 1
                DropdownValue.AnchorPoint = Vector2.new(1, 0)
                DropdownValue.Position = UDim2.new(1, -30, 0, 0)
                DropdownValue.Size = UDim2.new(0.3, -10, 1, 0)
                DropdownValue.Font = Enum.Font.Gotham
                DropdownValue.Text = "None"
                DropdownValue.TextColor3 = Color3.fromRGB(180, 180, 220)
                DropdownValue.TextSize = 14
                DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
                
                local DropdownToggle = Instance.new("ImageButton")
                DropdownToggle.Name = "Toggle"
                DropdownToggle.Parent = Dropdown
                DropdownToggle.AnchorPoint = Vector2.new(1, 0.5)
                DropdownToggle.BackgroundTransparency = 1
                DropdownToggle.Position = UDim2.new(1, -10, 0.5, 0)
                DropdownToggle.Size = UDim2.new(0, 20, 0, 20)
                DropdownToggle.Image = "rbxassetid://6031091004"
                DropdownToggle.ImageColor3 = config.TextColor
                
                local DropdownContent = Instance.new("Frame")
                DropdownContent.Name = "Content"
                DropdownContent.Parent = Dropdown
                DropdownContent.BackgroundTransparency = 1
                DropdownContent.Position = UDim2.new(0, 5, 0, 40)
                DropdownContent.Size = UDim2.new(1, -10, 0, 0)
                
                local DropdownContentLayout = Instance.new("UIListLayout")
                DropdownContentLayout.Parent = DropdownContent
                DropdownContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
                DropdownContentLayout.Padding = UDim.new(0, 5)
                
                local isOpen = false
                
                local function ToggleDropdown()
                    isOpen = not isOpen
                    
                    if isOpen then
                        DropdownToggle.Rotation = 180
                        Dropdown.Size = UDim2.new(1, 0, 0, 40 + DropdownContentLayout.AbsoluteContentSize.Y)
                    else
                        DropdownToggle.Rotation = 0
                        Dropdown.Size = UDim2.new(1, 0, 0, 35)
                    end
                end
                
                DropdownToggle.MouseButton1Click:Connect(ToggleDropdown)
                Dropdown.MouseButton1Click:Connect(function()
                    if not isOpen then
                        ToggleDropdown()
                    end
                end)
                
                DropdownContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    if isOpen then
                        Dropdown.Size = UDim2.new(1, 0, 0, 40 + DropdownContentLayout.AbsoluteContentSize.Y)
                    end
                end)
                
                local dropdown = {}
                
                function dropdown:AddOption(option)
                    local Option = Instance.new("TextButton")
                    Option.Name = "Option_" .. option
                    Option.Parent = DropdownContent
                    Option.BackgroundColor3 = config.TabColor
                    Option.BorderSizePixel = 0
                    Option.Size = UDim2.new(1, 0, 0, 30)
                    Option.AutoButtonColor = false
                    Option.Font = Enum.Font.Gotham
                    Option.Text = option
                    Option.TextColor3 = config.TextColor
                    Option.TextSize = 14
                    
                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 4)
                    OptionCorner.Parent = Option
                    
                    Option.MouseButton1Click:Connect(function()
                        DropdownValue.Text = option
                        DropdownValue.TextColor3 = config.TextColor
                        window.flags[flag] = option
                        if callback then callback(option) end
                        ToggleDropdown()
                    end)
                end
                
                function dropdown:RemoveOption(option)
                    local option = DropdownContent:FindFirstChild("Option_" .. option)
                    if option then
                        option:Destroy()
                    end
                end
                
                function dropdown:SetOptions(newOptions)
                    for _, v in pairs(DropdownContent:GetChildren()) do
                        if v:IsA("TextButton") then
                            v:Destroy()
                        end
                    end
                    
                    for _, option in pairs(newOptions) do
                        dropdown:AddOption(option)
                    end
                end
                
                dropdown:SetOptions(options)
                
                return dropdown
            end
            
            return section
        end
        
        return tab
    end
    
    -- Search functionality
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = string.lower(SearchBox.Text)
        
        for _, tab in pairs(TabContent:GetChildren()) do
            if tab:IsA("ScrollingFrame") then
                for _, section in pairs(tab:GetDescendants()) do
                    if section:IsA("Frame") and section.Name:match("Section_") then
                        local visible = false
                        
                        -- Check section title
                        if string.find(string.lower(section.Title.Text), searchText) then
                            visible = true
                        end
                        
                        -- Check elements in section
                        if not visible and section:FindFirstChild("Content") then
                            for _, element in pairs(section.Content:GetChildren()) do
                                if element:IsA("TextButton") or element:IsA("TextLabel") then
                                    if string.find(string.lower(element.Text or element.Name), searchText) then
                                        visible = true
                                        break
                                    end
                                end
                            end
                        end
                        
                        section.Visible = visible
                        
                        -- Adjust section size if open
                        if visible and section:FindFirstChild("Toggle") then
                            if section.Toggle.Image == "rbxassetid://6031302932" then -- Open state
                                section.Size = UDim2.new(1, 0, 0, 45 + section.Content.UIListLayout.AbsoluteContentSize.Y)
                            end
                        end
                    end
                end
            end
        end
    end)
    
    return window
end

return library