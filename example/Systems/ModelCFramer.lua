local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"

local ModelImporter = Puppy.System:extend("ModelImporter")

function ModelImporter:update()
	for _, model in ipairs(self:getComponents("Model")) do
		if model.instance ~= nil then
			local transform = model:sibling("Transform")
			if (transform ~= nil) and (model.lastCFrame ~= transform.cframe) then
				model.instance:PivotTo(transform.cframe)
				model.lastCFrame = transform.cframe
			end
		end
	end
end

return ModelImporter
