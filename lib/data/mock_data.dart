import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';

class MockData {
  static const List<ProductCategory> categories = [
    ProductCategory(
      id: 'all',
      name: 'All Items',
      nameAmharic: 'ሁሉም',
      icon: Icons.grid_view_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?auto=format&fit=crop&w=400&q=80',
      itemCount: 22,
    ),
    ProductCategory(
      id: 'electronics',
      name: 'Electronics',
      nameAmharic: 'ኤሌክትሮኒክስ',
      icon: Icons.devices_other_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=400&q=80',
      itemCount: 6,
    ),
    ProductCategory(
      id: 'ethiopian_heritage',
      name: 'Ethiopian Goods',
      nameAmharic: 'የሀበሻ ባህላዊ',
      icon: Icons.coffee_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=400&q=80',
      itemCount: 6,
    ),
    ProductCategory(
      id: 'fashion',
      name: 'Fashion & Wear',
      nameAmharic: 'ፋሽንና አልባሳት',
      icon: Icons.checkroom_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?auto=format&fit=crop&w=400&q=80',
      itemCount: 5,
    ),
    ProductCategory(
      id: 'home',
      name: 'Home & Living',
      nameAmharic: 'የቤት ዕቃዎች',
      icon: Icons.chair_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=400&q=80',
      itemCount: 3,
    ),
    ProductCategory(
      id: 'beauty',
      name: 'Beauty & Spices',
      nameAmharic: 'ቅመማቅመም እና ውበት',
      icon: Icons.spa_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=400&q=80',
      itemCount: 2,
    ),
  ];

  static IconData getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'electronics':
        return Icons.devices_other_rounded;
      case 'ethiopian_heritage':
        return Icons.coffee_rounded;
      case 'fashion':
        return Icons.checkroom_rounded;
      case 'home':
        return Icons.chair_rounded;
      case 'beauty':
        return Icons.spa_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }

  static const List<Product> products = [
    Product(
      id: 'gebeya_01',
      name: 'CyberAcoustics ANC Pro Headphones',
      nameAmharic: 'ሳይበር አኮስቲክስ ሄድፎን',
      description:
          'Next-generation active noise-canceling wireless headphones with 45-hour battery life, spatial audio processing, ultra-soft memory foam earcups, and instant multi-device Bluetooth pairing.',
      price: 4950.0,
      originalPrice: 6500.0,
      rating: 4.9,
      reviewCount: 142,
      category: 'electronics',
      isFeatured: true,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1484704849700-f032a568e944?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80',
      ],
      availableColors: ['Midnight Black', 'Platinum Silver', 'Deep Navy'],
      specifications: {
        'Battery Life': '45 Hours',
        'Connectivity': 'Bluetooth 5.3 + 3.5mm Aux',
        'Noise Cancellation': 'Hybrid Active ANC (-38dB)',
        'Weight': '250g',
      },
    ),
    Product(
      id: 'gebeya_02',
      name: 'Authentic Yirgacheffe Single-Origin Specialty Coffee (1KG)',
      nameAmharic: 'የይርጋጨፌ ስፔሻሊቲ ቡና (1 ኪሎ)',
      description:
          'Hand-picked from the highlands of Yirgacheffe, Ethiopia. Celebrated globally for its floral jasmine aroma, bright citrus acidity, and silky chocolate aftertaste. Freshly roasted upon dispatch.',
      price: 1850.0,
      originalPrice: 2200.0,
      rating: 5.0,
      reviewCount: 388,
      category: 'ethiopian_heritage',
      isFeatured: true,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1447933601403-0c6688de566e?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: ['Whole Bean (1kg)', 'Ground Filter (1kg)', 'Espresso Roast (1kg)'],
      specifications: {
        'Origin': 'Yirgacheffe, Gedeo Zone, Ethiopia',
        'Altitude': '1,900 - 2,200 MASL',
        'Roast Level': 'Medium City Roast',
        'Flavor Notes': 'Jasmine, Bergamot, Honey, Dark Chocolate',
      },
    ),
    Product(
      id: 'gebeya_03',
      name: 'Handcrafted Ethiopian Jebena Coffee Ceremony Set',
      nameAmharic: 'የሸክላ ጀበና እና የሲኒ ማቅረቢያ ስብስብ',
      description:
          'Handmade earthenware Jebena clay pot crafted by master Ethiopian potters. Complete with 6 traditional ceramic sini cups and a carved wooden rekebot serving stand.',
      price: 3400.0,
      originalPrice: 4200.0,
      rating: 4.8,
      reviewCount: 94,
      category: 'ethiopian_heritage',
      isFeatured: true,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=800&q=80',
      ],
      availableColors: ['Traditional Black Clay', 'Terracotta Red'],
      specifications: {
        'Material': 'Organic Highland Clay',
        'Includes': '1x Jebena, 6x Cini Cups, 1x Rekebot Stand',
        'Origin': 'Addis Ababa / Gojjam Craft Center',
      },
    ),
    Product(
      id: 'gebeya_04',
      name: 'Modern Habesha Kemis Embroidered Dress',
      nameAmharic: 'ዘመናዊ የሀበሻ የጥልፍ ቀሚስ',
      description:
          'Elegantly woven sheer Ethiopian cotton (Shemma) adorned with vibrant contemporary Tibeb border embroidery. Perfect for special events, holidays, and cultural celebrations.',
      price: 8900.0,
      originalPrice: 11500.0,
      rating: 4.9,
      reviewCount: 76,
      category: 'ethiopian_heritage',
      isFeatured: true,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: ['S', 'M', 'L', 'XL', 'Custom Tailored'],
      availableColors: ['Pure White with Gold Tibeb', 'Ivory with Emerald Green'],
      specifications: {
        'Fabric': '100% Hand-Spun Ethiopian Cotton',
        'Embroidery': 'Artisan Hand-Stitched Tibeb',
        'Care': 'Gentle Hand Wash Only',
      },
    ),
    Product(
      id: 'gebeya_05',
      name: 'PulseMatrix AMOLED Smart Watch Ultra',
      nameAmharic: 'የላቀ ስማርት ሰዓት',
      description:
          'Titanium alloy case, sapphire crystal AMOLED display with always-on technology, ECG and blood oxygen tracking, 14-day battery, and water-resistance up to 50 meters.',
      price: 7200.0,
      originalPrice: 8500.0,
      rating: 4.7,
      reviewCount: 119,
      category: 'electronics',
      isFeatured: false,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80',
      ],
      availableColors: ['Space Gray', 'Starlight Silver', 'Obsidian Black'],
      specifications: {
        'Display': '1.92-inch AMOLED 480x390px',
        'Battery': '500mAh (Up to 14 days)',
        'Sensors': 'SpO2, Heart Rate, Gyro, GPS',
        'Water Resistance': '5 ATM',
      },
    ),
    Product(
      id: 'gebeya_06',
      name: 'CyberDeck Mechanical RGB Keyboard',
      nameAmharic: 'መካኒካል ኪቦርድ',
      description:
          'Hot-swappable tactile mechanical switches with per-key RGB backlighting, aircraft-grade aluminum top frame, sound dampening foam layers, and triple connectivity (BT/2.4G/Type-C).',
      price: 5400.0,
      originalPrice: 6200.0,
      rating: 4.8,
      reviewCount: 65,
      category: 'electronics',
      isFeatured: false,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1595225476474-87563907a212?auto=format&fit=crop&w=800&q=80',
      ],
      availableColors: ['Cyberpunk Neon', 'Matte Black', 'Retro White'],
      specifications: {
        'Switches': 'Gateron Pro Yellow (Pre-lubed)',
        'Layout': '75% Compact (82 Keys)',
        'Keycaps': 'Double-shot PBT Cherry Profile',
      },
    ),
    Product(
      id: 'gebeya_07',
      name: 'AeroGlide Carbon Performance Sneakers',
      nameAmharic: 'ኤሮግላይድ የስፖርት ጫማ',
      description:
          'Engineered for maximum energy return with a full-length carbon fiber propulsion plate, breathable hyper-mesh upper, and ultra-durable continental rubber outsole.',
      price: 6800.0,
      originalPrice: 7900.0,
      rating: 4.8,
      reviewCount: 210,
      category: 'fashion',
      isFeatured: true,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: ['40', '41', '42', '43', '44', '45'],
      availableColors: ['Volt Red', 'Cyber White', 'Triple Black'],
      specifications: {
        'Cushioning': 'SuperCritical Nitrogen Foam',
        'Weight': '198g (Size 42)',
        'Drop': '8mm',
      },
    ),
    Product(
      id: 'gebeya_08',
      name: 'Minimalist Weatherproof Urban Backpack',
      nameAmharic: 'የከተማ ላፕቶፕ ቦርሳ',
      description:
          'Constructed from waterproof recycled Cordura ballistic fabric. Features a dedicated padded 16-inch laptop compartment, hidden security pocket, and ergonomic air-mesh shoulder straps.',
      price: 3600.0,
      originalPrice: 4500.0,
      rating: 4.6,
      reviewCount: 88,
      category: 'fashion',
      isFeatured: false,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?auto=format&fit=crop&w=800&q=80',
      ],
      availableColors: ['Charcoal Gray', 'Olive Green', 'Deep Black'],
      specifications: {
        'Capacity': '22 Liters',
        'Material': 'Recycled Cordura 1000D',
        'Laptop Pocket': 'Up to 16.2 inch MacBook Pro',
      },
    ),
    Product(
      id: 'gebeya_09',
      name: 'ErgoComfort Executive Mesh Desk Chair',
      nameAmharic: 'የቢሮ የወንበር ምርጫ',
      description:
          'Full ergonomic dynamic lumbar support, breathable German elastomeric mesh back, 3D adjustable armrests, and a 135-degree recline mechanism for maximum work productivity.',
      price: 14500.0,
      originalPrice: 17000.0,
      rating: 4.9,
      reviewCount: 42,
      category: 'home',
      isFeatured: false,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1580481077195-c3a821a58875?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1505797149-43b0069ec26b?auto=format&fit=crop&w=800&q=80',
      ],
      availableColors: ['Slate Gray', 'Pure Black'],
      specifications: {
        'Max Weight': '150 KG',
        'Cylinder': 'Class 4 BIFMA Certified Gas Lift',
        'Warranty': '3 Years',
      },
    ),
    Product(
      id: 'gebeya_10',
      name: 'Smart Ultrasonic Ambient Diffuser & Lamp',
      nameAmharic: 'ስማርት የቤት ሽታ ማሰራጫ',
      description:
          'Whisper-quiet ultrasonic mist generator with ambient warm LED lighting, companion smartphone app control, and automatic waterless shut-off.',
      price: 2600.0,
      originalPrice: 3200.0,
      rating: 4.7,
      reviewCount: 53,
      category: 'home',
      isFeatured: false,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1602928321679-560bb453f190?auto=format&fit=crop&w=800&q=80',
      ],
      availableColors: ['Natural Wood', 'Ceramic White'],
      specifications: {
        'Water Tank': '400 ml',
        'Coverage': '300 sq. ft.',
        'Runtime': 'Up to 12 Hours',
      },
    ),
    Product(
      id: 'gebeya_11',
      name: 'Artisan Sidama Bensa Specialty Coffee (1KG)',
      nameAmharic: 'የሲዳማ ቤንሳ ስፔሻሊቲ ቡና (1 ኪሎ)',
      description:
          'Grown at 2,100 meters in the lush Bensa district of Sidama. Natural anaerobic fermentation processing yielding luscious notes of wild blueberries, peach nectar, and delicate caramel.',
      price: 1950.0,
      originalPrice: 2400.0,
      rating: 4.9,
      reviewCount: 164,
      category: 'ethiopian_heritage',
      isFeatured: true,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: ['Whole Bean (1kg)', 'Ground Medium (1kg)', 'Cold Brew Coarse (1kg)'],
      specifications: {
        'Origin': 'Bensa, Sidama Region, Ethiopia',
        'Altitude': '2,050 - 2,200 MASL',
        'Process': 'Natural Anaerobic Sun-Dried',
        'Flavor Notes': 'Wild Berries, Peach, Honeycomb',
      },
    ),
    Product(
      id: 'gebeya_12',
      name: 'Handcrafted Men\'s Ethiopian Tilf Netela Scarf',
      nameAmharic: 'የወንዶች የጥልፍ ነጠላ ሻርፕ',
      description:
          'Finely hand-loomed two-layer Ethiopian Shemma cotton shawl tailored for men with regal geometric gold and black Tilf patterns.',
      price: 2800.0,
      originalPrice: 3500.0,
      rating: 4.8,
      reviewCount: 52,
      category: 'ethiopian_heritage',
      isFeatured: false,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1607522370275-f14206abe5d3?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1520903920243-00d872a2d1c9?auto=format&fit=crop&w=800&q=80',
      ],
      availableColors: ['White with Black & Gold', 'Ivory with Deep Navy'],
      specifications: {
        'Material': '100% Hand-Spun Gonder Cotton',
        'Length': '220 cm x 85 cm',
        'Weaving': 'Traditional Pit Loom Artisan Made',
      },
    ),
    Product(
      id: 'gebeya_13',
      name: 'Traditional Mesob Handwoven Bread Basket',
      nameAmharic: 'ባህላዊ የሳር መሶብ',
      description:
          'Stunning traditional Ethiopian dining basket handcrafted using dyed dried sweetgrass and wheat straw. Serves as authentic decor or centerpiece for injera dining.',
      price: 4500.0,
      originalPrice: 5600.0,
      rating: 4.9,
      reviewCount: 39,
      category: 'ethiopian_heritage',
      isFeatured: false,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1584589167171-541ce45f1eea?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=800&q=80',
      ],
      availableColors: ['Multicolor Heritage Red & Green', 'Earthtone Ochre & Brown'],
      specifications: {
        'Diameter': '45 cm',
        'Height': '65 cm with conical lid',
        'Crafted In': 'Harar / Aksum Artisan Cooperative',
      },
    ),
    Product(
      id: 'gebeya_14',
      name: 'CyberPower 65W GaN Fast Charger & Multi-Cable Kit',
      nameAmharic: 'ፈጣን ቻርጀር እና ኬብል ስብስብ',
      description:
          'Ultra-compact Gallium Nitride (GaN III) fast charger with 2x USB-C and 1x USB-A ports. Powers laptops, tablets, and smartphones simultaneously with universal voltage safety.',
      price: 2200.0,
      originalPrice: 2800.0,
      rating: 4.8,
      reviewCount: 97,
      category: 'electronics',
      isFeatured: false,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1622445262464-84b150777731?auto=format&fit=crop&w=800&q=80',
      ],
      availableColors: ['Midnight Black', 'Glossy White'],
      specifications: {
        'Power Output': '65W Max Power Delivery (PD 3.0)',
        'Ports': '2x USB-C + 1x USB-A',
        'Protections': 'Over-temperature, Over-voltage, Surge Shield',
      },
    ),
    Product(
      id: 'gebeya_15',
      name: 'StudioPro 4K Ultra-HD Streaming Webcam',
      nameAmharic: '4ኬ ዌብካም ለስብሰባ እና ቪዲዮ',
      description:
          'Crystal clear 4K @ 30fps Sony STARVIS CMOS sensor, dual omnidirectional AI noise-cancelling microphones, magnetic privacy shutter, and auto-focus for professional remote work.',
      price: 5800.0,
      originalPrice: 6900.0,
      rating: 4.7,
      reviewCount: 48,
      category: 'electronics',
      isFeatured: false,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1588508065123-287b28e013da?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=800&q=80',
      ],
      specifications: {
        'Resolution': '3840 x 2160 (4K UHD)',
        'Field of View': '90° Wide Angle',
        'Mount': 'Tripod Thread + Monitor Clamp',
      },
    ),
    Product(
      id: 'gebeya_16',
      name: 'Premium Ethiopian Highland Leather Messenger Bag',
      nameAmharic: 'የሀበሻ ቆዳ ላፕቶፕ ቦርሳ',
      description:
          '100% full-grain Ethiopian highland cowhide leather renowned worldwide for softness and tensile strength. Features brass YKK zippers, cotton twill lining, and 15.6-inch laptop pocket.',
      price: 7600.0,
      originalPrice: 9500.0,
      rating: 4.9,
      reviewCount: 83,
      category: 'fashion',
      isFeatured: true,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=800&q=80',
      ],
      availableColors: ['Cognac Vintage Brown', 'Obsidian Black', 'Rustic Tan'],
      specifications: {
        'Leather Type': 'Highland Full-Grain Pull-Up Leather',
        'Dimensions': '40 x 30 x 10 cm',
        'Handmade': 'Mojo Leather Crafts, Addis Ababa',
      },
    ),
    Product(
      id: 'gebeya_17',
      name: 'Urban Oversized Heavyweight Cotton Hoodie',
      nameAmharic: 'ዘመናዊ ኦቨርሳይዝድ ሁዲ',
      description:
          '480 GSM dense French terry cotton with brushed fleece interior. Double-needle drop-shoulder silhouette with kangaroo pocket and ribbed cuffs.',
      price: 3200.0,
      originalPrice: 3900.0,
      rating: 4.8,
      reviewCount: 112,
      category: 'fashion',
      isFeatured: false,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1509967419530-da38b4704bc6?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: ['S', 'M', 'L', 'XL', 'XXL'],
      availableColors: ['Washed Olive', 'Slate Charcoal', 'Cream Beige'],
      specifications: {
        'Weight': '480 GSM Super-Heavyweight',
        'Material': '100% Combed Organic Cotton',
      },
    ),
    Product(
      id: 'gebeya_18',
      name: 'Cast Iron Double-Handled Dutch Oven (5.5L)',
      nameAmharic: 'ከባድ የብረት ድስት',
      description:
          'Heavy-gauge enameled cast iron delivering exceptional heat distribution and retention. Perfect for slow-cooking Ethiopian doro wat, stews, braises, and artisan sourdough baking.',
      price: 6400.0,
      originalPrice: 7800.0,
      rating: 4.9,
      reviewCount: 47,
      category: 'home',
      isFeatured: false,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1585837575652-267c041d77d4?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1584990347449-3a31c5905d41?auto=format&fit=crop&w=800&q=80',
      ],
      availableColors: ['Emerald Teal', 'Fiery Orange', 'Matte Black'],
      specifications: {
        'Capacity': '5.5 Liters',
        'Heat Resistance': 'Oven safe up to 260°C / 500°F',
        'Compatibility': 'Induction, Gas, Electric, Oven',
      },
    ),
    Product(
      id: 'gebeya_19',
      name: 'Pure Organic Ethiopian Korarima & Berbere Spice Box',
      nameAmharic: 'የኦርጋኒክ በረበረ እና የኮረሪማ ቅመም ስብስብ',
      description:
          'Freshly sun-dried and stone-milled Ethiopian spices from Keffa and Gedeo forests. Includes authentic sun-cured Berbere (500g), Black Cardamom Korarima (250g), and Mekelesha finishing blend (150g).',
      price: 1650.0,
      originalPrice: 2100.0,
      rating: 5.0,
      reviewCount: 178,
      category: 'beauty',
      isFeatured: true,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1509358271058-acd22cc93898?auto=format&fit=crop&w=800&q=80',
      ],
      specifications: {
        'Contents': '500g Berbere + 250g Korarima + 150g Mekelesha',
        'Purity': '100% Organic, Preservative-Free',
        'Shelf Life': '18 Months',
      },
    ),
    Product(
      id: 'gebeya_20',
      name: 'Cold-Pressed Ethiopian Black Seed (Habba Sawda) Oil',
      nameAmharic: 'የጥቁር አዝሙድ ዘይት (ሀበሰውዳ)',
      description:
          '100% virgin cold-pressed Nigella Sativa oil from pristine Ethiopian farms with verified 3.2% thymoquinone concentration. Revered for immune defense, hair nourishment, and skin vitality.',
      price: 1400.0,
      originalPrice: 1750.0,
      rating: 4.9,
      reviewCount: 220,
      category: 'beauty',
      isFeatured: false,
      inStock: true,
      imageUrls: [
        'https://images.unsplash.com/photo-1608248597359-0d3c0157929d?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: ['250ml Amber Glass', '500ml Bottle'],
      specifications: {
        'Botanical': 'Nigella Sativa (Ethiopian Black Cumin)',
        'Extraction': 'Extra Virgin First Cold Press',
        'Thymoquinone': '> 3.0%',
      },
    ),
  ];
}
