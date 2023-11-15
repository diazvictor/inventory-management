#!/usr/bin/haserl-lua5.1 --accept-all --shell=lua --upload-limit=4098 --upload-dir=/tmp
<%
--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--
package.path	=	package.path .. ";../?.lua;../libraries/?.lua;../vendor/?.lua";
require('libraries.luachi')

--inicializo las variables
local file,controller,route

--Registro la ruta solicitada
route = router:route()

--incluyo el modelo
file=files:exists(('%s/../models/%s.lua'):format(root,route))
if (file) then
	model = require(('models.%s'):format(route));
end

--incluyo el controlador
file=files:exists(('%s/../controllers/%s.lua'):format(root,route))
if (file) then
	controller = require(('controllers.%s'):format(route));
	controller:execute();
end
%>
