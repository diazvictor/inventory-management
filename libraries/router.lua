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
-- Enrutador Luachi.
-- Esta clase se encarga de enrutar los request HTTP
-- y actuar en consecuencia
-- @classmod router
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
------------------------------------------------------------------------

local router	= class('router')

------------------------------------------------------------------------
---Analiza la url y verifica que se trate de una peticion valida
-- si el modulo esta registrado, lo retorna junto con su ambito
-- @param path la url en formato path
-- @param pages los modulos regitrados en un ambito determinado
------------------------------------------------------------------------
local function module_exist(path,pages)
	local url  = util:split(path,'/')
	local _mod, scope = nil, nil
	for _,line in pairs(pages) do
		local page  = util:split(line,'/')
		local match = true

		local i = 0
		for v = #page,1,-1 do
			i = (i+1)
			if ( page[i] ~= url[i] ) then
				match = false
				break
			end
		end

		if not _mod then _mod='' end
		if ( match ) then
			if ( (line:len() >= _mod:len()) ) then
				--print( line ,line:len(), _mod, _mod:len() )
				_mod = line
			end
		end
	end

	if (_mod) then
		for _scope,_ in pairs(modules) do
			--Verifico el ambito del modulo
			for index, _mod_ in pairs(modules[_scope]) do
				if ( _mod_ == _mod ) then
					scope = _scope
					break
				end
			end
		end
	end

	return _mod, scope
end

------------------------------------------------------------------------
---Determina si se trata de un modulo valido y actua en consecuencia
-- @param path la url en formato path
------------------------------------------------------------------------
function router:set_module(path)
	local scope,_module = nil

	--Si no hay modulo, al modulo de inicio
	if ( path == '' or path == nil ) then
		self.module = conf.luachi.default_public
		return
	end

	--Verifico el ambito del modulo
	for _scope,_ in pairs(modules) do
		_module,scope = module_exist(path,modules[_scope])
		if (scope) then break end
	end

	if ( not scope or not _module ) then
		self.module = conf.luachi.error_module
		return
	end

	--Procedo segun sea el caso
	if ( scope ) then
		if (scope == 'private') then
			--El modulo es privado, verifico la credencial
			local sessionIsValid = auth:sessionIsValid()
			if ( sessionIsValid ) then
				self.module = _module
			else
				-- lo mando al modulo de login
				self.module = conf.luachi.login_module
			end
		else
			--El modulo es publico
			self.module = _module
		end
	end
	return _module
end

------------------------------------------------------------------------
---Registra los parametros de un modulo
-- @param path la tabla con la informacion del path
-- @param pathinfo la url en formato path
------------------------------------------------------------------------
function router:set_parameters(path,pathinfo)
	local tmp_params = util:split(path,'/')
	for i,p in pairs(tmp_params) do
		for _,v in pairs(pathinfo) do
			if (p==v) then
				tmp_params[i] = nil
			end
		end
	end
	local parameters= {}
	for index,value in pairs(tmp_params) do
		table.insert(parameters,value)
	end
	return parameters
end

------------------------------------------------------------------------
---Intercepta la peticion y retorna la ruta apropiada en consecuencia
-- @return el nombre del modulo segun el request
------------------------------------------------------------------------
function router:route()
	local url  = util:split(ENV.REQUEST_URI or ENV.QUERY_STRING or ENV.PATH_INFO or '/','/')
	self.path  = table.concat(url, "/")

	--Seteo el nombre del modulo
	self:set_module(self.path)

	--Añado la informacion del path
	self.pathinfo = util:split(self.module,'/')

	--Determino los parametros y los seteo en la tabla parameters
	self.parameters = self:set_parameters(self.path,self.pathinfo)

	--debugger
	if( util:is_true(conf.luachi.logger) and ENV.REMOTE_ADDR and ENV.HTTP_USER_AGENT) then
		local msg if (path==nil or path=='') then msg='/' else msg=path end
		util:logfile(('GET %s %s %s'):format(msg,ENV.REMOTE_ADDR,ENV.HTTP_USER_AGENT))
	end

	return self.module
end

return router
