# src/guild_assistant/core/models/ecology.py
from pydantic import BaseModel
from typing import Optional, List


class EcologicalRange(BaseModel):
    min: float
    max: float

class EcologicalPreferences(BaseModel):
    temperature_celsius: Optional[EcologicalRange]
    altitude_meters: Optional[EcologicalRange]
    soil_ph: Optional[EcologicalRange]
    soil_type: Optional[List[str]]
    soil_drainage: Optional[List[str]]
