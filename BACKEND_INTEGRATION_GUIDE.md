# 🔗 Backend Integration Guide - Estato App

## 📋 Overview

This guide explains how to integrate the Flutter app with the Node.js backend using Supabase authentication.

---

## 🚀 Quick Start

### 1. Backend Setup (5 minutes)

```bash
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# Configure environment
cp .env.example .env
# Edit .env with your credentials

# Start server
npm run dev
```

### 2. Database Setup (10 minutes)

1. Go to Supabase Dashboard > SQL Editor
2. Run `backend/database/schema.sql`
3. Go to Storage > Create buckets:
   - `property-images` (public)
   - `avatars` (public)
4. Run storage policies from `backend/database/storage-setup.md`

### 3. Flutter App Configuration (2 minutes)

1. Update `lib/services/api_client.dart`:
   ```dart
   static const String baseUrl = 'http://localhost:3000/api';
   // For Android emulator: 'http://10.0.2.2:3000/api'
   ```

2. Update `lib/services/config_service.dart` with your API keys

---

## 🔄 Switching from Demo to Backend

### Option 1: Update Existing AuthProvider

Edit `lib/providers/auth_provider.dart` and replace demo code with API calls:

```dart
// Replace this:
final demoUser = DemoCredentials.validateLogin(email, password);

// With this:
final response = await ApiClient.login(email: email, password: password);
```

### Option 2: Use Backend AuthProvider

1. Backup current provider:
   ```bash
   mv lib/providers/auth_provider.dart lib/providers/auth_provider_demo.dart
   ```

2. Use backend provider:
   ```bash
   mv lib/providers/auth_provider_backend.dart lib/providers/auth_provider.dart
   ```

---

## 📡 API Integration

### Authentication Flow

```dart
// 1. Register
final response = await ApiClient.register(
  email: 'user@example.com',
  password: 'password123',
  name: 'User Name',
  phone: '+91 9876543210',
  userType: 'buyer',
);

// 2. Login
final response = await ApiClient.login(
  email: 'user@example.com',
  password: 'password123',
);

// 3. Get Current User
final response = await ApiClient.getCurrentUser();

// 4. Logout
await ApiClient.logout();
```

### Property Operations

```dart
// Get Properties
final response = await ApiClient.getProperties(
  propertyType: 'Apartment',
  transactionType: 'Buy',
  minPrice: 5000000,
  maxPrice: 10000000,
);

// Create Property
final response = await ApiClient.createProperty({
  'title': 'Property Title',
  'description': 'Description',
  'price': 8500000,
  // ... other fields
});

// Update Property
final response = await ApiClient.updateProperty(propertyId, {
  'title': 'Updated Title',
  'price': 9000000,
});

// Delete Property
final response = await ApiClient.deleteProperty(propertyId);
```

### Favorites

```dart
// Get Favorites
final response = await ApiClient.getFavorites();

// Add Favorite
final response = await ApiClient.addFavorite(propertyId);

// Remove Favorite
final response = await ApiClient.removeFavorite(propertyId);
```

### Chat

```dart
// Get Chats
final response = await ApiClient.getChats();

// Create Chat
final response = await ApiClient.createChat(
  participant2Id: 'user-id',
  propertyId: 'property-id',
);

// Get Messages
final response = await ApiClient.getChatMessages(chatId);

// Send Message
final response = await ApiClient.sendMessage(chatId, 'Message content');
```

### Bookings

```dart
// Get Bookings
final response = await ApiClient.getBookings(status: 'pending');

// Create Booking
final response = await ApiClient.createBooking(
  propertyId: 'property-id',
  scheduledDate: '2025-11-10',
  scheduledTime: '10:00',
  notes: 'Optional notes',
);

// Update Booking
final response = await ApiClient.updateBooking(bookingId, 'confirmed');
```

### Payments

```dart
// Create Payment
final response = await ApiClient.createPayment(
  amount: 999,
  planName: 'Pro Plan',
);

// Verify Payment (after Razorpay callback)
final response = await ApiClient.verifyPayment(
  orderId: 'order_id',
  paymentId: 'payment_id',
  signature: 'signature',
);

// Get Payment History
final response = await ApiClient.getPaymentHistory();
```

---

## 🔐 Authentication Headers

All authenticated requests automatically include:

```
Authorization: Bearer <access_token>
```

The access token is stored in SharedPreferences after login and automatically added to all requests.

---

## 🌐 Network Configuration

### Development
- **Local:** `http://localhost:3000/api`
- **Android Emulator:** `http://10.0.2.2:3000/api`
- **iOS Simulator:** `http://localhost:3000/api`

### Production
- **Backend URL:** `https://api.estato.com/api`

---

## 📝 Error Handling

All API methods return:

```dart
{
  'success': true/false,
  'data': {...}, // if success
  'error': 'Error message', // if failed
}
```

Example error handling:

```dart
final response = await ApiClient.login(email: email, password: password);

if (response['success'] == true) {
  // Handle success
  final user = response['data']['user'];
} else {
  // Handle error
  final error = response['error'];
  // Show error to user
}
```

---

## 🧪 Testing

### Test Backend
```bash
# Health check
curl http://localhost:3000/health

# Test registration
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"test123","name":"Test","phone":"+911234567890","userType":"buyer"}'

# Test login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"test123"}'
```

### Test Flutter App
1. Start backend server
2. Run Flutter app
3. Test registration/login flow
4. Test property operations
5. Test other features

---

## 🔧 Troubleshooting

### Issue: Cannot connect to backend
**Solutions:**
- Check if backend is running: `curl http://localhost:3000/health`
- Verify API URL in `api_client.dart`
- For Android emulator, use `10.0.2.2:3000` instead of `localhost`
- Check network permissions in AndroidManifest.xml

### Issue: 401 Unauthorized
**Solutions:**
- Check if user is logged in
- Verify access token is stored
- Try logging in again
- Check token expiration

### Issue: CORS errors
**Solutions:**
- Add Flutter app URL to `ALLOWED_ORIGINS` in backend `.env`
- Restart backend server
- Check CORS configuration in `server.js`

### Issue: Database errors
**Solutions:**
- Verify Supabase credentials in `.env`
- Check database schema is created
- Verify RLS policies are set up
- Check Supabase dashboard for errors

---

## 📊 API Response Examples

### Success Response
```json
{
  "success": true,
  "data": {
    "id": "123",
    "name": "User Name",
    "email": "user@example.com"
  },
  "message": "Operation successful"
}
```

### Error Response
```json
{
  "success": false,
  "error": "Error message here"
}
```

### Validation Error Response
```json
{
  "success": false,
  "error": "Validation failed",
  "errors": [
    {
      "field": "email",
      "message": "Invalid email format"
    }
  ]
}
```

---

## 🎯 Next Steps

1. **Complete Backend Setup**
   - [ ] Set up Supabase project
   - [ ] Run database schema
   - [ ] Configure storage buckets
   - [ ] Set environment variables

2. **Update Flutter App**
   - [ ] Update API base URL
   - [ ] Replace demo auth with backend auth
   - [ ] Test all API endpoints
   - [ ] Handle errors properly

3. **Deploy Backend**
   - [ ] Deploy to Heroku/Railway/DigitalOcean
   - [ ] Update Flutter app with production URL
   - [ ] Set up monitoring
   - [ ] Configure backups

---

## 📞 Support

For backend issues:
- Check backend logs
- Verify environment variables
- Test API with Postman
- Check Supabase dashboard

For Flutter integration issues:
- Verify API URL
- Check network permissions
- Test with curl/Postman first
- Check error responses

---

**Last Updated:** November 4, 2025

