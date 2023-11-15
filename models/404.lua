--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--
local main	=	class('main')
local theme =   conf.theme.theme

function main:show()
	view:add_content('title',"Page not found")
	view:add_contents({
		css = {
			("/css/themes/%s/%s.min.css"):format(theme,theme),
			("/css/themes/%s/common/common.css"):format(theme),
			("/css/themes/%s/public/404/404.css"):format(theme)
		}
	})
	local page = template.new(
		"/public/common/404.html"
	)
	view:generate(page)
end

return main
