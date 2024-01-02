import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.util.Scanner;

public class UserFrontendMin {
  public static void main(String[] args){

    String dbname = "marktz"; // Input your UIO-username
    String user = "marktz_priv"; // Input your UIO-username + _priv
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
      Class.forName("ord.postgresql.Driver");

      // Create a connection to the database
      Connection connection = DriverManager.getConnection(host + "/" + dbname
      + "?" + connectionStr);

      String username = null;
      while (username == null){
        System.out.println("-- USER FRONTEND -- ");
        System.out.println("Please choose an option:\n 1. Register\n 2.Login\n 3.Exit");
        int ch = getIntFromUser("Option: ", false);

        if (ch == 1){
          register(connection); // Register new user
        } else if (ch == 2){
          username = login(connection) // Login existing user
        } else if (ch == 3){
          return; // Exit program
        }
      }

      // Once logged in, allow user to search for products
      search(connection, username);
    } catch (SQLException | ClassNotFoundException ex){
      System.err.println("Error encountered: " + ex.getMessage());
    }
  }

  private static void register(Connection connection) throws SQLException {
    System.out.println(" --- REGISTER NEW USER ---");
    // Get credentials for new user
    String username = getStrFromUser("Username: ");
    String password = getStrFromUser("Password: ");
    String name = getStrFromUser("Name: ");
    String address = getStrFromUser("Address: ");

    // To execute queries, we need a PreparedStatement object, created by calling
    // the prepareStatement()-method with a query as argument.
    // We can use ? as a place holder for a value in PreparedStatements,
    // and then set them using setString(int, String), setInt(int, int), ect..
    // where the first argument is the index of the value to set, starting with 1.

    // If we do not use these placeholders, the program is susceptible to SQL
    // injection attacks. More about this on the next lecture.

    PreparedStatement statement = connection.prepareStatement("INSERT INTO ws.users(name, username, password, address) VALUES (?, ?, ?, ?);");
    statement.setString(1, name);
    statement.setString(2, username);
    statement.setString(3, password); // NOTE: NEVER store passwords in plain text for an actual application!!!

    // To execute the query we have made above, simply call the execute()-method.
    statement.execute();
    System.out.println("New user " + username + "added!");
  }

  private static String login(Connection connection) throws SQLException {
    System.out.println(" --- LOGIN --- ");
    // Get login details
    String username = getStrFromUser("Username: ");
    String password = getStrFromUser("Password: ");

    PreparedStatement statement = connection.prepareStatement("SELECT username, password, name FROM ws.users WHERE username = ? AND password = ?;");
    statement.setString(1, username);
    statement.setString(2, password);

    // To execute the SELECT-query, we can call executeQuery() on the
    // statement-object. This will return a ResultSet, an iterator-like object
    // over the results. A ResultSet has a pointer to one row of the result.
    ResultSet rows = statement.executeQuery();

    // However, the ResultSet does not point to a row initially.
    // By calling next() me move the pinter to the next row in the
    // result, and to the first row if not called before. The next() method
    // returns a boolean which is false if there is no more rows in the result,
    // and true otherwise

    if (!rows.next()){
      // The query returned no results, thus the user_password pair does not
      // exist in the DB.
      System.out.println("Incorrect username or password.");
      return null;
    } else {
      // Query returned a result, thus correct username and password
      System.out.println("Welcome " + username);
      return username;
    }
  }

  private static void search(Connection, String username) throws SQLException {
    // We start by gathering input from user, defining the search
    System.out.println(" --- SEARCH ---");
    String name = getStrFromUser("Seach: ");
    String category = getStrFromUser("Category: ");

    // We will now construct the search query based on the user´s input
    String q =
      "SELECT p.pid, p.name, p.price, c.name AS category, p.description " + \
      "FROM ws.products AS p INNER JOIN ws.categories AS c USING (cid) " +
      "WHERE p.name LIKE ?";

    if (!category.equals("")){
      q += " AND c.name = ?";
    }

    q += ";";

    PreparedStatement statement = connection.prepareStatement(q);
    statement.setString(1, '%' + name + '%');
    if (!category.equals("")){
      statement.setString(2, category);
    }

    // We can now execute the query using the executeQuery()-method (described above)
    Resultset rows = statement.executeQuery();

    if (! rows.next()) { // No row to move, this empty result set
      System.out.println("No results.");
      return;
    }

    // The user should be able to pick which product to order based on the product´s pid
    System.out.println("--- RESULTS ---\n");
    do {
      // To get values from the current row in the ResultSet
      // we use getString(int) from Strings, getFloat(int) for floats, ect...
      // The argument int denotes which column to get a value from, starting from index 1
      System.out.println("=== " + rows.getString(2) + "===\n" +
                         "Product ID: " + rows.getInt(1) + "\n" +
                         "Price: " + rows.getFloat(3) + "\n" +
                         "Category: " + rows.getString(4));

      if (!rows.getString(3).equals("NULL")){
        System.out.println("Description: " + rows.getString(5));
      }
      System.out.println("\n");
    } while (rows.next());

    // Now that we have made a search, we will allow the user to order products
    // from the search result
    orderProducts(connection, username);

  }

  private static void orderProducts(Connection connection, String username)
  throws SQLException {
    return
  }

  /**
   * Utility method that gets an int as input from user
   * Prints the argument message before getting input
   * If second argument is true, the user does not need to give input and can
   * leave the field blank (resulting in a null)
   */
  private static Intege getIntFromUser(String message, boolean canBeBlank) {
    while (true){
      String str = getStrFromUser(message);
      if (str.equals("" && canBeBlank)){
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
  private static String getStrFromUser(String message) {
    Scanner s = new Scanner(System.in);
    System.out.println(message);
    return s.nextLine();
  }
}
