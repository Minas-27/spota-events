# ✨ SPOTA Features Specification

This document outlines the detailed functional requirements and workflows for each user role within the SPOTA ecosystem.

---

## 🎫 1. Attendee (General User)

**Goal:** Discover events and book tickets seamlessly.

### A. Authentication
- **Sign Up/Login:** Email and Password authentication via Firebase.
- **Profile Setup:** Add name, phone number, and profile picture.

### B. Discovery (Home & Search)
- **Featured Events:** Carousel of high-priority or trending events.
- **Category Browsing:** Filter by Music, Tech, Art, Business, etc.
- **Search:** Real-time search by event title.
- **Event Details:** 
    - High-res cover image.
    - Date, Time, Location.
    - Price and "Tickets Left" counter.
    - Organizer info.

### C. Booking System
- **Ticket Selection:** Incremental counter to select quantity.
- **Payment Integration (Chapa):**
    - Users are redirected to a secure payment webview.
    - Supported methods: Telebirr, CBE Birr, Amole, Credit Cards.
- **Confirmation:**
    - Instant "Success" screen.
    - SMS sent to registered phone number.
    - Ticket generated in "My Tickets".

### D. My Tickets
- List of all upcoming and past bookings.
- QR Code generation for check-in (future implementation).
- Ability to view transaction details.

---

## 🏢 2. Organizer

**Goal:** Create, manage, and monetize events.

### A. Dashboard
- **Quick Stats:** Total Events, Tickets Sold, Total Revenue.
- **Performance Graphs:** Visual representation of sales trends.

### B. Event Management
- **Create Event:**
    - Upload Cover Image (Cloudinary).
    - Set Title, Description, Date, Time, Location.
    - Set Ticket Price and Capacity.
    - Select Category.
- **Edit Event:** Update details for upcoming events.
- **Cancel Event:** capability to cancel; updates status for all users.

### C. Analytics
- View detailed attendee list for each event.
- Track revenue per event.

---

## 🛡️ 3. Administrator

**Goal:** Platform oversight and governance.

### A. User Management
- View list of all registered users.
- Filter by role (Attendee vs. Organizer).

### B. Platform Health
- Monitor global ticket sales and active events.
- Ensure content guidelines are met.

---

## 🔧 Technical Feature Highlights

### 📡 Real-Time Data (Firestore)
- **Live Sync:** When an organizer updates an event, all attendees see the change instantly without refreshing.
- **Inventory Management:** Ticket counts decrement in real-time to prevent overbooking.

### 💳 Payments (Chapa)
- **Secure Handling:** Sensitive payment data is handled by Chapa's secure hosted pages.
- **Transaction Refs:** Unique transaction references (`tx_ref`) are generated for every booking for auditing.

### 💬 Notifications (AfroMessage)
- **SMS Gateway:** Direct integration to send reliable SMS confirmations to Ethiopian phone numbers.
- **Templates:** "Dear [Name], your booking for [Event] is confirmed. Ref: [ID]."

### ☁️ Media (Cloudinary)
- **Optimization:** Images are automatically resized and optimized for mobile performance.
- **Fast Delivery:** CDN delivery ensures images load quickly even on slower networks.
