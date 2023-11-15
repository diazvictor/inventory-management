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
-- MySQL Luachi.
-- Esta clase de abstracción de base de datos contiene metodos para
-- la manipulacion facil de MySQL
-- @classmod mysql
-- @author Díaz Urbaneja Víctor Eduardo Diex <diazvictor@tutamail.com>
-- @license GPL
-- @copyright 2023 Díaz Urbaneja Víctor Eduardo Diex (diazvictor)
------------------------------------------------------------------------

local db 	=  class('db')
local mysql	= require('luasql.mysql').mysql()

function db:open(dbname, user, pass, host, port)
	self.db, err = mysql:connect(dbname, user, pass, host, port)
	if (self.db) then
		return true
	end
	return false, err
end

--- Retorna todo el objeto db
function db:raw()
    return self.db
end

--- Cierra la conexion de la db
function db:close()
    self.db:close()
end

-- Esta función retorna las columnas de una tabla en una función
local function get_rows(conn, sql)
	local results, err = conn:execute(sql)
	if not results then
		return false, err
	end
	return function ()
		return results:fetch({}, 'a')
	end
end

------------------------------------------------------------------------
--- Ejecuta un query
-- @param sql el query a ser ejecutado-- @return mixed: true si fue exitoso, el msg de error en caso contrario
------------------------------------------------------------------------
function db:exec(sql)
	local result, err = self.db:execute(sql)
	if (result) then
		return true
	end
	return false, err
end

------------------------------------------------------------------------
--- Esta funcion retorna el ultimo rowid de la mas reciente
-- sentencia 'INSERT into' en la base de datos.
-- @return integer: el ultimo rowid
------------------------------------------------------------------------
function db:last_insert_rowid()
	return self.db:getlastautoid()
end

------------------------------------------------------------------------
--- Ejecuta una consulta y retorna toda la data en una tabla
-- @param sql string: el query a ser ejecutado
-- @return table: las columnas con el resultado
------------------------------------------------------------------------
function db:get_results(sql)
	local rows = {}
	local results, err = get_rows(self.db, sql)
	if not results then
		return false, err
	end
	for row in results do
		table.insert(rows, row)
	end
	return rows
end

------------------------------------------------------------------------
--- retorna una version limpia y desinfectada de la entrada
-- @param str string
-- @return string: la entrada escapada
------------------------------------------------------------------------
function db:escape(str)
	if (type(str) == 'number' ) then
		return str
	end
	return self.db:escape(str)
end

return db
