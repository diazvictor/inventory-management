--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--

local base64 = require('vendor.base64')
local login_successful 	= false

if ( ENV.REQUEST_METHOD == 'POST' and FORM['logIn'] == 'true' ) then
	local username, password = FORM['username'], FORM['password']
    auth.session_persistent  = util:is_true(FORM['session_persistent'])
	local ok,msg = auth:logIn(username,password)
	if( util:is_true(conf.luachi.logger) )then
        util:logfile(('LOGIN %s'):format(msg))
	end
	if ( not ok ) then
		view:add_message(msg)
	else
		router.module = router:set_module(router.path)
		--Añado la informacion del path
		router.pathinfo = util:split(router.module,'/')
		--Determino los parametros y los seteo en la tabla parameters
		router.parameters = router:set_parameters(router.path,router.pathinfo)
		login_successful = true
	end
end

--Autorizacion basica
if ( ENV['HTTP_AUTHORIZATION'] ) then
	local authorization = util:split(ENV['HTTP_AUTHORIZATION'],' ')
	local method, _auth = authorization[1],authorization[2]
	if ( (method == "Basic") and base64.decode(_auth) ~= nil ) then
		_auth = base64.decode(_auth)
		local credentials = util:split(_auth,':')
		local username, password = credentials[1], credentials[2]
		local ok, msg = auth:logIn(username,password)
        if( util:is_true(conf.luachi.logger) )then
            util:logfile(('HTTP_AUTHORIZATION %s'):format(msg))
        end
		if ( ok ) then
			router.module = router:set_module(router.path)
			login_successful = true
		end
	end
end

if ( login_successful ) then
	if (router.module ~= conf.luachi.login_module)then
		--Añado la informacion del path
		router.pathinfo = util:split(router.module,'/')
		--Determino los parametros y los seteo en la tabla parameters
		router.parameters = router:set_parameters(router.path,router.pathinfo)

		--incluyo el modelo
		file=files:exists(('%s/../models/%s.lua'):format(root,router.module))
		if (file) then
			model = require(('models.%s'):format(router.module));
		end

		--incluyo el controlador
		file=files:exists(('%s/../controllers/%s.lua'):format(root,router.module))
		if (file) then
			controller = require(('controllers.%s'):format(router.module));
			controller:execute();
		end
		--el controlador no hace falta, salgo aqui
		os.exit()
	end
end
