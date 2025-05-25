local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Создаём RemoteEvent для связи клиент-сервер
local toggleWireframeEvent = Instance.new("RemoteEvent")
toggleWireframeEvent.Name = "ToggleWireframe"
toggleWireframeEvent.Parent = ReplicatedStorage

local wireframeData = {}
local isWireframeActive = false

local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

local function createWireframeData(part)
	if wireframeData[part] then return end

	wireframeData[part] = {
		originalColor = part.Color,
		selectionBox = nil,
		currentlyAnimating = false
	}

	local selectionBox = Instance.new("SelectionBox")
	selectionBox.Adornee = part
	selectionBox.Color3 = Color3.fromRGB(138, 43, 226)
	selectionBox.LineThickness = 0.15
	selectionBox.Transparency = 1
	selectionBox.Parent = part

	wireframeData[part].selectionBox = selectionBox
end

local function animateWireframeOn(part)
	local data = wireframeData[part]
	if not data or data.currentlyAnimating then return end

	data.currentlyAnimating = true

	local colorTween = TweenService:Create(part, tweenInfo, {
		Color = Color3.fromRGB(0, 0, 0)
	})

	local outlineTween = TweenService:Create(data.selectionBox, tweenInfo, {
		Transparency = 0
	})

	colorTween:Play()
	outlineTween:Play()

	outlineTween.Completed:Connect(function()
		data.currentlyAnimating = false
	end)
end

local function animateWireframeOff(part)
	local data = wireframeData[part]
	if not data or data.currentlyAnimating then return end

	data.currentlyAnimating = true

	local colorTween = TweenService:Create(part, tweenInfo, {
		Color = data.originalColor
	})

	local outlineTween = TweenService:Create(data.selectionBox, tweenInfo, {
		Transparency = 1
	})

	colorTween:Play()
	outlineTween:Play()

	outlineTween.Completed:Connect(function()
		data.currentlyAnimating = false
	end)
end

local function toggleWireframe()
	isWireframeActive = not isWireframeActive

	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
			createWireframeData(obj)

			if isWireframeActive then
				animateWireframeOn(obj)
			else
				animateWireframeOff(obj)
			end
		end
	end
end

-- Слушаем сигнал от клиента
toggleWireframeEvent.OnServerEvent:Connect(function(player)
	toggleWireframe()
end)