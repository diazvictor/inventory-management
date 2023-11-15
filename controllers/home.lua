--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--

local home = class('home');
local theme = conf.theme.theme
local parameters  = router.parameters

function home:show_main(data)
	view:add_content('title',"Luachi | Usuarios")
	view:add_content('description',"Luachi, un framework web para Lua")
	view:add_contents({
		users = data or {},
		css = {
			("/css/themes/%s/public/home/main.css"):format(theme)
		},
		js = {
			("/js/themes/%s/public/home/main.js"):format(theme)
		}
	})
	local page = template.new(
		"/public/home/main.html",
		"/public/page.html"
	)
	view:generate(page)
end

function home:show_form(data)
	local data = data or {}
	if data.id_user then
		view:add_content('title',"Luachi | Editar usuario")
	else
		view:add_content('title',"Luachi | Nuevo usuario")
	end
	view:add_content('description',"Luachi, un framework web para Lua")
	view:add_contents({
		user = data,
		css = {
			("/css/themes/%s/public/home/main.css"):format(theme)
		},
		js = {
			("/js/themes/%s/public/home/main.js"):format(theme)
		}
	})
	local page = template.new(
		"/public/home/form.html",
		"/public/page.html"
	)
	view:generate(page)
end

function home:execute()
	if (ENV.REQUEST_METHOD == 'POST') then
		if ( FORM['logOut'] == 'true' ) then
			local result = auth:logOut()
			if ( result == true) then
				http:header("Content-type: application/json; charset=utf-8",200)
				print(json.encode({ ok = result }))
			end
			return
		end

		if ( FORM['submit'] == 'save' ) then
			local ok, err = model:save(FORM)
			if ( not ok ) then
				view:add_message(err[1])
				self:show_form(FORM)
				return
			end
			http:header('Location: /home', 200)
			return
		end
	end

	if (parameters and parameters[1]) then
		if (parameters[1] == "new") then
			self:show_form()
			return
		elseif (parameters[1] == "edit" and parameters[2]) then
			if (parameters[2]) then
				local data = model:get_user(tonumber(parameters[2]))
				-- for k,v in pairs(data[1].id_user) do
				util:logfile(('EDIT: %s'):format(tostring(data.id_user)))
				-- end
				if ( not data['id_user'] ) then
					util:borrow('404'):show()
					return
				end
				self:show_form(data)
				return
			end
		end
	end

	self:show_main(model:get_users())
end

return home
