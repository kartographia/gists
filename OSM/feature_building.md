# Building Table

The building table contains polygons representing buildings. The table schema is below


```sql
CREATE TABLE FEATURE.BUILDING (
    ID BIGSERIAL NOT NULL,
    NAME text,
    LOCAL_NAME text,
    TYPE text,
    SUBTYPE text,
    SOURCE_ID bigint NOT NULL,
    SOURCE_KEY bigint NOT NULL,
    GEOM geometry(Geometry,4326) NOT NULL,
    INFO jsonb,
    CONSTRAINT PK_BUILDING PRIMARY KEY (ID)
);

ALTER TABLE FEATURE.BUILDING ADD UNIQUE (SOURCE_ID, SOURCE_KEY);
```


The building table is populated using feature.polygons table

```sql

insert into feature.building(name, local_name, source_id, source_key, geom, info)


--- START QUERY ---

select 

tags -> 'name:en' as name, 
name as local_name, 
1 as source_id,
id as source_key,
way as geom,
info

from (

-----------------

select (info->>'osm_id')::bigint as id, (info->>'tags')::jsonb || ((info::jsonb-'tags')::jsonb-'osm_id')::jsonb as info from
(
select json_strip_nulls(to_json(row_to_json(t))) as info
from (
  select
  osm_id,


  access,
  "addr:housename",
  "addr:housenumber",
  "addr:interpolation",
  admin_level,
  aerialway,
  aeroway,
  amenity,
  area,
  barrier,
  bicycle,
  brand,
  bridge,
  boundary,
  building,
  construction,
  covered,
  culvert,
  cutting,
  denomination,
  disused,
  embankment,
  foot,
  "generator:source",
  harbour,
  highway,
  historic,
  horse,
  intermittent,
  junction,
  landuse,
  layer,
  leisure,
  lock,
  man_made,
  military,
  motorcar,
  name,
  "natural",
  office,
  oneway,
  operator,
  place,
  population,
  power,
  power_source,
  public_transport,
  railway,
  ref,
  religion,
  route,
  service,
  shop,
  sport,
  surface,
  toll,
  tourism,
  "tower:type",
  tracktype,
  tunnel,
  water,
  waterway,
  wetland,
  width,
  wood,
  z_order,
  way_area,



  to_json(tags) as tags
  from feature.polygons WHERE feature.polygons.building IS NOT NULL
) t

) a

-----------------

) t1

join feature.polygons on t1.id=feature.polygons.osm_id


--- END QUERY ---


on conflict do nothing;


```
