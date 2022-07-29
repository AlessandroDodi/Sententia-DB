CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE FUNCTION user_login(IN user VARCHAR(55), IN pswd VARCHAR(64)) RETURNS BOOLEAN AS $$
    DECLARE
        successful BOOLEAN
    BEGIN

        SELECT (psw = crypt(pswd, psw)) INTO successful
        FROM utente
        WHERE username = user;

        RETURN successful;

    END;
$$ LANGUAGE 'plpgsql';

CREATE FUNCTION GestionePassword() RETURNS TRIGGER AS $$
BEGIN
	IF OLD.psw = NEW.psw THEN RETURN NEW;
	END IF;
	
	NEW.psw = crypt(pswd, gen_salt('bf'));
	
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER GestionePasswordUtente
BEFORE INSERT OR UPDATE ON utente
FOR EACH ROW EXECUTE PROCEDURE GestionePassword();

CREATE TRIGGER GestionePasswordModeratore
BEFORE INSERT OR UPDATE ON moderatore
FOR EACH ROW EXECUTE PROCEDURE GestionePassword();

