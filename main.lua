-- ============================================
-- 🔥 DEMON HUB — BLOX FRUITS v1.0
-- Script completo com interface mobile
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChild("Humanoid")
local RootPart = Character:FindFirstChild("HumanoidRootPart")

if not Humanoid or not RootPart then
    wait(1)
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid = Character:FindFirstChild("Humanoid")
    RootPart = Character:FindFirstChild("HumanoidRootPart")
end

-- ============================================
-- CONFIGURAÇÕES GERAIS
-- ============================================
local DEMON_HUB_CONFIG = {
    -- Chave única
    API_KEY = "DEMON-ADMIN-001",
    
    -- Cores
    Colors = {
        Background = Color3.fromRGB(10, 10, 10),
        Header = Color3.fromRGB(20, 20, 20),
        ButtonActive = Color3.fromRGB(139, 0, 0),
        ButtonInactive = Color3.fromRGB(40, 40, 40),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        AccentRed = Color3.fromRGB(255, 0, 0),
        BorderColor = Color3.fromRGB(60, 60, 60),
        Success = Color3.fromRGB(0, 255, 0),
        Error = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 165, 0),
    },
    
    -- Configurações padrão
    DefaultSettings = {
        PanelSize = UDim2.new(0, 350, 0, 500),
        Transparency = 0.95,
        AnimationsEnabled = true,
        NotificationsEnabled = true,
        CompactMode = false,
        Minimized = false,
    },
    
    -- Farm Settings
    FarmSettings = {
        AutoFarmEnabled = false,
        SelectedEnemy = "Mare",
        SelectedMission = "Quest",
        SelectedIsland = "Starting Island",
        FarmDistance = 100,
        SelectedWeapon = "Sword",
        CombatStyle = "Melee",
        AbilitiesEnabled = true,
        StopFarm = false,
    },
    
    -- Raid Settings
    RaidSettings = {
        RaidType = "Normal",
        RaidProgress = 0,
        RaidActive = false,
        RaidBosses = {"Viper", "King Black Flame", "Don Swan"},
    },
    
    -- Combat Settings
    CombatSettings = {
        AbilitiesSelected = {},
        WeaponsSelected = {},
        ControlsConfigured = true,
        TrainingMode = false,
    },
    
    -- Teleport Settings
    TeleportSettings = {
        Islands = {
            "Starting Island",
            "Jungle",
            "Desert",
            "Snow Island",
            "Marine",
            "Sky Island",
            "Haunted Castle",
            "Magma Town",
            "Port Town",
            "Prison",
            "Colosseum",
            "Fountain City",
            "Cyber City",
            "Great Tree",
            "Deep Forest",
            "Volcano",
            "Ice Castle",
            "Sky Temple",
            "Tiki Island",
            "Pirate Port",
            "Garden of Swans",
            "Dressrosa",
            "Amazon",
            "Hallowtemple",
            "Library",
            "The Great Tree",
            "Frozen Village",
            "Hydra",
            "Rokaku",
            "Sea Fortress",
            "Raid Island",
            "Blox Fruit Dealer Ship",
            "Second Sea",
            "Third Sea"
        },
        SearchQuery = "",
        SelectedDestination = "",
    },
    
    -- Player Settings
    PlayerSettings = {
        CurrentHealth = 0,
        CurrentEnergy = 0,
        MaxHealth = 100,
        MaxEnergy = 100,
        SpeedMultiplier = 1,
        MovementTestMode = false,
    },
    
    -- Settings
    Settings = {
        PanelWidth = 350,
        PanelHeight = 500,
        Transparency = 0.95,
        AnimationsEnabled = true,
        NotificationsEnabled = true,
        CompactMode = false,
    }
}

-- ============================================
-- SISTEMA DE NOTIFICAÇÃO
-- ============================================
local NotificationSystem = {}
NotificationSystem.__index = NotificationSystem

function NotificationSystem:new()
    local instance = setmetatable({}, self)
    instance.NotificationsFolder = nil
    return instance
end

function NotificationSystem:Initialize()
    if not workspace:FindFirstChild("DemonHubNotifications") then
        local folder = Instance.new("Folder")
        folder.Name = "DemonHubNotifications"
        folder.Parent = workspace
        self.NotificationsFolder = folder
    else
        self.NotificationsFolder = workspace.DemonHubNotifications
    end
end

function NotificationSystem:Show(message, type, duration)
    if not DEMON_HUB_CONFIG.DefaultSettings.NotificationsEnabled and not duration then
        return
    end
    
    duration = duration or 3
    type = type or "info"
    
    local notification = Instance.new("ScreenGui")
    notification.Name = "Notification_" .. os.time()
    notification.ResetOnSpawn = false
    notification.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notification.Parent = game.CoreGui
    
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 300, 0, 50)
    frame.Position = UDim2.new(0.5, -150, 0, 20 + #game.CoreGui:GetChildren() * 60)
    frame.BackgroundColor3 = DEMON_HUB_CONFIG.Colors.Header
    frame.BorderSizePixel = 0
    frame.Parent = notification
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Text = message
    textLabel.Font = Enum.Font.Gothen
    textLabel.TextSize = 14
    textLabel.TextColor3 = DEMON_HUB_CONFIG.Colors.TextPrimary
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, -20, 1, 0)
    textLabel.Position = UDim2.new(0, 10, 0, 0)
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame
    
    local colorMap = {
        info = DEMON_HUB_CONFIG.Colors.AccentRed,
        success = DEMON_HUB_CONFIG.Colors.Success,
        error = DEMON_HUB_CONFIG.Colors.Error,
        warning = DEMON_HUB_CONFIG.Colors.Warning
    }
    
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 4, 1, 0)
    indicator.Position = UDim2.new(0, 0, 0, 0)
    indicator.BackgroundColor3 = colorMap[type] or DEMON_HUB_CONFIG.Colors.AccentRed
    indicator.Parent = frame
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = TweenService:Create(indicator, tweenInfo, {Size = UDim2.new(0, 4, 0, 0)})
    tween:Play()
    
    task.wait(duration)
    notification:Destroy()
end

function NotificationSystem:Info(message)
    self:Show(message, "info")
end

function NotificationSystem:Success(message)
    self:Show(message, "success")
end

function NotificationSystem:Error(message)
    self:Show(message, "error")
end

function NotificationSystem:Warning(message)
    self:Show(message, "warning")
end

local Notification = NotificationSystem:new()
Notification:Initialize()

-- ============================================
-- SISTEMA DE LOGO (DEMON HEAD)
-- ============================================
local LogoSystem = {}

function LogoSystem:DrawLogo(parent, size, position)
    local logoGroup = Instance.new("Frame")
    logoGroup.Name = "LogoGroup"
    logoGroup.Size = size
    logoGroup.Position = position
    logoGroup.BackgroundTransparency = 1
    logoGroup.Parent = parent
    
    -- Horns
    local hornLeft = Instance.new("Frame")
    hornLeft.Name = "HornLeft"
    hornLeft.Size = UDim2.new(0, 8, 0, 30)
    hornLeft.Position = UDim2.new(0.15, 0, 0, 0)
    hornLeft.BackgroundColor3 = DEMON_HUB_CONFIG.Colors.AccentRed
    hornLeft.Rotation = -30
    hornLeft.Parent = logoGroup
    
    local hornRight = Instance.new("Frame")
    hornRight.Name = "HornRight"
    hornRight.Size = UDim2.new(0, 8, 0, 30)
    hornRight.Position = UDim2.new(0.75, 0, 0, 0)
    hornRight.BackgroundColor3 = DEMON_HUB_CONFIG.Colors.AccentRed
    hornRight.Rotation = 30
    hornRight.Parent = logoGroup
    
    -- Head
    local head = Instance.new("Frame")
    head.Name = "Head"
    head.Size = UDim2.new(0.7, 0, 0.6, 0)
    head.Position = UDim2.new(0.15, 0, 0.2, 0)
    head.BackgroundColor3 = DEMON_HUB_CONFIG.Colors.ButtonActive
    head.Parent = logoGroup
    
    local headCorner = Instance.new("UICorner")
    headCorner.CornerRadius = UDim.new(0, 15)
    headCorner.Parent = head
    
    -- Eyes
    local eyeLeft = Instance.new("Frame")
    eyeLeft.Name = "EyeLeft"
    eyeLeft.Size = UDim2.new(0, 12, 0, 8)
    eyeLeft.Position = UDim2.new(0.15, 0, 0.2, 0)
    eyeLeft.BackgroundColor3 = DEMON_HUB_CONFIG.Colors.AccentRed
    eyeLeft.Parent = head
    
    local eyeRight = Instance.new("Frame")
    eyeRight.Name = "EyeRight"
    eyeRight.Size = UDim2.new(0, 12, 0, 8)
    eyeRight.Position = UDim2.new(0.65, 0, 0.2, 0)
    eyeRight.BackgroundColor3 = DEMON_HUB_CONFIG.Colors.AccentRed
    eyeRight.Parent = head
    
    -- Eye glow effect
    local glowLeft = Instance.new("UIStroke")
    glowLeft.Color = DEMON_HUB_CONFIG.Colors.AccentRed
    glowLeft.Thickness = 2
    glowLeft.Parent = eyeLeft
    
    local glowRight = Instance.new("UIStroke")
    glowRight.Color = DEMON_HUB_CONFIG.Colors.AccentRed
    glowRight.Thickness = 2
    glowRight.Parent = eyeRight
    
    return logoGroup
end

-- ============================================
-- SISTEMA DE CHAVE (KEY SYSTEM)
-- ============================================
local KeySystem = {}
KeySystem.__index = KeySystem

function KeySystem:new()
    local instance = setmetatable({}, self)
    instance.KeyValidated = false
    instance.ScreenGui = nil
    return instance
end

function KeySystem:Initialize()
    local selfRef = self
    
    -- Criar ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DemonHubKeyScreen"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game.CoreGui
    
    self.ScreenGui = screenGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = DEMON_HUB_CONFIG.Colors.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    local border = Instance.new("UIStroke")
    border.Color = DEMON_HUB_CONFIG.Colors.AccentRed
    border.Thickness = 2
    border.Parent = mainFrame
    
    -- Logo
    local logoGroup = LogoSystem:DrawLogo(mainFrame, UDim2.new(0.3, 0, 0, 80), UDim2.new(0.35, 0, 0.05, 0))
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = "🔥 DEMON HUB"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 24
    titleLabel.TextColor3 = DEMON_HUB_CONFIG.Colors.AccentRed
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -40, 0, 40)
    titleLabel.Position = UDim2.new(0, 20, 0.25, 0)
    titleLabel.Parent = mainFrame
    
    -- Subtítulo
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Name = "Subtitle"
    subtitleLabel.Text = "VERSÃO 1.0 | BLOX FRUITS"
    subtitleLabel.Font = Enum.Font.Gothin
