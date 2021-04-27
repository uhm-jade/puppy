local import = require(game.ReplicatedStorage.Lib.Import)

local Puppy = import "Puppy"

local CameraUpdater = Puppy.System:extend("CameraUpdater")

function CameraUpdater:update()
	for _, camera in ipairs(self:getComponents("Camera")) do
		local transform = camera:sibling("Transform")
		if not transform then
			continue
		end

		-- Set current camera to any camera claiming to be the current one, but is currently not.
		if camera.isCurrentCamera and not camera._wasSetToCurrentCamera then
			camera._wasSetToCurrentCamera = true

			-- Toggle off other cameras claiming to be the current one
			for _, otherCamera in ipairs(self:getComponents("Camera")) do
				if otherCamera ~= camera then
					otherCamera.isCurrentCamera = false
					otherCamera._wasSetToCurrentCamera = false
				end
			end
		end

		-- Update CFrame
		local currentCamera = workspace.CurrentCamera
		currentCamera.CFrame = transform.cframe
		currentCamera.Focus = camera.focus
		currentCamera.FieldOfView = camera.fov
		currentCamera.CameraType = camera.cameraType
	end
end

return CameraUpdater
