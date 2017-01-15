shell.run("/waffleui/WaffleUI/UpdateMetatable.lua")
shell.run("/waffleui/WaffleUI/Constraints.lua")
shell.run("/waffleui/WaffleUI/Draw.lua")

shell.run("waffleui/WaffleUI/UIObjects/Screen.lua")
shell.run("waffleui/WaffleUI/UIObjects/View.lua")
shell.run("waffleui/WaffleUI/UIObjects/Label.lua")
shell.run("waffleui/WaffleUI/UIObjects/Button.lua")

UIStatus = {
	needsUpdate = false,
}

Screens = {}

ActiveObject = {}
ActiveView = {}
ActiveController = {}

local isInHitbox = function(obj, x, y)
	return (obj.X <= x and (obj.X + obj.Width) > x and obj.Y <= y and (obj.Y + obj.Height) > y)
end

Initialize = function()
	--Initialize screen #0 (default terminal)
	Screens[1] = ScreenPort:New()
	-- TODO: Don't require this main view to be provided
	MainView = View:New({Top=0, Left=0, Right=0, Bottom=0}, "lightGray")
	Screens[1]:Add(MainView)
	Screens[1]:Draw()
end

HandleEvent = function(e)
	if e[1] == 'mouse_click' then
		HandleClick(Screens[1], e[3], e[4], e[2])
	elseif e[1] == 'mouse_up' then
		HandleMouseUp(Screens[1], e[3], e[4], e[2])
		-- Akward Code to Clean Up a button glitch
		if ActiveObject._type == 'Button' then
			ActiveObject.Active = false
			ActiveObject = {}
		end
	elseif e[1] == 'mouse_drag' then
		HandleDrag(e)
	else
		--ActiveController.HandleEvent(e)
	end
end


Run = function()
	while true do
		event = {os.pullEvent()}
		HandleEvent(event)
		if UIStatus.needsUpdate then
			for i=1,#Screens do
				Screens[i]:Draw()
			end
			UIStatus.needsUpdate = false
		end
	end
end

HandleClick = function(obj, x, y, button)
	if obj.delegateEvents == true then
		local nextDelegate = nil
		for i=1,#obj.Children do
			if isInHitbox(obj.Children[i], x, y) then
				nextDelegate = obj.Children[i]
				break
			end
		end
		if nextDelegate ~= nil then
			HandleClick(nextDelegate, x+obj.X-1, y+obj.Y-1)
		end
	else
		obj:HandleClick(x, y, button)
	end
end

HandleMouseUp = function(obj, x, y, button)
	if obj.delegateEvents == true then
		local nextDelegate = nil
		for i=1,#obj.Children do
			if isInHitbox(obj.Children[i], x, y) then
				nextDelegate = obj.Children[i]
				break
			end
		end
		if nextDelegate ~= nil then
			HandleMouseUp(nextDelegate, x+obj.X-1, y+obj.Y-1)
		end
	else
		obj:HandleMouseUp(x, y, button)
	end
end

HandleDrag = function(event)

end
