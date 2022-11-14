CREATE USER mcbuser
  IDENTIFIED BY pass1234
  DEFAULT TABLESPACE mcbbcm
  TEMPORARY TABLESPACE mcbbcm
  QUOTA 20M on mcbbcm;

GRANT create session TO mcbuser;
GRANT create table TO mcbuser;
GRANT create view TO mcbuser;
GRANT create any trigger TO mcbuser;
GRANT create any procedure TO mcbuser;
GRANT create sequence TO mcbuser;
GRANT create synonym TO mcbuser;