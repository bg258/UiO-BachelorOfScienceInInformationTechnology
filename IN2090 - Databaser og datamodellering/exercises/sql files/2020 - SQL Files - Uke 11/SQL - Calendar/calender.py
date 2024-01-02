import psycopg2
from datetime import date

dbname = "" # Set in your UIO-username
user = "" # Set in yout UIO-username + _priv
pwd = "" # Set inn the password for the _priv-user you got in a mail

# Gather all connection info into one string
connection = \
    "host='dbpg-ifi-kurs01.uio.no' " + \
    "dbname='" + dbname + "' " + \
    "user='" + user + "' " + \
    "port='5432' " + \
    "password='" + pwd + "'"

# GUI - vårt. Dette vil da vise oss de ulike muligheter vi har når
# det gjelder denne calendar.

def main():
    conn = psycopg2.connect(connection)
    today(conn)

    while (True):
        print("\n\n--MENU--\n 1.Add event \n 2. Show events for date \n 3. Exit")
        ch = get_int_from_user("Option: ", True)

        if (ch == 1):
            add_event(conn)
        elif (ch == 2):
            show_events(conn)
        else:
            return

def today(conn):
    print("-- TODAY'S EVENTS --")
    show(conn, date.today())

def show(conn, day):
    cur = conn.cursor()
    cur.execute("SELECT eid, event, starts::time, ends::time" + \
                "FROM calendar " + \
                "WHERE (starts, ends) overlaps (%s, %s + '1 day'::interval);",
                (day, day))
    rows = cur.fetchall()
    for row in rows:
        print("[" + str(row[0]) + "] " + row[1] + ": " + str(row[2]) + " - " + str(row[3]))

def show_events(conn):
    print("-- SHOW EVENTS --")
    show(conn, date.fromisoformat(datestr))

def add_event(conn):
    print("-- ADD EVENT --")
    event = input("Event: ")
    starts = input("Starts: ")
    ends = input("Ends: ")

    cur = conn.cursor()
    cur.execute("INSERT INTO calendar(event, starts, ends) " + \
                "VALUES (%s, %s, %s);", (event, starts, ends))
    conn.commit()
    print("Event added.")

def get_int_from_user(msg, needed):
    # Utility method that gets an int from the user with the first argument as
    # message. Second argument is boolean, and if false allows the user to not
    # give inout, and will then return None
    while True:
        numStr = input(msg)
        if (numStr == "" and not needed):
            return None
        try:
            return int(numStr)
        except:
            print("Please provide an integer or leave blank.")

if __name__ = "__main__":
    main()
