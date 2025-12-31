# Spota Events - Team Work Distribution 🚀

To ensure everyone can contribute smoothly before the submission, we have divided the project into **5 distinct parts**. Each part covers specific screens and features.

---

### 👤 Part 1: Authentication & Onboarding
*Focus: Getting users into the app.*
- **Key Screens:** Login, Signup, Forgot Password, Onboarding.
- **Main Files:** 
  - `lib/features/auth/screens/`
  - `lib/app/providers/auth_provider.dart` (Mock logic)

### 🏠 Part 2: Event Discovery
*Focus: Making events look great.*
- **Key Screens:** Home Screen, Search, Category Filters, Event List.
- **Main Files:** 
  - `lib/features/events/screens/home_screen.dart`
  - `lib/features/events/widgets/event_card.dart`
  - `lib/features/events/screens/search_screen.dart`

### 🎫 Part 3: Booking & Payments
*Focus: The transaction flow (Attendee).*
- **Key Screens:** Event Details, Booking Screen, Payment Selection, My Tickets.
- **Main Files:** 
  - `lib/features/events/screens/event_details_screen.dart`
  - `lib/features/booking/screens/booking_screen.dart`
  - `lib/features/booking/screens/my_tickets_screen.dart`

### 🛠️ Part 4: Organizer Dashboard
*Focus: Managing the business.*
- **Key Screens:** Organizer Home, Manage Events, Create Event, Attendee Lists.
- **Main Files:** 
  - `lib/features/organizer/screens/organizer_dashboard.dart`
  - `lib/features/organizer/screens/create_event_screen.dart`
  - `lib/features/organizer/screens/manage_events_screen.dart`

### ⚙️ Part 5: Profile & Core Components
*Focus: User settings and shared UI.*
- **Key Screens:** Profile, Edit Profile, Notifications, Settings.
- **Main Files:** 
  - `lib/features/profile/screens/`
  - `lib/shared/` (Common buttons, themes, models)

---

**Note:** Since we are using **Mock Data**, you don't need to worry about Firebase! Just focus on the UI and the flow using the existing providers.
