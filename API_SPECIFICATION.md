# 🔌 Gebeya Mobile App • API Specification & Integration Contract

This document outlines **exactly what endpoints, JSON structures, and request formats** the Gebeya Flutter mobile app expects from your backend.

The mobile app is completely decoupled and currently runs in offline/local mode until you configure the base URL.

---

## ⚙️ How to Configure the App to Your Backend

Edit [`lib/constants/api_constants.dart`](file:///home/emando/Desktop/myProject/Gebeya2/lib/constants/api_constants.dart):

```dart
class ApiConstants {
  // Set this to your running server (e.g., http://localhost:3000, http://10.0.2.2:3000, or https://api.yourdomain.com)
  static const String baseUrl = 'http://localhost:3000';

  // Toggle to true when your server is running and ready
  static const bool useLiveApi = false; 

  // Optional: Bearer token or API key if your routes are protected
  static const String apiKey = '';
}
```

Or pass them during build/run time without changing code:
```bash
flutter run --dart-define=API_BASE_URL=http://localhost:3000 --dart-define=USE_LIVE_API=true
```

---

## 📡 Endpoints Required by the App

### 1. Products List
- **Method:** `GET`
- **Route:** `/api/products`
- **Query Parameters (Optional):** `?category=electronics&search=coffee`
- **Headers:** `Accept: application/json`

#### Expected JSON Response Format:
Can be returned either as a direct JSON array:
```json
[
  {
    "id": "prod_01",
    "name": "CyberAcoustics ANC Pro Headphones",
    "nameAmharic": "ሳይበር አኮስቲክስ ሄድፎን",
    "description": "Active noise-canceling wireless headphones...",
    "price": 4950.0,
    "originalPrice": 6500.0,
    "rating": 4.9,
    "reviewCount": 142,
    "category": "electronics",
    "inStock": true,
    "isFeatured": true,
    "imageUrls": [
      "https://example.com/image1.jpg",
      "https://example.com/image2.jpg"
    ],
    "availableColors": ["Black", "Silver"],
    "availableSizes": ["M", "L"],
    "specifications": {
      "Battery": "45 Hours",
      "Connectivity": "Bluetooth 5.3"
    }
  }
]
```
*(Alternatively, `{ "products": [ ... ] }` or `{ "data": [ ... ] }` are also accepted automatically by the app parser).*

#### Field Definitions:
| Field | Type | Required | Description |
|---|---|---|---|
| `id` | String | Yes | Unique product identifier |
| `name` | String | Yes | Display name in English |
| `nameAmharic`| String | No | Bilingual Amharic title |
| `description`| String | Yes | Product details and description |
| `price` | Double | Yes | Price (numeric) |
| `originalPrice`| Double | No | Strike-through price for discounts |
| `rating` | Double | No | Customer review average (e.g. 4.8) |
| `reviewCount`| Int | No | Total count of reviews |
| `category` | String | Yes | `electronics`, `ethiopian_heritage`, `fashion`, `home` |
| `inStock` | Bool | No | Default `true` |
| `isFeatured` | Bool | No | Shows in the top hero deal carousel if `true` |
| `imageUrls` | List<String> | Yes | Array of image URLs |
| `availableColors` | List<String> | No | Color variations |
| `availableSizes` | List<String> | No | Size options (`S`, `M`, `L`, `XL`, etc.) |
| `specifications` | Map<String, String> | No | Key-value pairs for technical specs |

---

### 2. Categories (Optional)
- **Method:** `GET`
- **Route:** `/api/categories`

#### Expected JSON Response Format:
```json
[
  {
    "id": "electronics",
    "name": "Electronics",
    "nameAmharic": "ኤሌክትሮኒክስ",
    "imageUrl": "https://example.com/electronics.jpg",
    "itemCount": 12
  },
  {
    "id": "ethiopian_heritage",
    "name": "Ethiopian Goods",
    "nameAmharic": "የሀበሻ ባህላዊ",
    "imageUrl": "https://example.com/heritage.jpg",
    "itemCount": 6
  }
]
```

---

### 3. Checkout / Create Order Session
- **Method:** `POST`
- **Route:** `/api/checkout_sessions`
- **Headers:** `Content-Type: application/json`

#### Request Payload sent by the Flutter app:
```json
{
  "items": [
    {
      "productId": "prod_01",
      "name": "CyberAcoustics ANC Pro Headphones",
      "quantity": 2,
      "price": 4950.0,
      "selectedColor": "Midnight Black",
      "selectedSize": null
    }
  ],
  "customer": {
    "fullName": "Abebe Kebede",
    "phoneNumber": "+251 91 123 4567",
    "streetAddress": "Bole Medhanialem, Olympia St.",
    "subcity": "Bole",
    "city": "Addis Ababa"
  },
  "paymentMethod": "telebirr", 
  "total": 9900.0
}
```
*`paymentMethod` will be one of:* `telebirr`, `cbeBirr`, `chapa`, `stripe`, `cashOnDelivery`.

#### Expected Response Format:
```json
{
  "success": true,
  "orderId": "ORD-2026-9812",
  "paymentUrl": null,
  "message": "Order placed successfully"
}
```
*(If your payment gateway provides a checkout redirect webview URL like Chapa or Stripe, return it in `paymentUrl` or `url`).*
