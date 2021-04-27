local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"
local t = import "t"

local Name = Puppy.Component:extend("Name")

Name.validate = t.strictInterface({
	value = t.string,
})

function Name:init()
	self.value = ""

	return self
end

return Name
