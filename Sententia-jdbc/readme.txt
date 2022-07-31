17:00 31/07/2022

Gruppo n.28
	Leonardo Temperanza (152831)
	Amanjot Singh (152792)
	Alessandro Dodi (153355)
-----------------------------------------------------------------------

Sententia-jdbc
		lib
			postgresql-42.2.2.jar
		src	
			MainClass.java
			OutputFormatter.java
		readme.txt

-----------------------------------------------------------------------

Per la realizzazione del progetto é stato utilizzato:
	- JAVA 18: per compilare ed eseguire i sorgenti del jdbc

E' necessario che il dbms a cui si desidera connettersi sia
Postgresql.

-----------------------------------------------------------------------

Per i compilare i sorgenti si esegua il seguente comando:
	javac -cp "./src;./lib/postgresql-42.2.2.jar" -d ./bin ./src/MainClass.java

Per eseguire l'applicazione si esegua il seguente comando:
	java -classpath "./bin;./lib/postgresql-42.2.2.jar" MainClass
 