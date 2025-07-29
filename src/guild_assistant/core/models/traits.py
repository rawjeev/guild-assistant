# src/guild_assistant/core/models/traits.py
from pydantic import BaseModel
from typing import Optional, List


class PhysicalTrait(BaseModel):
    leaf_shape: Optional[str]  # For plants
    height_cm: Optional[int]   # Could apply to plants, animals, fungi
    bark_type: Optional[str]   # For woody plants
    body_color: Optional[str]  # For animals, insects
    body_covering: Optional[str]  # fur, feathers, scales, cuticle, etc.
    weight_grams: Optional[float]  # General
    other_features: Optional[str]  # Catch-all for anything else

class Functions(BaseModel):
    trophic_role: Optional[str]
    guild_roles: Optional[List[str]]
    ecological_services: Optional[List[str]]