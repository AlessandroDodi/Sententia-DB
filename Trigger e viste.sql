Viste

Vista contenente tutti i piani attivi:
CREATE VIEW PianiAttivi AS 
SELECT *
FROM Piano
WHERE Attivo = TRUE

Vista contenente tutte le recensioni visibili:
CREATE VIEW RecensioniVisibili AS 
SELECT R1.*
FROM Recensione AS R1
WHERE R1.CodR NOT IN (
	SELECT R2.CodR
	FROM Recensione AS R2, Rimozione
	WHERE R2.CodR = Rimozione.CodR
	  AND Rimozione.DAnnullamento IS NULL
)

Trigger (testare quando ci sono dei dati)

////////////////////////////

/* Il primo argomento è vero se si tenta di inserire una transazione manuale, falso altrimenti */
CREATE FUNCTION TotalitaGerarchiaTrans() RETURNS TRIGGER AS $$
DECLARE
	Cond BOOL;
BEGIN
	IF OLD.TRN = NEW.TRN THEN RETURN NEW;
	END IF;

	IF TG_NARGS <> 1 THEN RAISE EXCEPTION 'Argomenti forniti erroneamente';
	END IF;
	
	IF TG_ARGV[0] = TRUE
	THEN
		Cond = EXISTS(SELECT TRN
			      FROM TransazioneAutomatica
			      WHERE TRN = NEW.TRN);
	ELSE
		Cond = EXISTS(SELECT TRN
			      FROM TransazioneManuale
			      WHERE TRN = NEW.TRN);
	END IF;
	
	IF Cond
	THEN RAISE EXCEPTION 'Questo codice TRN è già presente nel database.';
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER GestioneInserTransManuale
AFTER INSERT OR UPDATE ON TransazioneManuale
FOR EACH ROW EXECUTE PROCEDURE TotalitaGerarchiaTrans(TRUE);

CREATE TRIGGER GestioneInserTransAuto
AFTER INSERT OR UPDATE ON TransazioneAutomatica
FOR EACH ROW EXECUTE PROCEDURE TotalitaGerarchiaTrans(FALSE);

/////////////////////////////////////////
