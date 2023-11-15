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
-- common Luachi.
-- Esta clase contiene metodos comunes para ser usados en la aplicacion
-- @classmod common
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
------------------------------------------------------------------------

local common	= class('common')
local rand	= require('vendor.randbytes')


------------------------------------------------------------------------
--- Generador de hash aleatorio, utiliza urandom para disponer de
-- alta entropia
-- @param size Integer: el tamaño del hash
-- @return String: el hash aleatorio
------------------------------------------------------------------------
function common:random_hash(size)
	local b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-"
	local file = io.open("/dev/urandom")
	local str = ""
	if file == nil then return nil end
	while (size > 0 ) do
		local offset = (string.byte(file:read(1)) % 64) + 1
		str = str .. string.sub (b64, offset, offset)
		size = size - 6
	end
	return str
end

------------------------------------------------------------------------
--- Generador de numeros aleatorios, utiliza urandom para disponer de
-- alta entropia
-- @param b Integer: bytes defaults to 4
-- @param m Integer; mask defaults to 256
-- @return Integer: el numero aleatorio
------------------------------------------------------------------------
function common:random_number(b, m)
	b = b or 4
	m = m or 256
	--urandom = assert (io.open('/dev/urandom', 'rb'))
	--local number, s = 0, urandom:read (b)
	--for i = 1, s:len() do
		--number = m * number + s:byte(i)
	--end
	--return number
	return rand:urandom(b,m)
end

------------------------------------------------------------------------
--- Generador de cadena de string aleatorios, esta diseñado
-- para disponer de alta entropia
-- @param length Integer: la longitud de la cadena
-- @return String: El string aleatorio
------------------------------------------------------------------------
function common:random_string(length)
	local charset = {}  do
		for c = 0, self:random_number(1) do
			table.insert(charset, self:random_hash(6))
		end
		for c = 0, self:random_number(1)
			do table.insert(charset, self:random_hash(6))
		end
		for c = 0, self:random_number(1)do
			table.insert(charset, self:random_hash(6))
		end
	end
	local text = ''
	math.randomseed(self:random_number())
	for i = 1, length do
		text = text..charset[math.floor(math.random(1,#charset))];
	end
	return text
end


--- escape unsafe html characters
function common:html_escape(text )
	text = text or ""
	local str = string.gsub (text, "&", "&amp;" )
	str = string.gsub (str, "<", "&lt;" )
	str = string.gsub (str, ">", "&gt;" )
	str = string.gsub (str, "'", "&#39;" )
	return (string.gsub (str, '"', "&quot;" ))
end


--- Default function for temporary names
-- @return a temporay name using os.tmpname
function common:tmpname()
    local tempname = os.tmpname()
    -- Lua os.tmpname returns a full path in Unix, but not in Windows
    -- so we strip the eventual prefix
    tempname = string.gsub(tempname, "(/tmp/)", "")
    return tempname
end


--- Imprime los elemento de una tabla en un formato entendible
--like a php print_r
--@param t table: La tabla de datos a imprimir
--@param fd file descriptor
function common:print_r(t, fd)
    fd = fd or io.stdout
    local function print(str) str = str or "" fd:write(str.."\n") end
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

return common
