#!/bin/bash


# enable debugging & set strict error trap
set -x -e


# change Home directory
export HOME=/mnt/home


# source script specifying environment variables
source ~/.EnvVars


# change directory to Programs directory
cd $PROGRAMS_DIR


# install supporting packages
sudo yum install -y freetds-devel
sudo yum install -y unixODBC-devel


# install SQLalchemy
sudo pip install --upgrade SQLalchemy


# install commonly-applicable drivers
sudo pip install --upgrade Egenix-mxODBC
sudo pip install --upgrade PyODBC
# sudo pip install --upgrade zxJDBC   skip: for Jython only


# install Firebird drivers
sudo pip install --upgrade FDB
# sudo pip install --upgrade kinterbasdb --allow-external kinterbasdb --allow-unverified kinterbasdb   skip: very old!


# install Microsoft SQL Server drivers
sudo pip install --upgrade PyMSSQL
sudo pip install --upgrade AdoDBAPI


# download / install MySQL Python & JDBC drivers
sudo pip install --upgrade CyMySQL
sudo yum install --enablerepo=fedora -y mysql-connector-python
sudo pip install --upgrade MySQL-Python
sudo pip install --upgrade OurSQL
sudo pip install --upgrade PyMySQL

wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.zip
unzip mysql-connector-java-*
sudo rm mysql-connector-java*.zip
sudo mv mysql-connector-java*/mysql-connector-java*.jar MySQL-JDBC-5.1.38.jar
sudo rm -r mysql-connector-java*/


# install Oracle drivers
# sudo pip install --upgrade cx-Oracle   skip: requires Oracle software installed


# download / install PostgreSQL Python & JDBC drivers
sudo pip install --upgrade PG8000
# sudo pip install --upgrade Py-PostgreSQL   skip: for Python 3.1 and greater only
sudo yum install -y python-psycopg2
# sudo pip install --upgrade psycopg2cffi   skip: requires PostgreSQL installed (for pg_config executable)

curl https://jdbc.postgresql.org/download/postgresql-9.4.1207.jar --output PostgreSQL-JDBC42-9.4.1207.jar


# install SQLite drivers
sudo pip install --upgrade PySQLCipher
# sudo pip install --upgrade PySQLite   skip: SQLite3 package already included in Python >=2.5 distributions


# install Sybase drivers
# sudo pip install --upgrade git+git://github.com/fbessho/python-sybase.git   skip: requires Sybase software installed
