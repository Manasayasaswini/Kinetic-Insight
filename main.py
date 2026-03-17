from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

app = FastAPI()

# This is our "Material Database"
MATERIALS = {
    "water": {"n": 1.33, "description": "Light slows down slightly in water."},
    "glass": {"n": 1.5, "description": "Glass is denser than water, bending light more."},
    "diamond": {"n": 2.42, "description": "Diamond has a very high index, causing extreme bending!"}
}

@app.get("/api/material/{name}")
async def get_material(name: str):
    return MATERIALS.get(name.lower(), {"n": 1.0, "description": "Unknown material"})

# This serves your HTML/JS files
app.mount("/", StaticFiles(directory="static", html=True), name="static")
