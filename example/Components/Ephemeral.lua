local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"
local t = import "t"

local Ephemeral = Puppy.Component:extend("Ephemeral")

Ephemeral.validate = t.strictInterface({
	lifetime = t.number,
	startTime = t.number,
})

function Ephemeral:init()
	self.lifetime = 10.0 -- seconds
	self.startTime = os.clock()

	return self
end

return Ephemeral
