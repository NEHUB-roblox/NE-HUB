local library = {}
local ToggleUI = false
library.currentTab = nil
library.flags = {}
library.searchTerm = ""

local services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end,
})

local mouse = game:GetService("Players").LocalPlayer:GetMouse()

-- Color configuration with modern gradient scheme
local config = {
    MainColor = Color3.fromRGB(30, 30, 40),
    TabColor = Color3.fromRGB(40, 40, 50),
    Bg_Color = Color3.fromRGB(25, 25, 35),
    AccentColor = Color3.fromRGB(100, 200, 255),
    
    Button_Color = Color3.fromRGB(45, 45, 60),
    Textbox_Color = Color3.fromRGB(45, 45, 60),
    Dropdown_Color = Color3.fromRGB(45, 45, 60),
    Keybind_Color = Color3.fromRGB(45, 45, 60),
    Label_Color = Color3.fromRGB(45, 45, 60),
    
    Slider_Color = Color3.fromRGB(45, 45, 60),
    SliderBar_Color = Color3.fromRGB(100, 200, 255),
    
    Toggle_Color = Color3.fromRGB(45, 45, 60),
    Toggle_Off = Color3.fromRGB(80, 80, 100),
    Toggle_On = Color3.fromRGB(100, 200, 255),
    
    SearchBox_Color = Color3.fromRGB(40, 40, 55),
    SearchText_Color = Color3.fromRGB(200, 220, 255),
    
    Border_Color = Color3.fromRGB(100, 200, 255),
}

-- Helper functions
function Tween(obj, t, data)
    game:GetService("TweenService")
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
        Ripple.ImageColor3 = config.AccentColor
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

function library.new(name)
    -- Clean up any existing UI
    for _, v in next, game:GetService("CoreGui"):GetChildren() do
        if v.Name == "PandaUILib" then
            v:Destroy()
        end
    end

    -- Main UI Container
    local PandaUI = Instance.new("ScreenGui")
    PandaUI.Name = "PandaUILib"
    PandaUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if syn and syn.protect_gui then
        syn.protect_gui(PandaUI)
    end
    PandaUI.Parent = game:GetService("CoreGui")

    -- Main Window Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = PandaUI
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = config.MainColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.ZIndex = 1
    MainFrame.Active = true
    
    -- Add border effect
    local Border = Instance.new("Frame")
    Border.Name = "Border"
    Border.Parent = MainFrame
    Border.BackgroundColor3 = config.Border_Color
    Border.BorderSizePixel = 0
    Border.Size = UDim2.new(1, 6, 1, 6)
    Border.Position = UDim2.new(0, -3, 0, -3)
    Border.ZIndex = 0
    
    local BorderCorner = Instance.new("UICorner")
    BorderCorner.CornerRadius = UDim.new(0, 8)
    BorderCorner.Name = "BorderCorner"
    BorderCorner.Parent = Border
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Name = "MainCorner"
    MainCorner.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = config.TabColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Parent = TitleBar
    TitleText.BackgroundTransparency = 1
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.Size = UDim2.new(0, 200, 1, 0)
    TitleText.Font = Enum.Font.GothamSemibold
    TitleText.Text = name or "Panda UI"
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextSize = 16
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TitleBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    
    CloseButton.MouseButton1Click:Connect(function()
        PandaUI:Destroy()
    end)
    
    -- Search Box
    local SearchBox = Instance.new("Frame")
    SearchBox.Name = "SearchBox"
    SearchBox.Parent = MainFrame
    SearchBox.BackgroundColor3 = config.SearchBox_Color
    SearchBox.BorderSizePixel = 0
    SearchBox.Position = UDim2.new(0, 10, 0, 40)
    SearchBox.Size = UDim2.new(1, -20, 0, 30)
    
    local SearchBoxCorner = Instance.new("UICorner")
    SearchBoxCorner.CornerRadius = UDim.new(0, 6)
    SearchBoxCorner.Parent = SearchBox
    
    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Name = "SearchIcon"
    SearchIcon.Parent = SearchBox
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Position = UDim2.new(0, 8, 0, 5)
    SearchIcon.Size = UDim2.new(0, 20, 0, 20)
    SearchIcon.Image = "rbxassetid://3926305904"
    SearchIcon.ImageRectOffset = Vector2.new(964, 324)
    SearchIcon.ImageRectSize = Vector2.new(36, 36)
    SearchIcon.ImageColor3 = config.SearchText_Color
    
    local SearchInput = Instance.new("TextBox")
    SearchInput.Name = "SearchInput"
    SearchInput.Parent = SearchBox
    SearchInput.BackgroundTransparency = 1
    SearchInput.Position = UDim2.new(0, 35, 0, 0)
    SearchInput.Size = UDim2.new(1, -35, 1, 0)
    SearchInput.Font = Enum.Font.Gotham
    SearchInput.PlaceholderText = "Search features..."
    SearchInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 180)
    SearchInput.Text = ""
    SearchInput.TextColor3 = config.SearchText_Color
    SearchInput.TextSize = 14
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Tab System
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 10, 0, 80)
    TabContainer.Size = UDim2.new(1, -20, 1, -90)
    
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Parent = TabContainer
    TabButtons.BackgroundTransparency = 1
    TabButtons.Size = UDim2.new(0, 120, 1, 0)
    
    local TabButtonsLayout = Instance.new("UIListLayout")
    TabButtonsLayout.Name = "TabButtonsLayout"
    TabButtonsLayout.Parent = TabButtons
    TabButtonsLayout.Padding = UDim.new(0, 5)
    
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.Parent = TabContainer
    TabContent.BackgroundColor3 = config.TabColor
    TabContent.BorderSizePixel = 0
    TabContent.Position = UDim2.new(0, 130, 0, 0)
    TabContent.Size = UDim2.new(1, -130, 1, 0)
    
    local TabContentCorner = Instance.new("UICorner")
    TabContentCorner.CornerRadius = UDim.new(0, 6)
    TabContentCorner.Parent = TabContent
    
    local TabContentScrolling = Instance.new("ScrollingFrame")
    TabContentScrolling.Name = "TabContentScrolling"
    TabContentScrolling.Parent = TabContent
    TabContentScrolling.BackgroundTransparency = 1
    TabContentScrolling.BorderSizePixel = 0
    TabContentScrolling.Size = UDim2.new(1, -10, 1, -10)
    TabContentScrolling.Position = UDim2.new(0, 5, 0, 5)
    TabContentScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContentScrolling.ScrollBarThickness = 5
    TabContentScrolling.ScrollBarImageColor3 = config.AccentColor
    
    local TabContentLayout = Instance.new("UIListLayout")
    TabContentLayout.Name = "TabContentLayout"
    TabContentLayout.Parent = TabContentScrolling
    TabContentLayout.Padding = UDim.new(0, 10)
    
    -- Make window draggable
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
    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        library.searchTerm = SearchInput.Text:lower()
        
        -- Search through all controls in the current tab
        local currentTab = library.currentTab
        if currentTab then
            for _, section in pairs(currentTab:GetDescendants()) do
                if section:IsA("TextButton") or section:IsA("TextLabel") then
                    local text = section.Text:lower()
                    if text:find(library.searchTerm) then
                        section.Visible = true
                        if section.Parent and section.Parent:IsA("Frame") then
                            section.Parent.Visible = true
                        end
                    else
                        section.Visible = false
                        if section.Parent and section.Parent:IsA("Frame") then
                            section.Parent.Visible = false
                        end
                    end
                end
            end
        end
    end)
    
    -- Window functions
    function PandaUI:Toggle()
        PandaUI.Enabled = not PandaUI.Enabled
    end
    
    function PandaUI:Destroy()
        PandaUI:Destroy()
    end
    
    -- Tab management
    local window = {}
    function window:Tab(name, icon)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "TabButton"
        TabButton.Parent = TabButtons
        TabButton.BackgroundColor3 = config.TabColor
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.AutoButtonColor = false
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = "   " .. name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 220)
        TabButton.TextSize = 14
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        if icon then
            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Name = "TabIcon"
            TabIcon.Parent = TabButton
            TabIcon.BackgroundTransparency = 1
            TabIcon.Position = UDim2.new(0, 10, 0.5, -12)
            TabIcon.Size = UDim2.new(0, 24, 0, 24)
            TabIcon.Image = "rbxassetid://" .. tostring(icon)
            TabIcon.ImageColor3 = Color3.fromRGB(200, 220, 255)
        end
        
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = name .. "TabFrame"
        TabFrame.Parent = TabContentScrolling
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel = 0
        TabFrame.Size = UDim2.new(1, 0, 0, 0)
        TabFrame.Visible = false
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.ScrollBarThickness = 0
        
        local TabFrameLayout = Instance.new("UIListLayout")
        TabFrameLayout.Name = "TabFrameLayout"
        TabFrameLayout.Parent = TabFrame
        TabFrameLayout.Padding = UDim.new(0, 10)
        
        TabFrameLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabFrameLayout.AbsoluteContentSize.Y)
            TabFrame.Size = UDim2.new(1, 0, 0, math.min(TabFrameLayout.AbsoluteContentSize.Y, TabContentScrolling.AbsoluteSize.Y))
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, child in pairs(TabContentScrolling:GetChildren()) do
                if child:IsA("ScrollingFrame") and child.Name:match("TabFrame") then
                    child.Visible = false
                end
            end
            
            -- Reset all tab buttons
            for _, child in pairs(TabButtons:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = config.TabColor
                    child.TextColor3 = Color3.fromRGB(200, 200, 220)
                end
            end
            
            -- Show selected tab
            TabFrame.Visible = true
            TabButton.BackgroundColor3 = config.AccentColor
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            library.currentTab = TabFrame
        end)
        
        -- Select first tab by default
        if #TabButtons:GetChildren() == 1 then
            TabButton.BackgroundColor3 = config.AccentColor
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabFrame.Visible = true
            library.currentTab = TabFrame
        end
        
        local tab = {}
        
        function tab:Section(name)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name .. "Section"
            SectionFrame.Parent = TabFrame
            SectionFrame.BackgroundColor3 = config.Bg_Color
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = SectionFrame
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Parent = SectionFrame
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 15, 0, 10)
            SectionTitle.Size = UDim2.new(1, -30, 0, 20)
            SectionTitle.Font = Enum.Font.GothamSemibold
            SectionTitle.Text = name
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "SectionContent"
            SectionContent.Parent = SectionFrame
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 10, 0, 40)
            SectionContent.Size = UDim2.new(1, -20, 0, 0)
            
            local SectionContentLayout = Instance.new("UIListLayout")
            SectionContentLayout.Name = "SectionContentLayout"
            SectionContentLayout.Parent = SectionContent
            SectionContentLayout.Padding = UDim.new(0, 10)
            
            SectionContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionContent.Size = UDim2.new(1, -20, 0, SectionContentLayout.AbsoluteContentSize.Y)
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionContentLayout.AbsoluteContentSize.Y + 50)
            end)
            
            local section = {}
            
            function section:Button(text, callback)
                local ButtonFrame = Instance.new("Frame")
                ButtonFrame.Name = text .. "Button"
                ButtonFrame.Parent = SectionContent
                ButtonFrame.BackgroundTransparency = 1
                ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
                
                local Button = Instance.new("TextButton")
                Button.Name = "Button"
                Button.Parent = ButtonFrame
                Button.BackgroundColor3 = config.Button_Color
                Button.BorderSizePixel = 0
                Button.Size = UDim2.new(1, 0, 0, 40)
                Button.AutoButtonColor = false
                Button.Font = Enum.Font.GothamSemibold
                Button.Text = "  " .. text
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 14
                Button.TextXAlignment = Enum.TextXAlignment.Left
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = Button
                
                local ButtonStroke = Instance.new("UIStroke")
                ButtonStroke.Parent = Button
                ButtonStroke.Color = config.AccentColor
                ButtonStroke.Thickness = 1
                ButtonStroke.Transparency = 0.7
                
                Button.MouseButton1Click:Connect(function()
                    Ripple(Button)
                    if callback then
                        callback()
                    end
                end)
                
                return Button
            end
            
            function section:Toggle(text, flag, default, callback)
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = text .. "Toggle"
                ToggleFrame.Parent = SectionContent
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
                
                local Toggle = Instance.new("TextButton")
                Toggle.Name = "Toggle"
                Toggle.Parent = ToggleFrame
                Toggle.BackgroundColor3 = config.Toggle_Color
                Toggle.BorderSizePixel = 0
                Toggle.Size = UDim2.new(1, 0, 0, 40)
                Toggle.AutoButtonColor = false
                Toggle.Font = Enum.Font.GothamSemibold
                Toggle.Text = "  " .. text
                Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
                Toggle.TextSize = 14
                Toggle.TextXAlignment = Enum.TextXAlignment.Left
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 6)
                ToggleCorner.Parent = Toggle
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Name = "ToggleIndicator"
                ToggleIndicator.Parent = Toggle
                ToggleIndicator.BackgroundColor3 = default and config.Toggle_On or config.Toggle_Off
                ToggleIndicator.BorderSizePixel = 0
                ToggleIndicator.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleIndicator.Size = UDim2.new(0, 40, 0, 20)
                
                local ToggleIndicatorCorner = Instance.new("UICorner")
                ToggleIndicatorCorner.CornerRadius = UDim.new(1, 0)
                ToggleIndicatorCorner.Parent = ToggleIndicator
                
                local ToggleDot = Instance.new("Frame")
                ToggleDot.Name = "ToggleDot"
                ToggleDot.Parent = ToggleIndicator
                ToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleDot.BorderSizePixel = 0
                ToggleDot.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                ToggleDot.Size = UDim2.new(0, 16, 0, 16)
                
                local ToggleDotCorner = Instance.new("UICorner")
                ToggleDotCorner.CornerRadius = UDim.new(1, 0)
                ToggleDotCorner.Parent = ToggleDot
                
                local state = default or false
                library.flags[flag] = state
                
                local function updateToggle()
                    Tween(ToggleDot, {0.2, "Quad", "Out"}, {
                        Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    })
                    ToggleIndicator.BackgroundColor3 = state and config.Toggle_On or config.Toggle_Off
                    
                    if callback then
                        callback(state)
                    end
                end
                
                Toggle.MouseButton1Click:Connect(function()
                    state = not state
                    library.flags[flag] = state
                    updateToggle()
                end)
                
                local toggleFuncs = {}
                
                function toggleFuncs:SetValue(value)
                    state = value
                    library.flags[flag] = state
                    updateToggle()
                end
                
                return toggleFuncs
            end
            
            function section:Slider(text, flag, min, max, default, callback)
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = text .. "Slider"
                SliderFrame.Parent = SectionContent
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Size = UDim2.new(1, 0, 0, 60)
                
                local SliderTitle = Instance.new("TextLabel")
                SliderTitle.Name = "SliderTitle"
                SliderTitle.Parent = SliderFrame
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 0, 0, 0)
                SliderTitle.Size = UDim2.new(1, 0, 0, 20)
                SliderTitle.Font = Enum.Font.GothamSemibold
                SliderTitle.Text = "  " .. text
                SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderTitle.TextSize = 14
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local SliderBack = Instance.new("Frame")
                SliderBack.Name = "SliderBack"
                SliderBack.Parent = SliderFrame
                SliderBack.BackgroundColor3 = config.Slider_Color
                SliderBack.BorderSizePixel = 0
                SliderBack.Position = UDim2.new(0, 10, 0, 30)
                SliderBack.Size = UDim2.new(1, -20, 0, 10)
                
                local SliderBackCorner = Instance.new("UICorner")
                SliderBackCorner.CornerRadius = UDim.new(1, 0)
                SliderBackCorner.Parent = SliderBack
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "SliderFill"
                SliderFill.Parent = SliderBack
                SliderFill.BackgroundColor3 = config.SliderBar_Color
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(1, 0)
                SliderFillCorner.Parent = SliderFill
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Name = "SliderValue"
                SliderValue.Parent = SliderFrame
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(1, -60, 0, 0)
                SliderValue.Size = UDim2.new(0, 50, 0, 20)
                SliderValue.Font = Enum.Font.Gotham
                SliderValue.Text = tostring(default or min)
                SliderValue.TextColor3 = Color3.fromRGB(200, 220, 255)
                SliderValue.TextSize = 14
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                
                local value = default or min
                library.flags[flag] = value
                
                local function setValue(newValue)
                    value = math.clamp(newValue, min, max)
                    local percent = (value - min) / (max - min)
                    
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    SliderValue.Text = tostring(math.floor(value))
                    library.flags[flag] = value
                    
                    if callback then
                        callback(value)
                    end
                end
                
                setValue(value)
                
                local dragging = false
                
                SliderBack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local percent = (input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X
                        setValue(min + (max - min) * percent)
                    end
                end)
                
                SliderBack.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = (input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X
                        setValue(min + (max - min) * percent)
                    end
                end)
                
                local sliderFuncs = {}
                
                function sliderFuncs:SetValue(newValue)
                    setValue(newValue)
                end
                
                return sliderFuncs
            end
            
            function section:Dropdown(text, flag, options, callback)
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = text .. "Dropdown"
                DropdownFrame.Parent = SectionContent
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "DropdownButton"
                DropdownButton.Parent = DropdownFrame
                DropdownButton.BackgroundColor3 = config.Dropdown_Color
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Size = UDim2.new(1, 0, 0, 40)
                DropdownButton.AutoButtonColor = false
                DropdownButton.Font = Enum.Font.GothamSemibold
                DropdownButton.Text = "  " .. text
                DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                DropdownButton.TextSize = 14
                DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 6)
                DropdownCorner.Parent = DropdownButton
                
                local DropdownArrow = Instance.new("ImageLabel")
                DropdownArrow.Name = "DropdownArrow"
                DropdownArrow.Parent = DropdownButton
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Position = UDim2.new(1, -30, 0.5, -10)
                DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
                DropdownArrow.Image = "rbxassetid://3926305904"
                DropdownArrow.ImageRectOffset = Vector2.new(884, 284)
                DropdownArrow.ImageRectSize = Vector2.new(36, 36)
                DropdownArrow.ImageColor3 = Color3.fromRGB(200, 220, 255)
                
                local DropdownValue = Instance.new("TextLabel")
                DropdownValue.Name = "DropdownValue"
                DropdownValue.Parent = DropdownButton
                DropdownValue.BackgroundTransparency = 1
                DropdownValue.Position = UDim2.new(1, -60, 0, 0)
                DropdownValue.Size = UDim2.new(0, 50, 1, 0)
                DropdownValue.Font = Enum.Font.Gotham
                DropdownValue.Text = "None"
                DropdownValue.TextColor3 = Color3.fromRGB(200, 220, 255)
                DropdownValue.TextSize = 14
                DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
                
                local DropdownOptions = Instance.new("Frame")
                DropdownOptions.Name = "DropdownOptions"
                DropdownOptions.Parent = DropdownFrame
                DropdownOptions.BackgroundColor3 = config.Dropdown_Color
                DropdownOptions.BorderSizePixel = 0
                DropdownOptions.Position = UDim2.new(0, 0, 1, 5)
                DropdownOptions.Size = UDim2.new(1, 0, 0, 0)
                DropdownOptions.Visible = false
                DropdownOptions.ClipsDescendants = true
                
                local DropdownOptionsCorner = Instance.new("UICorner")
                DropdownOptionsCorner.CornerRadius = UDim.new(0, 6)
                DropdownOptionsCorner.Parent = DropdownOptions
                
                local DropdownOptionsLayout = Instance.new("UIListLayout")
                DropdownOptionsLayout.Name = "DropdownOptionsLayout"
                DropdownOptionsLayout.Parent = DropdownOptions
                DropdownOptionsLayout.Padding = UDim.new(0, 5)
                
                DropdownOptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    DropdownOptions.Size = UDim2.new(1, 0, 0, DropdownOptionsLayout.AbsoluteContentSize.Y + 10)
                end)
                
                local function toggleDropdown()
                    DropdownOptions.Visible = not DropdownOptions.Visible
                    DropdownArrow.Rotation = DropdownOptions.Visible and 180 or 0
                end
                
                DropdownButton.MouseButton1Click:Connect(toggleDropdown)
                
                local selected = nil
                library.flags[flag] = nil
                
                local function selectOption(option)
                    selected = option
                    DropdownValue.Text = option
                    library.flags[flag] = option
                    toggleDropdown()
                    
                    if callback then
                        callback(option)
                    end
                end
                
                local function addOption(option)
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = option .. "Option"
                    OptionButton.Parent = DropdownOptions
                    OptionButton.BackgroundColor3 = config.Bg_Color
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Size = UDim2.new(1, -10, 0, 30)
                    OptionButton.Position = UDim2.new(0, 5, 0, 0)
                    OptionButton.AutoButtonColor = false
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    OptionButton.TextSize = 14
                    
                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 4)
                    OptionCorner.Parent = OptionButton
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        selectOption(option)
                    end)
                end
                
                for _, option in pairs(options) do
                    addOption(option)
                end
                
                local dropdownFuncs = {}
                
                function dropdownFuncs:AddOption(option)
                    addOption(option)
                end
                
                function dropdownFuncs:RemoveOption(option)
                    local optionFrame = DropdownOptions:FindFirstChild(option .. "Option")
                    if optionFrame then
                        optionFrame:Destroy()
                    end
                end
                
                function dropdownFuncs:SetOptions(newOptions)
                    for _, child in pairs(DropdownOptions:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for _, option in pairs(newOptions) do
                        addOption(option)
                    end
                end
                
                function dropdownFuncs:SetValue(value)
                    if table.find(options, value) then
                        selectOption(value)
                    end
                end
                
                return dropdownFuncs
            end
            
            return section
        end
        
        return tab
    end
    
    return window
end

return library