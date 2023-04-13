from bson import ObjectId
from pydantic import BaseModel, Field


class PyObjectId(ObjectId):
    @classmethod
    def __get_validators__(cls):
        yield cls.validate 
    
    @classmethod 
    def validate(cls, v):
        if not ObjectId.is_valid(v):
            raise ValueError('InvalidObjectId')
        return ObjectId(v)
    
    @classmethod 
    def __modify_schema__(cls, field_schema):
        field_schema.update(type='string')    


class CreateSinger(BaseModel):
    id: PyObjectId = Field(default_factory=PyObjectId, alias='_id')
    first_name: str 
    last_name: str 

    class Config:
        allow_manipulation_by_field_name = True 
        arbitrary_types = True 
        json_encoders = {ObjectId: str}
        schema_extra = {
            'example': {
                'first_name': 'Susan',
                'last_name': 'Jones',
            }
        }


class Singer(BaseModel):
    id: PyObjectId = Field(default_factory=PyObjectId, alias='_id')
    first_name: str 
    last_name: str 
    stage_name: str 

    class Config:
        allow_manipulation_by_field_name = True 
        arbitrary_types = True 
        json_encoders = {ObjectId: str}
        schema_extra = {
            'example': {
                'first_name': 'Susan',
                'last_name': 'Jones',
                'stage_name': 'Super Star'
            }
        }


class SetStageName(BaseModel):
    stage_name: str 

    class Config:
        allow_manipulation_by_field_name = True 
        arbitrary_types = True 
        schema_extra = {
            'example': {
                'stage_name': 'Super Start'
            }
        }

