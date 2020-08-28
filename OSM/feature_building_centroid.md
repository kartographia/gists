# Building Centroids

The building_centroid table is derived from the [feature.building](feature_building.md) table.

```sql
create table feature.building_centroid
as 
select id, st_centroid(geom) as geom
from feature.building;

alter table feature.building_centroid add CONSTRAINT pk_building_centroid PRIMARY KEY (ID);
CREATE INDEX idx_building_centroid ON feature.building_centroid USING GIST(GEOM);
```