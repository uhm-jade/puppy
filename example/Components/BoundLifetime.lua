local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"
local t = import "t"

local BoundLifetime = Puppy.Component:extend("BoundLifetime")

BoundLifetime.validate = t.strictInterface({
	entityId = t.string,
})

function BoundLifetime:init()
	self.entityId = nil
	return self
end

return BoundLifetime
