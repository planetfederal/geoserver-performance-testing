import sys
import random
import csv
from pyproj import *

""" Generates a csv file, so that each row contains a random bounding box, and width and height values equal to 256. These
parameters are used in the WMS GetMap request. The bounding boxes refer to areas in NYC.

Usage: python generateNYC256.py <csv file to be generated> <number of rows of csv file>

"""

with open(sys.argv[1], 'wb') as csvFile:
    fileWriter = csv.writer(csvFile, delimiter=',')
    numberOfRows = int(sys.argv[2])
    sourceProj = Proj(init='epsg:4326')
    targetProj = Proj(init='epsg:3857')
    for i in range(0, numberOfRows):
        lat1 = (random.uniform(40.62113443326006,40.8))
        lat2 = (lat1 + random.uniform(0.05, 0.255506195867984)) 
        lon1 = (random.uniform(-74.44208082696987,-74.116953920859))
        lon2 = (lon1 + abs(lat2-lat1))
        
        tLon1,tLat1 = transform(sourceProj, targetProj, lon1, lat1)
        tLon2,tLat2 = transform(sourceProj, targetProj, lon2, lat2)
        row = (tLon1, tLat1, tLon2, tLat2, 256, 256)
        fileWriter.writerow(row)





