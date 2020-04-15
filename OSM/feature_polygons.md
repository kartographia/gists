# Polygons Table

The feature.polygons table is a view created via a UNION ALL query using all the polygon chunk tables


### Filter polygons
In our applications we often filter the feature.polygons table to just a handful of fields. Example:
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
	
CREATE INDEX idx_osm_poly_way ON feature.osm_poly USING GIST(way) TABLESPACE osm_index;
CREATE INDEX idx_osm_poly_office ON feature.osm_poly(office) TABLESPACE osm_index;
CREATE INDEX idx_osm_poly_amenity ON feature.osm_poly(amenity) TABLESPACE osm_index;
CREATE INDEX idx_osm_poly_building ON feature.osm_poly(building) TABLESPACE osm_index;
CREATE INDEX idx_osm_poly_military ON feature.osm_poly(military) TABLESPACE osm_index;
CREATE INDEX idx_osm_poly_tourism ON feature.osm_poly(tourism) TABLESPACE osm_index;
CREATE INDEX idx_osm_poly_landuse ON feature.osm_poly(landuse) TABLESPACE osm_index;
```
