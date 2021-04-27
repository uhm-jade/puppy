local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"
local t = import "t"

local ParticleEmitter = Puppy.Component:extend("ParticleEmitter")

ParticleEmitter.validate = t.strictInterface({
	emitMap = t.map(t.string, t.table),
	startedEmitting = t.boolean,
})

function ParticleEmitter:init()
	self.emitMap = {}
	self.startedEmitting = false

	return self
end

return ParticleEmitter
