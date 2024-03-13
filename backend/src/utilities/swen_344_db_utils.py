import psycopg2
import yaml
import os

def connect():
    config = {}
    yml_path = os.path.join(os.path.dirname(__file__), '../../config/db.yml')
    with open(yml_path, 'r') as file:
        config = yaml.load(file, Loader=yaml.FullLoader)
    return psycopg2.connect(dbname=config['database'],
                            user=config['user'],
                            password=config['password'],
                            host=config['host'],
                            port=config['port'])

def exec_sql_file(path):
    full_path = os.path.join(os.path.dirname(__file__), f'../../{path}')
    conn = connect()
    cur = conn.cursor()
    with open(full_path, 'r') as file:
        cur.execute(file.read())
    conn.commit()
    conn.close()

def exec_get_one(sql, args={}):
    conn = connect()
    cur = conn.cursor()
    cur.execute(sql, args)
    one = cur.fetchone()
    conn.close()
    return one

def exec_get_all(sql, args={}):
    conn = connect()
    cur = conn.cursor()
    cur.execute(sql, args)
    # https://www.psycopg.org/docs/cursor.html#cursor.fetchall

    list_of_tuples = cur.fetchall()
    conn.close()
    return list_of_tuples

def exec_commit(sql, args={}):
    conn = connect()
    cur = conn.cursor()
    result=cur.execute(sql, args)
    conn.commit()
    conn.close()
    return result

def exec_fetch(sql,args={}):
    conn = connect()
    cur = conn.cursor()
    cur.execute(sql, args)
    result = cur.fetchone()
    conn.commit()
    conn.close()
    return result

def commit_dataframe(df, table):
    conn = connect()
    column_str = ','.join(['%%s' for i in df.columns])
    tuples = [tuple(x) for x in df.to_numpy()]
    cols = ','.join(list(df.columns))
    query = f"INSERT INTO %s(%s) VALUES({column_str}) RETURNING id" % (table, cols)
    cursor = conn.cursor()
    try:
        cursor.execute(query, tuples[0])
        id = cursor.fetchone()[0]
        conn.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        print("Error: %s" % error)
        conn.rollback()
        cursor.close()
        return 1
    cursor.close()
    return id

def update_dataframe(df, table, id):
    conn = connect()
    tuples = [tuple(x) for x in df.to_numpy()]
    tuples[0] = tuples[0] + (id, )
    cols = ','.join([f"{col}=%s" for col in list(df.columns)])
    query = "UPDATE %s SET %s WHERE id=%%s RETURNING id" % (table, cols)
    cursor = conn.cursor()
    try:
        cursor.execute(query, tuples[0])
        id = cursor.fetchone()[0]
        conn.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        print("Error: %s" % error)
        conn.rollback()
        cursor.close()
        return 1
    cursor.close()
    return id
