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

////////////////////////////////////////////////////

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

/////////////////////////////////////////////////

CREATE FUNCTION TotalitaGerarchiaMessaggio() RETURNS TRIGGER AS $$
BEGIN
	IF (OLD.CodM = NEW.CodM AND
		OLD.CodMittente = NEW.CodMittente AND
		OLD.CodDestinatario = NEW.CodDestinatario) THEN RETURN NEW;
	END IF;
	
	IF (SELECT COUNT(*)
	    FROM (SELECT CodM, CodMittente, CodDestinatario
			  FROM MTesto
			  UNION
			  SELECT CodM, CodMittente, CodDestinatario
			  FROM MImmagine
			  UNION
			  SELECT CodM, CodMittente, CodDestinatario
			  FROM MRecensione) AS CodMessaggi
	    WHERE CodM = NEW.CodM
		AND CodMittente = NEW.CodMittente
	    AND CodDestinatario = NEW.CodDestinatario) = 1
	THEN RAISE EXCEPTION 'La tripla (CodM, CodMittente, CodDestinatario) esiste
						  già in un''altra specializzazione di Messaggio';
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER GestioneInserMTesto
AFTER INSERT OR UPDATE ON MTesto
FOR EACH ROW EXECUTE PROCEDURE TotalitaGerarchiaMessaggio();

CREATE TRIGGER GestioneInserMImmagine
AFTER INSERT OR UPDATE ON MImmagine
FOR EACH ROW EXECUTE PROCEDURE TotalitaGerarchiaMessaggio();

CREATE TRIGGER GestioneInserMRecensione
AFTER INSERT OR UPDATE ON MRecensione
FOR EACH ROW EXECUTE PROCEDURE TotalitaGerarchiaMessaggio();

///////////////////////////////////////////////
