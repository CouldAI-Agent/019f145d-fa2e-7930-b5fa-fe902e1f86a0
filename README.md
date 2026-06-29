# Flutter Chat

A responsive chat application built with Flutter, designed to work seamlessly across mobile, desktop, and web platforms.

## Features

*   **Responsive Layout**: Uses a master-detail pattern on larger screens (desktop/tablet) and a navigation-based approach on smaller screens (mobile).
*   **Chat List**: Displays a list of conversations with the latest message and timestamp.
*   **Chat Detail**: A detailed view of a specific conversation, showing message history.
*   **Message Input**: Allows users to send new messages within a conversation.
*   **Mock Data**: Includes sample data models for users, conversations, and messages to simulate a real backend.

## Architecture

*   `lib/main.dart`: Contains the main application entry point and the UI components (`ChatApp`, `ChatLayout`, `ChatList`, `ChatDetail`).
*   `lib/models.dart`: Defines the data structures (`User`, `Message`, `Conversation`) and provides mock data for demonstration purposes.

## Getting Started

1.  Ensure you have Flutter installed.
2.  Clone this repository.
3.  Run `flutter pub get` to install dependencies.
4.  Run `flutter run` to launch the app on your preferred device or emulator.

---

## About CouldAI

This application was generated with [CouldAI](https://could.ai), an AI app builder for cross-platform apps that turns prompts into real native iOS, Android, Web, and Desktop apps with autonomous AI agents that architect, build, test, deploy, and iterate production-ready applications.
