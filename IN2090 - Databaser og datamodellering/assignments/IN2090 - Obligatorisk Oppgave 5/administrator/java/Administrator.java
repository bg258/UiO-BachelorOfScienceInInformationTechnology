import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;

public class Administrator {

    public static void main(String[] agrs) {

        String dbname = "marktz"; // Input your UiO-username
        String user = "marktz_priv"; // Input your UiO-username + _priv
        String pwd = "pie0aeCieg"; // Input the password for the _priv-user you got in a mail
        // Connection details
        String connectionStr =
            "user=" + user + "&" +
            "port=5432&" +
            "password=" + pwd + "";

        String host = "jdbc:postgresql://dbpg-ifi-kurs01.uio.no";
        String connectionURL =
            host + "/" + dbname +
            "?sslmode=require&ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory&" +
            connectionStr;

        try {
            // Load driver for PostgreSQL
            Class.forName("org.postgresql.Driver");
            // Create a connection to the database
            Connection connection = DriverManager.getConnection(connectionURL);

            int ch = 0;
            while (ch != 3) {
                System.out.println("-- ADMINISTRATOR --");
                System.out.println("Please choose an option:\n 1. Create bills\n 2. Insert new product\n 3. Exit");
                ch = getIntFromUser("Option: ", true);

                if (ch == 1) {
                    makeBills(connection);
                } else if (ch == 2) {
                    insertProduct(connection);
                }
            }
        } catch (SQLException|ClassNotFoundException ex) {
            System.err.println("Error encountered: " + ex.getMessage());
        }
    }

    private static void makeBills(Connection connection)  throws SQLException {
      System.out.println("-- BILLS --");

      String username = getStrFromUser("Username: ");
      if (username == "") {
        username = "'%%'";
      } else {
        username = "'" + username + "'";
      }

      String Query = "SELECT us.name, us.address, SUM(o.num * p.price)" +
                     "FROM ws.orders as o" +
                          "INNER JOIN ws.users as us USING (cid)" +
                          "INNER JOIN ws.products as p USING (pid)" +
                      "WHERE o.payed = 0 and username LIKE ?" +
                      "GROUP BY us.name, us.address";

      prepareStatement statement = connection.prepareStatement(Query);
      statement.setString(1, username);
      ResultSet rows = statement.executeQuery();

      if (!rows.next()) {
        System.out.println("Something went wrong, no results");
      } else {
        do {
          System.out.println("--BILLS--");
          System.out.println("Name: " + rows.getString(1));
          System.out.println("Address: " + rows.getString(2));
          System.out.println("Total due: " + rows.getString(3));
        }
      }
    }


    private static void insertProduct(Connection connection) throws SQLException {
        // TODO: Oppg 3
    }

    /**
     * Utility method that gets an int as input from user
     * Prints the argument message before getting input
     * If second argument is true, the user does not need to give input and can leave
     * the field blank (resulting in a null)
     */
    private static Integer getIntFromUser(String message, boolean canBeBlank) {
        while (true) {
            String str = getStrFromUser(message);
            if (str.equals("") && canBeBlank) {
                return null;
            }
            try {
                return Integer.valueOf(str);
            } catch (NumberFormatException ex) {
                System.out.println("Please provide an integer or leave blank.");
            }
        }
    }

    /**
     * Utility method that gets a String as input from user
     * Prints the argument message before getting input
     */
    private static String getStrFromUser(String message) {
        Scanner s = new Scanner(System.in);
        System.out.print(message);
        return s.nextLine();
    }
}
