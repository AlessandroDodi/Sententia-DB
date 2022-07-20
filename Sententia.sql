CREATE TABLE Moderatore(
	Email varchar(320) UNIQUE,
	Username varchar(55) PRIMARY KEY,
	Nome varchar(55) NOT NULL,
	Cognome varchar(55) NOT NULL,
	Psw char(64) NOT NULL
);

CREATE TABLE Utente(
	Email varchar(320) UNIQUE,
	Username varchar(55) PRIMARY KEY,
	Nome varchar(55) NOT NULL,
	Cognome varchar(55) NOT NULL,
	IP char(15) NOT NULL,
	Psw char(64) NOT NULL,
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
	Data timestamp NOT NULL
); 

CREATE TABLE Oggetto(
	CodO int PRIMARY KEY AUTO_INCREMENT,
	Nome varchar(55) NOT NULL,
	Descrizione varchar(320) NOT NULL,
	Categoria varchar(55) NOT NULL,
);

CREATE TABLE Recensione(
	CodR int PRIMARY KEY,
	Foto varchar(55),
	DataPubblicazione date NOT NULL,
	DataVisionePubblica date NOT NULL,
	Titolo varchar(155) NOT NULL,
	Valore int,
	Descrizione varchar(1555) NOT NULL,
	CHECK(Valore >= 0 AND Valore <= 100),
	CodUtente varchar(55) NOT NULL,
	CodO int NOT NULL,
	FOREIGN KEY (CodO) REFERENCES Oggetto(CodO),
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username)
);

CREATE TABLE Medaglia(
	CodUtente varchar(55),
	CodR int,
	Data timestamp NOT NULL,
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
	CHECK((TipoReport IS NULL AND Altro IS NOT NULL) OR (TipoReport IS NOT NULL AND Altro IS NULL))
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
	CodCRisposta int NOT NULL,
	PRIMARY KEY(CodC, CodR),
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
	Contenuto varchar(1555),
	FOREIGN KEY (CodM, CodMittente, CodDestinatario) REFERENCES Messaggio(CodM, CodMittente, CodDestinatario)
	PRIMARY KEY (CodM, CodMittente, CodDestinatario)
);

CREATE TABLE MImmagine(
	CodM int,
	CodMittente varchar(55),
	CodDestinatario varchar(55),
	Immagine varchar(55),
	Descrizione varchar(1555),
	FOREIGN KEY (CodM, CodMittente, CodDestinatario) REFERENCES Messaggio(CodM, CodMittente, CodDestinatario)
	PRIMARY KEY (CodM, CodMittente, CodDestinatario)
);

CREATE TABLE MRecensione(
	CodM int,
	CodMittente varchar(55),
	CodDestinatario varchar(55),
	codR int NOT NULL,
	Descrizione varchar(1555),
	FOREIGN KEY (CodM, CodMittente, CodDestinatario) REFERENCES Messaggio(CodM, CodMittente, CodDestinatario)
	FOREIGN KEY (CodR) REFERENCES Recensione(CodR),
	PRIMARY KEY (CodM, CodMittente, CodDestinatario)
);

CREATE TABLE CartaCredito(
	Numero char(16) PRIMARY KEY,
	DScadenza char(5) NOT NULL,
	EnteEmittente varchar(30) NOT NULL,
);

CREATE TABLE CartaUtente(
	CodU varchar(55),
	NumeroC char(16),
	PRIMARY KEY(CodU, NumeroC),
	FOREIGN KEY (CodU) REFERENCES Utente(Username),
	FOREIGN KEY (NumeroC) REFERENCES CartaCredito(Numero)
);

CREATE TYPE periodoPiano as ENUM('settimana', 'mese', 'trimestre', 'semestre', 'anno');
CREATE TABLE Piano(
	CodP int PRIMARY KEY,
	CodR int NOT NULL,
	CodUtentePremium varchar(55) NOT NULL, 
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
	CodUtente varchar(55) NOT NULL,
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
	CodUtente varchar(55) NOT NULL,
	NumeroCartaDiCredito char(16) NOT NULL,
	FOREIGN KEY (NumeroCartaDiCredito) REFERENCES CartaCredito(Numero),
	FOREIGN KEY (CodPiano) REFERENCES Piano(CodP),
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username),
	UNIQUE(Data, CodPiano, CodUtente)
);

CREATE TABLE TransazioneManuale(
	TRN char(30) PRIMARY KEY,
	Data date NOT NULL,
	CodMittente varchar(55) NOT NULL,
	CodDestinatario varchar(55) NOT NULL,
	NumeroCartaDiCredito char(16) NOT NULL,
	FOREIGN KEY (NumeroCartaDiCredito) REFERENCES CartaCredito(Numero),
	FOREIGN KEY (CodMittente) REFERENCES Utente(Username),
	FOREIGN KEY (CodDestinatario) REFERENCES Utente(Username),
	UNIQUE(Data, CodMittente, CodDestinatario)
);

CREATE TABLE Ban(
	CodUtente varchar(55) PRIMARY KEY,
	CodModeratore varchar(55) NOT NULL,
	FOREIGN KEY (CodUtente) REFERENCES Utente(Username),
	FOREIGN KEY (CodModeratore) REFERENCES Utente(Username)
);

create table Rimozione(
	DataEffettuazione date NOT NULL,
	CodR int NOT NULL,
	DAnnullamento date NOT NULL,
	CodModeratore varchar(55) NOT NULL,
	PRIMARY KEY(DataEffettuazione, CodR),
	FOREIGN KEY (CodR) REFERENCES Recensione(CodR),
	FOREIGN KEY (CodModeratore) REFERENCES Utente(Username)
);
