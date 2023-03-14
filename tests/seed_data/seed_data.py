#!/usr/bin/env python3

import os 
import motor.motor_asyncio
from bson import ObjectId
import json 


MONGODB_URL = "mongodb://admin:password1@0.0.0.0:27017"
client = motor.motor_asyncio.AsyncIOMotorClient(MONGODB_URL)
db = client.song_library

def main():
    dir_path = os.path.dirname(os.path.realpath(__file__))
    full_path = os.path.join(dir_path, 'seed_songs.json')
    with open(full_path) as seed_file:
        songs = json.load(seed_file)
        db["song_library"].insert_many(songs)


if __name__ == "__main__": 
    main()