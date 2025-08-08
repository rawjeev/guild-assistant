# src/guild_assistant/data/load_species_arcadedb.py

import os
import traceback
import httpx
import pandas as pd
import typer
from tenacity import retry, stop_after_attempt, wait_fixed

app = typer.Typer()

ARCADEDB_HOST = "arcadedb"
ARCADEDB_BASE_URL = f"http://{ARCADEDB_HOST}:2480"  # Update if needed
ARCADEDB_DB = "guild_assistant-db"
ARCADEDB_USER = os.getenv("ARCADEDB_USER", "root")
ARCADEDB_PASSWORD = os.getenv("ARCADEDB_PASSWORD", "root")

@retry(stop=stop_after_attempt(3), wait=wait_fixed(1))
def insert_species(client: httpx.Client, record: dict) -> bool:    
    """
    Insert a species vertex into ArcadeDB using the SQL endpoint.
    """
    url = f"{ARCADEDB_BASE_URL}/api/v1/command/{ARCADEDB_DB}"
    headers = {"Content-Type": "application/json"}
    
    command = """
        INSERT INTO Species SET
            scientific_name = :scientific_name,
            taxon_id = :taxon_id,
            kingdom = :kingdom,
            phylum = :phylum,
            class = :class,
            `order` = :order,
            family = :family,
            genus = :genus
    """

    data = {
        "language": "sql",
        "command": command,
        "params": {
            "scientific_name": record.get("scientific_name"),
            "taxon_id": record.get("taxon_id"),
            "kingdom": record.get("kingdom"),
            "phylum": record.get("phylum"),
            "class": record.get("class"),
            "order": record.get("order"),
            "family": record.get("family"),
            "genus": record.get("genus"),
        }
    }

    try:
        response = client.post(url, headers=headers, json=data)

        print(f"Request URL: {response.url}")
        print(f"Response Status Code: {response.status_code}")
        print(f"Response JSON: {response.json()}")

        if response.status_code == 200 and response.json().get("result"):
            typer.secho(f"✅ Inserted: {record['scientific_name']}", fg=typer.colors.GREEN)
            return True
        else:
            typer.secho(f"❌ Failed for: {record['scientific_name']}", fg=typer.colors.RED)
            return False

    except httpx.HTTPStatusError as e:
        typer.secho(f"❌ HTTP Error for {record['scientific_name']}: {e.response.status_code} - {e.response.text}", fg=typer.colors.RED)
        return False
    except httpx.RequestError as e:
        typer.secho(f"❌ Request Error for {record['scientific_name']}: {e}", fg=typer.colors.RED)
        return False
    except Exception as e:
        typer.secho(f"❌ Unexpected Error for {record['scientific_name']}: {e}", fg=typer.colors.RED)
        traceback.print_exc()
        return False
        
@app.command()
def load(csv_path: str = typer.Argument("species_data.csv", help="CSV file with species data")):
    df = pd.read_csv(csv_path)
    typer.secho(f"📄 Loading {len(df)} species from {csv_path}", fg=typer.colors.CYAN)

    with httpx.Client(auth=(ARCADEDB_USER, ARCADEDB_PASSWORD)) as client:
        for _, row in df.iterrows():
            species_data = {
                "scientific_name": row.get("scientific_name") or row.get("input_name"),
                "taxon_id": str(row.get("gbif_id", "")),
                "kingdom": row.get("kingdom"),
                "phylum": row.get("phylum"),
                "class": row.get("class"),
                "order": row.get("order"),
                "family": row.get("family"),
                "genus": row.get("genus"),
            }
            insert_species(client, species_data)

if __name__ == "__main__":
    app()