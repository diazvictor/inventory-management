local cURL = require("cURL")

local url	= 'http://luachi.com.me/users'
local url2	= 'http://luachi.com.me/download'
local cookies 	= '/tmp/cookies.txt'
local user,pass	= 'vitronic','vitronic'


--La data del formulario de iicio de sesion
local post = cURL.form()
	:add_content("logIn", "true")
	:add_content("username", user)
	:add_content("password", pass)


-- create first easy handle to do the login
c = cURL.easy()
	:setopt(cURL.OPT_URL, url)
	:setopt(cURL.OPT_COOKIEJAR,'/tmp/cookies.txt')
	:setopt(cURL.OPT_COOKIEFILE,'/tmp/cookies.txt')
	:setopt_verbose(true)
	:setopt_httppost(post)

-- create second easy handle to do the download
c2 = cURL.easy()
	:setopt(cURL.OPT_URL, url2)
	:setopt(cURL.OPT_COOKIEJAR,'/tmp/cookies.txt')
	:setopt(cURL.OPT_COOKIEFILE,'/tmp/cookies.txt')
	:setopt_verbose(true)

-- login
c:perform()
-- download
c2:perform()
