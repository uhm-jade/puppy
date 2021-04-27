local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"
local t = import "t"

local Camera = Puppy.Component:extend("Camera")

Camera.validate = t.strictInterface({
	isCurrentCamera = t.boolean,
	_wasSetToCurrentCamera = t.boolean,

	fov = t.number,
	focus = t.CFrame,
	cameraType = t.EnumItem,
})

function Camera:init()
	self.isCurrentCamera = false
	self._wasSetToCurrentCamera = false

	self.fov = 70
	self.focus = CFrame.new()
	self.cameraType = Enum.CameraType.Scriptable

	return self
end

return Camera
