/**!
 * @package   Test MySQL
 * @filename  01-people.sql
 * @version   1.0
 * @autor     Díaz Urbaneja Víctor Eduardo Diex <diazvictor@tutamail.com>
 * @date      14.11.2023 10:39:12 -04
 */

drop table if exists users;
create table users (
    id_user 	int not null auto_increment,
    name 		varchar(50),
    email		varchar(50),
    primary key (id_user)
);

insert into users (name, email) values
('Jose das Couves', 'jose@couves.com'),
('Manoel Joaquim', 'manoel.joaquim@cafundo.com'),
('Maria das Dores', 'maria@dores.com')
