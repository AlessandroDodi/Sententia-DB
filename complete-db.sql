-- creazione tabelle

CREATE TABLE Moderatore(
	Email varchar(320) NOT NULL UNIQUE,
	CHECK(Email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
	Username varchar(55) PRIMARY KEY,
	CHECK(Username !~* '.*[^A-Za-z0-9].*'),
	Nome varchar(55) NOT NULL,
	Cognome varchar(55) NOT NULL,
	Psw varchar(72) NOT NULL
);

CREATE TABLE Utente(
	Email varchar(320) NOT NULL UNIQUE,
	CHECK(Email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
	Username varchar(55) PRIMARY KEY,
	CHECK(Username !~* '.*[^A-Za-z0-9].*'),
	Nome varchar(55) NOT NULL,
	Cognome varchar(55) NOT NULL,
	IP char(15) NOT NULL,
	CHECK(IP ~ '^(\d{3}\.){3}\d{3}$'),
	Psw varchar(72) NOT NULL,
	Foto varchar(55)
);

CREATE TABLE UtentePremium(
	CodUtente varchar(55) PRIMARY KEY,
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username),
	IBAN char(27) NOT NULL
);

CREATE TABLE Amicizia(
	Seguente varchar(55),
	Seguito varchar(55),
	FOREIGN KEY (Seguente) REFERENCES Utente(Username),
	FOREIGN KEY (Seguito) REFERENCES Utente(Username),
	PRIMARY KEY (Seguente, Seguito),
	Data date NOT NULL
); 

CREATE TABLE Oggetto(
	CodO int PRIMARY KEY,
	Nome varchar(55) NOT NULL,
	Descrizione varchar(320) NOT NULL,
	Categoria varchar(55) NOT NULL
);

CREATE TABLE Recensione(
	CodR int PRIMARY KEY,
	Foto varchar(55),
	DataPubblicazione timestamp NOT NULL,
	DataVisionePubblica timestamp,
	CHECK(DataVisionePubblica IS NULL OR DataVisionePubblica >= DataPubblicazione),
	Titolo varchar(155) NOT NULL,
	Valore int,
	Descrizione varchar(1555) NOT NULL,
	CHECK(Valore IS NULL OR (Valore >= 0 AND Valore <= 100)),
	CodUtente varchar(55) NOT NULL,
	CodO int NOT NULL,
	FOREIGN KEY (CodO) REFERENCES Oggetto(CodO),
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username)
);

CREATE TABLE Medaglia(
	CodUtente varchar(55),
	CodR int,
	Data date NOT NULL,
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username),
	FOREIGN KEY (CodR) REFERENCES Recensione(CodR),
	PRIMARY KEY (CodUtente, CodR)
);

CREATE TYPE tipoR AS ENUM('Contenuti di natura sessuale', 'Contenuti violenti o ripugnanti', 'Azioni dannose o pericolose', 'Spam o ingannevole');
CREATE TABLE Report(
	CodUtente varchar(55),
	CodR int,
	TipoReport tipoR,
	Altro varchar(55),
	CHECK((TipoReport IS NULL AND Altro IS NOT NULL) OR (TipoReport IS NOT NULL AND Altro IS NULL)),
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username),
	FOREIGN KEY (CodR) REFERENCES Recensione(CodR),
	PRIMARY KEY (CodUtente, CodR)
);

CREATE TABLE Commento(
	CodC int,
	CodR int,
	CodUtente varchar(55) NOT NULL,
	Data timestamp NOT NULL, 
	Testo varchar(1555),
	CodCRisposta int,
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username),
	FOREIGN KEY (CodR) REFERENCES Recensione(CodR),
	FOREIGN KEY (CodCRisposta, CodR) REFERENCES Commento,
	PRIMARY KEY (CodC, CodR)
);

CREATE TABLE Messaggio(
	CodM int,
	CodMittente varchar(55),
	CodDestinatario varchar(55),
	Letto boolean NOT NULL,
	Data timestamp NOT NULL, 
	FOREIGN KEY (CodDestinatario) REFERENCES Utente(Username),
	FOREIGN KEY (CodMittente) REFERENCES Utente(Username),
	PRIMARY KEY (CodM, CodMittente, CodDestinatario)
);

CREATE TABLE MTesto(
	CodM int,
	CodMittente varchar(55),
	CodDestinatario varchar(55),
	Contenuto varchar(1555) NOT NULL,
	FOREIGN KEY (CodM, CodMittente, CodDestinatario) REFERENCES Messaggio(CodM, CodMittente, CodDestinatario),
	PRIMARY KEY (CodM, CodMittente, CodDestinatario)
);

CREATE TABLE MImmagine(
	CodM int,
	CodMittente varchar(55),
	CodDestinatario varchar(55),
	Immagine varchar(55) NOT NULL,
	Descrizione varchar(1555),
	FOREIGN KEY (CodM, CodMittente, CodDestinatario) REFERENCES Messaggio(CodM, CodMittente, CodDestinatario),
	PRIMARY KEY (CodM, CodMittente, CodDestinatario)
);

CREATE TABLE MRecensione(
	CodM int,
	CodMittente varchar(55),
	CodDestinatario varchar(55),
	codR int NOT NULL,
	Descrizione varchar(1555),
	FOREIGN KEY (CodM, CodMittente, CodDestinatario) REFERENCES Messaggio(CodM, CodMittente, CodDestinatario),
	FOREIGN KEY (CodR) REFERENCES Recensione(CodR),
	PRIMARY KEY (CodM, CodMittente, CodDestinatario)
);

CREATE TABLE CartaCredito(
	Numero char(16) PRIMARY KEY,
	DScadenza char(5) NOT NULL,
	EnteEmittente varchar(30) NOT NULL
);

CREATE TABLE CartaUtente(
	CodU varchar(55),
	NumeroC char(16),
	PRIMARY KEY(CodU, NumeroC),
	FOREIGN KEY (CodU) REFERENCES Utente(Username),
	FOREIGN KEY (NumeroC) REFERENCES CartaCredito(Numero)
);

CREATE TYPE periodoPiano AS ENUM('settimana', 'mese', 'trimestre', 'semestre', 'anno');
CREATE TABLE Piano(
	CodP int PRIMARY KEY,
	CodUtentePremium varchar(55) NOT NULL, 
	Quantita int NOT NULL, 
	Periodo periodoPiano NOT NULL,
	Attivo bool NOT NULL,
	FOREIGN KEY (CodUtentePremium) REFERENCES UtentePremium(CodUtente)
);

CREATE TABLE Esclusivita(
	DataAnticipata timestamp NOT NULL,
	CodP int,
	CodR int,
	FOREIGN KEY (CodR) REFERENCES Recensione(CodR),
	FOREIGN KEY (CodP) REFERENCES Piano(CodP),
	PRIMARY KEY (CodP, CodR)
);

CREATE TABLE Iscrizione(
	CodP int,
	CodUtente varchar(55),
	DIscrizione date,
	DAbbandono date,
	CHECK(DAbbandono IS NULL OR (DAbbandono >= DIscrizione)),
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username),
	FOREIGN KEY (CodP) REFERENCES Piano(CodP),
	PRIMARY KEY (CodP, CodUtente, DIscrizione)
);

CREATE TABLE TransazioneAutomatica(
	TRN char(30) PRIMARY KEY,
	Annullata bool NOT NULL,
	Data date NOT NULL,
	CodPiano int NOT NULL,
	CodMittente varchar(55) NOT NULL,
	NumeroCartaDiCredito char(16) NOT NULL,
	FOREIGN KEY (NumeroCartaDiCredito) REFERENCES CartaCredito(Numero),
	FOREIGN KEY (CodPiano) REFERENCES Piano(CodP),
	FOREIGN KEY (CodMittente) REFERENCES Utente(Username),
	UNIQUE(Data, CodPiano, CodMittente)
);

CREATE TABLE TransazioneManuale(
	TRN char(30) PRIMARY KEY,
	Annullata bool NOT NULL,
	Data date NOT NULL,
	CodMittente varchar(55) NOT NULL,
	CodDestinatario varchar(55) NOT NULL,
	NumeroCartaDiCredito char(16) NOT NULL,
	Quantita INTEGER NOT NULL,
	FOREIGN KEY (NumeroCartaDiCredito) REFERENCES CartaCredito(Numero),
	FOREIGN KEY (CodMittente) REFERENCES Utente(Username),
	FOREIGN KEY (CodDestinatario) REFERENCES UtentePremium(CodUtente),
	UNIQUE(Data, CodMittente, CodDestinatario)
);

CREATE TABLE Ban(
	CodUtente varchar(55) PRIMARY KEY,
	CodModeratore varchar(55) NOT NULL,
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username),
	FOREIGN KEY (CodModeratore) REFERENCES Moderatore(Username)
);

CREATE TABLE Rimozione(
	DataEffettuazione date,
	CodR int,
	DAnnullamento date,
	CHECK(DAnnullamento IS NULL OR (DataEffettuazione <= DAnnullamento)),
	CodModeratore varchar(55) NOT NULL,
	PRIMARY KEY(DataEffettuazione, CodR),
	FOREIGN KEY (CodR) REFERENCES Recensione(CodR),
	FOREIGN KEY (CodModeratore) REFERENCES Moderatore(Username)
);

-- Viste

-- Vista contenente tutti i piani attivi:
CREATE VIEW PianiAttivi AS 
SELECT *
FROM Piano
WHERE Attivo = TRUE;

-- Vista contenente tutte le recensioni visibili:
CREATE VIEW RecensioniVisibili AS 
SELECT R1.*
FROM Recensione AS R1
WHERE R1.CodR NOT IN (
	SELECT R2.CodR
	FROM Recensione AS R2, Rimozione
	WHERE R2.CodR = Rimozione.CodR
	  AND Rimozione.DAnnullamento IS NULL
);

-- Vista contenente tutte le recensioni disponibili per ciascun utente
CREATE VIEW RecDisponibiliPerUtente AS
SELECT Utente.Username, R.CodR
FROM Utente, RecensioniVisibili AS R
WHERE R.DataVisionePubblica <= CURRENT_DATE OR
Utente.Username = R.CodUtente OR 
EXISTS (
	SELECT *
	FROM UtentePremium, Iscrizione, Piano, Esclusivita
	WHERE UtentePremium.CodUtente = R.CodUtente AND
	Piano.CodUtentePremium = UtentePremium.CodUtente AND
	Iscrizione.CodUtente = Utente.Username AND
	Iscrizione.CodP = Piano.CodP AND
	Iscrizione.DAbbandono IS NULL AND
	Piano.CodP = Esclusivita.CodP AND
	Esclusivita.CodR = R.CodR AND
	DataAnticipata <= CURRENT_DATE
);

-- Trigger

/* Il primo argomento è vero se si tenta di inserire una transazione manuale, falso altrimenti */
CREATE FUNCTION TotalitaGerarchiaTrans() RETURNS TRIGGER AS $$
DECLARE
	Cond BOOL;
BEGIN
	IF OLD.TRN = NEW.TRN THEN RETURN NEW;
	END IF;

	IF TG_NARGS <> 1 THEN RAISE EXCEPTION 'Argomenti forniti erroneamente';
	END IF;
	
	IF TG_ARGV[0] = 'true'
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
	THEN RAISE EXCEPTION 'Questo codice TRN e'' gia'' presente nel database.';
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER GestioneInserTransManuale
BEFORE INSERT OR UPDATE ON TransazioneManuale
FOR EACH ROW EXECUTE PROCEDURE TotalitaGerarchiaTrans(TRUE);

CREATE TRIGGER GestioneInserTransAuto
BEFORE INSERT OR UPDATE ON TransazioneAutomatica
FOR EACH ROW EXECUTE PROCEDURE TotalitaGerarchiaTrans(FALSE);

-- /////////////////////////////////////////////////

CREATE FUNCTION TotalitaGerarchiaMessaggio() RETURNS TRIGGER AS $$
BEGIN
	IF (OLD.CodM = NEW.CodM AND
		OLD.CodMittente = NEW.CodMittente AND
		OLD.CodDestinatario = NEW.CodDestinatario) THEN RETURN NEW;
	END IF;
	
	IF EXISTS ( SELECT *
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
	    		AND CodDestinatario = NEW.CodDestinatario)
	THEN RAISE EXCEPTION 'La tripla ("%", "%", "%") esiste
						  gia'' in un''altra specializzazione di Messaggio', NEW.CodM,
						  NEW.CodMittente,
						  NEW.CodDestinatario;
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER GestioneInserMTesto
BEFORE INSERT OR UPDATE ON MTesto
FOR EACH ROW EXECUTE PROCEDURE TotalitaGerarchiaMessaggio();

CREATE TRIGGER GestioneInserMImmagine
BEFORE INSERT OR UPDATE ON MImmagine
FOR EACH ROW EXECUTE PROCEDURE TotalitaGerarchiaMessaggio();

CREATE TRIGGER GestioneInserMRecensione
BEFORE INSERT OR UPDATE ON MRecensione
FOR EACH ROW EXECUTE PROCEDURE TotalitaGerarchiaMessaggio();

-- ///////////////////////////////////////////////

CREATE FUNCTION VincoloEsclusivita() RETURNS TRIGGER AS $$
DECLARE
CodUtenteP varchar(55);
BEGIN
	IF (OLD.CodP = NEW.CodP AND
		OLD.CodR = NEW.CodR) THEN RETURN NEW;
	END IF;
	
	SELECT CodUtentePremium INTO CodUtenteP
	FROM Piano WHERE CodP = NEW.CodP;
	
	IF NOT EXISTS (SELECT *
				   FROM Recensione
				   WHERE CodR = NEW.CodR AND CodUtente = CodUtenteP)
	THEN RAISE EXCEPTION 'La recensione non appartiene all''utente in questione';
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER GestioneEsclusivita
BEFORE INSERT OR UPDATE ON Esclusivita
FOR EACH ROW EXECUTE PROCEDURE VincoloEsclusivita();

-- ////////////////////////////////////////////////

CREATE FUNCTION VincoloCartaCredito() RETURNS TRIGGER AS $$
BEGIN
	IF (OLD.NumeroCartaDiCredito = NEW.NumeroCartaDiCredito AND
		OLD.CodMittente = NEW.CodMittente) THEN RETURN NEW;
	END IF;
	
	IF NOT EXISTS (SELECT *
				   FROM CartaUtente
				   WHERE CodU = NEW.CodMittente AND NumeroC = NEW.NumeroCartaDiCredito)
	THEN RAISE EXCEPTION 'L''utente non può utilizzare la carta di credito in questione';
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER GestioneTransManCarta
BEFORE INSERT OR UPDATE ON TransazioneManuale
FOR EACH ROW EXECUTE PROCEDURE VincoloCartaCredito();

CREATE TRIGGER GestioneTransAutoCarta
BEFORE INSERT OR UPDATE ON TransazioneAutomatica
FOR EACH ROW EXECUTE PROCEDURE VincoloCartaCredito();

-- /////////////////////////////////////////////

CREATE FUNCTION VincoloRimozione() RETURNS TRIGGER AS $$
BEGIN
	IF OLD.DAnnullamento = NEW.DAnnullamento THEN RETURN NEW;
	END IF;
	
	IF EXISTS (SELECT *
			   FROM Rimozione
			   WHERE CodR = NEW.CodR AND DAnnullamento IS NULL)
	THEN RAISE EXCEPTION 'La recensione e'' gia'' attualmente invisibile';
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER GestioneRimozione
BEFORE INSERT OR UPDATE ON Rimozione
FOR EACH ROW EXECUTE PROCEDURE VincoloRimozione();

-- ///////////////////////////////////////////

CREATE FUNCTION VincoloIscrizione() RETURNS TRIGGER AS $$
BEGIN
	IF OLD.DAbbandono = NEW.DAbbandono THEN RETURN NEW;
	END IF;
	
	IF EXISTS (SELECT *
			   FROM Iscrizione
			   WHERE CodP = NEW.CodP AND
			   CodUtente = NEW.CodUtente AND
			   DAbbandono IS NULL)
	THEN RAISE EXCEPTION 'L''utente e'' gia'' attualmente iscritto al piano';
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER GestioneIscrizione
BEFORE INSERT OR UPDATE ON Iscrizione
FOR EACH ROW EXECUTE PROCEDURE VincoloIscrizione();

-- ///////////////////////////////////////////

CREATE FUNCTION VincoloDataEsclusiva() RETURNS TRIGGER AS $$
BEGIN
	IF (OLD.DataAnticipata = NEW.DataAnticipata AND
		OLD.CodR = NEW.CodR) THEN RETURN NEW;
	END IF;
	
	IF EXISTS (SELECT *
			   FROM Recensione
			   WHERE DataVisionePubblica IS NOT NULL AND
			   CodR = NEW.CodR AND NEW.DataAnticipata > DataVisionePubblica)
	THEN RAISE EXCEPTION 'La data anticipata e'' cronologicamente dopo la data di visione pubblica';
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER GestioneDataEsclusiva
BEFORE INSERT OR UPDATE ON Esclusivita
FOR EACH ROW EXECUTE PROCEDURE VincoloDataEsclusiva();

CREATE FUNCTION VincoloDataVisionePubblica() RETURNS TRIGGER AS $$
BEGIN
	IF OLD.DataVisionePubblica = NEW.DataVisionePubblica THEN RETURN NEW;
	END IF;
	
	IF EXISTS (SELECT *
			   FROM Esclusivita
			   WHERE CodR = NEW.CodR AND NEW.DataVisionePubblica < DataAnticipata)
	THEN RAISE EXCEPTION 'La data di visione pubblica immessa precede una data di visione anticipata';
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER GestioneDataVisionePubblica
BEFORE INSERT OR UPDATE ON Recensione
FOR EACH ROW EXECUTE PROCEDURE VincoloDataVisionePubblica();

-- //////////////////////////////////////////////////////

-- Si può utilizzare la stessa procedura per entrambi i trigger, in quanto hanno l'attributo CodUtente con il medesimo nome 

CREATE FUNCTION VincoloMaxPubblicazioni() RETURNS TRIGGER AS $$
DECLARE
    -- Contiene l'ora attuale priva di minuti e secondi
    OraNonMin timestamp;
BEGIN
    OraNonMin = date_trunc('hour', Now()::timestamp);

    IF (SELECT (SELECT COUNT(*)
               FROM Recensione
               WHERE CodUtente = NEW.CodUtente AND
               DataPubblicazione >= OraNonMin)
               +
               (SELECT COUNT(*)
                FROM Commento
                WHERE CodUtente = NEW.CodUtente AND
                Commento.Data >= OraNonMin)) > 1000
    THEN RAISE EXCEPTION 'E'' stato superato il numero massimo di pubblicazioni che si possono effettuare in un''ora.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER GestioneMaxPubblicazioniRec
BEFORE INSERT ON Recensione
FOR EACH ROW EXECUTE PROCEDURE VincoloMaxPubblicazioni();

CREATE TRIGGER GestioneMaxPubblicazioniCom
BEFORE INSERT ON Commento
FOR EACH ROW EXECUTE PROCEDURE VincoloMaxPubblicazioni();

-- //////////////////////////////////////////////////////

-- Security and user permissions
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE USER client WITH ENCRYPTED PASSWORD 'topolino2022';
GRANT ALL ON ALL TABLES IN SCHEMA "public" TO client;

GRANT SELECT, INSERT, UPDATE ON utente to client;
GRANT SELECT ON moderatore to client;

GRANT SELECT(email, username, nome, cognome, ip, foto, psw), 
      INSERT(email, username, nome, cognome, ip, foto, psw), 
      UPDATE(email, nome, cognome, ip, foto) ON utente to client;


CREATE FUNCTION delete_user(IN usr VARCHAR(55), IN pswd VARCHAR(72)) RETURNS BOOLEAN SECURITY DEFINER AS $$
        BEGIN
            IF NOT (SELECT user_login(usr, pswd)) = TRUE 
            THEN
                RETURN FALSE;
            END IF;

            DELETE FROM utente WHERE username = usr;
            RETURN TRUE;
        END           
$$ LANGUAGE 'plpgsql';

CREATE FUNCTION change_psw(IN usr VARCHAR(55), IN new_pswd VARCHAR(72), IN old_pswd VARCHAR(72)) 
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

CREATE FUNCTION moderatore_login(IN usr VARCHAR(55), IN pswd VARCHAR(72)) RETURNS BOOLEAN AS $$
    DECLARE
        successful BOOLEAN;
    BEGIN

        SELECT (psw = crypt(pswd, psw)) INTO successful
        FROM moderatore
        WHERE username = usr;

        RETURN successful;

    END;
$$ LANGUAGE 'plpgsql';

CREATE FUNCTION user_login(IN usr VARCHAR(55), IN pswd VARCHAR(72)) RETURNS BOOLEAN AS $$
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

-- inserts on db

INSERT INTO Moderatore
  (Email, Username, Nome, Cognome, Psw)
VALUES 
  ('dodialessandro3@gmail.com', 'AlleDodi', 'Alessandro', 'Dodi', 'alleella314253'),
  ('amanjotSingh@gmail.com', 'jot', 'Amanjot', 'Singh', 'singh392015'),
  ('LeonardoTemperanza@gmail.com', 'lollo', 'Leonardo', 'Temperanza', 'leotemp126'),
  ('luigifini@gmail.com', 'luigi', 'Luigi', 'Fini', 'luigiluigi'),
  ('mariacostanzi@gmail.com', 'meri', 'Maria', 'Costanzi', 'MariaCostanzi24152');

INSERT INTO Utente
  (Email, Username, Nome, Cognome, Psw, IP, Foto)
VALUES 
  ('sarafornaciari@gmail.com', 'sara', 'Sara', 'Fornaciari', 'passwordsicurasara', '127.000.000.001', 'images/users/sara.png'),
  ('mariorossi@gmail.com', 'MarioRossi', 'Mario', 'Rossi', 'mariomario', '127.000.000.002', 'images/users/MarioRossi.png'),
  ('lauracastiello@gmail.com', 'lalla', 'Laura', 'Castiello', 'lauraCastiello1207', '127.000.000.003', 'images/users/default.png'),
  ('jimmy@gmail.com', 'jimmy', 'Jimmy', 'Brown', 'lljimllbrownll', '127.000.000.004', 'images/users/jimmy.png'),
  ('groot@gmail.com', 'groot', 'Groot', 'Avenger', 'grootaven123', '127.000.000.005', 'images/users/default.png'),
  ('frankestrizza@gmail.com', 'frank', 'Frank', 'Salami', 'ffrraannkk122346', '127.000.000.006', 'images/users/default.png'),
  ('ligabuemarcon@gmail.com', 'lmarco', 'Marco', 'Ligabue', 'ligabmarc', '127.000.000.007', 'images/users/default.png'),
  ('marcusspin@gmail.com', 'marcus', 'Marcus', 'Spin', 'spinmarcusspin', '127.000.000.008', 'images/users/default.png');

INSERT INTO UtentePremium
  (CodUtente, IBAN)
VALUES 
  ('sara', 'IT45X0442834101000000654321'),
  ('lalla', 'IT60X0542811101000000123456'),
  ('groot', 'IT60X0542811101000000123453');

INSERT INTO Amicizia
  (Seguente, Seguito, Data)
VALUES 
  ('sara', 'jimmy', '2022-01-09'),
  ('sara', 'lalla', '2022-02-04'),
  ('sara', 'groot', '2022-03-10'),
  ('marcus', 'marcus', '2022-03-21'),
  ('marcus', 'jimmy', '2021-04-07'),
  ('lalla', 'sara', '2021-12-02'),
  ('jimmy', 'sara', '2022-05-12'),
  ('jimmy', 'groot', '2022-05-12'),
  ('jimmy', 'frank', '2022-05-12'),
  ('jimmy', 'MarioRossi', '2022-05-12'),
  ('groot', 'sara', '2022-06-10'),
  ('groot', 'lmarco', '2022-06-10'),
  ('lmarco', 'sara', '2022-07-01');

INSERT INTO Oggetto
  (CodO, Nome, Descrizione, Categoria)
VALUES 
  ('1', 'Interstellar', 'Un gruppo di scienziati appartenenti un tempo alla NASA, sfruttando un "wormhole" per superare le limitazioni fisiche del viaggio spaziale e coprire le immense distanze del viaggio interstellare, organizza una serie di missioni spaziali alla ricerca di un pianeta abitabile.', 'Film'),
  ('2', 'Will hunting', 'In un quartiere povero di Boston, Will Hunting (Matt Damon), venti anni, vive in modo precario e scombinato insieme ad alcuni amici, tra i quali spicca il suo migliore amico Chuckie, e guadagna qualcosa pulendo i pavimenti nel dipartimento di matematica del famoso Massachusetts Institute of Technology (MIT).', 'Film'),
  ('3', 'Cane', 'l cane è un quadrupede ed ha il corpo coperto di pelo. Le sue zampe sono lunghe, forti, snelle, atte alla corsa. Il cane cammina sulla punta delle dita, come il gatto, ma il suo passo non è silenzioso, perché i suoi artigli non sono retrattili e quando cammina li batte sul suolo.', 'Animali'),
  ('4', 'Joe Rogan', 'The Joe Rogan Experience è un podcast ospitato dal comico, presentatore e commentatore a colori UFC americano Joe Rogan. È stato lanciato il 24 dicembre 2009 su YouTube da Rogan e dal comico Brian Redban, che ne è stato co-conduttore e produttore fino al 2013, quando è stato sostituito da Jamie Vernon.', 'Podcast'),
  ('5', 'The genius of the crowd', 'Famosa poesia di Charles Bukowski', 'Poesia'),
  ('6', 'Bitcoin website', '', 'Tecnologia');

INSERT INTO Recensione
  (CodR, Foto, DataPubblicazione, Titolo, Valore, Descrizione, CodUtente, CodO, DataVisionePubblica)
VALUES
  ('1', 'images/reviews/lalla/1.png', '2021-04-01 10:12:24', 'Migliore film di sempre', '100', 'Semplicemente il miglior film di sempre', 'lalla', '1', '2021-05-01 05:01:10'),
  ('2', 'images/reviews/jimmy/2.png', '2021-04-03 02:52:26', 'Poesia estremamente profonda', '100', 'Questa è la mia poesia preferita di Bukowski. La trovo molto profonda.', 'jimmy', '5', '2021-04-03 15:15:15'),
  ('3', 'images/reviews/sara/3.png', '2022-05-13 05:42:23', 'Miglior film di Robin Williams', '100', 'Film meraviglioso. A mio parare miglior prestazione di Robin Williams', 'sara', '2', '2022-05-14 03:30:12'),
  ('4', 'images/reviews/jimmy/4.png', '2022-05-14 12:16:56', 'Il mio podcast preferito', '95', 'Questo è il mio podcast preferito. Joe è molto intelligente e fa ottime domande. Mi piace molto la varietà nel tipo delle persone chiamate', 'jimmy', '4', '2022-05-14 18:12:30'),
  ('5', 'images/reviews/marcus/5.png', '2022-05-15 08:16:34', 'Comprate sul mio sito', '90', 'Comprate bitcoin sul mio sito comprabitcoin.com', 'marcus', '6', '2022-05-15 09:10:21'),
  ('6', 'images/reviews/sara/5.png', '2022-05-16 22:22:22', 'Imperdibile', '94', 'Sarò breve: questo film entra di diritto nel club dei film unici da riguardare più e più volte. la storia, almeno inizialmente, non appare imprevedibile e ricca di sorprese: Terra che sta diventando inabitabile, quindi serve un altro mondo dove abitare, quindi ecco il progetto dell viaggio interstellare. Ma ecco la rivoluzione: non ci si sofferma più nel mostrare le solite pompose scene tipiche dei film spaziali (piloti che si preparano, musiche eroiche, sfrenata dettagliatura delle navicelle spaziali), ma si vada dritti al cuore della narrazione. Alcuni dei vari accadimenti nello spazio non sono di immediata comprensione per lo spettatore, quasi una conseguenza logica vista la mole di nozioni tecniche su cui si basano: ma questo mi è piaciuto, attriubuisce una certo realismo e una logica che sfuggono allo spettatore medio, ma che vengono più che esaurientemente rese afferrabili col proseguire della trama.', 'sara', '1', '2022-10-01 18:20:00'),
  ('7', 'images/reviews/lalla/5.png', '2022-05-17 23:13:42', 'Stravolgente', '100','Questo film di psicologia ci mostra come non si debba mai dar per scontato un attore:robin williams,solitamente effervescenza e vitalità allo stato puro-l''attimo fuggente,mrs doubtfire,hook-qui è nei panni di uno psicologo,brillante e amante della vita ma non troppo al di sopra delle righe-e sia detto che considero l''attimo fuggente come uno dei film capolavoro della storia del cinema e keatting come il professore che avrei voluto avere-tuttavia il rientrare nelle righe di williams non mi dispiace affatto,ed lo s9i ritrova solo in risvegli con de niro-il cambiamento di williams è tale in questo flm che può essere paragonato a quello di fabrizi in roma città aperta, nel quale da comico si trasforma in un serio rappresentante di dio.', 'lalla', '2', null),
  ('8', 'images/reviews/groot/5.png', '2022-05-15 00:12:51', 'Bitcoin', '90', 'Sei vuoi capire cosa sono i bitcoin, segui il link in allegato', 'groot', '6', '2022-05-15 10:00:00');

INSERT INTO Medaglia
  (CodUtente, CodR, Data)
VALUES
  ('lalla', '1', '2022-05-20'),
  ('marcus', '2', '2022-05-21'),
  ('lalla', '3', '2022-05-22'),
  ('marcus', '3', '2022-05-23'),
  ('jimmy', '5', '2022-05-24'),
  ('sara', '5', '2022-05-25');

INSERT INTO Report
  (CodUtente, CodR, TipoReport, Altro)
VALUES
  ('MarioRossi', '5', 'Spam o ingannevole', NULL),
  ('sara', '5', 'Spam o ingannevole', NULL),
  ('lalla', '8', 'Spam o ingannevole', NULL),
  ('jimmy', '5', 'Spam o ingannevole', NULL);

INSERT INTO Commento
  (CodC, CodR, CodUtente, Data, Testo, CodCRisposta)
VALUES
  ('1', '5', 'MarioRossi', '2022-06-01 21:00:13', 'Questa è spam, ti ho riportato', null),
  ('2', '4', 'marcus', '2022-06-02 08:00:32', 'Hai ragione', null),
  ('3', '3', 'lalla', '2022-06-03 05:25:53', 'Concordo', null),
  ('4', '4', 'lalla', '2022-06-03 18:41:37', 'la vedo diversamente', null);

INSERT INTO Messaggio
  (CodM, CodMittente, CodDestinatario, Letto, Data)
VALUES
  ('1', 'sara', 'jimmy', 'TRUE', '2022-06-10 10:02:36'),
  ('2', 'jimmy', 'sara', 'TRUE', '2022-06-10 10:02:56'),
  ('3', 'sara', 'jimmy', 'TRUE', '2022-06-10 10:03:10'),
  ('4', 'jimmy', 'sara', 'TRUE', '2022-06-10 10:04:41'),
  ('5', 'sara', 'jimmy', 'FALSE', '2022-06-10 10:04:59'),
  ('6', 'sara', 'jimmy', 'FALSE', '2022-06-10 10:05:59'),
  ('1', 'lalla', 'sara', 'FALSE', '2022-06-10 11:05:50'),
  ('1', 'marcus', 'lalla', 'TRUE', '2022-06-10 11:05:50'),
  ('2', 'lalla', 'marcus', 'TRUE', '2022-06-10 12:34:21'),
  ('3', 'marcus', 'lalla', 'TRUE', '2022-06-10 12:03:51'),
  ('4', 'lalla', 'marcus', 'TRUE', '2022-06-10 15:22:21'),
  ('1', 'groot', 'lmarco', 'TRUE', '2022-06-10 12:34:21'),
  ('2', 'lmarco', 'groot', 'TRUE', '2022-06-10 12:35:51'),
  ('3', 'groot', 'lmarco', 'FALSE', '2022-06-10 15:36:21');

INSERT INTO MTesto
  (CodM, CodMittente, CodDestinatario, Contenuto)
VALUES
  ('1', 'sara', 'jimmy', 'Ciao Jimmy'),
  ('2', 'jimmy', 'sara', 'Ciao Sara'),
  ('3', 'sara', 'jimmy', 'Come stai?'),
  ('4', 'jimmy', 'sara', 'Mai stato meglio, tu?'),
  ('5', 'sara', 'jimmy', 'Idem'),
  ('6', 'sara', 'jimmy', 'Usciamo mercoledí?'), 
  ('1', 'lalla', 'sara', 'Ci vediamo oggi pomeriggio per studiare?'),
  ('1', 'groot', 'lmarco', 'Come é andata la sessione estiva?'),
  ('2', 'lmarco', 'groot', 'Bene. E a te?'),
  ('3', 'groot', 'lmarco', 'Anche a me. Vieni alla festa di compleanno di frank?');

INSERT INTO MImmagine
  (CodM, CodMittente, CodDestinatario, Immagine)
VALUES
  ('1', 'marcus', 'lalla', '/img/198271928312982.png'),
  ('2', 'lalla', 'marcus', '/img/091823012983179.png');

INSERT INTO MRecensione
  (CodM, CodMittente, CodDestinatario, codR)
VALUES
  ('3', 'marcus', 'lalla', '1'),
  ('4', 'lalla', 'marcus', '2');


INSERT INTO CartaCredito
  (Numero, DScadenza, EnteEmittente)
VALUES
  ('5365192748368000', '12/24', 'Mastercard'),
  ('5243906784563827', '11/23', 'Mastercard'),
  ('5328087472838500', '11/25', 'Mastercard'),
  ('5785097781567052', '01/25', 'Mastercard'), 
  ('5785097781567051', '02/25', 'Visa'),
  ('5785097781560332', '03/25', 'Mastercard');

INSERT INTO CartaUtente
  (NumeroC, CodU)
VALUES
  ('5365192748368000', 'lalla'),
  ('5243906784563827', 'jimmy'),
  ('5328087472838500', 'MarioRossi'),
  ('5785097781567052', 'marcus'),
  ('5785097781567051', 'sara'),
  ('5785097781560332', 'sara');

INSERT INTO Piano
  (CodP, CodUtentePremium, Quantita, Periodo, Attivo)
VALUES
  ('1', 'sara', '1', 'trimestre', 'true'),
  ('2', 'lalla', '2', 'anno', 'true');

INSERT INTO Esclusivita
  (DataAnticipata, CodP, CodR)
VALUES
  ('2022-05-10 19:20:00', '1', '6'),
  ('2022-05-11 10:00:00', '2', '7');

INSERT INTO Iscrizione
  (CodP, CodUtente, DIscrizione, DAbbandono)
VALUES
  ('1', 'MarioRossi', '2022-03-11', '2022-06-08'),
  ('2', 'MarioRossi', '2022-04-21', '2022-07-13'),
  ('1', 'jimmy', '2022-04-22', '2022-06-11'),
  ('2', 'jimmy', '2022-05-05', '2022-05-30'),
  ('1', 'jimmy', '2022-07-26', null),
  ('2', 'jimmy', '2022-07-26', null);

INSERT INTO TransazioneAutomatica
  (TRN, Annullata, Data, CodPiano, CodMittente, NumeroCartaDiCredito)
VALUES
  ('KSBSJUP2130PNISUEHBJ98KNJLIT00', 'false', '2022-03-11', '1', 'MarioRossi', '5328087472838500'),
  ('LKNSKJDO0921KJBKJSBD91JKSDIT00', 'false', '2022-04-21', '2','MarioRossi', '5328087472838500');

INSERT INTO TransazioneManuale
  (TRN, Annullata, Data, CodMittente, CodDestinatario, NumeroCartaDiCredito, Quantita)
VALUES
  ('J98NKSDLKBDKASLB78912ASDJKIT00', 'false', '2022-06-1', 'jimmy', 'sara', '5243906784563827', '20'),
  ('55FBQSFGLJZ4PEKPX2XWR59UCHYFY3', 'false', '2022-05-30', 'jimmy', 'groot', '5243906784563827', '30'), 
  ('J98NKSDLKBDKASLB78912ASDJKIT22', 'false', '2022-06-2', 'sara', 'lalla', '5785097781567051', '20');

INSERT INTO Ban
  (CodUtente, CodModeratore)
VALUES
  ('marcus', 'AlleDodi');

INSERT INTO Rimozione
  (DataEffettuazione, CodR, DAnnullamento, CodModeratore)
VALUES
  ('2022-05-20', '5', null, 'AlleDodi'),
  ('2022-05-22', '8', '2022-05-23', 'lollo');
