# Kinetic Insight Backend

## Setup

```bash
cd /mnt/d/kinetic_insight/ai_backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Run

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

## Sarvam TTS Setup

```bash
export SARVAM_API_KEY="your_key_here"
```

## Endpoints

- `GET /` -> backend status message
- `GET /health` -> health check
- `GET /mcp/explanation/{classId}/{experimentId}/{language}` -> script + audio status (`en`/`te`)
- `POST /mcp/explanation/script` -> generate/fetch cached script
- `POST /mcp/explanation/audio` -> fetch cached audio metadata

## Notes

- Phase-1 uses in-memory TTL caches for scripts and audio metadata.
- Static/generated audio files are served from `/static/audio/...`.
- On cache miss, backend attempts Sarvam TTS generation and stores audio locally.
- If TTS generation fails, response returns `status: generating` and `audioUrl: null`.
