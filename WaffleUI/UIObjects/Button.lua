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
	return button
end

Button.Draw = function(self, x, y)
	if not self.Parent then
		error("Attempt to draw "..self.Type.." without a parent", 2)
	end
	if not self.Parent.canDraw or self.Parent.Type ~= 'View' then
		error("Attempt to draw "..self.Type.." without constrained parent", 2)
	end
	
	local bg = self.ActiveBackgroundColor and self.Active or self.BackgroundColor
	local fg = self.ActiveTextColor and self.Active or self.TextColor
	
	Draw:FillRect(self.X+x-1, self.Y+y-1, self.Width, self.Height, bg)
	
	local drawText = (string.len(self.Text) > self.Width) and string.sub(self.Text, 1, self.Width - 3).."..." or self.Text
	if self.TextAlign == "center" then
		Draw:DrawText(self.X+x+Draw:Round(self.Width/2 - string.len(drawText)/2)-1, self.Y+(y-1)+Draw:Round(self.Height/2)-1, drawText, fg, bg)
	elseif self.TextAlign == "left" then
		Draw:DrawText((self.X+x)-1, self.Y+(y-1)+Draw:Round(self.Height/2)-1, drawText, fg, bg)
	elseif self.TextAlign == "right" then
		local textlen = string.len(drawText)
		Draw:DrawText((self.X+(self.Width)+(x-1))-textlen, self.Y+(y-1)+Draw:Round(self.Height/2)-1, drawText, fg, bg)
	end
end

Button.OnClick = function(self, event)
	self.Active = true
	self.Draw()
	for k,v in pairs(self.Actions.MouseClick) do
		v(event);
	end
end

Button.MouseUp = function(self, event)
	local wasActive = self.Active
	self.Active = false
	self.Draw()
	if wasActive then
		for k,v in pairs(self.Actions.MouseUp) do
			v(event);
		end
	end
end

Button.MouseDrag = function(self, event)
	self.Draw()
	for k,v in pairs(self.Actions.MouseDrag) do
		v(event);
	end
end
