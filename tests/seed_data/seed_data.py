#!/usr/bin/env python3

import os 
import motor.motor_asyncio
from bson import ObjectId
import json 


MONGODB_URL = "mongodb://admin:password1@0.0.0.0:27017"
client = motor.motor_asyncio.AsyncIOMotorClient(MONGODB_URL)
db = client.song_library

with open('seed_songs.json') as seed_file:
    songs = json.load(seed_file)
    db["song_library"].insert_many(songs)