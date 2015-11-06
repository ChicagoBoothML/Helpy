from os import environ
from sys import exit, path


def import_pyspark(spark_home='/Applications/spark-1.5.0'):
    environ['SPARK_HOME'] = spark_home
    path.append(spark_home + '/python')
    try:
        import pyspark
        return pyspark
    except ImportError as e:
        print ("Cannot Import PySpark:", e)
        exit(1)
