local import = require(game.ReplicatedStorage.Lib.Import)

local Workspace = game:GetService("Workspace")

local Puppy = import "Puppy"
local t = import "t"

local Collider = Puppy.Component:extend("Collider")

Collider.validate = t.strictInterface({
	instance = t.optional(t.Instance),
	parent = t.optional(t.Instance),
	size = t.Vector3,
	offset = t.CFrame,
	shape = t.EnumItem,
	transparency = t.number,

	anchored = t.boolean,
	canCollide = t.boolean,
	physicalProps = t.optional(t.PhysicalProperties),
	serverOwned = t.boolean,

	touchEnabled = t.boolean,
	touchedThisFrame = t.array(t.Instance),
	touchedConnection = t.optional(t.RBXConnection),

	tag = t.optional(t.string),
	filterTouchedByTag = t.optional(t.string),

	worldCFrame = t.optional(t.CFrame),

	lastCFrame = t.CFrame,
})

function Collider:init()
	self.instance = nil
	self.parent = Workspace
	self.size = Vector3.new(1, 1, 1)
	self.offset = CFrame.new()
	self.shape = Enum.PartType.Block
	self.transparency = 0

	self.physicalProps = nil
	self.anchored = true
	self.canCollide = true
	self.serverOwned = false

	self.tag = nil
	self.filterTouchedByTag = nil

	self.lastCFrame = CFrame.new()

	self.touchEnabled = false
	self.touchedThisFrame = {}
	self.touchedConnection = nil

	return self
end

function Collider:destroy()
	if self.instance ~= nil then
		self.instance:Destroy()
	end
end

return Collider
