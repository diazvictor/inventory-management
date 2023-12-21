--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--

local clients =	class('clients')

function clients:get_clients()
	db:open()
	self.sql = 'select * from clients'
	self.data = {}
	local results = db:get_results(self.sql)
	db:close()
	for i, result in pairs(results) do
		table.insert(self.data,{
			username = result.username
		});
	end
	return self.data
end

return clients
