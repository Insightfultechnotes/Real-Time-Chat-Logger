1. **Create a GCP Project**

```bash
gcloud projects create chat-logger --set-as-default


2. Enable Required APIs

gcloud services enable pubsub.googleapis.com
gcloud services enable firestore.googleapis.com
gcloud services enable cloudfunctions.googleapis.com


3. Set Up Firestore
	a. Go to the Firestore section in Google Cloud Console.

	b. Click Create Database.

	c. Choose Production Mode and select a region.

4. Create a Pub/Sub Topic

	gcloud pubsub topics create chat-messages

5. Cloud Function Setup ---main.py

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

B. Create requirements.txt

	google-cloud-firestore

6. Deploy the Cloud Function

	gcloud functions deploy pubsub_to_firestore \
  	--runtime python310 \
  	--trigger-topic chat-messages \
  	--entry-point pubsub_to_firestore \
  	--region YOUR_REGION \
  	--source ./chat-logger-function \
  	--memory 128MB \
  	--timeout 60s

🧪 Testing
✅ Publish a Message

gcloud pubsub topics publish chat-messages \
  --message '{"chat_id": "chat123", "text": "Hello world!", "user": "Alice"}'

✅ Check Firestore
Open Firestore in GCP Console.

Navigate to:

chats → chat123 → messages

You should see documents with fields: text, user, timestamp

✅ Check Logs

gcloud functions logs read pubsub_to_firestore --limit 10

You should see confirmation logs or error messages if any issues occurred.

❌ Negative Test (Invalid Payload)

gcloud pubsub topics publish chat-messages \
  --message '{"text": "Missing user and chat_id"}'
The function should not crash.

Check logs for graceful error handling.

🧼 Cleanup

gcloud functions delete pubsub_to_firestore --region YOUR_REGION
gcloud pubsub topics delete chat-messages
To delete the Firestore database, you must do it via the GCP Console.


