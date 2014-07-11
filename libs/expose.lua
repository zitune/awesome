local capi = {
    tag = tag,
    client = client,
    keygrabber = keygrabber,
    mousegrabber = mousegrabber,
    mouse = mouse,
    screen = screen,
   naughty = naughty
}


function expose()
   local t = awful.tag.new({"ALL"},
			   mouse.screen,
			   awful.layout.suit.fair)[1]
   awful.tag.viewonly(t, mouse.screen)
   local clients = capi.client.get(scr)
   for _, c in pairs(clients) do
      awful.client.toggletag(t, c)
   end

   local function restore()
      capi.keygrabber.stop()
      capi.mousegrabber.stop()
      t.screen = nil
   end

   capi.keygrabber.run(function(mod, key, event)
			  if event ~= "press"
			  then
			     return true
			  end
			  if key == "Escape"
			  then
			     awful.tag.history.restore()
			     restore()
			     return false
			  end
			  if key == "Return"
			  then
			     awful.tag.viewonly(awful.client.focus.history.get(mouse.screen, 0):tags()[1])
			     restore()
			     return false
			  end
			  if key == "Left" or key == "Right" or
			     key == "Up" or key == "Down" then
			     awful.client.focus.bydirection(key:lower())
			  end
			  return true
		       end)
   capi.mousegrabber.run(function(mouse)
			    local c = awful.mouse.client_under_pointer()
			    if mouse.buttons[1] == true then
			       local t = c:tags()
			       local i = 1
			       while t[i].name == "ALL"
			       do
				  i = i + 1
			       end
			       awful.tag.viewonly(awful.mouse.client_under_pointer():tags()[1])
			       restore()
			       return false
			    end
			    return true
			 end,"fleur")
end
