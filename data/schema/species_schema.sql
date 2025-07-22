-- 🧬 Species Vertex Definition
CREATE VERTEX TYPE Species IF NOT EXISTS;

-- 📛 Basic Taxonomic Info
CREATE PROPERTY Species.scientific_name STRING;             -- e.g., Azadirachta indica
CREATE PROPERTY Species.common_names MAP;           -- Language-code mapped common names (e.g., { "en": "Neem", "hi": "नीम" })
CREATE PROPERTY Species.synonyms LIST;              -- Other scientific names used historically
CREATE PROPERTY Species.taxon_rank STRING;                  -- e.g., species, subspecies, variety
CREATE PROPERTY Species.taxon_id STRING;                    -- unique identifier for the species (e.g., from a taxonomic database)

-- 🌳 Life Form & Classification
CREATE PROPERTY Species.kingdom STRING;                        -- e.g., Plantae, Animalia, Fungi
CREATE PROPERTY Species.phylum STRING;                         -- e.g., Angiosperms, Chordata
CREATE PROPERTY Species.class STRING;                          -- e.g., Magnoliopsida, Aves
CREATE PROPERTY Species.order STRING;                          -- e.g., Fagales, Passeriformes
CREATE PROPERTY Species.family STRING;                         -- e.g., Fagaceae, Passeridae
CREATE PROPERTY Species.genus STRING;                          -- e.g., Azadirachta, Passer
CREATE PROPERTY Species.life_form STRING;                      -- e.g., tree, shrub, climber, predator, bird, fungus

-- 🧬 Structural & Phenological Traits
CREATE PROPERTY Species.morphology MAP;              -- Form traits (e.g., leaf shape, height, bark type)
-- Example format for morphology:
-- {
--   "leaf_shape": "lanceolate",
--   "height_cm": 500,
--   "bark_type": "rough"
-- }

CREATE PROPERTY Species.phenology MAP;               -- Seasonal patterns (e.g., flowering, fruiting, breeding)
-- Example format for phenology:
-- {
--   "flowering_season": ["February", "March"],
--   "fruiting_season": ["April", "May"],
--   "leaf_shedding": "dry_season"
-- }

-- 🌱 Ecological Functions & Roles
CREATE PROPERTY Species.functions MAP;                 -- includes guild roles, trophic role, services

-- Example format for functions:
-- {
--   "trophic_role": "omnivore",
--   "guild_roles": ["canopy", "pollinator_attractor"],
--   "ecological_services": ["pest_control", "soil_builder"]
-- }

-- 🌍 Ecological Preferences
CREATE PROPERTY Species.ecological_preferences MAP;

-- Example format:
-- {
--   "temperature_celsius": { "min": 15, "max": 40 },
--   "altitude_meters": { "min": 200, "max": 1500 },
--   "soil_ph": { "min": 6.0, "max": 7.5 },
--   "soil_type": ["loamy", "sandy"],
--   "soil_drainage": ["well_drained"]
-- }

-- 🌸 Phenological Triggers (seasonal/environmental cues for life events)
CREATE PROPERTY Species.phenological_triggers MAP;

-- Example format:
-- {
--   "flowering": {
--     "temperature_range_celsius": { "min": 15, "max": 22 },
--     "min_chill_hours": 200,
--     "daylength": ">=11h",
--     "season": ["late_winter"]
--   },
--   "fruiting": {
--     "after_flowering_days": 90,
--     "temperature_range_celsius": { "min": 25, "max": 35 }
--   }
-- }

-- 🗺️ Native Range & Distribution
CREATE PROPERTY Species.native_to LIST;         -- list of ecoregions or geographies

-- === 🔗 Relationships (to be implemented via EDGE definitions) ===
-- E.g. COMPANION_WITH, COMPETES_WITH, PREDATES, ATTRACTS, etc.
-- Will be added as needed.