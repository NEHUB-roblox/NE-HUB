-- Modern Tech UI Library
repeat task.wait() until game:IsLoaded()

local library = {}
local ToggleUI = false
library.currentTab = nil
library.flags = {}

local services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end
})

local mouse = game:GetService("Players").LocalPlayer:GetMouse()

-- Modern color scheme
local colors = {
    Main = Color3.fromRGB(10, 10, 20),
    Secondary = Color3.fromRGB(20, 20, 40),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(240, 240, 240),
    DarkText = Color3.fromRGB(150, 150, 150),
    Success = Color3.fromRGB(0, 255, 170),
    Warning = Color3.fromRGB(255, 170, 0),
    Error = Color3.fromRGB(255, 50, 50),
    Slider = Color3.fromRGB(0, 200, 255),
    ToggleOn = Color3.fromRGB(0, 255, 200),
    ToggleOff = Color3.fromRGB(60, 60, 80),
    Button = Color3.fromRGB(30, 30, 50),
    ButtonHover = Color3.fromRGB(40, 40, 70)
}

-- Animation functions
local function Tween(obj, props, duration, easing)
    easing = easing or Enum.EasingStyle.Quad
    game:GetService("TweenService"):Create(
        obj,
        TweenInfo.new(duration or 0.2, easing),
        props
    ):Play()
end

local function Ripple(button, color)
    spawn(function()
        if button.ClipsDescendants ~= true then
            button.ClipsDescendants = true
        end
        
        local ripple = Instance.new("Frame")
        ripple.Name = "RippleEffect"
        ripple.Parent = button
        ripple.BackgroundColor3 = color or colors.Accent
        ripple.BackgroundTransparency = 0.7
        ripple.ZIndex = 8
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(
            (mouse.X - ripple.AbsolutePosition.X) / button.AbsoluteSize.X,
            0,
            (mouse.Y - ripple.AbsolutePosition.Y) / button.AbsoluteSize.Y,
            0
        )
        
        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.5
        
        Tween(ripple, {
            Position = UDim2.new(-0.5, 0, -0.5, 0),
            Size = UDim2.new(1, size, 1, size),
            BackgroundTransparency = 1
        }, 0.6, Enum.EasingStyle.Quad)
        
        wait(0.6)
        ripple:Destroy()
    end)
end

-- UI Creation
function library.new(title)
    -- Create main UI container
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TechUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    end
    ScreenGui.Parent = game:GetService("CoreGui")

    -- Main container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = colors.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- Modern border effect
    local Border = Instance.new("Frame")
    Border.Name = "Border"
    Border.Size = UDim2.new(1, 0, 1, 0)
    Border.BackgroundTransparency = 1
    Border.BorderColor3 = colors.Accent
    Border.BorderSizePixel = 2
    Border.ZIndex = 2
    Border.Parent = MainFrame

    -- Corner rounding
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame

    -- Drop shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, -5, 0, -5)
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.BackgroundTransparency = 1
    Shadow.Parent = MainFrame

    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = colors.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 3
    TitleBar.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title or "Tech UI"
    Title.Font = Enum.Font.GothamSemibold
    Title.TextColor3 = colors.Text
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.ZIndex = 4
    Title.Parent = TitleBar

    -- Minimize button
    local Minimize = Instance.new("TextButton")
    Minimize.Name = "Minimize"
    Minimize.Size = UDim2.new(0, 30, 0, 30)
    Minimize.Position = UDim2.new(1, -40, 0.5, -15)
    Minimize.AnchorPoint = Vector2.new(1, 0.5)
    Minimize.BackgroundColor3 = colors.Accent
    Minimize.AutoButtonColor = false
    Minimize.Text = "-"
    Minimize.Font = Enum.Font.GothamBold
    Minimize.TextColor3 = colors.Text
    Minimize.TextSize = 20
    Minimize.ZIndex = 4
    Minimize.Parent = TitleBar

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = Minimize

    -- Tab buttons container
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(0, 150, 1, -40)
    TabButtons.Position = UDim2.new(0, 0, 0, 40)
    TabButtons.BackgroundColor3 = colors.Secondary
    TabButtons.BorderSizePixel = 0
    TabButtons.Parent = MainFrame

    local TabButtonsCorner = Instance.new("UICorner")
    TabButtonsCorner.CornerRadius = UDim.new(0, 8)
    TabButtonsCorner.Parent = TabButtons

    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, -10, 1, -20)
    TabList.Position = UDim2.new(0, 5, 0, 10)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 4
    TabList.ScrollBarImageColor3 = colors.Accent
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.Parent = TabButtons

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Name = "TabLayout"
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabList

    -- Search box
    local SearchBox = Instance.new("TextBox")
    SearchBox.Name = "SearchBox"
    SearchBox.Size = UDim2.new(1, -20, 0, 30)
    SearchBox.Position = UDim2.new(0, 10, 0, 10)
    SearchBox.BackgroundColor3 = colors.Main
    SearchBox.TextColor3 = colors.Text
    SearchBox.PlaceholderColor3 = colors.DarkText
    SearchBox.PlaceholderText = "Search features..."
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextSize = 14
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.Parent = TabButtons

    local SearchBoxCorner = Instance.new("UICorner")
    SearchBoxCorner.CornerRadius = UDim.new(0, 6)
    SearchBoxCorner.Parent = SearchBox

    local SearchPadding = Instance.new("UIPadding")
    SearchPadding.PaddingLeft = UDim.new(0, 10)
    SearchPadding.Parent = SearchBox

    -- Tab content container
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.Size = UDim2.new(1, -160, 1, -50)
    TabContent.Position = UDim2.new(0, 155, 0, 45)
    TabContent.BackgroundTransparency = 1
    TabContent.Parent = MainFrame

    -- Dragging functionality
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
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

    -- Minimize functionality
    local minimized = false
    Minimize.MouseButton1Click:Connect(function()
        minimized = not minimized
        Tween(MainFrame, {
            Size = minimized and UDim2.new(0, 600, 0, 40) or UDim2.new(0, 600, 0, 450)
        }, 0.3, Enum.EasingStyle.Quad)
    end)

    -- UI toggle keybind
    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    -- Window object
    local window = {}
    window.currentTab = nil

    function window:Tab(name, icon)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = colors.Main
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabList

        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton

        local TabButtonHighlight = Instance.new("Frame")
        TabButtonHighlight.Name = "Highlight"
        TabButtonHighlight.Size = UDim2.new(0, 4, 1, -10)
        TabButtonHighlight.Position = UDim2.new(0, 3, 0.5, 0)
        TabButtonHighlight.AnchorPoint = Vector2.new(0, 0.5)
        TabButtonHighlight.BackgroundColor3 = colors.Accent
        TabButtonHighlight.BorderSizePixel = 0
        TabButtonHighlight.Visible = false
        TabButtonHighlight.Parent = TabButton

        local TabButtonCorner2 = Instance.new("UICorner")
        TabButtonCorner2.CornerRadius = UDim.new(0, 2)
        TabButtonCorner2.Parent = TabButtonHighlight

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Position = UDim2.new(0, 10, 0.5, 0)
        TabIcon.AnchorPoint = Vector2.new(0, 0.5)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = icon or "rbxassetid://3926305904"
        TabIcon.ImageColor3 = colors.Text
        TabIcon.Parent = TabButton

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.Size = UDim2.new(1, -40, 1, 0)
        TabLabel.Position = UDim2.new(0, 40, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.Font = Enum.Font.GothamSemibold
        TabLabel.TextColor3 = colors.Text
        TabLabel.TextSize = 14
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton

        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = name
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.ScrollBarThickness = 4
        TabFrame.ScrollBarImageColor3 = colors.Accent
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.Visible = false
        TabFrame.Parent = TabContent

        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Name = "Layout"
        TabLayout.Padding = UDim.new(0, 8)
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Parent = TabFrame

        TabButton.MouseButton1Click:Connect(function()
            if window.currentTab then
                -- Hide current tab
                window.currentTab[2].Visible = false
                window.currentTab[1].Highlight.Visible = false
                Tween(window.currentTab[1], {BackgroundColor3 = colors.Main}, 0.2)
            end
            
            -- Show new tab
            window.currentTab = {TabButton, TabFrame}
            TabFrame.Visible = true
            TabButtonHighlight.Visible = true
            Tween(TabButton, {BackgroundColor3 = colors.Secondary}, 0.2)
        end)

        -- Set first tab as default
        if not window.currentTab then
            window.currentTab = {TabButton, TabFrame}
            TabFrame.Visible = true
            TabButtonHighlight.Visible = true
            TabButton.BackgroundColor3 = colors.Secondary
        end

        -- Search functionality
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local searchText = string.lower(SearchBox.Text)
            if searchText == "" then
                TabButton.Visible = true
            else
                TabButton.Visible = string.find(string.lower(name), searchText) ~= nil
            end
        end)

        -- Update canvas size
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end)

        local tab = {}

        function tab:Section(title)
            local Section = Instance.new("Frame")
            Section.Name = "Section"
            Section.Size = UDim2.new(1, -10, 0, 40)
            Section.BackgroundColor3 = colors.Secondary
            Section.BorderSizePixel = 0
            Section.Parent = TabFrame

            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = Section

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, -40, 1, 0)
            SectionTitle.Position = UDim2.new(0, 15, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = title
            SectionTitle.Font = Enum.Font.GothamSemibold
            SectionTitle.TextColor3 = colors.Text
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = Section

            local SectionToggle = Instance.new("ImageButton")
            SectionToggle.Name = "Toggle"
            SectionToggle.Size = UDim2.new(0, 24, 0, 24)
            SectionToggle.Position = UDim2.new(1, -30, 0.5, 0)
            SectionToggle.AnchorPoint = Vector2.new(1, 0.5)
            SectionToggle.BackgroundTransparency = 1
            SectionToggle.Image = "rbxassetid://3926305904"
            SectionToggle.ImageRectOffset = Vector2.new(924, 724)
            SectionToggle.ImageRectSize = Vector2.new(36, 36)
            SectionToggle.ImageColor3 = colors.Text
            SectionToggle.Parent = Section

            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.Position = UDim2.new(0, 0, 0, 40)
            SectionContent.BackgroundTransparency = 1
            SectionContent.ClipsDescendants = true
            SectionContent.Parent = Section

            local SectionContentLayout = Instance.new("UIListLayout")
            SectionContentLayout.Name = "Layout"
            SectionContentLayout.Padding = UDim.new(0, 8)
            SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionContentLayout.Parent = SectionContent

            local expanded = true

            local function toggleSection()
                expanded = not expanded
                if expanded then
                    Section.Size = UDim2.new(1, -10, 0, 40 + SectionContentLayout.AbsoluteContentSize.Y)
                    SectionToggle.ImageRectOffset = Vector2.new(924, 724)
                else
                    Section.Size = UDim2.new(1, -10, 0, 40)
                    SectionToggle.ImageRectOffset = Vector2.new(964, 284)
                end
            end

            SectionToggle.MouseButton1Click:Connect(toggleSection)
            SectionTitle.MouseButton1Click:Connect(toggleSection)

            SectionContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if expanded then
                    Section.Size = UDim2.new(1, -10, 0, 40 + SectionContentLayout.AbsoluteContentSize.Y)
                end
            end)

            local section = {}

            function section:Button(text, callback)
                local Button = Instance.new("TextButton")
                Button.Name = "Button"
                Button.Size = UDim2.new(1, 0, 0, 36)
                Button.BackgroundColor3 = colors.Button
                Button.AutoButtonColor = false
                Button.Text = text
                Button.Font = Enum.Font.GothamSemibold
                Button.TextColor3 = colors.Text
                Button.TextSize = 14
                Button.Parent = SectionContent

                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = Button

                local ButtonStroke = Instance.new("UIStroke")
                ButtonStroke.Name = "Stroke"
                ButtonStroke.Color = colors.Accent
                ButtonStroke.Thickness = 1
                ButtonStroke.Transparency = 0.5
                ButtonStroke.Parent = Button

                Button.MouseEnter:Connect(function()
                    Tween(Button, {BackgroundColor3 = colors.ButtonHover}, 0.2)
                    Tween(ButtonStroke, {Transparency = 0}, 0.2)
                end)

                Button.MouseLeave:Connect(function()
                    Tween(Button, {BackgroundColor3 = colors.Button}, 0.2)
                    Tween(ButtonStroke, {Transparency = 0.5}, 0.2)
                end)

                Button.MouseButton1Click:Connect(function()
                    Ripple(Button, colors.Accent)
                    if callback then callback() end
                end)

                return Button
            end

            function section:Toggle(text, flag, default, callback)
                library.flags[flag] = default or false

                local Toggle = Instance.new("TextButton")
                Toggle.Name = "Toggle"
                Toggle.Size = UDim2.new(1, 0, 0, 36)
                Toggle.BackgroundColor3 = colors.Button
                Toggle.AutoButtonColor = false
                Toggle.Text = "  " .. text
                Toggle.Font = Enum.Font.GothamSemibold
                Toggle.TextColor3 = colors.Text
                Toggle.TextSize = 14
                Toggle.TextXAlignment = Enum.TextXAlignment.Left
                Toggle.Parent = SectionContent

                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 6)
                ToggleCorner.Parent = Toggle

                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Name = "Indicator"
                ToggleIndicator.Size = UDim2.new(0, 24, 0, 24)
                ToggleIndicator.Position = UDim2.new(1, -15, 0.5, 0)
                ToggleIndicator.AnchorPoint = Vector2.new(1, 0.5)
                ToggleIndicator.BackgroundColor3 = library.flags[flag] and colors.ToggleOn or colors.ToggleOff
                ToggleIndicator.Parent = Toggle

                local ToggleIndicatorCorner = Instance.new("UICorner")
                ToggleIndicatorCorner.CornerRadius = UDim.new(0, 12)
                ToggleIndicatorCorner.Parent = ToggleIndicator

                local ToggleIndicatorInner = Instance.new("Frame")
                ToggleIndicatorInner.Name = "Inner"
                ToggleIndicatorInner.Size = UDim2.new(0, 16, 0, 16)
                ToggleIndicatorInner.Position = UDim2.new(0.5, 0, 0.5, 0)
                ToggleIndicatorInner.AnchorPoint = Vector2.new(0.5, 0.5)
                ToggleIndicatorInner.BackgroundColor3 = colors.Main
                ToggleIndicatorInner.Parent = ToggleIndicator

                local ToggleIndicatorInnerCorner = Instance.new("UICorner")
                ToggleIndicatorInnerCorner.CornerRadius = UDim.new(0, 8)
                ToggleIndicatorInnerCorner.Parent = ToggleIndicatorInner

                local function updateToggle()
                    Tween(ToggleIndicator, {
                        BackgroundColor3 = library.flags[flag] and colors.ToggleOn or colors.ToggleOff
                    }, 0.2)
                    
                    if callback then callback(library.flags[flag]) end
                end

                Toggle.MouseButton1Click:Connect(function()
                    library.flags[flag] = not library.flags[flag]
                    updateToggle()
                end)

                if default then
                    updateToggle()
                end

                local toggle = {}
                function toggle:Set(value)
                    library.flags[flag] = value
                    updateToggle()
                end
                return toggle
            end

            function section:Slider(text, flag, min, max, default, callback)
                library.flags[flag] = default or min

                local Slider = Instance.new("Frame")
                Slider.Name = "Slider"
                Slider.Size = UDim2.new(1, 0, 0, 60)
                Slider.BackgroundTransparency = 1
                Slider.Parent = SectionContent

                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "Label"
                SliderLabel.Size = UDim2.new(1, 0, 0, 20)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = text
                SliderLabel.Font = Enum.Font.GothamSemibold
                SliderLabel.TextColor3 = colors.Text
                SliderLabel.TextSize = 14
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = Slider

                local SliderTrack = Instance.new("Frame")
                SliderTrack.Name = "Track"
                SliderTrack.Size = UDim2.new(1, 0, 0, 8)
                SliderTrack.Position = UDim2.new(0, 0, 0, 30)
                SliderTrack.BackgroundColor3 = colors.ToggleOff
                SliderTrack.Parent = Slider

                local SliderTrackCorner = Instance.new("UICorner")
                SliderTrackCorner.CornerRadius = UDim.new(0, 4)
                SliderTrackCorner.Parent = SliderTrack

                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.BackgroundColor3 = colors.Slider
                SliderFill.Parent = SliderTrack

                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(0, 4)
                SliderFillCorner.Parent = SliderFill

                local SliderValue = Instance.new("TextLabel")
                SliderValue.Name = "Value"
                SliderValue.Size = UDim2.new(0, 60, 0, 20)
                SliderValue.Position = UDim2.new(1, -60, 0, 0)
                SliderValue.BackgroundTransparency = 1
                SliderValue.Text = tostring(library.flags[flag])
                SliderValue.Font = Enum.Font.GothamSemibold
                SliderValue.TextColor3 = colors.Text
                SliderValue.TextSize = 14
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.Parent = SliderLabel

                local dragging = false

                local function setValue(value)
                    value = math.clamp(value, min, max)
                    library.flags[flag] = value
                    SliderValue.Text = tostring(value)
                    
                    local percent = (value - min) / (max - min)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    
                    if callback then callback(value) end
                end

                SliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        
                        local percent = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
                        setValue(math.floor(min + (max - min) * percent))
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
                        setValue(math.floor(min + (max - min) * percent))
                    end
                end)

                setValue(default or min)

                local slider = {}
                function slider:Set(value)
                    setValue(value)
                end
                return slider
            end

            function section:Dropdown(text, flag, options, callback)
                library.flags[flag] = nil

                local Dropdown = Instance.new("Frame")
                Dropdown.Name = "Dropdown"
                Dropdown.Size = UDim2.new(1, 0, 0, 36)
                Dropdown.BackgroundTransparency = 1
                Dropdown.ClipsDescendants = true
                Dropdown.Parent = SectionContent

                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "Button"
                DropdownButton.Size = UDim2.new(1, 0, 0, 36)
                DropdownButton.BackgroundColor3 = colors.Button
                DropdownButton.AutoButtonColor = false
                DropdownButton.Text = "  " .. text
                DropdownButton.Font = Enum.Font.GothamSemibold
                DropdownButton.TextColor3 = colors.Text
                DropdownButton.TextSize = 14
                DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                DropdownButton.Parent = Dropdown

                local DropdownButtonCorner = Instance.new("UICorner")
                DropdownButtonCorner.CornerRadius = UDim.new(0, 6)
                DropdownButtonCorner.Parent = DropdownButton

                local DropdownArrow = Instance.new("ImageLabel")
                DropdownArrow.Name = "Arrow"
                DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
                DropdownArrow.Position = UDim2.new(1, -15, 0.5, 0)
                DropdownArrow.AnchorPoint = Vector2.new(1, 0.5)
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Image = "rbxassetid://3926305904"
                DropdownArrow.ImageRectOffset = Vector2.new(964, 284)
                DropdownArrow.ImageRectSize = Vector2.new(36, 36)
                DropdownArrow.ImageColor3 = colors.Text
                DropdownArrow.Parent = DropdownButton

                local DropdownValue = Instance.new("TextLabel")
                DropdownValue.Name = "Value"
                DropdownValue.Size = UDim2.new(0, 100, 0, 20)
                DropdownValue.Position = UDim2.new(1, -40, 0.5, 0)
                DropdownValue.AnchorPoint = Vector2.new(1, 0.5)
                DropdownValue.BackgroundTransparency = 1
                DropdownValue.Text = "None"
                DropdownValue.Font = Enum.Font.Gotham
                DropdownValue.TextColor3 = colors.DarkText
                DropdownValue.TextSize = 14
                DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
                DropdownValue.Parent = DropdownButton

                local DropdownOptions = Instance.new("Frame")
                DropdownOptions.Name = "Options"
                DropdownOptions.Size = UDim2.new(1, 0, 0, 0)
                DropdownOptions.Position = UDim2.new(0, 0, 0, 40)
                DropdownOptions.BackgroundTransparency = 1
                DropdownOptions.ClipsDescendants = true
                DropdownOptions.Parent = Dropdown

                local DropdownOptionsLayout = Instance.new("UIListLayout")
                DropdownOptionsLayout.Name = "Layout"
                DropdownOptionsLayout.Padding = UDim.new(0, 5)
                DropdownOptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
                DropdownOptionsLayout.Parent = DropdownOptions

                local expanded = false

                local function toggleDropdown()
                    expanded = not expanded
                    if expanded then
                        Dropdown.Size = UDim2.new(1, 0, 0, 36 + DropdownOptionsLayout.AbsoluteContentSize.Y + 5)
                        DropdownArrow.ImageRectOffset = Vector2.new(924, 724)
                    else
                        Dropdown.Size = UDim2.new(1, 0, 0, 36)
                        DropdownArrow.ImageRectOffset = Vector2.new(964, 284)
                    end
                end

                DropdownButton.MouseButton1Click:Connect(toggleDropdown)

                local function addOption(option)
                    local Option = Instance.new("TextButton")
                    Option.Name = option
                    Option.Size = UDim2.new(1, 0, 0, 30)
                    Option.BackgroundColor3 = colors.Button
                    Option.AutoButtonColor = false
                    Option.Text = "  " .. option
                    Option.Font = Enum.Font.Gotham
                    Option.TextColor3 = colors.Text
                    Option.TextSize = 14
                    Option.TextXAlignment = Enum.TextXAlignment.Left
                    Option.Parent = DropdownOptions

                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 6)
                    OptionCorner.Parent = Option

                    Option.MouseButton1Click:Connect(function()
                        library.flags[flag] = option
                        DropdownValue.Text = option
                        DropdownValue.TextColor3 = colors.Text
                        toggleDropdown()
                        if callback then callback(option) end
                    end)

                    Option.MouseEnter:Connect(function()
                        Tween(Option, {BackgroundColor3 = colors.ButtonHover}, 0.2)
                    end)

                    Option.MouseLeave:Connect(function()
                        Tween(Option, {BackgroundColor3 = colors.Button}, 0.2)
                    end)
                end

                for _, option in pairs(options) do
                    addOption(option)
                end

                DropdownOptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    if expanded then
                        Dropdown.Size = UDim2.new(1, 0, 0, 36 + DropdownOptionsLayout.AbsoluteContentSize.Y + 5)
                    end
                end)

                local dropdown = {}
                function dropdown:Add(option)
                    addOption(option)
                end
                function dropdown:Remove(option)
                    local found = DropdownOptions:FindFirstChild(option)
                    if found then found:Destroy() end
                end
                function dropdown:Set(value)
                    if table.find(options, value) then
                        library.flags[flag] = value
                        DropdownValue.Text = value
                        DropdownValue.TextColor3 = colors.Text
                        if callback then callback(value) end
                    end
                end
                return dropdown
            end

            function section:Label(text)
                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.Font = Enum.Font.Gotham
                Label.TextColor3 = colors.Text
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = SectionContent

                return Label
            end

            return section
        end

        return tab
    end

    function window:Destroy()
        ScreenGui:Destroy()
    end

    return window
end

return library