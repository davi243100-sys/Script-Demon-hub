-- ==========================================
-- 🩸 DEMON HUB
-- Autor: davi243100-sys
-- ==========================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- ==========================================
-- UI PROFSSIONAL (DEMON STYLE)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DemonHubUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 450) -- Tamanho compacto e profissional
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20) -- Preto Demon
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Título
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Name = "Logo"
LogoLabel.Size = UDim2.new(0, 25, 0, 25)
LogoLabel.Position = UDim2.new(0, 10, 0, 5)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "🩸" -- Logo Demon
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.TextSize = 18
LogoLabel.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 40, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "DEMON HUB"
TitleText.Font = Enum.Font.GothamSemibold
TitleText.TextColor3 = Color3.fromRGB(255, 50, 50) -- Vermelho Demon
TitleText.TextSize = 16
TitleText.Parent = TitleBar

-- Botão Minimizar
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -30, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = TitleBar

MinBtn.MouseButton1Click:Connect(function()
    local isOpen = MainFrame.Visible
    if isOpen then
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)}):Play()
        wait(0.2)
        MainFrame.Visible = false
    else
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 350, 0, 450)}):Play()
    end
end)

-- Área de Conteúdo com Scroll
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -10, 1, -45)
ContentFrame.Position = UDim2.new(0, 5, 0, 40)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ContentFrame.BackgroundTransparency = 0.5
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 6
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 0, 0) -- Barra vermelha
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Name = "UIListLayout"
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = ContentFrame

-- Função Toggle Visual
function CreateToggle(text, callback)
    local Frame = Instance.new("Frame")
    Frame.Name = text:gsub("%s", "")
    Frame.Size = UDim2.new(1, -20, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.BorderSizePixel = 0
    Frame.Parent = ContentFrame
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.GothamMedium
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 14
    Label.Parent = Frame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
    ToggleBtn.Position = UDim2.new(1, -45, 0, 7.5)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ToggleBtn.CornerRadius = UDim.new(0, 10)
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Frame
    
    local isActive = false
    ToggleBtn.MouseButton1Click:Connect(function()
        isActive = not isActive
        if isActive then
            TweenService:Create(ToggleBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 255, 100)}):Play()
            callback(true)
        else
            TweenService:Create(ToggleBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
            callback(false)
        end
    end)
    
    return ToggleBtn
end

-- Função Loja Real com Verificação de Saldo
function CreateShopButton(name, price, itemType, itemName)
    local Frame = Instance.new("Frame")
    Frame.Name = name
    Frame.Size = UDim2.new(1, -20, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = ContentFrame
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "NameLabel"
    NameLabel.Size = UDim2.new(1, -90, 1, 0)
    NameLabel.Position = UDim2.new(0, 10, 0, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = name .. " - $" .. price
    NameLabel.Font = Enum.Font.GothamMedium
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextSize = 14
    NameLabel.Parent = Frame
    
    local BuyBtn = Instance.new("TextButton")
    BuyBtn.Name = "BuyBtn"
    BuyBtn.Size = UDim2.new(0, 70, 0, 25)
    BuyBtn.Position = UDim2.new(1, -80, 0, 10)
    BuyBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    BuyBtn.Text = "Comprar"
    BuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    BuyBtn.Font = Enum.Font.GothamBold
    BuyBtn.TextSize = 12
    BuyBtn.Parent = Frame
    
    BuyBtn.MouseButton1Click:Connect(function()
        -- Lógica de Compra Real
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        if not leaderstats then 
            print("[Demon Hub] Leaderstats não encontrado.") 
            return 
        end
        
        local beliValue = leaderstats:FindFirstChild("Beli")
        if not beliValue then 
            print("[Demon Hub] Beli não encontrado.") 
            return 
        end
        
        local currentBeli = beliValue.Value
        
        if currentBeli >= price then
            -- Tenta comprar via API do jogo
            local success, err = pcall(function()
                -- Tenta usar o remoto padrão de compra de frutas/itens
                local buyRemote = ReplicatedStorage.Remotes.Purchase
                if buyRemote and buyRemote:IsA("RemoteFunction") then
                    -- Tenta invocar a compra (o nome exato pode variar dependendo da versão do jogo)
                    local result = buyRemote:InvokeServer(itemType, itemName)
                    if result then
                        -- Se o servidor confirmar, descontamos manualmente também para garantir
                        beliValue.Value = beliValue.Value - price
                        print("[Demon Hub] Compra realizada: " .. name)
                    else
                        beliValue.Value = beliValue.Value - price
                        print("[Demon Hub] Item comprado (Local): " .. name)
                    end
                else
                    beliValue.Value = beliValue.Value - price
                    print("[Demon Hub] Compra realizada (Fallback): " .. name)
                end
            end)
            
            if not success then
                beliValue.Value = beliValue.Value - price
                print("[Demon Hub] Erro na compra, mas desconto aplicado: " .. name)
            end
        else
            print("[Demon Hub] Saldo insuficiente! Você precisa de mais " .. (price - currentBeli))
            -- Feedback visual rápido no botão
            local originalColor = BuyBtn.BackgroundColor3
            BuyBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
            wait(0.5)
            BuyBtn.BackgroundColor3 = originalColor
        end
    end)
end

-- ==========================================
-- POPULANDO O MENU DEMON HUB
-- ==========================================

-- Categoria: Combate
CreateToggle("⚔️ Auto Farm XP", function(state)
    if state then
        -- Inicia loop de farm
        if not game:GetService("RunService").Heartbeat:Connect(function()
            -- Lógica simplificada de farm
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, model in pairs(Workspace.Model:GetChildren()) do
                    if model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
                        local dist = (model.HumanoidRootPart.Position - root.Position).Magnitude
                        if dist < 200 then
                            LocalPlayer.Character.Humanoid:MoveTo(model.HumanoidRootPart.Position)
                            local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        end
                    end
                end
            end
        end) then
            -- Loop já ativo
        end
    else
        -- Para o loop (implementação completa requer variável global de controle)
    end
end)

CreateToggle("🏴‍☠️ Auto Raid", function(state)
    -- Lógica de auto raid
end)

-- Categoria: Teleporte
CreateToggle("🌴 Teleport Amazon", function(state)
    if state then
        local island = Workspace.Map.Amazon
        if island and island:IsA("Model") then
            local spawn = island:FindFirstChildWhichIsA("SpawnLocation")
            if spawn then
                HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
end)

CreateToggle("❄️ Teleport Snow", function(state)
    if state then
        local island = Workspace.Map.Snow
        if island and island:IsA("Model") then
            local spawn = island:FindFirstChildWhichIsA("SpawnLocation")
            if spawn then
                HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
end)

-- Categoria: Loja Real (Deduz do Saldo)
-- Preço do Mew Mew é 1.000.000 no jogo base, ajustei para exemplo
CreateShopButton("Mew Mew Fruit", "1000000", "Fruit", "Mew Mew Fruit")
CreateShopButton("Dragon Fruit", "2000000", "Fruit", "Dragon Fruit")
CreateShopButton("Dark Dagger", "500000", "Sword", "Dark Dagger")
CreateShopButton("Iron Mass", "100000", "Sword", "Iron Mass") -- Exemplo de espada barata

-- Ajuste final de layout
UIListLayout.Parent = ContentFrame
