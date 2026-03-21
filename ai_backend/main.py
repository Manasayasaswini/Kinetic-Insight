from typing import Dict

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

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


@app.get('/')
def root() -> Dict[str, str]:
    return {'message': 'Backend is running'}


@app.get('/health')
def health() -> Dict[str, str]:
    return {'status': 'ok'}
