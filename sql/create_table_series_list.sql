use beat;

CREATE TABLE if not exists series_list
(
id int(12) unsigned not null auto_increment,
series_code varchar(32) not null unique,
series_type varchar(32) not null,
last_updated date, 
last_checked date,
series_status varchar(32) not null,
primary key(id)
);

