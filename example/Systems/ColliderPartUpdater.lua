local import = require(game.ReplicatedStorage.Lib.Import)

local CollectionService = game:GetService("CollectionService")

local Puppy = import "Puppy"

local ColliderPartUpdater = Puppy.System:extend("ColliderPartUpdater")

local function createColliderPart(component)
	local part = Instance.new("Part")
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth

	part.Anchored = component.anchored
	part.CanCollide = component.canCollide

	if component.physicalProps then
		part.CustomPhysicalProperties = component.physicalProps
	end

	if component.tag then
		CollectionService:AddTag(part, component.tag)
	end

	part.Shape = component.shape
	part.Size = component.size
	part.Transparency = component.transparency
	part.Name = "Collider:"..component.id
	part.Parent = component.parent

	if component.serverOwned and (not component.anchored) then
		part:SetNetworkOwner(nil)
	end

	return part
end

function ColliderPartUpdater:update()
	for _, collider in ipairs(self:getComponents("Collider")) do
		if not collider.instance then
			collider.instance = createColliderPart(collider)
		end

		if collider.worldCFrame then
			if collider.lastCFrame ~= collider.worldCFrame then
				collider.instance.CFrame = collider.worldCFrame
				collider.lastCFrame = collider.worldCFrame
			end
		else
			local transform = collider:sibling("Transform")
			if transform then
				local cf = transform.cframe * collider.offset
				if collider.lastCFrame ~= cf then
					collider.instance.CFrame = cf
					collider.lastCFrame = cf
				end
			end
		end
	end
end

return ColliderPartUpdater
