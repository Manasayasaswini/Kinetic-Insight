from typing import Any, Dict, List, Optional

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
        'https://kinetic-insight.vercel.app',
    ],
    allow_origin_regex=r'https://.*\.vercel\.app',
    allow_credentials=True,
    allow_methods=['*'],
    allow_headers=['*'],
)

NEWTON_OPTIONS = [
    'At very high speed, colors blend and the disc appears nearly white.',
    'At high speed, each color becomes darker and separate.',
    'The disc shows only red color when speed increases.',
    'Color does not change with speed.',
]
CORRECT_OPTION_INDEX = 0


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
    options: List[str] = Field(default_factory=list)
    isCorrect: Optional[bool] = None
    botMood: str = 'neutral'
    answerReview: str = ''


def _build_newton_disc_state_summary(student_state: Dict[str, Any]) -> Dict[str, Any]:
    speed_level = student_state.get('speedLevel', 'Low')
    computed = student_state.get('computed', {})
    white_opacity = float(computed.get('whiteOpacity', 0.0))

    level_order = {'Low': 0, 'Medium': 1, 'High': 2, 'Very High': 3}
    level_value = level_order.get(speed_level, 0)

    if level_value >= 3 and white_opacity >= 0.9:
        status = 'excellent'
    elif level_value >= 2 and white_opacity >= 0.6:
        status = 'good_try'
    else:
        status = 'needs_retry'

    return {
        'status': status,
        'speedLevel': speed_level,
        'whiteOpacity': round(white_opacity, 2),
    }


def _build_newton_question_response() -> TutorResponse:
    return TutorResponse(
        question='After increasing speed, what do you observe in Newton\'s Disc?',
        feedback='Run the experiment and choose one option.',
        nextStep='Move from Low to Very High, observe carefully, then submit your answer.',
        status='question',
        options=NEWTON_OPTIONS,
        isCorrect=None,
        botMood='neutral',
        answerReview='',
    )


def _evaluate_newton_option(state: Dict[str, Any]) -> TutorResponse:
    eval_state = _build_newton_disc_state_summary(state)
    selected_option = state.get('selectedOption')

    if not isinstance(selected_option, int):
        return TutorResponse(
            question='Choose one option first.',
            feedback='Select an answer option and submit.',
            nextStep='Observe the disc at Very High speed before answering.',
            status='question',
            options=NEWTON_OPTIONS,
            isCorrect=None,
            botMood='neutral',
            answerReview='Pick one option and submit.',
        )

    concept_correct = selected_option == CORRECT_OPTION_INDEX
    experiment_observed = eval_state['status'] in {'excellent', 'good_try'}

    if concept_correct and experiment_observed:
        return TutorResponse(
            question='Great job, little scientist!',
            feedback='Yes your experiment is correct little scientist! ...',
            nextStep='Yess! You got the correct answer!',
            status='correct',
            options=NEWTON_OPTIONS,
            isCorrect=True,
            botMood='happy',
            answerReview='Perfect observation. You matched the correct concept.',
        )

    if concept_correct and not experiment_observed:
        return TutorResponse(
            question='Good thinking!',
            feedback='You picked the right idea, but run the disc faster to verify it live.',
            nextStep='Move to Very High speed, observe white blending, then submit again.',
            status='retry',
            options=NEWTON_OPTIONS,
            isCorrect=False,
            botMood='retry',
            answerReview='Concept is correct, but experiment speed needs to be higher.',
        )

    return TutorResponse(
        question='Nice try!',
        feedback='You have done a try... the correct way is to increase speed and observe colors blending toward white.',
        nextStep='Try again: At very high speed, the disc appears nearly white.',
        status='incorrect',
        options=NEWTON_OPTIONS,
        isCorrect=False,
        botMood='oops',
        answerReview='Not this one. Focus on what happens at very high speed.',
    )


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
            options=[],
            isCorrect=None,
            botMood='neutral',
            answerReview='',
        )

    if request.mode == 'check_answer':
        return _evaluate_newton_option(request.studentState)

    return _build_newton_question_response()
