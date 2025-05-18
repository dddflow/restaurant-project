BEGIN
  IF USER != 'DEV_USER' THEN
    RAISE_APPLICATION_ERROR(-20000, 'This script can only be run as DEV_USER.');
  END IF;

  FOR t IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE "' || t.table_name || '" CASCADE CONSTRAINTS';
  END LOOP;
END;