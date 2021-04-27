local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"
local Weld = import "Utils/Weld"

local ModelWelder = Puppy.System:extend("ModelWelder")

local function validateAsset(asset)
	local centerPointAttachment = asset:FindFirstChild("CenterPoint", true)
	assert(centerPointAttachment, "Asset "..tostring(asset).." needs an attachment named 'CenterPoint'!")
	assert(centerPointAttachment:IsA("Attachment"), "'CenterPoint' must be an Attachment")
end

local function weldModelToCollider(collider, model, primaryPart)
	Weld.weldInPlace(collider, primaryPart)

	for _, child in pairs(model:GetChildren()) do
		child.CanCollide = false
		child.Anchored = false
		child.Massless = true

		Weld.weldInPlace(primaryPart, child)
	end
end

function ModelWelder:update()
	for _, weldedModel in ipairs(self:getComponents("WeldedModel")) do
		local collider = weldedModel:sibling("Collider")
		if not (collider and collider.instance) then
			continue
		end

		if (weldedModel.instance == nil) and (weldedModel.path ~= "") then
			local storedAsset = import(weldedModel.path)
			validateAsset(storedAsset)

			local model = storedAsset:Clone()
			model.Parent = weldedModel.parent

			local centerPointAttachment = model:FindFirstChild("CenterPoint", true)
			local primaryPart = centerPointAttachment.Parent

			model.PrimaryPart = primaryPart
			model:SetPrimaryPartCFrame(collider.instance.CFrame * centerPointAttachment.CFrame:Inverse())

			-- weld it all together
			weldModelToCollider(collider.instance, model, primaryPart)

			weldedModel.instance = model
		end
	end
end

return ModelWelder
