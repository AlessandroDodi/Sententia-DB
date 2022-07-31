17:00 31/07/2022

Gruppo n.28
	Leonardo Temperanza (152831)
	Amanjot Singh (152792)
	Alessandro Dodi (153355)
-----------------------------------------------------------------------

Sententia.zip
	Sententia.pdf
	complete-db.sql
	readme.txt
	Sententia-jdbc
		lib
			postgresql-42.2.2.jar
		src	
			MainClass.java
			OutputFormatter.java
		readme.txt

-----------------------------------------------------------------------
			
Per la realizzazione del progetto é stato utilizzato:
	- DBMS: Postgresql 14 con tool di amministrazione PGADMIN 14
	- JAVA 18: per compilare ed eseguire i sorgenti del jdbc

L'utilizzo del DBMS Postgresql rappresenta un requisito necessario, 
in quanto il progetto sfrutta alcune funzionalitá fornite dal sudetto
dbms.
-----------------------------------------------------------------------

Istruzioni per installare ed utilizzare il database e i sorgenti jdbc.

Per poter installare il database occorre importare il file 
complete-db.sql nel proprio DBMS. Per farlo basta creare un database
con nome 'Sententia' e copiare il contenuto del file complete/db.sql
nella query tool di pg-admin.
E' necessario che il database abbia il nome 'Sententia', 
poiché é il nome che é stato utilizzato dal progetto jdbc per
connettersi al database.

Le istruzioni per la compilazione ed esecuzione del progetto jdbc
sono contenute nel file readme.txt della cartella Sententia-jdbc.
