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

Trigger
