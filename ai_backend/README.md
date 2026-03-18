# Kinetic Insight AI Backend (Phase 1)

## Setup

```bash
cd /mnt/d/kinetic_insight/ai_backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Environment

```bash
export OPENAI_API_KEY="your_api_key"
export OPENAI_MODEL="gpt-4.1-mini"
```

If `OPENAI_API_KEY` is not set, backend returns deterministic fallback tutor responses.

## Run

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

## Endpoint

`POST /ai/tutor`

Example body:

```json
{
  "classId": "7",
  "experimentId": "newton_disc",
  "mode": "ask_or_feedback",
  "studentState": {
    "speedLevel": "High",
    "computed": {
      "whiteOpacity": 0.72
    },
    "step": "observation_done"
  }
}
```
