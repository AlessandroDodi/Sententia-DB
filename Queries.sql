--Durante il log di un utente che inserisce email e password verrà eseguita una query come la seguente

SELECT *
FROM Utente
WHERE Email = 'sarafornaciari@gmail.com' AND Psw = 'aisdouh78biknjpP';

--oppure qualora inserisca lo username

SELECT *
FROM Utente
WHERE Username = 'sara' AND Psw = 'aisdouh78biknjpP';


-- Vedere tutte gli amici di Sara---

SELECT *
FROM Amicizia
WHERE Seguente = 'sara';

--Contare il numero di amici che ha Sara

SELECT COUNT(*)
FROM Amicizia
WHERE Seguente = 'sara';


-- Vedere tutte gli utenti che hanno come amica Sara

SELECT *
FROM Amicizia
WHERE Seguito = 'sara';

-- Contare tutti gli utenti che hanno come amica Sara

SELECT COUNT(*)
FROM Amicizia
WHERE Seguito = 'sara';

-- Vedere tutte le recensioni che ha scritto Sara

SELECT Foto, Titolo, Valore, Descrizione, CodUtente, Oggetto.Nome, Categoria.Nome
FROM RECENSIONE INNER JOIN Oggetto ON Recensione.CodO = Oggetto.CodO INNER JOIN Categoria ON Oggetto.Categoria = Categoria.CodC
WHERE CodUtente = 'sara';

-- Vedere tutte le recensioni che hanno scritto gli amici di Sara

SELECT Foto, Titolo, Valore, Descrizione, CodUtente, Oggetto.Nome, Categoria.Nome
FROM RECENSIONE INNER JOIN Oggetto ON Recensione.CodO = Oggetto.CodO INNER JOIN Categoria ON OGgetto.Categoria = Categoria.CodC INNER JOIN Amicizia ON CodUtente = Amicizia.Seguente
WHERE CodUtente = 'sara';

...

-- Vedere una chat fra due utenti

SELECT
	Messaggio.CodMittente,
	Messaggio.CodDestinatario,
	Messaggio.Letto,
	Messaggio.Data,
	MTesto.Contenuto,
	MImmagine.Immagine,
	MImmagine.Descrizione,
	MRecensione.CodR,
	MRecensione.Descrizione
FROM
	Messaggio
	FULL JOIN MTesto ON Messaggio.CodM = MTesto.CodM
		AND Messaggio.CodMittente = MTesto.CodMittente
		AND Messaggio.CodDestinatario = MTesto.CodDestinatario
	FULL JOIN MImmagine ON Messaggio.CodM = MImmagine.CodM
		AND Messaggio.CodMittente = MImmagine.CodMittente
		AND Messaggio.CodDestinatario = MImmagine.CodDestinatario
	FULL JOIN MRecensione ON Messaggio.CodM = MRecensione.CodM
		AND Messaggio.CodMittente = MRecensione.CodMittente
		AND Messaggio.CodDestinatario = MRecensione.CodDestinatario
WHERE (Messaggio.CodMittente = 'sara'
	AND Messaggio.CodDestinatario = 'jimmy')
	OR(Messaggio.CodMittente = 'jimmy'
		AND Messaggio.CodDestinatario = 'sara')


-- Vedere le proprie carte di credito salvate
SELECT
	CartaCredito.Numero,
	CartaCredito.DScadenza,
	CartaCredito.EnteEmittente,
	Utente.Nome,
	Utente.Cognome
FROM
	CartaCredito
	JOIN CartaUtente ON CartaCredito.NUmero = CartaUtente.NumeroC
	JOIN Utente ON CartaUtente.CodU = Utente.Username
WHERE
	Utente.Username = 'lalla'

--Vedere i propri abbonamenti (attivi e disattivi)
SELECT
	Iscrizione.DIscrizione,
	Piano.CodUtentePremium,
	Piano.Periodo,
	Piano.Quantita
FROM
	Iscrizione
	JOIN Piano ON Iscrizione.CodP = Piano.CodP
WHERE
	Iscrizione.CodUtente = 'jimmy'

--Vedere i propri abbonamenti attivi
SELECT
	Iscrizione.DIscrizione,
	Piano.CodUtentePremium,
	Piano.Periodo,
	Piano.Quantita
FROM
	Iscrizione
	JOIN Piano ON Iscrizione.CodP = Piano.CodP
WHERE
	Iscrizione.CodUtente = 'jimmy'
	AND Iscrizione.DAbbandono = NULL

  