local Component = {}

local assignedGlobalId = 1

function Component:extend(componentType: string)
	local componentClass = {}
	componentClass.__index = componentClass
	componentClass.componentType = componentType

	function componentClass.new(parentEntity, data)
		local this = {}
		componentClass.init(this)

		for key, value in pairs(data) do
			this[key] = value
		end

		if componentClass.validate then
			local passed, msg = componentClass.validate(this)
			assert(passed, componentType..": "..(msg or ""))
		end

		this.id = tostring(assignedGlobalId)
		this.componentType = componentType

		this._parentEntity = parentEntity

		setmetatable(this, componentClass)
		assignedGlobalId += 1
		return this
	end

	function componentClass.onCreate()
	end

	-- move these to utils
	function componentClass.sibling(this, siblingComponentType)
		debug.profilebegin("sibling")
		local cachedSibling = this._parentEntity._componentByType[siblingComponentType]

		if cachedSibling then
			if cachedSibling == "__NONE__" then
				debug.profileend()
				return nil
			else
				debug.profileend()
				return cachedSibling
			end
		else
			debug.profilebegin("lookupSibling")
			local searchResult

			for _, sibling in pairs(this._parentEntity.components) do
				if sibling.componentType == siblingComponentType then
					searchResult = sibling
					break
				end
			end

			if searchResult then
				this._parentEntity._componentByType[siblingComponentType] = searchResult
			else
				this._parentEntity._componentByType[siblingComponentType] = "__NONE__"
			end

			debug.profileend()
			debug.profileend()
			return searchResult
		end
	end

	function componentClass.getParent(this)
		return this._parentEntity
	end

	return componentClass
end

function Component._componentsFromBlueprint(parentEntity, blueprint)
	local components = {}

	for componentClass, data in pairs(blueprint) do
		assert(type(componentClass) == "table", "Blueprint key must be a component class! (got "..typeof(componentClass)..")")
		assert(componentClass.componentType ~= nil, "Blueprint key must be a component class!"..tostring(componentClass))

		local newComponent = componentClass.new(parentEntity, data)
		newComponent:onCreate()

		table.insert(components, newComponent)
	end

	return components
end

return Component
