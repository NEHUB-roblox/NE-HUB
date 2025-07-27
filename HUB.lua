local SansHubLib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local TOGGLE_ON_POS = UDim2.new(0, 16, 0, 1.5)
local TOGGLE_OFF_POS = UDim2.new(0, 2, 0, 1.5)
local TOGGLE_ACTIVE_COLOR = Color3.fromRGB(0, 200, 255)
local TOGGLE_INACTIVE_COLOR = Color3.fromRGB(255, 255, 255)
local SECTION_BORDER_COLOR = Color3.fromRGB(50, 50, 50)
local COMPONENT_BG_COLOR = Color3.fromRGB(30, 30, 40)
local SECTION_BG_COLOR = Color3.fromRGB(25, 25, 35)
local MAIN_BG_COLOR = Color3.fromRGB(20, 20, 30) -- 主窗口背景颜色

local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.Parent = parent
    return stroke
end

local function createSeparator(parent, position)
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, -20, 0, 1)
    separator.Position = position
    separator.BackgroundColor3 = SECTION_BORDER_COLOR
    separator.BorderSizePixel = 0
    separator.Parent = parent
    return separator
end

local function smoothTween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(duration or 0.2, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function SansHubLib:CreateWindow(name, version)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SansHubLib"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 450, 0, 350) -- 扩大UI
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    mainFrame.BackgroundColor3 = MAIN_BG_COLOR
    mainFrame.BackgroundTransparency = 0
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    mainFrame.ClipsDescendants = true

    createCorner(mainFrame, 15)
    createStroke(mainFrame)

    -- 添加背景渐变
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 50, 100)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 100, 150)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 150, 200))
    }
    gradient.Parent = mainFrame

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = mainFrame

    local player = Players.LocalPlayer
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 40, 0, 40)
    avatar.Position = UDim2.new(0, 10, 0, 5)
    avatar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    avatar.BorderSizePixel = 0
    avatar.Parent = titleBar
    createCorner(avatar, 20)

    pcall(function()
        avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)

    local titleMain = Instance.new("TextLabel")
    titleMain.Size = UDim2.new(0, 200, 0, 25)
    titleMain.Position = UDim2.new(0, 60, 0, 10)
    titleMain.BackgroundTransparency = 1
    titleMain.Text = name or "SansHub UI"
    titleMain.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleMain.TextSize = 20
    titleMain.Font = Enum.Font.SourceSansBold
    titleMain.TextXAlignment = Enum.TextXAlignment.Left
    titleMain.Parent = titleBar

    local titleSub = Instance.new("TextLabel")
    titleSub.Size = UDim2.new(0, 200, 0, 15)
    titleSub.Position = UDim2.new(0, 60, 0, 35)
    titleSub.BackgroundTransparency = 1
    titleSub.Text = version or "Version 1.0"
    titleSub.TextColor3 = Color3.fromRGB(0, 200, 255)
    titleSub.TextSize = 12
    titleSub.Font = Enum.Font.SourceSansBold
    titleSub.TextXAlignment = Enum.TextXAlignment.Left
    titleSub.Parent = titleBar

    createSeparator(mainFrame, UDim2.new(0, 10, 0, 50))

    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 25, 0, 25)
    minimizeButton.Position = UDim2.new(1, -65, 0, 10)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    minimizeButton.BackgroundTransparency = 0
    minimizeButton.Text = "—"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.TextSize = 16
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Modal = true
    minimizeButton.Parent = titleBar

    createCorner(minimizeButton, 10)
    createStroke(minimizeButton)

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -35, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.BackgroundTransparency = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Modal = true
    closeButton.Parent = titleBar

    createCorner(closeButton, 10)
    createStroke(closeButton)

    local restoreButton = Instance.new("TextButton")
    restoreButton.Size = UDim2.new(0, 50, 0, 50)
    restoreButton.Position = UDim2.new(0, 10, 0, 10)
    restoreButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    restoreButton.BackgroundTransparency = 0
    restoreButton.Text = name and string.sub(name, 1, 5) or "Sans"
    restoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    restoreButton.TextSize = 14
    restoreButton.Font = Enum.Font.GothamBold
    restoreButton.Visible = false
    restoreButton.Active = true
    restoreButton.Parent = screenGui

    createCorner(restoreButton, 15)
    createStroke(restoreButton)

    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(0, 80, 1, -60)
    tabFrame.Position = UDim2.new(0, 10, 0, 60)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = mainFrame

    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(0, 350, 1, -70)
    contentFrame.Position = UDim2.new(0, 100, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 5
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentFrame.Parent = mainFrame

    local contentLayout = Instance.new("UIListLayout", contentFrame)
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local dragging = false
    local dragStart = Vector2.new(0, 0)
    local frameStart = Vector2.new(0, 0)

    local function updateInput(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            frameStart.X.Scale, 
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale,
            frameStart.Y.Offset + delta.Y
        )
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            frameStart = mainFrame.Position
            
            if input.UserInputType == Enum.UserInputType.Touch then
                local conn
                conn = RunService.Heartbeat:Connect(function()
                    if dragging then
                        updateInput(UserInputService:GetMouseLocation())
                    else
                        conn:Disconnect()
                    end
                end)
            end
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateInput(input)
        end
    end)

    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local isMinimized = false
    
    minimizeButton.MouseButton1Click:Connect(function()
        task.wait(0.1)
        if not isMinimized then
            smoothTween(mainFrame, {Position = UDim2.new(0.5, -225, 1.5, 0)}, 0.3)
            task.wait(0.3)
            mainFrame.Visible = false
            restoreButton.Visible = true
            minimizeButton.Text = "□"
            isMinimized = true
        else
            mainFrame.Visible = true
            smoothTween(mainFrame, {Position = UDim2.new(0.5, -225, 0.5, -175)}, 0.3)
            restoreButton.Visible = false
            minimizeButton.Text = "—"
            isMinimized = false
        end
    end)

    restoreButton.MouseButton1Click:Connect(function()
        task.wait(0.1)
        mainFrame.Visible = true
        smoothTween(mainFrame, {Position = UDim2.new(0.5, -225, 0.5, -175)}, 0.3)
        restoreButton.Visible = false
        minimizeButton.Text = "—"
        isMinimized = false
    end)

    closeButton.MouseButton1Click:Connect(function()
        local confirmFrame = Instance.new("Frame")
        confirmFrame.Size = UDim2.new(0, 250, 0, 120)
        confirmFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
        confirmFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        confirmFrame.Parent = screenGui
        createCorner(confirmFrame, 15)
        createStroke(confirmFrame)

        local confirmTitle = Instance.new("TextLabel")
        confirmTitle.Size = UDim2.new(1, 0, 0, 30)
        confirmTitle.Position = UDim2.new(0, 0, 0, 10)
        confirmTitle.BackgroundTransparency = 1
        confirmTitle.Text = "关闭UI?"
        confirmTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        confirmTitle.TextSize = 18
        confirmTitle.Font = Enum.Font.GothamBold
        confirmTitle.Parent = confirmFrame

        local confirmText = Instance.new("TextLabel")
        confirmText.Size = UDim2.new(1, -20, 0, 40)
        confirmText.Position = UDim2.new(0, 10, 0, 40)
        confirmText.BackgroundTransparency = 1
        confirmText.Text = "你确定要关闭吗？ "
        confirmText.TextColor3 = Color3.fromRGB(200, 200, 200)
        confirmText.TextSize = 14
        confirmText.Font = Enum.Font.Gotham
        confirmText.TextWrapped = true
        confirmText.Parent = confirmFrame

        local confirmButton = Instance.new("TextButton")
        confirmButton.Size = UDim2.new(0, 100, 0, 30)
        confirmButton.Position = UDim2.new(0.5, -110, 1, -40)
        confirmButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        confirmButton.Text = "确定"
        confirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        confirmButton.TextSize = 14
        confirmButton.Font = Enum.Font.Gotham
        confirmButton.Parent = confirmFrame
        createCorner(confirmButton, 8)
        createStroke(confirmButton)

        local cancelButton = Instance.new("TextButton")
        cancelButton.Size = UDim2.new(0, 100, 0, 30)
        cancelButton.Position = UDim2.new(0.5, 10, 1, -40)
        cancelButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        cancelButton.Text = "取消"
        cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        cancelButtonTitle.TextSize = 14
        cancelButtonTitle.Font = Enum.Font.Gotham
        cancelButtonTitle.Parent = confirmFrame
        createCorner(cancelButton, 8)
        createStroke(cancelButton)

        confirmButton.MouseButton1Click:Connect(function()
            smoothTween(confirmFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.2)
            task.wait(0.2)
            confirmFrame:Destroy()
            smoothTween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
            task.wait(0.3)
            screenGui:Destroy()
        end)

        cancelButtonTitle.MouseButton1Click:Connect(function()
            smoothTween(confirmFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.2)
            task.wait(0.2)
            confirmFrame:Destroy()
        end)
    end)

    local tabs = {}
    local currentTab = nil
    
    function tabs:AddTab(name)
        local tabCount = #self
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -10, 0, 30)
        tabButton.Position = UDim2.new(0, 5, 0, 5 + (tabCount * 35))
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tabButton.BackgroundTransparency = 0.5
        tabButton.Text = name:upper()
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.TextSize = 12
        tabButton.Font = Enum.Font.Gotham
        tabButton.Modal = true
        tabButton.Parent = tabFrame

        createStroke(tabButton)
        createCorner(tabButton)

        local highlight = Instance.new("Frame")
        highlight.Size = UDim2.new(0, 3, 0.6, 0)
        highlight.Position = UDim2.new(0, -5, 0.2, 0)
        highlight.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        highlight.BackgroundTransparency = 0
        highlight.Visible = tabCount == 0
        highlight.Parent = tabButton

        local tabContentFrame = Instance.new("Frame")
        tabContentFrame.Size = UDim2.new(1, 0, 1, 0)
        tabContentFrame.BackgroundTransparency = 1
        tabContentFrame.Visible = tabCount == 0
        tabContentFrame.Parent = contentFrame

        local tabContentLayout = Instance.new("UIListLayout", tabContentFrame)
        tabContentLayout.Padding = UDim.new(0, 10)
        tabContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        if tabCount == 0 then
            currentTab = {button = tabButton, frame = tabContentFrame, highlight = highlight}
        end

        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.highlight.Visible = false
                smoothTween(currentTab.frame, {Position = UDim2.new(1, 0, 0, 0)}, 0.2)
                currentTab.frame.Visible = false
            end
            
            currentTab = {button = tabButton, frame = tabContentFrame, highlight = highlight}
            highlight.Visible = true
            tabContentFrame.Visible = true
            tabContentFrame.Position = UDim2.new(-1, 0, 0, 0)
            smoothTween(tabContentFrame, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
        end)

        local tabFunctions = {}
        
        local componentsContainer = Instance.new("Frame")
        componentsContainer.Size = UDim2.new(1, 0, 0, 0)
        componentsContainer.AutomaticSize = Enum.AutomaticSize.Y
        componentsContainer.BackgroundTransparency = 1
        componentsContainer.Parent = tabContentFrame

        local componentsLayout = Instance.new("UIListLayout", componentsContainer)
        componentsLayout.Padding = UDim.new(0, 10)
        componentsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        function tabFunctions:AddToggle(name, description, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -20, 0, 35)
            toggleFrame.BackgroundColor3 = COMPONENT_BG_COLOR
            toggleFrame.BackgroundTransparency = 0
            toggleFrame.Parent = componentsContainer

            createCorner(toggleFrame, 6)
            createStroke(toggleFrame)

            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -50, 0, 12)
            desc.Position = UDim2.new(0, 5, 0, 2)
            desc.BackgroundTransparency = 1
            desc.Text = description
            desc.TextColor3 = Color3.fromRGB(150, 150, 150)
            desc.TextSize = 10
            desc.Font = Enum.Font.Gotham
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = toggleFrame

            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(0, 30, 0, 15)
            toggle.Position = UDim2.new(1, -35, 0, 10)
            toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            toggle.BackgroundTransparency = 0
            toggle.Text = ""
            toggle.Modal = true
            toggle.Parent = toggleFrame

            createCorner(toggle, 6)

            local toggleCircle = Instance.new("Frame")
            toggleCircle.Size = UDim2.new(0, 12, 0, 12)
            toggleCircle.Position = TOGGLE_OFF_POS
            toggleCircle.BackgroundColor3 = TOGGLE_INACTIVE_COLOR
            toggleCircle.Parent = toggle

            createCorner(toggleCircle, 6)

            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Size = UDim2.new(0, 150, 0, 18)
            toggleLabel.Position = UDim2.new(0, 5, 0, 14)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = name
            toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggleLabel.TextSize = 14
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame

            local isActive = false
            
            local function updateToggle()
                if isActive then
                    smoothTween(toggleCircle, {Position = TOGGLE_ON_POS, BackgroundColor3 = TOGGLE_ACTIVE_COLOR}, 0.2)
                else
                    smoothTween(toggleCircle, {Position = TOGGLE_OFF_POS, BackgroundColor3 = TOGGLE_INACTIVE_COLOR}, 0.2)
                end
                if callback then callback(isActive) end
            end
            
            toggle.MouseButton1Click:Connect(function()
                isActive = not isActive
                updateToggle()
            end)
            
            local toggleObj = {}
            
            function toggleObj:Set(value)
                isActive = value
                updateToggle()
            end
            
            function toggleObj:Get()
                return isActive
            end
            
            return toggleObj
        end
        
        function tabFunctions:AddButton(name, description, callback)
            local buttonFrame = Instance.new("Frame")
            buttonFrame.Size = UDim2.new(1, -20, 0, 35)
            buttonFrame.BackgroundColor3 = COMPONENT_BG_COLOR
            buttonFrame.BackgroundTransparency = 0
            buttonFrame.Parent = componentsContainer

            createCorner(buttonFrame, 6)
            createStroke(buttonFrame)

            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -10, 0, 12)
            desc.Position = UDim2.new(0, 5, 0, 2)
            desc.BackgroundTransparency = 1
            desc.Text = description
            desc.TextColor3 = Color3.fromRGB(150, 150, 150)
            desc.TextSize = 10
            desc.Font = Enum.Font.Gotham
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = buttonFrame

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -20, 0, 20)
            button.Position = UDim2.new(0, 10, 0, 15)
            button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            button.BackgroundTransparency = 0
            button.Text = name
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.Font = Enum.Font.Gotham
            button.Parent = buttonFrame

            createCorner(button, 6)

            button.MouseButton1Click:Connect(function()
                smoothTween(button, {Size = UDim2.new(1, -25, 0, 18)}, 0.1)
                smoothTween(button, {Size = UDim2.new(1, -20, 0, 20)}, 0.1)
                if callback then callback() end
            end)
        end
        
        function tabFunctions:AddSlider(name, description, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -20, 0, 50)
            sliderFrame.BackgroundColor3 = COMPONENT_BG_COLOR
            sliderFrame.BackgroundTransparency = 0
            sliderFrame.Parent = componentsContainer

            createCorner(sliderFrame, 6)
            createStroke(sliderFrame)

            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -10, 0, 12)
            desc.Position = UDim2.new(0, 5, 0, 2)
            desc.BackgroundTransparency = 1
            desc.Text = description
            desc.TextColor3 = Color3.fromRGB(150, 150, 150)
            desc.TextSize = 10
            desc.Font = Enum.Font.Gotham
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = sliderFrame

            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Size = UDim2.new(0, 150, 0, 18)
            sliderLabel.Position = UDim2.new(0, 5, 0, 14)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = name
            sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            sliderLabel.TextSize = 14
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 50, 0, 18)
            valueLabel.Position = UDim2.new(1, -55, 0, 14)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(default)
            valueLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
            valueLabel.TextSize = 14
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = sliderFrame

            local sliderTrack = Instance.new("Frame")
            sliderTrack.Size = UDim2.new(1, -20, 0, 5)
            sliderTrack.Position = UDim2.new(0, 10, 1, -15)
            sliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            sliderTrack.Parent = sliderFrame

            createCorner(sliderTrack, 3)

            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new(0, 0, 1, 0)
            sliderFill.Position = UDim2.new(0, 0, 0, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
            sliderFill.Parent = sliderTrack

            createCorner(sliderFill, 3)

            local sliderButton = Instance.new("TextButton")
            sliderButton.Size = UDim2.new(0, 15, 2, 0)
            sliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
            sliderButton.Position = UDim2.new(0, 0, 0.5, 0)
            sliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
            sliderButton.AutoButtonColor = false
            sliderButton.Text = ""
            sliderButton.Parent = sliderTrack

            createCorner(sliderButton, 7)

            local currentValue = math.clamp(default or min, min, max)
            local isDragging = false

            local function updateSlider(value)
                currentValue = math.clamp(value, min, max)
                local ratio = (currentValue - min) / (max - min)
                smoothTween(sliderFill, {Size = UDim2.new(ratio, 0, 1, 0)}, 0.1)
                smoothTween(sliderButton, {Position = UDim2.new(ratio, 0, 0.5, 0)}, 0.1)
                valueLabel.Text = string.format("%.2f", currentValue)
                if callback then callback(currentValue) end
            end

            updateSlider(currentValue)

            sliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = true
                end
            end)
            
            sliderButton.InputChanged:Connect(function(input)
                if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mousePos = input.Position
                    local sliderPos = sliderTrack.AbsolutePosition
                    local sliderSize = sliderTrack.AbsoluteSize
                    local relativeX = math.clamp(mousePos.X - sliderPos.X, 0, sliderSize.X)
                    local ratio = relativeX / sliderSize.X
                    local value = min + ratio * (max - min)
                    updateSlider(value)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = false
                end
            end)

            local sliderObj = {}
            
            function sliderObj:Set(value)
                updateSlider(value)
            end
            
            function sliderObj:Get()
                return currentValue
            end
            
            return sliderObj
        end
        
        function tabFunctions:AddDropdown(name, description, options, default, callback)
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, -20, 0, 35)
            dropdownFrame.BackgroundColor3 = COMPONENT_BG_COLOR
            dropdownFrame.BackgroundTransparency = 0
            dropdownFrame.Parent = componentsContainer

            createCorner(dropdownFrame, 6)
            createStroke(dropdownFrame)

            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -50, 0, 12)
            desc.Position = UDim2.new(0, 5, 0, 2)
            desc.BackgroundTransparency = 1
            desc.Text = description
            desc.TextColor3 = Color3.fromRGB(150, 150, 150)
            desc.TextSize = 10
            desc.Font = Enum.Font.Gotham
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = dropdownFrame

            local dropdownLabel = Instance.new("TextLabel")
            dropdownLabel.Size = UDim2.new(0, 150, 0, 18)
            dropdownLabel.Position = UDim2.new(0, 5, 0, 14)
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Text = name
            dropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            dropdownLabel.TextSize = 14
            dropdownLabel.Font = Enum.Font.Gotham
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.Parent = dropdownFrame

            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Size = UDim2.new(0, 100, 0, 20)
            dropdownButton.Position = UDim2.new(1, -105, 0, 10)
            dropdownButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            dropdownButton.BackgroundTransparency = 0
            dropdownButton.Text = default or options[1] or "Select"
            dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            dropdownButton.TextSize = 12
            dropdownButton.Font = Enum.Font.Gotham
            dropdownButton.Parent = dropdownFrame

            createCorner(dropdownButton, 6)

            local dropdownList = Instance.new("ScrollingFrame")
            dropdownList.Size = UDim2.new(0, 100, 0, 0)
            dropdownList.Position = UDim2.new(1, -105, 0, 30)
            dropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            dropdownList.BorderSizePixel = 0
            dropdownList.ScrollBarThickness = 5
            dropdownList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
            dropdownList.ZIndex = 100
            dropdownList.Visible = false
            dropdownList.Parent = screenGui

            createCorner(dropdownList, 6)
            createStroke(dropdownList)

            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 2)
            listLayout.Parent = dropdownList

            local currentSelection = default or options[1]
            local isOpen = false

            local function updateDropdown()
                dropdownButton.Text = currentSelection
                if callback then callback(currentSelection) end
            end

            local function toggleDropdown()
                isOpen = not isOpen
                dropdownList.Visible = isOpen
                
                if isOpen then
                    local height = math.min(#options * 25, 125)
                    dropdownList.Size = UDim2.new(0, 100, 0, height)
                    dropdownList.CanvasSize = UDim2.new(0, 0, 0, #options * 25)
                    dropdownList.Position = UDim2.new(0, dropdownButton.AbsolutePosition.X - screenGui.AbsolutePosition.X, 0, dropdownButton.AbsolutePosition.Y - screenGui.AbsolutePosition.Y + 25)
                else
                    dropdownList.Size = UDim2.new(0, 100, 0, 0)
                end
            end

            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, -4, 0, 25)
                optionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                optionButton.BackgroundTransparency = 0
                optionButton.Text = option
                optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                optionButton.TextSize = 12
                optionButton.Font = Enum.Font.Gotham
                optionButton.ZIndex = 101
                optionButton.Parent = dropdownList

                createCorner(optionButton, 4)

                optionButton.MouseButton1Click:Connect(function()
                    currentSelection = option
                    updateDropdown()
                    toggleDropdown()
                end)
            end

            dropdownButton.MouseButton1Click:Connect(toggleDropdown)

            local conn
            conn = UserInputService.InputBegan:Connect(function(input, processed)
                if not processed and (input.UserInputType == Enum.UserInputType.MouseButton1 or 
                   input.UserInputType == Enum.UserInputType.Touch) and isOpen then
                    local inputPos = input.Position
                    local buttonPos = dropdownButton.AbsolutePosition
                    local buttonSize = dropdownButton.AbsoluteSize
                    local listPos = dropdownList.AbsolutePosition
                    local listSize = dropdownList.AbsoluteSize
                    
                    if not ((inputPos.X >= buttonPos.X and inputPos.X <= buttonPos.X + buttonSize.X and
                            inputPos.Y >= buttonPos.Y and inputPos.Y <= buttonPos.Y + buttonSize.Y) or
                           (inputPos.X >= listPos.X and inputPos.X <= listPos.X + listSize.X and
                            inputPos.Y >= listPos.Y and inputPos.Y <= listPos.Y + listSize.Y)) then
                        toggleDropdown()
                    end
                end
            end)

            updateDropdown()

            local dropdownObj = {}
            
            function dropdownObj:Set(value)
                if table.find(options, value) then
                    currentSelection = value
                    updateDropdown()
                end
            end
            
            function dropdownObj:Get()
                return currentSelection
            end
            
            return dropdownObj
        end
        
        function tabFunctions:AddInput(name, description, placeholder, callback)
            local inputFrame = Instance.new("Frame")
            inputFrame.Size = UDim2.new(1, -20, 0, 35)
            inputFrame.BackgroundColor3 = COMPONENT_BG_COLOR
            inputFrame.BackgroundTransparency = 0
            inputFrame.Parent = componentsContainer

            createCorner(inputFrame, 6)
            createStroke(inputFrame)

            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -10, 0, 12)
            desc.Position = UDim2.new(0, 5, 0, 2)
            desc.BackgroundTransparency = 1
            desc.Text = description
            desc.TextColor3 = Color3.fromRGB(150, 150, 150)
            desc.TextSize = 10
            desc.Font = Enum.Font.Gotham
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = inputFrame

            local inputLabel = Instance.new("TextLabel")
            inputLabel.Size = UDim2.new(0, 150, 0, 18)
            inputLabel.Position = UDim2.new(0, 5, 0, 14)
            inputLabel.BackgroundTransparency = 1
            inputLabel.Text = name
            inputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            inputLabel.TextSize = 14
            inputLabel.Font = Enum.Font.Gotham
            inputLabel.TextXAlignment = Enum.TextXAlignment.Left
            inputLabel.Parent = inputFrame

            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(0, 100, 0, 20)
            textBox.Position = UDim2.new(1, -105, 0, 10)
            textBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            textBox.BackgroundTransparency = 0
            textBox.Text = ""
            textBox.PlaceholderText = placeholder or "Enter text..."
            textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            textBox.TextSize = 12
            textBox.Font = Enum.Font.Gotham
            textBox.ClearTextOnFocus = false
            textBox.Parent = inputFrame

            createCorner(textBox, 4)

            textBox.FocusLost:Connect(function(enterPressed)
                if enterPressed and callback then
                    callback(textBox.Text)
                end
            end)

            local inputObj = {}
            
            function inputObj:Set(value)
                textBox.Text = tostring(value)
            end
            
            function inputObj:Get()
                return textBox.Text
            end
            
            return inputObj
        end
        
        function tabFunctions:AddLabel(text, color)
            local labelFrame = Instance.new("Frame")
            labelFrame.Size = UDim2.new(1, -20, 0, 25)
            labelFrame.BackgroundTransparency = 1
            labelFrame.Parent = componentsContainer

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
            label.TextSize = 14
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = labelFrame
        end
        
        function tabFunctions:AddSection(title)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, -20, 0, 0)
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            sectionFrame.BackgroundColor3 = SECTION_BG_COLOR
            sectionFrame.BackgroundTransparency = 0
            sectionFrame.Parent = componentsContainer

            createCorner(sectionFrame, 8)
            createStroke(sectionFrame, SECTION_BORDER_COLOR, 2)

            local titleBar = Instance.new("Frame")
            titleBar.Size = UDim2.new(1, 0, 0, 30)
            titleBar.BackgroundTransparency = 1
            titleBar.Parent = sectionFrame

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, -10, 1, 0)
            titleLabel.Position = UDim2.new(0, 10, 0, 0)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = title
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLabel.TextSize = 16
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Parent = titleBar

            createSeparator(sectionFrame, UDim2.new(0, 10, 0, 30))

            local contentFrame = Instance.new("Frame")
            contentFrame.Size = UDim2.new(1, 0, 0, 0)
            contentFrame.AutomaticSize = Enum.AutomaticSize.Y
            contentFrame.BackgroundTransparency = 1
            contentFrame.Position = UDim2.new(0, 0, 0, 30)
            contentFrame.Parent = sectionFrame

            local contentLayout = Instance.new("UIListLayout", contentFrame)
            contentLayout.Padding = UDim.new(0, 10)
            contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

            local sectionFunctions = {}
            
            function sectionFunctions:AddToggle(name, description, callback)
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Size = UDim2.new(1, -20, 0, 35)
                toggleFrame.BackgroundColor3 = COMPONENT_BG_COLOR
                toggleFrame.BackgroundTransparency = 0
                toggleFrame.Parent = contentFrame

                createCorner(toggleFrame, 6)
                createStroke(toggleFrame)

                local desc = Instance.new("TextLabel")
                desc.Size = UDim2.new(1, -50, 0, 12)
                desc.Position = UDim2.new(0, 5, 0, 2)
                desc.BackgroundTransparency = 1
                desc.Text = description
                desc.TextColor3 = Color3.fromRGB(150, 150, 150)
                desc.TextSize = 10
                desc.Font = Enum.Font.Gotham
                desc.TextXAlignment = Enum.TextXAlignment.Left
                desc.Parent = toggleFrame

                local toggle = Instance.new("TextButton")
                toggle.Size = UDim2.new(0, 30, 0, 15)
                toggle.Position = UDim2.new(1, -35, 0, 10)
                toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                toggle.BackgroundTransparency = 0
                toggle.Text = ""
                toggle.Modal = true
                toggle.Parent = toggleFrame

                createCorner(toggle, 6)

                local toggleCircle = Instance.new("Frame")
                toggleCircle.Size = UDim2.new(0, 12, 0, 12)
                toggleCircle.Position = TOGGLE_OFF_POS
                toggleCircle.BackgroundColor3 = TOGGLE_INACTIVE_COLOR
                toggleCircle.Parent = toggle

                createCorner(toggleCircle, 6)

                local toggleLabel = Instance.new("TextLabel")
                toggleLabel.Size = UDim2.new(0, 150, 0, 18)
                toggleLabel.Position = UDim2.new(0, 5, 0, 14)
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Text = name
                toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                toggleLabel.TextSize = 14
                toggleLabel.Font = Enum.Font.Gotham
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                toggleLabel.Parent = toggleFrame

                local isActive = false
                
                local function updateToggle()
                    if isActive then
                        smoothTween(toggleCircle, {Position = TOGGLE_ON_POS, BackgroundColor3 = TOGGLE_ACTIVE_COLOR}, 0.2)
                    else
                        smoothTween(toggleCircle, {Position = TOGGLE_OFF_POS, BackgroundColor3 = TOGGLE_INACTIVE_COLOR}, 0.2)
                    end
                    if callback then callback(isActive) end
                end
                
                toggle.MouseButton1Click:Connect(function()
                    isActive = not isActive
                    updateToggle()
                end)
                
                local toggleObj = {}
                
                function toggleObj:Set(value)
                    isActive = value
                    updateToggle()
                end
                
                function toggleObj:Get()
                    return isActive
                end
                
                return toggleObj
            end
            
            function sectionFunctions:AddButton(name, description, callback)
                local buttonFrame = Instance.new("Frame")
                buttonFrame.Size = UDim2.new(1, -20, 0, 35)
                buttonFrame.BackgroundColor3 = COMPONENT_BG_COLOR
                buttonFrame.BackgroundTransparency = 0
                buttonFrame.Parent = contentFrame

                createCorner(buttonFrame, 6)
                createStroke(buttonFrame)

                local desc = Instance.new("TextLabel")
                desc.Size = UDim2.new(1, -10, 0, 12)
                desc.Position = UDim2.new(0, 5, 0, 2)
                desc.BackgroundTransparency = 1
                desc.Text = description
                desc.TextColor3 = Color3.fromRGB(150, 150, 150)
                desc.TextSize = 10
                desc.Font = Enum.Font.Gotham
                desc.TextXAlignment = Enum.TextXAlignment.Left
                desc.Parent = buttonFrame

                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, -20, 0, 20)
                button.Position = UDim2.new(0, 10, 0, 15)
                button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                button.BackgroundTransparency = 0
                button.Text = name
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.TextSize = 14
                button.Font = Enum.Font.Gotham
                button.Parent = buttonFrame

                createCorner(button, 6)

                button.MouseButton1Click:Connect(function()
                    smoothTween(button, {Size = UDim2.new(1, -25, 0, 18)}, 0.1)
                    smoothTween(button, {Size = UDim2.new(1, -20, 0, 20)}, 0.1)
                    if callback then callback() end
                end)
            end
            
            function sectionFunctions:AddSlider(name, description, min, max, default, callback)
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Size = UDim2.new(1, -20, 0, 50)
                sliderFrame.BackgroundColor3 = COMPONENT_BG_COLOR
                sliderFrame.BackgroundTransparency = 0
                sliderFrame.Parent = contentFrame

                createCorner(sliderFrame, 6)
                createStroke(sliderFrame)

                local desc = Instance.new("TextLabel")
                desc.Size = UDim2.new(1, -10, 0, 12)
                desc.Position = UDim2.new(0, 5, 0, 2)
                desc.BackgroundTransparency = 1
                desc.Text = description
                desc.TextColor3 = Color3.fromRGB(150, 150, 150)
                desc.TextSize = 10
                desc.Font = Enum.Font.Gotham
                desc.TextXAlignment = Enum.TextXAlignment.Left
                desc.Parent = sliderFrame

                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Size = UDim2.new(0, 150, 0, 18)
                sliderLabel.Position = UDim2.new(0, 5, 0, 14)
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Text = name
                sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                sliderLabel.TextSize = 14
                sliderLabel.Font = Enum.Font.Gotham
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                sliderLabel.Parent = sliderFrame

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 50, 0, 18)
                valueLabel.Position = UDim2.new(1, -55, 0, 14)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = tostring(default)
                valueLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
                valueLabel.TextSize = 14
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.Parent = sliderFrame

                local sliderTrack = Instance.new("Frame")
                sliderTrack.Size = UDim2.new(1, -20, 0, 5)
                sliderTrack.Position = UDim2.new(0, 10, 1, -15)
                sliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                sliderTrack.Parent = sliderFrame

                createCorner(sliderTrack, 3)

                local sliderFill = Instance.new("Frame")
                sliderFill.Size = UDim2.new(0, 0, 1, 0)
                sliderFill.Position = UDim2.new(0, 0, 0, 0)
                sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
                sliderFill.Parent = sliderTrack

                createCorner(sliderFill, 3)

                local sliderButton = Instance.new("TextButton")
                sliderButton.Size = UDim2.new(0, 15, 2, 0)
                sliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
                sliderButton.Position = UDim2.new(0, 0, 0.5, 0)
                sliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
                sliderButton.AutoButtonColor = false
                sliderButton.Text = ""
                sliderButton.Parent = sliderTrack

                createCorner(sliderButton, 7)

                local currentValue = math.clamp(default or min, min, max)
                local isDragging = false

                local function updateSlider(value)
                    currentValue = math.clamp(value, min, max)
                    local ratio = (currentValue - min) / (max - min)
                    smoothTween(sliderFill, {Size = UDim2.new(ratio, 0, 1, 0)}, 0.1)
                    smoothTween(sliderButton, {Position = UDim2.new(ratio, 0, 0.5, 0)}, 0.1)
                    valueLabel.Text = string.format("%.2f", currentValue)
                    if callback then callback(currentValue) end
                end

                updateSlider(currentValue)

                sliderButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = true
                    end
                end)
                
                sliderButton.InputChanged:Connect(function(input)
                    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local mousePos = input.Position
                        local sliderPos = sliderTrack.AbsolutePosition
                        local sliderSize = sliderTrack.AbsoluteSize
                        local relativeX = math.clamp(mousePos.X - sliderPos.X, 0, sliderSize.X)
                        local ratio = relativeX / sliderSize.X
                        local value = min + ratio * (max - min)
                        updateSlider(value)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = false
                    end
                end)

                local sliderObj = {}
                
                function sliderObj:Set(value)
                    updateSlider(value)
                end
                
                function sliderObj:Get()
                    return currentValue
                end
                
                return sliderObj
            end
            
            function sectionFunctions:AddDropdown(name, description, options, default, callback)
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Size = UDim2.new(1, -20, 0, 35)
                dropdownFrame.BackgroundColor3 = COMPONENT_BG_COLOR
                dropdownFrame.BackgroundTransparency = 0
                dropdownFrame.Parent = contentFrame

                createCorner(dropdownFrame, 6)
                createStroke(dropdownFrame)

                local desc = Instance.new("TextLabel")
                desc.Size = UDim2.new(1, -50, 0, 12)
                desc.Position = UDim2.new(0, 5, 0, 2)
                desc.BackgroundTransparency = 1
                desc.Text = description
                desc.TextColor3 = Color3.fromRGB(150, 150, 150)
                desc.TextSize = 10
                desc.Font = Enum.Font.Gotham
                desc.TextXAlignment = Enum.TextXAlignment.Left
                desc.Parent = dropdownFrame

                local dropdownLabel = Instance.new("TextLabel")
                dropdownLabel.Size = UDim2.new(0, 150, 0, 18)
                dropdownLabel.Position = UDim2.new(0, 5, 0, 14)
                dropdownLabel.BackgroundTransparency = 1
                dropdownLabel.Text = name
                dropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                dropdownLabel.TextSize = 14
                dropdownLabel.Font = Enum.Font.Gotham
                dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                dropdownLabel.Parent = dropdownFrame

                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Size = UDim2.new(0, 100, 0, 20)
                dropdownButton.Position = UDim2.new(1, -105, 0, 10)
                dropdownButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                dropdownButton.BackgroundTransparency = 0
                dropdownButton.Text = default or options[1] or "Select"
                dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                dropdownButton.TextSize = 12
                dropdownButton.Font = Enum.Font.Gotham
                dropdownButton.Parent = dropdownFrame

                createCorner(dropdownButton, 6)

                local dropdownList = Instance.new("ScrollingFrame")
                dropdownList.Size = UDim2.new(0, 100, 0, 0)
                dropdownList.Position = UDim2.new(1, -105, 0, 30)
                dropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                dropdownList.BorderSizePixel = 0
                dropdownList.ScrollBarThickness = 5
                dropdownList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
                dropdownList.ZIndex = 100
                dropdownList.Visible = false
                dropdownList.Parent = screenGui

                createCorner(dropdownList, 6)
                createStroke(dropdownList)

                local listLayout = Instance.new("UIListLayout")
                listLayout.Padding = UDim.new(0, 2)
                listLayout.Parent = dropdownList

                local currentSelection = default or options[1]
                local isOpen = false

                local function updateDropdown()
                    dropdownButton.Text = currentSelection
                    if callback then callback(currentSelection) end
                end

                local function toggleDropdown()
                    isOpen = not isOpen
                    dropdownList.Visible = isOpen
                    
                    if isOpen then
                        local height = math.min(#options * 25, 125)
                        dropdownList.Size = UDim2.new(0, 100, 0, height)
                        dropdownList.CanvasSize = UDim2.new(0, 0, 0, #options * 25)
                        dropdownList.Position = UDim2.new(0, dropdownButton.AbsolutePosition.X - screenGui.AbsolutePosition.X, 0, dropdownButton.AbsolutePosition.Y - screenGui.AbsolutePosition.Y + 25)
                    else
                        dropdownList.Size = UDim2.new(0, 100, 0, 0)
                    end
                end

                for i, option in ipairs(options) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Size = UDim2.new(1, -4, 0, 25)
                    optionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    optionButton.BackgroundTransparency = 0
                    optionButton.Text = option
                    optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    optionButton.TextSize = 12
                    optionButton.Font = Enum.Font.Gotham
                    optionButton.ZIndex = 101
                    optionButton.Parent = dropdownList

                    createCorner(optionButton, 4)

                    optionButton.MouseButton1Click:Connect(function()
                        currentSelection = option
                        updateDropdown()
                        toggleDropdown()
                    end)
                end

                dropdownButton.MouseButton1Click:Connect(toggleDropdown)

                local conn
                conn = UserInputService.InputBegan:Connect(function(input, processed)
                    if not processed and (input.UserInputType == Enum.UserInputType.MouseButton1 or 
                       input.UserInputType == Enum.UserInputType.Touch) and isOpen then
                        local inputPos = input.Position
                        local buttonPos = dropdownButton.AbsolutePosition
                        local buttonSize = dropdownButton.AbsoluteSize
                        local listPos = dropdownList.AbsolutePosition
                        local listSize = dropdownList.AbsoluteSize
                        
                        if not ((inputPos.X >= buttonPos.X and inputPos.X <= buttonPos.X + buttonSize.X and
                                inputPos.Y >= buttonPos.Y and inputPos.Y <= buttonPos.Y + buttonSize.Y) or
                               (inputPos.X >= listPos.X and inputPos.X <= listPos.X + listSize.X and
                                inputPos.Y >= listPos.Y and inputPos.Y <= listPos.Y + listSize.Y)) then
                            toggleDropdown()
                        end
                    end
                end)

                updateDropdown()

                local dropdownObj = {}
                
                function dropdownObj:Set(value)
                    if table.find(options, value) then
                        currentSelection = value
                        updateDropdown()
                    end
                end
                
                function dropdownObj:Get()
                    return currentSelection
                end
                
                return dropdownObj
            end
            
            function sectionFunctions:AddInput(name, description, placeholder, callback)
                local inputFrame = Instance.new("Frame")
                inputFrame.Size = UDim2.new(1, -20, 0, 35)
                inputFrame.BackgroundColor3 = COMPONENT_BG_COLOR
                inputFrame.BackgroundTransparency = 0
                inputFrame.Parent = contentFrame

                createCorner(inputFrame, 6)
                createStroke(inputFrame)

                local desc = Instance.new("TextLabel")
                desc.Size = UDim2.new(1, -10, 0, 12)
                desc.Position = UDim2.new(0, 5, 0, 2)
                desc.BackgroundTransparency = 1
                desc.Text = description
                desc.TextColor3 = Color3.fromRGB(150, 150, 150)
                desc.TextSize = 10
                desc.Font = Enum.Font.Gotham
                desc.TextXAlignment = Enum.TextXAlignment.Left
                desc.Parent = inputFrame

                local inputLabel = Instance.new("TextLabel")
                inputLabel.Size = UDim2.new(0, 150, 0, 18)
                inputLabel.Position = UDim2.new(0, 5, 0, 14)
                inputLabel.BackgroundTransparency = 1
                inputLabel.Text = name
                inputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                inputLabel.TextSize = 14
                inputLabel.Font = Enum.Font.Gotham
                inputLabel.TextXAlignment = Enum.TextXAlignment.Left
                inputLabel.Parent = inputFrame

                local textBox = Instance.new("TextBox")
                textBox.Size = UDim2.new(0, 100, 0, 20)
                textBox.Position = UDim2.new(1, -105, 0, 10)
                textBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                textBox.BackgroundTransparency = 0
                textBox.Text = ""
                textBox.PlaceholderText = placeholder or "Enter text..."
                textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                textBox.TextSize = 12
                textBox.Font = Enum.Font.Gotham
                textBox.ClearTextOnFocus = false
                textBox.Parent = inputFrame

                createCorner(textBox, 4)

                textBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed and callback then
                        callback(textBox.Text)
                    end
                end)

                local inputObj = {}
                
                function inputObj:Set(value)
                    textBox.Text = tostring(value)
                end
                
                function inputObj:Get()
                    return textBox.Text
                end
                
                return inputObj
            end
            
            function sectionFunctions:AddLabel(text, color)
                local labelFrame = Instance.new("Frame")
                labelFrame.Size = UDim2.new(1, -20, 0, 25)
                labelFrame.BackgroundTransparency = 1
                labelFrame.Parent = contentFrame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
                label.TextSize = 14
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = labelFrame
            end
            
            function sectionFunctions:AddExpandList(name, description, items)
                local expandListFrame = Instance.new("Frame")
                expandListFrame.Size = UDim2.new(1, -20, 0, 30)
                expandListFrame.BackgroundTransparency = 1
                expandListFrame.Parent = contentFrame

                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, 0, 1, 0)
                container.BackgroundColor3 = COMPONENT_BG_COLOR
                container.Parent = expandListFrame
                createCorner(container, 6)
                createStroke(container)

                local titleBar = Instance.new("Frame")
                titleBar.Size = UDim2.new(1, 0, 0, 30)
                titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                titleBar.Parent = container
                createCorner(titleBar, 6)

                local titleLabel = Instance.new("TextLabel")
                titleLabel.Text = name
                titleLabel.Font = Enum.Font.Gotham
                titleLabel.TextSize = 14
                titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
                titleLabel.Position = UDim2.new(0.1, 0, 0, 0)
                titleLabel.BackgroundTransparency = 1
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                titleLabel.Parent = titleBar

                local toggleButton = Instance.new("TextButton")
                toggleButton.Text = "+"
                toggleButton.Font = Enum.Font.GothamBold
                toggleButton.TextSize = 16
                toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                toggleButton.Size = UDim2.new(0.2, 0, 1, 0)
                toggleButton.Position = UDim2.new(0.8, 0, 0, 0)
                toggleButton.BackgroundTransparency = 1
                toggleButton.Parent = titleBar

                local contentArea = Instance.new("ScrollingFrame")
                contentArea.Size = UDim2.new(1, 0, 0, 0)
                contentArea.Position = UDim2.new(0, 0, 0, 30)
                contentArea.BackgroundTransparency = 1
                contentArea.ScrollBarThickness = 4
                contentArea.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
                contentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
                contentArea.Visible = false
                contentArea.Parent = container

                local contentLayout = Instance.new("UIListLayout", contentArea)
                contentLayout.Padding = UDim.new(0, 5)

                local searchBox = Instance.new("Frame")
                searchBox.Size = UDim2.new(1, -10, 0, 30)
                searchBox.Position = UDim2.new(0, 5, 0, 0)
                searchBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                searchBox.Parent = contentArea
                createCorner(searchBox, 6)

                local searchLabel = Instance.new("TextLabel")
                searchLabel.Text = "搜索:"
                searchLabel.Font = Enum.Font.Gotham
                searchLabel.TextSize = 12
                searchLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                searchLabel.Size = UDim2.new(0.2, 0, 1, 0)
                searchLabel.BackgroundTransparency = 1
                searchLabel.Parent = searchBox

                local searchInput = Instance.new("TextBox")
                searchInput.Size = UDim2.new(0.8, 0, 1, 0)
                searchInput.Position = UDim2.new(0.2, 0, 0, 0)
                searchInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                searchInput.TextColor3 = Color3.fromRGB(255, 255, 255)
                searchInput.Font = Enum.Font.Gotham
                searchInput.TextSize = 12
                searchInput.PlaceholderText = "输入关键词..."
                searchInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
                searchInput.Parent = searchBox
                createCorner(searchInput, 4)

                local itemsContainer = Instance.new("Frame")
                itemsContainer.Size = UDim2.new(1, -10, 0, 0)
                itemsContainer.Position = UDim2.new(0, 5, 0, 35)
                itemsContainer.AutomaticSize = Enum.AutomaticSize.Y
                itemsContainer.BackgroundTransparency = 1
                itemsContainer.Parent = contentArea

                local itemsLayout = Instance.new("UIListLayout", itemsContainer)
                itemsLayout.Padding = UDim.new(0, 5)

                for _, item in ipairs(items or {}) do
                    if item.Type == "Checkbox" or item.Type == "多选" then
                        local checkboxFrame = Instance.new("Frame")
                        checkboxFrame.Size = UDim2.new(1, 0, 0, 25)
                        checkboxFrame.BackgroundTransparency = 1
                        checkboxFrame.Parent = itemsContainer

                        local checkbox = Instance.new("TextButton")
                        checkbox.Text = ""
                        checkbox.Size = UDim2.new(0, 18, 0, 18)
                        checkbox.Position = UDim2.new(0, 5, 0, 3)
                        checkbox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                        checkbox.Parent = checkboxFrame
                        createCorner(checkbox, 4)

                        local checkboxLabel = Instance.new("TextLabel")
                        checkboxLabel.Text = item.Text
                        checkboxLabel.Font = Enum.Font.Gotham
                        checkboxLabel.TextSize = 12
                        checkboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        checkboxLabel.Size = UDim2.new(0.9, -28, 1, 0)
                        checkboxLabel.Position = UDim2.new(0, 30, 0, 0)
                        checkboxLabel.BackgroundTransparency = 1
                        checkboxLabel.Parent = checkboxFrame

                        checkbox.MouseButton1Click:Connect(function()
                            if checkbox.BackgroundColor3 == Color3.fromRGB(70, 70, 70) then
                                smoothTween(checkbox, {BackgroundColor3 = Color3.fromRGB(0, 200, 255)}, 0.2)
                                pcall(item.Callback, true)
                            else
                                smoothTween(checkbox, {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}, 0.2)
                                pcall(item.Callback, false)
                            end
                        end)
                    elseif item.Type == "Radio" or item.Type == "单选" then
                        local radioFrame = Instance.new("Frame")
                        radioFrame.Size = UDim2.new(1, 0, 0, 25)
                        radioFrame.BackgroundTransparency = 1
                        radioFrame.Parent = itemsContainer

                        local radioButton = Instance.new("TextButton")
                        radioButton.Text = ""
                        radioButton.Size = UDim2.new(0, 18, 0, 18)
                        radioButton.Position = UDim2.new(0, 5, 0, 3)
                        radioButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                        radioButton.Parent = radioFrame
                        createCorner(radioButton, 9)

                        local radioLabel = Instance.new("TextLabel")
                        radioLabel.Text = item.Text
                        radioLabel.Font = Enum.Font.Gotham
                        radioLabel.TextSize = 12
                        radioLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        radioLabel.Size = UDim2.new(0.9, -28, 1, 0)
                        radioLabel.Position = UDim2.new(0, 30, 0, 0)
                        radioLabel.BackgroundTransparency = 1
                        radioLabel.Parent = radioFrame

                        radioButton.MouseButton1Click:Connect(function()
                            for _, radio in ipairs(itemsContainer:GetChildren()) do
                                if radio:IsA("Frame") then
                                    for _, child in ipairs(radio:GetChildren()) do
                                        if child:IsA("TextButton") then
                                            smoothTween(child, {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}, 0.2)
                                        end
                                    end
                                end
                            end
                            smoothTween(radioButton, {BackgroundColor3 = Color3.fromRGB(0, 200, 255)}, 0.2)
                            pcall(item.Callback)
                        end)
                    elseif item.Type == "Tag" or item.Type == "标签" then
                        local tagFrame = Instance.new("Frame")
                        tagFrame.Size = UDim2.new(0.3, 0, 0, 25)
                        tagFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                        tagFrame.Parent = itemsContainer
                        createCorner(tagFrame, 4)

                        local tagLabel = Instance.new("TextLabel")
                        tagLabel.Text = item.Text
                        tagLabel.Font = Enum.Font.Gotham
                        tagLabel.TextSize = 12
                        tagLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        tagLabel.Size = UDim2.new(1, -10, 1, 0)
                        tagLabel.Position = UDim2.new(0, 10, 0, 0)
                        tagLabel.BackgroundTransparency = 1
                        tagLabel.Parent = tagFrame
                    end
                end

                searchInput.FocusLost:Connect(function()
                    local searchText = searchInput.Text:lower()
                    for _, child in ipairs(itemsContainer:GetChildren()) do
                        if child:IsA("Frame") then
                            local text = child:FindFirstChild("TextLabel") and child:FindFirstChild("TextLabel").Text:lower() or ""
                            child.Visible = text:find(searchText) ~= nil
                        end
                    end
                end)

                toggleButton.MouseButton1Click:Connect(function()
                    if toggleButton.Text == "+" then
                        toggleButton.Text = "-"
                        contentArea.Visible = true
                        smoothTween(expandListFrame, {Size = UDim2.new(1, -20, 0, 200)}, 0.2)
                        smoothTween(contentArea, {Size = UDim2.new(1, 0, 1, -30)}, 0.2)
                    else
                        toggleButton.Text = "+"
                        smoothTween(expandListFrame, {Size = UDim2.new(1, -20, 0, 30)}, 0.2)
                        smoothTween(contentArea, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        contentArea.Visible = false
                    end
                end)

                local expandListObj = {}
                
                function expandListObj:SetVisible(visible)
                    if visible then
                        toggleButton.Text = "-"
                        contentArea.Visible = true
                        expandListFrame.Size = UDim2.new(1, -20, 0, 200)
                        contentArea.Size = UDim2.new(1, 0, 1, -30)
                    else
                        toggleButton.Text = "+"
                        expandListFrame.Size = UDim2.new(1, -20, 0, 30)
                        contentArea.Size = UDim2.new(1, 0, 0, 0)
                        contentArea.Visible = false
                    end
                end
                
                return expandListObj
            end
            
            return sectionFunctions
        end

        table.insert(self, {})
        return tabFunctions
    end

    smoothTween(mainFrame, {Position = UDim2.new(0.5, -225, 0.5, -175)}, 0.5)

    return tabs
end

return SansHubLib
