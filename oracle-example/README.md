
https://hub.docker.com/u/kobainjp/content/sub-57ca2017-7067-462b-adcc-0787abf73287

https://qiita.com/KenjiOtsuka/items/97517fdd3406627cf8a7

// container作成　＋　起動
docker run -it -d --name oracle-db -p 1521:1521 -p 5500:5500 store/oracle/database-enterprise:12.2.0.1 

// データのマウント
cd oracle-example
docker run -it -d --name oracle-db -p 1521:1521 -p 5500:5500 store/oracle/database-enterprise:12.2.0.1 -v ./data:/ORCL

// container起動
docker start oracle-db

// container内に入る
docker exec -it oracle-db /bin/bash

// sqlplus起動
sqlplus /nolog

// sysdbaとして接続します。
SQL> conn sys/Oradoc_db1@ORCLCDB as sysdba

// ORCLPDB1にセッションを変更
SQL> alter session set container=ORCLPDB1;

// userを作成
SQL> create user developer identified by developer;

// sessionを作り、データベースに接続を許可するシステム権限を付与する
SQL> grant create session to developer;

// テーブル作成権限
SQL> grant create table to developer;

SQL> grant create sequence to developer;

SQL> alter user developer quota unlimited on USERS;

// 作成した接続に接続
SQL> conn developer/developer@127.0.0.1/rclopdb1.localdomain   
SQL> conn developer2/developer2@127.0.0.1/rclopdb1.localdomain   

テーブル作成
SQL> CREATE TABLE book(book_id NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY, isbn NUMBER, title NVARCHAR2(50), author NVARCHAR2(50), release_date DATE);

SQL> INSERT INTO book(title, isbn,  author, release_date) VALUES ('SLAM DUNK 1',9784088716114,'井上雄彦',TO_DATE('1991/02/08','yyyy/mm/dd'));
SQL> INSERT INTO book(title, isbn,  author, release_date) VALUES ('SLAM DUNK 2',9784088716121,'井上雄彦',TO_DATE('1991/06/10','yyyy/mm/dd'));
SQL> INSERT INTO book(title, isbn,  author, release_date) VALUES ('リアル 1',9784088761435,'井上雄彦',TO_DATE('2001/03/19','yyyy/mm/dd'));


mkdir /u01/app/dmpdir/

ディレクトリ作成 dp_dir
SQL> conn sys/Oradoc_db1@ORCLCDB as sysdba

SQL> alter session set container=ORCLPDB1;

SQL> CREATE OR REPLACE DIRECTORY dp_dir AS '/u01/app/dp_dir';

SQL> GRANT READ,WRITE ON DIRECTORY dp_dir TO developer

https://oracle-chokotto.com/ora_import_impdp.html

スキーマ単位　エクスポート
expdp developer/developer@127.0.0.1/orclpdb1.localdomain directory=dp_dir schemas=developer;

スキーマ単位　インポート
impdp developer/developer@127.0.0.1/orclpdb1.localdomain schemas=developer directory=dp_dir table_exists_action=replace dumpfile=expdat.dmp 


別スキーマへインポート
create user developer2

impdp developer2/developer2@127.0.0.1/orclpdb1.localdomain schemas=developer directory=dp_dir table_exists_action=replace dumpfile=expdat.dmp remap_schema=developer:developer2

docker exec oracle-db pg_dumpall -U [user name] > dump.sql

azu
https://twitter.com/azu_re



