from typing import Optional, Dict, List, Literal
from pydantic import BaseModel


class Metadata(BaseModel):
    # A placeholder for optional metadata (can be extended)
    data: Optional[Dict[str, str]] = None


class EnvironmentalCondition(BaseModel):
    name: str
    metadata: Optional[Metadata] = None


class SoilType(EnvironmentalCondition):
    description: Optional[str] = None
    texture: Optional[Literal['clay', 'sandy', 'loamy']] = None
    ph_range: Optional[Dict[str, float]] = None  # e.g., {'min': 5.5, 'max': 7.5}
    organic_matter: Optional[float] = None       # percentage
    drainage: Optional[str] = None
    fertility: Optional[Literal['high', 'medium', 'low']] = None
    moisture_retention: Optional[Literal['high', 'medium', 'low']] = None
    nutrient_content: Optional[Dict[str, float]] = None  # e.g., {'N': 12, 'P': 5}
    salinity: Optional[str] = None
    erosion_risk: Optional[Literal['high', 'medium', 'low']] = None
    typical_vegetation: Optional[List[str]] = None
    typical_climate: Optional[str] = None


class Sunlight(EnvironmentalCondition):
    intensity: Optional[Literal['high', 'medium', 'low']] = None
    duration: Optional[Literal['full-day', 'partial-day']] = None
    seasonal_variation: Optional[str] = None  # e.g., 'summer', 'winter'


class Moisture(EnvironmentalCondition):
    level: Optional[Literal['high', 'medium', 'low']] = None
    seasonal_variation: Optional[str] = None