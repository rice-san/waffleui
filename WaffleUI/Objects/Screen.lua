-- UIScreenPort

ScreenPort = {
	X = 1,
	Y = 1,
	Width = 51,
	Height = 19,
	BackgroundColor = "lightGray",
	Children = {},
	Parent = nil,
	Type = "View",
	canDraw = true,
}

ScreenPort.New = function(self)
	local screenPort = {}
	setmetatable(screenPort, {__index = ScreenPort})
	screenPort.X = 1
	screenPort.Y = 1
	screenPort.Width, screenPort.Height = term.getSize()
	return screenPort
end

ScreenPort.Draw = function(self)
	assert(self.canDraw, "Attempt to draw object without constraints")
	for _, uiObject in pairs(self.Children) do
		uiObject:Draw(self.X, self.Y)
	end
end

ScreenPort.Add = function(self, obj)
	table.insert(self.Children, obj)
	Constrain(self, obj)
	obj.Parent = self
end


