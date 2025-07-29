# src/guild_assistant/core/models/species.py
from pydantic import BaseModel, Field
from typing import List, Dict, Optional
from .traits import PhysicalTrait, Functions
from .phenology import Phenology, PhenologicalTriggers
from .ecology import EcologicalPreferences


class Species(BaseModel):
    scientific_name: str
    common_names: Dict[str, str]
    synonyms: List[str]
    taxon_rank: Optional[str]
    taxon_id: Optional[str]
    kingdom: Optional[str]
    phylum: Optional[str]
    class_: Optional[str] = Field(None, alias='class')
    order: Optional[str]
    family: Optional[str]
    genus: Optional[str]
    life_form: Optional[str]
    physical_traits: Optional[PhysicalTrait]
    phenology: Optional[Phenology]
    functions: Optional[Functions]
    ecological_preferences: Optional[EcologicalPreferences]
    phenological_triggers: Optional[PhenologicalTriggers]