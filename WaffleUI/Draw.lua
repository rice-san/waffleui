-- Draw.lua

-- BIG TODO: Change the way the API interprets color input.

os.loadAPI("/rom/apis/colors")
Draw = {}

Draw.SetFGColor = function(self, color)
	if type(color) == "number" then
		term.setTextColor(color)
	elseif type(color) == "string" then
		local thisColor = colors[color] or colours[color]
		assert(thisColor, "Attempt to set an invalid text color")
		term.setTextColor(thisColor)
	end
end

Draw.SetBGColor = function(self, color)
	if type(color) == "number" then
		term.setBackgroundColor(color)
	elseif type(color) == "string" then
		if color == "transparent" then
			term.setBackgroundColor(term.getBackgroundColor())
		else
			local thisColor = colors[color] or colours[color]
			assert(thisColor, "Attempt to set an invalid background color")
			term.setBackgroundColor(thisColor)
		end
	end
end

Draw.Display = {
	width = 51,
	height = 19
}

Draw.Display.width, Draw.Display.height = term.getSize()

Draw.DrawPoint = function(self, x, y, color)
    term.setCursorPos(x, y)
    self:SetBGColor(color)
    term.write(" ")
end

Draw.DrawHLine = function(self, x, y, length, color)
	local i
    for i=x,(x+length-1) do
        self:DrawPoint(i, y, color)
    end
end

Draw.DrawVLine = function(self, x, y, length, color)
	local i
    for i = y,(y+length-1) do
        self:DrawPoint(x, i, color)
    end
end

Draw.DrawRect = function(self, x, y, width, height, color)
	local i
	local j
    for i=1, width-1 do
        self:DrawPoint(i, y, color)
        self:DrawPoint(i, y+height-1, color)
    end
    for j=1, height do
        self:DrawPoint(x, j, color)
        self:DrawPoint(x+width-1, j, color)
    end
end

Draw.FillRect = function(self, x, y, width, height, color)
	local i
	local j
    for j=y,(y+height-1) do
        for i=x,(x+width-1) do
            self:DrawPoint(i, j, color)
        end
    end
end

Draw.DrawText = function(self, x, y, _text, fg, bg, _wrap)
	local wrapping = _wrap or false
	local text
	if not wrapping then
		text = string.sub(_text, 1, self.Display.width - x)
	end
	self:SetFGColor(fg)
	self:SetBGColor(bg)
	term.setCursorPos(x, y)
	--If we have a normal color
	if colors[bg] or colours[bg] then 
		term.write(text)
	else
		local i
		for i=1,string.len(text) do
			Draw:SetBGColor(bg)
			term.setCursorPos(x+i-1, y)
			term.write(text:sub(i, i+1))	
		end
	end
end

Draw.DrawCenterText = function(self, y, text, fg, bg)
	if string.len(text) > 0 then
		self:DrawText(self:Round(self.Display.width/2 - string.len(text)/2), y, text, fg, bg)
	end
end

Draw.Round = function(self, int)
	assert(type(int) == 'number', "Attempt to round a non-number")
	return math.floor(int + 0.5)
end

