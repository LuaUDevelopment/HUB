--// AntiGodHub Key System - Enhanced Edition
--========================================

local CONFIG = {
    --// Security - Multiple Keys Support
    KEYLESS = false,
    MAIN_KEYS = { "FREE-QK5L-JDMQ-RHKR" },
    PREMIUM_KEYS = { "STAFF-ANTI-GOD-HUB", "PREMIUM-D9TM-RWBO-RWBJ" },
    
    --// Loader URLs
    LOADER_URL = "https://raw.githubusercontent.com/LuaUScrip/LuaU/refs/heads/main/Loader.lua",
    PREMIUM_LOADER_URL = "https://raw.githubusercontent.com/LuaUScrip/LuaU/refs/heads/main/LoaderPrem.lua",
    
    GET_KEY_URL = "https://work.ink/2Mm1/antigodhub-key-system",
    DISCORD_INVITE = "https://discord.gg/jdJvZm6VdK",
    
    --// Whitelisted IDs (Horizontal format - Easy to add)
    WHITELISTED_IDS = { 123456789, 987654321, 111111111, 222222222 },
    
    --// UI
    UI = {
        WIDTH = 420,
        HEIGHT = 240,
        CORNER_RADIUS = 20,
        FONT = Enum.Font.Gotham,
        FONT_BOLD = Enum.Font.GothamBold,
    },
    
    --// Colors
    COLORS = {
        bg = Color3.fromRGB(20, 20, 24),
        surface = Color3.fromRGB(28, 28, 32),
        surfaceLight = Color3.fromRGB(35, 35, 40),
        text = Color3.fromRGB(255, 255, 255),
        textSecond = Color3.fromRGB(180, 180, 190),
        textMuted = Color3.fromRGB(120, 120, 130),
        border = Color3.fromRGB(50, 50, 58),
        button = Color3.fromRGB(240, 240, 245),
        primary = Color3.fromRGB(88, 166, 255),
        success = Color3.fromRGB(76, 175, 80),
        error = Color3.fromRGB(244, 67, 54),
        warning = Color3.fromRGB(255, 193, 7),
        notifBg = Color3.fromRGB(35, 35, 42),
    },
    
    --// Material Icons (Unicode)
    ICONS = {
        close = "X",
        key = "🔐",
        discord = "💬",
        check = "✓",
    },
}

--========================================
--// SERVICES & UTILITIES
--========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local Parent = game:GetService("CoreGui")

--// Key Storage
local KEY_SAVE_NAME = "AntiGodHub_Key"

local function SaveKey(key)
    pcall(function() writefile(KEY_SAVE_NAME, key) end)
end

local function LoadSavedKey()
    local success, key = pcall(function() return readfile(KEY_SAVE_NAME) end)
    if success then return key end
    return nil
end

local function IsValidKey(enteredKey)
    for _, validKey in ipairs(CONFIG.MAIN_KEYS) do
        if enteredKey == validKey then
            return true, "standard"
        end
    end
    return false, nil
end

local function IsValidPremiumKey(enteredKey)
    for _, validKey in ipairs(CONFIG.PREMIUM_KEYS) do
        if enteredKey == validKey then
            return true
        end
    end
    return false
end

local function Get(url)
    local Success, Result = pcall(function() return game:HttpGet(url) end)
    return Success and Result or nil
end

local function CopyToClipboard(text)
    pcall(function() if setclipboard then setclipboard(text) end end)
end

local function LoadMainLoader(loaderUrl)
    local Source = Get(loaderUrl)
    if not Source then return false end
    local Function = loadstring(Source)
    if not Function then return false end
    local Success = pcall(Function)
    return Success
end

local function IsPlayerWhitelisted()
    for _, id in ipairs(CONFIG.WHITELISTED_IDS) do
        if Player.UserId == id then return true end
    end
    return false
end

if not CONFIG.KEYLESS and not IsPlayerWhitelisted() then
    local savedKey = LoadSavedKey()
    if savedKey then
        if IsValidKey(savedKey) then
            LoadMainLoader(CONFIG.LOADER_URL)
            return
        elseif IsValidPremiumKey(savedKey) then
            LoadMainLoader(CONFIG.PREMIUM_LOADER_URL)
            return
        end
    end
end

if CONFIG.KEYLESS or IsPlayerWhitelisted() then
    LoadMainLoader(CONFIG.LOADER_URL)
    return
end

--========================================
--// UI SETUP
--========================================

local OldUI = Parent:FindFirstChild("AntiGodHub")
if OldUI then OldUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiGodHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Parent

local backdrop = Instance.new("Frame")
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backdrop.BackgroundTransparency = 1
backdrop.BorderSizePixel = 0
backdrop.Parent = ScreenGui

local container = Instance.new("Frame")
container.Size = UDim2.new(0, CONFIG.UI.WIDTH, 0, CONFIG.UI.HEIGHT)
container.Position = UDim2.fromScale(0.5, 0.5)
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.BackgroundColor3 = CONFIG.COLORS.surface
container.BorderSizePixel = 0
container.BackgroundTransparency = 1
container.Parent = backdrop

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, CONFIG.UI.CORNER_RADIUS)
containerCorner.Parent = container

--// Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = CONFIG.COLORS.bg
header.BorderSizePixel = 0
header.Parent = container

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, CONFIG.UI.CORNER_RADIUS)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 10)
headerFix.Position = UDim2.new(0, 0, 1, -10)
headerFix.BackgroundColor3 = CONFIG.COLORS.bg
headerFix.BorderSizePixel = 0
headerFix.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.BackgroundTransparency = 1
title.Text = "AntiGodHub"
title.TextColor3 = CONFIG.COLORS.text
title.TextSize = 16
title.Font = CONFIG.UI.FONT_BOLD
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0.5, 0)
closeButton.AnchorPoint = Vector2.new(0, 0.5)
closeButton.BackgroundTransparency = 1
closeButton.Text = CONFIG.ICONS.close
closeButton.TextColor3 = CONFIG.COLORS.textSecond
closeButton.TextSize = 18
closeButton.Font = CONFIG.UI.FONT_BOLD
closeButton.Parent = header

closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(container, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.wait(0.2)
    ScreenGui:Destroy()
end)

closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15), {TextColor3 = CONFIG.COLORS.error}):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15), {TextColor3 = CONFIG.COLORS.textSecond}):Play()
end)

--// Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -40, 1, -60)
content.Position = UDim2.new(0, 20, 0, 50)
content.BackgroundTransparency = 1
content.Parent = container

local description = Instance.new("TextLabel")
description.Size = UDim2.new(1, 0, 0, 18)
description.BackgroundTransparency = 1
description.Text = "Enter your key to continue"
description.TextColor3 = CONFIG.COLORS.textSecond
description.TextSize = 12
description.Font = CONFIG.UI.FONT
description.TextXAlignment = Enum.TextXAlignment.Left
description.Parent = content

--// Input
local inputSection = Instance.new("Frame")
inputSection.Size = UDim2.new(1, 0, 0, 40)
inputSection.Position = UDim2.new(0, 0, 0, 25)
inputSection.BackgroundColor3 = CONFIG.COLORS.surfaceLight
inputSection.BorderSizePixel = 0
inputSection.Parent = content

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputSection

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = CONFIG.COLORS.border
inputStroke.Thickness = 1
inputStroke.Parent = inputSection

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -30, 1, 0)
keyInput.Position = UDim2.new(0, 15, 0, 0)
keyInput.BackgroundTransparency = 1
keyInput.PlaceholderText = "key"
keyInput.PlaceholderColor3 = CONFIG.COLORS.textMuted
keyInput.Text = ""
keyInput.TextColor3 = CONFIG.COLORS.text
keyInput.TextSize = 13
keyInput.Font = CONFIG.UI.FONT
keyInput.ClearTextOnFocus = false
keyInput.Parent = inputSection

keyInput.Focused:Connect(function()
    TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = CONFIG.COLORS.primary, Thickness = 2}):Play()
end)

keyInput.FocusLost:Connect(function()
    TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = CONFIG.COLORS.border, Thickness = 1}):Play()
end)

--// Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 15)
statusLabel.Position = UDim2.new(0, 0, 0, 8)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = CONFIG.COLORS.error
statusLabel.TextSize = 11
statusLabel.Font = CONFIG.UI.FONT
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = content

--// Verify Button
local verifyButton = Instance.new("TextButton")
verifyButton.Size = UDim2.new(1, 0, 0, 44)
verifyButton.Position = UDim2.new(0, 0, 0, 87)
verifyButton.BackgroundColor3 = CONFIG.COLORS.button
verifyButton.BorderSizePixel = 0
verifyButton.Text = CONFIG.ICONS.check .. " Verify"
verifyButton.TextColor3 = CONFIG.COLORS.bg
verifyButton.TextSize = 14
verifyButton.Font = CONFIG.UI.FONT_BOLD
verifyButton.AutoButtonColor = false
verifyButton.Parent = content

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 10)
verifyCorner.Parent = verifyButton

verifyButton.MouseEnter:Connect(function()
    if not verifyButton.Interactable then return end
    TweenService:Create(verifyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 220, 225)}):Play()
end)

verifyButton.MouseLeave:Connect(function()
    if not verifyButton.Interactable then return end
    TweenService:Create(verifyButton, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.button}):Play()
end)

--// Secondary Buttons
local secondaryButtons = Instance.new("Frame")
secondaryButtons.Size = UDim2.new(1, 0, 0, 24)
secondaryButtons.Position = UDim2.new(0, 0, 0, 140)
secondaryButtons.BackgroundTransparency = 1
secondaryButtons.Parent = content

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.Padding = UDim.new(0, 20)
buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
buttonLayout.Parent = secondaryButtons

--// Notification System
local function ShowNotification(message, duration)
    local notifContainer = Instance.new("Frame")
    notifContainer.Size = UDim2.new(0, 300, 0, 50)
    notifContainer.Position = UDim2.new(0.5, -150, 0.5, -340)
    notifContainer.BackgroundColor3 = CONFIG.COLORS.notifBg
    notifContainer.BorderSizePixel = 0
    notifContainer.Parent = ScreenGui
    notifContainer.ZIndex = 100
    notifContainer.BackgroundTransparency = 0.1
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 12)
    notifCorner.Parent = notifContainer
    
    local notifShadow = Instance.new("UIStroke")
    notifShadow.Color = Color3.fromRGB(0, 0, 0)
    notifShadow.Thickness = 2
    notifShadow.Parent = notifContainer
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, 0, 1, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = message
    notifText.TextColor3 = CONFIG.COLORS.text
    notifText.TextSize = 13
    notifText.Font = CONFIG.UI.FONT_BOLD
    notifText.Parent = notifContainer
    
    notifContainer.Size = UDim2.new(0, 0, 0, 50)
    notifContainer.BackgroundTransparency = 1
    notifText.TextTransparency = 1
    notifShadow.Transparency = 1
    
    TweenService:Create(
        notifContainer,
        TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 300, 0, 50)}
    ):Play()
    
    TweenService:Create(
        notifContainer,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.1}
    ):Play()
    
    TweenService:Create(
        notifText,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {TextTransparency = 0}
    ):Play()
    
    TweenService:Create(
        notifShadow,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Transparency = 0}
    ):Play()
    
    task.wait(duration or 2)
    
    TweenService:Create(
        notifContainer,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 50), Position = UDim2.new(0.5, 0, 0.5, -340)}
    ):Play()
    
    TweenService:Create(
        notifContainer,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {BackgroundTransparency = 1}
    ):Play()
    
    TweenService:Create(
        notifText,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {TextTransparency = 1}
    ):Play()
    
    TweenService:Create(
        notifShadow,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Transparency = 1}
    ):Play()
    
    task.wait(0.35)
    notifContainer:Destroy()
end

local function CreateSecondaryButton(icon, label, order, callback)
    local btn = Instance.new("TextButton")
    btn.LayoutOrder = order
    btn.Size = UDim2.new(0.5, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = icon .. " " .. label
    btn.TextColor3 = CONFIG.COLORS.textSecond
    btn.TextSize = 12
    btn.Font = CONFIG.UI.FONT_BOLD
    btn.Parent = secondaryButtons
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.text}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.textSecond}):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

CreateSecondaryButton(CONFIG.ICONS.key, "Get Key", 1, function()
    CopyToClipboard(CONFIG.GET_KEY_URL)
    ShowNotification(CONFIG.ICONS.check .. " Get Key Link Copied", 2.5)
end)

CreateSecondaryButton(CONFIG.ICONS.discord, "Discord", 2, function()
    CopyToClipboard(CONFIG.DISCORD_INVITE)
    ShowNotification(CONFIG.ICONS.check .. " Discord Link Copied", 2.5)
end)

--// Verification Logic
local Checking = false
local lastKey = nil

local function ShakeAnimation()
    local orig = inputSection.Position
    for i = 1, 3 do
        TweenService:Create(inputSection, TweenInfo.new(0.05), {Position = orig + UDim2.new(0, -5, 0, 0)}):Play()
        task.wait(0.05)
        TweenService:Create(inputSection, TweenInfo.new(0.05), {Position = orig + UDim2.new(0, 5, 0, 0)}):Play()
        task.wait(0.05)
    end
    TweenService:Create(inputSection, TweenInfo.new(0.05), {Position = orig}):Play()
    task.wait(0.1)
end

local function VerifyKey()
    if Checking then return end
    
    local enteredKey = keyInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
    
    if enteredKey == "" then
        statusLabel.Text = ""
        ShakeAnimation()
        return
    end
    
    Checking = true
    verifyButton.Interactable = false
    statusLabel.Text = ""
    
    if enteredKey == lastKey and not IsValidKey(enteredKey) and not IsValidPremiumKey(enteredKey) then
        statusLabel.TextColor3 = CONFIG.COLORS.warning
        statusLabel.Text = "Expired Key"
        ShakeAnimation()
        TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = CONFIG.COLORS.warning}):Play()
        task.wait(0.5)
        TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = CONFIG.COLORS.border}):Play()
        Checking = false
        verifyButton.Interactable = true
        return
    end
    
    lastKey = enteredKey
    
    local isValid, keyType = IsValidKey(enteredKey)
    local isPremium = IsValidPremiumKey(enteredKey)
    
    if not isValid and not isPremium then
        statusLabel.TextColor3 = CONFIG.COLORS.error
        statusLabel.Text = "Invalid Key"
        TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = CONFIG.COLORS.error}):Play()
        ShakeAnimation()
        task.wait(0.5)
        TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = CONFIG.COLORS.border}):Play()
        Checking = false
        verifyButton.Interactable = true
        return
    end
    
    statusLabel.TextColor3 = CONFIG.COLORS.success
    statusLabel.Text = isPremium and "Premium Key Valid!" or "Key Valid!"
    TweenService:Create(verifyButton, TweenInfo.new(0.3), {BackgroundColor3 = CONFIG.COLORS.success}):Play()
    
    SaveKey(enteredKey)
    
    task.wait(0.7)
    
    TweenService:Create(container, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    
    ScreenGui:Destroy()
    
    if isPremium then
        LoadMainLoader(CONFIG.PREMIUM_LOADER_URL)
    else
        LoadMainLoader(CONFIG.LOADER_URL)
    end
end

verifyButton.MouseButton1Click:Connect(VerifyKey)

keyInput.FocusLost:Connect(function(EnterPressed)
    if EnterPressed then VerifyKey() end
end)

TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
