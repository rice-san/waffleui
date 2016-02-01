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
	
	print(obj.X)
	print(obj.Y)
	print(obj.Width)
	print(obj.Height)
	
	os.pullEvent()
	
	obj.canDraw = true
end


