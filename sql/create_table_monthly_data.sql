use beat;

CREATE TABLE if not exists monthly_data 
(
series_code varchar(32) not null,
release_date date,
point_month int not null check(month > 0 and month < 13),
point_year int not null check(year > 0 and year < 9999),
point_value decimal(10,10),
primary key(series_code,point_month,point_year),
foreign key(series_code) references series_list(series_code)
);
