-- UIView

View = {
	Constraints = {
		X = 1,
		Y = 1,
		Width = 51,
		Height = 19,
	},
	X = 1,
	Y = 1,
	Width = 51,
	Height = 19,
	BackgroundColor = "lightGray",
	Children = {},
	Parent = nil,
	Type = "View",
	canDraw = false,
}

View.__index = View

View.New = function(self, constraints, bc)
	local view = {}
	setmetatable(view, View)
	view.Constraints = constraints
	view.BackgroundColor = bc
	return view
end

View.Draw = function(self, x, y)
	assert(self.canDraw == true, "Attempt to draw object without constraints")
	Draw:FillRect(self.X+x-1, self.Y+y-1, self.Width, self.Height, self.BackgroundColor)
	for _, uiObject in pairs(self.Children) do
		uiObject:Draw(self.X+x-1, self.Y+y-1)
	end
end

View.Add = function(self, obj)
	table.insert(self.Children, obj)
	Constrain(self, obj)
	obj.Parent = self
end

