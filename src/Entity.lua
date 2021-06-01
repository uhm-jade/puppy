local Component = require(script.Parent.Component)

local Entity = {}
Entity.__index = Entity

local assignedGlobalId = 1

function Entity.new(world, resourceBlueprint)
	local blueprintType = typeof(resourceBlueprint)
	assert(blueprintType == "table", "Failed to create entity, bad resource blueprint: "..blueprintType.. " (expected table)")

	local this = {}
	setmetatable(this, Entity)

	this.id = tostring(assignedGlobalId)
	this.components = Component._componentsFromBlueprint(this, resourceBlueprint)
	this.world = world

	-- lazily populated table
	this._componentByType = {}

	this.resourceBlueprint = resourceBlueprint

	-- lifetime
	this._isDestroyed = false

	assignedGlobalId += 1

	return this
end

function Entity:getComponent(componentType)
	return self.world:getComponent(self, componentType)
end

function Entity:addComponent(componentClass, data)
	self.world:addComponent(self, componentClass, data)
end

function Entity:removeComponent(componentType)
	self.world:removeComponent(self, componentType)
end

function Entity:destroy()
	self.world:destroyEntity(self.id)
end

return Entity
