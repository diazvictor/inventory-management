--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--

local page_not_found = class('page_not_found');
local theme = conf.theme.theme

function page_not_found:show_main()
	view:add_content('title','Inventory | 404 - Page Not Found')
	view:add_content('description','Luachi, un framework web para Lua')
	view:add_contents({
		js = {
			('/js/themes/%s/app.min.js'):format(theme),
		},
		css  = {
			('/css/themes/%s/app.min.css'):format(theme,theme),
			('/css/themes/%s/common/common.css'):format(theme),
			('/css/themes/%s/public/404.css'):format(theme)
		}
	})
	local page = template.new(
		'/public/404.html'
	)
	view:generate(page)
end

function page_not_found:execute()
	self:show_main()
end

return page_not_found
