from flask import Flask
from flask_restful import Resource, Api
from flask_cors import CORS

from utilities.swen_344_db_utils import *
app = Flask(__name__) #create Flask instance
CORS(app) #Enable CORS on Flask server to work with Nodejs pages
api = Api(app) #api router


if __name__ == '__main__':
    print("Loading db")
    exec_sql_file('data/UserDetail.sql')
    print("Starting flask")
    app.run(debug=True), #starts Flask

    