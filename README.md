# SPOTA - Find Your Vibe

<div align="center">


**The Ultimate Event Discovery & Management Platform for Bahir Dar**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Provider](https://img.shields.io/badge/State-Provider-blue?style=for-the-badge)](https://pub.dev/packages/provider)
[![Chapa](https://img.shields.io/badge/Payments-Chapa-green?style=for-the-badge)](https://chapa.co)

</div>

---

## 📖 About SPOTA

**SPOTA** is a premium, high-performance mobile application designed to revolutionize the event industry in Bahir Dar, Ethiopia. We bridge the gap between vibrant event organizers and enthusiastic attendees through a seamless, digital-first experience.

Whether you're looking for the hottest concerts, professional tech workshops, or cultural festivals, SPOTA is your gateway. For organizers, it's a powerful command center to manage, monetize, and scale your events.

### 🌟 Why SPOTA?

- **Local Focus, Global Quality:** Built specifically for the Ethiopian context with world-class design standards.
- **Instant Booking:** Choose your spot and pay via reliable local gateways like Chapa (Telebirr, CBE, etc.).
- **Real-Time Everything:** Live ticket counts, instant SMS confirmations, and real-time analytics.

---

## ✨ Key Features

### 👤 For Attendees
- **Limitless Discovery:** Browse events by category, date, or popularity.
- **Smart Search:** Find exactly what you want with our optimized search engine.
- **Secure Payments:** Integrated **Chapa** gateway for seamless transactions.
- **Digital Wallet:** "My Tickets" section keeps all your QR codes and booking history.
- **SMS Confirmations:** Get instant verification via **AfroMessage**.

### 🏢 For Organizers
- **Command Center:** Real-time dashboard for sales, revenue, and attendance.
- **Easy Event Creation:** Launch an event in minutes with image uploads via **Cloudinary**.
- **Live Control:** Cancel, edit, or update events instantly.
- **Revenue Tracking:** Watch your earnings grow with detailed financial breakdowns.

### 🛡️ For Administrators
- **Platform Oversight:** Monitor user growth and event quality.
- **User Management:** Robust tools to manage the platform's community.

---

## 🛠 Technology Stack

We use a modern, robust, and scalable stack to ensure the best performance.

| Category | Technology | Usage |
|----------|------------|-------|
| **Frontend** | Flutter (Dart) | Cross-platform UI logic |
| **State Management** | Provider | Efficient data flow & UI updates |
| **Backend** | Firebase | Auth, Firestore (NoSQL), Cloud Functions |
| **Payments** | Chapa API | Secure payment processing |
| **Notifications** | AfroMessage | SMS Gateway integration |
| **Media** | Cloudinary | Optimized image hosting |
| **Architecture** | Feature-based Clean | Scalable project structure |

---

## 🚀 Getting Started

Follow these steps to set up the project locally.

### Prerequisites
- **Flutter SDK:** version 3.0.0 or higher.
- **Firebase Project:** Configured with Auth and Firestore.
- **API Keys:** Chapa, AfroMessage, Cloudinary.

### Installation

1. **Clone the Repo**
   ```bash
   git clone https://github.com/Minas-27/spota-events.git
   cd spota-events
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup Firebase**
   - Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
   - Run `flutterfire configure`.

4. **Run the App**
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

We follow a **Feature-based Clean Architecture**.

```
lib/
├── app/          # App configuration, routes, providers
├── core/         # Constants, theme, utilities
├── features/     # Feature modules (Auth, Booking, Events, etc.)
│   ├── screens/  # UI Pages
│   └── widgets/  # Local Widgets
└── shared/       # Shared services, models, and global widgets
```

For a deep dive, check out [ARCHITECTURE.md](./docs/ARCHITECTURE.md).

---

## 🤝 Application Workflow

1. **User Authentication** (Login/Signup)
2. **Browse Events** (Home/Search)
3. **Select Event** -> **View Details**
4. **Book Ticket** -> **Payment (Chapa)** -> **SMS Confirmation**
5. **View Ticket** (My Tickets)

---

## 👥 Contributors

- **Abraham Addisu**
- **Hailemariam Yohannes**
- **Henok Ashenafi**
- **Esubalew Worku**
- **Birtukan Nigussie**

---

<div align="center">

*Built with ❤️ in Bahir Dar, Ethiopia*

</div>
