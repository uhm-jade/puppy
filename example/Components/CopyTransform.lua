local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"
local t = import "t"

local CopyTransform = Puppy.Component:extend("CopyTransform")

CopyTransform.validate = t.strictInterface({
	otherTransform = t.optional(t.table),
	otherInstance = t.optional(t.union(t.instanceIsA("BasePart"), t.instanceIsA("Model"))),
	copyRotation = t.boolean,
	copyPosition = t.boolean,
})

function CopyTransform:init()
	self.otherTransform = nil
	self.otherInstance = nil
	self.copyRotation = true
	self.copyPosition = true
	return self
end

return CopyTransform
