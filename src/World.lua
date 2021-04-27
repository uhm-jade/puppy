local Entity = require(script.Parent.Entity)
local ComponentLookup = require(script.Parent.ComponentLookup)
local SystemStepper = require(script.Parent.SystemStepper)

local DEFERRED_CREATE = false

local World = {}
World.__index = World

function World.new(systems)
	local this = {}
	this.systems = {}
	this.components = {}
	this.entities = {}

	this.componentLookup = ComponentLookup.new(this.components)
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

function World:getComponents(componentType)
	return self.componentLookup:getIteration(componentType)
end

function World:createEntity(resourceBlueprint)
	local newEntity = Entity.new(resourceBlueprint)

	if DEFERRED_CREATE then
		table.insert(self.createdEntitiesThisFrame, newEntity)
	else
		self:_insertEntityIntoWorld(newEntity)
	end

	return newEntity
end

function World:_insertEntityIntoWorld(entity)
	-- Populate World.components with new entity's components
	for _, component in ipairs(entity.components) do
		table.insert(self.components, component)

		-- Invalidate lookup table
		self.componentLookup:invalidate(component.componentType)
	end

	self.entities[entity.id] = entity
end

function World:isEntityDestroyed(entityId)
	local entity = self.entities[entityId]
	if (not entity) or (entity._isDestroyed) then
		return true
	else
		return false
	end
end

function World:destroyEntity(entityId)
	local entity = self.entities[entityId]

	-- mark entity as destroyed
	if entity ~= nil then
		entity._isDestroyed = true
	end
end


function World:_destroyEntity(entity)
	-- Remove components from components list one-by-one, checking if it belongs to the entity
	for i = #self.components, 1, -1 do
		local component = self.components[i]

		if component._parentEntity == entity then
			table.remove(self.components, i)

			-- Invalidate lookup table
			self.componentLookup:invalidate(component.componentType)
		end
	end

	-- Properly destroy components of entity
	for _, component in ipairs(entity.components) do
		if component.destroy ~= nil then
			component:destroy()
		end
	end
	entity.components = nil

	-- Finally, remove entity from entities dictionary
	self.entities[entity.id] = nil
end

function World:_cleanupDestroyedEntities()
	for _, entity in pairs(self.entities) do
		if entity._isDestroyed then
			self:_destroyEntity(entity)
		end
	end
end

function World:_insertCreatedEntities()
	for _, entity in pairs(self.createdEntitiesThisFrame) do
		self:_insertEntityIntoWorld(entity)
	end
	self.createdEntitiesThisFrame = {}
end

return World
