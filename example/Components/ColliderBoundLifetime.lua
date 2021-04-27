local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"
local t = import "t"

local ColliderBoundLifetime = Puppy.Component:extend("ColliderBoundLifetime")

-- ColliderBoundLifetime.validate = t.strictInterface({
-- })

function ColliderBoundLifetime:init()

	return self
end

return ColliderBoundLifetime
