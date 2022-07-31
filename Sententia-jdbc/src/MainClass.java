import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class MainClass {
	
	public static void main(String[] args){
		try{
			Class.forName ("org.postgresql.Driver");  // Load the Driver
			Connection conn = DriverManager.getConnection( "jdbc:postgresql://localhost:5432/Sententia", "client", "topolino2022");
			
			Scanner sc = new Scanner(System.in);
			boolean exit = true;
			
			System.out.println("Autenticazione");
			
			System.out.println("Inserisci username: ");
			String username = sc.nextLine();
			
			System.out.println("Inserisci password: ");
			String password = sc.nextLine();
			
			PreparedStatement st = conn.prepareStatement("SELECT user_login(?, ?)");
			st.setString(1, username);
			st.setString(2, password);
			
			ResultSet res = st.executeQuery();
			if(res.next()) 
				if (res.getBoolean(1))
					exit = false;
			
			if (!exit)
				System.out.println("Autenticazione avvenuta con successo");
			else
				System.out.println("Autenticazione fallita!!");
					
			st.close();
			
			while (!exit) {
				int option = -1;
				while (option != 14)  {
					System.out.println("Utente: " + username);
					System.out.println("1.  Visualizza gli amici");
					System.out.println("2.  Visualizza il numero di amici");
					System.out.println("3.  Visualizza gli utenti che mi seguono");
					System.out.println("4.  Visualizza il numero di utenti che mi seguono");
					System.out.println("5.  Visualizza la chat tra due utenti");
					System.out.println("6.  Visualizza tutti gli utenti con cui ho scritto");
					System.out.println("7.  Visualizza tutte le carte di credito");
					System.out.println("8.  Visualizza i miei abbonamenti attivi");
					System.out.println("9.  Visualizza tutte le recensioni nel mio feed");
					System.out.println("10. Visualizza tutte le recensioni scritte da un dato utente");
					System.out.println("11. Visualizza tutte le transazioni effettuate");
					System.out.println("12. Visualizza il totale delle transazioni ricevute");
					System.out.println("13. Cambia password");
					System.out.println("14. Exit");
					System.out.println("Inserisci una scelta");
	
					option = Integer.parseInt(sc.nextLine());
					
					
					PreparedStatement stmt = null;
					
					switch (option) {
					case 1:
					{
						stmt = conn.prepareStatement("SELECT seguito AS Nome, data FROM Amicizia WHERE Seguente = ? ");
						stmt.setString(1, username);
						break;
					}
					
					case 2:
	
					{					
						stmt = conn.prepareStatement("SELECT COUNT(*) AS NAmici FROM Amicizia WHERE Seguente = ?");
						stmt.setString(1, username);
						break;
					}
					
					case 3:
	
					{					
						stmt = conn.prepareStatement("SELECT seguente AS Nome FROM Amicizia WHERE Seguito = ?");
						stmt.setString(1, username);
						break;
					}
					
					case 4:
					{					
						stmt = conn.prepareStatement("SELECT COUNT(*) AS NFollower FROM Amicizia WHERE Seguito = ?");
						stmt.setString(1, username);
						break;
					}
					
					case 5:
					{						
						System.out.println("Inserire l'username dell'utente di cui si vuole memorizzare la chat: ");
						String username2 = sc.nextLine();
						
						stmt = conn.prepareStatement("SELECT"
														+ "	Messaggio.CodMittente,"
														+ "	Messaggio.CodDestinatario,"
														+ "	Messaggio.Letto,"
														+ "	Messaggio.Data,"
														+ "	MTesto.Contenuto,"
														+ "	MImmagine.Immagine,"
														+ "	MImmagine.Descrizione,"
														+ "	MRecensione.CodR,"
														+ "	MRecensione.Descrizione"
														+ " FROM Messaggio"
														+ " FULL JOIN MTesto ON Messaggio.CodM = MTesto.CodM"
														+ "		AND Messaggio.CodMittente = MTesto.CodMittente"
														+ "		AND Messaggio.CodDestinatario = MTesto.CodDestinatario"
														+ " FULL JOIN MImmagine ON Messaggio.CodM = MImmagine.CodM"
														+ "		AND Messaggio.CodMittente = MImmagine.CodMittente"
														+ "		AND Messaggio.CodDestinatario = MImmagine.CodDestinatario"
														+ " FULL JOIN MRecensione ON Messaggio.CodM = MRecensione.CodM"
														+ "		AND Messaggio.CodMittente = MRecensione.CodMittente"
														+ "		AND Messaggio.CodDestinatario = MRecensione.CodDestinatario"
														+ " WHERE (Messaggio.CodMittente = ?"
														+ "	AND Messaggio.CodDestinatario = ?)"
														+ "	OR(Messaggio.CodMittente = ?"
														+ "		AND Messaggio.CodDestinatario = ?)"
														+ " ORDER BY Messaggio.data");
						
						
						
						stmt.setString(1, username);
						stmt.setString(2, username2);
						stmt.setString(3, username2);
						stmt.setString(4, username);
						break;
					}
					
					case 6:
					{					
						stmt = conn.prepareStatement("SELECT DISTINCT Messaggio.CodDestinatario"
														+ " FROM Messaggio"
														+ " WHERE (Messaggio.CodMittente = ?) "
														+ " UNION"
														+ "	SELECT DISTINCT Messaggio.CodMittente"
														+ " FROM Messaggio"
														+ " WHERE (Messaggio.CodDestinatario = ?)");
						stmt.setString(1, username);
						stmt.setString(2, username);
						break;
					}
					
					case 7:
					{					
						stmt = conn.prepareStatement("SELECT"
														+ "	CartaCredito.Numero,"
														+ "	CartaCredito.DScadenza,"
														+ "	CartaCredito.EnteEmittente,"
														+ "	Utente.Nome,"
														+ "	Utente.Cognome"
														+ " FROM CartaCredito"
														+ "	JOIN CartaUtente ON CartaCredito.NUmero = CartaUtente.NumeroC"
														+ "	JOIN Utente ON CartaUtente.CodU = Utente.Username"
														+ " WHERE"
														+ "	Utente.Username = ?");
						stmt.setString(1, username);
						break;
					}
					
					case 8: 
					{
						stmt = conn.prepareStatement("SELECT"
														+ "	Iscrizione.DIscrizione,"
														+ "	Piano.CodUtentePremium,"
														+ "	Piano.Periodo,"
														+ "	Piano.Quantita"
														+ " FROM Iscrizione"
														+ "	JOIN Piano ON Iscrizione.CodP = Piano.CodP"
														+ " WHERE Iscrizione.CodUtente = ?"
														+ "	AND Iscrizione.DAbbandono = NULL");
						stmt.setString(1, username);
						break;
					}
					
					case 9:
					{
						stmt = conn.prepareStatement("SELECT * " + 
													 "FROM RecDisponibiliPerUtente " +
													 "WHERE RecDisponibiliPerUtente.Username = ?");
						
						stmt.setString(1,  username);
						break;
					}
					
					case 10:
					{
						System.out.println("Inserire l'username dell'utente di cui si vogliono memorizzare le recensioni: ");
						String username2 = sc.nextLine();
						
						stmt = conn.prepareStatement("SELECT * "
													+ "	FROM RecDisponibiliPerUtente, RecensioniVisibili"
													+ "	WHERE RecDisponibiliPerUtente.CodR = RecensioniVisibili.CodR AND"
													+ "		RecDisponibiliPerUtente.Username = ? AND "
													+ "		RecensioniVisibili.CodUtente = ?");
						
						stmt.setString(1, username);
						stmt.setString(2, username2);
						break;
					}
					
					case 11: 
					{
						stmt = conn.prepareStatement("SELECT TRN, Annullata, Data, NumeroCartaDiCredito, Piano.Quantita"
								+ "		FROM TransazioneAutomatica, Piano"
								+ "		WHERE TransazioneAutomatica.CodPiano = Piano.CodP AND "
								+ "			TransazioneAutomatica.CodMittente = ?"
								+ ""
								+ "		UNION"
								+ ""
								+ "		SELECT TRN, Annullata, Data, NumeroCartaDiCredito, Quantita"
								+ "		FROM TransazioneManuale"
								+ "		WHERE TransazioneManuale.CodMittente = ?");
						
						stmt.setString(1, username);
						stmt.setString(2, username);
						break;
					}
					
					case 12:
					{
						stmt = conn.prepareStatement("SELECT SUM(Total)"
								+ "		FROM ("
								+ "			SELECT SUM(Quantita) AS Total"
								+ "			FROM TransazioneManuale"
								+ "			WHERE CodDestinatario = ?"
								+ ""
								+ "			UNION"
								+ ""
								+ "			SELECT SUM(Piano.Quantita) AS Total"
								+ "			FROM TransazioneAutomatica, Piano"
								+ "			WHERE TransazioneAutomatica.CodPiano = Piano.CodP AND "
								+ "				Piano.CodUtentePremium = ?"
								+ "	) AS foo");
						
						stmt.setString(1, username);
						stmt.setString(2, username);
						break;
					}
					
					case 13:
					{
						System.out.println("Inserire la vecchia password: ");
						String old_psw = sc.nextLine();

						System.out.println("Inserire la nuova password: ");
						String new_psw = sc.nextLine();
						
						
						stmt = conn.prepareStatement("SELECT change_psw(?, ?, ?)");
						stmt.setString(1, username);
						stmt.setString(2, new_psw);
						stmt.setString(3, old_psw);
						
						ResultSet exec = stmt.executeQuery();
						if (exec.next()) {
							if (exec.getBoolean(1))
								System.out.println("Operazione avvenuta con successo");
							else 
								System.out.println("Operazione fallita!!!");
						}
						break;
					}
						
					case 14:	
					default:
						exit = true;
						continue;
					};
					
					if (stmt != null && option != 13) {
						OutputFormatter.printResultSet(stmt.executeQuery());
						stmt.close();
					}
				}
						
			}
			
			conn.close();
			sc.close();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
}
