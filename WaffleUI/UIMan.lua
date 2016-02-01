ActiveObject = {}
ActiveView = {}
ActiveController = {}

HandleEvent = function(e)
	if e[1] == 'mouse_click' then
		HandleClick(e[3], e[4], e[2])
	elseif e[1] == 'mouse_up' then
		HandleMouseUp(e[3], e[4], e[2])
	elseif e[1] == 'mouse_drag' then
		HandleDrag(e)
	else
		ActiveController.HandleEvent(e)
	end
end


Run = function()
	while true do
		event = {os.pullEvent()}
		HandleEvent(event)
	end
end
