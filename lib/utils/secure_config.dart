class SecureConfig {
  // TODO: Replace with your Pocketbase credentials
  static const String pocketBaseUrl = String.fromEnvironment('PB_URL', defaultValue: 'REPLACE_ME');
  static const String pocketBaseAdminEmail = String.fromEnvironment('PB_ADMIN_EMAIL', defaultValue: 'https://example.com');
  static const String pocketBaseAdminPassword = String.fromEnvironment('PB_ADMIN_PASSWORD', defaultValue: 'admin@example.com');
}

