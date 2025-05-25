-- В ServerScriptService создайте Script
local function createWireframe(part)
	-- Делаем объект чёрным, НЕ прозрачным
	part.Transparency = 0 -- полностью непрозрачный
	part.BrickColor = BrickColor.new("Really black") -- чёрный цвет
	part.Material = Enum.Material.Plastic -- или ForceField для более глубокого чёрного

	-- Добавляем фиолетовую обводку
	local selectionBox = Instance.new("SelectionBox")
	selectionBox.Adornee = part
	selectionBox.Color3 = Color3.fromRGB(138, 43, 226) -- фиолетовый
	selectionBox.LineThickness = 0.15 -- толщина линий обводки
	selectionBox.Transparency = 0 -- непрозрачная обводка
	selectionBox.Parent = part
end


-- ИЛИ применить ко всем объектам
for _, obj in pairs(workspace:GetDescendants()) do
	if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
		createWireframe(obj)
	end
end
