-- ====================================================================
-- SCRIPT PREMIUM PARA DELTA EXECUTOR (BLACK & WHITE EDITION)
-- Funciones: Aimbot, Silent Aim, ESP Completo y Auto-Equip (MM2/Duelos)
-- ====================================================================

local Library = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Configuración del Menú de Juego
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaPremiumMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreInterface") or LocalPlayer:WaitForChild("PlayerGui")

-- Variables de Estado (Funciones apagadas por defecto)
local Config = {
    Aimbot = false,
    SilentAim = false,
    TargetPart = "Head", -- Cabesa
    ESP_Lines = false,
    ESP_Names = false,
    ESP_Colors = true,
    AutoEquipGun = false,
    AutoKnifeBug = false
}

-- Colores del Menú (Aesthetic Blanco y Negro)
local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    TopBar = Color3.fromRGB(0, 0, 0),
    Tabs = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(240, 240, 240)
}

-- Crear Base del Menú Principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 300)
MainFrame.Position = UDim2.new(0.5, -210, 0.4, -150)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

-- Barra de Título
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Theme.TopBar
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "DELTA EXECUTOR HUB v2.0 [B&W]"
Title.TextColor3 = Theme.Accent
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

-- Contenedor de Secciones (Botones Izquierda)
local Navigation = Instance.new("Frame")
Navigation.Size = UDim2.new(0, 120, 1, -40)
Navigation.Position = UDim2.new(0, 0, 0, 40)
Navigation.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Navigation.BorderSizePixel = 0
Navigation.Parent = MainFrame

-- Contenedor de Opciones (Contenido Derecha)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -130, 1, -50)
ContentFrame.Position = UDim2.new(0, 125, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Listas de UI para Organizar todo automáticamente
local NavLayout = Instance.new("UIListLayout")
NavLayout.Padding = UDim.new(0, 5)
NavLayout.Parent = Navigation

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.Parent = ContentFrame

-- ====================================================================
-- SISTEMA DE PESTAÑAS (Muestra opciones específicas al darle click)
-- ====================================================================
local Sections = {Aimbot = {}, ESP = {}, Armas = {}}

local function CreateTabButton(name)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Theme.Tabs
    Btn.Text = name:upper()
    Btn.TextColor3 = Theme.Text
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 14
    Btn.BorderSizePixel = 0
    Btn.Parent = Navigation
    return Btn
end

local TabAimbot = CreateTabButton("Aimbot")
local TabESP = CreateTabButton("ESP")
local TabArmas = CreateTabButton("Pistolas / Auto")

-- Sistema para cambiar entre menús del video
local function ClearContent()
    for _, child in pairs(ContentFrame:GetChildren()) do
        if child:IsA("Frame") then child.Visible = false end
    end
end

-- ====================================================================
-- CREACIÓN DE FUNCIONES E INTERRUPTORES (Toggles)
-- ====================================================================
local function CreateToggle(name, configKey, parentSection)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 30)
    Frame.BackgroundTransparency = 1
    Frame.Visible = false
    Frame.Parent = ContentFrame
    
    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(0.7, 0, 1, 0)
    Text.Text = name
    Text.TextColor3 = Theme.Text
    Text.Font = Enum.Font.SourceSans
    Text.TextSize = 15
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.BackgroundTransparency = 1
    Text.Parent = Frame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 45, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -50, 0, 4)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleBtn.Text = "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    ToggleBtn.Font = Enum.Font.SourceSansBold
    ToggleBtn.TextSize = 12
    ToggleBtn.Parent = Frame
    
    local CornerToggle = Instance.new("UICorner")
    CornerToggle.CornerRadius = UDim.new(0, 4)
    CornerToggle.Parent = ToggleBtn
    
    ToggleBtn.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        if Config[configKey] then
            ToggleBtn.BackgroundColor3 = Theme.Accent
            ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            ToggleBtn.Text = "ON"
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
            ToggleBtn.Text = "OFF"
        end
    end)
    
    table.insert(parentSection, Frame)
end

-- Asignar los elementos visuales a sus respectivas pestañas del video
CreateToggle("Activar Aimbot de Cámara", "Aimbot", Sections.Aimbot)
CreateToggle("Silent Aim (Tiros Directos)", "SilentAim", Sections.Aimbot)

CreateToggle("ESP Lineas de Rastreo", "ESP_Lines", Sections.ESP)
CreateToggle("ESP Mostrar Nombres", "ESP_Names", Sections.ESP)
CreateToggle("ESP Color por Roles (MM2)", "ESP_Colors", Sections.ESP)

CreateToggle("Equipar Pistola Automático", "AutoEquipGun", Sections.Armas)
CreateToggle("Auto Cuchillo Bug / Kill", "AutoKnifeBug", Sections.Armas)

-- Lógica para cambiar de ventana al clickear
TabAimbot.MouseButton1Click:Connect(function()
    ClearContent()
    for _, f in pairs(Sections.Aimbot) do f.Visible = true end
end)

TabESP.MouseButton1Click:Connect(function()
    ClearContent()
    for _, f in pairs(Sections.ESP) do f.Visible = true end
end)

TabArmas.MouseButton1Click:Connect(function()
    ClearContent()
    for _, f in pairs(Sections.Armas) do f.Visible = true end
end)

-- Mostrar la pestaña de Aimbot primero de manera predeterminada
for _, f in pairs(Sections.Aimbot) do f.Visible = true end

-- ====================================================================
-- LOGICA INTERNA LUA (Mecánicas de Juego detrás de los botones)
-- ====================================================================

-- Buscar el objetivo más cercano a la mira
local function GetClosestPlayer()
    local Target = nil
    local ShortestDistance = math.huge
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(Config.TargetPart) and v.Character:FindFirstChild("HumanoidRootPart") then
            if v.Character.Humanoid.Health > 0 then
                local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character[Config.TargetPart].Position)
                if OnScreen then
                    local Dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Pos.X, Pos.Y)).Magnitude
                    if Dist < ShortestDistance then
                        Target = v
                        ShortestDistance = Dist
                    end
                end
            end
        end
    end
    return Target
end

-- Bucle del Aimbot de Cámara y Silent Aim
game:GetService("RunService").RenderStepped:Connect(function()
    if Config.Aimbot then
        local Target = GetClosestPlayer()
        if Target and Target.Character then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character[Config.TargetPart].Position)
        end
    end
end)

-- Lógica de Silent Aim modificando los disparos reales
local Hook; Hook = hookmetamethod(game, "__index", function(Self, Key)
    if Config.SilentAim and tostring(Self) == "Mouse" and Key == "Hit" then
        local Target = GetClosestPlayer()
        if Target and Target.Character then
            return Target.Character[Config.TargetPart].CFrame
        end
    end
    return Hook(Self, Key)
end)

-- Sistema Visual ESP (Líneas y Nombres)
local function CreateESP(Player)
    local Line = Drawing.new("Line")
    Line.Visible = false
    Line.Thickness = 1
    
    local Text = Drawing.new("Text")
    Text.Visible = false
    Text.Size = 14
    Text.Center = true
    Text.Outline = true

    game:GetService("RunService").RenderStepped:Connect(function()
        if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.Humanoid.Health > 0 then
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)
            
            if OnScreen then
                -- Definir Colores (Blanco puro por defecto, o dinámicos para MM2)
                local EspColor = Color3.fromRGB(255, 255, 255)
                if Config.ESP_Colors and Player.Backpack:FindFirstChild("Gun") or Player.Character:FindFirstChild("Gun") then
                    EspColor = Color3.fromRGB(0, 0, 255) -- Azul para Sheriff / Pistola
