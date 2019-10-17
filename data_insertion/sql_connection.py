# DO NOT PUSH THIS FILE
#https://www.w3schools.com/python/python_mysql_getstarted.asp

import mysql.connector

db = mysql.connector.connect(
  host="database-1.cuhtdqbodsnu.us-east-2.rds.amazonaws.com",
  user="admin",
  passwd="1090d6bb-5bf5-4bef-bc6c-e40fdf040cac",
  port = 3306,
  database='PROJECT'
)