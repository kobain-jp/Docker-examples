// 
mkdir ./ORCL/ot_external

//
sqlplus /nolog;
conn system/Oradoc_db1@127.0.0.1/orclpdb1.localdomain
CREATE DIRECTORY ot_external_pdb AS '/ORCL/ot_external';
exit;

// TODO 環境変数でスキーマとdumpの名前
impdp system/Oradoc_db1@127.0.0.1/orclpdb1.localdomain schemas=developer directory=ot_external_pdb dumpfile=schemas.dmp  logfile=imp-schemas.log 




