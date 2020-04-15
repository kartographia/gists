# OSM Tables

We leverage OSM to help identify dwell locations and to classify devices. OSM data is stored in a PostgreSQL/PostGIS database.


## Loading Data

Basic process involves the following steps:
 - Download osm data (e.g. planet file)
 - Break the osm data up into chunks
 - Load the chunks into PostgreSQL
 - Merge chunks into unified tables
