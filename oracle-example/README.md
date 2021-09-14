### setup
https://hub.docker.com/u/kobainjp/content/sub-57ca2017-7067-462b-adcc-0787abf73287
https://qiita.com/KenjiOtsuka/items/97517fdd3406627cf8a7

// container作成　＋　起動

`docker run -it -d --name oracle-db -p 1521:1521 -p 5500:5500 store/oracle/database-enterprise:12.2.0.1`

// container起動

`docker start oracle-db`

### oracle db　初期値

// container内に入る

`docker exec -it oracle-db /bin/bash`

// sqlplus起動

`sqlplus /nolog`

// sysdbaとして接続します。

`SQL> conn / as sysdba`

// インスタンス名確認　DB_SID

```
SQL> SELECT INSTANCE_NAME FROM V$INSTANCE;
>ORCLCDB
```
// pdb確認　DB_PDB
```
SQL> select PDB_NAME from dba_pdbs
```

// テーブルスペース確認
`SQL> select TABLESPACE_NAME from dba_tablespaces`

// ユーザ確認
`SQL> gselect username from dba_users`

// init.oraの場所
`u01/app/oracle/product/12.2.0/dbhome_1/dbs/initORCLCDB.ora;`

// 作業用ディレクトリ
ORCL


### リスナー初期値

// リスナー確認　※ sqlplus外

```
lsnrctl services
>ORCLCDB.localdomain
```

// リスナー停止

`lsnrctl stop`

// リスナー開始

`lsnrctl start`

### user作成　

`sqlplus / as sysdba`

ORCLPDB1にセッションを変更

`SQL> alter session set container=ORCLPDB1;`

id/pwdがdeveloper/developerのユーザを作る

`SQL> create user developer identified by developer;`

sessionを作り、データベースに接続を許可するシステム権限を付与する

`SQL> grant create session to developer;`

テーブル作成権限付与

`SQL> grant create table to developer;`

シーケンス作成権限付与

`SQL> grant create sequence to developer;`

テーブルスペースの更新権限

`SQL> alter user developer quota unlimited on USERS;`

作成した接続に接続

`SQL> conn developer/developer@127.0.0.1/orclpdb1.localdomain`

データを作成
SQL> CREATE TABLE book(book_id NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY, isbn NUMBER, title NVARCHAR2(50), author NVARCHAR2(50), release_date DATE);
SQL> INSERT INTO book(title, isbn,  author, release_date) VALUES ('SLAM DUNK 1',9784088716114,'井上雄彦',TO_DATE('1991/02/08','yyyy/mm/dd'));
SQL> INSERT INTO book(title, isbn,  author, release_date) VALUES ('SLAM DUNK 2',9784088716121,'井上雄彦',TO_DATE('1991/06/10','yyyy/mm/dd'));
SQL> INSERT INTO book(title, isbn,  author, release_date) VALUES ('リアル 1',9784088761435,'井上雄彦',TO_DATE('2001/03/19','yyyy/mm/dd'));

外部から接続

springboot

```
spring.datasource.driver-class-name=oracle.jdbc.driver.OracleDriver
spring.datasource.url=jdbc:oracle:thin:@localhost:1521/orclpdb1.localdomain
spring.datasource.username=developer
spring.datasource.password=developer

```

sqldeveloper

```
Connection Type:Basic
Database host name *:localhost
Port number *:1521
Service name *:orclpdb1.localdomain
Connection string:localhost:1521/orclpdb1.localdomain
Role:Non-Administrator
User name *:developer
Password *:developer
```

### DB起動/停止

CDB起動/停止

`connect / as sysdba`

起動

`STARTUP`

停止

`SHUTDOWN IMMEDIATE`

PDB起動/停止

`sqlplus / as sysdba`

`alter pluggable database ORCLPDB1 close;`

起動

`alter pluggable database ORCLPDB1 open;`


### データエクスポート/インポート
https://www.oracletutorial.com/oracle-administration/oracle-expdp/

CDBをバックアップ

```
cd ORCL
mkdir ot_external
sqlplus system/manager as sysdba
CREATE DIRECTORY ot_external AS '/ORCL/ot_external';
expdp \"sys/manager as sysdba\" full=y directory=ot_external dumpfile=full.dmp  logfile=full.log
```

PDBをバックアップ

```
cd ORCL
mkdir ot_external_pdb
conn system/Oradoc_db1@127.0.0.1/orclpdb1.localdomain
CREATE DIRECTORY ot_external_pdb AS '/ORCL/ot_external_pdb';
expdp system/Oradoc_db1@127.0.0.1/orclpdb1.localdomain full=y directory=ot_external_pdb dumpfile=full-pdb.dmp  logfile=exp-full-pdb.log
```

PDB1のDBスキーマをバックアップ

```
expdp system/Oradoc_db1@127.0.0.1/orclpdb1.localdomain schemas=developer directory=ot_external_pdb dumpfile=schemas.dmp  logfile=exp-schemas.log 
```

データをインポート
CDB全て

```
impdp \"sys/manager as sysdba\" directory=ot_external dumpfile=full.dmp logfile=imp-full.log 
```

PDB1全て

```
impdp system/Oradoc_db1@127.0.0.1/orclpdb1.localdomain full=y directory=ot_external_pdb dumpfile=full.dmp  logfile=imp-full.log 
```

PDB1のDBスキーマごと

```
impdp system/Oradoc_db1@127.0.0.1/orclpdb1.localdomain schemas=developer directory=ot_external_pdb dumpfile=schemas.dmp  logfile=imp-schemas.log 
```

インポート先のテーブルスペース名を帰る場合は remap_tablespace=インポート元テーブルスペース名:インポート先テーブルスペース名,インポート元テーブルスペース名:インポート先テーブルスペース名
スキーマの名前が違う場合は remap_schema=インポート元スキーマ名:インポート先スキーマ名

### statspack
https://qiita.com/mkyz08/items/729545aab4751f3002d0
https://www.sql-dbtips.com/statspack/snapshot/


statspack install

```
sqlplus / as sysdba
@?/rdbms/admin/spcreate.sql
perfstat_passwordに値を入力してください: manager
default_tablespaceに値を入力してください: users
temporary_tablespaceに値を入力してください: temp
```

perfstat が削除できないとき

`alter session set "_oracle_script"=true;`

statspack設定

```
SQL> connect perfstat/perfstat
SQL> execute statspack.modify_statspack_parameter(i_snap_level=> 7)
```

snapshot取得

```
execute statspack.snap(i_snap_level=> 7)
execute statspack.snap
```

statspack一覧

`select snap_id, to_char(snap_time, 'yyyy-mm-dd hh24:mi:ss') snap_time from stats$snapshot order by snap_id;`

レポート取得

`@?/rdbms/admin/spreport.sql`

再インストール

```
sqlplus / as sysdba
@?/rdbms/admin/spdrop.sql
@?/rdbms/admin/spcreate.sql
```

// その他
init_script以下にダンプインポート用スクリプトを配置











