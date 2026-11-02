-- ==========================================
-- DEMON SCRIPT v1.0 - Personalizado para: Demon
-- Key: demon-hs55vd92
-- Autor: anonimo
-- ==========================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local SettingsService = game:GetService("Settings")

-- ==========================================
-- CONFIGURAÇÕES GERAIS
-- ==========================================
local ACCOUNT_NAME = "Demon" -- Nome da sua conta
local VALID_KEY = "demon-hs55vd92"

-- Variáveis de estado
local isFarming = false
local farmingThread = nil
local isDoingMissions = false
local isHuntingSeaEvents = false
local waterWalkingActive = false
local jumpBoostActive = false
local lowGraphicsActive = false

-- Valores originais para restaurar depois
local originalJumpPower = Humanoid.JumpPower
local originalMaxHealth = Humanoid.MaxHealth

-- ==========================================
-- SISTEMA DE KEY E LOGIN
-- ==========================================
local keyFrame = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
keyFrame.Name = "KeyFrame_Demon"
keyFrame.ResetOnSpawn = false

local keyLabel = Instance.new("TextLabel", keyFrame)
keyLabel.Size = UDim2.new(0, 320, 0, 60)
keyLabel.Position = UDim2.new(0.5, -160, 0.1, 0)
keyLabel.BackgroundTransparency = 0.3
keyLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextSize = 20
keyLabel.Text = "👤 Conta: " .. ACCOUNT_NAME
keyLabel.BorderSizePixel = 0
keyLabel.TextXAlignment = Enum.TextXAlignment.Center

local keyTextBox = Instance.new("TextBox", keyFrame)
keyTextBox.Size = UDim2.new(0, 320, 0, 40)
keyTextBox.Position = UDim2.new(0.5, -160, 0.2, 0)
keyTextBox.PlaceholderText = "Cole aqui sua key..."
keyTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
keyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTextBox.Font = Enum.Font.Gotham
keyTextBox.TextSize = 16
keyTextBox.BorderSizePixel = 0
keyTextBox.Text = ""

local keyButton = Instance.new("TextButton", keyFrame)
keyButton.Size = UDim2.new(0, 320, 0, 45)
keyButton.Position = UDim2.new(0.5, -160, 0.3, 0)
keyButton.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
keyButton.Text = "🔓 Entrar como " .. ACCOUNT_NAME
keyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
keyButton.Font = Enum.Font.GothamBold
keyButton.TextSize = 18
keyButton.BorderSizePixel = 0

local keySuccess = Instance.new("TextLabel", keyFrame)
keySuccess.Size = UDim2.new(0, 320, 0, 40)
keySuccess.Position = UDim2.new(0.5, -160, 0.4, 0)
keySuccess.BackgroundTransparency = 0.5
keySuccess.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
keySuccess.TextColor3 = Color3.fromRGB(255, 255, 255)
keySuccess.Font = Enum.Font.GothamBold
keySuccess.TextSize = 16
keySuccess.Text = ""
keySuccess.BorderSizePixel = 0

local keyError = Instance.new("TextLabel", keyFrame)
keyError.Size = UDim2.new(0, 320, 0, 40)
keyError.Position = UDim2.new(0.5, -160, 0.4, 0)
keyError.BackgroundTransparency = 0.5
keyError.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
keyError.TextColor3 = Color3.fromRGB(255, 255, 255)
keyError.Font = Enum.Font.GothamBold
keyError.TextSize = 16
keyError.Text = ""
keyError.BorderSizePixel = 0

keyButton.MouseButton1Click:Connect(function()
    local inputKey = keyTextBox.Text
    if inputKey == VALID_KEY then
        keySuccess.Text = "✅ Bem-vindo, " .. ACCOUNT_NAME .. "! Menu Aberto."
        task.wait(1.5)
        keyFrame:Destroy()
        openMainGUI()
    else
        keyError.Text = "❌ Key Inválida para " .. ACCOUNT_NAME .. "!"
        task.wait(2)
        keyError.Text = ""
    end
end)

print("[DemonScript] Carregado para a conta: " .. ACCOUNT_NAME)

-- ==========================================
-- MENU PRINCIPAL (GUI)
-- ==========================================
local mainGUI = nil
local frameContainer = nil

function createButton(parent, text, position, size, bgColor, textColor, onClick)
    local btn = Instance.new("TextButton", parent)
    btn.Size = size
    btn.Position = position
    btn.BackgroundColor3 = bgColor
    btn.Text = text
    btn.TextColor3 = textColor
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.BorderSizePixel = 0
    
    btn.MouseButton1Click:Connect(onClick)
    return btn
end

function openMainGUI()
    if mainGUI then mainGUI:Destroy() end
    
    mainGUI = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    mainGUI.Name = "DemonScript_Menu"
    mainGUI.ResetOnSpawn = false
    
    frameContainer = Instance.new("Frame", mainGUI)
    frameContainer.Size = UDim2.new(0, 380, 0, 650)
    frameContainer.Position = UDim2.new(0.5, -190, 0.5, -325)
    frameContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frameContainer.BackgroundTransparency = 0.1
    frameContainer.BorderSizePixel = 0
    
    -- Cabeçalho com nome da conta
    local headerFrame = Instance.new("Frame", frameContainer)
    headerFrame.Size = UDim2.new(1, 0, 0, 70)
    headerFrame.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
    headerFrame.BorderSizePixel = 0
    
    local titleLabel = Instance.new("TextLabel", headerFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundTransparency = 0.5
    titleLabel.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
    titleLabel.Text = "🐉 DEMON SCRIPT"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 22
    titleLabel.BorderSizePixel = 0
    
    local accountLabel = Instance.new("TextLabel", headerFrame)
    accountLabel.Size = UDim2.new(1, 0, 0, 30)
    accountLabel.Position = UDim2.new(0, 0, 0.5, 0)
    accountLabel.BackgroundTransparency = 0.5
    accountLabel.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
    accountLabel.Text = "👤 Conta: " .. ACCOUNT_NAME
    accountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    accountLabel.Font = Enum.Font.Gotham
    accountLabel.TextSize = 16
    accountLabel.BorderSizePixel = 0
    
    -- Botão Fechar
    local closeBtn = Instance.new("TextButton", frameContainer)
    closeBtn.Size = UDim2.new(0, 50, 0, 30)
    closeBtn.Position = UDim2.new(1, -50, 0, 75)
    closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.BorderSizePixel = 0
    
    closeBtn.MouseButton1Click:Connect(function()
        mainGUI:Destroy()
    end)
    
    -- ==========================================
    -- SEÇÃO: AUTO FARM & MISSÕES
    -- ==========================================
    local farmSection = Instance.new("Frame", frameContainer)
    farmSection.Size = UDim2.new(1, -20, 0, 180)
    farmSection.Position = UDim2.new(0, 10, 0, 80)
    farmSection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    farmSection.BorderSizePixel = 0
    
    local farmTitle = Instance.new("TextLabel", farmSection)
    farmTitle.Size = UDim2.new(1, 0, 0, 35)
    farmTitle.BackgroundTransparency = 0.5
    farmTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    farmTitle.Text = "⚔️ AUTO FARM & MISSÕES"
    farmTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    farmTitle.Font = Enum.Font.GothamBold
    farmTitle.TextSize = 18
    farmTitle.BorderSizePixel = 0
    
    -- Auto Farm XP
    local autoFarmBtn = createButton(farmSection, "🟢 Ativar Auto Farm XP", UDim2.new(0.1, 0, 0, 45), UDim2.new(0.8, 0, 0, 35), Color3.fromRGB(0, 100, 0), Color3.fromRGB(255, 255, 255), function()
        toggleAutoFarm(true)
        autoFarmBtn.Text = "🔴 Parar Auto Farm"
        autoFarmBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end)
    
    -- Auto Missões Completas
    local autoMissionBtn = createButton(farmSection, "📜 Completar Todas as Missões", UDim2.new(0.1, 0, 0, 90), UDim2.new(0.8, 0, 0, 35), Color3.fromRGB(0, 0, 150), Color3.fromRGB(255, 255, 255), function()
        toggleAutoMissions(true)
        print("[DemonScript] Iniciando ciclo completo de missões...")
    end)
    
    -- Auto Espadas (Simulado)
    local swordBtn = createButton(farmSection, "🗡️ Farmar Todas as Espadas", UDim2.new(0.1, 0, 0, 135), UDim2.new(0.8, 0, 0, 35), Color3.fromRGB(150, 100, 0), Color3.fromRGB(0, 0, 0), function()
        toggleSwordFarm(true)
        print("[DemonScript] Farm de Espadas Iniciado!")
    end)
    
    -- ==========================================
    -- SEÇÃO: EVENTOS MARÍTIMOS
    -- ==========================================
    local eventSection = Instance.new("Frame", frameContainer)
    eventSection.Size = UDim2.new(1, -20, 0, 120)
    eventSection.Position = UDim2.new(0, 10, 0, 270)
    eventSection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    eventSection.BorderSizePixel = 0
    
    local eventTitle = Instance.new("TextLabel", eventSection)
    eventTitle.Size = UDim2.new(1, 0, 0, 35)
    eventTitle.BackgroundTransparency = 0.5
    eventTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    eventTitle.Text = "🌊 CAÇA A EVENTOS MARÍTIMOS"
    eventTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    eventTitle.Font = Enum.Font.GothamBold
    eventTitle.TextSize = 18
    eventTitle.BorderSizePixel = 0
    
    local seaEventBtn = createButton(eventSection, "🚢 Caçar Todos os Eventos Marítimos", UDim2.new(0.1, 0, 0, 50), UDim2.new(0.8, 0, 0, 35), Color3.fromRGB(0, 100, 100), Color3.fromRGB(255, 255, 255), function()
        toggleSeaEvents(true)
        print("[DemonScript] Caça a Eventos Marítimos Iniciada! Procurando navios e eventos...")
    end)
    
    -- ==========================================
    -- SEÇÃO: LOJINHA DEMON
    -- ==========================================
    local shopSection = Instance.new("Frame", frameContainer)
    shopSection.Size = UDim2.new(1, -20, 0, 180)
    shopSection.Position = UDim2.new(0, 10, 0, 400)
    shopSection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    shopSection.BorderSizePixel = 0
    
    local shopTitle = Instance.new("TextLabel", shopSection)
    shopTitle.Size = UDim2.new(1, 0, 0, 35)
    shopTitle.BackgroundTransparency = 0.5
    shopTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    shopTitle.Text = "🛒 LOJINHA OFICIAL - " .. ACCOUNT_NAME
    shopTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    shopTitle.Font = Enum.Font.GothamBold
    shopTitle.TextSize = 18
    shopTitle.BorderSizePixel = 0
    
    -- Item 1: Yama
    local yamaBtn = createButton(shopSection, "🗡️ Comprar Yama (Virtual)", UDim2.new(0.1, 0, 0, 45), UDim2.new(0.8, 0, 0, 35), Color3.fromRGB(200, 150, 0), Color3.fromRGB(0, 0, 0), function()
        purchaseItem("Yama", "Espada Lendária")
    end)
    
    -- Item 2: Dragon Fruit
    local dragonBtn = createButton(shopSection, "🐉 Comprar Dragon Fruit", UDim2.new(0.1, 0, 0, 90), UDim2.new(0.8, 0, 0, 35), Color3.fromRGB(200, 50, 50), Color3.fromRGB(255, 255, 255), function()
        purchaseItem("Dragon Fruit", "Paramecia Lendária")
    end)
    
    -- Item 3: Haki Advanced
    local hakiBtn = createButton(shopSection, "👁️ Comprar Haki Avançado", UDim2.new(0.1, 0, 0, 135), UDim2.new(0.8, 0, 0, 35), Color3.fromRGB(100, 0, 150), Color3.fromRGB(255, 255, 255), function()
        purchaseItem("Haki Avançado", "Conjuração de Haki")
    end)
    
    -- Item 4: Speed Boost
    local speedBtn = createButton(shopSection, "⚡ Comprar Speed Boost", UDim2.new(0.1, 0, 0, 180), UDim2.new(0.8, 0, 0, 35), Color3.fromRGB(0, 150, 150), Color3.fromRGB(0, 0, 0), function()
        purchaseItem("Speed Boost", "Velocidade Máxima")
        applySpeedBoost(true)
    end)
    
    -- ==========================================
    -- SEÇÃO: CONFIGURAÇÕES AVANÇADAS
    -- ==========================================
    local configSection = Instance.new("Frame", frameContainer)
    configSection.Size = UDim2.new(1, -20, 0, 180)
    configSection.Position = UDim2.new(0, 10, 0, 590)
    configSection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    configSection.BorderSizePixel = 0
    
    local configTitle = Instance.new("TextLabel", configSection)
    configTitle.Size = UDim2.new(1, 0, 0, 35)
    configTitle.BackgroundTransparency = 0.5
    configTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    configTitle.Text = "⚙️ CONFIGURAÇÕES DO SISTEMA"
    configTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    configTitle.Font = Enum.Font.GothamBold
    configTitle.TextSize = 18
    configTitle.BorderSizePixel = 0
    
    -- Andar sobre a água
    local waterWalkBtn = createButton(configSection, "💧 Andar Sobre a Água", UDim2.new(0.1, 0, 0, 45), UDim2.new(0.8, 0, 0, 35), Color3.fromRGB(0, 100, 200), Color3.fromRGB(255, 255, 255), function()
        toggleWaterWalking()
        if waterWalkingActive then
            waterWalkBtn.Text = "💧 Andar Sobre a Água (ATIVADO)"
            waterWalkBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        else
            waterWalkBtn.Text = "💧 Andar Sobre a Água"
            waterWalkBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        end
    end)
    
    -- Pulo Aumentado
    local jumpBoostBtn = createButton(configSection, "🦘 Pulo Aumentado (2x)", UDim2.new(0.1, 0, 0, 90), UDim2.new(0.8, 0, 0, 35), Color3.fromRGB(100, 100, 0), Color3.fromRGB(0, 0, 0), function()
        toggleJumpBoost()
        if jumpBoostActive then
            jumpBoostBtn.Text = "🦘 Pulo Aumentado (2x) ATIVO"
            jumpBoostBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        else
            jumpBoostBtn.Text = "🦘 Pulo Aumentado (2x)"
            jumpBoostBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
        end
    end)
    
    -- Reduzir Gráficos
    local lowGraphicsBtn = createButton(configSection, "📉 Reduzir Gráficos (PC Fraco)", UDim2.new(0.1, 0, 0, 135), UDim2.new(0.8, 0, 0, 35), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255), function()
        toggleLowGraphics()
        if lowGraphicsActive then
            lowGraphicsBtn.Text = "📉 Gráficos Reduzidos"
            lowGraphicsBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        else
            lowGraphicsBtn.Text = "📉 Reduzir Gráficos"
            lowGraphicsBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end
    end)
    
    -- Aumentar Velocidade do Player
    local speedConfigBtn = createButton(configSection, "⚡ Aumentar Velocidade do Player", UDim2.new(0.1, 0, 0, 180), UDim2.new(0.8, 0, 0, 35), Color3.fromRGB(0, 150, 0), Color3.fromRGB(255, 255, 255), function()
        togglePlayerSpeed()
        print("[DemonScript] Velocidade do Player Aumentada!")
    end)
    
    print("[DemonScript] GUI do " .. ACCOUNT_NAME .. " carregada com sucesso!")
end

-- ==========================================
-- FUNÇÕES AUXILIARES DA LOJA
-- ==========================================
function purchaseItem(itemName, description)
    print("[DemonScript] " .. ACCOUNT_NAME .. " comprou: " .. itemName .. " (" .. description .. ")")
    
    -- Feedback visual no menu
    local successMsg = Instance.new("TextLabel", frameContainer)
    successMsg.Size = UDim2.new(0.8, 0, 0, 35)
    successMsg.Position = UDim2.new(0.1, 0, 0, 635)
    successMsg.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    successMsg.Text = "✅ " .. ITEM_NAME .. " Adquirido!"
    successMsg.TextColor3 = Color3.fromRGB(255, 255, 255)
    successMsg.Font = Enum.Font.GothamBold
    successMsg.TextSize = 14
    task.wait(3)
    successMsg:Destroy()
end

-- Corrigido: Usar itemName corretamente
function purchaseItem(itemName, description)
    print("[DemonScript] " .. ACCOUNT_NAME .. " comprou: " .. itemName .. " (" .. description .. ")")
    
    -- Feedback visual no menu
    local successMsg = Instance.new("TextLabel", frameContainer)
    successMsg.Size = UDim2.new(0.8, 0, 0, 35)
    successMsg.Position = UDim2.new(0.1, 0, 0, 635)
    successMsg.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    successMsg.Text = "✅ " .. itemName .. " Adquirido!"
    successMsg.TextColor3 = Color3.fromRGB(255, 255, 255)
    successMsg.Font = Enum.Font.GothamBold
    successMsg.TextSize = 14
    task.wait(3)
    successMsg:Destroy()
end

-- ==========================================
-- LÓGICA DE AUTO FARM
-- ==========================================
function toggleAutoFarm(state)
    if state and not isFarming then
        isFarming = true
        farmingThread = coroutine.create(function()
            print("[DemonScript] Auto Farm iniciado para " .. ACCOUNT_NAME)
            
            while isFarming and LocalPlayer.Character do
                task.wait(0.1)
                
                -- Encontra o inimigo mais próximo
                local closestEnemy = nil
                local minDistance = 150
                
                -- Tenta encontrar inimigos na área
                for _, model in pairs(Workspace.Model:GetChildren()) do
                    if model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
                        local distance = (model.HumanoidRootPart.Position - RootPart.Position).Magnitude
                        if distance < minDistance then
                            minDistance = distance
                            closestEnemy = model
                        end
                    end
                end
                
                -- Se não encontrou em Model, tenta direct children of Workspace
                if not closestEnemy then
                    for _, child in pairs(Workspace:GetChildren()) do
                        if child:IsA("Model") and child:FindFirstChild("Humanoid") and child:FindFirstChild("HumanoidRootPart") then
                            local distance = (child.HumanoidRootPart.Position - RootPart.Position).Magnitude
                            if distance < minDistance then
                                minDistance = distance
                                closestEnemy = child
                            end
                        end
                    end
                end
                
                if closestEnemy and closestEnemy:FindFirstChild("Humanoid") and closestEnemy.Humanoid.Health > 0 then
                    -- Move até o inimigo
                    RootPart.CFrame = CFrame.new(closestEnemy.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
                    
                    -- Tenta atacar
                    local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                    
                    -- Se tiver fruta, usa a habilidade básica
                    local fruit = LocalPlayer.PlayerScripts:FindFirstChild("Fruit")
                    if fruit then
                        -- Simula uso de fruta
                    end
                elseif not closestEnemy then
                    -- Se não tem inimigo, move-se aleatoriamente para buscar
                    local randomOffset = Vector3.new(math.random(-50, 50), 0, math.random(-50, 50))
                    RootPart.CFrame = RootPart.CFrame + randomOffset
                end
            end
            
            print("[DemonScript] Auto Farm parado para " .. ACCOUNT_NAME)
        end)
        coroutine.resume(farmingThread)
    elseif not state and isFarming then
        isFarming = false
        if farmingThread then
            coroutine.close(farmingThread)
        end
    end
end

-- ========
