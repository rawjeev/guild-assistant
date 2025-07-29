# src/guild_assistant/core/models/phenology.py
from pydantic import BaseModel
from typing import Optional, List
from .ecology import EcologicalRange


class Phenology(BaseModel):
    flowering_season: Optional[List[str]]
    fruiting_season: Optional[List[str]]
    leaf_shedding: Optional[str]


class PhenologicalTriggerDetails(BaseModel):
    temperature_range_celsius: Optional[EcologicalRange]
    min_chill_hours: Optional[int]
    daylength: Optional[str]
    season: Optional[List[str]]
    after_flowering_days: Optional[int]

class PhenologicalTriggers(BaseModel):
    flowering: Optional[PhenologicalTriggerDetails]
    fruiting: Optional[PhenologicalTriggerDetails]