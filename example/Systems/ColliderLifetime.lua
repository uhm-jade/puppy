local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"

local ColliderLifetime = Puppy.System:extend("ColliderLifetime")

function ColliderLifetime:update()
	for _, boundLifetime in ipairs(self:getComponents("ColliderBoundLifetime")) do
		local collider = boundLifetime:sibling("Collider")
		if not collider then
			warn("ColliderBoundLifetime needs a sibling Collider to work!")
		end

		if collider.instance then
			if not collider.instance:IsDescendantOf(game) then
				local entityId = boundLifetime:getParent().id
				self.world:destroyEntity(entityId)
			end
		end
	end
end

return ColliderLifetime
