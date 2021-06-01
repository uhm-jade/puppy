local ComponentLookup = {}
ComponentLookup.__index = ComponentLookup

function ComponentLookup.new(world)
	local this = {}
	this.world = world
	this.lookup = {}

	return setmetatable(this, ComponentLookup)
end

function ComponentLookup:_getNewIteration(componentType)
	local new = {}
	for _, component in ipairs(self.world.components) do
		if component.componentType == componentType then
			table.insert(new, component)
		end
	end
	return new
end

function ComponentLookup:getIteration(componentType)
	local iteration = self.lookup[componentType]
	if not iteration then
		iteration = self:_getNewIteration(componentType)
		self.lookup[componentType] = iteration
	end

	return iteration
end

function ComponentLookup:invalidate(key)
	self.lookup[key] = nil
end

return ComponentLookup
