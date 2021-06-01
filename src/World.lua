local Entity = require(script.Parent.Entity)
local ComponentLookup = require(script.Parent.ComponentLookup)
local SystemStepper = require(script.Parent.SystemStepper)
local WorldHelper = require(script.Parent.WorldHelper)

local DEFERRED_CREATE = false

local World = {}
World.__index = World

function World.new(systems)
	local this = {}
	this.systems = {}
	this.components = {}
	this.entities = {}

	this.hooks = {}

	this.frameNum = 0

	this.componentLookup = ComponentLookup.new(this)
	this.createdEntitiesThisFrame = {}

	for _, systemClass in ipairs(systems) do
		local system = systemClass.new(this)
		table.insert(this.systems, system)
	end

	setmetatable(this, World)
	return this
end

function World:start()
	SystemStepper.start(self)
end

function World:hookToWorldUpdate(fn)
	table.insert(self.hooks, fn)
end

function World:getComponents(componentType)
	return self.componentLookup:getIteration(componentType)
end

function World:getComponentById(id)
	debug.profilebegin("getComponentById")
	for _, component in ipairs(self.components) do
		if component.id == id then
			return component
		end
	end
	debug.profileend()
end

function World:createEntity(resourceBlueprint)
	debug.profilebegin("createEntity")
	local newEntity = Entity.new(self, resourceBlueprint)

	if DEFERRED_CREATE then
		table.insert(self.createdEntitiesThisFrame, newEntity)
	else
		WorldHelper.insertEntityIntoWorld(self, newEntity)
	end

	debug.profileend()
	return newEntity
end

function World:addComponent(entity, componentClass, componentData)
	debug.profilebegin("addComponent")
	componentData = componentData or {}

	local newComponents = WorldHelper.addComponents(self, entity, {[componentClass] = componentData})
	debug.profileend()
	return newComponents[1]
end

function World:addComponents(entity, components)
	return WorldHelper.addComponents(self, entity, components)
end

function World:removeComponent(entity, componentClass)
	debug.profilebegin("removeCmponent")
	WorldHelper.removeComponent(self, entity, componentClass)
	debug.profileend()
end

function World:getComponent(entity, componentType)
	return WorldHelper.getComponent(entity, componentType)
end

function World:isEntityDestroyed(entityId)
	assert(type(entityId) == "string", "isEntityDestroyed expects string 'entityId'!")

	local entity = self.entities[entityId]
	if (not entity) or (entity._isDestroyed) then
		return true
	else
		return false
	end
end

function World:destroyEntity(entityId)
	local entity = self.entities[entityId]

	-- Mark entity as destroyed, deferring the operation to end of frame
	if entity ~= nil then
		entity._isDestroyed = true
	end
end

function World:_cleanupDestroyedEntities()
	for _, entity in pairs(self.entities) do
		if entity._isDestroyed then
			debug.profilebegin("destroyEntity")
			WorldHelper.destroyEntity(self, entity)
			debug.profileend()
		end
	end
end

function World:_insertCreatedEntities()
	for _, entity in pairs(self.createdEntitiesThisFrame) do
		WorldHelper.insertEntityIntoWorld(self, entity)
	end
	self.createdEntitiesThisFrame = {}
end

return World
