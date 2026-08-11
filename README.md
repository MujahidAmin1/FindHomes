# FindHomes - Real Estate Management App 🏡

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![Status](https://img.shields.io/badge/Status-In%20Progress-orange)

FindHomes is a comprehensive real estate management mobile application built with Flutter. It connects clients looking for properties (to buy, rent, or shortlet) with real estate agents who manage and list those properties. 

> **Note:** This project is currently **In Progress**. Some features are actively being developed.

## 🚀 Features

### Implemented Features
- **Authentication & Onboarding**: Secure login, registration, and role-based onboarding (Client vs. Agent).
- **Role-Based Navigation**: Separate dashboards and navigation flows for Clients and Agents.
- **Property Exploration**: View detailed property listings including images (carousel), specifications, agent contact details, and location.
- **Agent Dashboard**: Agents can manage their profile and create new property listings (multi-step form including basic details, price, location, and photos).
- **Payment Integration**: Seamless property payments and checkout flow using the **Paystack SDK**. Includes transaction receipt generation.
- **Real-time Chat**: In-app messaging system allowing clients to communicate directly with agents regarding specific properties.
- **Profile Management**: Users and agents can update their profile information.

### 🚧 Coming Soon
- **Advanced Search & Filtering**: (In Progress) Search properties by location, price range, property type, and more.
- **Favourites / Wishlist**: Save favorite properties for later viewing.
- **Push Notifications**: Real-time alerts for new messages, payment confirmations, and listing updates (via OneSignal).
- **Agent Inquiries Management**: A dedicated interface for agents to manage leads and inquiries efficiently.

## 🛠 Tech Stack & Architecture

- **Framework**: Flutter
- **State Management**: [Riverpod](https://pub.dev/packages/flutter_riverpod)
- **Dependency Injection**: [GetIt](https://pub.dev/packages/get_it)
- **Networking**: [Dio](https://pub.dev/packages/dio) with custom interceptors for auth and logging.
- **Local Storage**: [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage) for tokens.
- **Payments**: [Paystack Flutter SDK](https://pub.dev/packages/paystack_flutter_sdk)
- **Environment Config**: `flutter_dotenv`

### Folder Structure (Feature-First)
The app follows a feature-first architecture to maintain scalability and separation of concerns:
```text
lib/
├── core/               # Shared utilities, theme, widgets, API endpoints, DI locator
├── features/
│   ├── agent dashboard/# Agent-specific views and listing creation logic
│   ├── auth/           # Login, registration, user models
│   ├── chat/           # Messaging system between users and agents
│   ├── favourites/     # (Coming Soon) Saved properties
│   ├── navbar/         # Role-based bottom navigation bars
│   ├── onboarding/     # Initial setup screens for new users
│   ├── payment/        # Paystack integration, checkout, and receipts
│   ├── profile/        # User and agent profile management
│   ├── property/       # Property listing views, details, and models
│   └── search/         # (Coming Soon) Search and filtering logic
└── main.dart           # App entry point
```

## ⚙️ Getting Started

### Prerequisites
- Flutter SDK (>= 3.3.0)
- Dart SDK
- Android Studio / Xcode for emulators

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd find_homes
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Environment Setup**
   Create a `.env` file in the root directory of the project and add your API keys.
   ```env
   # Example .env file
   PAYSTACK_PUBLIC_KEY=pk_test_your_paystack_public_key_here
   ```
   *(Note: Ensure `.env` is added to your `.gitignore`)*

4. **Run the App**
   ```bash
   flutter run
   ```

## 🎨 Design & Theme
The application uses a custom design system defined in `lib/core/theme/`. It features a clean, modern aesthetic with consistent typography (`Lato` for headings, `Roboto` for body text), a curated color palette, and reusable UI components like `AppButton` and `AppTextField`.

## 🤝 Contributing
Contributions, issues, and feature requests are welcome! 
