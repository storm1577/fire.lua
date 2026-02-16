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
        Icon = "rbxassetid://121339025686432",
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0, 20, 0, 100),
        Shape = "square"
    }
})

local tab = window:CreateTab({
	Name = "Main",
	Title = "Main",
	Subtitle = "Main features",
	Icon = "rbxassetid://92602807830976"
})

tab:AddSection("start")

window:Notify({
	Title = "Welcome!",
	Text = "cavalo loaded successfully",
	Duration = 5
})
-- AUTO FARM BONES AIR

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

local farming = false
local height = 30

local function getHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end

local function getEnemies()
	local enemies = {}
	local folder = workspace:FindFirstChild("Enemies")
	if not folder then return enemies end
	
	for _, v in pairs(folder:GetChildren()) do
		if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
			table.insert(enemies, v)
		end
	end
	return enemies
end

tab:CreateToggle({
	Name = "Auto Farm Bones (Air)",
	CurrentValue = false,
	Callback = function(v)
		farming = v
		
		if v then
			task.spawn(function()
				while farming do
					pcall(function()
						local hrp = getHRP()
						
						for _, enemy in pairs(getEnemies()) do
							if not farming then break end
							
							local eHRP = enemy:FindFirstChild("HumanoidRootPart")
							if eHRP then
								-- ficar em cima
								hrp.CFrame = eHRP.CFrame + Vector3.new(0, height, 0)
								
								-- puxar inimigo pra baixo
								eHRP.CFrame = hrp.CFrame - Vector3.new(0, 5, 0)
								
								-- atacar
								VirtualUser:CaptureController()
								VirtualUser:ClickButton1(Vector2.new())
								
								task.wait(0.12)
							end
						end
					end)
					task.wait()
				end
			end)
		end
	end
})
--========================
-- SEA EVENTOS TAB (CATLIB)
--========================

local SeaTab = window:CreateTab({
	Name = "Sea Eventos",
	Title = "Sea Eventos",
	Subtitle = "Auto Boat",
	Icon = "rbxassetid://119720690487986"
})

SeaTab:AddSection("Auto Boat")

-- Zonas
local SeaZones = {
	["Mar 1"] = CFrame.new(-21998, 0, -682),
	["Mar 2"] = CFrame.new(-26647, 2, -811),
	["Mar 3"] = CFrame.new(-30740, 6, -2116),
	["Mar 4"] = CFrame.new(-33642, 0, -2506),
	["Mar 5"] = CFrame.new(-38527, 0, -2177),
	["Mar 6"] = CFrame.new(-43761, 6, -1364),
}

local speed = 120
local hoverHeight = 2
local currentMove
local selectedZone = "Mar 1"

-- Funções barco
local function getBoat()
	local char = player.Character
	if not char then return end
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("VehicleSeat") and v.Occupant and v.Occupant.Parent == char then
			return v.Parent
		end
	end
end

local function sitOnBoat()
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end

	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("VehicleSeat") and (v.Position - hrp.Position).Magnitude < 60 then
			hrp.CFrame = v.CFrame + Vector3.new(0,2,0)
			task.wait(0.2)
			v:Sit(hum)
			task.wait(0.5)
			return v.Parent
		end
	end
end

local function ensureBoat()
	return getBoat() or sitOnBoat()
end

local function setNoclip(boat, state)
	for _, part in pairs(boat:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = not state
		end
	end
end

local savedY
local function stopBoat(primary, boat)
	if currentMove then currentMove:Disconnect() end
	if primary then
		primary.CFrame = CFrame.new(primary.Position.X, savedY or primary.Position.Y, primary.Position.Z)
	end
	if boat then
		setNoclip(boat, false)
	end
end

local function startBoat()
	local zoneCFrame = SeaZones[selectedZone]
	if not zoneCFrame then return end

	local boat = ensureBoat()
	if not boat then
		warn("Barco não encontrado")
		return
	end

	if not boat.PrimaryPart then
		boat.PrimaryPart = boat:FindFirstChildWhichIsA("BasePart")
	end

	local primary = boat.PrimaryPart
	savedY = primary.Position.Y
	setNoclip(boat, true)

	pcall(function()
		primary:SetNetworkOwner(player)
	end)

	if currentMove then currentMove:Disconnect() end

	currentMove = RunService.Heartbeat:Connect(function(dt)
		if not primary or not primary.Parent then
			stopBoat(primary, boat)
			return
		end

		local pos = primary.Position
		local target = Vector3.new(zoneCFrame.X, savedY + hoverHeight, zoneCFrame.Z)
		local dir = target - pos

		if dir.Magnitude < 5 then
			stopBoat(primary, boat)
			return
		end

		local move = dir.Unit * speed * dt
		primary.CFrame = CFrame.new(pos + move, target)
	end)
end

-- Dropdown zonas
local nomes = {}
for n in pairs(SeaZones) do table.insert(nomes, n) end

SeaTab:AddDropdown({
	Name = "Zona",
	Options = nomes,
	Default = "Mar 1",
	Callback = function(opt)
		selectedZone = opt
	end
})

-- Slider velocidade
SeaTab:AddSlider({
	Name = "Velocidade",
	Min = 20,
	Max = 300,
	Default = 120,
	Callback = function(val)
		speed = val
	end
})

-- Toggle autopilot
SeaTab:AddToggle({
	Name = "Auto Boat",
	Default = false,
	Callback = function(state)
		if state then
			startBoat()
		else
			local boat = ensureBoat()
			if boat and boat.PrimaryPart then
				stopBoat(boat.PrimaryPart, boat)
			end
		end
	end
})

--========================
-- TELEPORT TAB (COM TRAVEL)
--=d=======================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ÍCONE DA ABA
local ICON = "rbxassetid://104148559102116"

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
local player = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
