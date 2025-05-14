CREATE OR REPLACE DATABASE PARROT_ZOO_DB;
USE DATABASE PARROT_ZOO_DB;

CREATE OR REPLACE SCHEMA DATA_FILES;
USE SCHEMA DATA_FILES;

CREATE OR REPLACE TABLE ZOO_RAW (
    DATA VARIANT
)

INSERT INTO ZOO_RAW
SELECT PARSE_JSON($$
{
    "zooName": "Cosmic Critters Galactic Zoo",
    "location": "Space Station Delta-7, Sector Gamma-9",
    "establishedDate": "2077-01-01",
"director": {
    "name": "Zorp Glorbax",
    "species": "Xylosian"
},
"habitats": [
    {
    "id": "H001",
    "name": "Crystal Caves",
    "environmentType": "Subterranean",
    "sizeSqMeters": 1500,
    "safetyRating": 4.5,
    "features": ["Luminescent Flora", "Geothermal Vents", "Echo Chambers"],
    "currentTempCelsius": 15
    },
    {
    "id": "H002",
    "name": "Azure Aquarium",
    "environmentType": "Aquatic",
    "sizeSqMeters": 3000,
    "safetyRating": 4.8,
    "features": ["Coral Reef Simulation", "High-Pressure Zone", "Bioluminescent Plankton"],
    "currentTempCelsius": 22
    },
    {
    "id": "H003",
    "name": "Floating Forest",
    "environmentType": "Zero-G Jungle",
    "sizeSqMeters": 2500,
    "safetyRating": 4.2,
    "features": ["Magnetic Vines", "Floating Islands", "Simulated Rain"],
    "currentTempCelsius": 28
    },
    {
    "id": "H004",
    "name": "Frozen Tundra",
    "environmentType": "Arctic",
    "sizeSqMeters": 1800,
    "safetyRating": 4.0,
    "features": ["Ice Caves", "Simulated Aurora"],
    "currentTempCelsius": -10
    }
],
"creatures": [
    {
    "id": "C001",
    "name": "Gloob",
    "species": "Gelatinoid",
    "originPlanet": "Xylar",
    "diet": "Photosynthesis",
    "temperament": "Docile",
    "habitatId": "H001",
    "acquisitionDate": "2077-01-15",
    "specialAbilities": null,
    "healthStatus": { "lastCheckup": "2077-03-01", "status": "Excellent" }
    },
    {
    "id": "C002",
    "name": "Finblade",
    "species": "Aqua-Predator",
    "originPlanet": "Neptunia Prime",
    "diet": "Carnivore",
    "temperament": "Aggressive",
    "habitatId": "H002",
    "acquisitionDate": "2077-02-01",
    "specialAbilities": ["Sonar Burst", "Camouflage"],
    "healthStatus": { "lastCheckup": "2077-03-10", "status": "Good" }
    },
    {
    "id": "C003",
    "name": "Sky-Wisp",
    "species": "Aether Flyer",
    "originPlanet": "Cirrus V",
    "diet": "Energy Absorption",
    "temperament": "Shy",
    "habitatId": "H003",
    "acquisitionDate": "2077-02-20",
    "specialAbilities": ["Invisibility", "Phase Shift"],
    "healthStatus": { "lastCheckup": "2077-03-15", "status": "Fair" }
    },
    {
    "id": "C004",
    "name": "Krystal Krawler",
    "species": "Silicate Arthropod",
    "originPlanet": "Xylar",
    "diet": "Mineralvore",
    "temperament": "Neutral",
    "habitatId": "H001",
    "acquisitionDate": "2077-03-05",
    "specialAbilities": ["Crystal Armor", "Burrowing"],
    "healthStatus": { "lastCheckup": "2077-03-20", "status": "Excellent" }
    },
    {
    "id": "C005",
    "name": "Ice Strider",
    "species": "Cryo-Mammal",
    "originPlanet": "Cryonia",
    "diet": "Herbivore",
    "temperament": "Docile",
    "habitatId": "H004",
    "acquisitionDate": "2077-03-10",
    "specialAbilities": ["Thermal Resistance", "Ice Skating"],
    "healthStatus": { "lastCheckup": "2077-03-25", "status": "Good"}
    }
],
"staff": [
    {
    "employeeId": "S001",
    "name": "Grunga",
    "role": "Senior Keeper",
    "species": "Gronk",
    "assignedHabitatIds": ["H001", "H004"]
    },
    {
    "employeeId": "S002",
    "name": "Dr. Elara Vance",
    "role": "Chief Veterinarian",
    "species": "Human",
    "assignedHabitatIds": []
    },
    {
    "employeeId": "S003",
    "name": "Bleep-Bloop",
    "role": "Maintenance Droid",
    "species": "Robotic Unit 7",
    "assignedHabitatIds": ["H002", "H003"]
    }
],
"upcomingEvents": [
    {
    "eventId": "E001",
    "name": "Finblade Feeding Frenzy",
    "type": "Feeding Show",
    "scheduledTime": "2077-04-01T14:00:00Z",
    "locationHabitatId": "H002",
    "involvedCreatureIds": ["C002"]
    },
    {
    "eventId": "E002",
    "name": "Sky-Wisp Visibility Demo",
    "type": "Educational",
    "scheduledTime": "2077-04-05T11:00:00Z",
    "locationHabitatId": "H003",
    "involvedCreatureIds": ["C003"]
    }
]
}
$$)



SELECT 
    DATA:zooName::String as zoo_name,
    DATA:location::String as location
FROM ZOO_RAW



SELECT
    data:director.name::STRING AS director_name,
    data:director.species::STRING AS director_species
FROM ZOO_RAW



SELECT
    creature.value:name::STRING AS creature_name,
    creature.value:species::STRING AS species
FROM ZOO_RAW,
     LATERAL FLATTEN(input => data:creatures) AS creature


     
SELECT
    creature.value:name::STRING AS creature_name
FROM ZOO_RAW,
     LATERAL FLATTEN(input => data:creatures) AS creature
WHERE creature.value:originPlanet::STRING = 'Xylar'



SELECT
    habitat.value:name::STRING AS habitat_name,
    habitat.value:environmentType::STRING AS environment_type
FROM ZOO_RAW,
     LATERAL FLATTEN(input => data:habitats) AS habitat
WHERE habitat.value:sizeSqMeters::NUMBER > 2000



SELECT
    creature.value:name::STRING AS creature_name
FROM ZOO_RAW,
     LATERAL FLATTEN(input => data:creatures) AS creature,
     LATERAL FLATTEN(input => creature.value:specialAbilities) AS ability
WHERE ability.value::STRING = 'Camouflage'



SELECT
    creature.value:name::STRING AS creature_name,
    creature.value:healthStatus.status::STRING AS health_status
FROM ZOO_RAW,
     LATERAL FLATTEN(input => data:creatures) AS creature
WHERE creature.value:healthStatus.status::STRING != 'Excellent'



SELECT
    staff.value:name::STRING AS employee_name,
    staff.value:role::STRING AS role
FROM ZOO_RAW,
     LATERAL FLATTEN(input => data:staff) AS staff,
     LATERAL FLATTEN(input => staff.value:assignedHabitatIds) AS habitat_id
WHERE habitat_id.value::STRING = 'H001'



SELECT
    creature.value:habitatId::STRING AS habitat_id,
    COUNT(*) AS creature_count
FROM ZOO_RAW,
     LATERAL FLATTEN(input => data:creatures) AS creature
GROUP BY creature.value:habitatId::STRING



SELECT DISTINCT
    feature.value::STRING AS feature
FROM ZOO_RAW,
     LATERAL FLATTEN(input => data:habitats) AS habitat,
     LATERAL FLATTEN(input => habitat.value:features) AS feature



SELECT
    event.value:name::STRING AS event_name,
    event.value:type::STRING AS event_type,
    event.value:scheduledTime::TIMESTAMP AS scheduled_time
FROM ZOO_RAW,
     LATERAL FLATTEN(input => data:upcomingEvents) AS event



SELECT
    creature.value:name::STRING AS creature_name,
    habitat.value:environmentType::STRING AS environment_type
FROM ZOO_RAW,
     LATERAL FLATTEN(input => data:creatures) AS creature,
     LATERAL FLATTEN(input => data:habitats) AS habitat
WHERE creature.value:habitatId::STRING = habitat.value:id::STRING