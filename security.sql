CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE USER client WITH ENCRYPTED PASSWORD 'topolino2022';

GRANT SELECT, INSERT, UPDATE ON utente to client;
GRANT SELECT ON moderatore to client;

GRANT SELECT(email, username, nome, cognome, ip, foto, psw), 
      INSERT(email, username, nome, cognome, ip, foto, psw), 
      UPDATE(email, nome, cognome, ip, foto) ON utente to client;


CREATE FUNCTION delete_user(IN usr VARCHAR(55), IN pswd VARCHAR(64)) RETURNS BOOLEAN SECURITY DEFINER AS $$
        BEGIN
            IF NOT (SELECT user_login(usr, pswd)) = TRUE 
            THEN
                RETURN FALSE;
            END IF;

            DELETE FROM utente WHERE username = usr;
            RETURN TRUE;
        END           
$$ LANGUAGE 'plpgsql';

CREATE FUNCTION change_psw(IN usr VARCHAR(55), IN new_pswd VARCHAR(64), IN old_pswd VARCHAR(64)) 
    RETURNS BOOLEAN SECURITY DEFINER AS $$
        BEGIN
            IF NOT (SELECT user_login(usr, old_pswd)) = TRUE 
            THEN
                RETURN FALSE;
            END IF;

            UPDATE utente SET psw = new_pswd WHERE psw = crypt(old_pswd, psw);
            RETURN TRUE;
        END           
$$ LANGUAGE 'plpgsql';

CREATE FUNCTION moderatore_login(IN usr VARCHAR(55), IN pswd VARCHAR(64)) RETURNS BOOLEAN AS $$
    DECLARE
        successful BOOLEAN;
    BEGIN

        SELECT (psw = crypt(pswd, psw)) INTO successful
        FROM moderatore
        WHERE username = usr;

        RETURN successful;

    END;
$$ LANGUAGE 'plpgsql';

CREATE FUNCTION user_login(IN usr VARCHAR(55), IN pswd VARCHAR(64)) RETURNS BOOLEAN AS $$
    DECLARE
        successful BOOLEAN;
    BEGIN

        SELECT (psw = crypt(pswd, psw)) INTO successful
        FROM utente
        WHERE username = usr;

        RETURN successful;

    END;
$$ LANGUAGE 'plpgsql';

CREATE FUNCTION GestionePassword() RETURNS TRIGGER AS $$
BEGIN
	IF OLD.psw = NEW.psw THEN RETURN NEW;
	END IF;
	
	NEW.psw := crypt(NEW.psw, gen_salt('bf'));
	
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER GestionePasswordUtente
BEFORE INSERT OR UPDATE ON utente
FOR EACH ROW EXECUTE PROCEDURE GestionePassword();

CREATE TRIGGER GestionePasswordModeratore
BEFORE INSERT OR UPDATE ON moderatore
FOR EACH ROW EXECUTE PROCEDURE GestionePassword();
