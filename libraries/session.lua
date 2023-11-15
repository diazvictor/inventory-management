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
-- Session Luachi.
-- Esta clase contiene los metodos asociados a la manipulacion de sesiones
-- en Luachi
-- @classmod session
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
------------------------------------------------------------------------

local session		=  class('session')

------------------------------------------------------------------------
---Prefijo del archivo fisico de sesion
------------------------------------------------------------------------
local prefile		= '/tmp/lsess_%s'

------------------------------------------------------------------------
--- Retorna el identificador de la session, y si no existe genera uno
-- @return String: el identificador
-- @todo Mejorar!
------------------------------------------------------------------------
function session:get_id()
	local session_id
	if ( self.session_id ) then
		session_id = self.session_id
	elseif ( COOKIE[SESSION_ID] ) then
		session_id = COOKIE[SESSION_ID]
	elseif (SESSION['session_id']) then
		session_id = SESSION['session_id']
	else
		session_id = common:random_hash(256)
	end
	util:logfile(('SESSION_ID %s'):format(session_id))
	return session_id
end

------------------------------------------------------------------------
--- Almacena los datos de la sesion de forma serializada en el servidor
-- @param data table: Los datos de la sesion
------------------------------------------------------------------------
function session:save(data)
	local file	= prefile:format(self:get_id())
	local save	= data or SESSION
	local fh = assert(io.open(file, "w+"))
	fh:write "return "
	serialize (save, function (s) fh:write(s) end)
	fh:close()
	SESSION 	   = dofile(file)
end

------------------------------------------------------------------------
--- Mantiene sincronizada la variable global SESSION con el archivo
--fisico que esta en el servidor
------------------------------------------------------------------------
function session:update()
	if (ENV.HTTP_COOKIE ~= nil) then
		local file = prefile:format(self:get_id())
		if (util:isfile(file)) then
			SESSION = dofile(file)
			return
		end
	end
	SESSION = {}
end

------------------------------------------------------------------------
--- Destruye una sesion eliminando el archivo fisico del servidor
------------------------------------------------------------------------
function session:destroy()
	if (ENV.HTTP_COOKIE ~= nil) then
		local file = prefile:format(self:get_id())
		if (util:isfile(file)) then
			os.remove(file)
		end
	end
end

return session
