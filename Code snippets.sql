
drop table test;

create table test(id int, json jsonb);

INSERT INTO test (id, json)
SELECT x.id, '{"a":"abc","d":"def","z":[1,2,3]}'::jsonb
FROM generate_series(1,100000) AS x(id);

create index idx on test using gin (json);

explain analyze select * from test where json ? 'r';