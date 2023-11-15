--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--

local home	=	class('home')
local sql	=	nil
local data	=	{}

function home:get_users()
	db:open()
	self.sql = "select * from users"
	self.data = {}
	local results = db:get_results(self.sql)
	db:close()
	for _, result in pairs(results) do
		table.insert(self.data, {
			id_user = result.id_user,
			name = result.name,
			email = result.email
		})
	end
	return self.data
end

function home:get_user(id_user)
	db:open()
	self.sql = "select name, email from users where id_user = %s"
	local results, err = db:get_rows(self.sql, id_user)
	db:close()

	if not results then
		return false, err
	end

	self.data = {}
	for _, result in pairs(results) do
		self.data['id_user'] = id_user
		self.data['name'] = result.name
		self.data['email'] = result.email
	end

	return self.data
end

function home:save_ok(post)
	if post["name"] == "" then
		return false, { "Ingrese el nombre" }
	elseif post["email"] == "" then
		return false, { "Ingrese el correo" }
	end
	return true
end

function home:save(post)
	local update, values = false, {}
	local ok, err = self:save_ok(post)
	if not ok then
		return false, err
	end

	if post and tonumber(post["id_user"]) then
		update = true
	end
	values = {
		post['name'],
		post['email']
	}
	db:open()
	if not update then
		self.sql = "insert into users (name, email) values (%s, %s)"
	else
		self.sql = [[
			update users
				set name = %s, email = %s
			where id_user = %d;
		]]
		table.insert(values, post['id_user'])
	end
	ok, err = db:execute(self.sql, values)
	if not ok then
		return false, err
	end
	db:close()
	return true
end

return home
