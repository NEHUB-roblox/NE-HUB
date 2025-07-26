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

local Players = services.Players
local TweenService = services.TweenService
local UserInputService = services.UserInputService
local RunService = services.RunService

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Helper functions
local function Tween(obj, t, data)
    TweenService:Create(obj, TweenInfo.new(t[1], Enum.EasingStyle[t[2]], Enum.EasingDirection[t[3]]), data):Play()
    return true
end

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

local toggled = false
local switchingTabs = false

local function switchTab(new)
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

local function drag(frame, hold)
    if not hold then hold = frame end
    
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
            update(input)
        end
    end)
end

-- Color configuration
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
    
    TextColor = Color3.fromRGB(255, 255, 255),
    PlaceholderColor = Color3.fromRGB(180, 180, 180),
    
    BorderColor = Color3.fromRGB(50, 50, 50),
    GlowColor = Color3.fromRGB(0, 255, 255)
}

function library.new(name, theme)
    -- Clean up existing UI
    for _, v in next, services.CoreGui:GetChildren() do
        if v.Name == "FrostyUILib" then
            v:Destroy()
        end
    end

    -- Main UI Container
    local dogent = Instance.new("ScreenGui")
    dogent.Name = "FrostyUILib"
    dogent.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if syn and syn.protect_gui then
        syn.protect_gui(dogent)
    end
    dogent.Parent = services.CoreGui

    -- Main Window
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = dogent
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = config.BgColor
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.ZIndex = 1
    Main.Active = true
    
    -- Glowing Border Effect
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.Parent = Main
    Glow.BackgroundTransparency = 1
    Glow.BorderSizePixel = 0
    Glow.Size = UDim2.new(1, 12, 1, 12)
    Glow.Position = UDim2.new(0, -6, 0, -6)
    Glow.ZIndex = 0
    Glow.Image = "rbxassetid://5028857084"
    Glow.ImageColor3 = config.GlowColor
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(24, 24, 276, 276)
    
    -- Animate the glow
    spawn(function()
        while Glow and Glow.Parent do
            for i = 0, 1, 0.01 do
                if not Glow then break end
                Glow.ImageTransparency = 0.7 + math.sin(i * math.pi) * 0.3
                wait(0.03)
            end
        end
    end)

    -- Main Corner
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Name = "MainCorner"
    MainCorner.Parent = Main

    -- Tab Container
    local TabMain = Instance.new("Frame")
    TabMain.Name = "TabMain"
    TabMain.Parent = Main
    TabMain.BackgroundTransparency = 1
    TabMain.Position = UDim2.new(0.2, 0, 0, 5)
    TabMain.Size = UDim2.new(0.8, -10, 1, -10)

    -- Sidebar
    local Side = Instance.new("Frame")
    Side.Name = "Side"
    Side.Parent = Main
    Side.BackgroundColor3 = config.TabColor
    Side.BorderSizePixel = 0
    Side.Size = UDim2.new(0.2, -5, 1, 0)
    
    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 6)
    SideCorner.Name = "SideCorner"
    SideCorner.Parent = Side

    -- Title
    local ScriptTitle = Instance.new("TextLabel")
    ScriptTitle.Name = "ScriptTitle"
    ScriptTitle.Parent = Side
    ScriptTitle.BackgroundTransparency = 1
    ScriptTitle.Position = UDim2.new(0, 10, 0, 10)
    ScriptTitle.Size = UDim2.new(1, -20, 0, 30)
    ScriptTitle.Font = Enum.Font.GothamSemibold
    ScriptTitle.Text = name or "Frosty UI"
    ScriptTitle.TextColor3 = config.AccentColor
    ScriptTitle.TextSize = 18
    ScriptTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Tab Buttons Container
    local TabBtns = Instance.new("ScrollingFrame")
    TabBtns.Name = "TabBtns"
    TabBtns.Parent = Side
    TabBtns.BackgroundTransparency = 1
    TabBtns.BorderSizePixel = 0
    TabBtns.Position = UDim2.new(0, 0, 0, 50)
    TabBtns.Size = UDim2.new(1, 0, 1, -50)
    TabBtns.CanvasSize = UDim2.new(0, 0, 1, 0)
    TabBtns.ScrollBarThickness = 2
    TabBtns.ScrollBarImageColor3 = config.AccentColor

    local TabBtnsL = Instance.new("UIListLayout")
    TabBtnsL.Name = "TabBtnsL"
    TabBtnsL.Parent = TabBtns
    TabBtnsL.SortOrder = Enum.SortOrder.LayoutOrder
    TabBtnsL.Padding = UDim.new(0, 10)

    TabBtnsL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBtns.CanvasSize = UDim2.new(0, 0, 0, TabBtnsL.AbsoluteContentSize.Y + 20)
    end)

    -- Drag functionality
    drag(Main)

    -- Toggle UI visibility with keybind
    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            Main.Visible = not Main.Visible
        end
    end)

    -- Window functions
    function dogent:Toggle()
        Main.Visible = not Main.Visible
    end

    function dogent:Destroy()
        dogent:Destroy()
    end

    -- Window object
    local window = {}

    function window.Tab(name, icon)
        -- Create tab container
        local Tab = Instance.new("ScrollingFrame")
        Tab.Name = "Tab_"..name
        Tab.Parent = TabMain
        Tab.BackgroundTransparency = 1
        Tab.Size = UDim2.new(1, 0, 1, 0)
        Tab.ScrollBarThickness = 2
        Tab.ScrollBarImageColor3 = config.AccentColor
        Tab.Visible = false

        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Name = "TabLayout"
        TabLayout.Parent = Tab
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Padding = UDim.new(0, 10)

        -- Search box for this tab
        local SearchBox = Instance.new("TextBox")
        SearchBox.Name = "SearchBox"
        SearchBox.Parent = Tab
        SearchBox.BackgroundColor3 = config.TextboxColor
        SearchBox.BorderSizePixel = 0
        SearchBox.Size = UDim2.new(1, -20, 0, 30)
        SearchBox.Position = UDim2.new(0, 10, 0, 10)
        SearchBox.Font = Enum.Font.Gotham
        SearchBox.PlaceholderText = "Search "..name.."..."
        SearchBox.PlaceholderColor3 = config.PlaceholderColor
        SearchBox.TextColor3 = config.TextColor
        SearchBox.TextSize = 14
        SearchBox.TextXAlignment = Enum.TextXAlignment.Left
        SearchBox.Text = ""

        local SearchCorner = Instance.new("UICorner")
        SearchCorner.CornerRadius = UDim.new(0, 4)
        SearchCorner.Parent = SearchBox

        local SearchPadding = Instance.new("UIPadding")
        SearchPadding.Parent = SearchBox
        SearchPadding.PaddingLeft = UDim.new(0, 10)

        -- Create tab button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = "TabBtn_"..name
        TabBtn.Parent = TabBtns
        TabBtn.BackgroundColor3 = config.TabColor
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(1, -20, 0, 40)
        TabBtn.AutoButtonColor = false
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.Text = ""
        TabBtn.TextColor3 = config.TextColor
        TabBtn.TextSize = 14

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabBtn

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "TabIcon"
        TabIcon.Parent = TabBtn
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 10, 0.5, -12)
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Image = "rbxassetid://"..(icon or "4370341699")
        TabIcon.ImageColor3 = config.TextColor
        TabIcon.ImageTransparency = 0.2

        local TabText = Instance.new("TextLabel")
        TabText.Name = "TabText"
        TabText.Parent = TabBtn
        TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(0, 44, 0, 0)
        TabText.Size = UDim2.new(1, -44, 1, 0)
        TabText.Font = Enum.Font.GothamSemibold
        TabText.Text = name
        TabText.TextColor3 = config.TextColor
        TabText.TextSize = 14
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.TextTransparency = 0.2

        -- Tab button click event
        TabBtn.MouseButton1Click:Connect(function()
            Ripple(TabBtn)
            switchTab({TabBtn, Tab})
        end)

        -- Set first tab as active if none selected
        if library.currentTab == nil then
            switchTab({TabBtn, Tab})
        end

        -- Tab content layout
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
        end)

        -- Search functionality
        local function filterElements(searchText)
            local elements = Tab:GetChildren()
            for _, element in pairs(elements) do
                if element:IsA("Frame") and element.Name ~= "SearchBox" then
                    if searchText == "" then
                        element.Visible = true
                    else
                        local elementName = element:FindFirstChild("ElementName")
                        if elementName and elementName:IsA("TextLabel") then
                            element.Visible = string.find(string.lower(elementName.Text), string.lower(searchText)) ~= nil
                        end
                    end
                end
            end
        end

        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            filterElements(SearchBox.Text)
        end)

        -- Tab object
        local tab = {}

        function tab.Section(name, defaultOpen)
            local Section = Instance.new("Frame")
            Section.Name = "Section_"..name
            Section.Parent = Tab
            Section.BackgroundColor3 = config.TabColor
            Section.BorderSizePixel = 0
            Section.Size = UDim2.new(1, -20, 0, 40)
            Section.Position = UDim2.new(0, 10, 0, 50)
            Section.ClipsDescendants = true

            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = Section

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Parent = Section
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 10, 0, 0)
            SectionTitle.Size = UDim2.new(1, -40, 0, 40)
            SectionTitle.Font = Enum.Font.GothamSemibold
            SectionTitle.Text = name
            SectionTitle.TextColor3 = config.TextColor
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

            local SectionToggle = Instance.new("ImageButton")
            SectionToggle.Name = "SectionToggle"
            SectionToggle.Parent = Section
            SectionToggle.BackgroundTransparency = 1
            SectionToggle.Position = UDim2.new(1, -30, 0.5, -10)
            SectionToggle.Size = UDim2.new(0, 20, 0, 20)
            SectionToggle.Image = "rbxassetid://6031302934" -- Down arrow

            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "SectionContent"
            SectionContent.Parent = Section
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 10, 0, 40)
            SectionContent.Size = UDim2.new(1, -20, 0, 0)

            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.Name = "SectionLayout"
            SectionLayout.Parent = SectionContent
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionLayout.Padding = UDim.new(0, 8)

            -- Track if section is open
            local isOpen = defaultOpen or false

            -- Toggle section visibility
            local function toggleSection()
                isOpen = not isOpen
                if isOpen then
                    Section.Size = UDim2.new(1, -20, 0, 40 + SectionContent.Size.Y.Offset)
                    SectionToggle.Image = "rbxassetid://6031302932" -- Up arrow
                else
                    Section.Size = UDim2.new(1, -20, 0, 40)
                    SectionToggle.Image = "rbxassetid://6031302934" -- Down arrow
                end
            end

            -- Update section size when content changes
            SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isOpen then
                    SectionContent.Size = UDim2.new(1, -20, 0, SectionLayout.AbsoluteContentSize.Y)
                    Section.Size = UDim2.new(1, -20, 0, 40 + SectionLayout.AbsoluteContentSize.Y)
                end
            end)

            -- Toggle button click
            SectionToggle.MouseButton1Click:Connect(toggleSection)

            -- Set initial state
            toggleSection()

            -- Section object
            local section = {}

            -- Button element
            function section.Button(text, callback)
                local Button = Instance.new("TextButton")
                Button.Name = "Button_"..text
                Button.Parent = SectionContent
                Button.BackgroundColor3 = config.ButtonColor
                Button.BorderSizePixel = 0
                Button.Size = UDim2.new(1, 0, 0, 36)
                Button.AutoButtonColor = false
                Button.Font = Enum.Font.GothamSemibold
                Button.Text = "   "..text
                Button.TextColor3 = config.TextColor
                Button.TextSize = 14
                Button.TextXAlignment = Enum.TextXAlignment.Left

                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = Button

                local ElementName = Instance.new("TextLabel")
                ElementName.Name = "ElementName"
                ElementName.Parent = Button
                ElementName.BackgroundTransparency = 1
                ElementName.Size = UDim2.new(1, 0, 1, 0)
                ElementName.Visible = false
                ElementName.Text = text

                Button.MouseButton1Click:Connect(function()
                    Ripple(Button)
                    if callback then callback() end
                end)

                return Button
            end

            -- Toggle element
            function section.Toggle(text, flag, default, callback)
                assert(text, "No text provided")
                assert(flag, "No flag provided")
                
                library.flags[flag] = default or false
                
                local Toggle = Instance.new("TextButton")
                Toggle.Name = "Toggle_"..text
                Toggle.Parent = SectionContent
                Toggle.BackgroundColor3 = config.ToggleColor
                Toggle.BorderSizePixel = 0
                Toggle.Size = UDim2.new(1, 0, 0, 36)
                Toggle.AutoButtonColor = false
                Toggle.Font = Enum.Font.GothamSemibold
                Toggle.Text = "   "..text
                Toggle.TextColor3 = config.TextColor
                Toggle.TextSize = 14
                Toggle.TextXAlignment = Enum.TextXAlignment.Left

                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 4)
                ToggleCorner.Parent = Toggle

                local ToggleState = Instance.new("Frame")
                ToggleState.Name = "ToggleState"
                ToggleState.Parent = Toggle
                ToggleState.BackgroundColor3 = config.BgColor
                ToggleState.BorderSizePixel = 0
                ToggleState.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleState.Size = UDim2.new(0, 40, 0, 20)

                local ToggleStateCorner = Instance.new("UICorner")
                ToggleStateCorner.CornerRadius = UDim.new(0, 10)
                ToggleStateCorner.Parent = ToggleState

                local ToggleSwitch = Instance.new("Frame")
                ToggleSwitch.Name = "ToggleSwitch"
                ToggleSwitch.Parent = ToggleState
                ToggleSwitch.BackgroundColor3 = default and config.ToggleOn or config.ToggleOff
                ToggleSwitch.BorderSizePixel = 0
                ToggleSwitch.Position = UDim2.new(default and 0.5 or 0, 0, 0, 0)
                ToggleSwitch.Size = UDim2.new(0.5, 0, 1, 0)

                local ToggleSwitchCorner = Instance.new("UICorner")
                ToggleSwitchCorner.CornerRadius = UDim.new(0, 10)
                ToggleSwitchCorner.Parent = ToggleSwitch

                local ElementName = Instance.new("TextLabel")
                ElementName.Name = "ElementName"
                ElementName.Parent = Toggle
                ElementName.BackgroundTransparency = 1
                ElementName.Size = UDim2.new(1, 0, 1, 0)
                ElementName.Visible = false
                ElementName.Text = text

                local function setState(state)
                    state = state or not library.flags[flag]
                    library.flags[flag] = state
                    
                    Tween(ToggleSwitch, {0.2, "Quad", "Out"}, {
                        Position = UDim2.new(state and 0.5 or 0, 0, 0, 0),
                        BackgroundColor3 = state and config.ToggleOn or config.ToggleOff
                    })
                    
                    if callback then callback(state) end
                end

                Toggle.MouseButton1Click:Connect(function()
                    Ripple(Toggle)
                    setState()
                end)

                return {
                    SetState = setState
                }
            end

            -- Label element
            function section.Label(text)
                local Label = Instance.new("TextLabel")
                Label.Name = "Label_"..text
                Label.Parent = SectionContent
                Label.BackgroundColor3 = config.LabelColor
                Label.BorderSizePixel = 0
                Label.Size = UDim2.new(1, 0, 0, 24)
                Label.Font = Enum.Font.GothamSemibold
                Label.Text = text
                Label.TextColor3 = config.TextColor
                Label.TextSize = 14

                local LabelCorner = Instance.new("UICorner")
                LabelCorner.CornerRadius = UDim.new(0, 4)
                LabelCorner.Parent = Label

                local ElementName = Instance.new("TextLabel")
                ElementName.Name = "ElementName"
                ElementName.Parent = Label
                ElementName.BackgroundTransparency = 1
                ElementName.Size = UDim2.new(1, 0, 1, 0)
                ElementName.Visible = false
                ElementName.Text = text

                return Label
            end

            -- Slider element
            function section.Slider(text, flag, min, max, default, callback)
                assert(text, "No text provided")
                assert(flag, "No flag provided")
                assert(min and max, "Min and max values required")
                
                default = default or min
                library.flags[flag] = default
                
                local Slider = Instance.new("Frame")
                Slider.Name = "Slider_"..text
                Slider.Parent = SectionContent
                Slider.BackgroundColor3 = config.SliderColor
                Slider.BorderSizePixel = 0
                Slider.Size = UDim2.new(1, 0, 0, 60)

                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 4)
                SliderCorner.Parent = Slider

                local SliderTitle = Instance.new("TextLabel")
                SliderTitle.Name = "SliderTitle"
                SliderTitle.Parent = Slider
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 10, 0, 5)
                SliderTitle.Size = UDim2.new(1, -20, 0, 20)
                SliderTitle.Font = Enum.Font.GothamSemibold
                SliderTitle.Text = text
                SliderTitle.TextColor3 = config.TextColor
                SliderTitle.TextSize = 14
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

                local SliderBar = Instance.new("Frame")
                SliderBar.Name = "SliderBar"
                SliderBar.Parent = Slider
                SliderBar.BackgroundColor3 = config.BgColor
                SliderBar.BorderSizePixel = 0
                SliderBar.Position = UDim2.new(0, 10, 0, 30)
                SliderBar.Size = UDim2.new(1, -20, 0, 10)

                local SliderBarCorner = Instance.new("UICorner")
                SliderBarCorner.CornerRadius = UDim.new(0, 5)
                SliderBarCorner.Parent = SliderBar

                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "SliderFill"
                SliderFill.Parent = SliderBar
                SliderFill.BackgroundColor3 = config.SliderBarColor
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)

                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(0, 5)
                SliderFillCorner.Parent = SliderFill

                local SliderValue = Instance.new("TextBox")
                SliderValue.Name = "SliderValue"
                SliderValue.Parent = Slider
                SliderValue.BackgroundColor3 = config.BgColor
                SliderValue.BorderSizePixel = 0
                SliderValue.Position = UDim2.new(1, -60, 0, 5)
                SliderValue.Size = UDim2.new(0, 50, 0, 20)
                SliderValue.Font = Enum.Font.Gotham
                SliderValue.Text = tostring(default)
                SliderValue.TextColor3 = config.TextColor
                SliderValue.TextSize = 14

                local SliderValueCorner = Instance.new("UICorner")
                SliderValueCorner.CornerRadius = UDim.new(0, 4)
                SliderValueCorner.Parent = SliderValue

                local ElementName = Instance.new("TextLabel")
                ElementName.Name = "ElementName"
                ElementName.Parent = Slider
                ElementName.BackgroundTransparency = 1
                ElementName.Size = UDim2.new(1, 0, 1, 0)
                ElementName.Visible = false
                ElementName.Text = text

                local function setValue(value)
                    value = math.clamp(value, min, max)
                    library.flags[flag] = value
                    SliderValue.Text = tostring(math.floor(value))
                    SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    if callback then callback(value) end
                end

                local dragging = false
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local percent = (mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                        setValue(min + (max - min) * percent)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = (mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                        setValue(min + (max - min) * percent)
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

                setValue(default)

                return {
                    SetValue = setValue
                }
            end

            -- Textbox element
            function section.Textbox(text, flag, placeholder, default, callback)
                assert(text, "No text provided")
                assert(flag, "No flag provided")
                
                default = default or ""
                library.flags[flag] = default
                
                local Textbox = Instance.new("Frame")
                Textbox.Name = "Textbox_"..text
                Textbox.Parent = SectionContent
                Textbox.BackgroundColor3 = config.TextboxColor
                Textbox.BorderSizePixel = 0
                Textbox.Size = UDim2.new(1, 0, 0, 36)

                local TextboxCorner = Instance.new("UICorner")
                TextboxCorner.CornerRadius = UDim.new(0, 4)
                TextboxCorner.Parent = Textbox

                local TextboxTitle = Instance.new("TextLabel")
                TextboxTitle.Name = "TextboxTitle"
                TextboxTitle.Parent = Textbox
                TextboxTitle.BackgroundTransparency = 1
                TextboxTitle.Position = UDim2.new(0, 10, 0, 0)
                TextboxTitle.Size = UDim2.new(0.4, 0, 1, 0)
                TextboxTitle.Font = Enum.Font.GothamSemibold
                TextboxTitle.Text = text
                TextboxTitle.TextColor3 = config.TextColor
                TextboxTitle.TextSize = 14
                TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left

                local TextboxInput = Instance.new("TextBox")
                TextboxInput.Name = "TextboxInput"
                TextboxInput.Parent = Textbox
                TextboxInput.BackgroundTransparency = 1
                TextboxInput.Position = UDim2.new(0.45, 0, 0, 0)
                TextboxInput.Size = UDim2.new(0.55, -10, 1, 0)
                TextboxInput.Font = Enum.Font.Gotham
                TextboxInput.PlaceholderText = placeholder or "Enter value..."
                TextboxInput.PlaceholderColor3 = config.PlaceholderColor
                TextboxInput.Text = default
                TextboxInput.TextColor3 = config.TextColor
                TextboxInput.TextSize = 14
                TextboxInput.TextXAlignment = Enum.TextXAlignment.Left

                local ElementName = Instance.new("TextLabel")
                ElementName.Name = "ElementName"
                ElementName.Parent = Textbox
                ElementName.BackgroundTransparency = 1
                ElementName.Size = UDim2.new(1, 0, 1, 0)
                ElementName.Visible = false
                ElementName.Text = text

                TextboxInput.FocusLost:Connect(function()
                    library.flags[flag] = TextboxInput.Text
                    if callback then callback(TextboxInput.Text) end
                end)

                return {
                    SetText = function(self, text)
                        TextboxInput.Text = text
                        library.flags[flag] = text
                    end
                }
            end

            -- Dropdown element
            function section.Dropdown(text, flag, options, default, callback)
                assert(text, "No text provided")
                assert(flag, "No flag provided")
                assert(options and #options > 0, "Options required")
                
                default = default or options[1]
                library.flags[flag] = default
                
                local Dropdown = Instance.new("Frame")
                Dropdown.Name = "Dropdown_"..text
                Dropdown.Parent = SectionContent
                Dropdown.BackgroundColor3 = config.DropdownColor
                Dropdown.BorderSizePixel = 0
                Dropdown.Size = UDim2.new(1, 0, 0, 36)
                Dropdown.ClipsDescendants = true

                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 4)
                DropdownCorner.Parent = Dropdown

                local DropdownTitle = Instance.new("TextLabel")
                DropdownTitle.Name = "DropdownTitle"
                DropdownTitle.Parent = Dropdown
                DropdownTitle.BackgroundTransparency = 1
                DropdownTitle.Position = UDim2.new(0, 10, 0, 0)
                DropdownTitle.Size = UDim2.new(0.5, 0, 1, 0)
                DropdownTitle.Font = Enum.Font.GothamSemibold
                DropdownTitle.Text = text
                DropdownTitle.TextColor3 = config.TextColor
                DropdownTitle.TextSize = 14
                DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left

                local DropdownValue = Instance.new("TextButton")
                DropdownValue.Name = "DropdownValue"
                DropdownValue.Parent = Dropdown
                DropdownValue.BackgroundColor3 = config.BgColor
                DropdownValue.BorderSizePixel = 0
                DropdownValue.Position = UDim2.new(0.55, 0, 0.15, 0)
                DropdownValue.Size = UDim2.new(0.4, -30, 0, 24)
                DropdownValue.AutoButtonColor = false
                DropdownValue.Font = Enum.Font.Gotham
                DropdownValue.Text = default
                DropdownValue.TextColor3 = config.TextColor
                DropdownValue.TextSize = 14
                DropdownValue.TextXAlignment = Enum.TextXAlignment.Left

                local DropdownValueCorner = Instance.new("UICorner")
                DropdownValueCorner.CornerRadius = UDim.new(0, 4)
                DropdownValueCorner.Parent = DropdownValue

                local DropdownValuePadding = Instance.new("UIPadding")
                DropdownValuePadding.Parent = DropdownValue
                DropdownValuePadding.PaddingLeft = UDim.new(0, 8)

                local DropdownArrow = Instance.new("ImageButton")
                DropdownArrow.Name = "DropdownArrow"
                DropdownArrow.Parent = DropdownValue
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Position = UDim2.new(1, -20, 0.5, -8)
                DropdownArrow.Size = UDim2.new(0, 16, 0, 16)
                DropdownArrow.Image = "rbxassetid://6031091003" -- Down arrow
                DropdownArrow.ImageColor3 = config.TextColor

                local DropdownOptions = Instance.new("Frame")
                DropdownOptions.Name = "DropdownOptions"
                DropdownOptions.Parent = Dropdown
                DropdownOptions.BackgroundColor3 = config.BgColor
                DropdownOptions.BorderSizePixel = 0
                DropdownOptions.Position = UDim2.new(0, 10, 1, 5)
                DropdownOptions.Size = UDim2.new(1, -20, 0, 0)
                DropdownOptions.Visible = false

                local DropdownOptionsCorner = Instance.new("UICorner")
                DropdownOptionsCorner.CornerRadius = UDim.new(0, 4)
                DropdownOptionsCorner.Parent = DropdownOptions

                local DropdownOptionsLayout = Instance.new("UIListLayout")
                DropdownOptionsLayout.Name = "DropdownOptionsLayout"
                DropdownOptionsLayout.Parent = DropdownOptions
                DropdownOptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder

                local ElementName = Instance.new("TextLabel")
                ElementName.Name = "ElementName"
                ElementName.Parent = Dropdown
                ElementName.BackgroundTransparency = 1
                ElementName.Size = UDim2.new(1, 0, 1, 0)
                ElementName.Visible = false
                ElementName.Text = text

                local function toggleDropdown()
                    local isOpen = DropdownOptions.Visible
                    DropdownOptions.Visible = not isOpen
                    DropdownArrow.Image = isOpen and "rbxassetid://6031091003" or "rbxassetid://6031091004" -- Up/down arrows
                    
                    if not isOpen then
                        Dropdown.Size = UDim2.new(1, 0, 0, 36 + DropdownOptionsLayout.AbsoluteContentSize.Y + 10)
                    else
                        Dropdown.Size = UDim2.new(1, 0, 0, 36)
                    end
                end

                local function createOption(option)
                    local Option = Instance.new("TextButton")
                    Option.Name = "Option_"..option
                    Option.Parent = DropdownOptions
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
                        library.flags[flag] = option
                        toggleDropdown()
                        if callback then callback(option) end
                    end)

                    return Option
                end

                -- Create options
                for _, option in pairs(options) do
                    createOption(option)
                end

                -- Update dropdown size when options change
                DropdownOptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    if DropdownOptions.Visible then
                        DropdownOptions.Size = UDim2.new(1, -20, 0, DropdownOptionsLayout.AbsoluteContentSize.Y)
                        Dropdown.Size = UDim2.new(1, 0, 0, 36 + DropdownOptionsLayout.AbsoluteContentSize.Y + 10)
                    end
                end)

                -- Toggle dropdown
                DropdownArrow.MouseButton1Click:Connect(toggleDropdown)
                DropdownValue.MouseButton1Click:Connect(toggleDropdown)

                -- Methods
                local methods = {
                    AddOption = function(self, option)
                        table.insert(options, option)
                        createOption(option)
                    end,
                    
                    RemoveOption = function(self, option)
                        for i, opt in pairs(options) do
                            if opt == option then
                                table.remove(options, i)
                                local gui = DropdownOptions:FindFirstChild("Option_"..option)
                                if gui then gui:Destroy() end
                                break
                            end
                        end
                    end,
                    
                    SetOptions = function(self, newOptions)
                        options = newOptions
                        for _, child in pairs(DropdownOptions:GetChildren()) do
                            if child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end
                        for _, option in pairs(options) do
                            createOption(option)
                        end
                    end,
                    
                    SetValue = function(self, value)
                        if table.find(options, value) then
                            DropdownValue.Text = value
                            library.flags[flag] = value
                        end
                    end
                }

                return methods
            end

            return section
        end

        return tab
    end

    return window
end

return library