import sys
import random
import csv

""" Generates a csv file, so that each row contains a random bounding box, and width and height (both set to 1024). These
parameters are used in the WMS GetMap request.

Usage: python generateWorld1024.py <csv file to be generated> <number of rows of csv file>

"""

with open(sys.argv[1], 'wb') as csvFile:
    fileWriter = csv.writer(csvFile, delimiter=',')
    numberOfRows = int(sys.argv[2])
    for i in range(0, numberOfRows):
        lat1 = round(random.uniform(-90.0, 90.0),10)
        lat2 = round(random.uniform(lat1, 90.0),10)
        lon1 = round(random.uniform(-180.0, 180.0),10)
        lon2 = round((lon1 + abs(lat2 - lat1)),10)
        row = (lon1, lat1, lon2, lat2, 1024, 1024)
        fileWriter.writerow(row)
