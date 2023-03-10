import pytest 
import requests
import json
import motor


@pytest.fixture 
def song_library_api_endpoint():
    return 'http://0.0.0.0:8081'


def test_create_song(song_library_api_endpoint):
    post_data = {
        'song_title': 'title create song',
        'artist': 'artist create song'
    }

    headers = {'Content-Type': 'application/json'}
    url = f'{song_library_api_endpoint}/songs'

    response = requests.post(url, data=json.dumps(post_data), headers=headers)

    assert response.status_code == 201 
    assert '_id' in response.json()


def test_get_song(song_library_api_endpoint):
    get_song_id = '0123456789ab0123456789ab'
    headers = {'Content-Type': 'application/json'}
    url = f'{song_library_api_endpoint}/songs/{get_song_id}'

    response = requests.get(url, headers=headers)

    assert response.status_code == 200
    assert response.json()["_id"] == '0123456789ab0123456789ab'
