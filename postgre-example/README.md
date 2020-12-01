
https://crudzoo.com/blog/docker-postgres
https://hub.docker.com/_/postgres/

connect from app/db browser
Host: localhost
Port: 5433
Database: admin
User: admin
Password: admin

export dump.sql

docker exec [container_id or name] pg_dumpall -U [user name] > dump.sql
e.g docker exec docker-examples_postgre-example_1 pg_dumpall -U user > dump.sql

import dump.sql

cat dump.sql | docker exec -i docker-examples_postgre-example_1 psql -U admin
e.g dump.sql | docker exec -i docker-examples_postgre-example_1 psql -U [user name]