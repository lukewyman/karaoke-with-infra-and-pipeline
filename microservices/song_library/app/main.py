from fastapi import FastAPI, HTTPException, status, Body 
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from typing import List
import logging 
from .models import Song 
from .database import db 

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


app = FastAPI()

@app.get('/health', response_description='container health check')
async def health_check():
    return JSONResponse(status_code=200, content='OK')


@app.post('/songs', response_description='Add a new Song', response_model=Song)
async def create_song(song: Song=Body(...)):
    song = jsonable_encoder(song)
    new_song = await db['song_library'].insert_one(song)
    created_song = await db['song_library'].find_one({'_id': new_song.inserted_id})
    logger.info(f'Created Song: {created_song}')
    
    return JSONResponse(status_code=status.HTTP_201_CREATED, content=created_song)


@app.get('/songs/{song_id}', response_description='Get a Song', response_model=Song)
async def get_song(song_id):
    if (song := await db['song_library'].find_one({'_id': song_id})) is not None:
        return JSONResponse(status_code=status.HTTP_200_OK, content=song)
    
    raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, 
                        detail=f'Song with id {song_id} not found.')
