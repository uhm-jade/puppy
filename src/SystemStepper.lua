local RunService = game:GetService("RunService")

local FIXED_UPDATE_RATE = 100 -- TODO: make this configurable

local SystemStepper = {}

function SystemStepper.start(world)
	local accumulator = 0

	RunService.Heartbeat:Connect(function(deltaTime)
		debug.profilebegin("puppyWorld_step")
		world.frameNum +=1

		SystemStepper.update(world, deltaTime)

		accumulator += deltaTime

		while accumulator >= FIXED_UPDATE_RATE do
			SystemStepper.updateFixed(world, FIXED_UPDATE_RATE)

			accumulator -= (1 / FIXED_UPDATE_RATE)
		end

		debug.profilebegin("puppyWorld_hooks")
		SystemStepper.updateHooks(world, deltaTime)
		debug.profileend()

		debug.profilebegin("puppyWorld_cleanupDestroyed")
		world:_cleanupDestroyedEntities()
		debug.profileend()

		debug.profilebegin("puppyWorld_insertCreated")
		world:_insertCreatedEntities()
		debug.profileend()
	end)

	RunService:BindToRenderStep("puppyRenderStep", Enum.RenderPriority.Camera.Value, function(deltaTime)
		SystemStepper.updateRenderStep(world, deltaTime)
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

function SystemStepper.updateRenderStep(world, deltaTime)
	for _, system in ipairs(world.systems) do
		if system.updateRenderStep then
			debug.profilebegin(system.name)
			system:updateRenderStep(deltaTime)
			debug.profileend()
		end
	end
end

function SystemStepper.updateHooks(world, deltaTime)
	for _, updateFn in ipairs(world.hooks) do
		updateFn(world, deltaTime)
	end
end

return SystemStepper
