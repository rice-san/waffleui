-- Button.lua

Button = {
	Constraints = {
		X = 1,
		Y = 1,
		Height = 1,
		Width = 10,
	},
	X = 1,
	Y = 1,
	Height = 1,
	Width = 10,
	TextAlign = "center",
	TextColor = "black",
	BackgroundColor = "white",
	ActiveTextColor = "white",
	ActiveBackgroundColor = "blue",
	Active = false,
	Text = " ",
	Parent = nil,
	Type = "Button",
	canDraw = false,
	Actions = {}
}

Button.New = function(self, constraints, tc, bc, atc, abc, text, align)
	local button = {}
	setmetatable(button, {__index = Button})
	button.Constraints = constraints
	button.TextColor = tc
	button.BackgroundColor = bc
	button.ActiveTextColor = atc
	button.ActiveBackgroundColor = abc
	button.Text = text
	button.TextAlign = align
	button.Actions = {}
	return button
end

Button.Draw = function(self, x, y)
	if not self.Parent then
		error("Attempt to draw "..self.Type.." without a parent", 2)
	end
	if not self.Parent.canDraw or self.Parent.Type ~= 'View' then
		error("Attempt to draw "..self.Type.." without constrained parent", 2)
	end

	local bg = self.Active and self.ActiveBackgroundColor or self.BackgroundColor
	local fg = self.Active and self.ActiveTextColor or self.TextColor

	Draw:FillRect(self.X+self.Parent.X-1, self.Y+self.Parent.Y-1, self.Width, self.Height, bg)

	local drawText = (string.len(self.Text) > self.Width) and string.sub(self.Text, 1, self.Width - 3).."..." or self.Text
	if self.TextAlign == "center" then
		Draw:DrawText(self.X+self.Parent.X+Draw:Round(self.Width/2 - string.len(drawText)/2)-1, self.Y+(self.Parent.Y-1)+Draw:Round(self.Height/2)-1, drawText, fg, bg)
	elseif self.TextAlign == "left" then
		Draw:DrawText((self.X+self.Parent.X)-1, self.Y+(self.Parent.Y-1)+Draw:Round(self.Height/2)-1, drawText, fg, bg)
	elseif self.TextAlign == "right" then
		local textlen = string.len(drawText)
		Draw:DrawText((self.X+(self.Width)+(self.Parent.X-1))-textlen, self.Y+(self.Parent.Y-1)+Draw:Round(self.Height/2)-1, drawText, fg, bg)
	end
end

Button.HandleClick = function(self, x, y, button)
	UIStatus.needsUpdate = true
	self.Active = true
	--self:Draw()
	if self.Actions.MouseClick then
		for i=1,#(self.Actions.MouseClick) do
			self.Actions.MouseClick[i](event);
		end
	end
	ActiveObject = self
end

Button.HandleMouseUp = function(self, event)
	UIStatus.needsUpdate = true
	--FIXME: Button doesn't lose active state when MouseUp is not inside.
	local wasActive = self.Active
	self.Active = false
	--self:Draw()
	if wasActive then
		if self.Actions.MouseUp then
			for i=1,#(self.Actions.MouseUp) do
				self.Actions.MouseUp[i](event);
			end
		end
	end
end

Button.HandleMouseDrag = function(self, event)
	UIStatus.needsUpdate = true
	--self:Draw()
	for i=1,#(self.Actions.MouseDrag) do
		self.Actions.MouseDrag[i](event);
	end
end
