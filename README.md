# 📡 Real-Time Chat Logger (GCP)

A serverless project that captures real-time chat messages using Google Cloud Pub/Sub, processes them with Cloud Functions, and stores them in Firestore for live access and logging.

---

## 🎯 Project Overview

This project simulates a backend system that:
1. Publishes chat messages to a Pub/Sub topic.
2. Triggers a Cloud Function to process the messages.
3. Logs each message in Firestore under the corresponding chat thread.

---

## 🛠️ Tech Stack

- **Google Cloud Pub/Sub** – Real-time messaging system
- **Cloud Functions** – Serverless message processor
- **Firestore** – NoSQL document database for logging chat history

---

## 📁 Project Structure

chat-logger-function/
│
├── main.py # Cloud Function logic
├── requirements.txt # Dependencies
└── README.md # Project guide

