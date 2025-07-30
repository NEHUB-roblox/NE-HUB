local library = {}
local ToggleUI = false
library.currentTab = nil
library.flags = {}
local services = setmetatable({}, {
    __index = function(t, k)
        return game.GetService(game, k)
    end,
})
local mouse = services.Players.LocalPlayer:GetMouse()

-- 颜色配置
local config = {
    MainColor = Color3.fromRGB(25, 25, 30),
    BorderColor1 = Color3.fromRGB(0, 162, 255), -- 蓝色边框
    BorderColor2 = Color3.fromRGB(255, 0, 162), -- 粉色边框
    TextColor = Color3.fromRGB(200, 220, 255),
    AccentColor = Color3.fromRGB(100, 180, 255),
    TabColor = Color3.fromRGB(30, 30, 40),
    ButtonColor = Color3.fromRGB(40, 40, 50),
    ToggleOn = Color3.fromRGB(0, 200, 255),
    ToggleOff = Color3.fromRGB(70, 70, 80),
    SearchBox = Color3.fromRGB(35, 35, 45)
}

-- 动画效果函数
function Tween(obj, t, data)
    services.TweenService
        :Create(obj, TweenInfo.new(t[1], Enum.EasingStyle[t[2]], Enum.EasingDirection[t[3]]), data)
        :Play()
    return true
end

-- 水波纹效果
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
        Ripple.ImageColor3 = Color3.fromRGB(255, 255, 255)
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

-- 创建主窗口
function library.new(library, name)
    for _, v in next, services.CoreGui:GetChildren() do
        if v.Name == "EnhancedUI" then
            v:Destroy()
        end
    end

    local dogent = Instance.new("ScreenGui")
    dogent.Name = "EnhancedUI"
    dogent.Parent = services.CoreGui
    dogent.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- 创建主框架
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = dogent
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = config.MainColor
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 650, 0, 450) -- 更大的尺寸
    Main.ZIndex = 1
    
    -- 圆角边框效果
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Main
    
    -- 彩色边框
    local Border1 = Instance.new("Frame")
    Border1.Name = "Border1"
    Border1.Parent = Main
    Border1.BackgroundColor3 = config.BorderColor1
    Border1.BorderSizePixel = 0
    Border1.Size = UDim2.new(1, 0, 1, 0)
    Border1.ZIndex = 0
    
    local Border1Corner = Instance.new("UICorner")
    Border1Corner.CornerRadius = UDim.new(0, 12)
    Border1Corner.Parent = Border1
    
    local Border2 = Instance.new("Frame")
    Border2.Name = "Border2"
    Border2.Parent = Border1
    Border2.BackgroundColor3 = config.BorderColor2
    Border2.BorderSizePixel = 0
    Border2.Position = UDim2.new(0.02, 0, 0.02, 0)
    Border2.Size = UDim2.new(0.96, 0, 0.96, 0)
    Border2.ZIndex = 0
    
    local Border2Corner = Instance.new("UICorner")
    Border2Corner.CornerRadius = UDim.new(0, 10)
    Border2Corner.Parent = Border2
    
    -- 标题栏
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = Main
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TitleBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.Size = UDim2.new(0.9, 0, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = name
    Title.TextColor3 = config.TextColor
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 创建圆形开关按钮
    local ToggleButton = Instance.new("ImageButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = dogent
    ToggleButton.AnchorPoint = Vector2.new(0, 0.5)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Position = UDim2.new(0.02, 0, 0.1, 0)
    ToggleButton.Size = UDim2.new(0, 60, 0, 60)
    ToggleButton.Image = "rbxassetid://3570695787"
    ToggleButton.ImageColor3 = Color3.fromRGB(25, 25, 30)
    ToggleButton.ScaleType = Enum.ScaleType.Slice
    ToggleButton.SliceCenter = Rect.new(100, 100, 100, 100)
    
    -- 彩色边框
    local ButtonBorder1 = Instance.new("Frame")
    ButtonBorder1.Name = "ButtonBorder1"
    ButtonBorder1.Parent = ToggleButton
    ButtonBorder1.BackgroundColor3 = Color3.fromRGB(255, 0, 100) -- 红色
    ButtonBorder1.BorderSizePixel = 0
    ButtonBorder1.Size = UDim2.new(1, 0, 1, 0)
    ButtonBorder1.ZIndex = 0
    
    local ButtonBorder1Corner = Instance.new("UICorner")
    ButtonBorder1Corner.CornerRadius = UDim.new(1, 0)
    ButtonBorder1Corner.Parent = ButtonBorder1
    
    local ButtonBorder2 = Instance.new("Frame")
    ButtonBorder2.Name = "ButtonBorder2"
    ButtonBorder2.Parent = ButtonBorder1
    ButtonBorder2.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- 蓝色
    ButtonBorder2.BorderSizePixel = 0
    ButtonBorder2.Position = UDim2.new(0.05, 0, 0.05, 0)
    ButtonBorder2.Size = UDim2.new(0.9, 0, 0.9, 0)
    ButtonBorder2.ZIndex = 0
    
    local ButtonBorder2Corner = Instance.new("UICorner")
    ButtonBorder2Corner.CornerRadius = UDim.new(1, 0)
    ButtonBorder2Corner.Parent = ButtonBorder2
    
    local ButtonBorder3 = Instance.new("Frame")
    ButtonBorder3.Name = "ButtonBorder3"
    ButtonBorder3.Parent = ButtonBorder2
    ButtonBorder3.BackgroundColor3 = Color3.fromRGB(150, 0, 255) -- 紫色
    ButtonBorder3.BorderSizePixel = 0
    ButtonBorder3.Position = UDim2.new(0.05, 0, 0.05, 0)
    ButtonBorder3.Size = UDim2.new(0.9, 0, 0.9, 0)
    ButtonBorder3.ZIndex = 0
    
    local ButtonBorder3Corner = Instance.new("UICorner")
    ButtonBorder3Corner.CornerRadius = UDim.new(1, 0)
    ButtonBorder3Corner.Parent = ButtonBorder3
    
    local ButtonText = Instance.new("TextLabel")
    ButtonText.Name = "ButtonText"
    ButtonText.Parent = ButtonBorder3
    ButtonText.BackgroundTransparency = 1
    ButtonText.Size = UDim2.new(1, 0, 1, 0)
    ButtonText.Font = Enum.Font.GothamBold
    ButtonText.Text = "开启"
    ButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonText.TextSize = 14
    ButtonText.TextStrokeTransparency = 0.8
    
    -- 开关UI功能
    ToggleButton.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
        ButtonText.Text = Main.Visible and "开启" or "关闭"
        
        -- 点击动画
        Tween(ToggleButton, {0.1, "Quad", "Out"}, {Size = UDim2.new(0, 55, 0, 55)})
        wait(0.1)
        Tween(ToggleButton, {0.1, "Quad", "Out"}, {Size = UDim2.new(0, 60, 0, 60)})
    end)

    -- 拖动功能
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            
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

    services.UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- 标签页容器
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Main
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.Size = UDim2.new(1, -20, 1, -60)
    
    -- 标签按钮容器
    local TabButtons = Instance.new("ScrollingFrame")
    TabButtons.Name = "TabButtons"
    TabButtons.Parent = TabContainer
    TabButtons.BackgroundTransparency = 1
    TabButtons.Size = UDim2.new(0, 120, 1, 0)
    TabButtons.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabButtons.ScrollBarThickness = 0
    
    local TabButtonsLayout = Instance.new("UIListLayout")
    TabButtonsLayout.Name = "TabButtonsLayout"
    TabButtonsLayout.Parent = TabButtons
    TabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabButtonsLayout.Padding = UDim2.new(0, 0, 0, 10)
    
    -- 内容容器
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = TabContainer
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 130, 0, 0)
    ContentContainer.Size = UDim2.new(1, -130, 1, 0)
    
    -- 搜索框
    local SearchBox = Instance.new("Frame")
    SearchBox.Name = "SearchBox"
    SearchBox.Parent = ContentContainer
    SearchBox.BackgroundColor3 = config.SearchBox
    SearchBox.Size = UDim2.new(1, 0, 0, 40)
    
    local SearchBoxCorner = Instance.new("UICorner")
    SearchBoxCorner.CornerRadius = UDim.new(0, 8)
    SearchBoxCorner.Parent = SearchBox
    
    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Name = "SearchIcon"
    SearchIcon.Parent = SearchBox
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Position = UDim2.new(0, 10, 0, 10)
    SearchIcon.Size = UDim2.new(0, 20, 0, 20)
    SearchIcon.Image = "rbxassetid://3926305904"
    SearchIcon.ImageColor3 = config.TextColor
    SearchIcon.ImageRectOffset = Vector2.new(964, 324)
    SearchIcon.ImageRectSize = Vector2.new(36, 36)
    
    local SearchInput = Instance.new("TextBox")
    SearchInput.Name = "SearchInput"
    SearchInput.Parent = SearchBox
    SearchInput.BackgroundTransparency = 1
    SearchInput.Position = UDim2.new(0, 40, 0, 0)
    SearchInput.Size = UDim2.new(1, -40, 1, 0)
    SearchInput.Font = Enum.Font.Gotham
    SearchInput.PlaceholderText = "搜索功能..."
    SearchInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    SearchInput.Text = ""
    SearchInput.TextColor3 = config.TextColor
    SearchInput.TextSize = 14
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 内容滚动框
    local ContentScroll = Instance.new("ScrollingFrame")
    ContentScroll.Name = "ContentScroll"
    ContentScroll.Parent = ContentContainer
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.Position = UDim2.new(0, 0, 0, 50)
    ContentScroll.Size = UDim2.new(1, 0, 1, -50)
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentScroll.ScrollBarThickness = 4
    ContentScroll.ScrollBarImageColor3 = config.AccentColor
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Name = "ContentLayout"
    ContentLayout.Parent = ContentScroll
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    
    -- 更新CanvasSize
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentScroll.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    TabButtonsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabButtons.CanvasSize = UDim2.new(0, 0, 0, TabButtonsLayout.AbsoluteContentSize.Y + 10)
    end)

    -- 窗口功能
    local window = {}
    function window.Tab(window, name, icon)
        -- 创建标签按钮
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Parent = TabButtons
        TabButton.BackgroundColor3 = config.TabColor
        TabButton.AutoButtonColor = false
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Font = Enum.Font.GothamBold
        TabButton.Text = ""
        TabButton.TextColor3 = config.TextColor
        TabButton.TextSize = 14
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 8)
        TabButtonCorner.Parent = TabButton
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "TabIcon"
        TabIcon.Parent = TabButton
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 10, 0, 10)
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Image = icon or "rbxassetid://3926305904"
        TabIcon.ImageColor3 = config.TextColor
        
        local TabText = Instance.new("TextLabel")
        TabText.Name = "TabText"
        TabText.Parent = TabButton
        TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(0, 40, 0, 0)
        TabText.Size = UDim2.new(1, -40, 1, 0)
        TabText.Font = Enum.Font.GothamBold
        TabText.Text = name
        TabText.TextColor3 = config.TextColor
        TabText.TextSize = 14
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        
        -- 创建标签内容
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name
        TabContent.Parent = ContentScroll
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = config.AccentColor
        
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Name = "TabContentLayout"
        TabContentLayout.Parent = TabContent
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 10)
        
        TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- 标签切换功能
        local function switchTab()
            for _, tab in pairs(ContentScroll:GetChildren()) do
                if tab:IsA("ScrollingFrame") then
                    tab.Visible = false
                end
            end
            TabContent.Visible = true
            
            -- 更新按钮状态
            for _, btn in pairs(TabButtons:GetChildren()) do
                if btn:IsA("TextButton") then
                    if btn.Name == name then
                        Tween(btn, {0.2, "Quad", "Out"}, {BackgroundColor3 = Color3.fromRGB(40, 40, 60)})
                        Tween(TabText, {0.2, "Quad", "Out"}, {TextColor3 = config.AccentColor})
                        Tween(TabIcon, {0.2, "Quad", "Out"}, {ImageColor3 = config.AccentColor})
                    else
                        Tween(btn, {0.2, "Quad", "Out"}, {BackgroundColor3 = config.TabColor})
                        Tween(btn.TabText, {0.2, "Quad", "Out"}, {TextColor3 = config.TextColor})
                        Tween(btn.TabIcon, {0.2, "Quad", "Out"}, {ImageColor3 = config.TextColor})
                    end
                end
            end
        end
        
        TabButton.MouseButton1Click:Connect(function()
            Ripple(TabButton)
            switchTab()
        end)
        
        -- 如果是第一个标签，默认显示
        if #TabButtons:GetChildren() == 1 then
            switchTab()
        end
        
        local tab = {}
        function tab.section(tab, name, isOpen)
            local Section = Instance.new("Frame")
            Section.Name = "Section"
            Section.Parent = TabContent
            Section.BackgroundColor3 = config.TabColor
            Section.Size = UDim2.new(1, 0, 0, 40)
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = Section
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Parent = Section
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 15, 0, 0)
            SectionTitle.Size = UDim2.new(1, -15, 1, 0)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = name
            SectionTitle.TextColor3 = config.TextColor
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local SectionToggle = Instance.new("ImageButton")
            SectionToggle.Name = "SectionToggle"
            SectionToggle.Parent = Section
            SectionToggle.BackgroundTransparency = 1
            SectionToggle.Position = UDim2.new(1, -40, 0, 10)
            SectionToggle.Size = UDim2.new(0, 20, 0, 20)
            SectionToggle.Image = "rbxassetid://3926307971"
            SectionToggle.ImageColor3 = config.TextColor
            SectionToggle.ImageRectOffset = Vector2.new(964, 324)
            SectionToggle.ImageRectSize = Vector2.new(36, 36)
            
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "SectionContent"
            SectionContent.Parent = Section
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 0, 0, 40)
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.ClipsDescendants = true
            
            local SectionContentLayout = Instance.new("UIListLayout")
            SectionContentLayout.Name = "SectionContentLayout"
            SectionContentLayout.Parent = SectionContent
            SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionContentLayout.Padding = UDim.new(0, 10)
            
            local open = isOpen or false
            
            local function toggleSection()
                open = not open
                if open then
                    Section.Size = UDim2.new(1, 0, 0, 40 + SectionContentLayout.AbsoluteContentSize.Y + 10)
                    SectionToggle.Rotation = 180
                    SectionContent.Size = UDim2.new(1, 0, 0, SectionContentLayout.AbsoluteContentSize.Y)
                else
                    Section.Size = UDim2.new(1, 0, 0, 40)
                    SectionToggle.Rotation = 0
                    SectionContent.Size = UDim2.new(1, 0, 0, 0)
                end
            end
            
            SectionToggle.MouseButton1Click:Connect(function()
                toggleSection()
            end)
            
            SectionTitle.MouseButton1Click:Connect(function()
                toggleSection()
            end)
            
            SectionContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if open then
                    Section.Size = UDim2.new(1, 0, 0, 40 + SectionContentLayout.AbsoluteContentSize.Y + 10)
                    SectionContent.Size = UDim2.new(1, 0, 0, SectionContentLayout.AbsoluteContentSize.Y)
                end
            end)
            
            if isOpen then
                toggleSection()
            end
            
            local section = {}
            
            -- 创建按钮
            function section.Button(section, text, callback)
                local Button = Instance.new("TextButton")
                Button.Name = "Button"
                Button.Parent = SectionContent
                Button.BackgroundColor3 = config.ButtonColor
                Button.AutoButtonColor = false
                Button.Size = UDim2.new(1, 0, 0, 40)
                Button.Font = Enum.Font.GothamBold
                Button.Text = text
                Button.TextColor3 = config.TextColor
                Button.TextSize = 14
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 8)
                ButtonCorner.Parent = Button
                
                local ButtonHighlight = Instance.new("Frame")
                ButtonHighlight.Name = "ButtonHighlight"
                ButtonHighlight.Parent = Button
                ButtonHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ButtonHighlight.BackgroundTransparency = 0.9
                ButtonHighlight.Size = UDim2.new(1, 0, 1, 0)
                ButtonHighlight.Visible = false
                
                local ButtonHighlightCorner = Instance.new("UICorner")
                ButtonHighlightCorner.CornerRadius = UDim.new(0, 8)
                ButtonHighlightCorner.Parent = ButtonHighlight
                
                Button.MouseEnter:Connect(function()
                    ButtonHighlight.Visible = true
                    Tween(Button, {0.1, "Quad", "Out"}, {BackgroundColor3 = Color3.fromRGB(50, 50, 70)})
                end)
                
                Button.MouseLeave:Connect(function()
                    ButtonHighlight.Visible = false
                    Tween(Button, {0.1, "Quad", "Out"}, {BackgroundColor3 = config.ButtonColor})
                end)
                
                Button.MouseButton1Click:Connect(function()
                    Ripple(Button)
                    if callback then
                        callback()
                    end
                end)
            end
            
            -- 创建开关
            function section.Toggle(section, text, flag, default, callback)
                local Toggle = Instance.new("TextButton")
                Toggle.Name = "Toggle"
                Toggle.Parent = SectionContent
                Toggle.BackgroundColor3 = config.ButtonColor
                Toggle.AutoButtonColor = false
                Toggle.Size = UDim2.new(1, 0, 0, 40)
                Toggle.Font = Enum.Font.GothamBold
                Toggle.Text = "   " .. text
                Toggle.TextColor3 = config.TextColor
                Toggle.TextSize = 14
                Toggle.TextXAlignment = Enum.TextXAlignment.Left
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 8)
                ToggleCorner.Parent = Toggle
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Name = "ToggleIndicator"
                ToggleIndicator.Parent = Toggle
                ToggleIndicator.BackgroundColor3 = default and config.ToggleOn or config.ToggleOff
                ToggleIndicator.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleIndicator.Size = UDim2.new(0, 40, 0, 20)
                
                local ToggleIndicatorCorner = Instance.new("UICorner")
                ToggleIndicatorCorner.CornerRadius = UDim.new(1, 0)
                ToggleIndicatorCorner.Parent = ToggleIndicator
                
                local ToggleSwitch = Instance.new("Frame")
                ToggleSwitch.Name = "ToggleSwitch"
                ToggleSwitch.Parent = ToggleIndicator
                ToggleSwitch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleSwitch.Position = default and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
                ToggleSwitch.Size = UDim2.new(0, 20, 1, 0)
                
                local ToggleSwitchCorner = Instance.new("UICorner")
                ToggleSwitchCorner.CornerRadius = UDim.new(1, 0)
                ToggleSwitchCorner.Parent = ToggleSwitch
                
                local state = default or false
                library.flags[flag] = state
                
                local function toggleState()
                    state = not state
                    library.flags[flag] = state
                    
                    if state then
                        Tween(ToggleIndicator, {0.2, "Quad", "Out"}, {BackgroundColor3 = config.ToggleOn})
                        Tween(ToggleSwitch, {0.2, "Quad", "Out"}, {Position = UDim2.new(0.5, 0, 0, 0)})
                    else
                        Tween(ToggleIndicator, {0.2, "Quad", "Out"}, {BackgroundColor3 = config.ToggleOff})
                        Tween(ToggleSwitch, {0.2, "Quad", "Out"}, {Position = UDim2.new(0, 0, 0, 0)})
                    end
                    
                    if callback then
                        callback(state)
                    end
                end
                
                Toggle.MouseButton1Click:Connect(function()
                    Ripple(Toggle)
                    toggleState()
                end)
                
                local funcs = {}
                function funcs:SetState(newState)
                    if state ~= newState then
                        toggleState()
                    end
                end
                
                return funcs
            end
            
            -- 创建滑块
            function section.Slider(section, text, flag, min, max, default, callback)
                local Slider = Instance.new("Frame")
                Slider.Name = "Slider"
                Slider.Parent = SectionContent
                Slider.BackgroundColor3 = config.ButtonColor
                Slider.Size = UDim2.new(1, 0, 0, 60)
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 8)
                SliderCorner.Parent = Slider
                
                local SliderTitle = Instance.new("TextLabel")
                SliderTitle.Name = "SliderTitle"
                SliderTitle.Parent = Slider
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 15, 0, 5)
                SliderTitle.Size = UDim2.new(1, -30, 0, 20)
                SliderTitle.Font = Enum.Font.GothamBold
                SliderTitle.Text = text
                SliderTitle.TextColor3 = config.TextColor
                SliderTitle.TextSize = 14
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Name = "SliderBar"
                SliderBar.Parent = Slider
                SliderBar.BackgroundColor3 = config.ToggleOff
                SliderBar.Position = UDim2.new(0, 15, 0, 30)
                SliderBar.Size = UDim2.new(1, -30, 0, 10)
                
                local SliderBarCorner = Instance.new("UICorner")
                SliderBarCorner.CornerRadius = UDim.new(1, 0)
                SliderBarCorner.Parent = SliderBar
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "SliderFill"
                SliderFill.Parent = SliderBar
                SliderFill.BackgroundColor3 = config.ToggleOn
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(1, 0)
                SliderFillCorner.Parent = SliderFill
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Name = "SliderValue"
                SliderValue.Parent = Slider
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(1, -60, 0, 5)
                SliderValue.Size = UDim2.new(0, 45, 0, 20)
                SliderValue.Font = Enum.Font.GothamBold
                SliderValue.Text = tostring(default or min)
                SliderValue.TextColor3 = config.TextColor
                SliderValue.TextSize = 14
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                
                local dragging = false
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
                
                setValue(default or min)
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local percent = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                        setValue(min + (max - min) * percent)
                    end
                end)
                
                SliderBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                services.UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                        setValue(min + (max - min) * percent)
                    end
                end)
                
                local funcs = {}
                function funcs:SetValue(newValue)
                    setValue(newValue)
                end
                
                return funcs
            end
            
            return section
        end
        
        return tab
    end
    
    return window
end

return library