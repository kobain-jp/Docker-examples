### 参考

https://crudzoo.com/blog/docker-postgres
https://hub.docker.com/_/postgres/

###　他のアプリからの接続

connect from app/db browser
Host: localhost
Port: 5433
Database: admin
User: admin
Password: admin

// root は postgres

docker exec [container_id or name] pg_dumpall -U postgres > dump.sql
e.g docker exec docker-examples_postgre-example_1 pg_dumpall -U user > dump.sql

import dump.sql

cat dump.sql | docker exec -i docker-examples_postgre-example_1 psql -U admin
e.g dump.sql | docker exec -i docker-examples_postgre-example_1 psql -U [user name]


上記の dump.sqlをdocker-entrypoint-initdb.dにいれるだけ。

他の環境からimportする方法


Postgreの情報
SELECT version()

パラメータ
SELECT name, setting FROM  pg_settings  where name ='max_connections' 