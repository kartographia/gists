# Admin Table

The admin table contains polygons representing administrative boundaries for countries, states, provinces, counties, cities, etc. The table schema is below:


```sql
CREATE TABLE FEATURE.ADMIN (
    ID BIGSERIAL NOT NULL,
    NAME text,
    LOCAL_NAME text,
    ADMIN_LEVEL integer,
    COUNTRY text,
    REGION text,
    SOURCE_ID bigint NOT NULL,
    SOURCE_KEY bigint NOT NULL,
    GEOM geometry(Geometry,4326) NOT NULL,
    INFO jsonb,
    CONSTRAINT PK_ADMIN PRIMARY KEY (ID)
);

ALTER TABLE FEATURE.ADMIN ADD UNIQUE (SOURCE_ID, SOURCE_KEY);
```


The admin table is populated using the feature.polygons table like this:

```sql

insert into FEATURE.ADMIN(name, local_name, admin_level, region, country, source_id, source_key, geom, info) 
SELECT 
tags -> 'name:en' as name, 
name as local_name, 
CASE WHEN admin_level~E'^\\d+$' THEN CAST (admin_level AS INTEGER) ELSE NULL END as admin_level, 
tags -> 'addr:region' as region, 
tags -> 'addr:country' as country, 
1 as source_id,
osm_id as source_key,
way as geom, 
to_json(tags) as info

FROM feature.polygons

WHERE admin_level IS NOT NULL

on conflict do nothing;

```



In addition to the official administrative boundaries, we also like to include neighbourhoods. For areas in the US, we found the following to work quite well:

```sql

insert into FEATURE.ADMIN(name, local_name, admin_level, region, country, source_id, source_key, geom, info) 

SELECT 
tags -> 'name:en' as name, 
name as local_name, 

       CASE WHEN admin_level~E'^\\d+$' THEN CAST (admin_level AS INTEGER)
            ELSE 10
       END
,
tags -> 'addr:region' as region, 
tags -> 'addr:country' as country, 
1 as source_id,
osm_id as source_key,
way as geom, 
to_json(tags) as info

FROM feature.polygons

WHERE place = 'neighbourhood' and name is not null

on conflict do nothing;

```


Note the `on conflict` statement above. This, along with the unique index, prevents us from creating duplicate records.