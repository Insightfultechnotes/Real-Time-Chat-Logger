import base64
import json
from google.cloud import firestore

db = firestore.Client()

def pubsub_to_firestore(event, context):
    try:
        if 'data' in event:
            message_json = base64.b64decode(event['data']).decode('utf-8')
            message_data = json.loads(message_json)

            chat_id = message_data.get('chat_id')
            text = message_data.get('text')
            user = message_data.get('user')

            if chat_id and text and user:
                doc_ref = db.collection('chats').document(chat_id).collection('messages').document()
                doc_ref.set({
                    'text': text,
                    'user': user,
                    'timestamp': firestore.SERVER_TIMESTAMP
                })
    except Exception as e:
        print(f"Error processing message: {e}")
