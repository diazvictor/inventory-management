--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| "_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--

------------------------------------------------------------------------
-- login Luachi.
-- Esta modulo contiene el controlador para iniciar la sesion
-- @module login
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
------------------------------------------------------------------------

local login	= class("login");
local theme = conf.theme.theme

function login:execute()
	http:header("Status: 401")
	if ( ENV.REQUEST_METHOD == "POST" and FORM["logIn"] == "true" ) then
		if( FORM["username"] ) then
			view:add_content("username", FORM["username"])
		end
	end

	view:add_contents({
		title = "Inventory | Login",
		description = "Entrada al inventario, ingrese sus credenciales",
		css = {
			("/css/themes/%s/app.min.css"):format(theme),
			('/css/themes/%s/common/common.css'):format(theme),
			("/css/themes/%s/public/login.css"):format(theme)
		}
	})

	if ( util:is_false(conf.luachi.production) ) then
		view:add_content('js','//127.0.0.1:35729/livereload.js')
	end

	local page = template.new(
		"/public/login.html"
	)
	view:generate(page)
end

return login
