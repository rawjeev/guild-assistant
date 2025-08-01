# src/guild_assistant/data/fetch_species_gbif.py

import typer
from pygbif import species, occurrences
import pandas as pd
from time import sleep

app = typer.Typer()

def fetch_species_taxonomy(name: str):
    result = species.name_backbone(name=name)
    if result.get("matchType") == "NONE":
        typer.secho(f"[WARN] No match for: {name}", fg=typer.colors.YELLOW)
        return None
    return {
        "input_name": name,
        "scientific_name": result.get("scientificName"),
        "kingdom": result.get("kingdom"),
        "phylum": result.get("phylum"),
        "class": result.get("class"),
        "order": result.get("order"),
        "family": result.get("family"),
        "genus": result.get("genus"),
        "species": result.get("species"),
        "gbif_id": result.get("usageKey")
    }

def fetch_occurrence_location(gbif_id: int, limit: int = 1):
    try:
        occ = occurrences.search(taxonKey=gbif_id, country="IN", limit=limit)
        if occ["results"]:
            r = occ["results"][0]
            return {
                "latitude": r.get("decimalLatitude"),
                "longitude": r.get("decimalLongitude"),
                "locality": r.get("locality"),
                "stateProvince": r.get("stateProvince")
            }
    except Exception as e:
        typer.secho(f"[ERROR] Occurrence fetch failed for ID {gbif_id}: {e}", fg=typer.colors.RED)
    return {}

@app.command()
def fetch(
    names: list[str] = typer.Argument(..., help="Scientific names of species to fetch"),
    output: str = typer.Option("species_data.csv", "--output", "-o", help="Output CSV filename"),
    include_occurrence: bool = typer.Option(True, "--occurrence/--no-occurrence", help="Include occurrence data")
):
    """
    Fetch species taxonomy (and optionally occurrence data) from GBIF and save to CSV.
    """
    all_data = []
    for name in names:
        typer.echo(f"🔍 Fetching data for: {name}")
        tax = fetch_species_taxonomy(name)
        if not tax:
            continue
        if include_occurrence:
            occ = fetch_occurrence_location(tax["gbif_id"])
            tax.update(occ)
        all_data.append(tax)
        sleep(1)

    df = pd.DataFrame(all_data)
    df.to_csv(output, index=False)
    typer.secho(f"✅ Saved to {output}", fg=typer.colors.GREEN)

if __name__ == "__main__":
    app()