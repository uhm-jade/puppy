local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"
local Promise = import "Promise"

local ParticleSystem = Puppy.System:extend("ParticleSystem")

function ParticleSystem:update()
	for _, particleEmitter in ipairs(self:getComponents("ParticleEmitter")) do
		local model = particleEmitter:sibling("Model")

		if (model and model.instance) and (not particleEmitter.startedEmitting) then
			particleEmitter.startedEmitting = true

			local emitMap = particleEmitter.emitMap

			for _, child in ipairs(model.instance:GetDescendants()) do
				if child:IsA("ParticleEmitter") and emitMap[child.Name] then
					local info = emitMap[child.Name]
					if info.props then
						for k, v in pairs(info.props) do
							child[k] = v
						end
					end

					if info.delay then
						Promise.delay(info.delay):andThen(function()
							child:Emit(info.count)
						end)
					else
						child:Emit(info.count)
					end
				end
			end
		end
	end
end

return ParticleSystem
