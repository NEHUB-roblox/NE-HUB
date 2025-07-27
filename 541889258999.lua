local library = {}

repeat task.wait() until game:IsLoaded()

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Variables
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local dragging, dragInput, dragStart, startPos
local library = {currentTab = nil, flags = {}, toggled = true}

-- Utility Functions
local function Tween(obj, props, duration, style, direction)
    TweenService:Create(obj, TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), props):Play()
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
        Ripple.BackgroundTransparency = 0.8
        Ripple.ZIndex = 8
        Ripple.Size = UDim2.new(0, 0, 0, 0)
        Ripple.Position = UDim2.new(
            (mouse.X - Ripple.AbsolutePosition.X) / obj.AbsoluteSize.X,
            0,
            (mouse.Y - Ripple.AbsolutePosition.Y) / obj.AbsoluteSize.Y,
            0
        )
        Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = Ripple
        
        Tween(Ripple, {Size = UDim2.new(2, 0, 2, 0), 0.6, "Quad", "Out")
        Tween(Ripple, {BackgroundTransparency = 1}, 0.6, "Quad", "Out")
        
        wait(0.6)
        Ripple:Destroy()
    end)
end

local function drag(frame, hold)
    hold = hold or frame
    
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
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Color Config
local config = {
    MainColor = Color3.fromRGB(20, 20, 30),
    TabColor = Color3.fromRGB(30, 30, 45),
    AccentColor = Color3.fromRGB(0, 180, 255),
    TextColor = Color3.fromRGB(240, 240, 240),
    DarkText = Color3.fromRGB(50, 50, 50),
    
    -- Element Colors
    ButtonColor = Color3.fromRGB(40, 40, 60),
    ToggleOn = Color3.fromRGB(0, 200, 255),
    ToggleOff = Color3.fromRGB(60, 60, 80),
    SliderBar = Color3.fromRGB(0, 180, 255),
    SliderTrack = Color3.fromRGB(50, 50, 70),
    DropdownColor = Color3.fromRGB(40, 40, 60),
    TextboxColor = Color3.fromRGB(40, 40, 60),
    
    -- Modern Gradient
    Gradient1 = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
    }),
    
    -- Border Effects
    GlowColor = Color3.fromRGB(0, 150, 255),
    BorderSize = 2
}

-- Main UI Creation
function library.new(name)
    -- Cleanup old UI
    for _, v in next, CoreGui:GetChildren() do
        if v.Name == "NeonUI" then
            v:Destroy()
        end
    end

    -- Main UI Container
    local NeonUI = Instance.new("ScreenGui")
    NeonUI.Name = "NeonUI"
    NeonUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    if syn and syn.protect_gui then
        syn.protect_gui(NeonUI)
    end
    NeonUI.Parent = CoreGui

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.BackgroundColor3 = config.MainColor
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Parent = NeonUI
    
    -- Modern Corner
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Main
    
    -- Glow Effect
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.BackgroundTransparency = 1
    Glow.Size = UDim2.new(1, 20, 1, 20)
    Glow.Position = UDim2.new(0, -10, 0, -10)
    Glow.ZIndex = -1
    Glow.Image = "rbxassetid://5028857084"
    Glow.ImageColor3 = config.GlowColor
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(24, 24, 276, 276)
    Glow.Parent = Main
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = config.TabColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Parent = Main
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Name = "TitleCorner"
    TitleCorner.Parent = TitleBar
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.BackgroundTransparency = 1
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.Size = UDim2.new(0, 200, 1, 0)
    TitleText.Font = Enum.Font.GothamSemibold
    TitleText.Text = name or "Neon UI"
    TitleText.TextColor3 = config.TextColor
    TitleText.TextSize = 14
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Size = UDim2.new(0, 30, 1, 0)
    MinimizeBtn.Position = UDim2.new(1, -30, 0, 0)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = config.TextColor
    MinimizeBtn.TextSize = 18
    MinimizeBtn.Parent = TitleBar
    
    -- Search Box
    local SearchBox = Instance.new("TextBox")
    SearchBox.Name = "SearchBox"
    SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    SearchBox.BorderSizePixel = 0
    SearchBox.Position = UDim2.new(0, 220, 0, 5)
    SearchBox.Size = UDim2.new(0, 200, 0, 20)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.PlaceholderText = "Search features..."
    SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    SearchBox.Text = ""
    SearchBox.TextColor3 = config.TextColor
    SearchBox.TextSize = 12
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.Parent = TitleBar
    
    local SearchPadding = Instance.new("UIPadding")
    SearchPadding.PaddingLeft = UDim.new(0, 8)
    SearchPadding.Parent = SearchBox
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 4)
    SearchCorner.Parent = SearchBox
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundColor3 = config.TabColor
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.Size = UDim2.new(0, 120, 1, -30)
    TabContainer.Parent = Main
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabContainer
    
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.Size = UDim2.new(1, 0, 1, -40)
    TabList.Position = UDim2.new(0, 0, 0, 40)
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.ScrollBarThickness = 4
    TabList.ScrollBarImageColor3 = config.AccentColor
    TabList.Parent = TabContainer
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Name = "TabLayout"
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabList
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 125, 0, 35)
    ContentContainer.Size = UDim2.new(1, -130, 1, -40)
    ContentContainer.Parent = Main
    
    -- Tab Content Container
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.Parent = ContentContainer
    
    -- Search Results Container
    local SearchContent = Instance.new("ScrollingFrame")
    SearchContent.Name = "SearchContent"
    SearchContent.BackgroundTransparency = 1
    SearchContent.Size = UDim2.new(1, 0, 1, 0)
    SearchContent.Visible = false
    SearchContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    SearchContent.ScrollBarThickness = 4
    SearchContent.ScrollBarImageColor3 = config.AccentColor
    SearchContent.Parent = ContentContainer
    
    local SearchLayout = Instance.new("UIListLayout")
    SearchLayout.Name = "SearchLayout"
    SearchLayout.Padding = UDim.new(0, 5)
    SearchLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SearchLayout.Parent = SearchContent
    
    -- Make draggable
    drag(Main, TitleBar)
    
    -- Minimize functionality
    MinimizeBtn.MouseButton1Click:Connect(function()
        library.toggled = not library.toggled
        if library.toggled then
            Tween(Main, {Size = UDim2.new(0, 600, 0, 400)}, 0.3, "Quad", "Out")
            MinimizeBtn.Text = "-"
        else
            Tween(Main, {Size = UDim2.new(0, 600, 0, 30)}, 0.3, "Quad", "Out")
            MinimizeBtn.Text = "+"
        end
    end)
    
    -- Search functionality
    local searchDebounce = false
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        if searchDebounce then return end
        searchDebounce = true
        
        local searchText = SearchBox.Text:lower()
        if searchText == "" then
            TabContent.Visible = true
            SearchContent.Visible = false
        else
            TabContent.Visible = false
            SearchContent.Visible = true
            
            -- Clear previous search results
            for _, child in ipairs(SearchContent:GetChildren()) do
                if child:IsA("Frame") and child.Name == "SearchItem" then
                    child:Destroy()
                end
            end
            
            -- Search through all elements
            for _, tab in ipairs(TabContent:GetChildren()) do
                if tab:IsA("ScrollingFrame") then
                    for _, section in ipairs(tab:GetChildren()) do
                        if section:IsA("Frame") and section.Name == "Section" then
                            for _, element in ipairs(section:GetChildren()) do
                                if element:IsA("Frame") and element:FindFirstChild("TextLabel") then
                                    local text = element.TextLabel.Text:lower()
                                    if text:find(searchText) then
                                        local clone = element:Clone()
                                        clone.Name = "SearchItem"
                                        clone.Parent = SearchContent
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
        searchDebounce = false
    end)
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
    end)
    
    SearchLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SearchContent.CanvasSize = UDim2.new(0, 0, 0, SearchLayout.AbsoluteContentSize.Y)
    end)
    
    -- Window API
    local window = {}
    
    function window:Toggle()
        NeonUI.Enabled = not NeonUI.Enabled
    end
    
    function window:Tab(name, icon)
        icon = icon or "rbxassetid://3926305904"
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, -10, 0, 30)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = "   "..name
        TabButton.TextColor3 = config.TextColor
        TabButton.TextSize = 14
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabList
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabButton
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.BackgroundTransparency = 1
        TabIcon.Size = UDim2.new(0, 16, 0, 16)
        TabIcon.Position = UDim2.new(0, 8, 0.5, -8)
        TabIcon.Image = icon
        TabIcon.ImageColor3 = config.TextColor
        TabIcon.Parent = TabButton
        
        -- Tab Content
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = name
        TabFrame.BackgroundTransparency = 1
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.ScrollBarThickness = 4
        TabFrame.ScrollBarImageColor3 = config.AccentColor
        TabFrame.Visible = false
        TabFrame.Parent = TabContent
        
        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Name = "Layout"
        TabLayout.Padding = UDim.new(0, 5)
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Parent = TabFrame
        
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end)
        
        -- Tab Selection
        TabButton.MouseButton1Click:Connect(function()
            Ripple(TabButton)
            
            -- Hide all tabs
            for _, tab in ipairs(TabContent:GetChildren()) do
                if tab:IsA("ScrollingFrame") then
                    tab.Visible = false
                end
            end
            
            -- Reset all buttons
            for _, btn in ipairs(TabList:GetChildren()) do
                if btn:IsA("TextButton") then
                    Tween(btn, {BackgroundColor3 = Color3.fromRGB(40, 40, 60)})
                    Tween(btn.Icon, {ImageColor3 = config.TextColor})
                end
            end
            
            -- Show selected tab
            TabFrame.Visible = true
            
            -- Highlight button
            Tween(TabButton, {BackgroundColor3 = config.AccentColor})
            Tween(TabIcon, {ImageColor3 = Color3.fromRGB(255, 255, 255)})
            
            library.currentTab = TabFrame
        end)
        
        -- Select first tab
        if library.currentTab == nil then
            TabButton.BackgroundColor3 = config.AccentColor
            TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            TabFrame.Visible = true
            library.currentTab = TabFrame
        end
        
        -- Tab API
        local tab = {}
        
        function tab:Section(name)
            local Section = Instance.new("Frame")
            Section.Name = "Section"
            Section.BackgroundColor3 = config.TabColor
            Section.BorderSizePixel = 0
            Section.Size = UDim2.new(1, 0, 0, 0)
            Section.AutomaticSize = Enum.AutomaticSize.Y
            Section.Parent = TabFrame
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = Section
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Size = UDim2.new(1, -10, 0, 30)
            SectionTitle.Position = UDim2.new(0, 10, 0, 5)
            SectionTitle.Font = Enum.Font.GothamSemibold
            SectionTitle.Text = name
            SectionTitle.TextColor3 = config.TextColor
            SectionTitle.TextSize = 14
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = Section
            
            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.Name = "Layout"
            SectionLayout.Padding = UDim.new(0, 5)
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionLayout.Parent = Section
            
            SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Section.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y + 10)
            end)
            
            -- Section API
            local section = {}
            
            function section:Button(text, callback)
                callback = callback or function() end
                
                local Button = Instance.new("Frame")
                Button.Name = "Button"
                Button.BackgroundTransparency = 1
                Button.Size = UDim2.new(1, -10, 0, 30)
                Button.Position = UDim2.new(0, 5, 0, 0)
                Button.Parent = Section
                
                local ButtonBtn = Instance.new("TextButton")
                ButtonBtn.Name = "ButtonBtn"
                ButtonBtn.BackgroundColor3 = config.ButtonColor
                ButtonBtn.Size = UDim2.new(1, 0, 1, 0)
                ButtonBtn.Font = Enum.Font.Gotham
                ButtonBtn.Text = text
                ButtonBtn.TextColor3 = config.TextColor
                ButtonBtn.TextSize = 14
                ButtonBtn.AutoButtonColor = false
                ButtonBtn.Parent = Button
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = ButtonBtn
                
                ButtonBtn.MouseButton1Click:Connect(function()
                    Ripple(ButtonBtn)
                    callback()
                end)
                
                ButtonBtn.MouseEnter:Connect(function()
                    Tween(ButtonBtn, {BackgroundColor3 = Color3.fromRGB(
                        math.floor(config.ButtonColor.R * 255 + 10),
                        math.floor(config.ButtonColor.G * 255 + 10),
                        math.floor(config.ButtonColor.B * 255 + 10)
                    )})
                end)
                
                ButtonBtn.MouseLeave:Connect(function()
                    Tween(ButtonBtn, {BackgroundColor3 = config.ButtonColor})
                end)
            end
            
            function section:Toggle(text, flag, default, callback)
                callback = callback or function() end
                default = default or false
                library.flags[flag] = default
                
                local Toggle = Instance.new("Frame")
                Toggle.Name = "Toggle"
                Toggle.BackgroundTransparency = 1
                Toggle.Size = UDim2.new(1, -10, 0, 30)
                Toggle.Position = UDim2.new(0, 5, 0, 0)
                Toggle.Parent = Section
                
                local ToggleText = Instance.new("TextLabel")
                ToggleText.Name = "TextLabel"
                ToggleText.BackgroundTransparency = 1
                ToggleText.Size = UDim2.new(0.7, 0, 1, 0)
                ToggleText.Font = Enum.Font.Gotham
                ToggleText.Text = text
                ToggleText.TextColor3 = config.TextColor
                ToggleText.TextSize = 14
                ToggleText.TextXAlignment = Enum.TextXAlignment.Left
                ToggleText.Parent = Toggle
                
                local ToggleBtn = Instance.new("Frame")
                ToggleBtn.Name = "ToggleBtn"
                ToggleBtn.BackgroundColor3 = config.ToggleOff
                ToggleBtn.Size = UDim2.new(0, 50, 0, 20)
                ToggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleBtn.Parent = Toggle
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 10)
                ToggleCorner.Parent = ToggleBtn
                
                local ToggleInner = Instance.new("Frame")
                ToggleInner.Name = "ToggleInner"
                ToggleInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleInner.Size = UDim2.new(0, 16, 0, 16)
                ToggleInner.Position = UDim2.new(0, 2, 0.5, -8)
                ToggleInner.Parent = ToggleBtn
                
                local ToggleInnerCorner = Instance.new("UICorner")
                ToggleInnerCorner.CornerRadius = UDim.new(0, 8)
                ToggleInnerCorner.Parent = ToggleInner
                
                if default then
                    ToggleBtn.BackgroundColor3 = config.ToggleOn
                    ToggleInner.Position = UDim2.new(1, -18, 0.5, -8)
                end
                
                local function SetState(state)
                    state = state or not library.flags[flag]
                    library.flags[flag] = state
                    
                    if state then
                        Tween(ToggleBtn, {BackgroundColor3 = config.ToggleOn})
                        Tween(ToggleInner, {Position = UDim2.new(1, -18, 0.5, -8)})
                    else
                        Tween(ToggleBtn, {BackgroundColor3 = config.ToggleOff})
                        Tween(ToggleInner, {Position = UDim2.new(0, 2, 0.5, -8)})
                    end
                    
                    callback(state)
                end
                
                ToggleBtn.MouseButton1Click:Connect(function()
                    SetState()
                end)
                
                return {
                    SetState = SetState
                }
            end
            
            function section:Slider(text, flag, min, max, default, callback)
                callback = callback or function() end
                min = min or 0
                max = max or 100
                default = default or min
                library.flags[flag] = default
                
                local Slider = Instance.new("Frame")
                Slider.Name = "Slider"
                Slider.BackgroundTransparency = 1
                Slider.Size = UDim2.new(1, -10, 0, 50)
                Slider.Position = UDim2.new(0, 5, 0, 0)
                Slider.Parent = Section
                
                local SliderText = Instance.new("TextLabel")
                SliderText.Name = "TextLabel"
                SliderText.BackgroundTransparency = 1
                SliderText.Size = UDim2.new(1, 0, 0, 20)
                SliderText.Font = Enum.Font.Gotham
                SliderText.Text = text
                SliderText.TextColor3 = config.TextColor
                SliderText.TextSize = 14
                SliderText.TextXAlignment = Enum.TextXAlignment.Left
                SliderText.Parent = Slider
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Name = "Value"
                SliderValue.BackgroundTransparency = 1
                SliderValue.Size = UDim2.new(0, 60, 0, 20)
                SliderValue.Position = UDim2.new(1, -60, 0, 0)
                SliderValue.Font = Enum.Font.Gotham
                SliderValue.Text = tostring(default)
                SliderValue.TextColor3 = config.TextColor
                SliderValue.TextSize = 14
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.Parent = Slider
                
                local SliderTrack = Instance.new("Frame")
                SliderTrack.Name = "Track"
                SliderTrack.BackgroundColor3 = config.SliderTrack
                SliderTrack.Size = UDim2.new(1, 0, 0, 5)
                SliderTrack.Position = UDim2.new(0, 0, 0, 25)
                SliderTrack.Parent = Slider
                
                local SliderTrackCorner = Instance.new("UICorner")
                SliderTrackCorner.CornerRadius = UDim.new(0, 3)
                SliderTrackCorner.Parent = SliderTrack
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.BackgroundColor3 = config.SliderBar
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                SliderFill.Parent = SliderTrack
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(0, 3)
                SliderFillCorner.Parent = SliderFill
                
                local SliderButton = Instance.new("TextButton")
                SliderButton.Name = "Button"
                SliderButton.BackgroundTransparency = 1
                SliderButton.Size = UDim2.new(1, 0, 0, 20)
                SliderButton.Position = UDim2.new(0, 0, 0, 25)
                SliderButton.Text = ""
                SliderButton.Parent = Slider
                
                local dragging = false
                
                local function SetValue(value)
                    value = math.clamp(value, min, max)
                    local percent = (value - min) / (max - min)
                    
                    library.flags[flag] = value
                    SliderValue.Text = tostring(math.floor(value))
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    
                    callback(value)
                end
                
                SliderButton.MouseButton1Down:Connect(function()
                    dragging = true
                    local percent = (mouse.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
                    SetValue(min + (max - min) * percent)
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = (mouse.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
                        SetValue(min + (max - min) * percent)
                    end
                end)
                
                return {
                    SetValue = SetValue
                }
            end
            
            function section:Dropdown(text, flag, options, callback)
                callback = callback or function() end
                options = options or {}
                library.flags[flag] = nil
                
                local Dropdown = Instance.new("Frame")
                Dropdown.Name = "Dropdown"
                Dropdown.BackgroundTransparency = 1
                Dropdown.Size = UDim2.new(1, -10, 0, 30)
                Dropdown.Position = UDim2.new(0, 5, 0, 0)
                Dropdown.Parent = Section
                
                local DropdownBtn = Instance.new("TextButton")
                DropdownBtn.Name = "Button"
                DropdownBtn.BackgroundColor3 = config.DropdownColor
                DropdownBtn.Size = UDim2.new(1, 0, 0, 30)
                DropdownBtn.Font = Enum.Font.Gotham
                DropdownBtn.Text = text
                DropdownBtn.TextColor3 = config.TextColor
                DropdownBtn.TextSize = 14
                DropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
                DropdownBtn.AutoButtonColor = false
                DropdownBtn.Parent = Dropdown
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 4)
                DropdownCorner.Parent = DropdownBtn
                
                local DropdownArrow = Instance.new("ImageLabel")
                DropdownArrow.Name = "Arrow"
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Size = UDim2.new(0, 16, 0, 16)
                DropdownArrow.Position = UDim2.new(1, -20, 0.5, -8)
                DropdownArrow.Image = "rbxassetid://3926305904"
                DropdownArrow.ImageRectOffset = Vector2.new(324, 364)
                DropdownArrow.ImageRectSize = Vector2.new(36, 36)
                DropdownArrow.ImageColor3 = config.TextColor
                DropdownArrow.Parent = DropdownBtn
                
                local DropdownContainer = Instance.new("Frame")
                DropdownContainer.Name = "Container"
                DropdownContainer.BackgroundColor3 = config.DropdownColor
                DropdownContainer.BorderSizePixel = 0
                DropdownContainer.Position = UDim2.new(0, 0, 1, 5)
                DropdownContainer.Size = UDim2.new(1, 0, 0, 0)
                DropdownContainer.Visible = false
                DropdownContainer.Parent = Dropdown
                
                local DropdownContainerCorner = Instance.new("UICorner")
                DropdownContainerCorner.CornerRadius = UDim.new(0, 4)
                DropdownContainerCorner.Parent = DropdownContainer
                
                local DropdownLayout = Instance.new("UIListLayout")
                DropdownLayout.Name = "Layout"
                DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
                DropdownLayout.Padding = UDim.new(0, 2)
                DropdownLayout.Parent = DropdownContainer
                
                DropdownLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    DropdownContainer.Size = UDim2.new(1, 0, 0, DropdownLayout.AbsoluteContentSize.Y)
                end)
                
                local function ToggleDropdown()
                    DropdownContainer.Visible = not DropdownContainer.Visible
                    
                    if DropdownContainer.Visible then
                        Tween(DropdownArrow, {Rotation = 180})
                    else
                        Tween(DropdownArrow, {Rotation = 0})
                    end
                end
                
                local function AddOption(option)
                    local Option = Instance.new("TextButton")
                    Option.Name = "Option"
                    Option.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                    Option.BorderSizePixel = 0
                    Option.Size = UDim2.new(1, -10, 0, 25)
                    Option.Position = UDim2.new(0, 5, 0, 0)
                    Option.Font = Enum.Font.Gotham
                    Option.Text = option
                    Option.TextColor3 = config.TextColor
                    Option.TextSize = 14
                    Option.AutoButtonColor = false
                    Option.Parent = DropdownContainer
                    
                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 4)
                    OptionCorner.Parent = Option
                    
                    Option.MouseButton1Click:Connect(function()
                        Ripple(Option)
                        DropdownBtn.Text = text..": "..option
                        library.flags[flag] = option
                        callback(option)
                        ToggleDropdown()
                    end)
                    
                    Option.MouseEnter:Connect(function()
                        Tween(Option, {BackgroundColor3 = Color3.fromRGB(60, 60, 80)})
                    end)
                    
                    Option.MouseLeave:Connect(function()
                        Tween(Option, {BackgroundColor3 = Color3.fromRGB(50, 50, 70)})
                    end)
                end
                
                for _, option in pairs(options) do
                    AddOption(option)
                end
                
                DropdownBtn.MouseButton1Click:Connect(function()
                    Ripple(DropdownBtn)
                    ToggleDropdown()
                end)
                
                return {
                    AddOption = function(self, option)
                        AddOption(option)
                    end,
                    RemoveOption = function(self, option)
                        for _, child in ipairs(DropdownContainer:GetChildren()) do
                            if child:IsA("TextButton") and child.Text == option then
                                child:Destroy()
                                break
                            end
                        end
                    end,
                    SetOptions = function(self, newOptions)
                        for _, child in ipairs(DropdownContainer:GetChildren()) do
                            if child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end
                        
                        for _, option in pairs(newOptions) do
                            AddOption(option)
                        end
                    end
                }
            end
            
            function section:Textbox(text, flag, placeholder, callback)
                callback = callback or function() end
                placeholder = placeholder or ""
                library.flags[flag] = ""
                
                local Textbox = Instance.new("Frame")
                Textbox.Name = "Textbox"
                Textbox.BackgroundTransparency = 1
                Textbox.Size = UDim2.new(1, -10, 0, 30)
                Textbox.Position = UDim2.new(0, 5, 0, 0)
                Textbox.Parent = Section
                
                local TextboxBox = Instance.new("TextBox")
                TextboxBox.Name = "Box"
                TextboxBox.BackgroundColor3 = config.TextboxColor
                TextboxBox.BorderSizePixel = 0
                TextboxBox.Size = UDim2.new(1, 0, 1, 0)
                TextboxBox.Font = Enum.Font.Gotham
                TextboxBox.Text = ""
                TextboxBox.PlaceholderText = placeholder
                TextboxBox.TextColor3 = config.TextColor
                TextboxBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
                TextboxBox.TextSize = 14
                TextboxBox.TextXAlignment = Enum.TextXAlignment.Left
                TextboxBox.Parent = Textbox
                
                local TextboxCorner = Instance.new("UICorner")
                TextboxCorner.CornerRadius = UDim.new(0, 4)
                TextboxCorner.Parent = TextboxBox
                
                local TextboxPadding = Instance.new("UIPadding")
                TextboxPadding.PaddingLeft = UDim.new(0, 8)
                TextboxPadding.Parent = TextboxBox
                
                TextboxBox.FocusLost:Connect(function()
                    library.flags[flag] = TextboxBox.Text
                    callback(TextboxBox.Text)
                end)
            end
            
            function section:Label(text)
                local Label = Instance.new("Frame")
                Label.Name = "Label"
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, -10, 0, 20)
                Label.Position = UDim2.new(0, 5, 0, 0)
                Label.Parent = Section
                
                local LabelText = Instance.new("TextLabel")
                LabelText.Name = "TextLabel"
                LabelText.BackgroundTransparency = 1
                LabelText.Size = UDim2.new(1, 0, 1, 0)
                LabelText.Font = Enum.Font.Gotham
                LabelText.Text = text
                LabelText.TextColor3 = config.TextColor
                LabelText.TextSize = 14
                LabelText.TextXAlignment = Enum.TextXAlignment.Left
                LabelText.Parent = Label
                
                return LabelText
            end
            
            return section
        end
        
        return tab
    end
    
    return window
end

return library