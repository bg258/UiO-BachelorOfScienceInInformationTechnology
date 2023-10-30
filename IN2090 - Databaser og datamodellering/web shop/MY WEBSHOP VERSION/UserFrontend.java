import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.util.Scanner;
import java.util.List;
import java.util.LinkedList;

public class UserFrontend{

  private static String user = "";
  private static String pwd = "";
  private static String connectionStr =
  "sslmode=require&ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory&" +
  "user=" + user + "_priv" +
  "port=5432&" +
  "password=" + pwd + "";

  private static String host = "jdbc:postgresql://dbpg-ifi-kurs01.uio.no";

  public static void main(String[] args){
    try {
      // Java standard metode som laster inn definisjonen av en klasse
      class.forName("org.postgresql.Driver");
      Connection connection = DriverManager.getConnection(host + "/" + user
                                                          + "?" + connectionStr);
      int ch = 0;
      String username = null;

      while (username == null){
        System.out.println("--- USER FRONTEND ---");
        System.out.println("Please choose an option:\n 1.Register\n 2.Login\n 3.Exit");

        ch = getIntFromUser("Option: ", false);
        if (ch == 1){
          register(connection);
        } else if (ch == 2){
          username = login(connection);
        } else if (ch == 3){
          return;
        }
      }
      search(connection, username);
    } catch (SQLException|ClassNotFoundException ex){
      System.err.println("Error encountered: " + ex.getMessage());
    }
  }

  public static void register(Connection connection) throws SQLException{
    // Det første vi må gjøre er å lage en Statement-objekt
    // Deretter vil vi hente ut den nødvendig informasjonen for å
    // registrere en ny bruker i databasen vår.

    System.out.println("--- REGISTER --- ");
    String username = getStrFromUser("Username: ");
    String password = getStrFromUser("Password: ");
    String name = getStrFromUser("Name: ");
    String address = getStrFromUser("Address: ");

    // Statement-objektet
    PreparedStatement statement = connection.prepareStatement("INSERT INTO ws.users(username, password, name, address) VALUES (?, ?, ?, ?);")

    // Vi gir ikke verdiene med en gang, men vi har metoder for å sette
    // disse verdiene.
    statement.setString(1, username);
    statement.setString(2, password);
    statement.setString(3, name);
    statement.setString(4, address);

    // Ogaå ønsker vi å eksekvere denne spørringen.
    statement.execute();
    System.out.println("Username " + username + " added.");

  }

  public static void login(Connection connection) throws SQLException{
    System.out.println("--- LOGIN ---");
    // Vi vil hente brukernavn og password
    String username = getStrFromUser("Username: ");
    String password = getStrFromUser("Password: ");

    PreparedStatement statement = connection.prepareStatement("SELECT username, password, name FROM ws.users WHERE username = ? AND password = ?");
    statement.setString(1, username);
    statement.setString(2, password);

    ResultSet result = statement.executeQuery();
    if (! result.next()){
      System.out.println("Wrong username or password.");
      return null;
    } else {
      System.out.println("Welcome " + result.getString(3));
      return res.getString(1);
    }
  }

  public static void search(Connection connection, String username) throws SQLException{
    List<Integer> products = new LinkedList<>();
    // We start by gathering input from user, defining the search
    System.out.println("--- SEARCH ---");
    String name = getStrFromUser("Search: ");
    String category = getStrFromUser("Category: ");

    // We will now construct the search query based on the user´s input
    String q =
      "SELECT p.pid, p.name, p.pricem c.name AS category, p.description" +
      "FROM ws.products AS p INNER JOIN ws.categories AS c USING (cid)" +
      "WHERE p.name LIKE ?";

    if (! category.equals("")){
      q += " AND c.name = ?";
    }

    q += ";";

    PreparedStatement statement = connection.prepareStatement(q);
    statement.setString(1, '%' + name + '%');

    if (! category.equals("")){
      statement..setString(2, category);
    }

    // We can now execute the query using the executeQuery()-method (described above).
    ResultSet rows = statement.executeQuery();
    if (! rows.next(){ // No row to move to, thus empty result set
      System.out.println("No results.");
      return;
    }

    // The user shoul be able to pick to order based on the products pid
    System.out.println("-- RESULTS --");
    do {
      // To get values from the current row in the ResultSet
      // we use getString(int) from Strings, getFloat(int) for floats, etc.
      // The argument int denotes which column to get a value from, starting
      // from index 1
      System.out.println("===" + rows.getString(2) + "===\n" +
                         "Product ID: " + rows.getInt(1) + "\n" +
                         "Price: " + rows.getFloat(3) + "\n" +
                         "Category: " + rows.getString(4));
      if (! rows.getString(3).equals("NULL"){
        System.our.println("Description: " + rows.getString(5));
      }
      System.out.println("\n");
      products.add(rows.getInt(1));
    } while (rows.next());

    // Now that we have made a seach, we will allow the user to order products
    // from the  search result
    orderProducts(connection, username, products);

  }

  private static void orderProducts(Connection connection, String username, List<Integer> products){
    System.out.println("--- ORDER ---");
    Integer order = getIntFromUser("Order: ", true);
    if (order == null){
      return;
    }

    // We will let users order several of the same product in a single order
    Integer num = getIntFromUser("How many: ", false);
    String oq = "INSERT INTO ws.orders (uid, pid, num, date, payed) ";
    oq += "SELECT uid, ?, ?, current_date, 0 " +
          "FROM ws.users " +
          "WHERE username = ?;";

    PreparedStatement statement = connection.prepareStatement(oq);
    statement.setInt(1, products.get(order));
    statement.setInt(2, num);
    statement.setInt(3, username);
    statement.execute();

    System.out.println("Product(s) ordered.");

  }

  /**
   * Utility method that gets an int as input from user
   * Prints the argument message before getting input
   * If second argument is true, the user does not need to give input and can
   * leave the field blank (resulting in a null)
   */
   private static Integer getIntFromUser(String message, boolean canBeBlank) {
     while (true){
       String str = getStrFromUser(message);
       if (str.equals("") && canBeBlank){
         return null;
       }
       try {
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
      Scanner s = new Scanner(System.in);
      System.out.println(message);
      return s.nextLine();
    }
}
