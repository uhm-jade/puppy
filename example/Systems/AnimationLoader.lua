local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"

local AnimationLoader = Puppy.System:extend("AnimationLoader")

function AnimationLoader:update()
	for _, animator in ipairs(self:getComponents("Animator")) do
		if not animator.hasLoaded and animator:sibling("Model") then
			local model = animator:sibling("Model")

			if model.instance then
				local animatableInstance = model.instance:FindFirstChild("AnimationController") or model.instance:FindFirstChild("Humanoid")

				if animatableInstance then
					for name, animation in pairs(animator.animations) do
						animator.tracks[name] = animatableInstance:LoadAnimation(animation)
						animation.Parent = animatableInstance
					end

					animator.hasLoaded = true
				end
			end
		end
	end
end

return AnimationLoader
