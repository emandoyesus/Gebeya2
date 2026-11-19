# Gebeya (ገበያ) • E-Commerce Mobile App

[![Flutter](https://img.shields.io/badge/Flutter-3.50.0-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.14.0-0175C2?logo=dart)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Provider%20%2B%20Clean%20State-0F766E)](https://pub.dev/packages/provider)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Linux-emerald)](https://flutter.dev)

A modern full-stack e-commerce mobile application built with **Flutter**, inspired by and ported from the Next.js full-stack repository [dan-seng/fullstack-nextjs-ecommerce-app](https://github.com/dan-seng/fullstack-nextjs-ecommerce-app).

Gebeya (**"ገበያ"** - Market in Amharic) blends Ethiopian cultural heritage (authentic highland specialty coffee, traditional Habesha wear, clay Jebena sets) with cyber-themed modern tech gadgets (ANC headphones, AMOLED smartwatches, mechanical keyboards), delivered through a sleek Material 3 mobile experience.

---

## 🌟 Key Features

### 🛒 Product Catalog & Discovery
* **Curated Collections**: Browse across Electronics, Ethiopian Heritage Goods, Modern Streetwear, and Home & Living.
* **Hero Carousel**: Promotional banners celebrating *"እንኳን ወደ ገበያ በደህና መጡ"* (Welcome to Gebeya) with instant category deep-links.
* **Instant Search & Multi-Criteria Filtering**: Real-time keyword filtering across English and Amharic titles, descriptions, and categories.
* **Smart Sorting**: Sort by Featured & Popular, Price (Low to High / High to Low), Top Customer Ratings, and Alphabetical order.

### 🔍 Interactive Product Details
* **Multi-Image Showcase**: Dynamic hero transition (`Hero`) with interactive thumbnail switcher.
* **Interactive Variant Selectors**: Switch between colorways and package sizes (e.g., Whole Bean, Ground Filter, Espresso).
* **Detailed Specifications & Customer Reviews**: Tabular product breakdown and customer ratings.
* **Related Recommendations**: Contextual "You might also like" horizontal product carousel.

### 🛍️ Persistent Shopping Cart (Inspired by Zustand)
* **Local State Persistence**: Automatic state synchronization to `SharedPreferences` (survives app restarts).
* **Quantity Controls**: Instant increment, decrement, and item removal.
* **Dynamic Promo Code Engine**:
  * `GEBEYA10`: 10% instant discount
  * `WELCOME20`: 20% instant discount
  * `HABESHA50`: 50 ETB flat discount
* **Transparent Cost Breakdown**: Real-time calculation of Subtotal, Applied Discount, Delivery Fee (Free above 5,000 ETB), and VAT (15%).

### 💳 Ethiopian & International Checkout Flow
* **Shipping Address Form**: Pre-filled with Ethiopian locations (Addis Ababa subcities: Bole, Kazanchis, Kirkos, Lideta, Yeka, etc.) with field validation.
* **Delivery Speed Selection**: Standard Delivery (1-2 Days) or Same-Day Express Dispatch.
* **Localized & Global Payment Gateways**:
  * 📱 **Telebirr** (Ethio Telecom Mobile Money)
  * 🏦 **CBE Birr** (Commercial Bank of Ethiopia)
  * ⚡ **Chapa** (Fintech Gateway: Cards & Wallets)
  * 💳 **Credit / Debit Cards (Stripe)** (matching the Next.js reference app)
  * 🤝 **Cash on Delivery (COD)**

### 📦 Order Confirmation & Tracking
* **Celebration Screen**: Order confirmation receipt with order ID, date, payment method, and total paid.
* **Live Stepper Tracking**: Visual 4-step delivery pipeline (`Confirmed` → `Processing` → `On the Way` → `Delivered`).
* **Order History**: Comprehensive past orders log stored on-device.

### ❤️ Wishlist & Favorites
* Instant heart toggle on any product card or details page.
* "Add All to Cart" action for quick conversion.

### 🎨 Theme & Accessibility
* **Theme Modes**: Seamless toggling between **Clean Light Mode** and **Cyber OLED Slate Dark Mode** (`0xFF0B132B`).
* **Bilingual Ready**: English and Amharic typography and product metadata.

---

## 🏛️ Project Architecture

```
lib/
├── main.dart                          # App entry point, MultiProvider configuration
├── constants/
│   ├── app_colors.dart                # Emerald Teal, Cyber Amber & Dark Slate palette
│   └── app_theme.dart                 # Material 3 light & dark theme definitions
├── models/
│   ├── product.dart                   # Product data model with discount computations
│   ├── cart_item.dart                 # Cart item model with variants & composite ID
│   ├── category.dart                  # Product category definitions
│   ├── shipping_address.dart          # Delivery address entity with subcities
│   └── order.dart                     # Order entity with payment & status enums
├── providers/
│   ├── theme_provider.dart            # Theme mode state & SharedPreferences persistence
│   ├── product_provider.dart          # Product state, category filtering, search & sort
│   ├── cart_provider.dart             # Zustand-like cart store, coupons & tax calculations
│   ├── wishlist_provider.dart         # Favorites persistence & management
│   └── order_provider.dart            # Order creation, history & tracking persistence
├── data/
│   └── mock_data.dart                 # Realistic curated Ethiopian & tech inventory
├── screens/
│   ├── main_shell.dart                # Persistent BottomNavigationBar scaffold with badges
│   ├── home/
│   │   ├── home_screen.dart           # Home view with hero banner, categories, & grids
│   │   └── widgets/
│   │       ├── hero_banner.dart       # Auto-scrolling animated promo banner
│   │       └── category_chips.dart    # Horizontal scrollable category filters
│   ├── explore/
│   │   └── explore_screen.dart        # Search, sort bottom sheet, and result grid
│   ├── details/
│   │   └── product_detail_screen.dart # Image gallery, variants, specs, and add-to-cart
│   ├── cart/
│   │   └── cart_screen.dart           # Cart items, promo code box, cost summary
│   ├── checkout/
│   │   ├── checkout_screen.dart       # Multi-step address, delivery, & payment selector
│   │   └── order_success_screen.dart  # Post-purchase receipt & celebratory UI
│   └── profile/
│       ├── profile_screen.dart        # User account, stats, address, and theme toggle
│       ├── order_history_screen.dart  # List of past orders
│       └── order_detail_screen.dart   # Interactive status stepper & full receipt
└── widgets/
    ├── app_image.dart                 # Robust network image loader with placeholders
    ├── price_tag.dart                 # Standardized currency formatting & strikethrough
    ├── product_card.dart              # Reusable product card with hero & wishlist toggle
    └── empty_state_widget.dart        # Illustrated empty states with CTA buttons
```

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (3.24.0 or higher)
* Dart SDK (3.5.0 or higher)
* Android Studio / VS Code with Flutter extension
* Android Emulator or connected physical device

### Installation
1. Clone the repository or navigate to the project directory:
   ```bash
   cd Gebeya2
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

---

## 🔄 Mapping: Next.js Reference App vs Flutter Mobile

| Next.js App (`dan-seng/fullstack-nextjs-ecommerce-app`) | Flutter Mobile App (`Gebeya`) |
| :--- | :--- |
| **Zustand Cart Store** (`store/cart-store.ts`) | **CartProvider** (`lib/providers/cart_provider.dart`) with `SharedPreferences` persistence |
| **App Router** (`app/page.tsx`, `app/products/`) | **MainShell** & Navigator with bottom nav bar |
| **Product Card** (`components/product-card.tsx`) | **ProductCard** (`lib/widgets/product_card.dart`) with hero image & quick actions |
| **Tailwind CSS + Dark Mode** | **AppTheme** (`lib/constants/app_theme.dart`) Material 3 light/dark slate |
| **Stripe Checkout Flow** (`app/checkout/page.tsx`) | **CheckoutScreen** supporting Stripe, Telebirr, CBE Birr, Chapa, & COD |
| **Headline** ("እንኳን ወደ ገበያ በደህና መጡ") | Integrated in **HeroBanner** and top navigation bar |

---

## 📄 License
MIT License. Inspired by [dan-seng/fullstack-nextjs-ecommerce-app](https://github.com/dan-seng/fullstack-nextjs-ecommerce-app).
