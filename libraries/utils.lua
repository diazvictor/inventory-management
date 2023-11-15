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
-- Utilidades Luachi.
-- Esta clase contiene metodos utiles para ser usados en la aplicacion
-- @classmod utils
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
------------------------------------------------------------------------

local utils	= class('utils')


--- Convierte un string en una tabla
--- @param str el string
--- @param sep el patron de separacion
--- @return table
function utils:split(str,sep)
	local _sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", _sep)
	str:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

--- Verifica si un archivo existe
--- @param file la ruta del archivo
--- @return boolean
function utils:isfile(file)
	return (io.open(tostring(file), "r") ~= nil)
end

--- Remueve espacios iniciales y finales de una cadena
--- @param value el texto a limpiar
--- @return el texto limpiado
function utils:trim(value)
	return (string.gsub(value, "%s+$", ""):gsub("^%s+", ""))
end

--- Remueve espacios iniciales de una cadena
--- @param value el texto a limpiar
--- @param pattern el patron de busqueda
--- @return el texto limpiado
function utils:ltrim(value,pattern)
	pattern = "^" .. (pattern or "%s+")
	local t = type(value)
	if t == "string" or t == "number" then
		return (string.gsub(value, pattern, ""))
	end
	return nil
end

--- Remueve espacios finales de una cadena
--- @param value el texto a limpiar
--- @param pattern el patron de busqueda
--- @return el texto limpiado
function utils:rtrim(value,pattern)
	pattern = (pattern or "%s+") .. "$"
	local t = type(value)
	if t == "string" or t == "number" then
	    return (string.gsub(value, pattern, ""))
	end
	return nil
end

--- Convierte a Minuscula el texto pasado
--- @param value el texto a transformar
--- @return el texto transformado
function utils:lower(value)
	local t = type(value)
	if t == "string" or t == "number" then
	    return string.lower(value)
	end
	return nil
end

--- Convierte a Mayuscula el texto pasado
--- @param value el texto a transformar
--- @return el texto transformado
function utils:upper(value)
	local t = type(value)
	if t == "string" or t == "number" then
	    return string.upper(value)
	end
	return nil
end

--- Compara dos entras y retorna true si son iguales
--- @param value la primera entrada
--- @param equal la entrada a comparar
--- @return boolean
function utils:equals(value,equal)
        return value == equal
end

--- Convierte mixed a boolean
function utils:is_true(s)
	if (type(s) == "string") then
		s = string.lower(s)
	end
	local items = { true, 1 ,"1", "yes", "true", "on", "t" }
	for _,v in pairs(items) do
	  if v == s then
		return true
	  end
	end
	return false
end

--- Convierte mixed a boolean
function utils:is_false(s)
	return (self:is_true(s) == false)
end

--- Guarda en la bitacora de debug
function utils:logfile(msg)
	local date_format = conf.datetime.datetime
	msg =  ('%s\t%s\n'):format(os.date(date_format,os.time()),msg)
	local fd = io.open(root..'/../logfiles/debug.log', "a+")
	fd:write(msg)
	fd:close()
end

--- Toma prestado un metodo de un modelo
function utils:borrow(_module)
	file=files:exists(('%s/../models/%s.lua'):format(root,_module))
	if not file then
		http:header("Content-Type: text/plain",200)
		io.stdout:write(tostring(("Can't borrow model '%s'.\n"):format(_module) ))
		os.exit()
	end
	return require(('models.%s'):format(_module))
end


--function utils:fromBytes(t)
   --local bytearr = {}
   --for _, v in ipairs(t) do
      --local utf8byte = v < 0 and (0xff + v + 1) or v
      --table.insert(bytearr, string.char(utf8byte))
   --end
   --return table.concat(bytearr)
--end

function utils:str_split(str)
	t={}
	str:gsub(".",function(c)table.insert(t,c)end)
	return t
end

function utils:tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2 
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end


return utils
