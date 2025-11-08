# Estato - Real Estate Property App

**Your Home, Our Priority**

Estato is a comprehensive real estate property buying and selling listing directory application designed specifically for Lucknow, India. Built with Flutter, it provides a modern and intuitive platform for property seekers and sellers.

## Features

### 🏠 Core Features
- **Property Listings**: Browse apartments, houses, commercial spaces, and plots
- **Advanced Search**: Search properties by location, type, price, and amenities
- **Filters**: Filter by transaction type (Buy/Rent/Lease), property type, area, and price range
- **Featured Properties**: Highlighted premium listings
- **Property Details**: Comprehensive information with image galleries
- **Favorites**: Save properties for later viewing
- **User Profiles**: Manage your account and listings

### 🎯 For Buyers/Renters
- Search and filter properties across Lucknow
- View detailed property information with images
- Save favorite properties
- Contact property owners directly
- Schedule property visits

### 🏢 For Sellers/Landlords
- List properties with detailed information
- Add multiple images
- Specify amenities and property features
- Manage contact information
- Track property listings

### 📍 Lucknow Specific Areas
- Gomti Nagar
- Hazratganj
- Aliganj
- Indira Nagar
- Jankipuram
- Aminabad
- Alambagh
- Rajajipuram
- Mahanagar
- Chowk

## Technology Stack

### Frontend
- **Framework**: Flutter 3.9+
- **State Management**: Provider
- **UI Components**: Material Design 3
- **Fonts**: Google Fonts (Poppins)
- **Image Handling**: cached_network_image, image_picker
- **Storage**: shared_preferences
- **Networking**: http
- **UI Widgets**: carousel_slider, flutter_rating_bar

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth (JWT)
- **Storage**: Supabase Storage
- **Payment**: Razorpay (Integration ready)
- **SMS/OTP**: Twilio (Integration ready)

## Project Structure

```
estato_prop/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── property.dart
│   │   └── user.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   └── property_provider.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── property/
│   │   │   ├── property_detail_screen.dart
│   │   │   └── add_property_screen.dart
│   │   └── profile/
│   │       └── profile_screen.dart
│   ├── widgets/
│   │   └── property_card.dart
│   └── utils/
├── assets/
│   ├── images/
│   └── icons/
└── pubspec.yaml
```

## Getting Started

### Prerequisites
- Flutter SDK (3.9 or higher)
- Dart SDK
- Android Studio / VS Code
- Android Emulator / iOS Simulator or Physical Device

### Installation

1. **Clone or navigate to the project directory**
   ```bash
   cd estato_prop
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## How to Use

### 1. Splash Screen
- The app starts with the Estato branded splash screen
- Automatically navigates to login after 3 seconds

### 2. Demo Login System 🎯
The app uses a **demo authentication system** - no backend required!

**Option 1: Use Pre-configured Demo Accounts**
- **Buyer:** `buyer@estato.com` / `buyer123`
- **Seller:** `seller@estato.com` / `seller123`
- **Agent:** `agent@estato.com` / `agent123`
- **Demo:** `demo@estato.com` / `demo123`

**Option 2: Use ANY Credentials**
- Enter any email and password (6+ characters)
- The app will create a demo account automatically

**Option 3: Register**
- Click "Register" and fill in the form
- All registrations create demo accounts locally

> 📖 **See [DEMO_LOGIN_GUIDE.md](DEMO_LOGIN_GUIDE.md) for complete details**

### 3. Home Screen
- View featured properties in a carousel
- Browse all available properties
- Filter by transaction type (All/Buy/Rent/Lease)
- Use the search bar to find specific properties
- Access advanced filters for property type and area

### 4. Property Details
- View high-resolution property images
- See complete property information
- Check amenities and features
- Contact the owner directly
- Schedule property visits
- Add to favorites

### 5. Add Property
- Click the FAB (Floating Action Button) on the home screen
- Fill in property details:
  - Title and description
  - Property type and transaction type
  - Location (Lucknow areas)
  - Price and size
  - Bedrooms and bathrooms
  - Year built and furnished status
  - Contact phone
  - Amenities
  - Property images
- Submit to list the property

### 6. Profile
- View account information
- See statistics (listings and favorites)
- Access saved properties
- Manage account settings
- Logout

## Color Scheme

- **Primary**: `#1B4965` (Deep Blue)
- **Secondary**: `#D4A574` (Gold/Tan)
- **Accent**: `#62B6CB` (Light Blue)
- **Background**: White
- **Text**: Dark Gray

## Sample Data

The app includes sample properties for demonstration:
- 3 BHK Luxury Apartment in Gomti Nagar
- 2 BHK Flat for Rent in Hazratganj
- Independent House in Aliganj
- Commercial Space in Aminabad
- Plot for Sale in Indira Nagar
- Luxury Villa in Jankipuram

## Backend Integration

The app includes a complete Node.js backend with Supabase integration:

### Features
- ✅ Supabase Authentication (JWT-based)
- ✅ User Registration & Login
- ✅ Property CRUD Operations
- ✅ Favorites Management
- ✅ Real-time Chat
- ✅ Booking System
- ✅ Payment Integration (Razorpay)
- ✅ OTP Verification (Twilio)
- ✅ Admin Dashboard
- ✅ File Upload (Supabase Storage)

### Setup Backend
See [backend/README.md](backend/README.md) for detailed setup instructions.

### Quick Start
1. **Set up Supabase**
   - Create account at [supabase.com](https://supabase.com)
   - Run database schema from `backend/database/schema.sql`
   - Create storage buckets

2. **Configure Backend**
   - Copy `backend/ENV_TEMPLATE.txt` to `backend/.env`
   - Add your Supabase keys
   - Run `npm install` in `backend` folder
   - Start server: `npm run dev`

3. **Configure Flutter App**
   - Update API URL in `lib/services/config_service.dart`
   - Switch to backend auth provider (optional)

For detailed integration guide, see:
- [QUICK_SUPABASE_SETUP.md](QUICK_SUPABASE_SETUP.md)
- [SUPABASE_INTEGRATION_STEP_BY_STEP.md](SUPABASE_INTEGRATION_STEP_BY_STEP.md)

## Future Enhancements

- Real-time chat between buyers and sellers
- Google Maps integration
- Property comparison feature
- Mortgage calculator
- Push notifications
- Advanced analytics for sellers
- Property recommendations using ML
- Virtual property tours
- Document upload and verification

## Notes

- This is a demo application with local data
- For production use, integrate with a backend API
- Image picker functionality is demonstrated but uses placeholder URLs
- Phone call functionality requires appropriate permissions on device

## Development

### Building for Android
```bash
flutter build apk --release
```

### Building for iOS
```bash
flutter build ios --release
```

## License

This project is created for demonstration purposes.

## Contact

For more information about Estato, please contact the development team.

---

**Estato** - Finding Your Perfect Space in Lucknow 🏠
