# src/guild_assistant/core/models/__init__.py

from .species import Species
from .traits import PhysicalTrait, Functions
from .ecology import EcologicalPreferences, EcologicalRange
from .environment import EnvironmentalCondition, SoilType, Moisture, Sunlight
from .phenology import Phenology, PhenologicalTriggers
from .ecology import EcologicalPreferences, EcologicalRange
from .edges import BaseEdge, InteractionKind, InteractsWithEdge, HasEcosystemRoleEdge
from .edges import EcosystemRole, InteractsWith, SpeciesInEcoregionEdge, SpeciesEcoregionRelation
from .edges import PrefersConditionEdge, PreferenceDetail 
