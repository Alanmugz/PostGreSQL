

drop table test;

CREATE TABLE test
(
  id integer NOT NULL,
  json jsonb,
  CONSTRAINT "PK_Test" PRIMARY KEY (id)
)

INSERT INTO test (id, json)
11, '{
					"lookup_id": "c30055e5-97f8-4aa4-99d1-8522039eab83",
					"service_type": "MCM",
					"metadata": "sampledata2",
					"matrix": [
						{
							"payment_selection": "unselected",
							"offer_currencies": [
								{
									"display_order": 1,
									"currency_code": "EUR",
									"currency_name": "Euro",
									"currency_exponent": 2,
									"wholesale_exchange_rate": 1,
									"offer_exchange_rate": 1,
									"margin_percentage": 0,
									"value": 1446.52,
									"margin_value": 0
								},
								{
									"display_order": 2,
									"currency_code": "AUD",
									"currency_name": "Australian Dollar",
									"currency_exponent": 2,
									"wholesale_exchange_rate": 1.4612345,
									"offer_exchange_rate": 1.4612345,
									"margin_percentage": 0,
									"value": 496.84,
									"margin_value": 0
								},
								{
									"display_order": 3,
									"currency_code": "GBP",
									"currency_name": "Pound Sterling",
									"currency_exponent": 2,
									"wholesale_exchange_rate": 0.7512345,
									"offer_exchange_rate": 0.7512345,
									"margin_percentage": 0,
									"value": 2316.19,
									"margin_value": 0
								},
								{
									"display_order": 4,
									"currency_code": "USD",
									"currency_name": "US Dollar",
									"currency_exponent": 2,
									"wholesale_exchange_rate": 1.1312345,
									"offer_exchange_rate": 1.1312345,
									"margin_percentage": 0,
									"value": 2865.15,
									"margin_value": 0
								}
							]
						},
						{
							"payment_selection": "mc",
							"offer_currencies": [
								{
									"display_order": 1,
									"currency_code": "EUR",
									"currency_name": "Euro",
									"currency_exponent": 2,
									"wholesale_exchange_rate": 1,
									"offer_exchange_rate": 1,
									"margin_percentage": 0,
									"value": 1976.99,
									"margin_value": 0
								},
								{
									"display_order": 2,
									"currency_code": "AUD",
									"currency_name": "Australian Dollar",
									"currency_exponent": 2,
									"wholesale_exchange_rate": 1.4612345,
									"offer_exchange_rate": 1.5196839,
									"margin_percentage": 4,
									"value": 2454.66,
									"margin_value": 7.5
								},
								{
									"display_order": 3,
									"currency_code": "USD",
									"currency_name": "US Dollar",
									"currency_exponent": 2,
									"wholesale_exchange_rate": 1.1312345,
									"offer_exchange_rate": 1.1764839,
									"margin_percentage": 4,
									"value": 2618.87,
									"margin_value": 5.81
								}
							]
						},
						{
							"payment_selection": "vb",
							"offer_currencies": [
								{
									"display_order": 1,
									"currency_code": "EUR",
									"currency_name": "Euro",
									"currency_exponent": 2,
									"wholesale_exchange_rate": 1,
									"offer_exchange_rate": 1,
									"margin_percentage": 0,
									"value": 3998.54,
									"margin_value": 0
								},
								{
									"display_order": 2,
									"currency_code": "GBP",
									"currency_name": "Pound Sterling",
									"currency_exponent": 2,
									"wholesale_exchange_rate": 0.7512345,
									"offer_exchange_rate": 0.7737715,
									"margin_percentage": 3,
									"value": 1269.17,
									"margin_value": 2.87
								},
								{
									"display_order": 3,
									"currency_code": "USD",
									"currency_name": "US Dollar",
									"currency_exponent": 2,
									"wholesale_exchange_rate": 1.1312345,
									"offer_exchange_rate": 1.1651715,
									"margin_percentage": 3,
									"value": 892.85,
									"margin_value": 4.32
								}
							]
						}
					]
				}'::jsonb
FROM generate_series(1,1000) AS x(id);


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


CREATE INDEX idxgintag1 ON test USING gin ((json -> 'matrix'));
CREATE INDEX idxgintag1B ON test USING gin ((json -> 'matrix' -> 'payment_selection'));
CREATE INDEX idxgintag2 ON test USING gin ((json -> 'matrix' -> 'offer_currencies'));
CREATE INDEX idxgintags2 ON test USING gin ((json -> 'matrix' -> 0 -> 'offer_currencies' -> 'values'));


DELETE
FROM  test

INSERT INTO test (id, json)
SELECT x.id, '{
		"lookup_id":"3b685bb5-4424-4e02-996d-405248960a07",
		"service_type": "MCM",
		"metadata": "sampledata2",
		"matrix": [
			{
				"payment_selection": "unselected",
				"offer_currencies": [
					{
						"display_order": 1,
						"currency_code": "EUR",
						"currency_name": "Euro",
						"currency_exponent": 2,
						"wholesale_exchange_rate": 1,
						"offer_exchange_rate": 1,
						"margin_percentage": 0,
						"value": 1446.52,
						"margin_value": 0
					},
					{
						"display_order": 2,
						"currency_code": "AUD",
						"currency_name": "Australian Dollar",
						"currency_exponent": 2,
						"wholesale_exchange_rate": 1.4612345,
						"offer_exchange_rate": 1.4612345,
						"margin_percentage": 0,
						"value": 496.84,
						"margin_value": 0
					},
					{
						"display_order": 3,
						"currency_code": "GBP",
						"currency_name": "Pound Sterling",
						"currency_exponent": 2,
						"wholesale_exchange_rate": 0.7512345,
						"offer_exchange_rate": 0.7512345,
						"margin_percentage": 0,
						"value": 2316.19,
						"margin_value": 0
					},
					{
						"display_order": 4,
						"currency_code": "USD",
						"currency_name": "US Dollar",
						"currency_exponent": 2,
						"wholesale_exchange_rate": 1.1312345,
						"offer_exchange_rate": 1.1312345,
						"margin_percentage": 0,
						"value": 2865.15,
						"margin_value": 0
					}
				]
			},
			{
				"payment_selection": "mc",
				"offer_currencies": [
					{
						"display_order": 1,
						"currency_code": "EUR",
						"currency_name": "Euro",
						"currency_exponent": 2,
						"wholesale_exchange_rate": 1,
						"offer_exchange_rate": 1,
						"margin_percentage": 0,
						"value": 1976.99,
						"margin_value": 0
					},
					{
						"display_order": 2,
						"currency_code": "AUD",
						"currency_name": "Australian Dollar",
						"currency_exponent": 2,
						"wholesale_exchange_rate": 1.4612345,
						"offer_exchange_rate": 1.5196839,
						"margin_percentage": 4,
						"value": 2454.66,
						"margin_value": 7.5
					},
					{
						"display_order": 3,
						"currency_code": "USD",
						"currency_name": "US Dollar",
						"currency_exponent": 2,
						"wholesale_exchange_rate": 1.1312345,
						"offer_exchange_rate": 1.1764839,
						"margin_percentage": 4,
						"value": 2618.87,
						"margin_value": 5.81
					}
				]
			},
			{
				"payment_selection": "vb",
				"offer_currencies": [
					{
						"display_order": 1,
						"currency_code": "EUR",
						"currency_name": "Euro",
						"currency_exponent": 2,
						"wholesale_exchange_rate": 1,
						"offer_exchange_rate": 1,
						"margin_percentage": 0,
						"value": 3998.54,
						"margin_value": 0
					},
					{
						"display_order": 2,
						"currency_code": "GBP",
						"currency_name": "Pound Sterling",
						"currency_exponent": 2,
						"wholesale_exchange_rate": 0.7512345,
						"offer_exchange_rate": 0.7737715,
						"margin_percentage": 3,
						"value": 1269.17,
						"margin_value": 2.87
					},
					{
						"display_order": 3,
						"currency_code": "USD",
						"currency_name": "US Dollar",
						"currency_exponent": 2,
						"wholesale_exchange_rate": 1.1312345,
						"offer_exchange_rate": 1.1651715,
						"margin_percentage": 3,
						"value": 892.85,
						"margin_value": 4.32
					}
				]
			}
		]
	}'::jsonb
FROM generate_series(1,1000000) AS x(id);

INSERT INTO test (id, json)
VALUES(10000001, '{
	"lookup_id": "c30055e5-97f8-4aa4-99d1-8522039eab83",
	"service_type": "MCM",
	"metadata": "sampledata2",
	"matrix": [
		{
			"payment_selection": "unselected",
			"offer_currencies": [
				{
					"display_order": 1,
					"currency_code": "EUR",
					"currency_name": "Euro",
					"currency_exponent": 2,
					"wholesale_exchange_rate": 1,
					"offer_exchange_rate": 1,
					"margin_percentage": 0,
					"value": 1446.52,
					"margin_value": 0
				},
				{
					"display_order": 2,
					"currency_code": "AUD",
					"currency_name": "Australian Dollar",
					"currency_exponent": 2,
					"wholesale_exchange_rate": 1.4612345,
					"offer_exchange_rate": 1.4612345,
					"margin_percentage": 0,
					"value": 496.84,
					"margin_value": 0
				},
				{
					"display_order": 3,
					"currency_code": "GBP",
					"currency_name": "Pound Sterling",
					"currency_exponent": 2,
					"wholesale_exchange_rate": 0.7512345,
					"offer_exchange_rate": 0.7512345,
					"margin_percentage": 0,
					"value": 2316.19,
					"margin_value": 0
				},
				{
					"display_order": 4,
					"currency_code": "USD",
					"currency_name": "US Dollar",
					"currency_exponent": 2,
					"wholesale_exchange_rate": 1.1312345,
					"offer_exchange_rate": 1.1312345,
					"margin_percentage": 0,
					"value": 2865.15,
					"margin_value": 0
				}
			]
		},
		{
			"payment_selection": "mc",
			"offer_currencies": [
				{
					"display_order": 1,
					"currency_code": "JPY",
					"currency_name": "Euro",
					"currency_exponent": 2,
					"wholesale_exchange_rate": 1,
					"offer_exchange_rate": 1,
					"margin_percentage": 0,
					"value": 1976.99,
					"margin_value": 0
				},
				{
					"display_order": 2,
					"currency_code": "AUD",
					"currency_name": "Australian Dollar",
					"currency_exponent": 2,
					"wholesale_exchange_rate": 1.4612345,
					"offer_exchange_rate": 1.5196839,
					"margin_percentage": 4,
					"value": 2454.66,
					"margin_value": 7.5
				},
				{
					"display_order": 3,
					"currency_code": "USD",
					"currency_name": "US Dollar",
					"currency_exponent": 2,
					"wholesale_exchange_rate": 1.1312345,
					"offer_exchange_rate": 1.1764839,
					"margin_percentage": 4,
					"value": 2618.87,
					"margin_value": 5.81
				}
			]
		},
		{
			"payment_selection": "vb",
			"offer_currencies": [
				{
					"display_order": 1,
					"currency_code": "JPY",
					"currency_name": "Euro",
					"currency_exponent": 2,
					"wholesale_exchange_rate": 1,
					"offer_exchange_rate": 1,
					"margin_percentage": 0,
					"value": 3998.54,
					"margin_value": 0
				},
				{
					"display_order": 2,
					"currency_code": "GBP",
					"currency_name": "Pound Sterling",
					"currency_exponent": 2,
					"wholesale_exchange_rate": 0.7512345,
					"offer_exchange_rate": 0.7737715,
					"margin_percentage": 3,
					"value": 1269.17,
					"margin_value": 2.87
				},
				{
					"display_order": 3,
					"currency_code": "USD",
					"currency_name": "US Dollar",
					"currency_exponent": 2,
					"wholesale_exchange_rate": 1.1312345,
					"offer_exchange_rate": 1.1651715,
					"margin_percentage": 3,
					"value": 892.85,
					"margin_value": 4.32
				}
			]
		}
	]
}'::jsonb)

SELECT int4range '(10, 20]' @> 10;

