from __future__ import annotations

import hashlib
import os
import time
import base64
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, Optional, Tuple

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from starlette.middleware.base import BaseHTTPMiddleware
from pydantic import BaseModel
import requests
import boto3
from botocore.client import BaseClient
from botocore.exceptions import BotoCoreError, ClientError

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


class _StaticCacheControlMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):  # type: ignore[override]
        response = await call_next(request)
        if request.url.path.startswith('/static/audio/'):
            response.headers['Cache-Control'] = 'public, max-age=31536000, immutable'
        return response


app.add_middleware(_StaticCacheControlMiddleware)
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
_s3_client_singleton: Optional[BaseClient] = None


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
    audioError: Optional[str] = None


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
        (
            '9',
            'lawsOfReflection',
            'en',
        ): (
            'In this experiment, you change the incident angle and observe the reflected ray. '
            'The key law is simple: angle of incidence equals angle of reflection. '
            'Both angles are measured from the normal, not from the mirror surface. '
            'As you move the slider, both angles change equally. This is why mirrors form '
            'predictable paths of light. Try low, medium, and high angles and confirm that '
            'theta i and theta r always match.'
        ),
        (
            '9',
            'lawsOfReflection',
            'te',
        ): (
            'ఈ ప్రయోగంలో incident angle మార్చితే reflected ray ఎలా మారుతుందో చూస్తాం. '
            'ప్రధాన నియమం: angle of incidence = angle of reflection. ఈ రెండు కోణాలు '
            'mirror surface నుండి కాదు, normal నుండి కొలుస్తాం. Slider మార్చినప్పుడల్లా '
            'రెండు కోణాలు సమానంగా మారుతాయి. అందుకే mirror లో light path predict చేయగలం. '
            'తక్కువ, మధ్య, ఎక్కువ కోణాలతో ప్రయత్నించి theta i మరియు theta r ఎప్పుడూ సమానమని గమనించండి.'
        ),
        (
            '9',
            'kaleidoscope',
            'en',
        ): (
            'This kaleidoscope experiment shows multiple reflections between inclined mirrors. '
            'When the mirror angle decreases, repeated image sectors increase and patterns become richer. '
            'You can also vary number of mirrors and compare symmetry. '
            'Use the idea of 360 divided by mirror angle to estimate sector count. '
            'Observe how geometric repetition creates decorative patterns from simple rays.'
        ),
        (
            '9',
            'kaleidoscope',
            'te',
        ): (
            'ఈ kaleidoscope ప్రయోగంలో కోణంలో ఉన్న mirrors మధ్య multiple reflections జరుగుతాయి. '
            'Mirror angle తగ్గితే image sectors పెరుగుతాయి, pattern ఇంకా అందంగా కనిపిస్తుంది. '
            'Mirrors సంఖ్యను కూడా మార్చి symmetry ఎలా మారుతుందో చూడండి. '
            '360 ని mirror angle తో భాగిస్తే sectors trend అర్థమవుతుంది. '
            'సాధారణ rays ఎలా పునరావృతమై అందమైన pattern ఇస్తాయో గమనించండి.'
        ),
        (
            '7',
            'planeMirror',
            'en',
        ): (
            'In plane mirror activity, object distance and image distance are equal. '
            'The image is virtual, erect, and same size. '
            'As object moves closer or farther, image shifts equally behind the mirror. '
            'This experiment helps you understand lateral inversion and mirror symmetry.'
        ),
        (
            '7',
            'planeMirror',
            'te',
        ): (
            'Plane mirror ప్రయోగంలో object distance ఎంతైతే image distance కూడా అంతే ఉంటుంది. '
            'Image virtual, erect, మరియు objectకి same size లో ఉంటుంది. '
            'Object ను దగ్గరకి లేదా దూరంగా తీస్తే image కూడా mirror వెనుక సమానంగా మారుతుంది. '
            'ఈ ప్రయోగం lateral inversion మరియు mirror symmetry అర్థం చేసుకోవడంలో సహాయపడుతుంది.'
        ),
        (
            '7',
            'sphericalMirror',
            'en',
        ): (
            'Here you compare concave and convex spherical mirrors. '
            'By changing object distance and focal length, you can see real or virtual image conditions. '
            'The mirror formula one by f equals one by v plus one by u connects all cases. '
            'Watch how image size and orientation depend on object position.'
        ),
        (
            '7',
            'sphericalMirror',
            'te',
        ): (
            'ఈ ప్రయోగంలో concave మరియు convex spherical mirrors ను పోల్చి చూస్తాం. '
            'Object distance మరియు focal length మార్చితే image real లేదా virtual ఎలా మారుతుందో గమనించండి. '
            'Mirror formula 1/f = 1/v + 1/u అన్ని పరిస్థితులను కలుపుతుంది. '
            'Object స్థానాన్ని బట్టి image size మరియు orientation మార్పు స్పష్టంగా కనిపిస్తుంది.'
        ),
        (
            '7',
            'newtonDisc',
            'en',
        ): (
            'Newton disc demonstrates color recombination. '
            'At low speed, individual VIBGYOR sectors are visible. '
            'As speed increases, persistence of vision blends colors toward white. '
            'This links rotational motion with how our eyes perceive rapid color changes.'
        ),
        (
            '7',
            'newtonDisc',
            'te',
        ): (
            'Newton disc ప్రయోగం color recombination ని చూపిస్తుంది. '
            'తక్కువ వేగంలో VIBGYOR రంగులు విడిగా కనిపిస్తాయి. '
            'వేగం పెరిగేకొద్దీ persistence of vision వల్ల రంగులు కలసి తెలుపు రంగుకు దగ్గరగా కనిపిస్తాయి. '
            'Rotation మరియు మన కళ్ల perception మధ్య సంబంధాన్ని ఇది చక్కగా చూపిస్తుంది.'
        ),
        (
            '6',
            'transparency',
            'en',
        ): (
            'This experiment compares transparent, translucent, and opaque materials. '
            'Transparent objects pass most light, translucent pass some, and opaque block light. '
            'By changing material, observe clarity and shadow formation. '
            'This is the foundation for understanding how light interacts with matter.'
        ),
        (
            '6',
            'transparency',
            'te',
        ): (
            'ఈ ప్రయోగం transparent, translucent, opaque పదార్థాల తేడాను చూపిస్తుంది. '
            'Transparent పదార్థాలు ఎక్కువ కాంతి దాటనిస్తాయి, translucent కొంత మాత్రమే, opaque కాంతిని అడ్డుకుంటాయి. '
            'Material మార్చి clarity మరియు shadow ఎలా మారుతుందో చూడండి. '
            'కాంతి పదార్థాలతో ఎలా ప్రవర్తిస్తుందో అర్థం చేసుకోవడానికి ఇది ప్రాథమికం.'
        ),
        (
            '6',
            'shadow',
            'en',
        ): (
            'In shadow experiment, sun position changes shadow length and direction. '
            'When the light source is high, shadow is short. '
            'When light source is low, shadow becomes long. '
            'Observe how geometry of light and object creates daily shadow variation.'
        ),
        (
            '6',
            'shadow',
            'te',
        ): (
            'Shadow ప్రయోగంలో కాంతి మూలం స్థానాన్ని బట్టి నీడ పొడవు మరియు దిశ మారుతుంది. '
            'కాంతి పైకి ఉన్నప్పుడు నీడ చిన్నగా ఉంటుంది. '
            'కాంతి తక్కువ కోణంలో ఉన్నప్పుడు నీడ పొడవుగా ఉంటుంది. '
            'Light మరియు object geometry వల్ల రోజంతా నీడ ఎలా మారుతుందో గమనించండి.'
        ),
        (
            '6',
            'pinhole',
            'en',
        ): (
            'Pinhole camera shows that light travels in straight lines. '
            'A small hole forms an inverted image on the screen. '
            'As object distance changes, image size changes too. '
            'This is a simple but powerful model for image formation.'
        ),
        (
            '6',
            'pinhole',
            'te',
        ): (
            'Pinhole camera ప్రయోగం light straight line లో ప్రయాణిస్తుందని చూపిస్తుంది. '
            'చిన్న రంధ్రం వల్ల screen పై inverted image ఏర్పడుతుంది. '
            'Object distance మారితే image size కూడా మారుతుంది. '
            'Image formation అర్థం చేసుకోవడానికి ఇది చాలా సరళమైన కానీ ముఖ్యమైన మోడల్.'
        ),
        (
            '6',
            'refraction',
            'en',
        ): (
            'This experiment explains refraction, the bending of light at medium boundary. '
            'When light enters water from air, speed changes and ray bends. '
            'That is why a pencil in water appears bent or shifted. '
            'Track how apparent position differs from real position.'
        ),
        (
            '6',
            'refraction',
            'te',
        ): (
            'ఈ ప్రయోగం refraction ని వివరిస్తుంది. అంటే medium boundary వద్ద కాంతి వంగడం. '
            'Air నుండి water లోకి వెళ్తే కాంతి వేగం మారి ray దిశ మారుతుంది. '
            'అందుకే నీటిలో పెట్టిన పెన్సిల్ వంగినట్టు కనిపిస్తుంది. '
            'Actual position మరియు apparent position మధ్య తేడాను గమనించండి.'
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


def _s3_configured() -> bool:
    return bool(
        os.getenv('S3_BUCKET', '').strip()
        and os.getenv('S3_ACCESS_KEY_ID', '').strip()
        and os.getenv('S3_SECRET_ACCESS_KEY', '').strip()
    )


def _s3_client() -> Optional[BaseClient]:
    global _s3_client_singleton
    if not _s3_configured():
        return None
    if _s3_client_singleton is not None:
        return _s3_client_singleton
    _s3_client_singleton = boto3.client(
        's3',
        endpoint_url=os.getenv('S3_ENDPOINT_URL') or None,
        region_name=os.getenv('S3_REGION') or None,
        aws_access_key_id=os.getenv('S3_ACCESS_KEY_ID') or None,
        aws_secret_access_key=os.getenv('S3_SECRET_ACCESS_KEY') or None,
    )
    return _s3_client_singleton


def _s3_bucket() -> str:
    return os.getenv('S3_BUCKET', '').strip()


def _s3_prefix() -> str:
    return os.getenv('S3_KEY_PREFIX', 'audio').strip().strip('/')


def _s3_key(
    class_id: str,
    experiment_id: str,
    language: str,
    version: str,
    fmt: str,
) -> str:
    return f'{_s3_prefix()}/{class_id}/{experiment_id}/{language}/{version}.{fmt}'


def _s3_exists(key: str) -> bool:
    client = _s3_client()
    if client is None:
        return False
    try:
        client.head_object(Bucket=_s3_bucket(), Key=key)
        return True
    except ClientError:
        return False


def _s3_put_audio(key: str, audio_bytes: bytes, fmt: str) -> bool:
    client = _s3_client()
    if client is None:
        return False
    content_type = 'audio/mpeg' if fmt.lower() == 'mp3' else 'audio/wav'
    try:
        client.put_object(
            Bucket=_s3_bucket(),
            Key=key,
            Body=audio_bytes,
            ContentType=content_type,
            CacheControl='public, max-age=31536000, immutable',
        )
        return True
    except (ClientError, BotoCoreError):
        return False


def _s3_url(key: str) -> Optional[str]:
    client = _s3_client()
    if client is None:
        return None
    public_base = os.getenv('S3_PUBLIC_BASE_URL', '').strip().rstrip('/')
    if public_base:
        return f'{public_base}/{key}'
    use_presigned = os.getenv('S3_USE_PRESIGNED_URL', 'true').strip().lower()
    if use_presigned in {'1', 'true', 'yes'}:
        expires = int(os.getenv('S3_PRESIGNED_EXPIRES', '604800'))
        try:
            return client.generate_presigned_url(
                'get_object',
                Params={'Bucket': _s3_bucket(), 'Key': key},
                ExpiresIn=expires,
            )
        except (ClientError, BotoCoreError):
            return None
    endpoint = os.getenv('S3_ENDPOINT_URL', '').strip().rstrip('/')
    if endpoint:
        return f'{endpoint}/{_s3_bucket()}/{key}'
    return None


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

    # Prefer durable object storage when configured.
    s3_key = _s3_key(class_id, experiment_id, language, version, fmt)
    audio_id = f'aud_{class_id}_{experiment_id}_{language}_{version}'
    if _s3_configured():
        if _s3_exists(s3_key):
            s3_audio_url = _s3_url(s3_key)
            payload = {
                'audioId': audio_id,
                'audioUrl': s3_audio_url,
                'status': 'ready' if s3_audio_url else 'failed',
                'cached': False,
                'audioError': None if s3_audio_url else 'S3 object exists but URL resolution failed.',
            }
            _audio_meta_cache.set(key, payload, AUDIO_META_TTL_SECONDS)
            return payload

        generated, audio_bytes, error_message = _generate_audio_with_sarvam(
            text=script,
            language=language,
            voice_profile=voice_profile,
            fmt=fmt,
        )
        if generated and audio_bytes is not None and _s3_put_audio(s3_key, audio_bytes, fmt):
            s3_audio_url = _s3_url(s3_key)
            payload = {
                'audioId': audio_id,
                'audioUrl': s3_audio_url,
                'status': 'ready' if s3_audio_url else 'failed',
                'cached': False,
                'audioError': None if s3_audio_url else 'S3 upload succeeded but URL resolution failed.',
            }
        else:
            payload = {
                'audioId': audio_id,
                'audioUrl': None,
                'status': 'failed',
                'cached': False,
                'audioError': error_message or 'S3 upload failed after audio generation.',
            }
        _audio_meta_cache.set(key, payload, AUDIO_META_TTL_SECONDS)
        return payload

    # Local static fallback (non-durable).
    relative_path = f'audio/{class_id}/{experiment_id}/{language}/{version}.{fmt}'
    local_path = Path(__file__).parent / 'static' / relative_path
    if local_path.exists():
        payload = {
            'audioId': audio_id,
            'audioUrl': f'/static/{relative_path}',
            'status': 'ready',
            'cached': False,
        }
    else:
        generated, audio_bytes, error_message = _generate_audio_with_sarvam(
            text=script,
            language=language,
            voice_profile=voice_profile,
            fmt=fmt,
        )
        if generated and audio_bytes is not None:
            local_path.parent.mkdir(parents=True, exist_ok=True)
            local_path.write_bytes(audio_bytes)
            payload = {
                'audioId': audio_id,
                'audioUrl': f'/static/{relative_path}',
                'status': 'ready',
                'cached': False,
                'audioError': None,
            }
        else:
            payload = {
                'audioId': audio_id,
                'audioUrl': None,
                'status': 'failed',
                'cached': False,
                'audioError': error_message,
            }
    _audio_meta_cache.set(key, payload, AUDIO_META_TTL_SECONDS)
    return payload


def _pick_speaker(language: str, voice_profile: str) -> str:
    normalized = voice_profile.strip()
    if normalized and normalized not in {'teacher_warm_v1', 'default'}:
        # Allow explicit speaker override when caller passes valid Sarvam speaker.
        return normalized
    return 'kavitha' if language == 'te' else 'shubh'


def _pick_lang_code(language: str) -> str:
    return 'te-IN' if language == 'te' else 'en-IN'


def _generate_audio_with_sarvam(
    *,
    text: str,
    language: str,
    voice_profile: str,
    fmt: str,
) -> Tuple[bool, Optional[bytes], Optional[str]]:
    api_key = os.getenv('SARVAM_API_KEY', '').strip()
    if not api_key:
        return False, None, 'SARVAM_API_KEY is not set in backend environment.'

    endpoints = [
        'https://api.sarvam.ai/text-to-speech',
        'https://api.sarvam.ai/text-to-speech/convert',
    ]
    speaker = _pick_speaker(language, voice_profile)
    base_payload: Dict[str, Any] = {
        'text': text,
        'target_language_code': _pick_lang_code(language),
        'speaker': speaker,
        'model': 'bulbul:v3',
        'pace': 1.0,
    }
    payload_variants = [
        {
            **base_payload,
            'output_audio_codec': fmt,
            'temperature': 0.6,
        },
        base_payload,
    ]
    headers = {
        'api-subscription-key': api_key,
        'Content-Type': 'application/json',
    }

    last_error: Optional[str] = None
    try:
        for endpoint in endpoints:
            for payload in payload_variants:
                response = requests.post(
                    endpoint,
                    headers=headers,
                    json=payload,
                    timeout=45,
                )
                if response.status_code < 200 or response.status_code >= 300:
                    last_error = (
                        f'Sarvam HTTP {response.status_code} at {endpoint}: '
                        f'{response.text[:220]}'
                    )
                    continue
                data = response.json()
                audios = data.get('audios') if isinstance(data, dict) else None
                if not isinstance(audios, list) or not audios:
                    last_error = (
                        f'Sarvam response missing audios at {endpoint}: {str(data)[:220]}'
                    )
                    continue
                first_audio = audios[0]
                if not isinstance(first_audio, str) or not first_audio:
                    last_error = 'Sarvam audio payload is empty.'
                    continue
                audio_bytes = base64.b64decode(first_audio)
                return True, audio_bytes, None
    except Exception:
        last_error = 'Sarvam request raised exception.'
    return False, None, last_error


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
        audioError=audio_data.get('audioError'),
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
