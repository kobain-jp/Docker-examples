
https://hub.docker.com/u/kobainjp/content/sub-57ca2017-7067-462b-adcc-0787abf73287

https://qiita.com/KenjiOtsuka/items/97517fdd3406627cf8a7

// container作成　＋　起動
docker run -it -d --name oracle-db -p 1521:1521 -p 5500:5500 store/oracle/database-enterprise:12.2.0.1 

// データのマウント 失敗
cd oracle-example
docker run -it -d --name oracle-db -p 1521:1521 -p 5500:5500 store/oracle/database-enterprise:12.2.0.1 -v $(pwd)/data:/ORCL

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
SQL> conn developer/developer@127.0.0.1/orclpdb1.localdomain   
SQL> conn developer2/developer2@127.0.0.1/rclopdb1.localdomain   

conn system/manager@127.0.0.1/orclpdb1.localdomain 


mkdir /u01/app/dmpdir/

ディレクトリ作成 dp_dir
SQL> conn sys/Oradoc_db1@ORCLCDB as sysdba

SQL> alter session set container=ORCLPDB1;

SQL> CREATE OR REPLACE DIRECTORY dp_dir AS '/u01/app/dp_dir';

SQL> GRANT READ,WRITE ON DIRECTORY dp_dir TO developer

https://oracle-chokotto.com/ora_import_impdp.html

スキーマ単位　エクスポート
expdp developer/developer@127.0.0.1/orclpdb1.localdomain directory=dp_dir schemas=developer;

expdp system/manager

スキーマ単位　インポート
impdp developer/developer@127.0.0.1/orclpdb1.localdomain schemas=developer directory=dp_dir table_exists_action=replace dumpfile=expdat.dmp 


別スキーマへインポート
create user developer2

impdp developer2/developer2@127.0.0.1/orclpdb1.localdomain schemas=developer directory=dp_dir table_exists_action=replace dumpfile=expdat.dmp remap_schema=developer:developer2

docker exec oracle-db pg_dumpall -U [user name] > dump.sql



###  how to start up / shutdown. 

ローカル・データベース・ユーザーへの接続
connect / as sysdba
STARTUP
SHUTDOWN IMMEDIATE

### 起動後

接続
sqlplus sys/manager as sysdba
https://qiita.com/tpusuke/items/7af097580f239ba28b9d

インスタンス名確認　DB_SID
SQL> SELECT INSTANCE_NAME FROM V$INSTANCE;
>ORCLCDB

pdb確認　DB_PDB
SQL> select PDB_NAME from dba_pdbs

テーブルスペース確認
SQL> select TABLESPACE_NAME from dba_tablespaces

ユーザ確認
SQL> gselect username from dba_users

サービス名称確認
lsnrctl services
>ORCLCDB.localdomain

### ユーザ作成とデータ作成

SQL> alter session set container=ORCLPDB1;

// userを作成
SQL> create user developer identified by developer;

// sessionを作り、データベースに接続を許可するシステム権限を付与する
SQL> grant create session to developer;

// テーブル作成権限
SQL> grant create table to developer;

SQL> grant create sequence to developer;

SQL> alter user developer quota unlimited on USERS;

// 作成したユーザでpdb1で接続
conn developer/developer@127.0.0.1/orclpdb1.localdomain
*conn developer/developer as sysdba <= CDB

テーブル作成
CREATE TABLE book(book_id NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY, isbn NUMBER, title NVARCHAR2(50), author NVARCHAR2(50), release_date DATE);

INSERT INTO book(title, isbn,  author, release_date) VALUES ('SLAM DUNK 1',9784088716114,'井上雄彦',TO_DATE('1991/02/08','yyyy/mm/dd'));

INSERT INTO book(title, isbn,  author, release_date) VALUES ('SLAM DUNK 2',9784088716121,'井上雄彦',TO_DATE('1991/06/10','yyyy/mm/dd'));

INSERT INTO book(title, isbn,  author, release_date) VALUES ('リアル 1',9784088761435,'井上雄彦',TO_DATE('2001/03/19','yyyy/mm/dd'));

### データエクスポート/インポート
https://www.oracletutorial.com/oracle-administration/oracle-expdp/

フォルダ作成
cd ORCL
mkdir ot_external

sqlplus system/manager as sysdba
CREATE DIRECTORY ot_external AS '/ORCL/ot_external';

全てバックアップ
expdp \"sys/manager as sysdba\" full=y directory=ot_external dumpfile=full.dmp  logfile=full.log

PDB1のDBスキーマ
cd ORCL
mkdir ot_external_pdb

conn system/Oradoc_db1@127.0.0.1/orclpdb1.localdomain
CREATE DIRECTORY ot_external_pdb AS '/ORCL/ot_external_pdb';
exit;

expdp system/Oradoc_db1@127.0.0.1/orclpdb1.localdomain schemas=developer directory=ot_external_pdb dumpfile=schemas.dmp  logfile=exp-schemas.log 


conn developer/developer@127.0.0.1/orclpdb1.localdomain

//データ削除
conn system/manager as sysdba
drop table book;
conn developer/developer@127.0.0.1/orclpdb1.localdomain
drop table book;

//復旧
全て
impdp \"sys/manager as sysdba\" directory=ot_external dumpfile=full.dmp logfile=imp-full.log 

PDB1のスキーマごとにインポート
impdp system/Oradoc_db1@127.0.0.1/orclpdb1.localdomain schemas=developer directory=ot_external_pdb dumpfile=schemas.dmp  logfile=imp-schemas.log 

conn system/manager as sysdba
alter session set container=ORCLPDB1;
DROP USER developer CASCADE; 

ローカル・データベース・ユーザーへの接続
connect / as sysdba
STARTUP
SHUTDOWN IMMEDIATE

impdp system/Oradoc_db1@127.0.0.1/orclpdb1.localdomain schemas=developer directory=ot_external_pdb dumpfile=schemas.dmp  logfile=imp-schemas.log 

init.ora

### statspack
https://qiita.com/mkyz08/items/729545aab4751f3002d0
https://www.sql-dbtips.com/statspack/snapshot/
statspack install

sqlplus / as sysdba
@?/rdbms/admin/spcreate.sql
perfstat_passwordに値を入力してください: manager
default_tablespaceに値を入力してください: users
temporary_tablespaceに値を入力してください: temp

statspack設定

SQL> connect perfstat/manager
SQL> execute statspack.modify_statspack_parameter(i_snap_level=> 7)

snapshot取得
execute statspack.snap(i_snap_level=> 7)

statspack一覧
select snap_id, to_char(snap_time, 'yyyy-mm-dd hh24:mi:ss') snap_time from stats$snapshot order by snap_id;

レポート取得
@?/rdbms/admin/spreport.sql

### init.oraの場所
u01/app/oracle/product/12.2.0/dbhome_1/dbs/initORCLCDB.ora;

lsnrctl stop
lsnrctl start

### pdbごとの起動/停止
sqlplus / as sysdba

show pdbs
show con_name

alter pluggable database ORCLPDB1 close; 
alter pluggable database ORCLPDB1 open; 

## pdb丸ごとexport
expdp system/Oradoc_db1@127.0.0.1/orclpdb1.localdomain full=y directory=ot_external_pdb dumpfile=full-pdb.dmp  logfile=exp-full-pdb.log 

//起動プロセス確認
ps -e ax|grep -i ORCLPDB1

select INSTANCE_NUMBER,INSTANCE_NAME,STATUS from v$instance
