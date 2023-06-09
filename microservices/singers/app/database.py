import os 
import motor.motor_asyncio


docdb_endpoint = os.environ['DOCDB_ENDPOINT']
docdb_port     = os.environ['DOCDB_PORT']
docdb_username = os.environ['DOCDB_USERNAME']
docdb_password = os.environ['DOCDB_PASSWORD']
docdb_suffix   = '/?replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false'
if docdb_endpoint == 'mongo':
    docdb_suffix = ''

docdb_url = f'mongodb://{docdb_username}:{docdb_password}@{docdb_endpoint}:{docdb_port}{docdb_suffix}'

client = motor.motor_asyncio.AsyncIOMotorClient(docdb_url)
db = client.karaoke