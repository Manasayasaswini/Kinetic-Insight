from __future__ import annotations

import hashlib
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, Optional, Tuple

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

app = FastAPI(title='Kinetic Insight AI Backend', version='0.1.0')

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        'http://localhost:8080',
        'http://127.0.0.1:8080',
        'http://localhost:3000',
        'http://127.0.0.1:3000',
        'https://kinetic-insight.vercel.app',
        'https://kineticinsight.530020.online',
    ],
    allow_origin_regex=r'https://.*(vercel\.app|530020\.online)',
    allow_credentials=True,
    allow_methods=['*'],
    allow_headers=['*'],
)
app.mount('/static', StaticFiles(directory='static', check_dir=False), name='static')

SCRIPT_TTL_SECONDS = 60 * 60 * 24 * 30  # 30 days
AUDIO_META_TTL_SECONDS = 60 * 60 * 24 * 365  # 1 year


@dataclass
class _CacheValue:
    expires_at: float
    payload: Dict[str, Any]


class _TtlCache:
    def __init__(self) -> None:
        self._store: Dict[str, _CacheValue] = {}

    def get(self, key: str) -> Optional[Dict[str, Any]]:
        item = self._store.get(key)
        if item is None:
            return None
        if item.expires_at < time.time():
            self._store.pop(key, None)
            return None
        return item.payload

    def set(self, key: str, payload: Dict[str, Any], ttl_seconds: int) -> None:
        self._store[key] = _CacheValue(
            expires_at=time.time() + ttl_seconds,
            payload=payload,
        )


_script_cache = _TtlCache()
_audio_meta_cache = _TtlCache()


class McpExplanationResponse(BaseModel):
    classId: str
    experimentId: str
    language: str
    version: str
    status: str
    scriptId: str
    script: str
    audioId: Optional[str] = None
    audioUrl: Optional[str] = None
    audioCached: bool = False


class McpExplanationScriptRequest(BaseModel):
    classId: str
    experimentId: str
    language: str
    tone: str = 'student_friendly'
    version: str = 'v1'


class McpExplanationAudioRequest(BaseModel):
    classId: str
    experimentId: str
    language: str
    version: str = 'v1'
    voiceProfile: str = 'teacher_warm_v1'
    format: str = 'mp3'


def _normalize_language(language: str) -> str:
    normalized = language.strip().lower()
    if normalized in {'en', 'english'}:
        return 'en'
    if normalized in {'te', 'telugu'}:
        return 'te'
    return normalized


def _script_cache_key(
    class_id: str,
    experiment_id: str,
    language: str,
    version: str,
) -> str:
    return f'script:{class_id}:{experiment_id}:{language}:{version}'


def _audio_meta_cache_key(
    script_hash: str,
    language: str,
    voice_profile: str,
    fmt: str,
) -> str:
    return f'audio:{script_hash}:{language}:{voice_profile}:{fmt}'


def _script_bank() -> Dict[Tuple[str, str, str], str]:
    # Humanized, classroom-style scripts for first delivery slice.
    return {
        (
            '11',
            'tir',
            'en',
        ): (
            'Welcome! In this experiment, we are learning critical angle and total '
            'internal reflection. You will change two things: refractive index and '
            'incident angle. Watch what happens near the boundary. If the incident '
            'angle is smaller than critical angle, light refracts into air. At the '
            'critical angle, the refracted ray grazes the surface. If the incident '
            'angle goes beyond critical angle, no refracted ray appears and light '
            'reflects back completely. That is total internal reflection. This is '
            'the core idea behind optical fibers used in internet communication and '
            'medical endoscopy. Try changing the incident angle step by step and '
            'notice exactly when the state changes.'
        ),
        (
            '11',
            'tir',
            'te',
        ): (
            'నమస్తే! ఈ ప్రయోగంలో critical angle మరియు total internal reflection ని '
            'సులభంగా అర్థం చేసుకుందాం. మీరు రెండు inputs మార్చాలి: refractive index '
            'మరియు incident angle. Boundary దగ్గర కిరణం ఎలా ప్రవర్తిస్తుందో గమనించండి. '
            'Incident angle critical angle కంటే తక్కువైతే refraction జరుగుతుంది. '
            'Critical angle వద్ద refracted ray ఉపరితలం వెంట సాగుతుంది. ఆ కోణం దాటితే '
            'refracted ray కనిపించదు, కిరణం పూర్తిగా తిరిగి లోపలే ప్రతిఫలిస్తుంది. '
            'దాన్నే total internal reflection అంటాం. Optical fiber communication లో ఇదే '
            'principle పని చేస్తుంది. Incident angle ని క్రమంగా పెంచుతూ state ఎప్పుడు '
            'మారుతుందో గమనించండి.'
        ),
        (
            '11',
            'prism',
            'en',
        ): (
            'In this prism experiment, you will enter apex angle A and minimum '
            'deviation delta. The simulator computes refractive index using '
            'n equals sine of A plus delta by 2, divided by sine of A by 2. '
            'Keep an eye on how n changes when delta changes. Larger deviation '
            'generally means stronger bending and higher refractive index for '
            'the same apex angle. This idea helps explain how prisms spread '
            'white light into colors.'
        ),
        (
            '11',
            'prism',
            'te',
        ): (
            'ఈ prism ప్రయోగంలో మీరు apex angle A మరియు minimum deviation delta '
            'ఇస్తారు. ఆ values తో refractive index n ని formula ద్వారా కనుక్కుంటాం. '
            'Delta మారితే n ఎలా మారుతుందో గమనించండి. అదే A ఉన్నప్పుడు deviation ఎక్కువైతే '
            'కాంతి bending కూడా ఎక్కువగా ఉంటుంది. ఇదే concept వల్ల prism లో white light '
            'రంగులుగా విడిపోతుంది.'
        ),
        (
            '11',
            'lens',
            'en',
        ): (
            'Here you will explore image formation by convex and concave lenses. '
            'Enter object distance and focal length, then observe image distance, '
            'magnification, and image nature. For a convex lens, changing object '
            'position across focal points gives different real or virtual images. '
            'A concave lens usually gives a virtual, upright, diminished image. '
            'Use the thin lens formula and compare the output with the canvas rays.'
        ),
        (
            '11',
            'lens',
            'te',
        ): (
            'ఈ lens ప్రయోగంలో convex మరియు concave lenses లో image ఎలా ఏర్పడుతుందో '
            'చూద్దాం. Object distance, focal length values ఇచ్చి image distance, '
            'magnification, image type ను గమనించండి. Convex lens లో object position '
            'మారితే image nature కూడా మారుతుంది. Concave lens సాధారణంగా virtual, upright, '
            'diminished image ఇస్తుంది. Formula output ను canvas rays తో compare చేస్తే '
            'concept చాలా clear అవుతుంది.'
        ),
    }


def _fallback_script(class_id: str, experiment_id: str, language: str) -> str:
    if language == 'te':
        return (
            'ఈ ప్రయోగం గురించి సులభమైన వివరణను త్వరలో అందిస్తాము. '
            'ఇప్పటికి inputs మార్చి output మరియు observation ను పరిశీలించండి.'
        )
    return (
        'A student-friendly explanation for this experiment will be available soon. '
        'For now, vary the inputs and compare output with observation.'
    )


def _resolve_script(
    class_id: str,
    experiment_id: str,
    language: str,
    version: str,
) -> Dict[str, Any]:
    key = _script_cache_key(class_id, experiment_id, language, version)
    cached = _script_cache.get(key)
    if cached is not None:
        return {**cached, 'cached': True}

    bank = _script_bank()
    script = bank.get((class_id, experiment_id, language))
    if script is None:
        script = _fallback_script(class_id, experiment_id, language)
    script_id = f'scr_{class_id}_{experiment_id}_{language}_{version}'
    payload = {'scriptId': script_id, 'script': script, 'cached': False}
    _script_cache.set(key, payload, SCRIPT_TTL_SECONDS)
    return payload


def _resolve_audio_meta(
    class_id: str,
    experiment_id: str,
    language: str,
    version: str,
    voice_profile: str,
    fmt: str,
    script: str,
) -> Dict[str, Any]:
    script_hash = hashlib.sha256(script.encode('utf-8')).hexdigest()[:16]
    key = _audio_meta_cache_key(script_hash, language, voice_profile, fmt)
    cached = _audio_meta_cache.get(key)
    if cached is not None:
        return {**cached, 'cached': True}

    # MCP/TTS integration point:
    # For now, if static audio exists we mark ready. Otherwise generating.
    relative_path = f'audio/{class_id}/{experiment_id}/{language}/{version}.{fmt}'
    local_path = Path(__file__).parent / 'static' / relative_path
    audio_id = f'aud_{class_id}_{experiment_id}_{language}_{version}'
    if local_path.exists():
        payload = {
            'audioId': audio_id,
            'audioUrl': f'/static/{relative_path}',
            'status': 'ready',
            'cached': False,
        }
    else:
        payload = {
            'audioId': audio_id,
            'audioUrl': None,
            'status': 'generating',
            'cached': False,
        }
    _audio_meta_cache.set(key, payload, AUDIO_META_TTL_SECONDS)
    return payload


@app.get('/')
def root() -> Dict[str, str]:
    return {'message': 'Backend is running'}


@app.get('/health')
def health() -> Dict[str, str]:
    return {'status': 'ok'}


@app.get('/mcp/explanation/{class_id}/{experiment_id}/{language}')
def get_explanation(
    class_id: str,
    experiment_id: str,
    language: str,
    version: str = 'v1',
    voice_profile: str = 'teacher_warm_v1',
    fmt: str = 'mp3',
) -> McpExplanationResponse:
    lang = _normalize_language(language)
    script_data = _resolve_script(class_id, experiment_id, lang, version)
    audio_data = _resolve_audio_meta(
        class_id=class_id,
        experiment_id=experiment_id,
        language=lang,
        version=version,
        voice_profile=voice_profile,
        fmt=fmt,
        script=script_data['script'],
    )
    return McpExplanationResponse(
        classId=class_id,
        experimentId=experiment_id,
        language=lang,
        version=version,
        status=audio_data['status'],
        scriptId=script_data['scriptId'],
        script=script_data['script'],
        audioId=audio_data['audioId'],
        audioUrl=audio_data['audioUrl'],
        audioCached=bool(audio_data.get('cached', False)),
    )


@app.post('/mcp/explanation/script')
def generate_explanation_script(
    request: McpExplanationScriptRequest,
) -> Dict[str, Any]:
    lang = _normalize_language(request.language)
    payload = _resolve_script(
        class_id=request.classId,
        experiment_id=request.experimentId,
        language=lang,
        version=request.version,
    )
    return {
        'classId': request.classId,
        'experimentId': request.experimentId,
        'language': lang,
        'tone': request.tone,
        'version': request.version,
        'scriptId': payload['scriptId'],
        'text': payload['script'],
        'cached': payload.get('cached', False),
    }


@app.post('/mcp/explanation/audio')
def generate_explanation_audio(
    request: McpExplanationAudioRequest,
) -> Dict[str, Any]:
    lang = _normalize_language(request.language)
    script_data = _resolve_script(
        class_id=request.classId,
        experiment_id=request.experimentId,
        language=lang,
        version=request.version,
    )
    audio_data = _resolve_audio_meta(
        class_id=request.classId,
        experiment_id=request.experimentId,
        language=lang,
        version=request.version,
        voice_profile=request.voiceProfile,
        fmt=request.format,
        script=script_data['script'],
    )
    return {
        'classId': request.classId,
        'experimentId': request.experimentId,
        'language': lang,
        'version': request.version,
        'voiceProfile': request.voiceProfile,
        'format': request.format,
        'audioId': audio_data['audioId'],
        'url': audio_data['audioUrl'],
        'status': audio_data['status'],
        'cached': audio_data.get('cached', False),
    }
