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
'yard, pasture',



'abandoned_pitch',
'activity_park',


'anchorage',
'animal_feeder',
'animal_training',

'arbor',
'arboretum',

'archery',
'archery_club',


'attraction',

'aviary',

'axe_throwing',
'badminton',

'balance_beam',
'ball wall',
'ball_distributor',

'bandstand',

'barbecue',
'barbecue_fireplace',
'barefoot',

'baseball_field',
'basket',
'basket_ball_court',
'basketball court',
'basketball_court',
'basketball_hoop',
'bath',
'bathhouse',
'bathing',
'bathing_place',
'bathtub',
'bbq',
'beach',

'belachers',
'bicycle',
'bicycle_track',
'bike grill',
'bike_jump',
'bike_park',
'bikepark',


'birch:juice_collecting',
'bleecher',
'bleechers',
'bmx_park',
'bmx_track',

'boat landing - canoe',
'boat launch',
'boat ramp',

'boat_hoist',
'boat_house',
'boat_ramp',
'boatdock',
'boathouse',
'bocce',
'boccia_course',

'boulder',
'boundary=national_park',


'cabin lot',
'camel_riding',
'camp',
'camp_site',
'campground',
'camping',
'campsite',

'canoe access point',
'canoe launch',
'canoe_launch',
'canoe_trip',

'cemetery',

'charging_station',
'chess_board',

'clay pigeon',
'cliff',

'demolished:playground',

'dirt bike',
'disc_golf',
'disc_golf_course',

'dismantled',
'disused',
'diving board',
'diving_platform',

'dog exercise area',
'dog_bin',

'dolphin_watching',



'entrance',

'exercise',
'exercise_area',
'exercise_station',
'exit_games',


'family_park',
'farm',

'fee_station',
'festival grounds',
'festival_grounds',
'festivalground',

'field',
'fire_pit',
'firepit;picnic_table',
'firewood',

'fisching',
'fishing',
'fishing_dock',
'fishing_hole',
'fishing_pier',
'fishing_platform',



'flag',

'floral ground',
'flower_pot',

'footba',
'football',

'fountain',

'frozen waterfall',

'funfair',
'futsal',

'gambling_machine',

'game_feeding',


'gaming_table',
'garden',
'garden+garden:type=botanical',
'gardens',


'gazebo',

'goal',

'golf_pin',

'grass',
'grill',


'halfpipe',

'hammock',
'hammock_hangout',
'hammocking_posts',

'handcar',
'harbour',

'high_rope_course',
'high_ropes_course',
'hiking',

'history',

'holiday_park',

'hoop',
'horse_carriage',

'horseshoe',
'hot_spring',


'hunting_camp',
'hunting_stand',

'info_table',
'ingress',
'interactive_game',

'internet',
'internet_access',

'iron bar',
'iron_bar',


'kayak_dock',
'kayak_ramp',
'kids_area',
'kids_camp',
'kids_club',

'kite_flying',
'kiteboarding',

'labyrinth',
'lake',
'lake_bath',
'landing',
'landmark',

'launching_ramp',

'leisure',
'leisure=bandstand',


'long_jump',


'mais_labyrinth',
'makerspace',

'map',
'marina',

'maze',
'meadow',

'meeting_point',
'memorial',
'memorial_park',

'monument',

'municipal park',


'national_park',
'natural_play_area',
'natural_reserve',
'natural_tree',
'nature_monument',
'nature_reserve',

'net',

'nordic_park',

'nursery',

'observation_platform',
'obstacle_course',
'offroad',


'open space',

'orchard',
'outdoor',
'outdoor tower',
'outdoor_bathing',
'outdoor_chess',
'outdoor_fitness',
'outside',

'panorama',
'paragliding',
'parasail',
'park',
'park;sports_centre',
'park_bench',
'parking space',

'picnic',
'picnic_area',
'picnic_place',
'picnic_site',
'pier',

'piste',
'pitch',
'pitch;playground',



'plane_spotting',
'planespotting',

'platform',
'play_area',
'play_centre',
'play_ground',
'play_house',
'play_land',
'playground',

'playground:climbingframe=yes',
'playground:slide=yes',
'playground:springy=yes',
'playground:structure',
'playground:swing=yes',
'playground;fitness_station',
'playground;park',
'playground=seesaw',
'playground=springy',
'playhouse',
'playing_field',

'podium',
'point_of_interest',


'pony_park',

'pool_lift',

'practice_pitch',


'protected_area',

'public',
'public_beach',
'publico',
'publicoo',
'pulkabacke',
'quad_biking',
'quary',


'ramp',
'ranch',

'recreation_ground',
'recreation_grounds',
'recreation_park',

'refuge',


'river',
'river_bath',
'river_surfing',
'rock climbing',

'roller-skate ramp',

'rope_climb',
'rope_course',
'rope_swing',
'ropes_course',
'rowing',
'sailing',

'sanbathing',
'sandpit',
'sanitary dump station',


'schoolyard',
'scoreboard',
'scout_hut',
'scouts',
'sea_bath',
'segway',

'sensory_trail',

'shelter',
'shipway',


'shooting_stand',

'showground',
'sightseeing',

'sipway',

'skatepark',



'slackline',
'slide',
'slip',
'slippoint',
'slipway',
'slipway;fishing',

'soccer ground',
'soccer_golf',

'soft_play',
'softball_field',
'soho point',

'split',
'spo',
'sport',

'sport climbing',
'sport crag',

'sport_studio',
'sports',
'sports climbing',
'sports court',

'sports_centre;jump_park',
'sports_centre;park',


'sports_field',
'sports_ground',

'sports_pitch',

'sports_track',
'spring_board',
'springboard',

'square',

'star_gazing',
'starting_place',
'street',



'sunbathing',

'swim',
'swimming',
'swimming_area',
'swimming_hole',
'swimming_river',
'swimming_spot',
'swing',

'swings',
'swmming_area',
'table_soccer_table',
'table_tennis',
'table_tennis_table',

'tennis',
'tent_ground',
'tent_space',

'tire swing',
'toboggan',
'toboggan_hill',
'toboggan_slide',
'tobogganing',


'tourist_info',
'tower',
'track',
'track;pitch',
'tracks',

'traffic_park',
'trail',
'trailhead',

'trapeze',
'tree',
'tree_climbing',
'tree_garden',
'treehouse',

'turf',


'viewpoint',

'visit',

'wading pool',
'wading_pool',

'walk',
'wall',
'wand',
'water hammock',
'water_access',

'water_reserve',
'water_ski',
'water_slide',

'wayside_table',

'whirlpool',
'wild_swimming',
'wildlife_hide',
'wildlife_park',
'wildlife_reserve',
'wind',

'winning_post'

)) 

order by leisure;
```
