local Component = require(script.Parent.Component)
local Cryo = require(script.Parent.lib.Cryo)

local WorldHelper = {}

function WorldHelper.addComponents(world, entity, componentsDict)
	-- Warn attempts to add components that the entity already has
	for componentClass, _ in pairs(componentsDict) do
		if WorldHelper.entityHasComponent(entity, componentClass.componentType) then
			warn("Cannot add component of type "..componentClass.componentType..": Already exists!")

			componentsDict = Cryo.Dictionary.join(componentsDict, {
				[componentClass] = Cryo.None,
			})
		end
	end

	-- Create the new components
	local newComponents = Component._componentsFromBlueprint(entity, componentsDict)

	-- Add new components to entity
	entity.components = Cryo.List.join(entity.components, newComponents)

	-- Invalidate sibling cache
	entity._componentByType = {}

	-- Insert into world
	WorldHelper.insertComponentsIntoWorld(world, newComponents)

	return newComponents
end

function WorldHelper.getComponent(entity, componentType)
	for idx, component in ipairs(entity.components) do
		if component.componentType == componentType then
			return component, idx
		end
	end
	return nil
end

function WorldHelper.entityHasComponent(entity, componentType)
	for _, v in ipairs(entity.components) do
		if v.componentType == componentType then
			return true
		end
	end

	return false
end

function WorldHelper.insertEntityIntoWorld(world, entity)
	WorldHelper.insertComponentsIntoWorld(world, entity.components)

	world.entities[entity.id] = entity
end

function WorldHelper.insertComponentsIntoWorld(world, componentsList)
	world.components = Cryo.List.join(world.components, componentsList)

	for _, component in ipairs(componentsList) do
		-- Invalidate lookup table
		world.componentLookup:invalidate(component.componentType)
	end
end

function WorldHelper.destroyEntity(world, entity)
	-- Remove components belonging to entity from world
	world.components = Cryo.List.filter(world.components, function(value)
		if value._parentEntity ~= entity then
			return true
		end
	end)

	-- Properly destroy components of entity
	for _, component in ipairs(entity.components) do
		if component.destroy ~= nil then
			component:destroy()
		end

		-- Invalidate lookup table
		world.componentLookup:invalidate(component.componentType)
	end
	entity.components = nil

	-- Finally, remove entity from entities dictionary
	world.entities[entity.id] = nil
end

function WorldHelper.removeComponent(world, entity, componentType)
	if type(componentType) == "table" then
		-- assume argument is a component class
		componentType = componentType.componentType
	end

	assert(type(componentType) == "string")

	local component, idx = WorldHelper.getComponent(entity, componentType)
	if not component then
		warn("Failed to remove component '"..componentType.."' from entity: ", entity)
		return
	end

	-- Remove component from entity
	table.remove(entity.components, idx)

	-- Remove component from world
	world.components = Cryo.List.filter(world.components, function(value)
		return value.id ~= component.id
	end)

	-- Destroy the component itself
	if component.destroy ~= nil then
		component:destroy()
	end

	-- Invalidate lookup table
	world.componentLookup:invalidate(component.componentType)

	-- Invalidate entity's sibling cache
	entity._componentByType = {}
end

return WorldHelper
