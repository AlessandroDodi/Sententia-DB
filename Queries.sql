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
ORDER BY DESC Messaggio.data


-- Vedere tutti gli utenti della chat di Sara
SELECT DISTINCT Messaggio.CodDestinatario
FROM
	Messaggio
WHERE (Messaggio.CodMittente = 'sara')

UNION

SELECT DISTINCT Messaggio.CodMittente
FROM
	Messaggio
WHERE (Messaggio.CodDestinatario = 'sara')

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

  -- Vedere tutte le recensioni nel feed
CREATE VIEW RecDisponibiliPerUtente AS
SELECT Utente.Username, R.CodR
FROM Utente, RecensioniVisibili AS R, UtentePremium
WHERE R.DataVisionePubblica <= CURRENT_DATE OR
(UtentePremium.CodUtente = R.CodUtente AND
EXISTS (
	SELECT *
	FROM Iscrizione, Piano, Esclusivita
	WHERE Piano.CodUtentePremium = UtentePremium.CodUtente AND
	Iscrizione.CodUtente = Utente.Username AND
	Iscrizione.CodP = Piano.CodP AND
	Iscrizione.DAbbandono IS NULL AND
	Piano.CodP = Esclusivita.CodP AND
	Esclusivita.CodR = R.CodR AND
	DataAnticipata <= CURRENT_DATE
))

SELECT * 
FROM RecDisponibiliPerUtente
WHERE RecDisponibiliPerUtente.Username = '?'

	--Penso serva un'altra view per questa query ma leo mi ha detto che è nel word e io non lo trovo
	--Notifiche di messaggio non letti o di commenti/like a recensioni postate (Magari si può anche fare una query per il numero di notifiche)
		--per ora l'ho fatto solo per i messaggi. Ma leo ha detto che gli va bene se aggiungiamo una colonna nelle tabelle medaglia e commento. Vedi tu
		SELECT CodMittente
		FROM Messaggio
		WHERE CodDestinatario = 'sara' AND Letto = 'FALSE'
		ORDER BY Data DESC

	-- Vedere tutte le recensioni postate da un utente
	-- Un utente vuole visualizzare tutte le recensioni pubblicate da un'altro utente
		SELECT * 
		FROM RecDisponibiliPerUtente, RecensioniVisibili
		WHERE RecDisponibiliPerUtente.CodR = RecensioniVisibili.CodR AND
			 RecDisponibiliPerUtente.Username = '?' AND 
			 RecensioniVisibili.CodUtente = '?'



	-- ELENCARE tutte le transazioni effettuate da un utente

		SELECT TRN, Annullata Data, NumeroCartaDiCredito, Piano.Quantita
		FROM TransazioneAutomatica, Piano
		WHERE TransazioneAutomatica.CodPiano = Piano.CodP AND 
			TransazioneAutomatica.CodMittente = ?

		UNION

		SELECT TRN, Annullata, Data, NumeroCartaDiCredito, Quantita
		FROM TransazioneManuale
		WHERE TransazioneManuale.CodMittente = ?

	-- Totale donazioni ricevuti di un utente premium
		SELECT SUM(Total)
		FROM (
			SELECT SUM(Quantita) AS Total
			FROM TransazioneManuale
			WHERE CodDestinatario = '?'

			UNION

			SELECT SUM(Piano.Quantita) AS Total
			FROM TransazioneAutomatica, Piano
			WHERE TransazioneAutomatica.CodPiano = Piano.CodP AND 
				Piano.CodUtentePremium = '?'
		)

	-- Calcolo ratio moderatori utenti
		SELECT (
			SELECT COUNT(*)
			FROM Moderatore
		) / (
			SELECT COUNT(*)
			FROM Utente
		)



--------------------------------------
-- -- Vedere tutte le recensioni che ha scritto Sara

-- SELECT Foto, Titolo, Valore, Descrizione, CodUtente, Oggetto.Nome, Categoria.Nome
-- FROM RecDisponibiliPerUtente
-- WHERE RecDisponibiliPerUtente.CodU

-- -- Vedere tutte le recensioni che hanno scritto gli amici di Sara

-- SELECT Foto, Titolo, Valore, Descrizione, CodUtente, Oggetto.Nome, Categoria.Nome
-- FROM RECENSIONE INNER JOIN Oggetto ON Recensione.CodO = Oggetto.CodO INNER JOIN Categoria ON OGgetto.Categoria = Categoria.CodC INNER JOIN Amicizia ON CodUtente = Amicizia.Seguente
-- WHERE CodUtente = 'sara';

-- ...