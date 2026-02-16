local CatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/realcath/lab/refs/heads/main/libary/catliby"))()

local window = CatLib:CreateWindow({
    Title = "kryzen hub",
    Subtitle = "u.i By zerozxk",
    Icon = "rbxassetid://121339025686432",
    Size = UDim2.new(0, 500, 0, 300),
    Theme = "Stormx",
    ColorfulLetters = true,
    FloatingButton = {
        Enabled = true,
        Icon = "rbxassetid://",
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0, 20, 0, 100),
        Shape = "square"
    }
})

local tab = window:CreateTab({
	Name = "Main",
	Title = "Main",
	Subtitle = "Main features",
	Icon = "rbxassetid://89029993998703"
})

tab:AddSection("start")

window:Notify({
	Title = "Welcome!",
	Text = "cavalo loaded successfully",
	Duration = 5
})
--========================
-- TELEPORT TAB (COM TRAVEL)
--=d=======================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ÍCONE DA ABA
local ICON = "rbxassetid://8678122759"

-- DESTINOS SEA 3
local locais = {
    ["Porto"] = CFrame.new(-439, 21, 5424),
    ["Hydra"] = CFrame.new(5292, 1005, 395),
    ["Great Tree"] = CFrame.new(3213, 2252, -7275),
    ["Tartaruga"] = CFrame.new(-12552, 337, -7558),
    ["Castelo do Mar"] = CFrame.new(-5106, 315, -2970),
    ["Castelo Assombrado"] = CFrame.new(-9511, 142, 5542),
    ["Ilha do Sorvete"] = CFrame.new(-869, 66, -10911),
    ["Ilha do Amendoim"] = CFrame.new(-2203, 141, -10537),
    ["Ilha do Bolo"] = CFrame.new(-1865, 40, -11814),
    ["Ilha do Cacau"] = CFrame.new(217, 127, -12599),
    ["Polo Norte"] = CFrame.new(-1093, 64, -14520),
    ["Tiki"] = CFrame.new(-16896, 37, 382),
    ["Dragon Dojo"] = CFrame.new(5703, 1207, 867)
}

--========================
-- VARIÁVEIS
--========================
local ativo = false
local destino = nil
local velocidade = 295

local function char()
    return player.Character or player.CharacterAdded:Wait()
end

local function noclip(state)
    for _, v in ipairs(char():GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state
        end
    end
end

-- AUTO TRAVEL LOOP
RunService.Heartbeat:Connect(function()
    if not ativo or not destino then return end

    local root = char():FindFirstChild("HumanoidRootPart")
    if not root then return end

    noclip(true)

    local dir = destino.Position - root.Position
    if dir.Magnitude < 6 then
        ativo = false
        noclip(false)
        root.Velocity = Vector3.zero
        return
    end

    root.Velocity = dir.Unit * velocidade
end)
--========================
-- TELEPORT UI (CATLIB)
--========================

local teleportTab = window:CreateTab({
	Name = "Teleport",
	Title = "Teleport",
	Subtitle = "Auto Travel",
	Icon = ICON
})

teleportTab:AddSection("Auto Travel")

-- lista de nomes
local nomes = {}
for nome in pairs(locais) do
	table.insert(nomes, nome)
end

-- dropdown
teleportTab:AddDropdown({
	Name = "Destino",
	Options = nomes,
	Default = nomes[1],
	Callback = function(nomeSelecionado)
		destino = locais[nomeSelecionado]
	end
})
local ligado = false

teleportTab:AddButton({
	Name = "Auto Travel: OFF",
	Callback = function(btn)
		ligado = not ligado
		ativo = ligado

		btn:SetText("Auto Travel: " .. (ligado and "ON" or "OFF"))

		if not ligado then
			local root = char():FindFirstChild("HumanoidRootPart")
			if root then root.Velocity = Vector3.zero end
			noclip(false)
		end
	end
})
--========================
-- FAST AUTO CLICK (estilo fast attack)
--========================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local player = game.Players.LocalPlayer

-- remotes do blox fruits
local Modules = ReplicatedStorage:WaitForChild("Modules")
local RegisterAttack = Modules.Net:WaitForChild("RE/RegisterAttack")
local RegisterHit = Modules.Net:WaitForChild("RE/RegisterHit")

local function getEnemies()
    local list = {}
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return list end

    local pos = char.HumanoidRootPart.Position

    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        local hum = enemy:FindFirstChild("Humanoid")
        local hrp = enemy:FindFirstChild("HumanoidRootPart")

        if hum and hrp and hum.Health > 0 then
            if (hrp.Position - pos).Magnitude <= 60 then
                table.insert(list, enemy)
            end
        end
    end

    return list
end

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = player.Character
            if not char then return end

            local tool = char:FindFirstChildOfClass("Tool")
            if not tool then return end

            local enemies = getEnemies()
            if #enemies == 0 then return end

            for _, enemy in pairs(enemies) do
                local target = enemy:FindFirstChild("HumanoidRootPart")
                if target then
                    RegisterAttack:FireServer(0)
                    RegisterHit:FireServer(target, {{enemy, target}})
                end
            end
        end)
    end
end)

-- anti afk extra
player.Idled:Connect(function()
    VirtualUser:CaptureController()
end)
