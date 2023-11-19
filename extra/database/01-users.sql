/**!
 * @package   Inventory Management
 * @filename  01-users.sql
 * @version   1.0
 * @autor     Díaz Urbaneja Víctor Eduardo Diex <diazvictor@tutamail.com>
 * @date      14.11.2023 10:39:12 -04
 */

drop table if exists users;
create table users (
    id_user 	int not null auto_increment,
    fullname	varchar(16) not null,
    username	varchar(16) not null,
    password	char(128) not null,
    avatar		varchar(200),
    admin	  	boolean not null default false,
    status		boolean not null default true,
    primary key (id_user)
);

insert into users
	(fullname, username, password, admin)
values
	('Víctor Díaz', 'diazvictor', '$5$R21bDnsnhz2$hyQolrqmcnwLuw5quQuLrFiUui3.fruGGyRU1VKYkI5', true)
