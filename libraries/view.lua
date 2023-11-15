--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--

------------------------------------------------------------------------
-- Views Luachi.
-- Esta clase contiene los metodos para la manipulacion de las vistas
-- en Luachi
-- @classmod view
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
------------------------------------------------------------------------

local view  = class("view")
template 	  = require("vendor.resty.template").new({
	root = ("%s/../views/themes/%s"):format(root,conf.theme.theme)
});
local js,css,messages,contents	= {},{},{},{}
local router,buffer

------------------------------------------------------------------------
---Añade un mensaje al buffer de mensajes
-- @param msg String: El mensaje
-- @usage
-- view:add_message('Mensaje Uno')
-- view:add_message('Mensaje Dos')
-- view:add_message('Mensaje tres')
------------------------------------------------------------------------
function view:add_message(msg)
	table.insert(messages,{message = msg})
end

------------------------------------------------------------------------
---Retorna el buffer de mensajes
-- @usage
-- local buffer view:get_content()
-- common:print_r(buffer)
-- table: 0x55d3fd228ac0 {
--   [1] => table: 0x55d3fd228ac0 {
--            [message] => "Mensaje Uno"
--          }
--   [2] => table: 0x55d3fd228ac0 {
--            [message] => "Mensaje Dos"
--          }
--   [3] => table: 0x55d3fd228ac0 {
--            [message] => "Mensaje tres"
--          }
-- }
------------------------------------------------------------------------
function view:get_messages()
	return messages
end

------------------------------------------------------------------------
--- Añade contenido al buffer para ser consumido
-- por la vista
-- @param name String: El indice del contenido que consumira la vista
-- @param value mixed: El valor del contenido
-- @usage
-- view:add_content('title',"Luachi Framework")
-- view:add_content('users',{"Victor"})
-- view:add_content('users',{"Diex"})
-- view:add_content('users',{"Diego"})
-- view:add_content('css',{"/css/spectre.min.css"})
-- view:add_content('css',{"/css/module/main.min.css"})
--
-- Luego, para consumir los datos haga lo siguiente en la vista html
--
--  <html>
--    <head>
--      <title>{{title}}</title>
--      {% for _, style in ipairs(css) do %}
--		<link rel="stylesheet" href="{*style*}">
--      {% end %}
--    </head>
--    <body>
--      <main>
--         <ul>
--          {% for _, user in ipairs(users) do %}
--		    <li>{{user}}</li>
--          {% end %}
--         </ul>
--      </main>
--    </body>
--  </html>
------------------------------------------------------------------------
function view:add_content(name,value)
	if( type(value) == 'table' ) then
		if(type(contents[name]) == 'table') then
			for k,v in pairs(value) do
				--local c = (ml.count(contents[name] or {})+1)
				local c = ((#contents[name] or {})+1)
				contents[name][c] = value[k]
			end
		else
			contents[name]=value
		end
	else
		if(type(contents[name]) == 'table') then
			table.insert(contents[name],value)
		else
			contents[name]=value
		end
	end
end

------------------------------------------------------------------------
--- Añade un lote de contenido al buffer para ser
-- consumido por la vista
-- @param data table: El contenido en una tabla asociativa, si ya existe
-- un indice con el nombre consumible, este se añadira al final, si no,
-- se registrara el indice con los datos asociativos
-- @usage
-- view:add_contents({
--		js    = {"/js/jquery.min.js","/js/module/main.min.js"},
--		css   = {"/css/spectre.min.css","/css/module/main.min.css"},
--		users = {"Victor","Diex","Diego"}
-- })
--
-- Luego, para consumir users haga lo siguiente en la vista html
--
--  <html>
--    <head>
--      <title>{{title}}</title>
--      {% for _, style in ipairs(css) do %}
--		<link rel="stylesheet" href="{*style*}">
--      {% end %}
--    </head>
--    <body>
--      <main>
--         <ul>
--          {% for _, user in ipairs(users) do %}
--		    <li>{{user}}</li>
--          {% end %}
--         </ul>
--      </main>
--      {% for _, v in ipairs(js) do %}
--      <script src="{*v*}"></script>
--      {% end %}
--    </body>
--  </html>
------------------------------------------------------------------------
function view:add_contents(data)
	if (type(data) == "table") then
		for k,v in pairs(data) do
			if( contents[k] ) then
			    for k1,v1 in pairs(data[k]) do
					table.insert(contents[k],v1)
				end
			else
				contents[k] = data[k]
			end
		end
	end
end

------------------------------------------------------------------------
---Retorna el contenido almacenado en el buffer
--@return table El contenido del buffer
--@usage
-- local buffer view:get_content()
-- common:print_r(buffer)
-- table: 0x558d28586b20 {
--  [messages] => table: 0x558d28586b20 {
--                }
--  [js] => table: 0x558d28586b20 {
--            [1] => "/js/jquery.min.js"
--            [2] => "/js/module/main.min.js"
--          }
--  [users] => table: 0x558d28586b20 {
--               [1] => "Victor"
--               [2] => "Diex"
--               [3] => "Diego"
--             }
--  [css] => table: 0x558d28586b20 {
--             [1] => "/css/spectre.min.css"
--             [2] => "/css/module/main.min.css"
--           }
--}
------------------------------------------------------------------------
function view:get_content()
	contents['messages'] = messages
	return contents
end

------------------------------------------------------------------------
--- Genera el documento HTML y lo escupe con las cabeceras apropiadas
-- para ser consumido por el browser
-- @return el HTML con las cabeceras HTTP
-- @usage
--	local page     = template.new(
--		"/private/start/main.html",
--		"/private/page.html"
--	)
-- view:add_contents({
--		js    = {"/js/jquery.min.js","/js/module/main.min.js"},
--		css   = {"/css/spectre.min.css","/css/module/main.min.css"},
--		users = {"Victor","Diex","Diego"}
-- })
--  view:generate(page)
------------------------------------------------------------------------
function view:generate(buffer)
	for k,v in pairs(contents) do
		buffer[k] = contents[k]
	end
	buffer['messages'] = messages
	--@FIXME esto me duplica la cookie al autenticar, la idea es que
	-- la autenticacion sobreescriba esta
	--if( ENV.HTTP_COOKIE == nil ) then
		--http:set_cookie(SESSION_ID,{value=common:random_hash(256)})
	--end
	http:header('Content-type: text/html; charset=utf-8')
	if( util:is_true(conf.luachi.production) ) then
		http:header('X-Frame-Options: sameorigin')
		http:header('X-Content-Type-Options: nosniff')
	end
	http:header('X-Powered-By: Luachi by Vitronic',200)
	io.stdout:write(tostring(buffer))
end

return view
