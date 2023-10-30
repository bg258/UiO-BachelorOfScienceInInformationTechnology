import psycopg2

# Login details for database user  marktz_priv
dbname = "" # Set in your UIO-username
user = "" # Set in your UIO-username + "_priv"
pwd = "" # Set in the password for the _priv-user you got in a mail

# Gather all connection info into one string
connection = \
    "host='dbpg-ifi-kurs01.uio.no' " + \
    "dbname='" + dbname + "' " + \
    "user='" + user + "' " + \
    "port='5432' " + \
    "password='" + pwd + "'"

# Det første vi skal gjøre er å generere en connection for vår database (Et
# connection objekt)

def frontend():
    # Det første vi gjør er å kalle på navnet til biblioteket for å koble
    # oss til databasen
    conn = psycopg2.connect(connection) # Create a connection
    ch = 0
    username = ""
    password = ""

    while (username == ""):
        print("--- USER FRONTEND ---")
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
    # Siden vi skal registrere en ny bruker, henter vi den nødvendig informasjon
    # Get credentials for new user account
    print("-- REGISTER NEW USER --")
    username = input("Username: ")
    password = input("Password: ")
    name = input("Name: ")
    address = input("Adress: ")

    # Nå som vi har den nødvendig informasjon, er det på tide å sette det
    # i vårt database. Vi har en connection - objekt, så først må vi lage
    # en spørring-eksekverer (cursor)

    # Create a cursor object that can be used for executing queries.
    # We can use %s as a place holder for a value, and then pass a tuple of values
    # to be substituted for these place holders. The first placeholder is then
    # substituted with the first element in the tuple, and so on.
    # NOTE: NEVER store passwords in plain text for an actual application!!

    cur = conn.curso
    cur.execute("INSERT INTO ws.users (name, username, password, address) " + \
                "VALUES (%s, %s, %s, %s);", (name, username, password, address))
    conn.commit()
    print("New user " + username + " added!")


def login(conn):
    # Tankegangen med LOGIN funksjonen er at vi skal hente et brukernavn
    # og et passord og sjekke om det stemmer med informasjonen i databasen.
    print("-- LOGIN --")
    username = input("Username: ")
    password = input("Password: ")

    # Vi må lage et cursor-objektet for å kunne opprettholde cursore
    cur = conn.cursor()
    # If we do not use these placeholders, the program is susceptible to
    # SQL injections attacks. More on this next lecture.
    cur.execute("SELECT username, password, name " + \
                "FROM ws.users WHERE Username = %s AND password = %s;",
                (username, password))

    # To get the results from a SELECT-query, we can call fetchall() on the
    # cursor. This will make a list of lists, where each inner list represents
    # one row. Retribe all results into a list of tuples,
    rows = cur.fetchall()

    # tom liste. Brukeren oppga ikke riktig brukernavn eller password
    if (rows == []):
        # The query returned no results, thus the user-password pair does
        # not exist in the DB
        print("Incorrect username or password.")
        return ""
    else:
        row = rows[0]
        print("Welcome, " + row[2]) # Print "Welcome <name>"
        return row[0] # Return username

    return


def search(conn, username):
    print("-- SEARCH -- ")
    name = input("Search: ")
    category = input("Category: ")

    # We will now construct the search query based on the user´s input
    # For long queries, it is helpful to name placeholders
    # This is done by placing the name of the place holder in the parenthesis
    # between the % and the s

    q = "SELECT p.pid, p.name, p.price, c.name AS category, p.description " + \
        "FROM p.products AS p INNER JOIN ws.categories AS c USING (cid)" + \
        "WHERE p.name LIKE %(name)s"

    if (category != ""):
        q += " AND c.name = %(category)s"

    print("Sort by:\n1. Name\n2.Price")
    sort = get_int_from_user(">", False)

    if (sort != None):
        if (sort == 1):
            q += " ORDER BY p.name"
        else:
            q += " ORDER BY p.price"

    q += ";"

    # We can then give a map from placeholder name to value, like below
    cur = conn.cursor()
    cur.execute(q, {'name' : "%"+name+"%", 'category' : category})
    rows = cur.fetchall()

    if (rows == []):
        print("No results.")
        return

    print(" -- RESULTS --\n")

    for row in rows:
        print("=== " + row[1] + " ===\n" + \
              "Product ID: " + str(row[0] + "\n" + \
              "Price: " + str(row[2]) + "\n" + \
              "Category: " + row[3])
        if (row[3] != "NULL"):
            print("Description: " + row[4])
        print("\n")

    order_products(conn, username)

def order_products(conn, username):
    return

def get_int_from_user(msg, needed):
    # Utility method that gets ant int from the user with the first argument
    # as message. Second argument is boolean, and if false allows user to not
    # give input, and will then return None
    while True:
        numStr = input(msg)
        if (numStr == "" and not needed):
            return None
        try:
            return int(numStr)
        except:
            print("Please provide an integer or leave blank")

if __name__ == "__main__":
    frontend()
