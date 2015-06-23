
CREATE TABLE if not exists requests 
(	
id serial not null,
sname varchar(32) not null,
provider varchar(32) not null,
type varchar(32) not null,
status varchar(32) not null,
args varchar(128),
owner varchar(32),
lastchange timestamp not null default current_timestamp,
primary key(id)
);

CREATE OR REPLACE FUNCTION update_lastchange_column()
RETURNS TRIGGER AS $$
BEGIN
	NEW.lastchange = now();
	RETURN NEW;
END;
$$ language 'plpgsql';


CREATE TRIGGER update_requests_lastchange BEFORE UPDATE
ON requests FOR EACH ROW EXECUTE PROCEDURE
update_lastchange_column();
