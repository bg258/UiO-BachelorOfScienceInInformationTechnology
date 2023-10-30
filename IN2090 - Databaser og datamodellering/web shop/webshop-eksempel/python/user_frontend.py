import psycopg2

# Login details for database user
user = '' # Set in your UiO-username
pwd = '' # Set inn the password for the _priv-user you got in a mail

# Gather all connection info into one string
connection = \
    "dbname='" + user + "' " +  \
    "user='" + user + "_priv' " + \
    "port='5432' " +  \
    "host='dbpg-ifi-kurs.uio.no' " + \
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
    
    cur = conn.cursor() # Create a cursor object that can be used for executing queries
    print(" -- REGISTER NEW USER --")
    # Get credentials for new user account
    username = input("Username: ")
    password = input("Password: ")
    name = input("Name: ")
    address = input("Address: ")

    # We can use %s as a place holder for a value, and then pass a tuple of values to be substituted for
    # these place holders. The first placeholder is then substituted with the first element in the tuple,
    # and so on.
    # NOTE: NEVER store passwords in plain text for an actual application!!!
    cur.execute("INSERT INTO ws.users(name, username, password, address) VALUES (%s, %s, %s, %s);",
                (name, username, password, address))
    conn.commit()
    print("New user " + username + " added!")
                  

def login(conn):
    cur = conn.cursor()
    print(" -- LOGIN --")
    username = input("Username: ")
    password = input("Password: ")

    # If we do not use these placeholders, the program is susceptible to SQL injection attacks
    # More on this next lecture.
    cur.execute("SELECT username, password, name FROM ws.users WHERE username = %s AND password = %s;",
                (username, password))

    # To get the resuts from a SELECT-query, we can call fetchall() on the
    # cursor. This will make a list of lists, where each inner list represents one row
    rows = cur.fetchall() # Retrieve all restults into a list of tuples
    if (rows == []):
        # The query returned no results, thus the user-password pair does not exist in the DB
        print("Incorrect username or password.")
        return ""
    else:
        row = rows[0] # Get the first result
        print("Welcome", row[2]) # Print "Welcome <name>"
        return row[0] # Return username

def search(conn, username):
    cur = conn.cursor()

    print(" -- SEARCH --")
    name = input("Search: ")
    category = input("Category: ")

    print("How should the results be sorted?\n1. by price\n2. by name")
    sort = get_int_from_user("Sorting: ", False)
    so = None
    if (sort != None):
        print("Sort according to:\n1. Ascending order\n2. Descending order")
        so = get_int_from_user("Ordering: ", True)

    limit = get_int_from_user("Limit: ", False)

    # We will now construct the search query based on the user's input
    # For long queries, is is helpful to name the placeholders
    # This is done by placing the name of the place holder in parenthesis between the % and the s
    q = "SELECT p.pid, p.name, p.price, c.name, p.description " + \
        "FROM ws.products AS p, ws.categories AS c " + \
        "WHERE p.name LIKE %(name)s AND c.cid = p.cid"

    if (category != ""):
        q += " AND c.name = %(category)s"
    if (sort == 1):
        q += " ORDER BY p.price"
    elif (sort == 2):
        q += " ORDER BY p.name"

    if (so == 1):
        q += " DESC"

    if (limit != None):
        q += " LIMIT %(limit)s"

    q += ";"

    # We can then give a map from placeholder name to value, like below
    cur.execute(q, {'name' : "%"+name+"%", 'category' : category, 'limit' : limit})
    rows = cur.fetchall() # Retrieve all restults into a list of tuples

    if (rows == []):
        print("No results.")
        return

    # The user should be able to pick which product to order,
    # but the order shown to the user does not necessarily represent
    # the products pid, thus we will make a list where the i'th item
    # in the user's order's pid is stored at position i in the list
    products = []

    print(" -- RESULTS --\n")
    n = 0
    for row in rows:

        print("===" + str(n) + "===\n" + \
              "Name: " + row[1] + "\n" + \
              "Price: " + str(row[2]) + "\n" + \
              "Category: " + row[3])

        if (row[3] != "NULL"):
            print("Description: " + row[4])

        print("\n")
        products.append(row[0])
        n += 1

    order_products(conn, username, products)


def order_products(conn, username, products):

    order = get_int_from_user("Order: ", False)
    if (order == None):
        return

    # We will let users order several of the same product in a single order
    num = get_int_from_user("How many: ", True)

    oq = "INSERT INTO ws.orders (uid, pid, num, date, payed) " + \
         "SELECT uid, %(pid)s, %(num)s, current_date, 0 " + \
         "FROM ws.users " + \
         "WHERE username = %(username)s;"

    cur = conn.cursor()
    cur.execute(oq, {'pid' : products[order], 'num' : str(num), 'username' : username}) 
    conn.commit()
    print("Product(s) ordered.")


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
