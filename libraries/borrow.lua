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
-- Borrow Luachi.
-- Esta clase toma prestados metodos de un modulo
-- @classmod borrow
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
------------------------------------------------------------------------


local borrow = class('borrow')

function borrow:class(_module)
	file=files:exists(('%s/../models/%s.lua'):format(root,_module))
	if not file then
		http:header("Content-Type: text/plain",200)
		io.stdout:write(tostring(("Can't borrow model '%s'.\n"):format(_module) ))
		os.exit()
	end
	return require(('models.%s'):format(_module))
end

return borrow
