SET LANGUAGE = sqlscript;

-- === VERTEX CLASSES ===

-- 🌿 Species
-- 📛 Basic Taxonomic Info
CREATE PROPERTY Species.scientific_name STRING; -- e.g., Quercus robur
CREATE PROPERTY Species.common_names MAP;       -- e.g., {'en': 'English Oak'}
CREATE PROPERTY Species.synonyms LIST;          -- e.g., ['Quercus robur', 'English Oak']
CREATE PROPERTY Species.taxon_rank STRING;      -- e.g., 'species'
CREATE PROPERTY Species.taxon_id STRING;        -- e.g., '12345'

-- 🌳 Life Form & Classification
CREATE PROPERTY Species.kingdom STRING;         -- e.g., Plantae, Animalia, Fungi
CREATE PROPERTY Species.phylum STRING;          -- e.g., Angiosperms, Chordata
CREATE PROPERTY Species.class STRING;           -- e.g., Magnoliopsida, Aves
CREATE PROPERTY Species.order STRING;           -- e.g., Fagales, Passeriformes
CREATE PROPERTY Species.family STRING;          -- e.g., Fagaceae, Fringillidae
CREATE PROPERTY Species.genus STRING;           -- e.g., Quercus, Fringilla
CREATE PROPERTY Species.life_form STRING;      -- e.g., Tree, Shrub, Herb

-- 🌱 Traits & Preferences
CREATE PROPERTY Species.physical_traits MAP;                        -- e.g., {'leaf_shape': 'lanceolate', 'height_cm': 500, 'bark_type': 'rough'}
CREATE PROPERTY Species.phenology MAP;                              -- e.g., {'flowering_season': ['February', 'March'], 'fruiting_season': ['April', 'May'], 'leaf_shedding': 'dry_season'}
CREATE PROPERTY Species.phenological_triggers EMBEDDED;             -- e.g., {'flowering': {'temperature_range_celsius': {'min': 15, 'max': 22}, 'min_chill_hours': 200, 'daylength': '>=11h', 'season': ['late_winter']}, 'fruiting': {'after_flowering_days': 90, 'temperature_range_celsius': {'min': 25, 'max': 35}}}
CREATE PROPERTY Species.habitat STRING;                             -- e.g., 'tropical rainforest', 'temperate forest'
CREATE PROPERTY Species.distribution MAP;                           -- e.g., {'global': 'widespread', 'local': 'endemic to region X'}
CREATE PROPERTY Species.temperature_tolerance_celsius EMBEDDED;     -- e.g., {'min': 15, 'max': 40}
CREATE PROPERTY Species.soil_ph_range EMBEDDED;                     -- e.g., {'min': 5.5, 'max': 7.5}
CREATE PROPERTY Species.shade_tolerance STRING;                     -- e.g., 'full_sun', 'partial_shade', 'shade_tolerant'
CREATE PROPERTY Species.water_needs STRING;                         -- e.g., 'high', 'moderate', 'low'
CREATE PROPERTY Species.nutrient_needs STRING;                      -- e.g., 'high', 'moderate', 'low'
CREATE PROPERTY Species.pest_resistance STRING;                     -- e.g., 'high', 'moderate', 'low'
CREATE PROPERTY Species.disease_resistance STRING;                  -- e.g., 'high', 'moderate', 'low'
CREATE PROPERTY Species.maintenance_requirements STRING;            -- e.g., 'low', 'medium', 'high'
CREATE PROPERTY Species.propagation_methods LIST;                   -- e.g., ['seed', 'cutting', 'grafting']
CREATE PROPERTY Species.economic_uses LIST;                         -- e.g., ['timber', 'medicinal', 'ornamental']
CREATE PROPERTY Species.medicinal_uses LIST;                        -- e.g., ['antimicrobial', 'anti-inflammatory']
CREATE PROPERTY Species.cultural_significance STRING;               -- e.g., 'sacred', 'symbolic'
CREATE PROPERTY Species.traditional_knowledge STRING;               -- e.g., 'used in traditional medicine for centuries'
CREATE PROPERTY Species.conservation_status STRING;                 -- e.g., 'endangered', 'vulnerable', 'least concern'
CREATE PROPERTY Species.intercrop_uses LIST;                        -- e.g., ['companion planting', 'crop rotation']

-- 🌍 Ecoregion
CREATE VERTEX TYPE Ecoregion IF NOT EXISTS;            
CREATE PROPERTY Ecoregion.name STRING;          -- e.g., 'Amazon Rainforest'
CREATE PROPERTY Ecoregion.description STRING;   -- e.g., 'Tropical rainforest in South America'
CREATE PROPERTY Ecoregion.biome STRING;       -- e.g., 'tropical', 'temperate', 'arctic'
CREATE PROPERTY Ecoregion.climate STRING;    -- e.g., 'humid', 'arid', 'temperate'
CREATE PROPERTY Ecoregion.geographic_extent STRING; -- e.g., 'South America', 'North America'
CREATE PROPERTY Ecoregion.biodiversity_index FLOAT; -- e.g., 0.9 (scale of 0 to 1)
CREATE PROPERTY Ecoregion.conservation_status STRING;   -- e.g., 'critical', 'endangered', 'least concern'

-- EnvironmentalCondition

CREATE VERTEX TYPE EnvironmentalCondition IF NOT EXISTS;
CREATE PROPERTY EnvironmentalCondition.name STRING;
CREATE PROPERTY EnvironmentalCondition.metadata EMBEDDED;


-- 🌾 SoilType
CREATE VERTEX TYPE SoilType EXTENDS EnvironmentalCondition IF NOT EXISTS;
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

-- === EDGE CLASSES ===

CREATE EDGE TYPE SpeciesInEcoregion IF NOT EXISTS;
CREATE PROPERTY SpeciesInEcoregion.relationship STRING;  -- 'endemic', 'native', 'invasive', 'exotic', 'naturalized', 'introduced', 'occurs', 'extinct'
CREATE PROPERTY SpeciesInEcoregion.notes STRING;         -- Optional: reasoning, sources, remarks
CREATE PROPERTY SpeciesInEcoregion.since DATE;           -- Optional: when the status began (intro date, etc.)

CREATE EDGE TYPE PrefersCondition IF NOT EXISTS;        -- Species → EnvironmentalCondition
CREATE PROPERTY PrefersCondition.strength FLOAT;        -- e.g., 0.8 (scale of 0 to 1)
CREATE PROPERTY PrefersCondition.since DATE;            -- Optional: when the preference was established
CREATE PROPERTY PrefersCondition.notes STRING;        -- Optional: additional notes about the preference

CREATE EDGE TYPE HasEcosystemRole IF NOT EXISTS;        -- Species → EcosystemRole
CREATE EDGE TYPE InteractsWith IF NOT EXISTS;           -- Species → Interaction (→ Species or Environment)
