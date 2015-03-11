
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




