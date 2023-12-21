--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--

local catalogue =	class('catalogue');
local theme = conf.theme.theme
local parameters = router.parameters

--- Configuracion general de la pagina
function catalogue:set_page()
	view:add_contents({
		js = {
			('/js/themes/%s/app.min.js'):format(theme)
		},
		css = {
			('/css/themes/%s/app.min.css'):format(theme),
			('/css/themes/%s/common/common.css'):format(theme,theme),
			('/css/themes/%s/private/catalogue/main.css'):format(theme)
		}
	})

	if ( util:is_false(conf.luachi.production) ) then
		view:add_content('js','//127.0.0.1:35729/livereload.js')
	end
end

--- Configuracion de la vista principal
function catalogue:show(data)
	view:add_content('title','Inventory | Catalogue')

	self:set_page()

	view:add_contents({
		catalogue = data or {},
		js = {
			('/js/themes/%s/private/catalogue/main.min.js'):format(theme)
		}
	})

	local page = template.new(
		'/private/catalogue/main.html',
		'/private/page.html'
	)
	view:generate(page)
end

--- Configuracion del filtro
function catalogue:show_filter()
	local page = template.new(
		'/private/catalogue/filter.html'
	)
	view:generate(page)
end

--- Configuracion del formulario
function catalogue:show_form(data)
	if (not data) then
		view:add_content('title','New article')
	else
		view:add_content('title','Edit article')
	end

	self:set_page()

	view:add_contents({
		catalogue = data or {},
		js = {
			('/js/themes/%s/private/catalogue/form.min.js'):format(theme)
		}
	})

	local page = template.new(
		'/private/catalogue/form.html',
		'/private/page.html'
	)
	view:generate(page)
end

--- Confiuracion de la vista
function catalogue:show_view(data)
	view:add_content('title','View article')

	self:set_page()

	view:add_contents({
		catalogue = data or {},
		js = {
			('/js/themes/%s/private/catalogue/form.min.js'):format(theme)
		}
	})

	local page = template.new(
		'/private/catalogue/form.html',
		'/private/page.html'
	)
	view:generate(page)
end

function catalogue:execute()
	if (ENV.REQUEST_METHOD == 'POST') then
		if (http:xmlhttprequest()) then
			if ( FORM['search'] ) then
				http:header('Content-type: application/json; charset=utf-8',200)
				local result = {
					items = model:search(FORM['search'])
				}
				print(json.encode(result))
				return
			end
		end

		if ( FORM['submit'] == 'save' ) then
			local ok, err
			ok, err = model:save(FORM)
			if ( not ok ) then
				view:add_message(err[1])
				self:show_form(FORM)
				return
			end
			http:header('Location: /catalogue', 200)
			return
		end
	end

	if (parameters and parameters[1]) then
		if (parameters[1] == 'new') then
			self:show_form()
			return
		elseif (parameters[1] == 'filter' and http:xmlhttprequest()) then
			self:show_filter()
			return
		elseif (parameters[1] == 'edit' and parameters[2]) then
			if (tonumber(parameters[2])) then
				local data = model:get_catalogue(parameters[2])
				if ( not data ) then
					--- Tomo prestado el show del modulo 404
					borrow:class('404'):show()
					return
				end
				self:show_form(data)
				return
			end
		elseif (parameters[1] == 'page') then
			self:show(model:get_catalogue(tonumber(parameters[2])))
			return
		else
			-- Si no es new o edit, muestro el 404
			borrow:class('404'):show()
			return
		end
	end

	-- Por defecto se muestra la vista principal
	self:show(model:get_catalogue())
end

return catalogue
