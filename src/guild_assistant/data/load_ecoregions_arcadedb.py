import os
import geopandas as gpd
import typer
import httpx
from tenacity import retry, stop_after_attempt, wait_fixed
from dotenv import load_dotenv

# Load environment variables at module level
load_dotenv()

app = typer.Typer()

# Config - these will use the loaded env vars
ARCADEDB_HOST = "arcadedb"
ARCADEDB_BASE_URL = f"http://{ARCADEDB_HOST}:2480"
DATABASE = os.getenv("DB_NAME","guild_assistant-db")
USERNAME = os.getenv("DB_USER_NAME", "root")
PASSWORD = os.getenv("DB_USER_PASSWORD", "root")
HEADERS = {"Accept": "application/json"}

# Columns commonly found in WWF ecoregion shapefiles
FIELD_MAP = {
    "ECO_NAME": "name",
    "BIOME": "biome",
    "REALM": "geographic_extent",
    "ECO_ID_U": "description",  # or ECO_CODE or whatever unique name
    "STATUS": "conservation_status",  # optional
    # Add more mappings if required
}

@retry(stop=stop_after_attempt(3), wait=wait_fixed(1))
def insert_ecoregion(client: httpx.Client, data):
    url = f"{ARCADEDB_BASE_URL}/api/v1/command/{DATABASE}"
    headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
    }

    payload = {
        "command": f"""
            INSERT INTO Ecoregion SET
                name = "{data['name']}",
                description = "{data.get('description', '')}",
                biome = "{data.get('biome', '')}",
                climate = "{data.get('climate', '')}",
                geographic_extent = "{data.get('geographic_extent', '')}",
                biodiversity_index = {data.get('biodiversity_index', 0.0)},
                conservation_status = "{data.get('conservation_status', '')}"
        """,
        "language": "sql"
    }

    try:
        response = client.post(url, headers=headers, json=payload)
        response.raise_for_status()
        return response.json()
    except httpx.HTTPStatusError as e:
        typer.secho(f"❌ HTTP Error: {e.response.status_code} - {e.response.text}", fg=typer.colors.RED)
        raise
    except httpx.RequestError as e:
        typer.secho(f"❌ Request Error: {e}", fg=typer.colors.RED)
        raise
    except Exception as e:
        typer.secho(f"❌ Unexpected Error: {e}", fg=typer.colors.RED)
        raise

def extract_data(row):
    def safe_string_extract(value):
        """Convert value to string and escape quotes if needed"""
        if value is None:
            return ""
        # Convert to string first, then replace quotes
        return str(value).replace('"', "'")
    
    return {
        "name": safe_string_extract(row.get("ECO_NAME", "")),
        "description": safe_string_extract(row.get("ECO_CODE", "")),
        "biome": safe_string_extract(row.get("BIOME", "")),
        "geographic_extent": safe_string_extract(row.get("REALM", "")),
        "conservation_status": safe_string_extract(row.get("STATUS", "")),
        "climate": "",  # Not available in WWF data directly, can infer later
        "biodiversity_index": 0.0  # Optional placeholder
    }

@app.command()
def load_ecoregions(shp_path: str = typer.Argument("wwf_terr_ecos.shp", help="Path to the WWF Ecoregions shapefile")):
    """
    Load ecoregions from a shapefile into ArcadeDB.
    """
    # Optional: Print config to verify env vars loaded correctly
    typer.secho(f"Using database: {DATABASE} at {ARCADEDB_BASE_URL}", fg=typer.colors.BLUE)
    typer.secho(f"Username: {USERNAME}", fg=typer.colors.BLUE)
    
    gdf = gpd.read_file(shp_path)
    typer.secho(f"Loaded {len(gdf)} ecoregions from {shp_path}", fg=typer.colors.GREEN)
    
    with httpx.Client(auth=(USERNAME, PASSWORD)) as client:
        typer.secho("Starting to insert ecoregions...", fg=typer.colors.CYAN)
        for _, row in gdf.iterrows():
            data = extract_data(row)
            try:
                result = insert_ecoregion(client, data)
                typer.secho(f"Inserted: {data['name']}", fg=typer.colors.GREEN)
            except Exception as e:
                typer.secho(f"Error inserting {data['name']}: {e}", fg=typer.colors.RED)
        
        typer.secho("Finished inserting ecoregions.", fg=typer.colors.GREEN)

if __name__ == "__main__":
    app()