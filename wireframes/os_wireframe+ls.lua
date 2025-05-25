local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local toggleWireframeEvent = ReplicatedStorage:WaitForChild("ToggleWireframe")

-- Переключение по клавише T
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.T then
        toggleWireframeEvent:FireServer()
    end
end)