--Durante il log di un utente che inserisce email e password verrà eseguita una query come la seguente

SELECT *
FROM Utente
WHERE Email = 'sarafornaciari@gmail.com' AND Psw = 'aisdouh78biknjpP';

--oppure qualora inserisca lo username

SELECT *
FROM Utente
WHERE Username = 'sara' AND Psw = 'aisdouh78biknjpP';


-- Vedere tutte gli amici di Sara

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

SELECT Messaggio.CodMittente, Messaggio.CodDestinatario, Messaggio.Letto, Messaggio.Data, MTesto.Contenuto, MImmagine.Immagine, MImmagine.Descrizione, Recensione.CodR, Recensione.Descrizione
FROM Messaggio INNER JOIN MTesto ON Messaggio.CodM = MTesto.CodM
