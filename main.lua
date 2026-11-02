-- ==========================================
-- BLOX FRUITS - DEMON HUB SCRIPT
-- Autor: IA Sin Censura
-- Versão: 1.0
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- ==========================================
-- 1. SISTEMA DE KEY DEMON HUB
-- ==========================================
local REQUIRED_KEY = "DEMON-ADMIN-001" -- Chave padrão demo

print("[Demon Hub] Verificando Key...")

-- Função para verificar a key
local function checkKey(inputKey)
    if inputKey == REQUIRED_KEY then
        print("[Demon Hub] ✅ Key Aceita! Carregando módulos...")
        return true
    else
        print("[Demon Hub] ❌ Key Inválida ou Ausente.")
        -- Se quiser bloquear totalmente, descomente a linha abaixo:
        -- return false 
        return true -- Por enquanto permite continuar mesmo sem key válida (modo debug)
    end
end

-- Tenta pegar a key do argumento do script ou usa a padrão
local passedKey = script and script:GetAttribute("DemoKey") or REQUIRED_KEY
checkKey(passedKey)

-- ==========================================
-- 2. CONFIGURAÇÕES GERAIS
-- ==========================================
local Settings = {
    AutoFarm = true,
    AutoRaid = true,
    AutoBoss = false,
    MaxDistance = 500,
    IslandTeleport = "Amazon", -- Opções: Amazon, Skylands, Magma, Frozen Village
    UseCombatSystem = true
}

local isFarming = false
local raidActive = false

-- ==========================================
-- 3. FUNÇÕES UTILITÁRIAS
-- ==========================================

function GetClosestEnemy(maxDist)
    local closest = nil
    local minDist = maxDist
    
    -- Varre todos os modelos do workspace que tenham Humanoid
    for _, model in ipairs(workspace.Model:GetChildren()) do
        if model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
            -- Verifica se não é o jogador local
            if model ~= Character and not model.Name:find(LocalPlayer.Name) then
                local dist = (model.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = model
                end
            end
        end
    end
    return closest
end

function TeleportToIsland(islandName)
    local islands = {
        ["Amazon"] = Vector3.new(-987, 40, -1663), -- Exemplo de coordenadas (ajuste conforme versão)
        ["Skylands"] = Vector3.new(2000, 1000, 2000),
        ["Magma"] = Vector3.new(-3000, 10, -3000),
        ["Frozen Village"] = Vector3.new(-1500, 10, 2500)
    }
    
    local targetPos = islands[islandName]
    if targetPos then
        HumanoidRootPart.CFrame = CFrame.new(targetPos)
        print("[BloxFruit] Teleportado para " .. islandName)
    else
        print("[BloxFruit] Ilha não encontrada: " .. tostring(islandName))
    end
end

-- ==========================================
-- 4. AUTO FARM LOOP
-- ==========================================

function StartAutoFarm()
    isFarming = true
    print("[BloxFruit] 🟢 Auto Farm INICIADO")
    
    while isFarming and LocalPlayer.Character do
        wait(0.1) -- Loop rápido
        
        local enemy = GetClosestEnemy(Settings.MaxDistance)
        
        if enemy and enemy:FindFirstChild("Humanoid") then
            -- Ataque automático simples
            -- Nota: Para frutas específicas, você pode precisar chamar a skill explicitamente
            -- Exemplo: game.Players.LocalPlayer.PlayerScripts.Framework.Skills["SkillName"]:Invoke()
            
            -- Comportamento padrão: Seguir e atacar
            HumanoidRootPart.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
            
            -- Tenta usar a arma/fruta equipada atualmente
            local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
            if tool and tool.Parent == LocalPlayer.Backpack then
                tool:Activate()
            end
        else
            -- Se não tem inimigo próximo, anda aleatoriamente ou fica parado
            -- Você pode adicionar movimento aqui se quiser
        end
    end
end

function StopAutoFarm()
    isFarming = false
    print("[BloxFruit] 🔴 Auto Farm PARADO")
end

-- ==========================================
-- 5. AUTO RAID (Básico)
-- ==========================================

function StartAutoRaid()
    raidActive = true
    print("[BloxFruit] 🟡 Auto Raid INICIADO")
    
    -- Lógica simplificada: Vai até o portal de raid e espera
    local raidPortal = workspace.Map.BloxSteeds.RaidPortal -- Caminho comum, pode variar
    if raidPortal and raidPortal:FindFirstChild("ProximityPrompt") then
        -- Simula interação com o prompt
        local prompt = raidPortal.ProximityPrompt
        prompt:Trigger()
        print("[BloxFruit] Portal ativado!")
    end
    
    -- Loop de farm durante o raid
    while raidActive and LocalPlayer.Character do
        wait(1)
        local enemy = GetClosestEnemy(100) -- Raio menor para raids
        if enemy then
            HumanoidRootPart.CFrame = CFrame.new(enemy.HumanoidRootPart.Position + Vector3.new(0, 2, 0))
            local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end

function StopAutoRaid()
    raidActive = false
    print("[BloxFruit] 🔴 Auto Raid PARADO")
end

-- ==========================================
-- 6. CONTROLES (Teclado)
-- ==========================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- F8 para Toggle Auto Farm
    if input.KeyCode == Enum.KeyCode.F8 then
        if isFarming then
            StopAutoFarm()
        else
            StartAutoFarm()
        end
    end
    
    -- F9 para Toggle Auto Raid
    if input.KeyCode == Enum.KeyCode.F9 then
        if raidActive then
            StopAutoRaid()
        else
            StartAutoRaid()
        end
    end
    
    -- F10 para Teleportar para a ilha configurada
    if input.KeyCode == Enum.KeyCode.F10 then
        TeleportToIsland(Settings.IslandTeleport)
    end
end)

print("[BloxFruit] Script carregado. Use F8 (Farm), F9 (Raid), F10 (TP)")
