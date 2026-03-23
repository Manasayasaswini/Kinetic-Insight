# Kinetic Insight

Kinetic Insight is an interactive physics lab platform with:
- a Flutter frontend (`project/`)
- a FastAPI backend (`ai_backend/`)
- MCP-style AI explanation endpoints (English + Telugu)
- Sarvam TTS integration
- durable audio storage support (S3/R2)

This document explains architecture, internal flow, networking, deployment, and troubleshooting.

## 1) Repository Structure

```text
Kinetic-Insight/
├─ project/                  # Flutter app (web/desktop)
│  ├─ lib/features/class6/
│  ├─ lib/features/class7/
│  ├─ lib/features/class9/
│  ├─ lib/features/class11/
│  └─ lib/features/ai/       # MCP client models + service
├─ ai_backend/               # FastAPI backend
│  ├─ main.py                # API routes + MCP logic + TTS + storage
│  ├─ requirements.txt
│  ├─ static/audio/          # Local audio fallback store
│  └─ scripts/pregen_mcp_audio.sh
└─ README.md                 # this file
```

## 2) Product Behavior

### Experiments
Current experiment tracks include Class 6, 7, 9, and 11 labs with:
- Inputs
- Canvas
- Output
- Observation/Guide
- Experiment checkpoint questions

### AI Explanations
For each experiment:
- Student can request `Listen in English` or `తెలుగులో వినండి`
- Backend returns a script transcript + audio status
- If audio exists or is generated, frontend can play it

## 3) System Architecture

### Frontend (Flutter)
- UI + experiment interactions
- calls backend endpoint:
  - `GET /mcp/explanation/{classId}/{experimentId}/{language}`
- handles:
  - transcript display
  - audio URL playback
  - loading/errors/status

### Backend (FastAPI)
- serves health and MCP endpoints
- chooses script (humanized EN/TE)
- checks caches
- generates audio via Sarvam TTS on cache miss
- stores audio:
  - preferred: S3/R2 durable object storage
  - fallback: local `ai_backend/static/audio`

### Storage + Cache Layers
- Script cache: in-memory TTL
- Audio metadata cache: in-memory TTL
- Audio binary:
  - S3/R2 object (durable in production)
  - local file fallback (non-durable on ephemeral infra)

## 4) Networking Flow (Internal Happenings)

### Request sequence: Student clicks "Listen in English"

1. Flutter sends:
   `GET {AI_BASE_URL}/mcp/explanation/11/tir/en`
2. FastAPI loads/creates script.
3. FastAPI resolves audio:
   - if S3 key exists -> return URL
   - else generate via Sarvam -> upload -> return URL
   - if generation fails -> return `status: failed` + `audioError`
4. Flutter:
   - shows transcript
   - if `audioUrl` is available, plays via `just_audio`

### Why `FormatException <!DOCTYPE...` happens
Frontend expected JSON but received HTML. Typical causes:
- wrong `AI_BASE_URL`
- backend URL unreachable
- calling frontend domain for `/mcp/...` by mistake
- backend endpoint not deployed (404 HTML/JSON mismatch)

## 5) Environment Variables

## Frontend Build-Time
- `AI_BASE_URL` (required)
  - Example:
    `https://kinetic-insight-production.up.railway.app`

Build example:

```bash
/home/manasa/development/flutter/bin/flutter build web --release --base-href / \
  --dart-define=AI_BASE_URL=https://kinetic-insight-production.up.railway.app
```

## Backend Runtime

### Required for TTS
- `SARVAM_API_KEY`

### Required for durable storage (S3/R2)
- `S3_BUCKET`
- `S3_ACCESS_KEY_ID`
- `S3_SECRET_ACCESS_KEY`
- `S3_REGION`
- `S3_ENDPOINT_URL`

### Optional
- `S3_KEY_PREFIX` (default: `audio`)
- `S3_PUBLIC_BASE_URL` (public CDN URL form)
- `S3_USE_PRESIGNED_URL=true|false` (default true when no public base)
- `S3_PRESIGNED_EXPIRES` (seconds)

## 6) Local Development

## Backend

```bash
cd /home/manasa/project/Kinetic-Insight/ai_backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
export SARVAM_API_KEY='your_key'
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Quick checks:

```bash
curl -i http://127.0.0.1:8000/health
curl -i http://127.0.0.1:8000/mcp/explanation/11/tir/en
```

## Frontend (web-server mode)

```bash
cd /home/manasa/project/Kinetic-Insight/project
/home/manasa/development/flutter/bin/flutter run -d web-server --web-port 8080 \
  --dart-define=AI_BASE_URL=http://127.0.0.1:8000
```

Open: `http://localhost:8080`

## 7) Production Deployment

## Backend (Railway)

Recommended:
- Root directory: `ai_backend`
- Start command:
  `uvicorn main:app --host 0.0.0.0 --port $PORT`
- Set all required env vars above

Validation:

```bash
curl -i https://<railway-domain>/health
curl -i https://<railway-domain>/mcp/explanation/11/tir/en
```

## Frontend (Vercel)

1. Build with Railway backend URL in `AI_BASE_URL`
2. Deploy compiled output only:

```bash
npx vercel --prod ./build/web
```

## 8) Audio Pre-Generation (All Experiments)

Use script:

```bash
cd /home/manasa/project/Kinetic-Insight/ai_backend
BASE_URL=https://<backend-domain> ./scripts/pregen_mcp_audio.sh
```

This calls all Class 6/7/9/11 experiment IDs for both `en` and `te`.

## 9) Troubleshooting Guide

### `ModuleNotFoundError: boto3`
Install backend dependencies again:

```bash
pip install -r ai_backend/requirements.txt
```

### `/mcp/explanation/...` returns 404 in production
- backend deployed from wrong directory
- old commit running
- wrong start command

### Frontend audio fails with `<!DOCTYPE` parse error
- frontend not built with correct `AI_BASE_URL`
- request hitting frontend domain instead of backend

### `status: failed` with `audioError`
- invalid/missing `SARVAM_API_KEY`
- invalid Sarvam payload/voice settings
- S3 upload/URL generation issue

## 10) Physics Topic Coverage (Current)

### Class 6
- transparency
- shadow
- pinhole camera
- refraction basics

### Class 7
- plane mirror
- spherical mirrors
- Newton disc

### Class 9
- laws of reflection
- kaleidoscope (multiple reflections)

### Class 11
- critical angle & total internal reflection
- prism formula
- lens image formation

## 11) Security and Ops Notes

- Do not commit API keys.
- Rotate any leaked keys immediately.
- Prefer S3/R2 over local audio in production.
- Use long cache headers for immutable versioned audio assets.
- If private delivery is needed, use signed URLs + auth.

---

For backend-specific operational details, also see:
- [`ai_backend/README.md`](./ai_backend/README.md)
