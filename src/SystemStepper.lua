local RunService = game:GetService("RunService")

local FIXED_UPDATE_RATE = 100 -- TODO: make this configurable

local SystemStepper = {}

function SystemStepper.start(world)
	local accumulator = 0

	RunService.Heartbeat:Connect(function(deltaTime)
		debug.profilebegin("puppyWorld_step")
		SystemStepper.update(world, deltaTime)

		accumulator += deltaTime

		while accumulator >= FIXED_UPDATE_RATE do
			SystemStepper.updateFixed(world, FIXED_UPDATE_RATE)

			accumulator -= (1 / FIXED_UPDATE_RATE)
		end

		debug.profilebegin("puppyWorld_cleanupDestroyed")
		world:_cleanupDestroyedEntities()
		debug.profileend()

		debug.profilebegin("puppyWorld_insertCreated")
		world:_insertCreatedEntities()
		debug.profileend()
	end)
end

function SystemStepper.update(world, deltaTime)
	for _, system in ipairs(world.systems) do
		debug.profilebegin(system.name)
		system:update(deltaTime)
		debug.profileend()
	end
end

function SystemStepper.updateFixed(world, deltaTime)
	for _, system in ipairs(world.systems) do
		debug.profilebegin(system.name)
		system:updateFixed(deltaTime)
		debug.profileend()
	end
end

return SystemStepper
