# 🎯 SPOTA - Event Discovery App

<div align="center">

**Discover Your Spot in Bahir Dar's Event Scene**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Provider](https://img.shields.io/badge/Provider-blue.svg)](https://pub.dev/packages/provider)

</div>

##  About SPOTA
SPOTA is a premium Flutter-based mobile application designed to revitalize the event ecosystem in Bahir Dar, Ethiopia. It bridges the gap between event organizers and attendees by providing a seamless platform for event discovery, secure ticket booking, and real-time notifications.

**Tagline:** *"Find Your Vibe in Bahir Dar"*

---

## ✨ Key Features

### 🎫 For Attendees
- **Event Discovery:** Browse through curated categories like Music, Tech, Cultural, and University events.
- **Seamless Search:** Find exactly what you're looking for with real-time search and category filtering.
- **Secure Booking:** Book tickets immediately with integrated payment processing.
- **My Tickets:** Access all your booked tickets and booking history in one place.
- **Notifications:** Receive real-time updates and SMS confirmations for your bookings.

### 🏢 For Organizers
- **Event Management Dashboard:** A dedicated space to manage your events, track sales, and monitor revenue.
- **Real-time Analytics:** View total tickets sold, revenue generated, and event popularity at a glance.
- **Easy Creation:** Quickly create and list new events with image uploads via Cloudinary.
- **Status Control:** Activate or cancel events with immediate synchronization across the platform.

### 🛡️ For Administrators
- **User Management:** Oversee all users, including attendees and organizers.
- **Platform Oversight:** Monitor all platform activities and statistics from a central dashboard.
- **Security:** Robust role-based access control to ensure platform integrity.

---

## 🛠 Tech Stack

- **Frontend:** Flutter (v3.0+)
- **State Management:** Provider & Riverpod (for complex data streams)
- **Backend-as-a-Service:** Firebase
  - **Authentication:** Email/Password & Secure Role Management
  - **Firestore:** Real-time NoSQL database for events, bookings, and user data
  - **Cloud Storage:** Storage for assets and media
- **External Integrations:**
  - **Payments:** Chapa API (Secure Ethiopian payment gateway)
  - **SMS Gateway:** AfroMessage (Instant SMS booking confirmations)
  - **Media Management:** Cloudinary (Dynamic image hosting and optimization)

---

## 📁 Project Architecture

The project follows a **Feature-based Clean Architecture** for scalability and maintainability:

- `lib/app/`: Central app configuration, routing, and global providers.
- `lib/features/`: Functional modules organized by feature (Auth, Events, Booking, Organizer, Admin, Profile).
- `lib/shared/`: Reusable components, common models, and core services.
- `lib/core/`: Application-wide constants, themes, and utilities.

For a deeper dive into the architecture, see [ARCHITECTURE.md](./docs/ARCHITECTURE.md).

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Firebase Account
- Chapa & AfroMessage API Keys (for production features)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Minas-27/spota-events.git
   cd spota-events
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Place your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the appropriate directories.
   - Run `flutterfire configure` to update specialized configurations.

4. **Run the application**
   ```bash
   flutter run
   ```

---

## 👨‍💻 Team Members

- **Abraham Addisu** ([@Minas-27](https://github.com/Minas-27))
- **Hailemariam Yohannes** ([@halazYoha](https://github.com/halazYoha))
- **Henok Ashenafi** ([@henokashenafi](https://github.com/henokashenafi))
- **Esubalew Worku** ([@esubaleww](https://github.com/esubaleww))
- **Birtukan Nigussie** ([@yemariamnegn](https://github.com/yemariamnegn))

---

<div align="center">

**Built with ❤️ in Bahir Dar, Ethiopia**

</div>
