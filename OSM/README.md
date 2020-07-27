# OSM Data

We leverage OSM to help identify dwell locations and to classify devices. OSM data is stored in a PostgreSQL/PostGIS database snd is organized into five tables:
 - feature.points (imported from osm_point)
 - [feature.polygons](feature_polygons.md) (imported from osm_polygon)
 - [feature.admin](feature_admin.md)
 - [feature.building](feature_building.md)
 - [feature.place](feature_place.md)




## OSM Database
Typically, we store OSM data in a dedicated database called `osm` in a database partition called `osm`. Example:
```
sudo mkdir -p /mnt/raid0/postgresql/osm
sudo chown postgres.postgres /mnt/raid0/postgresql/osm
sudo -i -u postgres psql -c "CREATE TABLESPACE osm LOCATION '/mnt/raid0/postgresql/osm';"
sudo -i -u postgres psql -c "create database osm tablespace osm;"
```

Once the database is created, we can login to PostgreSQL and do some additional configuration. 
```
sudo -u postgres psql postgres
\c osm
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS hstore;
CREATE USER osm WITH PASSWORD null;
GRANT CONNECT ON DATABASE osm TO osm;
GRANT ALL PRIVILEGES ON DATABASE osm to osm;
SELECT pg_reload_conf();
```
Note that this will create an `osm` user in the database. The `osm` does not have a password. This makes it a little easier to load data using `osm2pgsql` (see below). You can verify that the `osm` user has access to the `osm` database using psql. Example:
```
psql -h localhost -p 5432 -U osm osm
```
If you encounter an `fe_sendauth: no password supplied` error or a password prompt, you will need to update the `pg_hba.conf` file and set the IPv4 and IPv6 config for the localhost to `trust`. Example:
```
sudo vi /etc/postgresql/12/main/pg_hba.conf

host    all             all             ::1/128                 trust
host    all             all             127.0.0.1/32            trust

sudo -i -u postgres psql -c "SELECT pg_reload_conf();"
```


## Loading Data (Basic)
Loading a small area of the earth is easy with `osm2pgsql`. Example:
```
osm2pgsql -l -d osm -U osm -P 5432 -H localhost -S default.style -r pbf -p osm -C 30000 -v --hstore us-south-latest.osm.pbf
```
Note that the command required a `default.style` which you can download here:
```
curl -O https://raw.githubusercontent.com/openstreetmap/osm2pgsql/master/default.style
```

## Loading Data (Advanced)
Loading large areas or the entire planet may be impossible to do with `osm2pgsql` depending on your hardware configuration. To circumvent these issues, we break the osm data up into chunks and then load the chunks into PostgreSQL.


### Creating Chunks
We have a python script called `partition_planet` that automates the chunking process. The script is found in the scripts directory and is used as follows:
```
python3 partition_planet.py \
    -m 8e8 \
    -i planet-latest.osm.pbf \
    -o /mnt/nvme1/chunks/
```
The `-m` option is maximum file size in bytes, and can be in the form of an integer (e.g. `800000000`) or abbreviated in the python style (e.g. `8e8`).

The `-i` option specifies the location of the planet file.

The `-o` option specifies the output directory into which the chunks will be put.

Note that the `partition_planet.py` script requires the `pexpect` python module and is installed by running 
```
pip3 install pexpect
```
Under the hood, the `partition_planets.py` script calls `osmium` to subset osm.

### Loading Chunks
We have a python script called `upload_chunks` that automates the loading process. The script is found in the scripts directory and is used as follows:

```
python3 upload_chunks.py -d /mnt/nvme1/chunks
```
This script takes 5-6 hours to run for the whole planet. 
The result is 4 tables per chunk: one each for points, lines, polygons and roads. Thus with 135 chunks you will get 540 tables.

Under the hood, the `upload_chunks.py` script calls `osm2pgsql` to load osm into PostgreSQL. You will need to have the `default.style` file in your working directory.
