--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--
local files		= class('files');

------------------------------------------------------------------------
-- Files Luachi.
-- Esta clase contiene los metodos para la manipulacion de
-- archivos en Luachi
-- @classmod files
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
------------------------------------------------------------------------


---Verifica si un archivo existe
function files:exists(path)
	if not path then
		return false
	end
	local file = io.open(path, 'rb')
	if file then
		file:close()
	end
	return file ~= nil
end

---Lee un archivo y retorna su contenido
function files:read(path, mode)
	mode = mode or '*a'
	local file, err = io.open(path, 'rb')
	if err then
		return false, err
	end
	local content = file:read(mode)
	file:close()
	return content
end

---Escribe un archivo
function files:write(path, content, mode)
	mode = mode or 'w'
	local file, err = io.open(path, mode)
	if err then
		return false, err
	end
	file:write(content)
	file:close()
end

---Copia un archivo a un destino
function files:copy(src, dest, safe)
	--Verifico que el fuente exista
	if (  not self:exists(src)  ) then
		return false, gettext('source file not exists')
	end

	--Si la bendera safe esta presente, verifico si
	--el archivo existe, si este es el caso, retorno false
	if safe then
		if ( self:exists(dest) ) then
			return false, gettext('file alredy exists')
		end
	end

	local content = self:read(src)
	self:write(dest, content)
	return true
end

---Mueve un archivo a un destino en el sistema de ficheros
function files:move(src, dest, safe)
	--Si la bendera safe esta presente, verifico si
	--el archivo existe, si este es el caso, retorno false
	if safe then
		if ( self:exists(dest) ) then
			return false, gettext('file alredy exists')
		end
	end

	if (self:exists(src)) then
		os.rename(src, dest)
	end

	return true
end

---Remueve un archivo del sistema de ficheros
function files:remove(path)
	if (self:exists(path)) then
		os.remove(path)
	end
end

---Retorna el tamaño de un archivo
function files:get_size(file)
	if ( self:exists(file) ) then
		local fd, err	= io.open(file,'r')
		if not fd then
			return false, err
		end
		local size	= fd:seek('end')
		fd:close()
		return size
        end
        return false, gettext('source file not exists')
end

---Retorna el path del archivo cargado
function files:uploaded_file_path()
	return self.file_path
end

---Retorna una tabla con los archivos permitidos para subir
function files:allowed_uploads()
	return util:split(conf.security.allowed_uploads ,'|')
end

---Retorna la extenxion de un archivo
function files:extension(file)
    file = file:lower()
    local tar = file:match('%.(tar%.[^.]+)$')
    if tar then
        return tar
    end
    return file:match('%.([^.]+)$')
end

---Mueve el archivo suvido a un directorio de destino
function files:move_uploaded_file(dest, src, safe)
	local src = src or self:uploaded_file_path()
	local valid = false
	if ( self:exists(src) ) then

		--La extension del archivo subido
		local ext = self:extension(self.file_name)
		--Valído contra la lista de permitidos en la config
		for _,allowed in pairs(self:allowed_uploads()) do
			if ( ext == allowed ) then
				--Es valido!
				valid = true
				break
			end
		end

		--Validacion del tipo de archivo permitido
		if ( not valid ) then
			return false, gettext('file not allowed')
		end

		--Validacion del tamaño del archivo subido
		local max_size = tonumber(conf.security.max_size_upload)
		if ( self:get_size(src) > max_size ) then
			return false, gettext('file size not allowed')
		end

		local result, err = self:move(src, dest, safe)
		if not result then
			return false, err
		end
		return true
	end
	return false, gettext('source file not exists')
end

return files
