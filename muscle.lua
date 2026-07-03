-- Muscle Legends Mobile Helper
-- Versión original y segura para móvil en Delta.
-- Solo añade una interfaz táctil y ayuda visual, sin automatizar el juego.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer

local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function makeButton(parent, text, y, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 34)
    button.Position = UDim2.new(0, 10, 0, y)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Parent = parent
    button.MouseButton1Click:Connect(callback)
    return button
end

local function createOverlay()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MuscleMobileHelper"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 230, 0, 170)
    frame.Position = UDim2.new(0.02, 0, 0.18, 0)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 26)
    title.Position = UDim2.new(0, 10, 0, 8)
    title.Text = "Muscle Helper"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = frame

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 0, 54)
    infoLabel.Position = UDim2.new(0, 10, 0, 40)
    infoLabel.Text = "Esperando personaje..."
    infoLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 13
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
    infoLabel.Parent = frame

    local function updateInfo()
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")

        if humanoid and root then
            infoLabel.Text = string.format(
                "HP: %d\nPos: %.1f, %.1f, %.1f",
                math.floor(humanoid.Health),
                root.Position.X,
                root.Position.Y,
                root.Position.Z
            )
        else
            infoLabel.Text = "Esperando personaje..."
        end
    end

    makeButton(frame, "Marca de posición", 100, function()
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root then
            local marker = Instance.new("Part")
            marker.Size = Vector3.new(2, 0.2, 2)
            marker.Position = root.Position
            marker.Anchored = true
            marker.CanCollide = false
            marker.Material = Enum.Material.Neon
            marker.Color = Color3.fromRGB(255, 190, 60)
            marker.Transparency = 0.5
            marker.Parent = workspace
            Debris:AddItem(marker, 2.5)
        end
    end)

    makeButton(frame, "Actualizar info", 138, function()
        updateInfo()
    end)

    RunService.RenderStepped:Connect(function()
        updateInfo()
    end)
end

if isMobile() then
    createOverlay()
else
    print("Abre este script desde móvil para ver la interfaz.")
end
