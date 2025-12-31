# 🏗️ SPOTA Architecture Overview

SPOTA is built using a **Feature-based Clean Architecture** to ensure the codebase remains maintainable, testable, and scalable as the project grows.

---

## 📂 Directory Structure

The `lib/` directory is organized into four main layers:

### 1. `app/` (Application Layer)
- **Purpose:** Contains application-wide configurations that tie the layers together.
- **Key Files:**
  - `app.dart`: The main application widget and theme configuration.
  - `providers/`: Global state management providers (e.g., `AuthProvider`).
  - `routes/`: Centralized route definitions.

### 2. `features/` (Feature Layer)
- **Purpose:** This is where the core business logic and UI reside, organized by functional module.
- **Structure:** Each feature (e.g., `auth`, `events`, `organizer`) contains its own:
  - `screens/`: UI pages.
  - `widgets/`: Feature-specific reusable UI components.
- **Key Features:**
  - `auth/`: Login, Registration, and Password Recovery.
  - `events/`: Event listing, search, and details.
  - `booking/`: Ticket purchasing workflow and ticket management.
  - `organizer/`: Event creation and analytics for event owners.
  - `admin/`: Platform-wide oversight and user management.

### 3. `shared/` (Shared/Data Layer)
- **Purpose:** Reusable components, models, and services used across multiple features.
- **Components:**
  - `models/`: Data classes (e.g., `Event`, `UserModel`, `Booking`).
  - `services/`: Business logic and external API communication (e.g., `EventService`, `AuthService`, `ChapaService`).
  - `widgets/`: Global common UI components (e.g., buttons, inputs).

### 4. `core/` (Core Layer)
- **Purpose:** Low-level configurations and utilities.
- **Components:**
  - `constants/`: Configuration keys, endpoint URLs, and fixed strings.
  - `theme/`: Global styling, color palettes, and typography.
  - `utils/`: Common utility functions (e.g., date formatting, validation).

---

## 🔄 Data Flow

1. **User Interaction:** The user interacts with a `Screen` or `Widget` in the `features/` layer.
2. **State Management:** The UI triggers a method in a `Provider` (Application layer).
3. **Business Logic:** The `Provider` calls a `Service` in the `shared/` layer.
4. **External API:** The `Service` communicates with **Firebase** (Firestore, Auth) or external APIs (**Chapa**, **AfroMessage**, **Cloudinary**).
5. **Data Processing:** The `Service` maps raw response data into `Models` (Shared layer).
6. **UI Update:** The `Provider` notifies listeners, and the UI rebuilds with the new data.

---

## 🛠 State Management Patterns

- **Provider:** Used for most reactive state management (Auth state, UI state).
- **Streams:** Heavily utilized for real-time data from Firestore (e.g., `getEventsStream()`), allowing the UI to update automatically when data changes in the cloud.

---

## 🔒 Security & Roles

SPOTA implements a robust Role-Based Access Control (RBAC) system:
- **Attendees:** Can browse and book events.
- **Organizers:** Can create and manage their own events.
- **Administrators:** Can manage users and view platform analytics.

Permissions are enforced at both the UI level (conditional navigation) and the Backend level (Firestore Security Rules).
