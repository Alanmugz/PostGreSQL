
--JsonB Example Queries

SELECT * 
FROM   test 
WHERE  json ? 'friends' -> 2;

SELECT json 
FROM   test 
WHERE  json @> '{"index": 0}';

SELECT json 
FROM   test 
WHERE  json <@ '{"index": 0}';

SELECT * 
FROM   test 
WHERE  json ? 'index';

SELECT * 
FROM   test 
WHERE  json ?| array['xc', 'friends'];

SELECT * 
FROM   test 
WHERE  json ?& array['index','friends','_id'];

SELECT * 
FROM   test 
WHERE  json ->> 'index' > '1';

SELECT * 
FROM   test 
WHERE  json -> 'index' = '0';

SELECT * 
FROM   test 
WHERE  json -> 'friends' -> 'id' = '0';

SELECT element ->> 'id'
FROM   test t, jsonb_array_elements(t.json -> 'friends') AS element
WHERE  element ->> 'name' = 'Alan Mulligan';

SELECT json -> 'friends'
from   test t, jsonb_array_elements(t.json -> 'friends') AS element
WHERE  element ->> 'name' = 'Alan Mulligan';

SELECT element -> 'offer_currencies' -> 0 -> 'value'
FROM   test t, 
       jsonb_array_elements(t.json -> 'matrix') AS element
WHERE  element ->> 'payment_selection' = 'mc'

SELECT element -> 'offer_currencies' -> 0
FROM   test t, 
       jsonb_array_elements(t.json -> 'matrix') AS element
WHERE  element ->> 'payment_selection' = 'mc'

SELECT element -> 'offer_currencies'
FROM   test t, 
       jsonb_array_elements(t.json -> 'matrix') AS element
WHERE  element ->> 'payment_selection' = 'mc'

SELECT element
FROM   test t, 
       jsonb_array_elements(t.json -> 'matrix') AS element
WHERE  element ->> 'payment_selection' = 'mc'

SELECT offer.*
FROM   test t,
       jsonb_array_elements(t.json -> 'matrix') element,
       jsonb_each_text(element -> 'offer_currencies' -> 3) AS offer
WHERE  element ->> 'payment_selection' = 'unselected'

SELECT length 
FROM   test t,
       jsonb_array_elements(t.json -> 'matrix') element,
       jsonb_array_length(element -> 'offer_currencies') AS length
WHERE  element ->> 'payment_selection' = 'vb'

SELECT typeOf
FROM   test t, 
       jsonb_array_elements(t.json -> 'matrix') AS element,
       jsonb_typeof(element -> 'offer_currencies' -> 0 -> 'currency_name') AS typeOf
WHERE  element ->> 'payment_selection' = 'mc'

SELECT id, json -> 'lookup_id'
FROM   test

create index idx on test using gin (json);
drop index idx;

explain analyze select * from test where json ? 'age';

SELECT element -> 'offer_currencies' -> 0 -> 'value'
FROM   test t, 
       jsonb_array_elements(t.json -> 'matrix') AS element
WHERE  element ->> 'payment_selection' = 'mc'

SELECT element -> 'offer_currencies' -> 0
FROM   test t, 
       jsonb_array_elements(t.json -> 'matrix') AS element
WHERE  element ->> 'payment_selection' = 'mc'

SELECT element -> 'offer_currencies'
FROM   test t, 
       jsonb_array_elements(t.json -> 'matrix') AS element
WHERE  element ->> 'payment_selection' = 'mc'

SELECT element
FROM   test t, 
       jsonb_array_elements(t.json -> 'matrix') AS element
WHERE  element ->> 'payment_selection' = 'mc'

SELECT offer.*
FROM   test t,
       jsonb_array_elements(t.json -> 'matrix') element,
       jsonb_each_text(element -> 'offer_currencies' -> 3) AS offer
WHERE  element ->> 'payment_selection' = 'unselected'

SELECT length 
FROM   test t,
       jsonb_array_elements(t.json -> 'matrix') element,
       jsonb_array_length(element -> 'offer_currencies') AS length
WHERE  element ->> 'payment_selection' = 'vb'

SELECT typeOf
FROM   test t, 
       jsonb_array_elements(t.json -> 'matrix') AS element,
       jsonb_typeof(element -> 'offer_currencies' -> 0 -> 'currency_name') AS typeOf
WHERE  element ->> 'payment_selection' = 'mc'

explain analyze
SELECT json -> 'service_type'
FROM   test
WHERE  json @> '{"lookup_id": "4c685bb5-4424-4e02-996d-405248960a07"}';

create index idx on test using gin (json);

SELECT json -> 'service_type'
FROM   test t, 
       jsonb_array_elements(t.json -> 'matrix' -> 0 -> 'offer_currencies') AS element
WHERE  element @> '{"value": 2446.52}';

EXPLAIN ANALYZE
SELECT element -> 'offer_currencies' -> 0
FROM   test t, 
       jsonb_array_elements(t.json -> 'matrix') AS element,
       jsonb_array_elements(element -> 'offer_currencies') AS element2
WHERE  element ->> 'payment_selection' = 'mc' AND element2 @> '{"currency_code": "EUR"}'
LIMIT  1

drop index idx

CREATE INDEX idx ON test USING gin ((json -> 'matrix'));



-- Inheritance

CREATE TABLE cities (
  name       text,
  population numeric
);

CREATE TABLE capitals (
  country   text
) INHERITS (cities);

INSERT INTO capitals(country, name, population)
VALUES('Ireland', 'Dublin', 1500000);

INSERT INTO cities(name, population)
VALUES('Cork', 800000);

SELECT * FROM capitals;
SELECT * FROM cities;

SELECT * FROM only cities
WHERE "population" > 8000;

SELECT * FROM only capitals
WHERE "population" > 8000;

-- Working with Arrays

CREATE TABLE time (name text,stage_time decimal[][]);
INSERT INTO time VALUES ('Kris Meeke', '{{236.3, 10.0}, {845.9, 15.0}, {236.3, 0.0}, {845.9, 15.0}}');

UPDATE time SET stage_time[5][1] = 256.0;
UPDATE time SET stage_time[5][2] = 30.0;

update time
set stage_time = stage_time || '{236.3, 10.0}';

SELECT (stage_time[1:5]) AS s FROM time WHERE name = 'Kris Meeke';

SELECT stage_time[1][2] FROM time;

CREATE OR REPLACE FUNCTION stage() RETURNS integer AS '
    SELECT 7 AS result;
' LANGUAGE SQL;

SELECT name, stage_time[stage()][1] AS Stage_Time, stage_time[stage()][2] AS Penalties, (SELECT SUM(s) FROM UNNEST(stage_time[1:stage()]) s) as Total from time;

CREATE OR REPLACE FUNCTION difference (finishTime timestamp, startTime timestamp, stage numeric)
RETURNS DECIMAL AS $total$
DECLARE
	total decimal;
BEGIN
   SELECT ((EXTRACT (epoch from (finishTime - startTime))))::DECIMAL INTO total;

   UPDATE time
   SET stage_time = stage_time || '{0.0, 0.0}';

   UPDATE time SET stage_time[stage][1] = 256.0;
   UPDATE time SET stage_time[stage][2] = 0.0;
   
   RETURN total;
END;
$total$ 
LANGUAGE plpgsql;

SELECT difference('2012-01-01 18:59:14.7', '2012-01-01 18:25:00.0', 7);

SELECT ((EXTRACT (epoch from ('2012-01-01 18:59:14.7'::TIMESTAMP - '2012-01-01 18:25:00.0'::TIMESTAMP))))::DECIMAL AS Stage_Time


