--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--

LUACHI_VERSION	= "0.1"
SESSION		= {}
SESSION_ID	= 'LUACHISESSID';
class       = require('vendor.middleclass');
root		= ENV.DOCUMENT_ROOT or (io.popen('pwd'):read('*l'));
files		= require("libraries.files");
json 		= require('cjson');
inifile		= require("vendor.inifile");
serialize	= require("vendor.serialize");
valid		= require("vendor.resty.validation");
util		= require("libraries.utils");
common		= require("libraries.common");
configuration	= require("libraries.configuration");
conf		= configuration:get_conf();
modules		= configuration:get_modules();
gettext		= require("vendor.gettext");
http		= require("libraries.http");
db		    = require("libraries.database.database");
router		= require("libraries.router");
session		= require("libraries.session");
session     : update();
borrow      = require("libraries.borrow");
auth		= require("libraries.auth");
view		= require("libraries.view");
