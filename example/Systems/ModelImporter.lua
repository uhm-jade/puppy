local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"

local ModelImporter = Puppy.System:extend("ModelImporter")

function ModelImporter:update()
	for _, model in ipairs(self:getComponents("Model")) do
		if (model.instance == nil) and (model.path ~= "") then
			model.instance = import(model.path):Clone()
			model.instance.Parent = model.parent
		end
	end
end

return ModelImporter
