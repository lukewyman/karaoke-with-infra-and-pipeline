from fastapi import FastAPI, HTTPException, status, Body 
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from typing import List
import logging 
from .models import Singer, CreateSinger, SetStageName
from .database import db 

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


app = FastAPI()

@app.get('/health', response_description='container health check')
async def health_check():
    return JSONResponse(status_code=200, content='OK')


@app.post('/singers', response_description='Add a new Singer', response_model=Singer)
async def create_singer(singer: CreateSinger=Body(...)):
    singer = jsonable_encoder(singer)
    new_singer = await db['singers'].insert_one(singer)
    created_singer = await db['singers'].find_one({'_id': new_singer.inserted_id})
    logger.info(f'Created Singer: {created_singer}')

    return JSONResponse(status_code=status.HTTP_201_CREATED, content=created_singer)


@app.get('/singers/{singer_id}', response_description='Get a Singer', response_model=Singer)
async def get_singer(singer_id):
    if (singer := await db['singers'].find_one({'_id': singer_id})) is not None:
        return JSONResponse(status_code=status.HTTP_200_OK, content=singer)
    
    raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, 
                        detail=f'Singer with id {singer_id} not found.')


@app.patch('/singers/{singer_id}', response_description="Update Singer's stage name", 
           response_model=Singer)
async def update_singers_stage_name(singer_id, set_stage_name: SetStageName=(Body(...))):
    if (singer:= await db['singers'].find_one({'_id': singer_id})) is not None:
        result = await db['singers'].update_one({'_id': singer_id}, 
                                                {'$set': {'stage_name': set_stage_name.stage_name}})
        if result.modified_count > 0:
            logger.info(f'Singer with id {singer_id} stage name updated to {set_stage_name.stage_name}')
            updated_singer = db['singers'].find_one({"_id": singer_id})

            return JSONResponse(status_code=status.HTTP_200_OK, content=updated_singer)
        else:
            raise HTTPException(status_code=status.HTTP_304_NOT_MODIFIED, 
                                detail=f'Singer with id {singer_id} not modified')
        
