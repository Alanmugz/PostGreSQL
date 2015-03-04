

drop table test;

CREATE TABLE test
(
  id integer NOT NULL,
  json jsonb,
  CONSTRAINT "PK_Test" PRIMARY KEY (id)
)

INSERT INTO test (id, json)
SELECT x.id, '{
	       "_id": "54f5ca1067fd4211c7211d45",
	       "index": 0,
	       "friends": [
		       {
			"id": 0,
			"name": "Watts Morrison"
		       },
		       {
			"id": 1,
			"name": "Marcella Wilder"
		       },
		       {
			"id": 2,
			"name": "Terry Willis"
		       }
	          ]
	       }'::jsonb
FROM generate_series(1,1) AS x(id);

INSERT INTO test (id, json)
SELECT 7, '{
			"lookup_id": "dd20a605-5462-4ee2-86f6-eeae74931204",
			"service_type": "ABC",
			"metadata": "sampledata2",
			"matrix": [
					{
						"payment_selection": "unselected",
						"offer_currencies": [
							{
								"currency_name": "Euro",
								"value": 123.45
							}
						]
					},
					{
						"payment_selection": "selected",
						"offer_currencies": [
							{
								"currency_name": "Euro",
								"value": 123.45
							}
						]
					}
				]
			}'::jsonb

select * from test where json ? 'friends' -> 2;

SELECT json FROM test WHERE json @> '{"index": 0}';
SELECT json FROM test WHERE json <@ '{"index": 0}';

SELECT * FROM test WHERE json ? 'index';
SELECT * FROM test WHERE json ?| array['xc', 'friends'];
SELECT * FROM test WHERE json ?& array['index','friends','_id'];

SELECT * FROM test WHERE json ->> 'index' > '1';
SELECT * FROM test WHERE json -> 'index' = '0';

SELECT * FROM test WHERE json -> 'friends' -> 'id' = '0';


select element ->> 'id'
from test t, jsonb_array_elements(t.json -> 'friends') AS element
where element ->> 'name' = 'Alan Mulligan';

select json -> 'friends'
from test t, jsonb_array_elements(t.json -> 'friends') AS element
where element ->> 'name' = 'Alan Mulligan';



SELECT element -> 'offer_currencies' -> 0 -> 'value'
FROM   test t, jsonb_array_elements(t.json -> 'matrix') AS element
WHERE  element ->> 'payment_selection' = 'mc'

SELECT element -> 'offer_currencies' -> 0
FROM   test t, jsonb_array_elements(t.json -> 'matrix') AS element
WHERE  element ->> 'payment_selection' = 'mc'

SELECT element -> 'offer_currencies'
FROM   test t, jsonb_array_elements(t.json -> 'matrix') AS element
WHERE  element ->> 'payment_selection' = 'mc'

SELECT element
FROM   test t, jsonb_array_elements(t.json -> 'matrix') AS element
WHERE  element ->> 'payment_selection' = 'mc'

SELECT first_currency.*
FROM   test t,
       jsonb_array_elements(t.json -> 'matrix') element,
       jsonb_each_text(element -> 'offer_currencies' -> 0) AS first_currency
WHERE  element ->> 'payment_selection' = 'mc'
 

select '{"a":"abc","d":"def","z":[1,2,3],"d":"overwritten"}'::jsonb -> 'z' -> 2;

create index idx on test using gin (json);
drop index idx;

explain analyze select * from test where json ? 'age';