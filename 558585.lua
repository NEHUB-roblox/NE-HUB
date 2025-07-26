-- 等待游戏加载完成
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
local mouse = services.Players.LocalPlayer:GetMouse()

-- 动态背景颜色
local function dynamicBackground()
    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 166, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(139, 0, 255),
    }
    local index = 1
    return function()
        index = index % #colors + 1
        return colors[index]
    end
end

local nextColor = dynamicBackground()

-- 配置主题
local themes = {
    Light = {
        MainColor = Color3.fromRGB(255, 255, 255),
        Bg_Color = Color3.fromRGB(240, 240, 240),
        TabColor = Color3.fromRGB(220, 220, 220),
        TextColor = Color3.fromRGB(0, 0, 0),
    },
    Dark = {
        MainColor = Color3.fromRGB(0, 0, 0),
        Bg_Color = Color3.fromRGB(30, 30, 30),
        TabColor = Color3.fromRGB(40, 40, 40),
        TextColor = Color3.fromRGB(255, 255, 255),
    },
    Neon = {
        MainColor = Color3.fromRGB(0, 255, 255),
        Bg_Color = Color3.fromRGB(0, 0, 0),
        TabColor = Color3.fromRGB(20, 20, 20),
        TextColor = Color3.fromRGB(0, 255, 255),
    },
}

local currentTheme = "Light"

-- 切换主题
local function switchTheme(theme)
    currentTheme = theme
    for _, v in pairs(library.Main:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextBox") then
            v.TextColor3 = themes[theme].TextColor
        end
        if v:IsA("Frame") or v:IsA("ImageButton") then
            v.BackgroundColor3 = themes[theme].Bg_Color
        end
    end
    library.Main.BackgroundColor3 = themes[theme].MainColor
end

-- 创建 UI
function library.new(library, name)
    -- 创建主界面
    local Main = Instance.new("ScreenGui")
    Main.Name = "frosty is al"
    Main.Parent = services.CoreGui

    -- 创建主框架
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Main
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = themes[currentTheme].MainColor
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.ZIndex = 1

    -- 创建圆角
    local MainC = Instance.new("UICorner")
    MainC.CornerRadius = UDim.new(0, 10)
    MainC.Parent = MainFrame

    -- 创建背景渐变
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Rotation = 90
    UIGradient.Parent = MainFrame

    -- 创建设置按钮
    local SettingsButton = Instance.new("TextButton")
    SettingsButton.Name = "SettingsButton"
    SettingsButton.Parent = MainFrame
    SettingsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SettingsButton.BackgroundTransparency = 0.5
    SettingsButton.Position = UDim2.new(0.9, 0, 0.05, 0)
    SettingsButton.Size = UDim2.new(0, 30, 0, 30)
    SettingsButton.Text = "⚙"
    SettingsButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    SettingsButton.TextSize = 20

    -- 创建设置菜单
    local SettingsMenu = Instance.new("Frame")
    SettingsMenu.Name = "SettingsMenu"
    SettingsMenu.Parent = MainFrame
    SettingsMenu.BackgroundColor3 = themes[currentTheme].Bg_Color
    SettingsMenu.Position = UDim2.new(0.6, 0, 0.1, 0)
    SettingsMenu.Size = UDim2.new(0, 200, 0, 300)
    SettingsMenu.Visible = false

    -- 创建设置菜单的圆角
    local SettingsMenuC = Instance.new("UICorner")
    SettingsMenuC.CornerRadius = UDim.new(0, 10)
    SettingsMenuC.Parent = SettingsMenu

    -- 创建主题切换按钮
    local ThemeButton = Instance.new("TextButton")
    ThemeButton.Name = "ThemeButton"
    ThemeButton.Parent = SettingsMenu
    ThemeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ThemeButton.Position = UDim2.new(0.1, 0, 0.1, 0)
    ThemeButton.Size = UDim2.new(0, 180, 0, 30)
    ThemeButton.Text = "切换主题"
    ThemeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    ThemeButton.TextSize = 16

    -- 切换主题功能
    ThemeButton.MouseButton1Click:Connect(function()
        if currentTheme == "Light" then
            switchTheme("Dark")
        elseif currentTheme == "Dark" then
            switchTheme("Neon")
        else
            switchTheme("Light")
        end
    end)

    -- 创建搜索框
    local SearchBox = Instance.new("TextBox")
    SearchBox.Name = "SearchBox"
    SearchBox.Parent = MainFrame
    SearchBox.BackgroundColor3 = themes[currentTheme].Bg_Color
    SearchBox.Position = UDim2.new(0.1, 0, 0.1, 0)
    SearchBox.Size = UDim2.new(0, 400, 0, 30)
    SearchBox.Font = Enum.Font.GothamSemibold
    SearchBox.PlaceholderText = "搜索功能"
    SearchBox.TextColor3 = themes[currentTheme].TextColor
    SearchBox.TextSize = 16

    -- 搜索功能
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = SearchBox.Text:lower()
        for _, tab in pairs(library.Main:GetChildren()) do
            if tab:IsA("Frame") and tab.Name:lower():find(searchText) then
                tab.Visible = true
            else
                tab.Visible = false
            end
        end
    end)

    -- 创建功能页
    function library:Tab(name)
        local Tab = Instance.new("Frame")
        Tab.Name = name
        Tab.Parent = MainFrame
        Tab.BackgroundColor3 = themes[currentTheme].TabColor
        Tab.Position = UDim2.new(0.1, 0, 0.2, 0)
        Tab.Size = UDim2.new(0, 400, 0, 300)
        Tab.Visible = false

        -- 创建功能页的圆角
        local TabC = Instance.new("UICorner")
        TabC.CornerRadius = UDim.new(0, 10)
        TabC.Parent = Tab

        -- 创建功能页的标题
        local TabTitle = Instance.new("TextLabel")
        TabTitle.Name = "TabTitle"
        TabTitle.Parent = Tab
        TabTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabTitle.BackgroundTransparency = 1
        TabTitle.Position = UDim2.new(0, 0, 0, 0)
        TabTitle.Size = UDim2.new(1, 0, 0, 30)
        TabTitle.Font = Enum.Font.GothamSemibold
        TabTitle.Text = name
        TabTitle.TextColor3 = themes[currentTheme].TextColor
        TabTitle.TextSize = 18

        -- 创建功能页的内容区域
        local TabContent = Instance.new("Frame")
        TabContent.Name = "TabContent"
        TabContent.Parent = Tab
        TabContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.BackgroundTransparency = 1
        TabContent.Position = UDim2.new(0, 0, 0.1, 0)
        TabContent.Size = UDim2.new(1, 0, 0.9, 0)

        -- 创建功能页的内容区域的圆角
        local TabContentC = Instance.new("UICorner")
        TabContentC.CornerRadius = UDim.new(0, 10)
        TabContentC.Parent = TabContent

        -- 切换功能页
        local function switchTab()
            for _, v in pairs(MainFrame:GetChildren()) do
                if v:IsA("Frame") and v ~= SettingsMenu then
                    v.Visible = false
                end
            end
            Tab.Visible = true
        end

        -- 创建功能页的按钮
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton"
        TabButton.Parent = MainFrame
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundTransparency = 0.5
        TabButton.Position = UDim2.new(0.1, 0, 0.15, 0)
        TabButton.Size = UDim2.new(0, 100, 0, 30)
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        TabButton.TextSize = 16

        -- 切换功能页
        TabButton.MouseButton1Click:Connect(switchTab)

        return Tab
    end

    -- 切换设置菜单的显示状态
    SettingsButton.MouseButton1Click:Connect(function()
        SettingsMenu.Visible = not SettingsMenu.Visible
    end)

    return library
end

return library
