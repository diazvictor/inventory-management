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
-- HTML Luachi.
-- Esta clase contiene los metodos para la manipulacion del
-- protocolo HTTP en Luachi
-- @classmod http
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
------------------------------------------------------------------------

local http	= class("http")

------------------------------------------------------------------------
---Es usada para enviar una cabecera HTTP en bruto.
-- @param header String: The header string.
-- @param response_code Integer: Fuerza el código de respuesta
-- HTTP al valor especificado.
------------------------------------------------------------------------
function http:header(header,response_code)
	if ( type(response_code) == 'number' ) then
		print(("Status: %s\n%s\n"):format(response_code,header))
	else
		print(('%s'):format(header))
	end
end

------------------------------------------------------------------------
---Verifica si la peticion se hace via xmlhttprequest
-- @return boolean true si la petision es un XMLHTTPREQUEST, false
-- en caso contrario
------------------------------------------------------------------------
function http:xmlhttprequest()
	if ( ENV.HTTP_X_REQUESTED_WITH ~= nil ) then
		return ((ENV.HTTP_X_REQUESTED_WITH):lower() == 'xmlhttprequest')
	end
	return false
end

------------------------------------------------------------------------
---- Añade componentes opcionalñes de una cookie
-- @param what El nombre del componente
-- @param name El valor del componente
------------------------------------------------------------------------
local function optional(what, name)
  if name ~= nil and name ~= "" then
    return string.format("; %s=%s", what, name)
  else
    return ""
  end
end


local function optional_flag(what, isset)
  if isset then
    return string.format("; %s", what)
  end
  return ""
end

------------------------------------------------------------------------
---- Crea los componentes de una cookie
-- @param name El nombre de la cookie
-- @param value El valor de la cookie
------------------------------------------------------------------------
local function make_cookie(name, value)
	local options = {}
	local t
	if type(value) == "table" then
		options = value
		value = value.value
	end
	local cookie = string.format('%s=%s',name,value)
	if (options.expires==nil) then
		if(tonumber(conf.cookie.expire)~=nil) then
			local expire = tonumber(conf.cookie.expire)
			options.expires = (os.time()+expire)
		end
	end
	if options.expires then
		t = os.date("!%A, %d-%b-%Y %H:%M:%S GMT", options.expires)
		cookie = cookie .. optional("expires", t)
	end
	if options.max_age then
		t = os.date("!%A, %d-%b-%Y %H:%M:%S GMT", options.max_age)
		cookie = cookie .. optional("Max-Age", t)
	end
	cookie = cookie .. optional("path", options.path)
	cookie = cookie .. optional("domain", options.domain)
	cookie = cookie .. optional_flag("secure", options.secure)
	cookie = cookie .. optional_flag("HttpOnly", options.httponly)
	return cookie
end

------------------------------------------------------------------------
--- Imprime la cabecera http
-- @param name String con el nombre de la cookie.
-- @param value String con el valor de la cookie.
--
------------------------------------------------------------------------
function http:set_cookie(name, value)
	http:header(("Set-Cookie: %s"):format(make_cookie(name, value)))
end

------------------------------------------------------------------------
--- Borra una cookie
-- @param name String con el nombre de la cookie.
--
------------------------------------------------------------------------
function http:delete_cookie(name)
  self:set_cookie(name, {value="", expires = 1})
end

------------------------------------------------------------------------
--- Retorna el valor de una cookie..
-- @param name String con el nombre de la cookie.
-- @return String con el valor asociado a la cookie
--
------------------------------------------------------------------------
function http:get_cookie(name)
	--return COOKIE[name]
	local cookies = ENV.HTTP_COOKIE or ""
	cookies = ";" .. cookies .. ";"
	cookies = string.gsub(cookies, "%s*;%s*", ";")
	local pattern = ";" .. name .. "=(.-);"
	local _, __, value = string.find(cookies, pattern)
	return value and self:url_decode(value)
end

------------------------------------------------------------------------
--- Decode an URL-encoded string (see RFC 2396)
------------------------------------------------------------------------
function http:url_decode(str)
	if not str then return nil end
	str = string.gsub (str, "+", " ")
	str = string.gsub (str, "%%(%x%x)",
		function(h) return string.char(tonumber(h,16)) end
	)
	str = string.gsub (str, "\r\n", "\n")
	return str
end

------------------------------------------------------------------------
--- URL-encode a string (see RFC 2396)
------------------------------------------------------------------------
function http:url_encode(str)
	if not str then return nil end
	str = string.gsub (str, "\n", "\r\n")
	str = string.gsub (str, "([^%w ])",
		function(c) return ("%%%02X"):format(string.byte(c)) end
	)
	str = string.gsub (str, " ", "+")
	return str
end


return http
