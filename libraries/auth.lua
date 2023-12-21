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
-- Auth Luachi.
-- Esta clase contiene los metodos asociados a la autenticación en Luachi
-- @classmod auth
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
------------------------------------------------------------------------

local auth	        	=	class('auth')
local crypt             = 	require('crypt')
local session_timeout 	=	tonumber(conf.security.session_timeout)

------------------------------------------------------------------------
--- Crea un password cifrado
-- @param plaintext La frase a cifrar
-- @param method md5|sha|ssha|sha256|sha512
-- @param salt Una frase aleatoria para generar entropia
-- @return string | la contraseña ya cifrada
------------------------------------------------------------------------
function auth:make_password(plaintext, method, salt)
	--@see https://github.com/jprjr/lua-crypt
	if not crypt.methods[method] then
	  return false, ('Method %s not available'):format(method)
	end
	local salt = salt or common:random_hash(64)
	local method = method or 'sha256'
	return crypt.encrypt(method,plaintext,salt)
end

------------------------------------------------------------------------
--- Metodo para iniciar y cerrar sesion
-- @local
-- @param mode String 'login' o 'exit'
-- @usage auth:key('login') se creara o actualizara una cookie
-- y sera enviada al browser, ademas se registrara la sesion
-- en el servidor
-- @usage auth:key('exit') la cookie sera destruida asi como tambien
-- la sesion en el servidor
------------------------------------------------------------------------
function auth:key(mode)
	if(mode == 'login') then
		session.session_id	= session:get_id()
        local session_persistent = self.session_persistent or false
		http:set_cookie(
			SESSION_ID,{
				value   = session.session_id,
				domain	= conf.cookie.domain or nil,
				path	= '/',
				secure	= false,
				httponly= true,
				expire  = false
			}
		)
		local data = {}
		data.id_user 	= self.id_user;
		data.username 	= self.username;
		data.fullname 	= self.fullname;
		data.is_admin 	= self.is_admin;
		data.session_id	= session.session_id;
		if(session_timeout and not session_persistent) then
			data.session_timeout = (os.time()+session_timeout);
		end
		session:save(data)
		return true, gettext(('User %s authenticated')):format(self.username)
	elseif(mode == 'exit') then
		session:destroy()
		http:delete_cookie(SESSION_ID)
		return true, gettext('Logging out, bye')
	end
	return false
end

------------------------------------------------------------------------
--- Retorna true si la sesion es valida
-- @return boolean
------------------------------------------------------------------------
function auth:sessionIsValid()
	if ( SESSION and SESSION['id_user'] ) then
		if ( SESSION['session_timeout'] == nil )then
			return true
		end
		if ( SESSION['session_timeout'] > os.time() ) then
			SESSION['session_timeout'] = (os.time()+session_timeout)
			session:save(SESSION)
			return true
		end
		self:key('exit')
	end
	return false
end

------------------------------------------------------------------------
--- Este metodo permite el inicio de la sesion comparando las
-- credenciales
-- @param user EL nombre de usuario
-- @param pass La contraseña del usuario
-- @return boolean true en caso de exito, false en caso de error
------------------------------------------------------------------------
function auth:logIn(user,pass)
	db:open()
	self.sql=[[select id_user,password as pass, fullname, admin
			from users
		  where username=%s and status=true]]
	local result, err = db:get_rows(self.sql,user)
	db:close()
	if ( not result ) then
		return false, err
	end
	if (result[1] and self:checkPass(pass,result[1]['pass'])) then
		self.id_user  = result[1]['id_user']
		self.fullname = result[1]['fullname']
		self.is_admin = util:is_true(result[1]['admin'])
		self.username = user
		return self:key('login')
	end
	return false, gettext('User or password invalid')
end


------------------------------------------------------------------------
--- Retorna true si es admin
-- @param id_user el id_del usuario
-- @return boolean true en caso de admin, false en caso contrario
------------------------------------------------------------------------
function auth:isAdmin(id_user)
	db:open()
	self.sql=[[select admin from users where id_user=%d]]
	local admin, err = db:get_var(self.sql,id_user)
	db:close()
	if ( not admin ) then
		return false, err
	end
	return util:is_true(admin)
end

------------------------------------------------------------------------
--- Retorna true si la sesion es valida y el usuario esta efectivamente
-- logeado
-- @return boolean
------------------------------------------------------------------------
function auth:isLogged()
	return self:sessionIsValid()
end

------------------------------------------------------------------------
--- Verificar una palabra de texto simple contra un hash
-- @param plaintext String con la frase
-- @param pwhash    String con la frase cifrada
-- @return  boolean
------------------------------------------------------------------------
function auth:checkPass(plaintext, pwhash)
	--@see  https://github.com/jprjr/lua-crypt
	return crypt.check(plaintext, pwhash)
end

------------------------------------------------------------------------
--- Este metodo cierra la sesion
-- @return boolean
------------------------------------------------------------------------
function auth:logOut()
	return self:key('exit')
end

------------------------------------------------------------------------
--- Este metodo establece un nuevo valor ser usado como CSRF
------------------------------------------------------------------------
function auth:setCsrf()
	SESSION[self.KEY_CSRF or 'csrf'] = crypt.encrypt(
		'sha256',
		common:random_hash(64),
		common:random_hash(64)
	)
	session:save()
end

------------------------------------------------------------------------
--- Este metodo retorna el CSRF actual
------------------------------------------------------------------------
function auth:getCsrf()
	return SESSION[self.KEY_CSRF or 'csrf']
end

------------------------------------------------------------------------
--- Este metodo Valida/Verifica el CSRF
------------------------------------------------------------------------
function auth:csrfIsValid(csrf)
	return crypt.check(self:getCsrf(),crypt.encrypt(
		'sha256',
		csrf,
		common:random_hash(64)
	))
end


return auth
