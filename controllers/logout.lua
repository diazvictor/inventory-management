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
-- logout Luachi.
-- Esta modulo contiene el controlador para cerrar la sesion
-- @module logout
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
------------------------------------------------------------------------

local logout	=	class('logout');

------------------------------------------------------------------------
---Ejecuta el controlador
------------------------------------------------------------------------
function logout:execute()
	if ( auth:isLogged() ) then
		local result = auth:logOut()
		if ( result == true) then
			http:header("Location: /\n",307)
		end
	else
		http:header('Content-type: text/html; charset=utf-8',200)
		print 'Usted no esta logeado  <a href="/">Inicio</a> ';
	end
end

return logout
