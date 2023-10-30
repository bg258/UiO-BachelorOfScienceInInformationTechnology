"""
                                    marktz
                        IN2090 - Obligatorisk Oppgave 5
                            Programmering med SQL

Forklaring:
Jeg tenkte å gi en liten forklaringen for å gjøre koden mer forståelig.

- O P P G A V E 2 -
Det jeg har gjort i oppgave 2 er først å spørre om username. Hvis brukeren
velger da å ikke skrive noen brukernavn i det hele tatt, vil dette føre til
at strengen blir konvertert til "%%". Dette vil føre til at vi lager "bills"
for alle brukere. Deretter har jeg laget en spørring som henter den nødvendig
informasjon for å løse oppgaven. Til slutt printer jeg resultatet vi får fra
å eksekvere cur.fetchall();

- O P P G A V E 3 -
Jeg har valgt å løse oppgaven på en liten annerledes måte. Jeg synes presentasjonene
til leif var ganske nyttig med tanke på spørrings-delen, men jeg valgte å lage
en egen metode for å hente cid, altså "Kategori"-IDen, når vi setter navnet
på denne. Dersom kategorien ikke finnes, vil vi returnere NONE, som betyr at
navnet på kategorien ikke fantes i databasen, og derfor vil denne ikke ha noen
category-ID.

Konklusjon:
Jeg vet at man kunne ha løst oppgaven på forskjellige måter. Jeg fant denne
løsningen ganske nyttig og lærte masse. Ellers er det bare å komme med
kommentarer til ting som kunne ha blitt løst annerledes.

"""
import psycopg2

# Login details for database user
dbname = "marktz"
user = "marktz_priv"
pwd = "pie0aeCieg" # Set in the password for the _priv-user you got in a mail

# Gather all connection info into one string
connection = \
    "host='dbpg-ifi-kurs01.uio.no' " + \
    "dbname='" + dbname + "' " + \
    "user='" + user + "' " + \
    "port='5432' " + \
    "password='" + pwd + "'"

def admin():
    conn = psycopg2.connect(connection) # Create a connection
    option = True
    while (option == True):
        print("\n--- ADMINISTRATOR --- ")
        print("Please choose an option: \n 1. Create bills \n 2. Insert new product \n 3. Exit")

        user = get_int_from_user("Option: ", True)
        if (user == 1):
            make_bills(conn) # Print bill
        elif (user == 2):
            insert_product(conn) # Insert new product to the database
        elif (user == 3):
            option = False # Ezit program
            print("See you soon!")

"""
Oppgave 2 - Lage regninger
I denne oppgaven skal du implementere funksjonen make_bills (conn) (for python)
som generer regninger for brukere. Funksjonen skal spørre brukeren av programmet
om et brukernavn. Dersom brukeren oppgir et brukernavn skal programmet så
generere en regning for denne brukeren på følgende format:

Name: <navn>
Address: <adresse>
Total due: <total>

hvor <navn> er brukerens navn, <adresse> er brukerens adresse, og <total> er
mengden penger brukeren skylder, altså summen av alle produktene som som
brukeren har bestilt men ennå ikke betalt for (husk at en bestilling kan
inneholde flere av samme produkt via num-kolonnen).
"""

# Oppgave 2
def make_bills(conn):
    print("-- BILLS --")

    # Asking for the username to print the bill
    username = input("Username: ")
    if (username == ""):
        username = "%%"

    query = "SELECT u.name, u.address, SUM(o.num * p.price) " + \
            "FROM ws.orders AS o " + \
                "INNER JOIN ws.products AS p USING (pid) " + \
                "INNER JOIN ws.users AS u USING (uid) " + \
            "WHERE o.payed = 0 AND u.username LIKE %(username)s " + \
            "GROUP  BY u.name, u.address;";

    cur = conn.cursor()
    cur.execute(query, {'username' : username})
    rows = cur.fetchall()

    if (rows == []):
        print("\nNo results.")
        return
    else:
        for row in rows:
            print("\n-- Bill --")
            print("Name: " + row[0] + "\n" + \
                  "Address: " + row[1] + "\n" + \
                  "Total due: " + str(row[2]))

"""
Oppgave 3 - Sette inn nye produkter
I denne oppgaven skal du implementere funksjonen insert_product (conn) som
lar brukeren sette inn nye produkter i Webshopens produktkatalog (som da er
ws.products-tabellen). Brukeren skal bli spurt om navn og pris på produktet,
samt navnet på kategorien produktet tilhører.

-- INSERT NEW PRODUCT -- Product name: Juice
Price: 2.3
Category: food
Description: Fresh orange juice New product Juice inserted.
"""
# Oppgave 3
def insert_product(conn):
    print("-- INSERT NEW PRODUCT --")
    name = input("Product name: ")
    price = input("Price: ")
    while (price == ""):
        price = input("Vennligst tast inn en pris: ")
    price = float(price)
    c = input("Category: ")
    category = hente_cid(conn, c)
    description = input("Description: ")

    query = "INSERT INTO ws.products(name, price, cid, description) " + \
            "VALUES (%(n)s, %(p)s, %(c)s, %(d)s);"

    cur = conn.cursor()
    cur.execute(query, {'n' : name, 'p' : price, 'c' : category, 'd' : description})
    conn.commit()
    print("New product '" + name + "' inserted.")

def hente_cid(conn, category):
    query = "SELECT cid " + \
            "FROM ws.categories " + \
            "WHERE name = %(name)s;"

    cur = conn.cursor()
    cur.execute(query, {'name' : category})
    rows = cur.fetchall()

    if (rows == []):
        return None
    else:
        for row in rows:
            return row[0]

def get_int_from_user(msg, needed):
    # Utility method that gets an int from the user with the first argument as message
    # Second argument is boolean, and if false allows user to not give input,
    # and will then return None
    while True:
        numStr = input(msg)
        if (numStr == "" and not needed):
            return None
        try:
            return int(numStr)
        except:
            print("Please provide an integer or leave blank.")

if __name__ == "__main__":
    admin()
