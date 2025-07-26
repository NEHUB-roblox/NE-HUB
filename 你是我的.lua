local library = {}
local ToggleUI = false
library.currentTab = nil
library.flags = {}

-- Services
local services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end
})
local tweenService = services.TweenService
local inputService = services.UserInputService
local runService = services.RunService
local players = services.Players
local mouse = players.LocalPlayer:GetMouse()

-- Helper functions
function Tween(obj, t, data)
    tweenService:Create(obj, TweenInfo.new(t[1], Enum.EasingStyle[t[2]], Enum.EasingDirection[t[3]]), data):Play()
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
        Ripple.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Ripple.Position = UDim2.new(
            (mouse.X - Ripple.AbsolutePosition.X) / obj.AbsoluteSize.X,
            0,
            (mouse.Y - Ripple.AbsolutePosition.Y) / obj.AbsoluteSize.Y,
            0
        )
        Tween(Ripple, {0.3, "Linear", "InOut"}, {Position = UDim2.new(-5.5, 0, -5.5, 0), Size = UDim2.new(12, 0, 12, 0)})
        wait(0.15)
        Tween(Ripple, {0.3, "Linear", "InOut"}, {ImageTransparency = 1})
        wait(0.3)
        Ripple:Destroy()
    end)
end

-- Tab switching
local switchingTabs = false
function switchTab(new)
    if switchingTabs then return end
    local old = library.currentTab
    
    if old == nil then
        new[2].Visible = true
        library.currentTab = new
        Tween(new[1], {0.1, "Linear", "InOut"}, {ImageTransparency = 0})
        Tween(new[1].TabText, {0.1, "Linear", "InOut"}, {TextTransparency = 0})
        return
    end
    
    if old[1] == new[1] then return end
    
    switchingTabs = true
    library.currentTab = new
    
    Tween(old[1], {0.1, "Linear", "InOut"}, {ImageTransparency = 0.2})
    Tween(new[1], {0.1, "Linear", "InOut"}, {ImageTransparency = 0})
    Tween(old[1].TabText, {0.1, "Linear", "InOut"}, {TextTransparency = 0.2})
    Tween(new[1].TabText, {0.1, "Linear", "InOut"}, {TextTransparency = 0})
    
    old[2].Visible = false
    new[2].Visible = true
    
    task.wait(0.1)
    switchingTabs = false
end

-- Dragging function
function drag(frame, hold)
    if not hold then hold = frame end
    local dragging, dragInput, dragStart, startPos
    
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
    
    inputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Create new library
function library.new(name, theme)
    -- Clean up existing UI
    for _, v in next, services.CoreGui:GetChildren() do
        if v.Name == "EnhancedUILib" then
            v:Destroy()
        end
    end

    -- Configuration
    local config = {
        MainColor = Color3.fromRGB(16, 16, 16),
        TabColor = Color3.fromRGB(22, 22, 22),
        BgColor = Color3.fromRGB(17, 17, 17),
        AccentColor = Color3.fromRGB(37, 254, 152),
        
        ButtonColor = Color3.fromRGB(22, 22, 22),
        TextboxColor = Color3.fromRGB(22, 22, 22),
        DropdownColor = Color3.fromRGB(22, 22, 22),
        KeybindColor = Color3.fromRGB(22, 22, 22),
        LabelColor = Color3.fromRGB(22, 22, 22),
        
        SliderColor = Color3.fromRGB(22, 22, 22),
        SliderBarColor = Color3.fromRGB(37, 254, 152),
        
        ToggleColor = Color3.fromRGB(22, 22, 22),
        ToggleOff = Color3.fromRGB(34, 34, 34),
        ToggleOn = Color3.fromRGB(254, 254, 254),
        
        BorderColor = Color3.fromRGB(50, 50, 50),
        GlowColor = Color3.fromRGB(37, 254, 152)
    }

    -- Main UI
    local ui = Instance.new("ScreenGui")
    ui.Name = "EnhancedUILib"
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if syn and syn.protect_gui then
        syn.protect_gui(ui)
    end
    ui.Parent = services.CoreGui

    -- Main frame with dynamic border
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = config.BgColor
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.ZIndex = 1
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = ui
    
    -- Glowing border effect
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.AnchorPoint = Vector2.new(0.5, 0.5)
    border.BackgroundTransparency = 1
    border.BorderSizePixel = 0
    border.Position = UDim2.new(0.5, 0, 0.5, 0)
    border.Size = UDim2.new(1, 10, 1, 10)
    border.ZIndex = 0
    border.Parent = mainFrame
    
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = config.GlowColor
    glow.ImageTransparency = 0.8
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.ZIndex = 0
    glow.Parent = border
    
    -- Animate the glow
    spawn(function()
        while ui.Parent do
            for i = 0.8, 0.4, -0.05 do
                glow.ImageTransparency = i
                wait(0.1)
            end
            for i = 0.4, 0.8, 0.05 do
                glow.ImageTransparency = i
                wait(0.1)
            end
        end
    end)
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Tab system
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.BackgroundTransparency = 1
    tabContainer.Size = UDim2.new(1, 0, 1, 0)
    tabContainer.Parent = mainFrame
    
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.BackgroundColor3 = config.TabColor
    sidebar.Size = UDim2.new(0, 120, 1, 0)
    sidebar.Parent = tabContainer
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 8)
    sidebarCorner.Parent = sidebar
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 10, 0, 10)
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Font = Enum.Font.GothamBold
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = sidebar
    
    -- Search box for tabs
    local tabSearch = Instance.new("TextBox")
    tabSearch.Name = "TabSearch"
    tabSearch.BackgroundColor3 = config.BgColor
    tabSearch.Position = UDim2.new(0, 10, 0, 50)
    tabSearch.Size = UDim2.new(1, -20, 0, 30)
    tabSearch.Font = Enum.Font.Gotham
    tabSearch.PlaceholderText = "Search tabs..."
    tabSearch.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    tabSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabSearch.TextSize = 14
    tabSearch.TextXAlignment = Enum.TextXAlignment.Left
    tabSearch.Parent = sidebar
    
    local tabSearchCorner = Instance.new("UICorner")
    tabSearchCorner.CornerRadius = UDim.new(0, 6)
    tabSearchCorner.Parent = tabSearch
    
    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "TabList"
    tabList.BackgroundTransparency = 1
    tabList.Position = UDim2.new(0, 0, 0, 90)
    tabList.Size = UDim2.new(1, 0, 1, -90)
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.ScrollBarThickness = 4
    tabList.Parent = sidebar
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Name = "TabListLayout"
    tabListLayout.Padding = UDim.new(0, 10)
    tabListLayout.Parent = tabList
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.BackgroundTransparency = 1
    contentFrame.Position = UDim2.new(0, 130, 0, 10)
    contentFrame.Size = UDim2.new(1, -140, 1, -20)
    contentFrame.Parent = tabContainer
    
    -- Search box for content
    local contentSearch = Instance.new("TextBox")
    contentSearch.Name = "ContentSearch"
    contentSearch.BackgroundColor3 = config.BgColor
    contentSearch.Position = UDim2.new(0, 0, 0, 0)
    contentSearch.Size = UDim2.new(1, 0, 0, 30)
    contentSearch.Font = Enum.Font.Gotham
    contentSearch.PlaceholderText = "Search options..."
    contentSearch.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    contentSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
    contentSearch.TextSize = 14
    contentSearch.TextXAlignment = Enum.TextXAlignment.Left
    contentSearch.Visible = false -- Will be shown when tab is selected
    contentSearch.Parent = contentFrame
    
    local contentSearchCorner = Instance.new("UICorner")
    contentSearchCorner.CornerRadius = UDim.new(0, 6)
    contentSearchCorner.Parent = contentSearch
    
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Name = "ContentContainer"
    contentContainer.BackgroundTransparency = 1
    contentContainer.Position = UDim2.new(0, 0, 0, 40)
    contentContainer.Size = UDim2.new(1, 0, 1, -40)
    contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentContainer.ScrollBarThickness = 4
    contentContainer.Parent = contentFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Name = "ContentLayout"
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = contentContainer
    
    -- Tab search functionality
    tabSearch:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = tabSearch.Text:lower()
        
        for _, tabBtn in pairs(tabList:GetChildren()) do
            if tabBtn:IsA("TextButton") then
                if searchText == "" or tabBtn.Text:lower():find(searchText) then
                    tabBtn.Visible = true
                else
                    tabBtn.Visible = false
                end
            end
        end
    end)
    
    -- Content search functionality (will be set up per tab)
    
    -- Make draggable
    drag(mainFrame)
    
    -- Toggle UI with keybind
    inputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.RightShift then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)
    
    -- Window object
    local window = {}
    
    function window.Tab(name, icon)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = name
        tabBtn.BackgroundColor3 = config.TabColor
        tabBtn.Size = UDim2.new(1, -10, 0, 40)
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.Text = name
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.TextSize = 14
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabList
        
        local tabBtnCorner = Instance.new("UICorner")
        tabBtnCorner.CornerRadius = UDim.new(0, 6)
        tabBtnCorner.Parent = tabBtn
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name
        tabContent.BackgroundTransparency = 1
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.ScrollBarThickness = 4
        tabContent.Visible = false
        tabContent.Parent = contentContainer
        
        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.Name = "Layout"
        tabContentLayout.Padding = UDim.new(0, 10)
        tabContentLayout.Parent = tabContent
        
        -- Set up content search for this tab
        local function setupContentSearch()
            contentSearch:GetPropertyChangedSignal("Text"):Connect(function()
                local searchText = contentSearch.Text:lower()
                
                for _, section in pairs(tabContent:GetChildren()) do
                    if section:IsA("Frame") and section.Name == "Section" then
                        local found = false
                        
                        for _, element in pairs(section:GetChildren()) do
                            if element:IsA("TextButton") or element:IsA("TextLabel") then
                                if searchText == "" or element.Text:lower():find(searchText) then
                                    element.Visible = true
                                    found = true
                                else
                                    element.Visible = false
                                end
                            end
                        end
                        
                        section.Visible = found
                    end
                end
            end)
        end
        
        tabBtn.MouseButton1Click:Connect(function()
            -- Hide all tab contents
            for _, tab in pairs(contentContainer:GetChildren()) do
                if tab:IsA("ScrollingFrame") then
                    tab.Visible = false
                end
            end
            
            -- Show this tab's content
            tabContent.Visible = true
            contentSearch.Visible = true
            contentSearch.PlaceholderText = "Search in " .. name .. "..."
            
            -- Reset search
            contentSearch.Text = ""
            
            -- Setup search for this tab
            setupContentSearch()
        end)
        
        -- Tab object
        local tab = {}
        
        function tab.Section(title, initiallyOpen)
            local section = Instance.new("Frame")
            section.Name = "Section"
            section.BackgroundColor3 = config.TabColor
            section.Size = UDim2.new(1, 0, 0, 40)
            section.ClipsDescendants = true
            section.Parent = tabContent
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 6)
            sectionCorner.Parent = section
            
            local sectionHeader = Instance.new("TextButton")
            sectionHeader.Name = "Header"
            sectionHeader.BackgroundTransparency = 1
            sectionHeader.Size = UDim2.new(1, 0, 0, 40)
            sectionHeader.Font = Enum.Font.GothamBold
            sectionHeader.Text = title
            sectionHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
            sectionHeader.TextSize = 16
            sectionHeader.TextXAlignment = Enum.TextXAlignment.Left
            sectionHeader.Parent = section
            
            local sectionToggle = Instance.new("ImageButton")
            sectionToggle.Name = "Toggle"
            sectionToggle.BackgroundTransparency = 1
            sectionToggle.Position = UDim2.new(1, -30, 0.5, -10)
            sectionToggle.Size = UDim2.new(0, 20, 0, 20)
            sectionToggle.Image = "rbxassetid://6031094667" -- Down arrow
            sectionToggle.Parent = sectionHeader
            
            local sectionContent = Instance.new("Frame")
            sectionContent.Name = "Content"
            sectionContent.BackgroundTransparency = 1
            sectionContent.Position = UDim2.new(0, 10, 0, 50)
            sectionContent.Size = UDim2.new(1, -20, 0, 0)
            sectionContent.Parent = section
            
            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.Name = "Layout"
            sectionLayout.Padding = UDim.new(0, 10)
            sectionLayout.Parent = sectionContent
            
            local isOpen = initiallyOpen or false
            
            local function updateSection()
                if isOpen then
                    sectionToggle.Image = "rbxassetid://6031094678" -- Up arrow
                    sectionContent.Visible = true
                    section.Size = UDim2.new(1, 0, 0, 50 + sectionLayout.AbsoluteContentSize.Y)
                else
                    sectionToggle.Image = "rbxassetid://6031094667" -- Down arrow
                    sectionContent.Visible = false
                    section.Size = UDim2.new(1, 0, 0, 40)
                end
            end
            
            sectionHeader.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                updateSection()
            end)
            
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isOpen then
                    section.Size = UDim2.new(1, 0, 0, 50 + sectionLayout.AbsoluteContentSize.Y)
                end
            end)
            
            updateSection()
            
            -- Section object
            local sectionObj = {}
            
            -- Add all your element creation functions here (Button, Toggle, Slider, etc.)
            -- They should be similar to your original code but adapted for this new UI
            
            return sectionObj
        end
        
        return tab
    end
    
    return window
end

return library