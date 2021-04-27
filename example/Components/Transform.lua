local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"
local t = import "t"

local Transform = Puppy.Component:extend("Transform")

Transform.validate = t.strictInterface({
	cframe = t.CFrame,
})

function Transform:init()
	self.cframe = CFrame.new()
	return self
end

return Transform
