use beat;

LOAD DATA INFILE '/tmp/quote_data.csv'
INTO TABLE quote_data 
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(series_id,@point_date,open_value,high_value,low_value,close_value,volume_value)
SET point_date = STR_TO_DATE(@point_date, '%d/%m/%Y');