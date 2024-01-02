import psycopg2

# Login details for database user
dbname = "marktz" # Set in your UiO-username
user = "marktz_priv" # Set in your UiO-username + _priv
pwd = "" # Set inn the password for the _priv-user you got in a mail

# Gather all connection info into one string
connection = \
    "host='dbpg-ifi-kurs01.uio.no' " + \
    "dbname='" + dbname + "' " + \
    "user='" + user + "' " + \
    "port='5432' " + \
    "password='" + pwd + "'"


def frontend():
    conn = psycopg2.connect(connection) # Create a connection
    ch = 0
    username = ""
    while (username == ""):
        print("-- USER FRONTEND --")
        print("Please choose an option:\n 1. Register\n 2. Login\n 3. Exit")
        ch = get_int_from_user("Option: ", True)

        if (ch == 1):
            register(conn) # Register a new user
        elif (ch == 2):
            username = login(conn) # Login with existing user
        elif (ch == 3):
            return # Exit program
    # Once logged in, can now search for products
    search(conn, username)

def register(conn):

    print(" -- REGISTER NEW USER --")
    # Get credentials for new user account
    username = input("Username: ")
    password = input("Password: ")
    name = input("Name: ")
    address = input("Address: ")

    cur = conn.cursor() # Create a cursor object that can be used for executing queries
    # We can use %s as a place holder for a value, and then pass a tuple of values to be substituted for
    # these place holders. The first placeholder is then substituted with the first element in the tuple,
    # and so on.
    # NOTE: NEVER store passwords in plain text for an actual application!!!
    cur.execute("INSERT INTO ws.users(name, username, password, address) VALUES (%s, %s, %s, %s);",
                (name, username, password, address))
    conn.commit()
    print("New user " + username + " added!")


def login(conn):
    print(" -- LOGIN --")
    username = input("Username: ")
    password = input("Password: ")

    cur = conn.cursor()
    # If we do not use these placeholders, the program is susceptible to SQL injection attacks
    # More on this next lecture.
    cur.execute("SELECT username, name FROM ws.users WHERE username = %s AND password = %s;",
                (username, password))

    # To get the resuts from a SELECT-query, we can call fetchall() on the
    # cursor. This will make a list of lists, where each inner list represents one row
    rows = cur.fetchall() # Retrieve all restults into a list of tuples
    if (rows == []):
        # The query returned no results, thus the user-password pair does not exist in the DB
        print("Incorrect username or password.")
        return ""
    else:
        row = rows[0]
        print("Welcome", row[1]) # Print "Welcome <name>"
        return row[0] # Return username

"""
Oppgave 1 - Forbedret søk
I denne oppgaven skal du forbedre søket etter produkter. Brukeren skal kunne
sortere resultatene, og skal kunne velge om sorteringen skal skje på pris
eller produktnavn, i tillegg skal brukeren kunne velge om sorteringen skal
skje fra minst til størst eller størst til minst. Til slutt skal brukeren
kunne velge en begrensning på hvor mange produkter som skal vises.
Merk at om brukeren ikke oppgir noe på spørsmålene, skal ingen begrensning skje.
"""

def search(conn, username):

    print(" -- SEARCH --")
    name = input("Search: ")
    category = input("Category: ")

    # We will now construct the search query based on the user's input
    # For long queries, is is helpful to name the placeholders
    # This is done by placing the name of the place holder in parenthesis between the % and the s
    q = "SELECT p.pid, p.name, p.price, c.name AS category, p.description " + \
        "FROM ws.products AS p INNER JOIN ws.categories AS c USING (cid)" + \
        "WHERE p.name LIKE %(name)s"

    if (category != ""):
        q += " AND c.name = %(category)s"

        print("How should the results be sorted? \n 1. by price \n 2. by name")
        sorted = get_int_from_user("Sorted by: ", False)

        if (sorted != ""):
            print("Sort according to: \n 1. Ascending order \n 2. Descending order")
            order = get_int_from_user("Ordering: ", False)

            if (sorted == 1):
                if (order != ""):
                    if (order == 1):
                        q += " ORDER BY price ASC"
                    elif (order == 2):
                        q += " ORDER BY price DESC"
                elif (order == ""):
                    q += " ORDER BY price"
            elif (sorted == 2):
                if (order != ""):
                    if (order == 1):
                        q += " ORDER BY name ASC"
                    elif (order == 2):
                        q += " ORDER BY name DESC"
            elif (order == ""):
                q += " ORDER BY name"


    limit = get_int_from_user("Limit: ", False)
    if (limit != ""):
        q += " LIMIT " + str(limit)

    q += ";"

    cur = conn.cursor()
    # We can then give a map from placeholder name to value, like below
    cur.execute(q, {'name' : "%"+name+"%", 'category' : category})
    rows = cur.fetchall() # Retrieve all restults into a list of tuples

    if (rows == []):
        print("No results.")
        return

    print(" -- RESULTS --\n")

    for row in rows:

        print("=== " + row[1] + " ===\n" + \
              "Product ID: " + str(row[0]) + "\n" + \
              "Price: " + str(row[2]) + "\n" + \
              "Category: " + row[3])

        if (row[3] != "NULL"):
            print("Description: " + row[4])

        print("\n")

    order_products(conn, username)

"""
Oppgave 2 -
I denne oppgaven skal du implementere order_products(conn, username).
Denne metoden blir kalt etter at en bruker har søkt etter produkter. Denne
metoden skal spørre brukeren om hvilket produkt brukeren ønsker å bestille
basert på pid (produktetsID), og deretter hvor mange av dette produktet som
skal bestilles. Så skal metoden kjøre en INSERT-kommando som setter bestillingen
inn i ws.orders-tabellen.

Merk at man vet brukernavnet til brukeren som skal bestille produktet,
mens i ws.orders skal man legge inn brukerens uid.

En bestilling kan se slikt ut (og er en fortsettelse av søket vist over), hvor
brukeren bestiller 5 eksemplarer av spillet pid lik 2, altså Star Fights 3
"""
def order_products(conn, username):
    print("--- ORDER PRODUCTS ---")
    product_id = get_int_from_user("Order (Product ID): ", False)

    if (product_id != ""):
        amount_p = get_int_from_user("How many: ", True)
        uid_user = get_uid(conn, username)

        query = "INSERT INTO ws.orders (uid, pid, num, date, payed) " + \
                "VALUES (%(uid_user)s, %(product)s, %(amo)s, current_date, 0)"
        cur = conn.cursor()
        cur.execute(query, {'uid_user' : uid_user, 'product' : product_id, 'amo' : amount_p});
        conn.commit()

        if (amount_p == 1):
            print("Product ordered.")
        else:
            print("Products ordered.")
    else:
        print("ordering cancelled!")

def get_uid(conn, username):
    cur = conn.cursor()
    q = "SELECT uid, username " + \
        "FROM ws.users " + \
        "WHERE username LIKE %(username)s;"

    cur.execute(q, {'username' : username})
    rows = cur.fetchall()
    for row in rows:
        x = row[0]
        return x

def get_int_from_user(msg, needed):
    # Utility method that gets an int from the user with the first argument as message
    # Second argument is boolean, and if false allows user to not give input, and will then
    # return None
    while True:
        numStr = input(msg)
        if (numStr == "" and not needed):
            return None;
        try:
            return int(numStr)
        except:
            print("Please provide an integer or leave blank.");


if __name__ == "__main__":
    frontend()
