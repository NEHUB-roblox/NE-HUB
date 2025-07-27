local library = {}
library.flags = {}

local services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end
})

local function createRippleEffect(button)
    spawn(function()
        button.ClipsDescendants = true
        local ripple = Instance.new("ImageLabel")
        ripple.Name = "Ripple"
        ripple.Parent = button
        ripple.BackgroundTransparency = 1
        ripple.Image = "rbxassetid://2708891598"
        ripple.ImageTransparency = 0.8
        ripple.ScaleType = Enum.ScaleType.Fit
        ripple.ImageColor3 = Color3.fromRGB(150, 150, 255)
        
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        ripple.Position = UDim2.new(
            (mouse.X - ripple.AbsolutePosition.X) / button.AbsoluteSize.X,
            0,
            (mouse.Y - ripple.AbsolutePosition.Y) / button.AbsoluteSize.Y,
            0
        )
        
        game:GetService("TweenService"):Create(ripple, TweenInfo.new(0.3), {
            Position = UDim2.new(-5.5, 0, -5.5, 0),
            Size = UDim2.new(12, 0, 12, 0)
        }):Play()
        
        wait(0.15)
        game:GetService("TweenService"):Create(ripple, TweenInfo.new(0.3), {
            ImageTransparency = 1
        }):Play()
        wait(0.3)
        ripple:Destroy()
    end)
end

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
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
            update(input)
        end
    end)
end

function library.new(name)
    -- 清理旧UI
    for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
        if v.Name == "TechUI" then
            v:Destroy()
        end
    end

    -- 颜色配置
    local config = {
        MainColor = Color3.fromRGB(20, 20, 40),
        TabColor = Color3.fromRGB(30, 30, 60),
        AccentColor = Color3.fromRGB(100, 150, 255),
        TextColor = Color3.fromRGB(220, 220, 255),
        SliderColor = Color3.fromRGB(80, 130, 255),
        ToggleOn = Color3.fromRGB(100, 255, 150),
        ToggleOff = Color3.fromRGB(60, 60, 90),
        ButtonHover = Color3.fromRGB(50, 50, 90)
    }

    -- 创建主UI
    local ui = Instance.new("ScreenGui")
    ui.Name = "TechUI"
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if syn and syn.protect_gui then
        syn.protect_gui(ui)
    end
    ui.Parent = game:GetService("CoreGui")

    -- 主窗口
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = config.MainColor
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    -- 科技感边框
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Size = UDim2.new(1, 4, 1, 4)
    border.Position = UDim2.new(0, -2, 0, -2)
    border.BackgroundColor3 = config.AccentColor
    border.BorderSizePixel = 0
    
    local innerBorder = Instance.new("Frame")
    innerBorder.Name = "InnerBorder"
    innerBorder.Size = UDim2.new(1, -4, 1, -4)
    innerBorder.Position = UDim2.new(0, 2, 0, 2)
    innerBorder.BackgroundColor3 = config.MainColor
    innerBorder.BorderSizePixel = 0
    
    -- 圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 10)
    borderCorner.Parent = border
    
    -- 标题栏
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = config.TabColor
    titleBar.BorderSizePixel = 0
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = name or "Tech UI"
    title.TextColor3 = config.TextColor
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 最小化按钮
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -30, 0, 0)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = config.TextColor
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 20
    
    -- 搜索框
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(0, 200, 0, 25)
    searchBox.Position = UDim2.new(0, 10, 0, 40)
    searchBox.BackgroundColor3 = config.TabColor
    searchBox.TextColor3 = config.TextColor
    searchBox.PlaceholderText = "搜索功能..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 180)
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 14
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    
    local searchPadding = Instance.new("UIPadding")
    searchPadding.PaddingLeft = UDim.new(0, 10)
    searchPadding.Parent = searchBox
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 6)
    searchCorner.Parent = searchBox
    
    -- 标签栏
    local tabButtons = Instance.new("Frame")
    tabButtons.Name = "TabButtons"
    tabButtons.Size = UDim2.new(0, 120, 0, 300)
    tabButtons.Position = UDim2.new(0, 10, 0, 75)
    tabButtons.BackgroundTransparency = 1
    
    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 5)
    tabList.Parent = tabButtons
    
    -- 内容区域
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(0, 440, 0, 300)
    contentFrame.Position = UDim2.new(0, 140, 0, 75)
    contentFrame.BackgroundTransparency = 1
    
    -- 组装UI
    border.Parent = mainFrame
    innerBorder.Parent = border
    titleBar.Parent = mainFrame
    title.Parent = titleBar
    minimizeBtn.Parent = titleBar
    searchBox.Parent = mainFrame
    tabButtons.Parent = mainFrame
    contentFrame.Parent = mainFrame
    mainFrame.Parent = ui
    
    -- 使窗口可拖动
    makeDraggable(mainFrame, titleBar)
    
    -- 最小化功能
    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            mainFrame.Size = UDim2.new(0, 600, 0, 40)
            minimizeBtn.Text = "+"
        else
            mainFrame.Size = UDim2.new(0, 600, 0, 400)
            minimizeBtn.Text = "-"
        end
    end)
    
    -- 窗口功能
    local window = {}
    local currentTab = nil
    
    function window:Tab(name, icon)
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Name = name .. "Tab"
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.ScrollBarThickness = 3
        tabFrame.ScrollBarImageColor3 = config.AccentColor
        tabFrame.Visible = false
        
        local tabListLayout = Instance.new("UIListLayout")
        tabListLayout.Padding = UDim.new(0, 10)
        tabListLayout.Parent = tabFrame
        
        -- 标签按钮
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Button"
        tabButton.Size = UDim2.new(1, 0, 0, 35)
        tabButton.BackgroundColor3 = config.TabColor
        tabButton.TextColor3 = config.TextColor
        tabButton.Text = "   " .. name
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.TextSize = 14
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.AutoButtonColor = false
        
        if icon then
            local iconImage = Instance.new("ImageLabel")
            iconImage.Name = "Icon"
            iconImage.Size = UDim2.new(0, 20, 0, 20)
            iconImage.Position = UDim2.new(0, 5, 0.5, 0)
            iconImage.AnchorPoint = Vector2.new(0, 0.5)
            iconImage.BackgroundTransparency = 1
            iconImage.Image = icon
            iconImage.Parent = tabButton
        end
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tabButton
        
        -- 悬停效果
        tabButton.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(tabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = config.ButtonHover
            }):Play()
        end)
        
        tabButton.MouseLeave:Connect(function()
            if currentTab ~= tabFrame then
                game:GetService("TweenService"):Create(tabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = config.TabColor
                }):Play()
            end
        end)
        
        -- 切换标签
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
                game:GetService("TweenService"):Create(
                    currentTabButton, 
                    TweenInfo.new(0.2), 
                    {BackgroundColor3 = config.TabColor}
                ):Play()
            end
            
            currentTab = tabFrame
            currentTabButton = tabButton
            tabFrame.Visible = true
            
            game:GetService("TweenService"):Create(tabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = config.AccentColor
            }):Play()
            
            createRippleEffect(tabButton)
        end)
        
        -- 默认显示第一个标签
        if not currentTab then
            currentTab = tabFrame
            currentTabButton = tabButton
            tabFrame.Visible = true
            tabButton.BackgroundColor3 = config.AccentColor
        end
        
        tabButton.Parent = tabButtons
        tabFrame.Parent = contentFrame
        
        local tab = {}
        
        function tab:Section(name)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = name .. "Section"
            sectionFrame.Size = UDim2.new(1, -20, 0, 40)
            sectionFrame.BackgroundColor3 = config.TabColor
            sectionFrame.BackgroundTransparency = 0.1
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 6)
            sectionCorner.Parent = sectionFrame
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "Title"
            sectionTitle.Size = UDim2.new(1, -10, 0, 20)
            sectionTitle.Position = UDim2.new(0, 10, 0, 5)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = name
            sectionTitle.TextColor3 = config.TextColor
            sectionTitle.Font = Enum.Font.GothamSemibold
            sectionTitle.TextSize = 14
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local contentFrame = Instance.new("Frame")
            contentFrame.Name = "Content"
            contentFrame.Size = UDim2.new(1, -10, 0, 0)
            contentFrame.Position = UDim2.new(0, 5, 0, 30)
            contentFrame.BackgroundTransparency = 1
            
            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Padding = UDim.new(0, 5)
            contentLayout.Parent = contentFrame
            
            sectionFrame.Parent = tabFrame
            sectionTitle.Parent = sectionFrame
            contentFrame.Parent = sectionFrame
            
            local section = {}
            
            function section:Button(text, callback)
                local button = Instance.new("TextButton")
                button.Name = text .. "Button"
                button.Size = UDim2.new(1, 0, 0, 30)
                button.BackgroundColor3 = config.TabColor
                button.TextColor3 = config.TextColor
                button.Text = "   " .. text
                button.Font = Enum.Font.Gotham
                button.TextSize = 14
                button.TextXAlignment = Enum.TextXAlignment.Left
                button.AutoButtonColor = false
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 4)
                buttonCorner.Parent = button
                
                -- 悬停效果
                button.MouseEnter:Connect(function()
                    game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = config.ButtonHover
                    }):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = config.TabColor
                    }):Play()
                end)
                
                -- 点击效果
                button.MouseButton1Click:Connect(function()
                    createRippleEffect(button)
                    if callback then callback() end
                end)
                
                button.Parent = contentFrame
            end
            
            function section:Toggle(text, flag, default, callback)
                default = default or false
                library.flags[flag] = default
                
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Name = text .. "Toggle"
                toggleFrame.Size = UDim2.new(1, 0, 0, 30)
                toggleFrame.BackgroundTransparency = 1
                
                local toggleText = Instance.new("TextLabel")
                toggleText.Name = "Text"
                toggleText.Size = UDim2.new(0.7, 0, 1, 0)
                toggleText.BackgroundTransparency = 1
                toggleText.Text = "   " .. text
                toggleText.TextColor3 = config.TextColor
                toggleText.Font = Enum.Font.Gotham
                toggleText.TextSize = 14
                toggleText.TextXAlignment = Enum.TextXAlignment.Left
                
                local toggleButton = Instance.new("Frame")
                toggleButton.Name = "Toggle"
                toggleButton.Size = UDim2.new(0, 50, 0, 25)
                toggleButton.Position = UDim2.new(1, -55, 0.5, 0)
                toggleButton.AnchorPoint = Vector2.new(1, 0.5)
                toggleButton.BackgroundColor3 = default and config.ToggleOn or config.ToggleOff
                
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 12)
                toggleCorner.Parent = toggleButton
                
                local toggleCircle = Instance.new("Frame")
                toggleCircle.Name = "Circle"
                toggleCircle.Size = UDim2.new(0, 21, 0, 21)
                toggleCircle.Position = UDim2.new(default and 0.6 or 0.1, 0, 0.5, 0)
                toggleCircle.AnchorPoint = Vector2.new(0, 0.5)
                toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                
                local circleCorner = Instance.new("UICorner")
                circleCorner.CornerRadius = UDim.new(0.5, 0)
                circleCorner.Parent = toggleCircle
                
                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Name = "Button"
                toggleBtn.Size = UDim2.new(1, 0, 1, 0)
                toggleBtn.BackgroundTransparency = 1
                toggleBtn.Text = ""
                
                toggleFrame.Parent = contentFrame
                toggleText.Parent = toggleFrame
                toggleButton.Parent = toggleFrame
                toggleCircle.Parent = toggleButton
                toggleBtn.Parent = toggleButton
                
                local function setState(state)
                    library.flags[flag] = state
                    game:GetService("TweenService"):Create(toggleButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = state and config.ToggleOn or config.ToggleOff
                    }):Play()
                    
                    game:GetService("TweenService"):Create(toggleCircle, TweenInfo.new(0.2), {
                        Position = UDim2.new(state and 0.6 or 0.1, 0, 0.5, 0)
                    }):Play()
                    
                    if callback then callback(state) end
                end
                
                toggleBtn.MouseButton1Click:Connect(function()
                    setState(not library.flags[flag])
                end)
                
                return {
                    SetState = setState
                }
            end
            
            function section:Slider(text, flag, min, max, default, callback)
                min = min or 0
                max = max or 100
                default = default or min
                library.flags[flag] = default
                
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = text .. "Slider"
                sliderFrame.Size = UDim2.new(1, 0, 0, 50)
                sliderFrame.BackgroundTransparency = 1
                
                local sliderText = Instance.new("TextLabel")
                sliderText.Name = "Text"
                sliderText.Size = UDim2.new(1, 0, 0, 20)
                sliderText.BackgroundTransparency = 1
                sliderText.Text = "   " .. text
                sliderText.TextColor3 = config.TextColor
                sliderText.Font = Enum.Font.Gotham
                sliderText.TextSize = 14
                sliderText.TextXAlignment = Enum.TextXAlignment.Left
                
                local sliderBar = Instance.new("Frame")
                sliderBar.Name = "Bar"
                sliderBar.Size = UDim2.new(1, -10, 0, 5)
                sliderBar.Position = UDim2.new(0, 5, 1, -15)
                sliderBar.BackgroundColor3 = config.TabColor
                
                local sliderBarCorner = Instance.new("UICorner")
                sliderBarCorner.CornerRadius = UDim.new(0, 3)
                sliderBarCorner.Parent = sliderBar
                
                local sliderFill = Instance.new("Frame")
                sliderFill.Name = "Fill"
                sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                sliderFill.BackgroundColor3 = config.SliderColor
                
                local sliderFillCorner = Instance.new("UICorner")
                sliderFillCorner.CornerRadius = UDim.new(0, 3)
                sliderFillCorner.Parent = sliderFill
                
                local sliderValue = Instance.new("TextLabel")
                sliderValue.Name = "Value"
                sliderValue.Size = UDim2.new(0, 50, 0, 20)
                sliderValue.Position = UDim2.new(1, -55, 0, 0)
                sliderValue.AnchorPoint = Vector2.new(1, 0)
                sliderValue.BackgroundTransparency = 1
                sliderValue.Text = tostring(default)
                sliderValue.TextColor3 = config.TextColor
                sliderValue.Font = Enum.Font.Gotham
                sliderValue.TextSize = 14
                sliderValue.TextXAlignment = Enum.TextXAlignment.Right
                
                local sliderBtn = Instance.new("TextButton")
                sliderBtn.Name = "Button"
                sliderBtn.Size = UDim2.new(0, 15, 0, 15)
                sliderBtn.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
                sliderBtn.AnchorPoint = Vector2.new(0.5, 0.5)
                sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderBtn.Text = ""
                
                local sliderBtnCorner = Instance.new("UICorner")
                sliderBtnCorner.CornerRadius = UDim.new(0.5, 0)
                sliderBtnCorner.Parent = sliderBtn
                
                sliderFrame.Parent = contentFrame
                sliderText.Parent = sliderFrame
                sliderBar.Parent = sliderFrame
                sliderFill.Parent = sliderBar
                sliderValue.Parent = sliderFrame
                sliderBtn.Parent = sliderBar
                
                local function setValue(value)
                    value = math.clamp(value, min, max)
                    library.flags[flag] = value
                    sliderValue.Text = tostring(math.floor(value))
                    
                    local percent = (value - min) / (max - min)
                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    sliderBtn.Position = UDim2.new(percent, 0, 0.5, 0)
                    
                    if callback then callback(value) end
                end
                
                local dragging = false
                
                sliderBtn.MouseButton1Down:Connect(function()
                    dragging = true
                end)
                
                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = game:GetService("Players").LocalPlayer:GetMouse().X
                        local barPos = sliderBar.AbsolutePosition.X
                        local barSize = sliderBar.AbsoluteSize.X
                        
                        local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
                        local value = min + (max - min) * percent
                        
                        setValue(value)
                    end
                end)
                
                setValue(default)
                
                return {
                    SetValue = setValue
                }
            end
            
            -- 其他控件可以类似添加...
            
            return section
        end
        
        return tab
    end
    
    -- 搜索功能
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = string.lower(searchBox.Text)
        
        for _, tab in pairs(contentFrame:GetChildren()) do
            if tab:IsA("ScrollingFrame") then
                for _, section in pairs(tab:GetDescendants()) do
                    if section:IsA("Frame") and section.Name:match("Section$") then
                        local found = false
                        
                        for _, element in pairs(section:GetDescendants()) do
                            if element:IsA("TextLabel") or element:IsA("TextButton") then
                                if string.find(string.lower(element.Text), searchText) then
                                    found = true
                                    break
                                end
                            end
                        end
                        
                        section.Visible = found or searchText == ""
                    end
                end
            end
        end
    end)
    
    return window
end

return library