SET LANGUAGE = sqlscript;

-- === VERTEX CLASSES ===

-- 🌿 Species
CREATE VERTEX TYPE Species IF NOT EXISTS;

-- 📛 Basic
CREATE PROPERTY Species.scientific_name STRING; -- e.g., Quercus robur
CREATE PROPERTY Species.common_names MAP;       -- e.g., {'en': 'English Oak'}
CREATE PROPERTY Species.synonyms LIST;          -- e.g., ['Quercus robur', 'English Oak']
CREATE PROPERTY Species.taxon_rank STRING;      -- e.g., 'species'
CREATE PROPERTY Species.taxon_id STRING;        -- e.g., '12345'

-- 📊 Classification
CREATE PROPERTY Species.kingdom STRING;     -- e.g., Plantae, Animalia, Fungi
CREATE PROPERTY Species.phylum STRING;      -- e.g., Angiosperms, Chordata
CREATE PROPERTY Species.class STRING;       -- e.g., Magnoliopsida, Aves
CREATE PROPERTY Species.order STRING;       -- e.g., Fagales, Passeriformes
CREATE PROPERTY Species.family STRING;      -- e.g., Fagaceae, Fringillidae
CREATE PROPERTY Species.genus STRING;       -- e.g., Quercus, Fringilla
CREATE PROPERTY Species.life_form STRING;   -- e.g., Tree, Shrub, Herb

-- 🧭 Others
CREATE PROPERTY Species.conservation_status STRING; -- e.g., 'endangered', 'vulnerable', 'least concern'

-- 🌍 Ecoregion
CREATE VERTEX TYPE Ecoregion IF NOT EXISTS;            
CREATE PROPERTY Ecoregion.name STRING;          -- e.g., 'Amazon Rainforest'
CREATE PROPERTY Ecoregion.description STRING;   -- e.g., 'Tropical rainforest in South America'
CREATE PROPERTY Ecoregion.biome STRING;       -- e.g., 'tropical', 'temperate', 'arctic'
CREATE PROPERTY Ecoregion.climate STRING;    -- e.g., 'humid', 'arid', 'temperate'
CREATE PROPERTY Ecoregion.geographic_extent STRING; -- e.g., 'South America', 'North America'
CREATE PROPERTY Ecoregion.biodiversity_index FLOAT; -- e.g., 0.9 (scale of 0 to 1)
CREATE PROPERTY Ecoregion.conservation_status STRING;   -- e.g., 'critical', 'endangered', 'least concern'

-- HabitatCondition

CREATE VERTEX TYPE HabitatCondition IF NOT EXISTS;
CREATE PROPERTY HabitatCondition.name STRING;
CREATE PROPERTY HabitatCondition.metadata EMBEDDED;

-- 🌾 SoilType
CREATE VERTEX TYPE SoilType EXTENDS HabitatCondition IF NOT EXISTS;
CREATE PROPERTY SoilType.name STRING;          -- e.g., 'Clay'
CREATE PROPERTY SoilType.description STRING;   -- e.g., 'Heavy, sticky soil that retains moisture'
CREATE PROPERTY SoilType.texture STRING;       -- e.g., 'clay', 'sandy', 'loamy'
CREATE PROPERTY SoilType.ph_range EMBEDDED;   -- e.g., {'min': 5.5, 'max': 7.5}
CREATE PROPERTY SoilType.organic_matter FLOAT; -- e.g., 3.5 (percentage)
CREATE PROPERTY SoilType.drainage STRING;     -- e.g., 'well-drained', 'poorly-drained'
CREATE PROPERTY SoilType.fertility STRING;    -- e.g., 'high', 'medium', 'low'
CREATE PROPERTY SoilType.moisture_retention STRING; -- e.g., 'high', 'medium', 'low'
CREATE PROPERTY SoilType.nutrient_content MAP; -- e.g., {'N': 12, 'P': 5, 'K': 10}
CREATE PROPERTY SoilType.salinity STRING;     -- e.g., 'saline', 'non-saline'
CREATE PROPERTY SoilType.erosion_risk STRING; -- e.g., 'high', 'medium', 'low'
CREATE PROPERTY SoilType.typical_vegetation LIST; -- e.g., ['grass', 'shrubs', 'trees']
CREATE PROPERTY SoilType.typical_climate STRING; -- e.g., 'tropical', 'arid', 'temperate'

-- ☀️ Sunlight
CREATE VERTEX TYPE Sunlight EXTENDS EnvironmentalCondition IF NOT EXISTS;
CREATE PROPERTY Sunlight.intensity STRING;      -- e.g., 'high', 'medium', 'low'
CREATE PROPERTY Sunlight.duration STRING;       -- e.g., 'full-day', 'partial-day'
CREATE PROPERTY Sunlight.seasonal_variation STRING; -- e.g., 'summer', 'winter'

-- 💧 Moisture
CREATE VERTEX TYPE Moisture EXTENDS EnvironmentalCondition IF NOT EXISTS;
CREATE PROPERTY Moisture.level STRING;         -- e.g., 'high', 'medium', 'low'
CREATE PROPERTY Moisture.seasonal_variation STRING; -- e.g., 'summer', 'winter'

-- 🔄 Interaction
CREATE VERTEX TYPE Interaction IF NOT EXISTS;
CREATE PROPERTY Interaction.type STRING;    -- e.g., 'predation', 'mutualism', 'competition'    
CREATE PROPERTY Interaction.description STRING; -- e.g., 'Predation by hawks on small mammals'

-- 🌐 EcosystemRole
CREATE VERTEX TYPE EcosystemRole IF NOT EXISTS;
CREATE PROPERTY EcosystemRole.role STRING;       -- e.g., 'primary producer', 'herbivore', 'carnivore'
CREATE PROPERTY EcosystemRole.is_primary BOOLEAN; -- e.g., true for primary ecological function, false for secondary e.g., 'Nitrogen Fixer', 'Pollinator'
CREATE PROPERTY EcosystemRole.description STRING; -- e.g., 'Organisms that produce energy through photosynthesis'

-- 🌱 Trait & Use
CREATE VERTEX TYPE Trait IF NOT EXISTS;
CREATE PROPERTY Trait.name STRING;          -- e.g., 'Drought Tolerance'
CREATE PROPERTY Trait.description STRING;   -- e.g., 'Ability to survive with minimal water'
CREATE PROPERTY Trait.value STRING;         -- e.g., 'High', 'Medium', 'Low'
CREATE PROPERTY Trait.unit STRING;          -- e.g., 'mm', 'days', 'percentage'
CREATE PROPERTY Trait.metadata EMBEDDED;    -- e.g., {'source': 'Field Study', 'year': 2023}

CREATE VERTEX TYPE Use IF NOT EXISTS;
CREATE PROPERTY Use.name STRING;            -- e.g., 'Medicinal'
CREATE PROPERTY Use.description STRING;     -- e.g., 'Used to treat headaches'
CREATE PROPERTY Use.category STRING;        -- e.g., 'Traditional Medicine', 'Agriculture'
CREATE PROPERTY Use.application STRING;     -- e.g., 'Topical', 'Oral'
CREATE PROPERTY Use.metadata EMBEDDED;      -- e.g., {'source': 'Traditional Medicine', 'year': 2023}

CREATE VERTEX TYPE Habitat IF NOT EXISTS;
CREATE PROPERTY Habitat.name STRING;              -- e.g., 'Temperate Forest'
CREATE PROPERTY Habitat.description STRING;       -- e.g., 'Forests found in temperate regions'
CREATE PROPERTY Habitat.type STRING;              -- e.g., 'forest', 'grassland', 'wetland', 'desert'
CREATE PROPERTY Habitat.climate STRING;           -- e.g., 'temperate', 'tropical', 'arid'
CREATE PROPERTY Habitat.biodiversity_index FLOAT; -- e.g., 0.85 (scale of 0 to 1)
CREATE PROPERTY Habitat.metadata EMBEDDED;        -- e.g., {'source': 'Field Survey', 'year': 2023}

-- === EDGE CLASSES ===

CREATE EDGE TYPE Presence IF NOT EXISTS;
CREATE PROPERTY Presence.status STRING;         -- 'endemic', 'native', 'invasive', 'exotic', 'naturalized', 'introduced', 'occurs', 'extinct'
CREATE PROPERTY Presence.since DATE;            -- Optional: when the status began (intro date, etc.)
CREATE PROPERTY Presence.notes STRING;          -- Optional: reasoning, sources, remarks

CREATE EDGE TYPE Prefers IF NOT EXISTS;        -- Species → EnvironmentalCondition
CREATE PROPERTY Prefers.strength FLOAT;        -- e.g., 0.8 (scale of 0 to 1)
CREATE PROPERTY Prefers.since DATE;            -- Optional: when the preference was established
CREATE PROPERTY Prefers.notes STRING;        -- Optional: additional notes about the preference

CREATE EDGE TYPE HasEcosystemRole IF NOT EXISTS;        -- Species → EcosystemRole
CREATE EDGE TYPE InteractsWith IF NOT EXISTS;           -- Species → Interaction (→ Species or Environment)
CREATE EDGE TYPE HasTrait IF NOT EXISTS;        -- Species → Trait
CREATE EDGE TYPE HasUse IF NOT EXISTS;            -- Species → Use
CREATE EDGE TYPE HasCondition IF NOT EXISTS;      -- Species → EnvironmentalCondition