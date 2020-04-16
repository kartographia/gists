# Place Table

The place table contains points and polygons representing brick-and-mortar points of interest (bars, restaurants, hotels, offices, etc). The table schema is below:


```sql
CREATE TABLE FEATURE.PLACE (
    ID BIGSERIAL NOT NULL,
    NAME text,
    LOCAL_NAME text,
    TYPE text,
    SUBTYPE text,
    COUNTRY text,
    SOURCE_ID bigint NOT NULL,
    SOURCE_KEY bigint NOT NULL,
    GEOM geometry(Geometry,4326) NOT NULL,
    INFO jsonb,
    CONSTRAINT PK_PLACE PRIMARY KEY (ID)
);

ALTER TABLE FEATURE.PLACE ADD UNIQUE (SOURCE_ID, SOURCE_KEY);
```


The place table is populated using the feature.points table via a UNION of multiple distinct queries. The basic pattern is as follows:

```sql

insert into feature.place(name, local_name, type, subtype, country, source_id, source_key, geom, info)

-------------------------------------------------
-- Office
-------------------------------------------------

SELECT 
tags -> 'name:en' as name, 
name as local_name, 
'amenity' as type, 
----
       CASE WHEN office='yes' THEN 'office'
            ELSE office
       END
---
as subtype,
tags -> 'addr:country' as country, 
1 as source_id,
osm_id as source_key,
way as geom, 
to_json(tags) as info

from feature.points where 

---

amenity is null and
(office is not null)

UNION ALL

-------------------------------------------------
-- Shop
-------------------------------------------------

SELECT 
tags -> 'name:en' as name, 
name as local_name, 
'amenity' as type, 
----
       CASE WHEN shop='yes' THEN 'shop'
            ELSE shop
       END
---
as subtype,
tags -> 'addr:country' as country, 
1 as source_id,
osm_id as source_key,
way as geom, 
to_json(tags) as info

from feature.points where 

---

amenity is null and
(shop is not null)

UNION ALL


--- etc, etc, etc ...



on conflict do nothing;

```

There are six joins total that correspond to the various feature classes in the OSM data:
 - Amenity
 - Service
 - Office
 - Shop
 - Leisure
 - Tourism

The actual `WHERE` clause is a little more complex than what was in the previous snippit. 
In the sections below you will find the actual `WHERE` clause we use in the insert statements.

## Shop
Here is the query used to find shops
```sql
select distinct(

       CASE WHEN shop='yes' THEN 'shop'
            ELSE shop
       END
)

from feature.points

where 

amenity is null and
(shop is not null and shop not in (
'parking',
'parking_tickets'
))

order by shop;
```

## Service
Here is the query used to find service-related businesses

```sql
select distinct(

       CASE WHEN service='yes' THEN 'service'
            ELSE service
       END
)

from feature.points

where 

amenity is null and
(service is not null and service not in(
'barn_ramp',
'bicycle:pump',
'ventilation',
'driveway',
'alley',
'parking',
'parking_aisle',
'terminal',
'crossing',
'slipway',
'tower',
'base_tranceiver_station',
'base_transceiver_station',
'loading_dock',
'bridge_control',
'emergency_access',
'emergency_exit',
'event_venue',
'fire exit',
'public well',
'public_well'
))

order by service;
```

## Office
Here is the query used to find offices/businesses

```sql
select distinct(

       CASE WHEN office='yes' THEN 'office'
            ELSE office
       END
)

from feature.points


where 

amenity is null and
(office is not null and office not in (
'camp_site',
'fire_extinguisher',
'festival_grounds',
'farm',
'habour',
'harbour',
'marina',
'port',
'parking',
'parking_tickets'
))

order by office;
```


## Leisure
Here is the query used to find leisure related businesses

```sql

select distinct(

       CASE WHEN leisure='yes' THEN 'leisure'
            ELSE leisure
       END
)

from feature.points

where 

amenity is null and
(leisure is not null 
and leisure not like 'bird%'
and leisure not in(
'table', 
'seat', 
'fireplace',
'firepit',
'picnic_table',
'picnic_bench',
'picnic_table;firepit',
'barbecue_spot',
'outdoor_seating',
'bench',
'bleacher',
'bleachers',
'information',
'knowledge',
'outdoor_seating',
'surface',
'spot',
'yard, pasture'
)) 

order by leisure;
```