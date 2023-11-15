local cURL = require ("cURL")


local url	= 'http://luachi.com.me/users'
local cookies 	= '/tmp/cookies.txt'
local user,pass	= 'vitronic','vitronic'


c = cURL.easy_init()
c:setopt(cURL.OPT_URL,url)
c:setopt(cURL.OPT_HTTPAUTH,1)
c:setopt(cURL.OPT_USERPWD, ('%s:%s'):format(user,pass) )
c:setopt(cURL.OPT_COOKIEJAR,  cookies)
c:setopt(cURL.OPT_COOKIEFILE, cookies)
c:perform()
c:close()
