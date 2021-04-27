local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"

local Lifetime = Puppy.System:extend("Lifetime")

function Lifetime:update()
	for _, ephemeral in ipairs(self:getComponents("Ephemeral")) do
		if os.clock() - ephemeral.startTime > ephemeral.lifetime then
			local parentId = ephemeral:getParent().id
			self.world:destroyEntity(parentId)
		end
	end

	for _, boundLifetime in ipairs(self:getComponents("BoundLifetime")) do
		if self.world:isEntityDestroyed(boundLifetime.entityId) then
			local parentId = boundLifetime:getParent().id
			self.world:destroyEntity(parentId)
		end
	end
end

return Lifetime
