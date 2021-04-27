local import = require(game.ReplicatedStorage.Lib.Import)

local Workspace = game:GetService("Workspace")

local Puppy = import "Puppy"
local t = import "t"

--[[
	similar to Model component, but welds to a sibling Collider instead
]]
local WeldedModel = Puppy.Component:extend("WeldedModel")

WeldedModel.validate = t.strictInterface({
	path = t.string,
	instance = t.optional(t.Instance),
	parent = t.optional(t.Instance),
})

function WeldedModel:init()
	self.path = ""
	self.instance = nil

	self.parent = Workspace

	return self
end

function WeldedModel:destroy()
	if self.instance ~= nil then
		self.instance:Destroy()
	end
end

return WeldedModel
