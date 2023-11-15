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
-- captcha Luachi.
-- Clase para la generacion de imagenes captcha
-- @classmod captcha
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
-- @usage
--	local captcha		= require("libraries.captcha");
--	captcha.length		= 8    --(required)
--	captcha.width		= 180  --(optional)
--	captcha.height		= 50   --(optional)
--	captcha.base64		= true --(optional)
--	captcha.distorsion	= 5    --(optional)
--	captcha.code = 'Vitronic'      --(optional)
--	captcha:generate()
--	captcha:output()
------------------------------------------------------------------------

local captcha	= class('captcha')
local magick	= require('imagick')
local FONT	= root .. "/fonts/captcha_font.ttf"

---Usado para generar entropia en los random
--@local
local function random_number(b, m)
	b = b or 4
	m = m or 256
	urandom = assert (io.open('/dev/urandom', 'rb'))
	local number, s = 0, urandom:read (b)
	for i = 1, s:len() do
		number = m * number + s:byte(i)
	end
	return number
end

---Genera el codigo del captcha
function captcha:gen_code()
	math.randomseed(random_number())
	local charset = {}  do
	    for c = 48, 57  do table.insert(charset, string.char(c)) end --[0-9]
	    for c = 97, 122 do table.insert(charset, string.char(c)) end --[a-z]
	end
	local text = ''
	for i = 1, self.length do
		text = text .. charset[math.floor(math.random(1,#charset))];
	end
	return text
end

---Genera la imagen captcha
function captcha:generate()
	math.randomseed(random_number())
	local width 	= self.width  or 180
	local height	= self.height or 50
	local font	= self.font   or FONT
	local code   	= self.code   or self:gen_code()
	local i 	= 0
	local r		= math.random(10,150)
	local g		= math.random(10,150)
	local b		= math.random(10,150)
	local background  = ('xc:rgb(%d,%d,%d)'):format(r,g,b)
	self.img = assert(magick.open_pseudo(width, height, background))
	self.img:set_font(font)

	for char in code:gmatch(".") do
		local r		= math.random(150,255)
		local g		= math.random(150,255)
		local b		= math.random(150,255)
		local color 	= ('rgb(%d,%d,%d)'):format(r,g,b)
		local angle	= math.random(55)-20
		local y		= math.random(30,40)
		local x		= (i*20)+10
		if ( type(self.distorsion) == 'number' ) then
			self.img:swirl( math.random(self.distorsion) )
		end
		self.img:set_font_size((height * 0.75)+ math.random(10) )
		self.img:annotate(color, char, x, y, angle)
		i=i+1
	end

	--Creo una cookie temporal para registrar la sesion
	if( not ENV.HTTP_COOKIE ) then
		session.session_id	 = session:get_id()
		http:set_cookie(
			SESSION_ID,{
				value    = session.session_id,
				domain	 = conf.cookie.domain,
				path	 = '/',
				secure	 = false,
				httponly = true,
				expire   = false
			}
		)
	end

	SESSION['captcha_code'] = code
	session:save(SESSION)
end

---Valida en codigo captcha
function captcha:validate(code)
	if ( not SESSION['captcha_code'] ) then
		return false, gettext('invalid captcha request')
	end
	if (code == SESSION['captcha_code']) then
		return true
	end
	return false, gettext('invalid captcha code')
end

---Escupe el captcha en formato png o base64
-- para se consumido por el browser
function captcha:output()
	self.img:swirl( math.random(0,30) )
	self.img:oilpaint(1)
	self.img:set_format("PNG")
	local img_blob,img_length = self.img:blob()

	local datetime = os.date('%a, %d %b %Y %H:%M:%S', os.time());
	http:header("Expires: "..datetime.." GMT")
	http:header("Last-Modified: "..datetime.." GMT")
	http:header("Cache-Control: no-store, no-cache, must-revalidate")
	http:header("Cache-Control: post-check=0, pre-check=0")
	http:header("Pragma: no-cache")

	if ( self.base64 == true ) then
		local base64 = require('vendor.base64')
		http:header('text/plain',200)
		io.write( base64.encode(img_blob) )
		return
	end

	http:header("Content-Type: image/png",200)
	io.write( img_blob )
end


return captcha
