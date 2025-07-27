local library = {}

-- 等待游戏加载完成
repeat task.wait() until game:IsLoaded()

-- 配置
local config = {
    MainColor = Color3.fromRGB(20, 20, 30),
    BgColor = Color3.fromRGB(15, 15, 25),
    AccentColor = Color3.fromRGB(0, 180, 255),
    SecondaryColor = Color3.fromRGB(40, 40, 50),
    TextColor = Color3.fromRGB(240, 240, 240),
    DisabledColor = Color3.fromRGB(100, 100, 110),
    SuccessColor = Color3.fromRGB(0, 200, 100),
    WarningColor = Color3.fromRGB(255, 150, 0),
    ErrorColor = Color3.fromRGB(255, 50, 50),
    BorderSize = 1,
    CornerRadius = UDim.new(0, 8),
    AnimationSpeed = 0.25
}

-- 服务
local services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end
})

local tweenService = services.TweenService
local userInputService = services.UserInputService
local runService = services.RunService
local players = services.Players
local mouse = players.LocalPlayer:GetMouse()

-- 辅助函数
local function tween(object, properties, duration, easingStyle, easingDirection)
    local info = TweenInfo.new(
        duration or config.AnimationSpeed,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = tweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

local function createRipple(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "RippleEffect"
    ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    ripple.BackgroundTransparency = 0.8
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.ZIndex = 10
    ripple.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    local buttonPos = button.AbsolutePosition
    local buttonSize = button.AbsoluteSize
    
    local center = Vector2.new(
        (mousePos.X - buttonPos.X) / buttonSize.X,
        (mousePos.Y - buttonPos.Y) / buttonSize.Y
    )
    
    ripple.Position = UDim2.new(center.X, 0, center.Y, 0)
    
    local maxSize = math.max(buttonSize.X, buttonSize.Y) * 2.5
    
    tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1,
        Position = UDim2.new(center.X, -maxSize/2, center.Y, -maxSize/2)
    }, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    game.Debris:AddItem(ripple, 0.5)
end

local function createGlowEffect(frame)
    local glow = Instance.new("ImageLabel")
    glow.Name = "GlowEffect"
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = config.AccentColor
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(24, 24, 24, 24)
    glow.BackgroundTransparency = 1
    glow.Size = UDim2.new(1, 12, 1, 12)
    glow.Position = UDim2.new(0, -6, 0, -6)
    glow.ZIndex = -1
    glow.Parent = frame
    
    local transparency = 0.8
    local pulseSpeed = 2
    
    coroutine.wrap(function()
        while glow and glow.Parent do
            for i = 1, 20 do
                glow.ImageTransparency = transparency - (i * 0.01)
                task.wait(0.05 / pulseSpeed)
            end
            for i = 1, 20 do
                glow.ImageTransparency = transparency + (i * 0.01) - 0.2
                task.wait(0.05 / pulseSpeed)
            end
        end
    end)()
    
    return glow
end

-- 主UI创建
function library.new(title)
    -- 创建主UI
    local mainUI = Instance.new("ScreenGui")
    mainUI.Name = "ModernTechUI"
    mainUI.ResetOnSpawn = false
    mainUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    if syn and syn.protect_gui then
        syn.protect_gui(mainUI)
    end
    mainUI.Parent = game:GetService("CoreGui")
    
    -- 主容器
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = config.MainColor
    mainFrame.BorderSizePixel = 0
    mainFrame.Size = UDim2.new(0.85, 0, 1, 0)
    mainFrame.Position = UDim2.new(1, 0, 0, 0)
    mainFrame.AnchorPoint = Vector2.new(1, 0)
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = mainUI
    
    -- 圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = config.CornerRadius
    corner.Parent = mainFrame
    
    -- 发光效果
    createGlowEffect(mainFrame)
    
    -- 标题栏
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = config.SecondaryColor
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.ZIndex = 2
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, config.CornerRadius.Scale)
    titleCorner.Parent = titleBar
    
    -- 标题文本
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Text = title or "Modern Tech UI"
    titleText.Font = Enum.Font.GothamSemibold
    titleText.TextSize = 18
    titleText.TextColor3 = config.TextColor
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(0.5, 0, 1, 0)
    titleText.Position = UDim2.new(0.05, 0, 0, 0)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- 搜索框
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.PlaceholderText = "Search features..."
    searchBox.Text = ""
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 14
    searchBox.TextColor3 = config.TextColor
    searchBox.PlaceholderColor3 = config.DisabledColor
    searchBox.BackgroundColor3 = config.MainColor
    searchBox.Size = UDim2.new(0.3, 0, 0.6, 0)
    searchBox.Position = UDim2.new(0.65, 0, 0.2, 0)
    searchBox.Parent = titleBar
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 20)
    searchCorner.Parent = searchBox
    
    local searchPadding = Instance.new("UIPadding")
    searchPadding.PaddingLeft = UDim.new(0, 15)
    searchPadding.Parent = searchBox
    
    -- 搜索图标
    local searchIcon = Instance.new("ImageLabel")
    searchIcon.Name = "SearchIcon"
    searchIcon.Image = "rbxassetid://3926305904"
    searchIcon.ImageRectOffset = Vector2.new(964, 324)
    searchIcon.ImageRectSize = Vector2.new(36, 36)
    searchIcon.Size = UDim2.new(0, 20, 0, 20)
    searchIcon.Position = UDim2.new(1, -25, 0.5, -10)
    searchIcon.AnchorPoint = Vector2.new(1, 0.5)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Parent = searchBox
    
    -- 关闭按钮
    local closeButton = Instance.new("ImageButton")
    closeButton.Name = "CloseButton"
    closeButton.Image = "rbxassetid://3926305904"
    closeButton.ImageRectOffset = Vector2.new(284, 4)
    closeButton.ImageRectSize = Vector2.new(24, 24)
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(0.95, -15, 0.5, -15)
    closeButton.AnchorPoint = Vector2.new(0.5, 0.5)
    closeButton.BackgroundTransparency = 1
    closeButton.Parent = titleBar
    
    -- 内容区域
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.BackgroundTransparency = 1
    contentFrame.Size = UDim2.new(1, 0, 1, -50)
    contentFrame.Position = UDim2.new(0, 0, 0, 50)
    contentFrame.Parent = mainFrame
    
    -- 选项卡容器
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.BackgroundTransparency = 1
    tabContainer.Size = UDim2.new(0.2, 0, 1, 0)
    tabContainer.Position = UDim2.new(0, 0, 0, 0)
    tabContainer.Parent = contentFrame
    
    local tabList = Instance.new("UIListLayout")
    tabList.Name = "TabList"
    tabList.Padding = UDim.new(0, 5)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabContainer
    
    -- 页面容器
    local pageContainer = Instance.new("Frame")
    pageContainer.Name = "PageContainer"
    pageContainer.BackgroundTransparency = 1
    pageContainer.Size = UDim2.new(0.8, 0, 1, 0)
    pageContainer.Position = UDim2.new(0.2, 0, 0, 0)
    pageContainer.Parent = contentFrame
    
    -- 打开UI的按钮
    local openButton = Instance.new("ImageButton")
    openButton.Name = "OpenButton"
    openButton.Image = "rbxassetid://3926307971"
    openButton.ImageRectOffset = Vector2.new(884, 4)
    openButton.ImageRectSize = Vector2.new(36, 36)
    openButton.Size = UDim2.new(0, 50, 0, 50)
    openButton.Position = UDim2.new(1, -60, 0.5, -25)
    openButton.AnchorPoint = Vector2.new(1, 0.5)
    openButton.BackgroundColor3 = config.AccentColor
    openButton.Parent = mainUI
    
    local openCorner = Instance.new("UICorner")
    openCorner.CornerRadius = UDim.new(0, 12)
    openCorner.Parent = openButton
    
    createGlowEffect(openButton)
    
    -- 状态变量
    local isOpen = false
    local currentTab = nil
    local tabs = {}
    local flags = {}
    
    -- 动画函数
    local function toggleUI()
        isOpen = not isOpen
        if isOpen then
            tween(mainFrame, {Position = UDim2.new(1, -10, 0, 0)})
            tween(openButton, {Position = UDim2.new(1, -70, 0.5, -25), ImageTransparency = 1}, 0.2, nil, nil, function()
                openButton.Visible = false
            end)
        else
            openButton.Visible = true
            tween(mainFrame, {Position = UDim2.new(1, 0, 0, 0)})
            tween(openButton, {Position = UDim2.new(1, -60, 0.5, -25), ImageTransparency = 0})
        end
    end
    
    -- 事件绑定
    openButton.MouseButton1Click:Connect(toggleUI)
    closeButton.MouseButton1Click:Connect(toggleUI)
    
    -- 拖拽功能
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
    
    userInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- 窗口对象
    local window = {}
    
    function window:Tab(name, icon)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "TabButton_" .. name
        tabButton.Text = "   " .. name
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.TextSize = 14
        tabButton.TextColor3 = config.TextColor
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.BackgroundColor3 = config.SecondaryColor
        tabButton.AutoButtonColor = false
        tabButton.Size = UDim2.new(0.9, 0, 0, 40)
        tabButton.Position = UDim2.new(0.05, 0, 0, 0)
        tabButton.Parent = tabContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = config.CornerRadius
        tabCorner.Parent = tabButton
        
        if icon then
            local tabIcon = Instance.new("ImageLabel")
            tabIcon.Name = "TabIcon"
            tabIcon.Image = icon
            tabIcon.Size = UDim2.new(0, 20, 0, 20)
            tabIcon.Position = UDim2.new(0, 10, 0.5, -10)
            tabIcon.AnchorPoint = Vector2.new(0, 0.5)
            tabIcon.BackgroundTransparency = 1
            tabIcon.Parent = tabButton
        end
        
        local tabPage = Instance.new("ScrollingFrame")
        tabPage.Name = "TabPage_" .. name
        tabPage.BackgroundTransparency = 1
        tabPage.Size = UDim2.new(1, 0, 1, 0)
        tabPage.Position = UDim2.new(0, 0, 0, 0)
        tabPage.ScrollBarThickness = 5
        tabPage.ScrollBarImageColor3 = config.AccentColor
        tabPage.Visible = false
        tabPage.Parent = pageContainer
        
        local tabPageList = Instance.new("UIListLayout")
        tabPageList.Name = "TabPageList"
        tabPageList.Padding = UDim.new(0, 10)
        tabPageList.SortOrder = Enum.SortOrder.LayoutOrder
        tabPageList.Parent = tabPage
        
        tabPageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabPage.CanvasSize = UDim2.new(0, 0, 0, tabPageList.AbsoluteContentSize.Y + 20)
        end)
        
        -- 点击事件
        tabButton.MouseButton1Click:Connect(function()
            createRipple(tabButton)
            
            if currentTab then
                currentTab.Visible = false
                for _, btn in pairs(tabContainer:GetChildren()) do
                    if btn:IsA("TextButton") then
                        tween(btn, {BackgroundColor3 = config.SecondaryColor})
                    end
                end
            end
            
            currentTab = tabPage
            tabPage.Visible = true
            tween(tabButton, {BackgroundColor3 = config.AccentColor})
        end)
        
        -- 默认选中第一个标签
        if #tabContainer:GetChildren() == 1 then
            tabButton.MouseButton1Click:Invoke()
        end
        
        local tab = {}
        
        function tab:Section(title)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = "Section_" .. title
            sectionFrame.BackgroundColor3 = config.SecondaryColor
            sectionFrame.Size = UDim2.new(0.95, 0, 0, 40)
            sectionFrame.Position = UDim2.new(0.025, 0, 0, 0)
            sectionFrame.Parent = tabPage
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = config.CornerRadius
            sectionCorner.Parent = sectionFrame
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "SectionTitle"
            sectionTitle.Text = title
            sectionTitle.Font = Enum.Font.GothamSemibold
            sectionTitle.TextSize = 16
            sectionTitle.TextColor3 = config.TextColor
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Size = UDim2.new(1, -40, 1, 0)
            sectionTitle.Position = UDim2.new(0, 15, 0, 0)
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.Parent = sectionFrame
            
            local sectionContent = Instance.new("Frame")
            sectionContent.Name = "SectionContent"
            sectionContent.BackgroundTransparency = 1
            sectionContent.Size = UDim2.new(1, 0, 0, 0)
            sectionContent.Position = UDim2.new(0, 0, 0, 40)
            sectionContent.Parent = sectionFrame
            
            local sectionList = Instance.new("UIListLayout")
            sectionList.Name = "SectionList"
            sectionList.Padding = UDim.new(0, 5)
            sectionList.SortOrder = Enum.SortOrder.LayoutOrder
            sectionList.Parent = sectionContent
            
            sectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sectionContent.Size = UDim2.new(1, 0, 0, sectionList.AbsoluteContentSize.Y)
                sectionFrame.Size = UDim2.new(0.95, 0, 0, 40 + sectionList.AbsoluteContentSize.Y)
            end)
            
            local section = {}
            
            function section:Button(text, callback)
                local buttonFrame = Instance.new("Frame")
                buttonFrame.Name = "Button_" .. text
                buttonFrame.BackgroundTransparency = 1
                buttonFrame.Size = UDim2.new(1, 0, 0, 35)
                buttonFrame.Parent = sectionContent
                
                local button = Instance.new("TextButton")
                button.Name = "Button"
                button.Text = text
                button.Font = Enum.Font.Gotham
                button.TextSize = 14
                button.TextColor3 = config.TextColor
                button.BackgroundColor3 = config.MainColor
                button.AutoButtonColor = false
                button.Size = UDim2.new(1, -10, 0, 35)
                button.Position = UDim2.new(0, 5, 0, 0)
                button.Parent = buttonFrame
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 6)
                buttonCorner.Parent = button
                
                local buttonStroke = Instance.new("UIStroke")
                buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                buttonStroke.Color = config.AccentColor
                buttonStroke.Thickness = 1
                buttonStroke.Parent = button
                
                button.MouseEnter:Connect(function()
                    tween(button, {BackgroundColor3 = Color3.fromRGB(
                        config.MainColor.R * 255 + 20,
                        config.MainColor.G * 255 + 20,
                        config.MainColor.B * 255 + 20
                    )})
                end)
                
                button.MouseLeave:Connect(function()
                    tween(button, {BackgroundColor3 = config.MainColor})
                end)
                
                button.MouseButton1Click:Connect(function()
                    createRipple(button)
                    if callback then callback() end
                end)
            end
            
            function section:Toggle(text, flag, default, callback)
                flags[flag] = default or false
                
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Name = "Toggle_" .. text
                toggleFrame.BackgroundTransparency = 1
                toggleFrame.Size = UDim2.new(1, 0, 0, 35)
                toggleFrame.Parent = sectionContent
                
                local toggleLabel = Instance.new("TextLabel")
                toggleLabel.Name = "ToggleLabel"
                toggleLabel.Text = text
                toggleLabel.Font = Enum.Font.Gotham
                toggleLabel.TextSize = 14
                toggleLabel.TextColor3 = config.TextColor
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Size = UDim2.new(0.7, -10, 1, 0)
                toggleLabel.Position = UDim2.new(0, 5, 0, 0)
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                toggleLabel.Parent = toggleFrame
                
                local toggleButton = Instance.new("TextButton")
                toggleButton.Name = "ToggleButton"
                toggleButton.Text = ""
                toggleButton.BackgroundColor3 = default and config.SuccessColor or config.ErrorColor
                toggleButton.AutoButtonColor = false
                toggleButton.Size = UDim2.new(0, 50, 0, 25)
                toggleButton.Position = UDim2.new(1, -55, 0.5, -12.5)
                toggleButton.AnchorPoint = Vector2.new(1, 0.5)
                toggleButton.Parent = toggleFrame
                
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(1, 0)
                toggleCorner.Parent = toggleButton
                
                local toggleSwitch = Instance.new("Frame")
                toggleSwitch.Name = "ToggleSwitch"
                toggleSwitch.BackgroundColor3 = Color3.new(1, 1, 1)
                toggleSwitch.Size = UDim2.new(0, 21, 0, 21)
                toggleSwitch.Position = UDim2.new(default and 1 or 0, default and -23 or 2, 0.5, -10.5)
                toggleSwitch.AnchorPoint = Vector2.new(default and 1 or 0, 0.5)
                toggleSwitch.Parent = toggleButton
                
                local switchCorner = Instance.new("UICorner")
                switchCorner.CornerRadius = UDim.new(1, 0)
                switchCorner.Parent = toggleSwitch
                
                toggleButton.MouseButton1Click:Connect(function()
                    flags[flag] = not flags[flag]
                    
                    tween(toggleSwitch, {
                        Position = UDim2.new(flags[flag] and 1 or 0, flags[flag] and -23 or 2, 0.5, -10.5),
                        AnchorPoint = Vector2.new(flags[flag] and 1 or 0, 0.5)
                    })
                    
                    tween(toggleButton, {
                        BackgroundColor3 = flags[flag] and config.SuccessColor or config.ErrorColor
                    })
                    
                    if callback then callback(flags[flag]) end
                end)
                
                local toggle = {}
                
                function toggle:Set(value)
                    flags[flag] = value
                    
                    tween(toggleSwitch, {
                        Position = UDim2.new(flags[flag] and 1 or 0, flags[flag] and -23 or 2, 0.5, -10.5),
                        AnchorPoint = Vector2.new(flags[flag] and 1 or 0, 0.5)
                    })
                    
                    tween(toggleButton, {
                        BackgroundColor3 = flags[flag] and config.SuccessColor or config.ErrorColor
                    })
                    
                    if callback then callback(flags[flag]) end
                end
                
                return toggle
            end
            
            function section:Slider(text, flag, min, max, default, callback)
                flags[flag] = default or min
                
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = "Slider_" .. text
                sliderFrame.BackgroundTransparency = 1
                sliderFrame.Size = UDim2.new(1, 0, 0, 50)
                sliderFrame.Parent = sectionContent
                
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Name = "SliderLabel"
                sliderLabel.Text = text
                sliderLabel.Font = Enum.Font.Gotham
                sliderLabel.TextSize = 14
                sliderLabel.TextColor3 = config.TextColor
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Size = UDim2.new(1, -10, 0, 20)
                sliderLabel.Position = UDim2.new(0, 5, 0, 0)
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                sliderLabel.Parent = sliderFrame
                
                local sliderValue = Instance.new("TextLabel")
                sliderValue.Name = "SliderValue"
                sliderValue.Text = tostring(default or min)
                sliderValue.Font = Enum.Font.GothamSemibold
                sliderValue.TextSize = 14
                sliderValue.TextColor3 = config.AccentColor
                sliderValue.BackgroundTransparency = 1
                sliderValue.Size = UDim2.new(0.2, 0, 0, 20)
                sliderValue.Position = UDim2.new(0.8, 5, 0, 0)
                sliderValue.TextXAlignment = Enum.TextXAlignment.Right
                sliderValue.Parent = sliderFrame
                
                local sliderBar = Instance.new("Frame")
                sliderBar.Name = "SliderBar"
                sliderBar.BackgroundColor3 = config.MainColor
                sliderBar.Size = UDim2.new(1, -10, 0, 10)
                sliderBar.Position = UDim2.new(0, 5, 0, 30)
                sliderBar.Parent = sliderFrame
                
                local barCorner = Instance.new("UICorner")
                barCorner.CornerRadius = UDim.new(1, 0)
                barCorner.Parent = sliderBar
                
                local sliderFill = Instance.new("Frame")
                sliderFill.Name = "SliderFill"
                sliderFill.BackgroundColor3 = config.AccentColor
                sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                sliderFill.Parent = sliderBar
                
                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(1, 0)
                fillCorner.Parent = sliderFill
                
                local sliderButton = Instance.new("TextButton")
                sliderButton.Name = "SliderButton"
                sliderButton.Text = ""
                sliderButton.BackgroundTransparency = 1
                sliderButton.Size = UDim2.new(1, -10, 0, 20)
                sliderButton.Position = UDim2.new(0, 5, 0, 30)
                sliderButton.Parent = sliderFrame
                
                local dragging = false
                
                local function updateSlider(input)
                    local pos = UDim2.new(
                        math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1), 
                        0, 
                        1, 
                        0
                    )
                    
                    sliderFill.Size = pos
                    
                    local value = math.floor(min + (max - min) * pos.X.Scale)
                    if value ~= flags[flag] then
                        flags[flag] = value
                        sliderValue.Text = tostring(value)
                        if callback then callback(value) end
                    end
                end
                
                sliderButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateSlider(input)
                    end
                end)
                
                sliderButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                sliderButton.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                local slider = {}
                
                function slider:Set(value)
                    value = math.clamp(value, min, max)
                    flags[flag] = value
                    
                    local pos = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    sliderFill.Size = pos
                    sliderValue.Text = tostring(value)
                    
                    if callback then callback(value) end
                end
                
                return slider
            end
            
            function section:Dropdown(text, flag, options, callback)
                flags[flag] = nil
                
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Name = "Dropdown_" .. text
                dropdownFrame.BackgroundTransparency = 1
                dropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                dropdownFrame.Parent = sectionContent
                
                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Name = "DropdownButton"
                dropdownButton.Text = text
                dropdownButton.Font = Enum.Font.Gotham
                dropdownButton.TextSize = 14
                dropdownButton.TextColor3 = config.TextColor
                dropdownButton.BackgroundColor3 = config.MainColor
                dropdownButton.AutoButtonColor = false
                dropdownButton.Size = UDim2.new(1, -10, 0, 35)
                dropdownButton.Position = UDim2.new(0, 5, 0, 0)
                dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                dropdownButton.Parent = dropdownFrame
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = config.CornerRadius
                buttonCorner.Parent = dropdownButton
                
                local dropdownArrow = Instance.new("ImageLabel")
                dropdownArrow.Name = "DropdownArrow"
                dropdownArrow.Image = "rbxassetid://3926305904"
                dropdownArrow.ImageRectOffset = Vector2.new(884, 284)
                dropdownArrow.ImageRectSize = Vector2.new(36, 36)
                dropdownArrow.Size = UDim2.new(0, 20, 0, 20)
                dropdownArrow.Position = UDim2.new(1, -15, 0.5, -10)
                dropdownArrow.AnchorPoint = Vector2.new(1, 0.5)
                dropdownArrow.BackgroundTransparency = 1
                dropdownArrow.Parent = dropdownButton
                
                local dropdownValue = Instance.new("TextLabel")
                dropdownValue.Name = "DropdownValue"
                dropdownValue.Text = "Select..."
                dropdownValue.Font = Enum.Font.Gotham
                dropdownValue.TextSize = 14
                dropdownValue.TextColor3 = config.DisabledColor
                dropdownValue.BackgroundTransparency = 1
                dropdownValue.Size = UDim2.new(0.5, 0, 1, 0)
                dropdownValue.Position = UDim2.new(0.5, 5, 0, 0)
                dropdownValue.TextXAlignment = Enum.TextXAlignment.Right
                dropdownValue.Parent = dropdownButton
                
                local dropdownList = Instance.new("Frame")
                dropdownList.Name = "DropdownList"
                dropdownList.BackgroundColor3 = config.MainColor
                dropdownList.Size = UDim2.new(1, -10, 0, 0)
                dropdownList.Position = UDim2.new(0, 5, 0, 40)
                dropdownList.ClipsDescendants = true
                dropdownList.Visible = false
                dropdownList.Parent = dropdownFrame
                
                local listCorner = Instance.new("UICorner")
                listCorner.CornerRadius = config.CornerRadius
                listCorner.Parent = dropdownList
                
                local listLayout = Instance.new("UIListLayout")
                listLayout.Name = "ListLayout"
                listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                listLayout.Padding = UDim.new(0, 2)
                listLayout.Parent = dropdownList
                
                local isOpen = false
                
                local function toggleDropdown()
                    isOpen = not isOpen
                    
                    if isOpen then
                        tween(dropdownArrow, {Rotation = 180})
                        dropdownList.Visible = true
                        tween(dropdownList, {Size = UDim2.new(1, -10, 0, math.min(#options * 30, 150))})
                    else
                        tween(dropdownArrow, {Rotation = 0})
                        tween(dropdownList, {Size = UDim2.new(1, -10, 0, 0)}, 0.2, nil, nil, function()
                            dropdownList.Visible = false
                        end)
                    end
                end
                
                dropdownButton.MouseButton1Click:Connect(toggleDropdown)
                
                local function createOption(option)
                    local optionButton = Instance.new("TextButton")
                    optionButton.Name = "Option_" .. option
                    optionButton.Text = option
                    optionButton.Font = Enum.Font.Gotham
                    optionButton.TextSize = 14
                    optionButton.TextColor3 = config.TextColor
                    optionButton.BackgroundColor3 = config.SecondaryColor
                    optionButton.AutoButtonColor = false
                    optionButton.Size = UDim2.new(1, 0, 0, 30)
                    optionButton.Parent = dropdownList
                    
                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = config.CornerRadius
                    optionCorner.Parent = optionButton
                    
                    optionButton.MouseButton1Click:Connect(function()
                        flags[flag] = option
                        dropdownValue.Text = option
                        dropdownValue.TextColor3 = config.TextColor
                        toggleDropdown()
                        if callback then callback(option) end
                    end)
                end
                
                for _, option in ipairs(options) do
                    createOption(option)
                end
                
                listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    if isOpen then
                        dropdownList.Size = UDim2.new(1, -10, 0, math.min(listLayout.AbsoluteContentSize.Y, 150))
                    end
                end)
                
                local dropdown = {}
                
                function dropdown:AddOption(option)
                    table.insert(options, option)
                    createOption(option)
                end
                
                function dropdown:RemoveOption(option)
                    for i, opt in ipairs(options) do
                        if opt == option then
                            table.remove(options, i)
                            local btn = dropdownList:FindFirstChild("Option_" .. option)
                            if btn then btn:Destroy() end
                            break
                        end
                    end
                end
                
                function dropdown:SetOptions(newOptions)
                    options = newOptions
                    for _, child in ipairs(dropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    for _, option in ipairs(options) do
                        createOption(option)
                    end
                end
                
                function dropdown:SetValue(value)
                    if table.find(options, value) then
                        flags[flag] = value
                        dropdownValue.Text = value
                        dropdownValue.TextColor3 = config.TextColor
                        if callback then callback(value) end
                    end
                end
                
                return dropdown
            end
            
            function section:Label(text)
                local labelFrame = Instance.new("Frame")
                labelFrame.Name = "Label_" .. text
                labelFrame.BackgroundTransparency = 1
                labelFrame.Size = UDim2.new(1, 0, 0, 25)
                labelFrame.Parent = sectionContent
                
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Text = text
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextColor3 = config.TextColor
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, -10, 1, 0)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = labelFrame
                
                local line = Instance.new("Frame")
                line.Name = "Line"
                line.BackgroundColor3 = config.AccentColor
                line.Size = UDim2.new(1, -10, 0, 1)
                line.Position = UDim2.new(0, 5, 1, -5)
                line.Parent = labelFrame
                
                return label
            end
            
            function section:Keybind(text, flag, default, callback)
                local keyNames = {
                    [Enum.KeyCode.LeftControl] = "LCtrl",
                    [Enum.KeyCode.RightControl] = "RCtrl",
                    [Enum.KeyCode.LeftShift] = "LShift",
                    [Enum.KeyCode.RightShift] = "RShift",
                    [Enum.KeyCode.LeftAlt] = "LAlt",
                    [Enum.KeyCode.RightAlt] = "RAlt",
                    [Enum.KeyCode.CapsLock] = "Caps",
                    [Enum.KeyCode.Semicolon] = ";",
                    [Enum.KeyCode.Equals] = "=",
                    [Enum.KeyCode.Minus] = "-",
                    [Enum.KeyCode.LeftBracket] = "[",
                    [Enum.KeyCode.RightBracket] = "]",
                    [Enum.KeyCode.BackSlash] = "\\",
                    [Enum.KeyCode.Quote] = "'",
                    [Enum.KeyCode.Comma] = ",",
                    [Enum.KeyCode.Period] = ".",
                    [Enum.KeyCode.Slash] = "/",
                    [Enum.KeyCode.Backquote] = "`",
                    [Enum.KeyCode.Return] = "Enter",
                    [Enum.KeyCode.Space] = "Space",
                    [Enum.KeyCode.Tab] = "Tab",
                    [Enum.KeyCode.Escape] = "Esc",
                    [Enum.KeyCode.Delete] = "Del",
                    [Enum.KeyCode.Insert] = "Ins",
                    [Enum.KeyCode.Home] = "Home",
                    [Enum.KeyCode.End] = "End",
                    [Enum.KeyCode.PageUp] = "PgUp",
                    [Enum.KeyCode.PageDown] = "PgDown",
                    [Enum.KeyCode.Up] = "↑",
                    [Enum.KeyCode.Down] = "↓",
                    [Enum.KeyCode.Left] = "←",
                    [Enum.KeyCode.Right] = "→",
                    [Enum.KeyCode.NumLock] = "NumLock",
                    [Enum.KeyCode.Print] = "PrtSc",
                    [Enum.KeyCode.Scroll] = "ScrollLock",
                    [Enum.KeyCode.Pause] = "Pause"
                }
                
                flags[flag] = default or nil
                
                local keybindFrame = Instance.new("Frame")
                keybindFrame.Name = "Keybind_" .. text
                keybindFrame.BackgroundTransparency = 1
                keybindFrame.Size = UDim2.new(1, 0, 0, 35)
                keybindFrame.Parent = sectionContent
                
                local keybindLabel = Instance.new("TextLabel")
                keybindLabel.Name = "KeybindLabel"
                keybindLabel.Text = text
                keybindLabel.Font = Enum.Font.Gotham
                keybindLabel.TextSize = 14
                keybindLabel.TextColor3 = config.TextColor
                keybindLabel.BackgroundTransparency = 1
                keybindLabel.Size = UDim2.new(0.6, -10, 1, 0)
                keybindLabel.Position = UDim2.new(0, 5, 0, 0)
                keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
                keybindLabel.Parent = keybindFrame
                
                local keybindButton = Instance.new("TextButton")
                keybindButton.Name = "KeybindButton"
                keybindButton.Text = flags[flag] and keyNames[flags[flag]] or flags[flag] and tostring(flags[flag].Name):gsub("KeyCode.", "") or "None"
                keybindButton.Font = Enum.Font.Gotham
                keybindButton.TextSize = 14
                keybindButton.TextColor3 = config.TextColor
                keybindButton.BackgroundColor3 = config.MainColor
                keybindButton.AutoButtonColor = false
                keybindButton.Size = UDim2.new(0.4, -10, 0, 30)
                keybindButton.Position = UDim2.new(0.6, 5, 0.5, -15)
                keybindButton.Parent = keybindFrame
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = config.CornerRadius
                buttonCorner.Parent = keybindButton
                
                local buttonStroke = Instance.new("UIStroke")
                buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                buttonStroke.Color = config.AccentColor
                buttonStroke.Thickness = 1
                buttonStroke.Parent = keybindButton
                
                local listening = false
                
                local function setKey(key)
                    flags[flag] = key
                    keybindButton.Text = keyNames[key] or tostring(key.Name):gsub("KeyCode.", "")
                    
                    if callback then callback(key) end
                end
                
                keybindButton.MouseButton1Click:Connect(function()
                    listening = true
                    keybindButton.Text = "..."
                    keybindButton.TextColor3 = config.AccentColor
                    
                    local connection
                    connection = userInputService.InputBegan:Connect(function(input, gameProcessed)
                        if gameProcessed then return end
                        
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            setKey(input.KeyCode)
                        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                            setKey(Enum.KeyCode.MouseButton1)
                        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                            setKey(Enum.KeyCode.MouseButton2)
                        elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                            setKey(Enum.KeyCode.MouseButton3)
                        end
                        
                        listening = false
                        keybindButton.TextColor3 = config.TextColor
                        connection:Disconnect()
                    end)
                end)
                
                local keybind = {}
                
                function keybind:SetKey(key)
                    setKey(key)
                end
                
                return keybind
            end
            
            return section
        end
        
        return tab
    end
    
    -- 搜索功能
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = searchBox.Text:lower()
        
        for _, tab in pairs(pageContainer:GetChildren()) do
            if tab:IsA("ScrollingFrame") then
                for _, section in pairs(tab:GetChildren()) do
                    if section:IsA("Frame") and section.Name:match("Section_") then
                        local found = false
                        
                        for _, element in pairs(section:FindFirstChild("SectionContent"):GetChildren()) do
                            if element:IsA("Frame") then
                                local label = element:FindFirstChildOfClass("TextLabel") or 
                                              element:FindFirstChildOfClass("TextButton") or
                                              element:FindFirstChildOfClass("TextBox")
                                
                                if label and label.Text:lower():find(searchText, 1, true) then
                                    found = true
                                    element.Visible = true
                                else
                                    element.Visible = searchText == ""
                                end
                            end
                        end
                        
                        section.Visible = found or searchText == ""
                    end
                end
            end
        end
    end)
    
    -- 返回窗口对象
    return window
end

return library