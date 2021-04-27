local Entity = {}

local assignedGlobalId = 1

local function newComponentsFromBlueprint(parentEntity, resourceBlueprint)
	local components = {}

	for componentClass, data in pairs(resourceBlueprint) do
		local newComponent = componentClass.new(parentEntity, data)
		newComponent:onCreate()

		table.insert(components, newComponent)
	end

	return components
end

function Entity.new(resourceBlueprint)
	local blueprintType = typeof(resourceBlueprint)
	assert(blueprintType == "table", "Failed to create entity, bad resource blueprint: "..blueprintType.. " (expected table)")

	local this = {}
	this.id = tostring(assignedGlobalId)
	this.components = newComponentsFromBlueprint(this, resourceBlueprint)

	-- lazily populated table
	this._componentByType = {}

	this.resourceBlueprint = resourceBlueprint

	-- lifetime
	this._isDestroyed = false

	assignedGlobalId += 1
	return this
end

return Entity
