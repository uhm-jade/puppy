local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"

local TransformCopier = Puppy.System:extend("TransformCopier")

function TransformCopier:update()
	for _, copyTransform in ipairs(self:getComponents("CopyTransform")) do
		local copyCF do
			if copyTransform.otherTransform then
				copyCF = copyTransform.otherTransform.cframe
			elseif copyTransform.otherInstance then
				copyCF = copyTransform.otherInstance:GetPivot()
			end
		end

		if copyCF then
			local transform = copyTransform:sibling("Transform")
			if transform then
				if copyTransform.copyRotation and copyTransform.copyPosition then
					transform.cframe = copyCF
				else
					transform.cframe = (copyTransform.copyPosition and CFrame.new(copyCF.p) or CFrame.new())
					                 * (copyTransform.copyRotation and (copyCF - copyCF.p) or CFrame.new())
				end
			else
				warn("CopyTransform needs a sibling Transform component to work!")
			end
		end
	end
end

return TransformCopier
