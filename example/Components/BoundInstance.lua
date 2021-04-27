local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"
local t = import "t"

local BoundInstance = Puppy.Component:extend("BoundInstance")

BoundInstance.validate = t.strictInterface({
	instance = t.optional(t.Instance),
})

function BoundInstance:init()
	self.instance = nil
	return self
end

function BoundInstance:destroy()
	if self.instance then
		self.instance:Destroy()
	end
end

return BoundInstance
