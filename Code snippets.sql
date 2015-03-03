

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
SELECT 2, '{
	       "_id": "54f5ca1067fd4211c7211d45",
	       "index": 2,
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

select * from test where json ? 'friends' -> 2;

SELECT json FROM test WHERE json @> '{"index": 0}';
SELECT json FROM test WHERE json <@ '{"index": 0}';

SELECT * FROM test WHERE json ? 'index';
SELECT * FROM test WHERE json ?| array['xc', 'friends'];
SELECT * FROM test WHERE json ?& array['index','friends','_id'];

SELECT * FROM test WHERE json ->> 'index' > '1';
SELECT * FROM test WHERE json -> 'index' = '0';

SELECT * FROM test WHERE json -> 'friends' -> 'id' = '0';

select '{"a":"abc","d":"def","z":[1,2,3],"d":"overwritten"}'::jsonb -> 'z' -> 2;

create index idx on test using gin (json);
drop index idx;

explain analyze select * from test where json ? 'age';