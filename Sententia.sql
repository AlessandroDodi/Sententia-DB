CREATE TABLE Moderatore(
	Email varchar(320) UNIQUE,
	Username varchar(55) NOT NULL PRIMARY KEY,
	Nome varchar(55) NOT NULL,
	Cognome varchar(55) NOT NULL,
	Psw char(64) NOT NULL
);

CREATE TABLE Utente(
	Email varchar(320) UNIQUE,
	Username varchar(55) NOT NULL PRIMARY KEY,
	Nome varchar(55) NOT NULL,
	Cognome varchar(55) NOT NULL,
	IP char(15) NOT NULL,
	Psw char(64) NOT NULL,
	Foto varchar(55)
);

CREATE TABLE UtentePremium(
	CodUtente varchar(320) PRIMARY KEY,
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username),
	IBAN char(27)
);

CREATE TABLE Amicizia(
	Seguente varchar(320) NOT NULL,
	Seguito varchar(320) NOT NULL,
	FOREIGN KEY (Seguente) REFERENCES Utente(Username),
	FOREIGN KEY (Seguito) REFERENCES Utente(Username),
	PRIMARY KEY (Seguente, Seguito),
	Data timestamp NOT NULL
); 

CREATE TABLE Categoria(
	CodC int PRIMARY KEY,
	Nome varchar(55) NOT NULL
);

CREATE TABLE Oggetto(
	CodO int PRIMARY KEY,
	Nome varchar(55) NOT NULL,
	Descrizione varchar(320) NOT NULL,
	CodC int NOT NULL
);

CREATE TABLE Recensione(
	CodR int PRIMARY KEY,
	Foto varchar(55),
	DataVisionePubblica date NOT NULL,
	Titolo varchar(155) NOT NULL,
	Valore int,
	Descrizione varchar(1555) NOT NULL,
  CONSTRAINT Valore CHECK(Valore >= 0 AND Valore <= 100),
	CodUtente varchar(320) NOT NULL,
	CodO int NOT NULL,
	FOREIGN KEY (CodO) REFERENCES Oggetto(CodO),
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username)
);

CREATE TABLE Medaglia(
	CodUtente varchar(320) NOT NULL,
	CodR int NOT NULL,
	Data timestamp NOT NULL,
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username),
	FOREIGN KEY (CodR) REFERENCES Recensione(CodR),
	PRIMARY KEY (CodUtente, CodR)
);

CREATE TYPE tipoR AS ENUM('Contenuti di natura sessuale', 'Contenuti violenti o ripugnanti', 'Azioni dannose o pericolose', 'Spam o ingannevole');
CREATE TABLE Report(
	CodUtente varchar(320) NOT NULL,
	CodR int NOT NULL,
	TipoReport tipoR,
	Altro varchar(55), --CHECK UNA O L'ALTRA NULL
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username),
	FOREIGN KEY (CodR) REFERENCES Recensione(CodR),
	PRIMARY KEY (CodUtente, CodR)
);

CREATE TABLE Commento(
	CodC int PRIMARY KEY,
	CodR int NOT NULL,
	CodUtente varchar(320) NOT NULL,
	Data timestamp NOT NULL, 
	Testo varchar(1555),
	CodRisposta int NOT NULL,
	CodRRisposta int NOT NULL,
	PRIMARY KEY(CodC, CodR),
	FOREIGN KEY (CodR) REFERENCES Recensione(CodR),
	FOREIGN KEY (CodRisposta) REFERENCES Commento(CodC),
	FOREIGN KEY (CodRRisposta) REFERENCES Commento(CodC),
	UNIQUE(CodC, CodR)
);

CREATE TABLE Messaggio(
	CodM int NOT NULL,
	CodMittente varchar(320) NOT NULL,
	CodDestinatario varchar(320) NOT NULL,
	Letto boolean, 
	Contenuto varchar(1555) NOT NULL,
	Data timestamp NOT NULL, 
	FOREIGN KEY (CodDestinatario) REFERENCES Utente(Username),
	FOREIGN KEY (CodMittente) REFERENCES Utente(Username),
	PRIMARY KEY (CodM, CodMittente, CodDestinatario)
);
--query failed
CREATE TABLE MTesto(
	CodM int NOT NULL,
	CodMittente varchar(320) NOT NULL,
	CodDestinatario varchar(320) NOT NULL,
	Contenuto varchar(1555),
	FOREIGN KEY (CodM) REFERENCES Messaggio(CodM),
	FOREIGN KEY (CodDestinatario) REFERENCES Utente(Username),
	FOREIGN KEY (CodMittente) REFERENCES Utente(Username),
	PRIMARY KEY (CodM, CodMittente, CodDestinatario)
);
--query failed
CREATE TABLE MImmagine(
	CodM int NOT NULL,
	CodMittente varchar(320) NOT NULL,
	CodDestinatario varchar(320) NOT NULL,
	Immagine varchar(55) NOT NULL,
	Descrizione varchar(1555),
	FOREIGN KEY (CodM REFERENCES Messaggio(CodM),
	FOREIGN KEY (CodDestinatario REFERENCES Utente(Username),
	FOREIGN KEY (CodMittente REFERENCES Utente(Username),
	PRIMARY KEY (CodM, CodMittente, CodDestinatario)
);

--query failed
CREATE TABLE MRecensione(
	CodM int NOT NULL,
	CodMittente varchar(320) NOT NULL,
	CodDestinatario varchar(320) NOT NULL,
	codR int NOT NULL,
	FOREIGN KEY (CodM) REFERENCES Messaggio(CodM),
	FOREIGN KEY (CodDestinatario) REFERENCES Messaggio(CodDestinatario),
	FOREIGN KEY (CodMittente) REFERENCES Messaggio(CodMittente),
	FOREIGN KEY (CodR) REFERENCES Recensione(CodR),
	PRIMARY KEY (CodM, CodMittente, CodDestinatario)
);

CREATE TABLE CartaCredito(
	Numero char(16) PRIMARY KEY,
	DScadenza char(5) NOT NULL,
	Titolare varchar(55) NOT NULL
);

CREATE TABLE CartaUtente(
	CodU varchar(320),
	NumeroC char(16),
	PRIMARY KEY(CodU, NumeroC),
	FOREIGN KEY (CodU) REFERENCES Utente(Username),
	FOREIGN KEY (NumeroC) REFERENCES CartaCredito(Numero)
);

CREATE TYPE periodoPiano as ENUM('settimana', 'mese', 'trimestre', 'semestre', 'anno');
CREATE TABLE Piano(
	CodP int PRIMARY KEY,
	CodR int NOT NULL,
	CodUtentePremium varchar(320) NOT NULL, 
	Quantita int NOT NULL, 
	Periodo periodoPiano NOT NULL,
	FOREIGN KEY (CodUtentePremium) REFERENCES UtentePremium(CodUtente),
	FOREIGN KEY (CodR) REFERENCES Recensione(CodR)
);

CREATE TABLE Esclusivita(
	DataAnticipata date NOT NULL,
	CodP int NOT NULL,
	CodR int NOT NULL,
	FOREIGN KEY (CodR) REFERENCES Recensione(CodR),
	FOREIGN KEY (CodP) REFERENCES Piano(CodP),
	PRIMARY KEY (CodP, CodR)
);

CREATE TABLE Iscrizione(
	CodP int PRIMARY KEY,
	CodUtente varchar(320) NOT NULL,
	DIscrizione date NOT NULL,
	DAbbandono date NOT NULL,
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username),
	FOREIGN KEY (CodP) REFERENCES Piano(CodP)
);

CREATE TABLE TransazioneAutomatica(
	TRN char(30) PRIMARY KEY,
	Annullata bool NOT NULL,
	Data date NOT NULL,
	CodPiano int NOT NULL,
	CodUtente varchar(320) NOT NULL,
	NumeroCartaDiCredito char(16) NOT NULL,
	FOREIGN KEY (NumeroCartaDiCredito) REFERENCES CartaCredito(Numero),
	FOREIGN KEY (CodPiano) REFERENCES Piano(CodP),
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username),
	UNIQUE(Data, CodPiano, CodUtente)
);

CREATE TABLE TransazioneManuale(
	TRN char(30) PRIMARY KEY,
	Data date NOT NULL,
	CodMittente varchar(320) NOT NULL,
	CodDestinatario varchar(320) NOT NULL,
	NumeroCartaDiCredito char(16) NOT NULL,
	FOREIGN KEY (NumeroCartaDiCredito) REFERENCES CartaCredito(Numero),
	FOREIGN KEY (CodMittente) REFERENCES Utente(Username),
	FOREIGN KEY (CodDestinatario) REFERENCES Utente(Username),
	UNIQUE(Data, CodMittente, CodDestinatario)
);

CREATE TABLE Ban(
	CodUtente varchar(320) NOT NULL,
	CodModeratore varchar(320) NOT NULL,
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username),
	FOREIGN KEY (CodModeratore) REFERENCES Utente(Username),
	PRIMARY KEY(CodModeratore, CodUtente)
);

create table Rimozione(
	DataEffettuazione date NOT NULL,
	CodR int NOT NULL,
	DAnnullamento date NOT NULL,
	CodModeratore varchar(320) NOT NULL,
	PRIMARY KEY(DataEffettuazione, CodR),
	FOREIGN KEY (CodR) REFERENCES Recensione(CodR),
	FOREIGN KEY (CodModeratore) REFERENCES Utente(Username)
);