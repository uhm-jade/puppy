local import = require(game.ReplicatedStorage.Lib.Import)

local CollectionService = game:GetService("CollectionService")

local Puppy = import "Puppy"

local ColliderTouchedEvents = Puppy.System:extend("ColliderTouchedEvents")

function ColliderTouchedEvents:update()
	for _, collider in ipairs(self:getComponents("Collider")) do
		if collider.touchEnabled and collider.instance then
			if not collider.touchedConnection then
				collider.touchedConnection = collider.instance.Touched:Connect(function(hit)
					if collider.filterTouchedByTag then
						if CollectionService:HasTag(hit, collider.filterTouchedByTag) then
							table.insert(collider.touchedThisFrame, hit)
						end
					else
						table.insert(collider.touchedThisFrame, hit)
					end
				end)
			end

			collider.touchedThisFrame = {}
		end
	end
end

return ColliderTouchedEvents
