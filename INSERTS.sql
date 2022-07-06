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
  ('sarafornaciari@gmail.com', 'sara', 'Sara', 'Fornaciari', 'aisdouh78biknjpP', '127.0.0.1', 'images/users/sara.png'),
  ('mariorossi@gmail.com', 'MarioRossi', 'Mario', 'Rossi', '2318sk!oj%%3', '127.0.0.2', 'images/users/MarioRossi.png'),
  ('lauracastiello@gmail.com', 'lalla', 'Laura', 'Castiello', 'ojabsld328!k', '127.0.3', 'images/users/default.png'),
  ('jimmy@gmail.com', 'jimmy', 'Jimmy', 'Brown', '3vfds2', '127.0.0.4', 'images/users/jimmy.png'),
  ('marcusspin@gmail.com', 'marcus', 'Marcus', 'Spin', '0n92njke@', '127.0.0.4', 'images/users/default.png');

INSERT INTO UtentePremium
  (CodUtente, IBAN)
VALUES 
  ('sara', 'SI56 2633 0001 2039 086'),
  ('lalla', 'IT60 X054 2811 1010 0000 0123 456');

INSERT INTO Amicizia
  (Seguente, Seguito, Data)
VALUES 
  ('sara', 'jimmy', '2022-01-09'),
  ('laura', 'laura', '2022-02-04'),
  ('marcus', 'marcus', '2022-03-21'),
  ('marcus', 'jimmy', '2021-04-07'),
  ('jimmy', 'sara', '2022-05-12');

INSERT INTO Categoria
  (CodC, Nome)
VALUES 
  ('1', 'Film'),
  ('2', 'Canzoni'),
  ('3', 'Politica'),
  ('4', 'Tecnologia'),
  ('5', 'Eventi'),
  ('6', 'Poesia'),
  ('7', 'Podcast'),
  ('8', 'Frasi'),
  ('9', 'Sport'),
  ('10', 'Animali'),
  ('11', 'Pensieri');

INSERT INTO Oggetto
  (CodO, Nome, Descrizione, CodC)
VALUES 
  ('1', 'Interstellar', 'Un gruppo di scienziati appartenenti un tempo alla NASA, sfruttando un "wormhole" per superare le limitazioni fisiche del viaggio spaziale e coprire le immense distanze del viaggio interstellare, organizza una serie di missioni spaziali alla ricerca di un pianeta abitabile.', '1'),
  ('2', 'Will hunting', 'In un quartiere povero di Boston, Will Hunting (Matt Damon), venti anni, vive in modo precario e scombinato insieme ad alcuni amici, tra i quali spicca il suo migliore amico Chuckie, e guadagna qualcosa pulendo i pavimenti nel dipartimento di matematica del famoso Massachusetts Institute of Technology (MIT).', '1'),
  ('3', 'Cane', 'l cane è un quadrupede ed ha il corpo coperto di pelo. Le sue zampe sono lunghe, forti, snelle, atte alla corsa. Il cane cammina sulla punta delle dita, come il gatto, ma il suo passo non è silenzioso, perché i suoi artigli non sono retrattili e quando cammina li batte sul suolo.', '10'),
  ('4', 'Joe Rogan', 'The Joe Rogan Experience è un podcast ospitato dal comico, presentatore e commentatore a colori UFC americano Joe Rogan. È stato lanciato il 24 dicembre 2009 su YouTube da Rogan e dal comico Brian Redban, che ne è stato co-conduttore e produttore fino al 2013, quando è stato sostituito da Jamie Vernon.', '7'),
  ('5', 'The genius of the crowd', 'Famosa poesia di Charles Bukowski', '6');

INSERT INTO Recensione
  (CodR, Foto, DaaVisionePubblica, Titolo, Valore, Descrizione, CodUtente, CodO)
VALUES
  ('1', 'images/reviews/lalla/1.png,', '2021-04-01', 'Migliore film di sempre', '100', 'Semplicemente il miglior film di sempre', 'lalla', '1'),
  ('2', 'images/reviews/jimmy/1.png,', '2021-04-03', 'Poesia estremamente profonda', '100', 'Questa è la mia poesia preferita di Bukowski. La trovo molto profonda.', 'jimmy', '6'),
  ('3', 'images/reviews/marcus/1.png,', '2022-05-13', 'Miglior film di Robin Williams', '100', 'Film meraviglioso. A mio parare miglior prestazione di Robin Williams', 'marcus', '1'),
  ('4', 'images/reviews/marcus/2.png,', '2022-05-14', 'Il mio podcast preferito', '95', 'Questo è il mio podcast preferito. Joe è molto intelligente e fa ottime domande. Mi piace molto la varietà nel tipo delle persone chiamate', 'marcus', '7'),
  ('5', 'images/reviews/sara/2.png,', '2022-05-15', 'Comprate sul mio sito', '90', 'Comprate bitcoin sul mio sito comprabitcoin.com', 'sara', '7');

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
  ('MarioRossi', '5', 'Spam o ingannevole'),
  ('marcus', '5', 'Spam o ingannevole'),
  ('lalla', '5', 'Spam o ingannevole'),
  ('jimmy', '5', 'Spam o ingannevole');

INSERT INTO Commento
  (CodC, CodR, CodUtente, Data, Testo, CodRisposta, CodRRisposta)
VALUES
  ('1', '5', '2022-06-01', 'Questa è spam, ti ho riportato', '', '')
  ('2', '4', '2022-06-02', 'Hai ragione', '', '')
  ('3', '3', '2022-06-03', 'Concordo', '', '')
  ('4', '2', '2022-06-03', "Non sono d''accordo", '', '');

INSERT INTO Messaggio
  (CodM, CodMittente, Letto, Data)
VALUES
  ('1', 'sara', 'jimmy', 'Ciao Jimmy', '2022-06-10 10:02:36'),
  ('2', 'jimmy', 'sara', 'Ciao Sara', '2022-06-10 10:02:56'),
  ('3', 'sara', 'jimmy', 'Come stai?', '2022-06-10 10:03:10'),
  ('4', 'jimmy', 'sara', 'Mai stato meglio, tu?', '2022-06-10 10:04:41'),
  ('5', 'sara', 'jimmy', 'Idem', '2022-06-10 10:04:59');

INSERT INTO MTesto
  (CodM, CodMittente, CodDestinatario, Contenuto)
VALUES
  ('1', )

...

INSERT INTO CartaCredito
  (Numero, DScadenza, Titolare)
VALUES
  ('5365192748368000', '12/24', 'Laura Castiello'),
  ('5243906784563827', '11/23', 'Jimmy Brown'),
  ('5785097781567052', '01/25', 'Marcus Spin');

INSERT INTO CartaUtente
  (CodU, NumeroC)
VALUES
  ('5365192748368000', 'lalla'),
  ('5243906784563827', 'jimmy'),
  ('5785097781567052', 'marcus');

INSERT INTO Piano
  (CodP, CodR, CodUtentePremium, Quantita, Periodo)
VALUES
  ('')