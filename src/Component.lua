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
		local cachedSibling = this._parentEntity._componentByType[siblingComponentType]

		if cachedSibling then
			if cachedSibling == "__NONE__" then
				return nil
			else
				return cachedSibling
			end
		else
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

			return searchResult
		end
	end

	function componentClass.getParent(this)
		return this._parentEntity
	end

	return componentClass
end

return Component
