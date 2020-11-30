
https://hub.docker.com/u/kobainjp/content/sub-57ca2017-7067-462b-adcc-0787abf73287

docker pull store/oracle/database-enterprise:12.2.0.1

https://qiita.com/KenjiOtsuka/items/97517fdd3406627cf8a7

docker run -it --name oracle-db -p 1521:1521 -p 5500:5500 store/oracle/database-enterprise:12.2.0.1 -d

sqlplus /nolog
