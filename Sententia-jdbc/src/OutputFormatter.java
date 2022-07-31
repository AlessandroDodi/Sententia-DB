import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

public class OutputFormatter {
	
	public static void printResultSet(ResultSet result) throws SQLException {
		List<List<String>> rows = new ArrayList<>();
		
		List<String> row = new ArrayList<String>();
		ResultSetMetaData rsmd = result.getMetaData();
		
		for (int i = 1; i <= rsmd.getColumnCount(); i++)
			row.add(rsmd.getColumnName(i));
		
		rows.add(row);
		
		while (result.next()) {
			row = new ArrayList<String>();
			for (int i = 1; i <= rsmd.getColumnCount(); i++)
				row.add(result.getString(i));
			
			rows.add(row);
		}
		
		System.out.println(formatAsTable(rows));
	}
	
	private static String formatAsTable(List<List<String>> rows)
	{
	    int[] maxLengths = new int[rows.get(0).size()];
	    for (List<String> row : rows)
	    {
	        for (int i = 0; i < row.size(); i++)
	        {
	        	if (row.get(i) != null)
	        		maxLengths[i] = Math.max(maxLengths[i], row.get(i).length());
	        }
	    }

	    StringBuilder formatBuilder = new StringBuilder();
	    for (int maxLength : maxLengths)
	    {
	        formatBuilder.append("%-").append(maxLength + 2).append("s");
	    }
	    
	    String format = formatBuilder.toString();

	    StringBuilder result = new StringBuilder();
	    for (List<String> row : rows)
	    {
	        result.append(String.format(format, row.toArray())).append("\n");
	    }
	    
	    return result.toString();
	}
}
