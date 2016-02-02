
local Round = function(int)
	if type(int) ~= 'number' then
		error("Attempt to round a non-number", 2)
	end
	return math.floor(int + 0.5)
end

-- UI Constraint Controls

-- All constraints can be transformed into X, Y, Width, Height.

Constrain = function(parentView, obj)
	if parentView.canDraw == false then
		error("Parent View must have calculated constraints!", 2)
	end
	if not obj.Constraints then
		error("Attempt to constrain an Object without constraints", 2)
	end
	
	local modifyX = true
	local modifyY = true
	local modifyWidth = true
	local modifyHeight = true
	
	--If any value is hard configured, don't modify anything else!
	if type(obj.Constraints.X) == 'number' then
		obj.X = obj.Constraints.X
		modifyX = false	
	end
	if type(obj.Constraints.Y) == 'number' then
		obj.Y = obj.Constraints.Y
		modifyY = false
	end
	if type(obj.Constraints.Width) == 'number' then
		obj.Width = obj.Constraints.Width
		modifyWidth = false	
	end
	if type(obj.Constraints.Height) == 'number' then
		obj.Height = obj.Constraints.Height
		modifyHeight = false
	end
	
	-- Do minimum constraints last
	if obj.Constraints.MinWidth and modifyWidth and obj.Constraints.Width < obj.Constraints.MinWidth then
		obj.Constraints.Width = MinWidth
		modifyWidth = false
	end
	if obj.Constraints.MinHeight and modifyHeight and obj.Constraints.Height < obj.Constraints.MinHeight then
		obj.Constraints.Height = MinHeight
		modifyHeight = false
	end
	
	-- Edge Constraints Override all other constraints Left->Top->Right->Bottom
	
	if obj.Constraints.Left then
		-- If the constraint is a string, it needs interpreting
		if type(obj.Constraints.Left) == 'string' then
			-- If the string continained an ending percent symbol
			local found, _, percent = string.find(obj.Constraints.Left, "(%d+)%%$")
			--print(percent)
			percent = tonumber(percent)
			if found then
				obj.X = Round((percent/100) * parentView.Width)
				modifyX = false 
			end
		-- If the constraint is a literal number
		elseif type(obj.Constraints.Left) == 'number' then
			obj.X = (obj.Constraints.Left + 1 > parentView.Width) and parentView.Width or obj.Constraints.Left + 1
			modifyX = false
		end
	end
	
	if obj.Constraints.Top then
		if type(obj.Constraints.Top) == 'string' then
			-- If the string continained an ending percent symbol
			local found, _, percent = string.find(obj.Constraints.Top, "(%d+)%%$")
			percent = tonumber(percent)
			if found then
				obj.Y = Round((percent/100) * parentView.Height)
				modifyY = false 
			end
		-- If the constraint is a literal number
		elseif type(obj.Constraints.Top) == 'number' then
			obj.Y = (obj.Constraints.Top + 1 > parentView.Height) and parentView.Height or obj.Constraints.Top + 1
			modifyY = false
		end
	end
	
	--Right and Bottom Constraints could actually be two different calculations... Just saying.

	if obj.Constraints.Right then
		if type(obj.Constraints.Right) == 'string' then
			-- If the string continained an ending percent symbol
			local found, _, percent = string.find(obj.Constraints.Right, "(%d+)%%$")
			percent = tonumber(percent)
			if found then
				if obj.X and not modifyX then
					-- If we calculated the X coord, we will use this constraint to set width
					obj.Width = parentView.Width - Round(parentView.Width*(percent/100)) - obj.X + 1
					modifyWidth = false
				elseif obj.Width and not modifyWidth then
					obj.X = parentView.Width - Round(parentView.Width*(percent/100)) - obj.Width + 1
					modifyX = false
				end 
			end
		-- If the constraint is a literal number
		elseif type(obj.Constraints.Right) == 'number' then
			if obj.X and not modifyX then
					-- If we calculated the X coord, we will use this constraint to set width
					obj.Width = parentView.Width - obj.Constraints.Right - obj.X + 1
					modifyWidth = false
				elseif obj.Width and not modifyWidth then
					obj.X = parentView.Width - obj.Constraints.Right - obj.Width + 1
					modifyX = false
				end 
		end
	end
	
	if obj.Constraints.Bottom then
		if type(obj.Constraints.Bottom) == 'string' then
			-- If the string continained an ending percent symbol
			local found, _, percent = string.find(obj.Constraints.Bottom, "(%d+)%%$")
			percent = tonumber(percent)
			if found then
				if obj.Y and not modifyY then
					-- If we calculated the Y coord, we will use this constraint to set height
					obj.Height = parentView.Height - Round(parentView.Height*(percent/100)) - obj.Y + 1
					modifyHeight = false
				elseif obj.Height and not modifyHeight then
					obj.Y = parentView.Height - Round(parentView.Height*(percent/100)) - obj.Height + 1
					modifyY = false
				end 
			end
		-- If the constraint is a literal number
		elseif type(obj.Constraints.Bottom) == 'number' then
			if obj.Y and not modifyY then
					-- If we calculated the Y coord, we will use this constraint to set Height
					obj.Height = parentView.Height - obj.Constraints.Bottom - obj.Y + 1
					modifyHeight = false
				elseif obj.Height and not modifyHeight then
					obj.Y = parentView.Height - obj.Constraints.Bottom - obj.Height + 1
					modifyY = false
				end 
		end
	end
	
	--For debug purposes
	--[[
		print(obj.X)
		print(obj.Y)
		print(obj.Width)
		print(obj.Height)
		
		os.pullEvent()
	]]--
	obj.canDraw = true
end



