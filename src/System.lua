local System = {}

function System:extend(systemName)
	return System._extend(systemName)
end

function System._extend(name)
	local systemClass = {}
	systemClass.name = name
	systemClass.__index = systemClass

	function systemClass.new(world)
		local this = {}
		this.name = name
		this.world = world

		setmetatable(this, systemClass)
		return this
	end

	function systemClass:getComponents(...)
		return self.world:getComponents(...)
	end

	function systemClass:update()
	end

	function systemClass:updateFixed()
	end

	return systemClass
end

return System
