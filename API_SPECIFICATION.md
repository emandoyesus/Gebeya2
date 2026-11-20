# 🔌 Gebeya Mobile App • API Architecture & Engine

The Gebeya mobile app features an **embedded, self-contained REST API engine** ([`lib/services/local_api_server.dart`](file:///home/emando/Desktop/myProject/Gebeya2/lib/services/local_api_server.dart)) and client service ([`lib/services/api_service.dart`](file:///home/emando/Desktop/myProject/Gebeya2/lib/services/api_service.dart)).

It is **100% self-sufficient** and does **NOT** make any external network requests or connect to any remote repositories.

---

## 🏗️ Architecture

```
┌──────────────────────────────────────────────┐
│                  Flutter UI                  │
│    (HomeScreen, ExploreScreen, Checkout)     │
└──────────────────────┬───────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────┐
│           ProductProvider & Providers        │
└──────────────────────┬───────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────┐
│                 ApiService                   │
│          (Client abstraction layer)          │
└──────────────────────┬───────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────┐
│               LocalApiServer                 │
│      (Self-contained REST API Engine)        │
│                                              │
│  • GET  /api/products                        │
│  • GET  /api/products/:id                    │
│  • GET  /api/categories                      │
│  • POST /api/checkout_sessions               │
│  • POST /api/products                        │
└──────────────────────┬───────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────┐
│        Local Database (SharedPreferences)    │
│       (Persisted products, orders, cart)     │
└──────────────────────────────────────────────┘
```

---

## 📡 API Endpoints Provided

### 1. `GET /api/products`
- **Method:** `ApiService().fetchProducts({String? category, String? search})`
- Returns a list of products with optional category and search query filtering.
- Persisted to local storage database.

### 2. `GET /api/products/:id`
- **Method:** `ApiService().fetchProductById(String id)`
- Retrieves a single product with full specifications, gallery images, colors, and sizes.

### 3. `GET /api/categories`
- **Method:** `ApiService().fetchCategories()`
- Returns all categories with live calculated inventory item counts.

### 4. `POST /api/checkout_sessions`
- **Method:** `ApiService().createCheckoutSession(...)`
- Handles order placement with line items, customer address, payment method (`telebirr`, `cbeBirr`, `chapa`, `stripe`, `cashOnDelivery`), and persists the confirmed order to the local database.

### 5. `POST /api/products`
- **Method:** `ApiService().addProduct(Product product)`
- Adds a new item to the active database catalog and persists it.
