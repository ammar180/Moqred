# Moqred - Transaction Management App

A comprehensive Flutter-based transaction management application designed for tracking loans, payments, and financial transactions with Arabic language support.

## 📱 Overview

Moqred is a transaction-based application that helps users manage financial relationships, track loans, payments, and donations. The app features a clean, modern UI with full Arabic language support and provides both local SQLite storage and cloud synchronization capabilities.

## 🏗️ Architecture

### Technology Stack
- **Framework**: Flutter 3.0+
- **Language**: Dart
- **Local Database**: SQLite (sqflite)
- **Cloud Backend**: PocketBase
- **State Management**: Provider
- **Navigation**: GoRouter
- **UI Components**: Custom FlutterFlow components

### Project Structure
```
lib/
├── auth/                    # Authentication modules
├── backend/
│   ├── db_requests/         # Database operations
│   ├── remote/             # Cloud service integration
│   ├── schema/             # Data models and DTOs
│   └── sync/               # Data synchronization
├── components/             # Reusable UI components
├── flutter_flow/           # Custom UI framework
├── pages/                  # Main application screens
└── utils/                  # Utility functions and themes
```

## 🎯 Core Features

### 1. Transaction Management
- **Transaction Types**:
  - **قرض (Loan)**: Money lent out (negative balance)
  - **سداد (Payment)**: Loan repayment (positive balance)
  - **ملئ (Filling)**: Account top-up (positive balance)
  - **تبرع (Donation)**: Donations received (positive balance)

- **Transaction Validation**:
  - Loan validation ensures sufficient balance
  - Payment validation prevents overpayment
  - Real-time balance calculations

### 2. Person Management
- **Person Profiles**: Name, phone, bio, and relationships
- **Relationship Tracking**: Link persons to other persons
- **Transaction History**: Complete transaction log per person
- **Loan Overview**: Track outstanding loans and payments

### 3. Financial Dashboard
- **Balance Overview**: Real-time total balance calculation
- **Transaction Summary**: Income vs. outgoing transactions
- **Person Overview**: List of persons with outstanding loans
- **Data Visualization**: Paginated data tables with sorting

### 4. Data Synchronization
- **Local Storage**: SQLite database for offline functionality
- **Cloud Backup**: PocketBase integration for data backup
- **Sync Management**: Bidirectional sync with conflict resolution
- **Data Integrity**: Transaction-based operations ensure consistency

## 📊 Database Schema

### Core Tables

#### `persons`
- `id`: Unique identifier
- `name`: Person's name (required)
- `phone`: Contact number
- `bio`: Personal description
- `relatedTo`: Reference to another person
- `created/updated`: Timestamps

#### `transaction_types`
- `id`: Unique identifier
- `name`: Display name (e.g., "قرض", "سداد")
- `type`: Type identifier (loan, payment, filling, donate)
- `sign`: Mathematical sign (-1 for loans, +1 for payments)
- `created/updated`: Timestamps

#### `transactions`
- `id`: Unique identifier
- `amount`: Transaction amount
- `person`: Reference to person
- `type`: Reference to transaction type
- `notes`: Additional notes
- `created/updated`: Timestamps

#### `persons_overview` (View)
- Aggregated view showing:
  - Total loan amount per person
  - Current remainder (loan - payments)
  - Last transaction date
  - Only shows persons with outstanding loans

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart 3.0 or higher
- Android Studio / Xcode for mobile development
- PocketBase server for cloud sync (optional)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd moqred
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure PocketBase (Optional)**
   - Set up PocketBase server
   - Update `lib/utils/secure_config.dart` with your server details
   - Configure admin credentials

4. **Run the application**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK: 21
- Target SDK: 34
- Compile SDK: 34
- Supports Android 5.0+

#### iOS
- Minimum iOS: 14.0
- Supports iPhone and iPad
- Requires Xcode 12+

## 🔧 Configuration

### Database Configuration
The app uses SQLite with automatic schema initialization:
- Schema file: `assets/schema.sql`
- Database file: `app.db`
- Auto-seeding of transaction types on first run

### PocketBase Configuration
Update `lib/utils/secure_config.dart`:
```dart
class SecureConfig {
  static const String pocketBaseUrl = 'your-pocketbase-url';
  static const String pocketBaseAdminEmail = 'admin@example.com';
  static const String pocketBaseAdminPassword = 'your-password';
}
```

## 📱 User Interface

### Main Navigation
The app features a bottom navigation bar with three main sections:

1. **الرئيسية (Home)**: Dashboard with balance overview and person list
2. **المعاملات (Transactions)**: Transaction history and management
3. **الإعدادات (Settings)**: App configuration and transaction type management

### Key UI Components
- **PaginatedDataTable**: For displaying large datasets
- **FlutterFlowDropDown**: Custom dropdown components
- **Shimmer Loading**: Loading states for better UX
- **Responsive Design**: Adapts to different screen sizes

## 🔄 Data Flow

### Transaction Creation Flow
1. User selects transaction type
2. System validates available balance (for loans)
3. User enters amount and selects person
4. System validates person's loan status (for payments)
5. Transaction is created and balance is updated
6. UI refreshes to show new data

### Synchronization Flow
1. **Backup to Cloud**:
   - Authenticate with PocketBase
   - Clear remote data
   - Upload local data in dependency order
   
2. **Restore from Cloud**:
   - Authenticate with PocketBase
   - Clear local data
   - Download and insert remote data

## 🛠️ Development

### Code Generation
The app uses code generation for JSON serialization:
```bash
flutter packages pub run build_runner build
```

### Key Dependencies
- `provider`: State management
- `go_router`: Navigation
- `sqflite`: Local database
- `pocketbase`: Cloud backend
- `syncfusion_flutter_datagrid`: Data tables
- `shimmer`: Loading animations

### Custom Components
- **FlutterFlow Framework**: Custom UI components
- **Form Validation**: Built-in validation for all forms
- **Error Handling**: Comprehensive error management
- **Internationalization**: Arabic language support

## 📈 Performance Considerations

- **Pagination**: Large datasets are paginated for better performance
- **Lazy Loading**: Data is loaded on-demand
- **Caching**: Local SQLite provides fast data access
- **Background Sync**: Cloud operations don't block UI

## 🔒 Security

- **Local Data**: SQLite database is stored securely on device
- **Cloud Sync**: Admin authentication required for cloud operations
- **Data Validation**: All inputs are validated before processing
- **Error Handling**: Sensitive information is not exposed in error messages

The app includes widget tests for core functionality.

## 📝 License

This project includes code from FlutterFlow (BSD 3-Clause License).

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📞 Support

For support and questions, please refer to the project documentation or create an issue in the repository.

---

**Version**: 1.0.2  
**Last Updated**: 2025
