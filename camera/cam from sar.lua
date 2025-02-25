--[[
2.5D камера и управление для Super Animal Royale в Roblox
--]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera
local transparencyObjects = {} -- Храним изменённые объекты

-- Настраиваем камеру сверху
camera.CameraType = Enum.CameraType.Scriptable
local function updateCamera()
    if character then
        local charPos = character.PrimaryPart.Position
        camera.CFrame = CFrame.new(charPos + Vector3.new(0, 50, 20), charPos)
        
        -- Восстанавливаем прозрачность старых объектов
        for obj, originalTransparency in pairs(transparencyObjects) do
            if obj and obj:IsA("BasePart") then
                obj.Transparency = originalTransparency
            end
        end
        transparencyObjects = {}
        
        -- Проверяем объекты между камерой и персонажем
        local direction = (charPos - camera.CFrame.Position).unit
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {character}
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        local rayResult = workspace:Raycast(camera.CFrame.Position, direction * 50, rayParams)
        
        -- Делаем найденные объекты прозрачными
        while rayResult do
            local part = rayResult.Instance
            if part and part:IsA("BasePart") then
                transparencyObjects[part] = part.Transparency
                part.Transparency = 0.5
            end
            rayResult = workspace:Raycast(rayResult.Position + direction * 0.1, direction * 50, rayParams) -- Продолжаем проверку
        end
    end
end

game:GetService("RunService").RenderStepped:Connect(updateCamera)

-- Управление персонажем
local UIS = game:GetService("UserInputService")
local moveDir = Vector3.new(0, 0, 0)

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        moveDir = Vector3.new(0, 0, -1)
    elseif input.KeyCode == Enum.KeyCode.S then
        moveDir = Vector3.new(0, 0, 1)
    elseif input.KeyCode == Enum.KeyCode.A then
        moveDir = Vector3.new(-1, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.D then
        moveDir = Vector3.new(1, 0, 0)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
        moveDir = Vector3.new(0, 0, 0)
    end
end)

-- Двигаем персонажа
local function moveCharacter()
    if character and humanoid then
        humanoid:Move(moveDir, true)
    end
end

game:GetService("RunService").Heartbeat:Connect(moveCharacter)

-- Поворот персонажа в сторону курсора
local mouse = player:GetMouse()
local function rotateCharacter()
    if character and character.PrimaryPart then
        local charPos = character.PrimaryPart.Position
        local mousePos = Vector3.new(mouse.Hit.p.X, charPos.Y, mouse.Hit.p.Z)
        character:SetPrimaryPartCFrame(CFrame.lookAt(charPos, mousePos))
    end
end

game:GetService("RunService").RenderStepped:Connect(rotateCharacter)
