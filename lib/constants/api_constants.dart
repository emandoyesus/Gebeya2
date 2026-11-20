/// API Configuration Constants
///
/// Configure your custom backend endpoint and credentials here or via environment variables.
/// The mobile app will not call any external or remote services by default until you enable them.
class ApiConstants {
  /// Base URL of your backend API server (e.g., http://localhost:3000 or your custom domain)
  /// Set this to your own running backend instance.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// Products endpoint relative to baseUrl
  static const String productsEndpoint = '/api/products';

  /// Single product endpoint relative to baseUrl (append id)
  static const String productDetailEndpoint = '/api/products/';

  /// Categories endpoint relative to baseUrl
  static const String categoriesEndpoint = '/api/categories';

  /// Checkout session creation endpoint relative to baseUrl
  static const String checkoutEndpoint = '/api/checkout_sessions';

  /// Optional Auth token or API key for protected routes
  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );

  /// Toggle whether the app should make network calls or run purely locally with mock data
  /// Set to true when you want to connect to your live backend.
  static const bool useLiveApi = bool.fromEnvironment(
    'USE_LIVE_API',
    defaultValue: false,
  );
}
