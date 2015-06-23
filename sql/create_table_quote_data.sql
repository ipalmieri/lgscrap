use beat;

CREATE TABLE if not exists quote_data 
(
series_id int(12) not null,
point_date date not null,
open_value float,
high_value float,
low_value float,
close_value float,
volume_value float,
primary key(series_id,point_date),
foreign key(series_id) references series_list(series_id)
);
