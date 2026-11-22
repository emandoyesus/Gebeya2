import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gebeya/main.dart';
import 'package:gebeya/providers/auth_provider.dart';
import 'package:gebeya/providers/cart_provider.dart';
import 'package:gebeya/providers/order_provider.dart';
import 'package:gebeya/providers/product_provider.dart';
import 'package:gebeya/providers/theme_provider.dart';
import 'package:gebeya/providers/wishlist_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Gebeya app smoke test - launches and renders home navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
        ],
        child: const GebeyaApp(),
      ),
    );

    // Initial pump and settle
    await tester.pumpAndSettle();

    // Verify Gebeya branding is visible
    expect(find.text('Gebeya'), findsOneWidget);
    expect(find.text('ገበያ'), findsWidgets);

    // Verify Navigation Bar items (Home, Cart, Wishlist, Sign In)
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Wishlist'), findsOneWidget);
    // When user has no account, nav tab displays 'Sign In'
    expect(find.text('Sign In'), findsOneWidget);

    // Verify categories rendered
    expect(find.text('Categories'), findsOneWidget);
  });
}
