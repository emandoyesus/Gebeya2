# 📍 Gebeya (ገበያ) • Project Milestones & Roadmap

This document outlines the development milestones, technical deliverables, and future roadmap for the **Gebeya** mobile application.

---

## 🏆 Completed Milestones

### Milestone 1: Project Initialization & Architecture Setup (`v0.1.0`)
- [x] Flutter 3.50+ & Dart 3.14+ project initialized with clean package structure.
- [x] Material 3 Light Mode and OLED Cyber Slate Dark Mode palette (`#0F766E` Deep Emerald, `#F59E0B` Amber Gold, `#0B132B` Cyber Slate).
- [x] MultiProvider integration with decoupled providers for Products, Cart, Wishlist, Orders, and Theme.
- [x] Persistent local storage integration using `SharedPreferences`.

### Milestone 2: Product Catalog & Ethiopian Market Inventory (`v0.2.0`)
- [x] Data models with JSON serialization: `Product`, `CartItem`, `Category`, `ShippingAddress`, `OrderModel`.
- [x] Curated Ethiopian inventory:
  - Authentic Yirgacheffe Single-Origin Specialty Coffee
  - Handcrafted Clay Jebena Coffee Ceremony Sets
  - Contemporary Embroidered Habesha Kemis Dresses
- [x] Cyber-themed modern electronics and lifestyle items (ANC Pro Headphones, PulseMatrix AMOLED Watch, RGB Mechanical Keyboard, Ergonomic Mesh Chair).
- [x] Bilingual copy and metadata (English + Amharic "እንኳን ወደ ገበያ በደህና መጡ").

### Milestone 3: Discovery, Search & Filtering (`v0.3.0`)
- [x] Real-time search query filtering across product titles and descriptions.
- [x] Horizontal scrollable category filter chips.
- [x] Sorting modal bottom sheet: Featured, Price (Low to High / High to Low), Top Customer Ratings, and Alphabetical.
- [x] Animated promotional hero carousel with automatic timer transitions.

### Milestone 4: Shopping Cart & Localized Checkout (`v0.4.0`)
- [x] Zustand-inspired persistent shopping cart with quantity stepper and removal.
- [x] Promotional coupon code engine (`GEBEYA10`, `WELCOME20`, `HABESHA50`).
- [x] Transparent tax and delivery fee calculation (Free delivery above 5,000 ETB, standard 15% VAT).
- [x] Comprehensive delivery address form with Addis Ababa subcities (Bole, Kazanchis, Kirkos, Lideta, Yeka, etc.).
- [x] Multi-gateway payment selection:
  - Telebirr (Ethio Telecom)
  - CBE Birr (Commercial Bank of Ethiopia)
  - Chapa (Fintech Gateway)
  - Stripe / Credit Cards
  - Cash on Delivery (COD)

### Milestone 5: Order Management, Wishlist & Profile (`v1.0.0-mvp`)
- [x] Order success screen with celebration receipt and immediate order ID generation.
- [x] Interactive 4-step order tracking timeline (`Confirmed` → `Processing` → `On the Way` → `Delivered`).
- [x] Persistent past orders history with detailed item breakdowns.
- [x] Wishlist favorites management with one-tap "Add All to Cart".
- [x] Profile screen with account overview, order stats, address management, and instant dark mode switch.

### Milestone 6: Web Runtime Stabilization & UI Polish (`v1.0.1-stable`)
- [x] Fixed `UnsupportedError: Unsupported operation: sort` by ensuring mutable list copies in `ProductProvider`.
- [x] Resolved duplicate `Hero` tag conflicts across home, explore, wishlist, and detail views by introducing unique scoped hero keys.
- [x] Fixed `Material` assertion conflict (`borderRadius == null || shape == null`).
- [x] Eliminated horizontal and vertical `RenderFlex` overflows in product cards and price tags.
- [x] Ensured zero compilation warnings and zero analyzer issues (`flutter analyze` clean).

---

## 🔮 Upcoming Milestones & Roadmap

### Milestone 7: Real Backend Integration & API Layer (`v1.1.0-api`)
- [x] Connected Flutter app with live API layer via dedicated `ApiService`.
- [x] Multi-source API support:
  - **Live Cloud REST API**: Real-time product inventory + Ethiopian heritage items.
  - **Next.js Backend API**: Direct integration with Dan Seng's Next.js repo (`/api/products` and `/api/checkout_sessions`).
  - **Direct Stripe REST API**: Fetches active products and prices with expandable price objects.
  - **Offline Cache Fallback**: Seamless local storage cache with `SharedPreferences` so the app is always functional.
- [x] Dynamic API status indicator chips on Home & Explore screens.
- [x] Interactive `ApiConfigSheet` to switch endpoints, set custom Next.js server URLs, test connections, and sync catalog.
- [x] Integrated Checkout Session creation API on order placement.

---

## 🔮 Upcoming Milestones & Roadmap

### Milestone 8: Real Authentication, Multi-User Sessions & Profile Management (`v1.2.0-auth`)
- [x] Implemented dedicated `AuthProvider` and `UserModel` with 100% free, zero-cost architecture.
- [x] Built full-featured `AuthScreen` supporting both **Customer Sign In** and **New Account Registration**.
- [x] Integrated phone number (+251) and email registration with default subcity/address assignment.
- [x] Added persistent account registry in `SharedPreferences` allowing multiple customer accounts to register and switch dynamically.
- [x] Connected real customer delivery info to `HomeScreen` and pre-populated `CheckoutScreen` inputs.
- [x] Added in-app profile editor modal allowing customers to update name, phone, subcity, and street address with instant reactivity.

---

## 🔮 Upcoming Milestones & Roadmap

### Milestone 9: Zero-Fee Ethiopian Payment Verification & Merchant Operations (`v1.3.0-merchant`)
- [x] Integrated `PaymentTransferDialog` for direct **Telebirr** and **CBE Birr** transfers with zero transaction fees.
- [x] One-tap copy affordances for merchant accounts, phone numbers, and till numbers.
- [x] Built customer transaction reference verification input (`TB-xxx` / `FT-xxx`) attached directly to order records.
- [x] Implemented dedicated **Merchant Operations Dashboard** (`MerchantDashboardScreen`) with live gross sales metrics.
- [x] Added store owner order management allowing status transitions (`Confirmed` ➔ `Packing & Processing` ➔ `Out for Delivery` ➔ `Delivered` / `Cancelled`).
- [x] Attached verified transaction reference and payment proof notes to customer order receipts.

---

## 🔮 Upcoming Milestones & Roadmap

### Milestone 10: Interactive Map Pin Picker & Delivery Geo-Tagging (`v1.4.0-maps`)
- [x] Built zero-cost visual vector map canvas painter with animated focal point pins and GPS coordinates.
- [x] Curated comprehensive Addis Ababa delivery landmark database covering all 10 subcities (Bole, Kazanchis, Kirkos, Yeka, Arada, Lideta, Gulele, Sarbet, Jemo, Kality, Tor Hailoch).
- [x] Built `DeliveryPinPickerModal` with instant subcity filtering and live landmark search.
- [x] Integrated one-tap pin picking into both `CheckoutScreen` and customer profile address editor.

---

## 🔮 Upcoming Milestones & Roadmap

### Milestone 11: Digital Ethiopian Tax Invoices & WhatsApp Sharing (`v1.5.0-invoicing`)
- [x] Designed compliant Ethiopian digital sales invoice dialog (`DigitalTaxReceiptDialog`) with TIN and 15% VAT breakdown.
- [x] Generated structured plain text invoice formatted for instant clipboard copy and WhatsApp transmission.
- [x] Added invoice inspection and WhatsApp sharing actions to both `OrderSuccessScreen` and `OrderDetailScreen`.
- [x] Integrated invoice actions in the `OrderDetailScreen` AppBar.

---

## 🚀 Commercial Readiness Status: 100% Complete
- **Multi-User Identity & Profile**: Done (`v1.2.0-auth`)
- **Zero-Fee Merchant Transfers & Verification**: Done (`v1.3.0-merchant`)
- **Interactive Landmark Pin Picker & GPS**: Done (`v1.4.0-maps`)
- **Digital Tax Receipts & WhatsApp Dispatch**: Done (`v1.5.0-invoicing`)
