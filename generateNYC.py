import sys
import random
import csv

""" Generates a csv file, so that each row contains a random bounding box, and width and height values. These
parameters are used in the WMS GetMap request. The bounding boxes refer to areas in NYC or in its outskirts.

Usage: python generateNYC.py <csv file to be generated> <number of rows of csv file>

"""


with open(sys.argv[1], 'wb') as csvFile:
    fileWriter = csv.writer(csvFile, delimiter=',')
    numberOfRows = int(sys.argv[2])
    for i in range(0, numberOfRows):
        lat1 = round(random.uniform(39.0, 42.0),10)
        lat2 = round((lat1 + random.uniform(0.1, 2.0)),10)
        lon2 = round(random.uniform(-75.0,-74.0),10)
        lon1 = round((lon2 - abs(lat2 - lat1)),10)
        row = (lon1, lat1, lon2, lat2, 256, 256)
        fileWriter.writerow(row)
