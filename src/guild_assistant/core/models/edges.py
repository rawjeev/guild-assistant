from datetime import date
import re
from pydantic import BaseModel
from typing import Optional, Literal, Dict
from enum import Enum

# === Base Edge Model ===
class BaseEdge(BaseModel):
    source_id: str                     # RID or UID of source vertex
    target_id: str                     # RID or UID of target vertex
    strength: Optional[float] = None   # Confidence or influence [0.0 - 1.0]
    since: Optional[str] = None        # ISO date or year string (e.g. "2023", "2021-06-15")
    notes: Optional[str] = None        # Freeform notes
    metadata: Optional[Dict] = None    # Arbitrary additional data

# === Enum for Interaction Types ===
class InteractionKind(str, Enum):
    POLLINATES = "POLLINATES"
    PREDATES = "PREDATES"
    COMPETES_WITH = "COMPETES_WITH"
    FACILITATES = "FACILITATES"
    INHIBITS = "INHIBITS"
    SYMBIOTIC_WITH = "SYMBIOTIC_WITH"
    USES_AS_HOST = "USES_AS_HOST"
    ALTERS_ENVIRONMENT = "ALTERS_ENVIRONMENT"
    OCCURS_IN = "OCCURS_IN"

# === Inter-Species Interaction Edge ===
class InteractsWithEdge(BaseEdge):
    interaction_type: InteractionKind
    interaction_context: Optional[str] = None  # e.g., "during flowering", "in dry season"

# === Describes a Species' Ecosystem Role ===
class EcosystemRole(BaseModel):
    role: str                             # e.g., "Pollinator", "Nitrogen Fixer"
    is_primary: bool = True               # Whether this is its main ecological role
    description: Optional[str] = None     # Optional elaboration

# === Optional interaction explanation (meta info) ===
class InteractsWith(BaseModel):
    interaction_type: str                 # e.g., "symbiotic", "competitive"
    description: Optional[str] = None     # e.g., "Provides shade in dry season"

# === Connects a species to an ecosystem role ===
class HasEcosystemRoleEdge(BaseEdge):
    edge_type: Literal["HAS_ROLE"]
    ecosystem_role: EcosystemRole
    interaction_details: Optional[InteractsWith] = None  # Optional contextual explanation

# === Describes preference for a condition ===
# === Embedded preference detail ===
class PreferenceDetail(BaseModel):
    condition: str                                # e.g., "partial shade", "loamy soil"
    context: Optional[str] = None                 # e.g., "for flowering"
    notes: Optional[str] = None
    since: Optional[date] = None
    strength: Optional[float] = None              # e.g., scale from 0.0 to 1.0
    metadata: Optional[Dict[str, str]] = None     # Maps to EMBEDDED

# === Edge from Species → EnvironmentalCondition (or subclass) ===
class PrefersConditionEdge(BaseModel):
    edge_type: Literal["PrefersCondition"]        # Corresponds to ArcadeDB edge type
    from_id: str                                  # RID or identifier of Species vertex
    to_id: str                                    # RID or identifier of EnvironmentalCondition/SoilType/Moisture/Sunlight vertex
    preference: PreferenceDetail                  # Embedded preference detail

class SpeciesEcoregionRelation(str, Enum):
    endemic = "ENDMIC"
    native = "NATIVE"
    exotic = "EXOTIC"
    naturalized = "NATURALIZED"
    invasive = "INVASIVE"
    extinct = "EXTINCT"
    introduced = "INTRODUCED"
    reintroduced = "REINTRODUCED"
    occurs_in = "OCCURS_IN"

class SpeciesInEcoregionEdge(BaseEdge):
    relationship: SpeciesEcoregionRelation

# === Habitat Relationship Edge ===
# class HabitatEdge(BaseEdge):
#     edge_type: Literal["OCCURS_IN", "NATIVE_TO", "ENDEMIC_TO", "EXTINCT_IN", "INTRODUCED_TO", "EXOTIC_TO", "INVASIVE_TO"]
#     ecoregion_name: Optional[str] = None        # Optional redundancy for denormalized lookup
#     certainty: Optional[float] = None           # Confidence [0.0 - 1.0]

