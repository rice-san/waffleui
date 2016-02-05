Label = {
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
	BackgroundColor = "transparent",
	Text = " ",
	Parent = nil,
	Type = "Label",
	canDraw = false,
}

Label.New = function(self, constraints, tc, bc, text, align)
	local label = {}
	setmetatable(label, {__index = Label})
	label.Constraints = constraints
	label.TextColor = tc
	label.BackgroundColor = bc
	label.Text = text
	label.TextAlign = align
	return label
end

Label.Draw = function(self, x, y)
	if not self.Parent then
		error("Attempt to draw "..self.Type.." without a parent", 2)
	end
	if not self.Parent.canDraw or self.Parent.Type ~= 'View' then
		error("Attempt to draw "..self.Type.." without constrained parent", 2)
	end
	
	Draw:FillRect(self.X+x-1, self.Y+y-1, self.Width, self.Height, self.BackgroundColor)
	
	local drawText = (string.len(self.Text) > self.Width) and string.sub(self.Text, 1, self.Width - 3).."..." or self.Text
	if self.TextAlign == "center" then
		Draw:DrawText(self.X+x+Draw:Round(self.Width/2 - string.len(drawText)/2)-1, self.Y+(y-1)+Draw:Round(self.Height/2)-1, drawText, self.TextColor, self.BackgroundColor)
	elseif self.TextAlign == "left" then
		Draw:DrawText((self.X+x)-1, self.Y+(y-1)+Draw:Round(self.Height/2)-1, drawText, self.TextColor, self.BackgroundColor)
	elseif self.TextAlign == "right" then
		local textlen = string.len(drawText)
		Draw:DrawText((self.X+(self.Width)+(x-1))-textlen, self.Y+(y-1)+Draw:Round(self.Height/2)-1, drawText, self.TextColor, self.BackgroundColor)
	end
end



