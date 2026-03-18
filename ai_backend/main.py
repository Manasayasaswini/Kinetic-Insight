import os
from typing import Any, Dict, Optional

import requests
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

app = FastAPI(title='Kinetic Insight AI Backend', version='0.1.0')

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        'http://localhost:8080',
        'http://127.0.0.1:8080',
        'http://localhost:3000',
        'http://127.0.0.1:3000',
    ],
    allow_credentials=True,
    allow_methods=['*'],
    allow_headers=['*'],
)


class TutorRequest(BaseModel):
    classId: str = Field(..., min_length=1)
    experimentId: str = Field(..., min_length=1)
    mode: str = Field(default='ask_or_feedback')
    studentState: Dict[str, Any] = Field(default_factory=dict)


class TutorResponse(BaseModel):
    question: str
    feedback: str
    nextStep: str
    status: str


def _build_newton_disc_state_summary(student_state: Dict[str, Any]) -> Dict[str, Any]:
    speed_level = student_state.get('speedLevel', 'Low')
    computed = student_state.get('computed', {})
    white_opacity = float(computed.get('whiteOpacity', 0.0))

    level_order = {'Low': 0, 'Medium': 1, 'High': 2, 'Very High': 3}
    level_value = level_order.get(speed_level, 0)

    if level_value >= 3 and white_opacity >= 0.9:
        status = 'excellent'
        summary = 'Student reached very high speed and observed near-white blending correctly.'
    elif level_value >= 2 and white_opacity >= 0.6:
        status = 'good_try'
        summary = 'Student reached high speed and observed partial color blending.'
    else:
        status = 'needs_retry'
        summary = 'Student has not yet reached sufficient speed for strong white blending.'

    return {
        'status': status,
        'summary': summary,
        'speedLevel': speed_level,
        'whiteOpacity': round(white_opacity, 2),
    }


def _fallback_tutor_response(state: Dict[str, Any], mode: str) -> TutorResponse:
    if mode == 'ask_or_feedback' and not state:
        return TutorResponse(
            question='Set Newton\'s Disc speed to Very High. What color does the disc appear?',
            feedback='Do the experiment first, then tap Check My Experiment.',
            nextStep='Start at Low, then move to Very High and observe carefully.',
            status='question',
        )

    eval_state = _build_newton_disc_state_summary(state)
    status = eval_state['status']
    white_opacity = eval_state['whiteOpacity']

    if status == 'excellent':
        feedback = (
            f'Great observation. At {eval_state["speedLevel"]} speed, white blend ({white_opacity}) is strong, '
            'so colors combine toward white.'
        )
        next_step = 'Now reduce speed to Low and compare the separate VIBGYOR colors.'
    elif status == 'good_try':
        feedback = (
            f'Good work. You are seeing partial blending at {eval_state["speedLevel"]} speed '
            f'(white blend {white_opacity}).'
        )
        next_step = 'Increase to Very High and check if the disc appears closer to white.'
    else:
        feedback = (
            f'Nice attempt. At {eval_state["speedLevel"]} speed the white blend ({white_opacity}) is still low.'
        )
        next_step = 'Increase speed and observe when colors start merging strongly.'

    return TutorResponse(
        question='What changed in color appearance when speed increased?',
        feedback=feedback,
        nextStep=next_step,
        status=status,
    )


def _openai_tutor_response(state: Dict[str, Any], mode: str) -> Optional[TutorResponse]:
    api_key = os.getenv('OPENAI_API_KEY')
    if not api_key:
        return None

    model = os.getenv('OPENAI_MODEL', 'gpt-4.1-mini')
    eval_state = _build_newton_disc_state_summary(state)

    system_prompt = (
        'You are a friendly physics tutor for middle-school students. '\
        'Respond in simple language. Keep each field concise (1-2 short lines). '\
        'Never invent formulas beyond the provided context.'
    )

    user_prompt = {
        'task': 'Return JSON with keys: question, feedback, nextStep, status.',
        'mode': mode,
        'classId': '7',
        'experimentId': 'newton_disc',
        'evaluatedState': eval_state,
        'context': (
            'Newton disc combines VIBGYOR toward white at very high rotation. '
            'Student should compare Low vs Very High speed.'
        ),
    }

    try:
        response = requests.post(
            'https://api.openai.com/v1/responses',
            headers={
                'Authorization': f'Bearer {api_key}',
                'Content-Type': 'application/json',
            },
            json={
                'model': model,
                'input': [
                    {'role': 'system', 'content': system_prompt},
                    {'role': 'user', 'content': str(user_prompt)},
                ],
                'temperature': 0.3,
                'text': {'format': {'type': 'json_object'}},
            },
            timeout=20,
        )
        response.raise_for_status()
        data = response.json()

        raw_text = ''
        for item in data.get('output', []):
            for content in item.get('content', []):
                if content.get('type') == 'output_text':
                    raw_text += content.get('text', '')

        if not raw_text:
            return None

        parsed = requests.models.complexjson.loads(raw_text)
        return TutorResponse(
            question=str(parsed.get('question', 'What do you observe now?')),
            feedback=str(parsed.get('feedback', 'Good attempt. Keep observing carefully.')),
            nextStep=str(parsed.get('nextStep', 'Try changing speed and compare results.')),
            status=str(parsed.get('status', eval_state['status'])),
        )
    except Exception:
        return None


@app.get('/health')
def health() -> Dict[str, str]:
    return {'status': 'ok'}


@app.post('/ai/tutor', response_model=TutorResponse)
def ai_tutor(request: TutorRequest) -> TutorResponse:
    if request.classId != '7' or request.experimentId != 'newton_disc':
        return TutorResponse(
            question='Use Newton\'s Disc experiment for this AI testing phase.',
            feedback='This endpoint currently supports Class 7 Newton\'s Disc only.',
            nextStep='Switch to Class 7 Newton\'s Disc and try again.',
            status='unsupported',
        )

    llm_response = _openai_tutor_response(request.studentState, request.mode)
    if llm_response is not None:
        return llm_response

    return _fallback_tutor_response(request.studentState, request.mode)
