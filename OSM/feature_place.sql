insert into feature.place(name, local_name, type, subtype, country, source_id, source_key, geom, info)


-------------------------------------------------
-- Amenity
-------------------------------------------------

SELECT 
tags -> 'name:en' as name, 
name as local_name, 
'amenity' as type, 
----
       CASE WHEN amenity='yes' THEN ''
            ELSE amenity
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



(amenity is not null 
and amenity not like 'abandoned%' and amenity not like 'disused%' and amenity not like 'closed%' 
and amenity not like 'bench%' and amenity not like 'atm%' and amenity not like 'drinking_water%'
and amenity not like 'parking%' and amenity not like 'shelter%' and amenity not like 'sign%'
and amenity not like 'shower%' and amenity not like 'sink%' and amenity not like 'toilet%' 
and amenity not like 'vending%' and amenity not like 'hay%' and amenity not like 'dog_waste%'
and amenity not like 'waste_disposal%' and amenity not like 'waste_basket%'
and amenity not in
(



-- Trash --
'waste_container',
'waste_dumpster',
'waste=trash',
'waste=trash;cigarettes',
'waste_bags',
'waste_bin',
'waste_bin;dog_waste_bin',
'recycling',
'recycling;waste_disposal',
'recycling;waste_basket',
'waste_basket;bench;waste_disposal',
'waste_transfer_station',
'awaste_basket',
'ash_bin',
'ash_bucket',
'ash_tray',
'ashstray',
'ashtray',
'cigarette_disposal',
'dump_station',
'dumpster',
'dung_yard',
'recycle_bin',
'recycling:organic=yes',
'recycling; waste_disposal',
'recycling;drinking_water',
'recycling;parking',
'recycling;post_box',
'recycling_container',
'trash',
'trash_can',
'trash_disposal',
'trashbin',
'excrement_bags',
'garbage_can',
'rubbish',
'rubbish_bin',
'sanitary_dump_station',
'sanitary_dump_station ; toilets',
'sanitary_station',
'sanitary_waste_dump',
'sanity_dump_station',
'septic_tank',


-- Outdoor --
'table',
'chair',
'seat',
'seating',
'seating,ornamental',
'seating_area',
'stool',
'ladder',
'refuge',
'bbq',
'bbq; drinking_water; waste_basket',
'bbq; toilets; drinking_water',
'bbq;bench',
'bbq;shelter',
'bbq;waste_basket',
'picknick',
'picknik',
'picknik_table',
'picnic',
'picnic spot',
'picnic; bench',
'picnic_area',
'picnic_bench',
'picnic_shelter',
'picnic_site',
'picnick',
'picninc_site',
'picnic_table',
'fountain',
'fountain;bench',
'outdoor_seating',
'swing',
'swings',
'planter',
'flower_planter',
'public_bookcase',
'public-bookcase',
'public_bookshelf',
'stumps',

--'basketball court',
--'basketball_court',
'basketball_hoop',
'agility_tubes',
--'pitch',

'campfire',
'firepit',
'fire_pit',
'fire_place',
'fireplace',
'firewood',
'wood_splittint_place',
'wood_stoves',


'flag',
'flag_pole',
'flagpole',
'statue',
'monument',
'tomb',
'tombstone',
'grave',

'sundial',
'sun_clock',
'clock',
'clock_tower',
'bell',
'bell_tower',
'churchbell',
'tower',
'chimney',

'water',
'swamp',
'spring',
'river',
'pond',
'lake',
'stream',
'waterfall',
'hill',
'overlook',
'viewpoint',
'path',
'footpath',
'hiking,heritage site',
'hiking_trail',
'public_path',
'gravel',
'park_entrance',
'beach',
'beach access',
'umbrella',
'umbrella_rental',
'beach_cabin',
'beachhut',
'beachhuts',
'basic_hut',
'lean_to',
'trail_head',
'windsock',



-- Toilets and Water Fountains --
'toilets',
'Private/toilets',
'bathroom',
'bathroom and toilet',
'change_room',
'change_rooms',
'changing_room',
'changing_room;toilets',
'changing_rooms',
'changing_station',
'outhouse',
'stall',
'public_bath',
'pulic_bath',
'public_shower',
'foot_shower',
'cold water shower',
'baby changing',
'baby_change',
'restroom',
'urinal',
'watering_place',
'drinking_water',
'wheelchair-toilets',
'hand_wash',
'fountain;drinking_water',
'fountain;waste_basket',
'fountain;watering_place',
'public_building; toilets',
'public bath',
'rest_room',
'water_fountain',
'water_source',
'watertap',
'water_tank',
'water_tanks',
'water_tap',
'water_tower',
'watering_hole',
'watering_place;drinking_water',
'watering_tank',
'watering_well',
'waterpoint',
'waterpump',
'wc',



-- Charging --
'power outlet (publlic)',
'power_socket',
'power_supply',
'telephone;charging_station',
'charging_station',
'charging center',
'charging station',
'charging_station;fuel',
'device_charging_station',
'device charging station',
'device_charging_point',
'charging_station;bicycle_parking',
'bicycle_charging_station',
'bicycle_parking;bank',
'electric socket',
'electric_socket',



-- Parking --
'motorcycle_parking',
'bicycle_parking',
'bicycle_rental',
'horse_parking',
'bicycle_parking; parking_entrance',
'bicycle_parking;bench',
'bicycle_parking;car_sharing',
'bicycle_parking;motorcycle_parking',
'bicycle_parking;parking_space',
'bicycle_parking;post_box',
'bicycle_parking;public_bookcase',
'bicycle_parking;townhall',
'bicycle_parking;waste_basket',
'bycicle_parking',
'car parking',
'disabled_parking',
'buggy_parking',
'micro_scooter_parking',
'moped parking',
'moped_parking',
'ski_parking',
'stroller_parking',
'truck_parking',
'valet_parking',
'wheelchair_lift',
'wheelchair_parking',
'boat parking',
'motor_parking',
'motorbicycle_parking',
'motorbike_parking',
'motorcycle_parking; bicycle_parking',
'motorcycle_parking;bicycle_parking',
'motorcycle_parking;telephone',
'rv parking',
'tourist_bus_parking',
'tricycle_parking',
'unofficial_parking',
'scooter_parking',




-- Vacuum/Air --
'car_vac',
'car_vacumcleaner',
'car_vacuum',
'car_vacuum_cleaner',
'car_warming_plug',
'public_vaccum',
'public_vacuum',
'compressed_air',
'compressed_air;parking',
'compressed_air;vacuum_cleaner',
'air_compressor',
'air_compressor;pressure_washer',
'air_filling',
'air_pump',
'airpump',
'air',
'bicycle:air',
'bicycle_air',
'bicycle_airpump',
'bicycle_pump',
'tire_inflation_station',
'tire_pump',


-- Payment --
'atm',
'bankomat',
'pay',
'payment_terminal',
'pay_booth',
'pay_station',
'payment_center',
'payment_centre',
'payment_point',
'turn_stile',
'ticket_validator',
'toll_booth',
'ticket',
'tickets',
'ticket booth',
'ticket validator',
'ticket-validator',
'ticket_booth',



-- Building --
'entrance',
'stairs_entrance/exit_P_garage',
'ramp',
'vehicle_ramp',
'vehicle ramp',
'mini_ramp',
'disused',
'exit',
'noexit',
'no_exit',
'arrival',
'building_entrance',
'building_reception',
'waiting_area',
'waiting_room',
'check-in',
'check-in counter',
'check_in',
'checkin',
'checkout',
'reception',
'reception_area',
'reception_desk',
'logbook',
'cloakroom',
'closet',
'mirror',
'baggage_room',
'baggage checkroom',
'baggage_checkin',
'baggage_checkroom',
'luggage locker',
'luggage_locker',
'luggage_storage',
'locker',
'lockers',
'receiving_dock',
'loading dock',
'loading_bay',
'loading_lock',
'loading_ramp',
'loading_dock',
'cart_return',
'green_roof',
'solar_panel',
'lost_and_found_box',
'lost_found',
'lost_property',
'lost_property_box',
'lost_property_office',
'lostandfound',
'left luggage',
'left_luggage',
'airport_lounge',
'post_box',
'post_pox',
'post_locker',
'post_office_box',
'post_box; telephone',
'post_box; vending_machine',
'post_box;bicycle_parking',
'post_box;drinking_water',
'post_box;pharmacy',
'post_box;post_office',
'post_box;recycling',
'post_box;telephone',
'post_box;vending_machine',
'post_box;waste_basket',
'post_box_missing',
'post_box_nonexistent',
'mail box',
'mail_box',
'mailbox',
'mailboxes',
'letter-box',
'letter_box',
'letterbox',
'key_room',
'key_box',
'electricity box',
'electricy box',




-- Safety --
'emergency_exit',
'emergency_marker',
'fire_brigade_entrance',
'fire_extinguisher',
'fire_alarm',
'fire_alarm_box',
'fire_hose',
'fire_plug',
'firefighter_exit',
'fireplce',
'fireplug',
'life_boats',
'life_buoy',
'life_ring',
'life_saver',
'lifebelt',
'life_belt',
'lifeboat',
'lifeboat_station',
'lifebuoy',
'lifesaver',
'lifevest',
'rescue_box',
'mountain_rescue_box',
'life_boat',
'security_booth',




-- Signs/Lights --
'map',
'marker',
'bulletin_board',
'billboard',
'commercial_Signs',
'electronic_sign',
'name_plate',
'nameplate',
'notice board',
'notice_board',
'noticeboard',
'passenger_information_display',
'public_display_screen',
'scoreboard',
'welcome_sign',
'waymarker',
'signal',
'stop',
'speed',
'speed bump',
'speed limit sign',
'speed_check_display',
'speed_enforcement',
'speed_trap',
'speed_camera',
'traffic signal',
'traffic_camera',
'traffic_light_camera',
'traffic_light_controller',
'traffic_park',
'traffic_signal',
'traffic_signals',
'traffic_tickets',
'warning_sign',
'flood warning sign',
'flood_light',
'level_crossing',
'level_crossing_control_box',
'level_crossing_signal_box',
'maxheight_warning_beam',
'lamp',
'lamp_post',
'lampadaire',
'lamppost',
'river_light',
'light',
'light_post',
'lightpole',
'surveillance_camera',
'street-lamp',
'streetLamp',
'street_cabinet',
'street_lamp',




-- Communications --
'wifi',
'phone',
'telephone',
'antenna',
'communications_tower',
'beacon',
'barometer',
'cable',
'telephone cable access',
'telephone;clock',
'telephone;post_box',
'telephone_box',
'telephone_control_box',
'telephone_pole',
'phone box',
'phone_box',
'relay_box',
'relay_post_box',
'wifi;telephone;device_charging_station',
'wifihotspot',
'electric tower',
'weather_station',
'weather_vane',
'weathervane',



-- Transportation --
'road',
'bridge',
'railway',
'port',
'seaport',
'harbour', 
'marina',
'mooring',
'warf',
'weir',
'scenic_route',
'lift',
'lifts',
'lock',
'canal',
'car_ramp',
'curb',
'sewer',
'manhole',
'manhole_drain',
'deep_water_port',
'drop off point',
'kiss_and_go_stopping',
'kiss_and_ride',
'passenger pick up drop off',
'passenger_pick_up_drop_off',
'passenger_pickup_drop_off',
'passenger_pickup_dropoff',
'school_drop_off',
'lock gate',
'gate',
'aircraft_fuel',
'airplane_fuel',
'slipway',
'sloped curve',
'sloped_curb',
'steps',


-- Animal --
'pet_relief',
'pet_relief_area',
'pet_toilet',
'dog waste bin',
'dog_agility_obstacle',
'dog_bags',
'dog_excrement',
'dog_litter_box',
'dog_off_leash',
'dog_parking',
'dog_relief_area',
'dog_toilet',
'dog_toilets',
'doggie_bags',
'doggy_bag',
'dogwaste_basket',
'horse_dismount_block',
'mounting_block',
'mounting_step',
'mounting_steps',
'anthill',
'bee_hive',
'beehouse',
'beeyard',
'bear_box',
'bird feeder',
'bird_bath',
'bird_feeding_station',
'bird_house',
'birds_nest',
'nest_box',
'feeder',
'manure',





-- Misc --
'body_scales',
'milk collection point',
'stand pipe',
'stand_pipe',
'carpet_rack'


)) 


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
(shop is not null and shop not in (
'parking',
'parking_tickets'
))

UNION ALL


-------------------------------------------------
-- Service
-------------------------------------------------

SELECT 
tags -> 'name:en' as name, 
name as local_name, 
'amenity' as type, 
----
       CASE WHEN service='yes' THEN 'service'
            ELSE service
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

UNION ALL

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

UNION ALL



-------------------------------------------------
-- Leisure
-------------------------------------------------

SELECT 
tags -> 'name:en' as name, 
name as local_name, 
'amenity' as type, 
----
       CASE WHEN leisure='yes' THEN 'leisure'
            ELSE leisure
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

UNION ALL

-------------------------------------------------
-- Tourism
-------------------------------------------------

SELECT 
tags -> 'name:en' as name, 
name as local_name, 
'amenity' as type, 
----
       CASE WHEN tourism='yes' THEN 'tourism'
            ELSE tourism
       END
---
as subtype,
tags -> 'addr:country' as country, 
1 as source_id,
osm_id as source_key,
way as geom, 
to_json(tags) as info

from feature.points 

where 

---

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

----------------------------------------

on conflict do nothing;