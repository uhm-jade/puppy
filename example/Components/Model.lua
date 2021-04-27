local import = require(game.ReplicatedStorage.Lib.Import)

local Workspace = game:GetService("Workspace")

local Puppy = import "Puppy"
local t = import "t"

local Model = Puppy.Component:extend("Model")

Model.validate = t.strictInterface({
	path = t.string,
	instance = t.optional(t.Instance),
	parent = t.optional(t.Instance),
	lastCFrame = t.optional(t.CFrame),
})

function Model:init()
	self.path = ""
	self.instance = nil
	self.parent = Workspace

	self.lastCFrame = nil

	return self
end

function Model:destroy()
	if self.instance ~= nil then
		self.instance:Destroy()
	end
end

return Model
