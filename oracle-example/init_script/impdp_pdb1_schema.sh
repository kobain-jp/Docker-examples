
# usage put dmpfile to ot_external and kick this sh file as follows
# sh impdp_to_specific_schema.sh importdmp.sh schemasname dumpfilename logfilename

if [ $# -ne 3 ]; then
  echo "need three arguments as schemasname dumpfilename logfilename " 1>&2
  exit 1
fi

sqlplus  -s  system/Oradoc_db1@127.0.0.1/orclpdb1.localdomain <<'EOF'
  CREATE DIRECTORY ot_external_pdb AS '/ORCL/ot_external_pdb';
  exit
EOF

impdp system/Oradoc_db1@127.0.0.1/orclpdb1.localdomain schemas=$1 directory=ot_external_pdb dumpfile=$2  logfile=$3

