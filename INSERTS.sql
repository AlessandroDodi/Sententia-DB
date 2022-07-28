INSERT INTO Moderatore
  (Email, Username, Nome, Cognome, Psw)
VALUES 
  ('dodialessandro3@gmail.com', 'AlleDodi', 'Alessandro', 'Dodi', 'H^EHv,)rZ2&cHS9M'),
  ('amanjotSingh@gmail.com', 'jot', 'Amanjot', 'Singh', 'ni28sk!ks8'),
  ('LeonardoTemperanza@gmail.com', 'lollo', 'Leonardo', 'Temperanza', 'ojabsld328!k'),
  ('luigifini@gmail.com', 'luigi', 'Luigi', 'Fini', '12n988^w2'),
  ('mariacostanzi@gmail.com', 'meri', 'Maria', 'Costanzi', 'jnkacshbi728òç@');

INSERT INTO Utente
  (Email, Username, Nome, Cognome, Psw, IP, Foto)
VALUES 
  ('sarafornaciari@gmail.com', 'sara', 'Sara', 'Fornaciari', 'aisdouh78biknjpP', '127.000.000.001', 'images/users/sara.png'),
  ('mariorossi@gmail.com', 'MarioRossi', 'Mario', 'Rossi', '2318sk!oj%%3', '127.000.000.002', 'images/users/MarioRossi.png'),
  ('lauracastiello@gmail.com', 'lalla', 'Laura', 'Castiello', 'ojabsld328!k', '127.000.000.003', 'images/users/default.png'),
  ('jimmy@gmail.com', 'jimmy', 'Jimmy', 'Brown', '3vfds2', '127.000.000.004', 'images/users/jimmy.png'),
  ('marcusspin@gmail.com', 'marcus', 'Marcus', 'Spin', '0n92njke@', '127.000.000.004', 'images/users/default.png');

INSERT INTO UtentePremium
  (CodUtente, IBAN)
VALUES 
  ('sara', 'IT45X0442834101000000654321'),
  ('lalla', 'IT60X0542811101000000123456');

INSERT INTO Amicizia
  (Seguente, Seguito, Data)
VALUES 
  ('sara', 'jimmy', '2022-01-09'),
  ('sara', 'lalla', '2022-02-04'),
  ('marcus', 'marcus', '2022-03-21'),
  ('marcus', 'jimmy', '2021-04-07'),
  ('jimmy', 'sara', '2022-05-12');

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
  (CodR, Foto, DataPubblicazione, Titolo, Valore, Descrizione, CodUtente, CodO)
VALUES
  ('1', 'images/reviews/lalla/1.png', '2021-04-01', 'Migliore film di sempre', '100', 'Semplicemente il miglior film di sempre', 'lalla', '1'),
  ('2', 'images/reviews/jimmy/2.png', '2021-04-03', 'Poesia estremamente profonda', '100', 'Questa è la mia poesia preferita di Bukowski. La trovo molto profonda.', 'jimmy', '5'),
  ('3', 'images/reviews/marcus/3.png', '2022-05-13', 'Miglior film di Robin Williams', '100', 'Film meraviglioso. A mio parare miglior prestazione di Robin Williams', 'marcus', '2'),
  ('4', 'images/reviews/marcus/.4png', '2022-05-14', 'Il mio podcast preferito', '95', 'Questo è il mio podcast preferito. Joe è molto intelligente e fa ottime domande. Mi piace molto la varietà nel tipo delle persone chiamate', 'marcus', '4'),
  ('5', 'images/reviews/marcus/5.png', '2022-05-15', 'Comprate sul mio sito', '90', 'Comprate bitcoin sul mio sito comprabitcoin.com', 'marcus', '6'),
  ('6', 'images/reviews/sara/5.png', '2022-05-16', 'Imperdibile', '94', 'Sarò breve: questo film entra di diritto nel club dei film unici da riguardare più e più volte. la storia, almeno inizialmente, non appare imprevedibile e ricca di sorprese: Terra che sta diventando inabitabile, quindi serve un altro mondo dove abitare, quindi ecco il progetto dell viaggio interstellare. Ma ecco la rivoluzione: non ci si sofferma più nel mostrare le solite pompose scene tipiche dei film spaziali (piloti che si preparano, musiche eroiche, sfrenata dettagliatura delle navicelle spaziali), ma si vada dritti al cuore della narrazione. Alcuni dei vari accadimenti nello spazio non sono di immediata comprensione per lo spettatore, quasi una conseguenza logica vista la mole di nozioni tecniche su cui si basano: ma questo mi è piaciuto, attriubuisce una certo realismo e una logica che sfuggono allo spettatore medio, ma che vengono più che esaurientemente rese afferrabili col proseguire della trama.', 'sara', '1'),
  ('7', 'images/reviews/lalla/5.png', '2022-05-17', 'Stravolgente', '100','Questo film di psicologia ci mostra come non si debba mai dar per scontato un attore:robin williams,solitamente effervescenza e vitalità allo stato puro-l''attimo fuggente,mrs doubtfire,hook-qui è nei panni di uno psicologo,brillante e amante della vita ma non troppo al di sopra delle righe-e sia detto che considero l''attimo fuggente come uno dei film capolavoro della storia del cinema e keatting come il professore che avrei voluto avere-tuttavia il rientrare nelle righe di williams non mi dispiace affatto,ed lo s9i ritrova solo in risvegli con de niro-il cambiamento di williams è tale in questo flm che può essere paragonato a quello di fabrizi in roma città aperta, nel quale da comico si trasforma in un serio rappresentante di dio.', 'lalla', '2');

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
  ('marcus', '5', 'Spam o ingannevole', NULL),
  ('lalla', '5', 'Spam o ingannevole', NULL),
  ('jimmy', '5', 'Spam o ingannevole', NULL);

INSERT INTO Commento
  (CodC, CodR, CodUtente, Data, Testo, CodCRisposta)
VALUES
  ('1', '5', 'MarioRossi', '2022-06-01', 'Questa è spam, ti ho riportato', null),
  ('2', '4', 'marcus', '2022-06-02', 'Hai ragione', null),
  ('3', '3', 'lalla', '2022-06-03', 'Concordo', null),
  ('4', '4','lalla', '2022-06-03', 'la vedo diversamente', null);

INSERT INTO Messaggio
  (CodM, CodMittente, CodDestinatario, Letto, Data)
VALUES
  ('1', 'sara', 'jimmy', 'TRUE', '2022-06-10 10:02:36'),
  ('2', 'jimmy', 'sara', 'TRUE', '2022-06-10 10:02:56'),
  ('3', 'sara', 'jimmy', 'TRUE', '2022-06-10 10:03:10'),
  ('4', 'jimmy', 'sara', 'TRUE', '2022-06-10 10:04:41'),
  ('5', 'sara', 'jimmy', 'FALSE', '2022-06-10 10:04:59'),
  ('1', 'marcus', 'lalla', 'TRUE', '2022-06-10 11:05:50'),
  ('2', 'lalla', 'marcus', 'TRUE', '2022-06-10 12:34:21'),
  ('3', 'marcus', 'lalla', 'TRUE', '2022-06-10 12:03:51'),
  ('4', 'lalla', 'marcus', 'TRUE', '2022-06-10 15:22:21');

INSERT INTO MTesto
  (CodM, CodMittente, CodDestinatario, Contenuto)
VALUES
  ('1', 'sara', 'jimmy', 'Ciao Jimmy'),
  ('2', 'jimmy', 'sara', 'Ciao Sara'),
  ('3', 'sara', 'jimmy', 'Come stai?'),
  ('4', 'jimmy', 'sara', 'Mai stato meglio, tu?'),
  ('5', 'sara', 'jimmy', 'Idem');

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
  ('5785097781567052', '01/25', 'Mastercard');

INSERT INTO CartaUtente
  (NumeroC, CodU)
VALUES
  ('5365192748368000', 'lalla'),
  ('5243906784563827', 'jimmy'),
  ('5328087472838500', 'MarioRossi'),
  ('5785097781567052', 'marcus');

INSERT INTO Piano
  (CodP, CodUtentePremium, Quantita, Periodo, Attivo)
VALUES
  ('1', 'sara', '1', 'trimestre', 'true'),
  ('2', 'lalla', '2', 'anno', 'true');

INSERT INTO Esclusivita
  (DataAnticipata, CodP, CodR)
VALUES
  ('2022-05-10', '1', '6'),
  ('2022-05-11', '2', '7');

INSERT INTO Iscrizione
  (CodP, CodUtente, DIscrizione, DAbbandono)
VALUES
  ('1', 'jimmy', '2022-07-26', null),
  ('1', 'MarioRossi', '2022-03-11', '2022-06-08'),
  ('2', 'MarioRossi', '2022-04-21', '2022-07-13'),
  ('1', 'jimmy', '2022-04-22', '2022-06-11'),
  ('2', 'jimmy', '2022-05-05', '2022-05-30');

INSERT INTO TransazioneAutomatica
  (TRN, Annullata, Data, CodPiano, CodMittente, NumeroCartaDiCredito)
VALUES
  ('KSBSJUP2130PNISUEHBJ98KNJLIT00', 'false', '2022-03-11', '1', 'MarioRossi', '5328087472838500'),
  ('LKNSKJDO0921KJBKJSBD91JKSDIT00', 'false', '2022-04-21', '2','MarioRossi', '5328087472838500');

INSERT INTO TransazioneManuale
  (TRN, Annullata, Data, CodMittente, CodDestinatario, NumeroCartaDiCredito, Quantita)
VALUES
  ('J98NKSDLKBDKASLB78912ASDJKIT00', 'false', '2022-06-1', 'jimmy', 'sara', '5243906784563827', '20'),
  ('55FBQSFGLJZ4PEKPX2XWR59UCHYFY3', 'false', '2022-05-30', 'jimmy', 'lalla', '5243906784563827', '30');

INSERT INTO Ban
  (CodUtente, CodModeratore)
VALUES
  ('marcus', 'AlleDodi');

INSERT INTO Rimozione
  (DataEffettuazione, CodR, DAnnullamento, CodModeratore)
VALUES
  ('2022-05-20', '5', '2022-05-20', 'AlleDodi');
