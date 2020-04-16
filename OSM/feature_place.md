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

## Tourism

```sql
select distinct(

       CASE WHEN tourism='yes' THEN 'tourism'
            ELSE tourism
       END
)

from feature.points

where 

amenity is null and 
(tourism is not null 
and tourism not like 'camp_site%' and tourism not like 'route%'
and tourism not like 'viewpoint%'
and tourism not in (



'artwork',
'statue',
'sculpture',
'plaque',

'parking',

'view',
'view_point',

'information',

'picnic_site',
'picnic_table',

'caravan_site',
'lean_to',

'hiking',
'trail',
'trail_riding_station',
'trail riding station',
'trail_blaze',
'trail_head',
'trailhead',



'alpine_hut',
'wilderness_hut',
'hunting_lodge',
'cabin',

'spring',
'valley',

'abandoned:camp_site',

'acctraction',

'agriculture',
'agritourism',

'alpine_hut #2',

'anchorage',

'animal parc',


'arch',
'archaeological_site',

'art_work',

'artillerie',

'artiwork',
'artkwork',
'artwork (covered during building renovation 2015)',
'artwork removed to storage',
'artwork,_gardening',
'artwork:removed',
'artwork;information',
'artwork;viewpoint;attraction',
'artwork_removed',
'ashram',
'at',
'atraccion',
'att',
'attrackition',
'attractamusement_rideion',
'attraction',
'attraction,museum',
'attraction; information',
'attraction;artwork',
'attraction;information',
'attraction;viewpoint',
'attraction=altar',
'attraction=ark',

'attration',
'aviary',


'band-stand',

'barrier',
'basic_hut',
'bathing pool',
'beach',


'belltower',

'bench',

'binoculars',
'bird_hide',
'bivouac',
'bivouac_site',
'biwak',

'board',

'boat_landing',

'botanic_garden',
'botanical_garden',
'bridge',


'cabins',

'camp',
'camp_disused_camp_site',
'camp_fire',
'camp_pitch',
'campfire',
'camping',
'camping_barn',
'camping_car',
'campsite',
'cannon',
'cape',
'caravan_site; chalet',
'caravan_site;camp_site',

'cave',
'cave_entrance',
'caves',
'cellar_door',


'check:picnic_site',
'check_point',
'checkpoint',



'climb_and_viewpoint',

'clock',
'clock_tower',
'closed',
'closed_camp_site',
'closed_hotel',

'country_farm_agriturismo',
'country_park',

'croix',
'cross',

'day-trip hut',

'direction_finder',

'disused',
'disused camp_site',
'disused:attraction',
'disused:camp_site',
'disused:information',
'disused_camp_saite',
'disused_camp_site',

'drinking water',



'fair',
'farm',

'fee_station',
'feed swans',
'ferry',
'field_barn',
'fireplace',
'fish ladder',
'fish_spa',
'fishing',

'fishing_area',


'foot_bath',
'football place',

'fotopoint',

'fountain',

'game_hide',
'garden',
'gardens',
'gate',

'geopark',

'grave',
'grill',
'grit_bin',

'guestbook',
'guide_borne',
'guide_post',
'guided_tour',
'guidepost',
'guideway',
'guidpost',
'guode_post',

'heritage=2',
'heritage=4',
'heritage=6',
'heritage_railway',
'highlight',
'hiking_map',
'hill',

'historic',

'historic grave',
'historic site',
'historic_landmark',
'historic_ruins',

'historical_marker',

'history',
'hitchhiker_station',

'horse station',
'horse_hut',


'hot_spring',


'hut',

'info-point',
'info_board',
'info_table',
'information @ (2018 Sep 22 - 2018 Oct 7)',
'information:gone',
'information;attraction',
'information;camp_site',
'information;map',
'information;museum',
'information;picnic_site',
'information;ticket_office',
'information;viewpoint',
'information_Box_Office',
'information_pour_les_travailleurs_frontaliers_luxembourg',
'informationboard',

'island',


'lake',
'lamp',
'landing stage',
'landmark',

'location_de_tourisme',


'lookout',



'map',
'map;guidepost',
'map_board',

'maze',
'meeting_point',
'memoral',
'memorial',

'miniature_railway',
'minor_attraction',
'model',
'monument',

'motorcycle_meetingpoint',
'mountain_biking',
'mountain_railway',


'narrow_gauge_railway',
'natural attraction',
'natural_monument',
'natural_tourist_attraction_changed_by_humans.',
'nature',
'nature_trail',
'natürlich',


'observation_hive',


'old well',
'open-air bath',

'paddle_boats',
'pagoda',

'park',

'parking place',

'path',

'peak',


'phone_box',

'photo_location',

'picnic site',
'picnic_area',
'picnic_site;information',
'picnic_site;viewpoint',
'pier',
'pillar',
'pincic_site',
'place to watch birds',

'plage',
'plan',
'plane',
'planned',
'playground',

'pocnic_table',
'point',
'point of interest',
'point_of_reference',
'pointview',
'post',
'preserved_railway',




'registration_box',
'reindeer farm',

'removed_artwork',


'river_rafting',
'roadside_shrine',
'rock_climing',

'rough_camping',
'ruin',
'ruins',
'ruins_of_a_hotel',

'segway tours',
'self-registration',


'shieling',
'shingle field',
'ship',

'sightseeing',
'sign',
'sign-in_book',
'site',


'slipway',
'snorkeling_site',



'squat',


'stone',

'storm_view',


'summit_cross',
'sundial',
'surf_station',

'technical_monument',
'teepee',

'temple_ruins',

'tent bivouac',



'tour_departure',

'tour_start',


'tourist_farm',


'towells',
'tower',
'tower_viewer',

'view_scope',

'village_sign',
'vineyard',
'visitor_centre',
'visitors_centre',


'warning',
'water',
'water tunnel',
'water_pump',
'water_slide',
'waterfall',
'watermill',

'welcome_sign',
'whale_watching',
'wiewpoint',
'wild_camp',
'wild_camping',
'wilderness_toilet',
'winderness_hut',

'wishing_well',
'wood henge',

'yes;attraction',


'Бесплатная_зарядка_телефона._Free_phone_charging.'


))

order by tourism;


```
