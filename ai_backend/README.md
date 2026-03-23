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

## Durable Audio Storage (S3 / R2)

Set these in your deployment environment:

```bash
S3_BUCKET=your-bucket-name
S3_ACCESS_KEY_ID=...
S3_SECRET_ACCESS_KEY=...
S3_REGION=auto
S3_ENDPOINT_URL=https://<account-id>.r2.cloudflarestorage.com
S3_KEY_PREFIX=audio
S3_PUBLIC_BASE_URL=https://cdn.yourdomain.com
S3_USE_PRESIGNED_URL=true
S3_PRESIGNED_EXPIRES=604800
```

Notes:
- If `S3_PUBLIC_BASE_URL` is set, backend returns public CDN URL.
- If not set, backend returns presigned URL when `S3_USE_PRESIGNED_URL=true`.
- If S3 vars are absent, backend falls back to local `static/audio` storage.

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
- If TTS generation fails, response returns `status: failed` and `audioUrl: null` with `audioError`.
- Browser cache headers are enabled for `/static/audio/*` (`max-age=31536000`, `immutable`).
- Script bank now includes Class 6/7/9/11 experiment IDs in English and Telugu.
