# Polygons Table

The feature.polygons table is a view created via a UNION ALL query using all the polygon chunk tables


### Filter polygons
In our applications we filter the feature.polygons table to just a handful of fields. Example:
```sql
create table feature.osm_poly
as 
select osm_id, way_area, office, amenity, building, military, tourism, landuse, way
from feature.polygons
where not (
	(office is null 
	 and amenity is null 
	 and military is null 
	 and tourism is null 
	 and landuse is null)
	and (building is null or building = 'yes')
	);
```
