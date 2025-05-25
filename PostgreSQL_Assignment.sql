# SQL code for table creation, sample data insertion
CREATE DATABASE conservation_db;
CREATE TABLE rangers (
  ranger_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  region TEXT NOT NULL
);

INSERT INTO rangers ( name, region) VALUES
( 'Alice Green', 'Northern Hills'),
( 'Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

CREATE TABLE species (
  species_id SERIAL PRIMARY KEY,
  common_name TEXT NOT NULL,
  scientific_name TEXT NOT NULL,
  discovery_date DATE NOT NULL,
  conservation_status TEXT CHECK (conservation_status IN ('Endangered', 'Vulnerable', 'Extinct')) NOT NULL
);
INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Golden Eagle', 'Aquila chrysaetos', '1990-05-15', 'Vulnerable'),
('Snow Leopard', 'Panthera uncia', '1985-08-20', 'Endangered'),
('Blue Whale', 'Balaenoptera musculus', '2000-01-10', 'Endangered');

CREATE TABLE sightings (
  sighting_id SERIAL PRIMARY KEY,
  species_id INTEGER NOT NULL REFERENCES species(species_id),
  ranger_id INTEGER NOT NULL REFERENCES rangers(ranger_id),
  location TEXT NOT NULL,
  sighting_time TIMESTAMP NOT NULL,
  notes TEXT
);
INSERT INTO sightings ( species_id, ranger_id, location, sighting_time, notes) VALUES
( 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
( 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
( 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
( 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

# Problem 1

INSERT INTO rangers(name,region) VALUES ('Derek Fox', 'Coastal Plains');

# Problem 2

SELECT COUNT(DISTINCT species_id) AS unique_species_sighted
FROM sightings;

# Problem 3
SELECT * FROM sightings WHERE location LIKE '%Pass%';

# Problem 4
SELECT r.name AS name, COUNT(s.sighting_id) AS total_sightings
FROM rangers r
LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY r.name
ORDER BY total_sightings DESC;

# Problem 5
SELECT s.common_name
FROM species s
LEFT JOIN sightings si ON s.species_id = si.species_id
WHERE si.species_id IS NULL;

# Problem 6

SELECT 
  sp.common_name, 
  si.sighting_time, 
  r.name AS ranger_name
FROM sightings si
JOIN species sp ON si.species_id = sp.species_id
JOIN rangers r ON si.ranger_id = r.ranger_id
ORDER BY si.sighting_time DESC
LIMIT 2;

# Problem 7

UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';

# Problem 8

SELECT 
  sighting_id,
  CASE
    WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sighting_time) < 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day
FROM sightings;

# Problem 9

DELETE FROM rangers
WHERE ranger_id NOT IN (
  SELECT DISTINCT ranger_id FROM sightings
);
