# Kinetic Insight AI Backend (Phase 1)

## Setup

```bash
cd /mnt/d/kinetic_insight/ai_backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Backend currently uses deterministic tutor logic for Class 7 Newton's Disc.

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
  "mode": "check_answer",
  "studentState": {
    "speedLevel": "Very High",
    "computed": {
      "whiteOpacity": 0.95
    },
    "step": "answer_submitted",
    "selectedOption": 0
  }
}
```
