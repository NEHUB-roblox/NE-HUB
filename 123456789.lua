repeat
    task.wait()
until game:IsLoaded()

local library = {}
local ToggleUI = false
library.currentTab = nil
library.flags = {}

local services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end,
})

local mouse = game:GetService("Players").LocalPlayer:GetMouse()

-- 颜色配置
local config = {
    MainColor = Color3.fromRGB(20, 20, 30),
    BgColor = Color3.fromRGB(15, 15, 25),
    TabColor = Color3.fromRGB(25, 25, 40),
    AccentColor = Color3.fromRGB(0, 180, 255),
    SecondaryColor = Color3.fromRGB(100, 200, 255),
    TextColor = Color3.fromRGB(240, 240, 255),
    DisabledColor = Color3.fromRGB(100, 100, 120),
    
    -- 控件颜色
    ButtonColor = Color3.fromRGB(30, 30, 50),
    ToggleOn = Color3.fromRGB(0, 200, 255),
    ToggleOff = Color3.fromRGB(50, 50, 70),
    SliderColor = Color3.fromRGB(0, 180, 255),
    DropdownColor = Color3.fromRGB(30, 30, 50),
    TextboxColor = Color3.fromRGB(30, 30, 50),
    KeybindColor = Color3.fromRGB(30, 30, 50),
    
    -- 边框效果
    BorderColor = Color3.fromRGB(0, 150, 255),
    GlowColor = Color3.fromRGB(0, 100, 255)
}

-- 动画函数
local function Tween(obj, t, data)
    game:GetService("TweenService")
        :Create(obj, TweenInfo.new(t[1], Enum.EasingStyle[t[2]], Enum.EasingDirection[t[3]]), data)
        :Play()
    return true
end

-- 水波纹效果
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
        Ripple.ImageColor3 = Color3.fromRGB(0, 180, 255)
        Ripple.Position = UDim2.new(
            (mouse.X - Ripple.AbsolutePosition.X) / obj.AbsoluteSize.X,
            0,
            (mouse.Y - Ripple.AbsolutePosition.Y) / obj.AbsoluteSize.Y,
            0
        )
        
        Tween(Ripple, {0.3, "Linear", "InOut"}, {
            Position = UDim2.new(-5.5, 0, -5.5, 0),
            Size = UDim2.new(12, 0, 12, 0)
        })
        
        wait(0.15)
        Tween(Ripple, {0.3, "Linear", "InOut"}, {ImageTransparency = 1})
        wait(0.3)
        Ripple:Destroy()
    end)
end

-- 标签切换功能
local switchingTabs = false
local function switchTab(new)
    if switchingTabs then return end
    
    local old = library.currentTab
    if old == nil then
        new[2].Visible = true
        library.currentTab = new
        Tween(new[1], {0.1, "Sine", "Out"}, {ImageColor3 = config.AccentColor})
        Tween(new[1].TabText, {0.1, "Sine", "Out"}, {TextColor3 = config.AccentColor})
        return
    end
    
    if old[1] == new[1] then return end
    
    switchingTabs = true
    library.currentTab = new
    
    Tween(old[1], {0.1, "Sine", "Out"}, {ImageColor3 = config.DisabledColor})
    Tween(new[1], {0.1, "Sine", "Out"}, {ImageColor3 = config.AccentColor})
    Tween(old[1].TabText, {0.1, "Sine", "Out"}, {TextColor3 = config.DisabledColor})
    Tween(new[1].TabText, {0.1, "Sine", "Out"}, {TextColor3 = config.AccentColor})
    
    old[2].Visible = false
    new[2].Visible = true
    
    task.wait(0.1)
    switchingTabs = false
end

-- 拖动功能
local function drag(frame, hold)
    if not hold then hold = frame end
    
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    
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
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- 创建UI库
function library.new(name)
    -- 清理旧UI
    for _, v in next, game:GetService("CoreGui"):GetChildren() do
        if v.Name == "ModernUI" then
            v:Destroy()
        end
    end

    -- 主UI框架
    local ModernUI = Instance.new("ScreenGui")
    ModernUI.Name = "ModernUI"
    ModernUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    if syn and syn.protect_gui then
        syn.protect_gui(ModernUI)
    end
    
    -- 主窗口
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Parent = ModernUI
    MainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
    MainWindow.BackgroundColor3 = config.MainColor
    MainWindow.BorderSizePixel = 0
    MainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainWindow.Size = UDim2.new(0, 600, 0, 400)
    MainWindow.ZIndex = 1
    MainWindow.Active = true
    
    -- 窗口圆角
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Name = "MainCorner"
    MainCorner.Parent = MainWindow
    
    -- 窗口发光效果
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.Parent = MainWindow
    Glow.BackgroundTransparency = 1
    Glow.BorderSizePixel = 0
    Glow.Size = UDim2.new(1, 20, 1, 20)
    Glow.Position = UDim2.new(0, -10, 0, -10)
    Glow.Image = "rbxassetid://5028857084"
    Glow.ImageColor3 = config.GlowColor
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(24, 24, 276, 276)
    Glow.ZIndex = 0
    
    -- 窗口标题栏
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainWindow
    TitleBar.BackgroundColor3 = config.MainColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Name = "TitleCorner"
    TitleCorner.Parent = TitleBar
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Parent = TitleBar
    TitleText.BackgroundTransparency = 1
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.Size = UDim2.new(0, 200, 1, 0)
    TitleText.Font = Enum.Font.GothamSemibold
    TitleText.Text = name or "Modern UI"
    TitleText.TextColor3 = config.TextColor
    TitleText.TextSize = 16
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 标题栏渐变效果
    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, config.AccentColor),
        ColorSequenceKeypoint.new(1, config.SecondaryColor)
    })
    TitleGradient.Rotation = 90
    TitleGradient.Parent = TitleText
    
    -- 最小化按钮
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TitleBar
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -30, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = config.TextColor
    MinimizeButton.TextSize = 18
    
    -- 搜索框
    local SearchBar = Instance.new("TextBox")
    SearchBar.Name = "SearchBar"
    SearchBar.Parent = TitleBar
    SearchBar.BackgroundColor3 = config.TabColor
    SearchBar.BackgroundTransparency = 0.5
    SearchBar.Position = UDim2.new(0.5, -100, 0.5, -12)
    SearchBar.Size = UDim2.new(0, 200, 0, 24)
    SearchBar.Font = Enum.Font.Gotham
    SearchBar.PlaceholderText = "搜索功能..."
    SearchBar.PlaceholderColor3 = Color3.fromRGB(150, 150, 180)
    SearchBar.Text = ""
    SearchBar.TextColor3 = config.TextColor
    SearchBar.TextSize = 14
    SearchBar.TextXAlignment = Enum.TextXAlignment.Left
    SearchBar.ClearTextOnFocus = false
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 12)
    SearchCorner.Parent = SearchBar
    
    local SearchPadding = Instance.new("UIPadding")
    SearchPadding.PaddingLeft = UDim.new(0, 10)
    SearchPadding.Parent = SearchBar
    
    -- 侧边栏
    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Parent = MainWindow
    SideBar.BackgroundColor3 = config.TabColor
    SideBar.BorderSizePixel = 0
    SideBar.Position = UDim2.new(0, 0, 0, 30)
    SideBar.Size = UDim2.new(0, 150, 1, -30)
    
    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 8)
    SideCorner.Parent = SideBar
    
    -- 标签按钮容器
    local TabButtons = Instance.new("ScrollingFrame")
    TabButtons.Name = "TabButtons"
    TabButtons.Parent = SideBar
    TabButtons.BackgroundTransparency = 1
    TabButtons.BorderSizePixel = 0
    TabButtons.Position = UDim2.new(0, 5, 0, 5)
    TabButtons.Size = UDim2.new(1, -10, 1, -10)
    TabButtons.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabButtons.ScrollBarThickness = 3
    TabButtons.ScrollBarImageColor3 = config.AccentColor
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Name = "TabListLayout"
    TabListLayout.Parent = TabButtons
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    
    -- 内容区域
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainWindow
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 155, 0, 35)
    ContentFrame.Size = UDim2.new(1, -160, 1, -40)
    
    -- 标签内容容器
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = ContentFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    
    -- 拖动功能
    drag(MainWindow, TitleBar)
    
    -- 最小化功能
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(MainWindow, {0.3, "Sine", "Out"}, {Size = UDim2.new(0, 600, 0, 30)})
            Tween(TitleCorner, {0.3, "Sine", "Out"}, {CornerRadius = UDim.new(0, 8)})
        else
            Tween(MainWindow, {0.3, "Sine", "Out"}, {Size = UDim2.new(0, 600, 0, 400)})
            Tween(TitleCorner, {0.3, "Sine", "Out"}, {CornerRadius = UDim.new(0, 8, 0, 0)})
        end
    end)
    
    -- 窗口功能
    local window = {}
    
    function window.Destroy()
        ModernUI:Destroy()
    end
    
    function window.Toggle()
        ModernUI.Enabled = not ModernUI.Enabled
    end
    
    -- 创建标签页
    function window.Tab(name, icon)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton_" .. name
        TabButton.Parent = TabButtons
        TabButton.BackgroundColor3 = config.TabColor
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.AutoButtonColor = false
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = ""
        TabButton.TextColor3 = config.DisabledColor
        TabButton.TextSize = 14
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "TabIcon"
        TabIcon.Parent = TabButton
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 10, 0.5, -8)
        TabIcon.Size = UDim2.new(0, 16, 0, 16)
        TabIcon.Image = "rbxassetid://" .. (icon or "6031091004")
        TabIcon.ImageColor3 = config.DisabledColor
        
        local TabText = Instance.new("TextLabel")
        TabText.Name = "TabText"
        TabText.Parent = TabButton
        TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(0, 35, 0, 0)
        TabText.Size = UDim2.new(1, -35, 1, 0)
        TabText.Font = Enum.Font.GothamSemibold
        TabText.Text = name
        TabText.TextColor3 = config.DisabledColor
        TabText.TextSize = 14
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        
        -- 标签内容
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. name
        TabContent.Parent = TabContainer
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = config.AccentColor
        
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Name = "TabContentLayout"
        TabContentLayout.Parent = TabContent
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 10)
        
        -- 更新滚动区域大小
        TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- 标签点击事件
        TabButton.MouseButton1Click:Connect(function()
            Ripple(TabButton)
            switchTab({TabButton, TabContent})
        end)
        
        -- 如果没有当前标签，设置为第一个标签
        if library.currentTab == nil then
            switchTab({TabButton, TabContent})
        end
        
        local tab = {}
        
        -- 创建分区
        function tab.Section(name, initiallyOpen)
            local Section = Instance.new("Frame")
            Section.Name = "Section_" .. name
            Section.Parent = TabContent
            Section.BackgroundColor3 = config.TabColor
            Section.BorderSizePixel = 0
            Section.Size = UDim2.new(1, 0, 0, 40)
            Section.ClipsDescendants = true
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = Section
            
            local SectionTitle = Instance.new("TextButton")
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Parent = Section
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Size = UDim2.new(1, 0, 0, 40)
            SectionTitle.Font = Enum.Font.GothamSemibold
            SectionTitle.Text = name
            SectionTitle.TextColor3 = config.TextColor
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local SectionPadding = Instance.new("UIPadding")
            SectionPadding.PaddingLeft = UDim.new(0, 15)
            SectionPadding.Parent = SectionTitle
            
            local SectionToggle = Instance.new("ImageButton")
            SectionToggle.Name = "SectionToggle"
            SectionToggle.Parent = SectionTitle
            SectionToggle.BackgroundTransparency = 1
            SectionToggle.Position = UDim2.new(1, -30, 0.5, -10)
            SectionToggle.Size = UDim2.new(0, 20, 0, 20)
            SectionToggle.Image = "rbxassetid://6031091004"
            SectionToggle.ImageColor3 = config.TextColor
            
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "SectionContent"
            SectionContent.Parent = Section
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 10, 0, 45)
            SectionContent.Size = UDim2.new(1, -20, 0, 0)
            
            local SectionContentLayout = Instance.new("UIListLayout")
            SectionContentLayout.Name = "SectionContentLayout"
            SectionContentLayout.Parent = SectionContent
            SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionContentLayout.Padding = UDim.new(0, 8)
            
            -- 更新分区大小
            local function updateSize()
                SectionContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    SectionContent.Size = UDim2.new(1, -20, 0, SectionContentLayout.AbsoluteContentSize.Y)
                    Section.Size = UDim2.new(1, 0, 0, open and 45 + SectionContentLayout.AbsoluteContentSize.Y or 40)
                end)
            end
            
            -- 切换分区状态
            local open = initiallyOpen or false
            SectionToggle.MouseButton1Click:Connect(function()
                open = not open
                Tween(SectionToggle, {0.2, "Sine", "Out"}, {
                    Rotation = open and 180 or 0,
                    ImageColor3 = open and config.AccentColor or config.TextColor
                })
                Tween(Section, {0.2, "Sine", "Out"}, {
                    Size = UDim2.new(1, 0, 0, open and 45 + SectionContentLayout.AbsoluteContentSize.Y or 40)
                })
            end)
            
            -- 初始状态
            if initiallyOpen then
                SectionToggle.Rotation = 180
                SectionToggle.ImageColor3 = config.AccentColor
            else
                Section.Size = UDim2.new(1, 0, 0, 40)
            end
            
            updateSize()
            
            local section = {}
            
            -- 按钮控件
            function section.Button(text, callback)
                local Button = Instance.new("TextButton")
                Button.Name = "Button_" .. text
                Button.Parent = SectionContent
                Button.BackgroundColor3 = config.ButtonColor
                Button.BorderSizePixel = 0
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.AutoButtonColor = false
                Button.Font = Enum.Font.GothamSemibold
                Button.Text = text
                Button.TextColor3 = config.TextColor
                Button.TextSize = 14
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = Button
                
                local ButtonStroke = Instance.new("UIStroke")
                ButtonStroke.Color = config.BorderColor
                ButtonStroke.Thickness = 1
                ButtonStroke.Parent = Button
                
                Button.MouseEnter:Connect(function()
                    Tween(Button, {0.2, "Sine", "Out"}, {BackgroundColor3 = Color3.fromRGB(40, 40, 60)})
                end)
                
                Button.MouseLeave:Connect(function()
                    Tween(Button, {0.2, "Sine", "Out"}, {BackgroundColor3 = config.ButtonColor})
                end)
                
                Button.MouseButton1Click:Connect(function()
                    Ripple(Button)
                    if callback then callback() end
                end)
                
                return Button
            end
            
            -- 开关控件
            function section.Toggle(text, flag, default, callback)
                library.flags[flag] = default or false
                
                local Toggle = Instance.new("Frame")
                Toggle.Name = "Toggle_" .. text
                Toggle.Parent = SectionContent
                Toggle.BackgroundTransparency = 1
                Toggle.Size = UDim2.new(1, 0, 0, 30)
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "ToggleLabel"
                ToggleLabel.Parent = Toggle
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.Text = text
                ToggleLabel.TextColor3 = config.TextColor
                ToggleLabel.TextSize = 14
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "ToggleButton"
                ToggleButton.Parent = Toggle
                ToggleButton.BackgroundColor3 = default and config.ToggleOn or config.ToggleOff
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Position = UDim2.new(1, -50, 0.5, -12)
                ToggleButton.Size = UDim2.new(0, 50, 0, 24)
                ToggleButton.AutoButtonColor = false
                ToggleButton.Text = ""
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 12)
                ToggleCorner.Parent = ToggleButton
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Name = "ToggleIndicator"
                ToggleIndicator.Parent = ToggleButton
                ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleIndicator.BorderSizePixel = 0
                ToggleIndicator.Position = default and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
                ToggleIndicator.Size = UDim2.new(0.5, 0, 1, 0)
                
                local IndicatorCorner = Instance.new("UICorner")
                IndicatorCorner.CornerRadius = UDim.new(0, 12)
                IndicatorCorner.Parent = ToggleIndicator
                
                ToggleButton.MouseButton1Click:Connect(function()
                    library.flags[flag] = not library.flags[flag]
                    if library.flags[flag] then
                        Tween(ToggleButton, {0.2, "Sine", "Out"}, {BackgroundColor3 = config.ToggleOn})
                        Tween(ToggleIndicator, {0.2, "Sine", "Out"}, {Position = UDim2.new(0.5, 0, 0, 0)})
                    else
                        Tween(ToggleButton, {0.2, "Sine", "Out"}, {BackgroundColor3 = config.ToggleOff})
                        Tween(ToggleIndicator, {0.2, "Sine", "Out"}, {Position = UDim2.new(0, 0, 0, 0)})
                    end
                    if callback then callback(library.flags[flag]) end
                end)
                
                local toggle = {}
                
                function toggle.SetState(self, state)
                    library.flags[flag] = state
                    if state then
                        ToggleButton.BackgroundColor3 = config.ToggleOn
                        ToggleIndicator.Position = UDim2.new(0.5, 0, 0, 0)
                    else
                        ToggleButton.BackgroundColor3 = config.ToggleOff
                        ToggleIndicator.Position = UDim2.new(0, 0, 0, 0)
                    end
                    if callback then callback(state) end
                end
                
                return toggle
            end
            
            -- 滑块控件
            function section.Slider(text, flag, min, max, default, callback)
                library.flags[flag] = default or min
                
                local Slider = Instance.new("Frame")
                Slider.Name = "Slider_" .. text
                Slider.Parent = SectionContent
                Slider.BackgroundTransparency = 1
                Slider.Size = UDim2.new(1, 0, 0, 50)
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "SliderLabel"
                SliderLabel.Parent = Slider
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Size = UDim2.new(1, 0, 0, 20)
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.Text = text
                SliderLabel.TextColor3 = config.TextColor
                SliderLabel.TextSize = 14
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local SliderValue = Instance.new("TextBox")
                SliderValue.Name = "SliderValue"
                SliderValue.Parent = Slider
                SliderValue.BackgroundColor3 = config.TabColor
                SliderValue.BorderSizePixel = 0
                SliderValue.Position = UDim2.new(1, -60, 0, 0)
                SliderValue.Size = UDim2.new(0, 60, 0, 20)
                SliderValue.Font = Enum.Font.Gotham
                SliderValue.Text = tostring(default or min)
                SliderValue.TextColor3 = config.TextColor
                SliderValue.TextSize = 14
                
                local ValueCorner = Instance.new("UICorner")
                ValueCorner.CornerRadius = UDim.new(0, 4)
                ValueCorner.Parent = SliderValue
                
                local SliderTrack = Instance.new("Frame")
                SliderTrack.Name = "SliderTrack"
                SliderTrack.Parent = Slider
                SliderTrack.BackgroundColor3 = config.TabColor
                SliderTrack.BorderSizePixel = 0
                SliderTrack.Position = UDim2.new(0, 0, 0, 30)
                SliderTrack.Size = UDim2.new(1, 0, 0, 10)
                
                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(0, 5)
                TrackCorner.Parent = SliderTrack
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "SliderFill"
                SliderFill.Parent = SliderTrack
                SliderFill.BackgroundColor3 = config.SliderColor
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(0, 5)
                FillCorner.Parent = SliderFill
                
                local SliderButton = Instance.new("TextButton")
                SliderButton.Name = "SliderButton"
                SliderButton.Parent = SliderFill
                SliderButton.BackgroundTransparency = 1
                SliderButton.Size = UDim2.new(0, 20, 1, 0)
                SliderButton.Position = UDim2.new(1, -10, 0, 0)
                SliderButton.Text = ""
                
                local dragging = false
                
                local function setValue(value)
                    value = math.clamp(value, min, max)
                    library.flags[flag] = value
                    SliderValue.Text = tostring(math.floor(value))
                    SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    if callback then callback(value) end
                end
                
                SliderButton.MouseButton1Down:Connect(function()
                    dragging = true
                end)
                
                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
                        setValue(min + (max - min) * math.clamp(percent, 0, 1))
                    end
                end)
                
                SliderValue.FocusLost:Connect(function()
                    local num = tonumber(SliderValue.Text)
                    if num then
                        setValue(num)
                    else
                        SliderValue.Text = tostring(library.flags[flag])
                    end
                end)
                
                setValue(default or min)
                
                local slider = {}
                
                function slider.SetValue(self, value)
                    setValue(value)
                end
                
                return slider
            end
            
            -- 下拉菜单
            function section.Dropdown(text, flag, options, callback)
                library.flags[flag] = nil
                
                local Dropdown = Instance.new("Frame")
                Dropdown.Name = "Dropdown_" .. text
                Dropdown.Parent = SectionContent
                Dropdown.BackgroundTransparency = 1
                Dropdown.Size = UDim2.new(1, 0, 0, 30)
                Dropdown.ClipsDescendants = true
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "DropdownButton"
                DropdownButton.Parent = Dropdown
                DropdownButton.BackgroundColor3 = config.DropdownColor
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Size = UDim2.new(1, 0, 0, 30)
                DropdownButton.AutoButtonColor = false
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.Text = text
                DropdownButton.TextColor3 = config.TextColor
                DropdownButton.TextSize = 14
                DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = DropdownButton
                
                local DropdownArrow = Instance.new("ImageLabel")
                DropdownArrow.Name = "DropdownArrow"
                DropdownArrow.Parent = DropdownButton
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Position = UDim2.new(1, -25, 0.5, -8)
                DropdownArrow.Size = UDim2.new(0, 16, 0, 16)
                DropdownArrow.Image = "rbxassetid://6031091004"
                DropdownArrow.ImageColor3 = config.TextColor
                DropdownArrow.Rotation = 90
                
                local DropdownPadding = Instance.new("UIPadding")
                DropdownPadding.PaddingLeft = UDim.new(0, 10)
                DropdownPadding.Parent = DropdownButton
                
                local DropdownOptions = Instance.new("Frame")
                DropdownOptions.Name = "DropdownOptions"
                DropdownOptions.Parent = Dropdown
                DropdownOptions.BackgroundTransparency = 1
                DropdownOptions.Position = UDim2.new(0, 0, 0, 35)
                DropdownOptions.Size = UDim2.new(1, 0, 0, 0)
                
                local OptionsLayout = Instance.new("UIListLayout")
                OptionsLayout.Name = "OptionsLayout"
                OptionsLayout.Parent = DropdownOptions
                OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
                OptionsLayout.Padding = UDim.new(0, 5)
                
                local open = false
                
                local function toggleDropdown()
                    open = not open
                    if open then
                        Tween(DropdownArrow, {0.2, "Sine", "Out"}, {Rotation = 270})
                        Tween(Dropdown, {0.2, "Sine", "Out"}, {
                            Size = UDim2.new(1, 0, 0, 35 + OptionsLayout.AbsoluteContentSize.Y + 5)
                        })
                    else
                        Tween(DropdownArrow, {0.2, "Sine", "Out"}, {Rotation = 90})
                        Tween(Dropdown, {0.2, "Sine", "Out"}, {Size = UDim2.new(1, 0, 0, 30)})
                    end
                end
                
                DropdownButton.MouseButton1Click:Connect(toggleDropdown)
                
                OptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    if open then
                        Dropdown.Size = UDim2.new(1, 0, 0, 35 + OptionsLayout.AbsoluteContentSize.Y + 5)
                    end
                end)
                
                local function addOption(option)
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = "Option_" .. option
                    OptionButton.Parent = DropdownOptions
                    OptionButton.BackgroundColor3 = config.TabColor
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Size = UDim2.new(1, 0, 0, 30)
                    OptionButton.AutoButtonColor = false
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Text = option
                    OptionButton.TextColor3 = config.TextColor
                    OptionButton.TextSize = 14
                    
                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 6)
                    OptionCorner.Parent = OptionButton
                    
                    OptionButton.MouseEnter:Connect(function()
                        Tween(OptionButton, {0.2, "Sine", "Out"}, {BackgroundColor3 = Color3.fromRGB(40, 40, 60)})
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        Tween(OptionButton, {0.2, "Sine", "Out"}, {BackgroundColor3 = config.TabColor})
                    end)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        library.flags[flag] = option
                        DropdownButton.Text = text .. ": " .. option
                        toggleDropdown()
                        if callback then callback(option) end
                    end)
                end
                
                for _, option in pairs(options) do
                    addOption(option)
                end
                
                local dropdown = {}
                
                function dropdown.AddOption(self, option)
                    addOption(option)
                end
                
                function dropdown.RemoveOption(self, option)
                    local opt = DropdownOptions:FindFirstChild("Option_" .. option)
                    if opt then opt:Destroy() end
                end
                
                function dropdown.SetOptions(self, newOptions)
                    for _, child in pairs(DropdownOptions:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for _, option in pairs(newOptions) do
                        addOption(option)
                    end
                end
                
                return dropdown
            end
            
            -- 文本框
            function section.Textbox(text, flag, placeholder, default, callback)
                library.flags[flag] = default or ""
                
                local Textbox = Instance.new("Frame")
                Textbox.Name = "Textbox_" .. text
                Textbox.Parent = SectionContent
                Textbox.BackgroundTransparency = 1
                Textbox.Size = UDim2.new(1, 0, 0, 50)
                
                local TextboxLabel = Instance.new("TextLabel")
                TextboxLabel.Name = "TextboxLabel"
                TextboxLabel.Parent = Textbox
                TextboxLabel.BackgroundTransparency = 1
                TextboxLabel.Size = UDim2.new(1, 0, 0, 20)
                TextboxLabel.Font = Enum.Font.Gotham
                TextboxLabel.Text = text
                TextboxLabel.TextColor3 = config.TextColor
                TextboxLabel.TextSize = 14
                TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local InputBox = Instance.new("TextBox")
                InputBox.Name = "InputBox"
                InputBox.Parent = Textbox
                InputBox.BackgroundColor3 = config.TextboxColor
                InputBox.BorderSizePixel = 0
                InputBox.Position = UDim2.new(0, 0, 0, 25)
                InputBox.Size = UDim2.new(1, 0, 0, 25)
                InputBox.Font = Enum.Font.Gotham
                InputBox.PlaceholderText = placeholder or "输入..."
                InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 180)
                InputBox.Text = default or ""
                InputBox.TextColor3 = config.TextColor
                InputBox.TextSize = 14
                InputBox.ClearTextOnFocus = false
                
                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 6)
                InputCorner.Parent = InputBox
                
                local InputPadding = Instance.new("UIPadding")
                InputPadding.PaddingLeft = UDim.new(0, 10)
                InputPadding.PaddingRight = UDim.new(0, 10)
                InputPadding.Parent = InputBox
                
                InputBox.FocusLost:Connect(function()
                    library.flags[flag] = InputBox.Text
                    if callback then callback(InputBox.Text) end
                end)
                
                local textbox = {}
                
                function textbox.SetText(self, text)
                    InputBox.Text = text
                    library.flags[flag] = text
                end
                
                return textbox
            end
            
            -- 标签控件
            function section.Label(text)
                local Label = Instance.new("TextLabel")
                Label.Name = "Label_" .. text
                Label.Parent = SectionContent
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.Font = Enum.Font.Gotham
                Label.Text = text
                Label.TextColor3 = config.TextColor
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                
                return Label
            end
            
            return section
        end
        
        return tab
    end
    
    -- 搜索功能
    local function searchFeatures(text)
        text = text:lower()
        
        for _, tab in pairs(TabContainer:GetChildren()) do
            if tab:IsA("ScrollingFrame") then
                for _, section in pairs(tab:GetChildren()) do
                    if section:IsA("Frame") and section.Name:match("Section_") then
                        local found = false
                        
                        for _, element in pairs(section.SectionContent:GetChildren()) do
                            if element:IsA("Frame") then
                                local elementName = ""
                                
                                if element.Name:match("Button_") then
                                    elementName = element.Button.Text
                                elseif element.Name:match("Toggle_") then
                                    elementName = element.ToggleLabel.Text
                                elseif element.Name:match("Slider_") then
                                    elementName = element.SliderLabel.Text
                                elseif element.Name:match("Dropdown_") then
                                    elementName = element.DropdownButton.Text
                                elseif element.Name:match("Textbox_") then
                                    elementName = element.TextboxLabel.Text
                                elseif element.Name:match("Label_") then
                                    elementName = element.Text
                                end
                                
                                if elementName:lower():find(text) then
                                    found = true
                                    element.Visible = true
                                else
                                    element.Visible = false
                                end
                            end
                        end
                        
                        -- 如果找到匹配项，展开分区
                        if found then
                            section.SectionToggle.Rotation = 180
                            section.SectionToggle.ImageColor3 = config.AccentColor
                            section.Size = UDim2.new(1, 0, 0, 45 + section.SectionContent.SectionContentLayout.AbsoluteContentSize.Y)
                        end
                    end
                end
            end
        end
    end
    
    SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
        if SearchBar.Text == "" then
            -- 重置所有元素可见性
            for _, tab in pairs(TabContainer:GetChildren()) do
                if tab:IsA("ScrollingFrame") then
                    for _, section in pairs(tab:GetChildren()) do
                        if section:IsA("Frame") and section.Name:match("Section_") then
                            for _, element in pairs(section.SectionContent:GetChildren()) do
                                if element:IsA("Frame") then
                                    element.Visible = true
                                end
                            end
                        end
                    end
                end
            end
        else
            searchFeatures(SearchBar.Text)
        end
    end)
    
    ModernUI.Parent = game:GetService("CoreGui")
    
    return window
end

return library