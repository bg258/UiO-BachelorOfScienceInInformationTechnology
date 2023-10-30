import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class Administrator{
  public static void main(String[] args){
    String dbname = "marktz"; // Input your UIO-username
    String user = "marktz_priv";   // Input your UIO-username + priv
    String pwd = "pie0aeCieg";    // Input the password for the _priv-user you got in a mail

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

      // Create a connectuon to the database
      // Connection connection = DriverManager.getConnection();

      Connection connection = DriverManager.getConnection(host + "/" + dbname
                                                          + "?" + connectionStr);

      boolean program = true;
      while (program == true){
        System.out.println("\n--- ADMINISTRATOR ---");
        System.out.println("Please choose an option: ");
        System.out.println(" 1. Create bills\n 2. Insert new products \n 3. Exit");

        int ch = getIntFromUser("Option: ", true);

        if (ch == 1) {
          makeBills(connection);
        } else if (ch == 2) {
          insertProducts(connection);
        } else if (ch == 3){
          program = false;
          System.out.println("See you soon!");
        }
      }
    } catch (SQLException|ClassNotFoundException ex) {
        System.err.println("Error encountered: " + ex.getMessage());
    }
  }

  private static void makeBills(Connection connection){
    System.out.println("-- BILLS --");

    // Asking for the username to print the bill
    String username = getStrFromUser("Username: ");
    if (username.isEmpty()){
      username = "%%";
    } else {
      username = "" + username + "";
    }

    String query = "SELECT u.name, u.address, SUM(o.num * p.price)" +
                   "FROM ws.orders AS o " +
                      "INNER JOIN ws.products AS p USING (pid) " +
                      "INNER JOIN ws.users AS u USING (uid) " +
                    "WHERE o.payed = 0 AND u.username LIKE ? " +
                    "GROUP BY u.name, u.address;"

    PreparedStatement statement = connection.prepareStatement(query)
    statement.setString(1, username);
    ResultSet rows = statement.executeQuery();

    if (!rows.next()){
      System.out.println("No results.");
      return;
    } else {
      do {
        System.out.println("\n-- Bill --")
        System.out.println("Name: " + rows.getString(1) + "\n" +
                           "Address: " + rows.getString(2) + "\n" +
                           "Total due: " + rows.getInteger(3));
      }
    }

  }

  private static void insertProducts(Connection connection){
    System.out.println("--INSERT NEW PRODUCT");

    String navn = getStrFromUser("Navn paa produkt?", false);
    Int pris = getIntFromUser("Prisen paa produktet?", false);
    String kat = getStrFromUser("Kategori paa produktet?", false);
    String bes = getStrFromUser("Beskrivelse av produktet: ", false);

    String query = "INSERT INTO ws.products as nyP" +
                   "VALUES (c.cid," + navn + "," + pris + "," + kat + "," + bes + ")" +
                   "SELECT c.cid" +
                   "FROM ws.categories as c" +
                   "WHERE name = " + kat;

    prepareStatement statement = connection.prepareStatement(query);
    statement.setString(1, navn);
    statement.setString(2, pris);
    statement.setString(3, kat);
    statement.setString(4, bes);
    ResultSet rows = statement.executeQuery();

    if (!rows.next()) {
      System.out.println("Something went wrong, no results");
    } else {
      do {
        System.out.println("--INSERT NEW PRODUCT");
        System.out.println("Product name: " + rows.getString(1));
        System.out.println("Price: " + rows.getString(2));
        System.out.println("Category: " + rows.getString(3));
        System.out.println("Description: " + rows.getString(4));
        System.out.println("New product " + rows.getString(1) + " inserted.");
      }
    }
  }

  /**
   * Utility method that gets an int as input from user
   * Prints the argument message before getting input
   * If second argument is true, the user does not need to give input and can
   * leave the field blank (resulting in a null)
   */
   private static Integer getIntFromUser(String message, boolean canBeBlank){
     while (true) {
       String str = getStrFromUser(message);
       if (str.equals("") && canBeBlank){
         return null;
       } try {
         return Integer.valueOf(str);
       } catch (NumberFormatException ex){
         System.out.println("Please provide an integer or leave blank.");
       }
     }
   }

   /**
    * Utility method that gets a String as input from user
    * Prints the argument message before getting input
    */
    private static String getStrFromUser(String message){
      Scanner scanner = new Scanner(System.in);
      System.out.println(message);
      return scanner.nextLine();
    }
}
