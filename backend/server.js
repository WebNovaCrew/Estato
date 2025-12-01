const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

// Check for required environment variables before importing routes
const requiredEnvVars = ['SUPABASE_URL', 'SUPABASE_ANON_KEY'];
const missingEnvVars = requiredEnvVars.filter(varName => !process.env[varName]);

if (missingEnvVars.length > 0) {
  console.error('❌ Missing required environment variables!');
  console.error(`Missing: ${missingEnvVars.join(', ')}`);
  console.error('');
  console.error('📝 To fix this:');
  console.error('   1. Go to Render Dashboard → Your Service → Environment Tab');
  console.error('   2. Add the following environment variables:');
  console.error('      - PORT=10000');
  console.error('      - NODE_ENV=production');
  console.error('      - SUPABASE_URL');
  console.error('      - SUPABASE_ANON_KEY');
  console.error('      - SUPABASE_SERVICE_ROLE_KEY');
  console.error('      - JWT_SECRET');
  console.error('      - ALLOWED_ORIGINS');
  console.error('   3. Save changes and redeploy');
  console.error('');
  console.error('See: backend/RENDER_ENV_COPY_PASTE.md for detailed instructions');
  process.exit(1);
}

// Import routes (only after env vars are verified)
let authRoutes, otpRoutes, userRoutes, propertyRoutes, favoriteRoutes;
let chatRoutes, bookingRoutes, paymentRoutes, adminRoutes, notificationRoutes, settingsRoutes;

try {
  authRoutes = require('./routes/auth');
  otpRoutes = require('./routes/otp');
  userRoutes = require('./routes/users');
  propertyRoutes = require('./routes/properties');
  favoriteRoutes = require('./routes/favorites');
  chatRoutes = require('./routes/chats');
  bookingRoutes = require('./routes/bookings');
  paymentRoutes = require('./routes/payments');
  adminRoutes = require('./routes/admin');
  notificationRoutes = require('./routes/notifications');
  settingsRoutes = require('./routes/settings');
} catch (error) {
  console.error('❌ Error loading routes:', error.message);
  console.error('');
  console.error('This is likely due to missing environment variables.');
  console.error('Please check Render Dashboard → Environment Variables.');
  process.exit(1);
}

// Initialize Express app
const app = express();
// Render automatically sets PORT, fallback to 3000 for local development
const PORT = process.env.PORT || 3000;

// Trust proxy - Required for Render and other reverse proxies
// This fixes the X-Forwarded-For header issue with express-rate-limit
app.set('trust proxy', 1);

// Middleware
app.use(helmet()); // Security headers
app.use(compression()); // Compress responses
app.use(morgan('dev')); // Logging

// CORS configuration - Allow all origins for development
const allowedOrigins = process.env.ALLOWED_ORIGINS
  ? process.env.ALLOWED_ORIGINS.split(',')
  : ['http://localhost:3000', 'http://localhost:8080', 'http://127.0.0.1:3000'];

app.use(
  cors({
    origin: function(origin, callback) {
      // Allow requests with no origin (mobile apps, curl, etc.)
      if (!origin) return callback(null, true);
      
      // In development, allow all origins
      if (process.env.NODE_ENV !== 'production') {
        return callback(null, true);
      }
      
      // In production, check against allowed origins
      if (allowedOrigins.includes(origin)) {
        return callback(null, true);
      }
      
      // Also allow any localhost origin
      if (origin.includes('localhost') || origin.includes('127.0.0.1')) {
        return callback(null, true);
      }
      
      callback(new Error('Not allowed by CORS'));
    },
    credentials: true,
  })
);

// Body parser middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100, // 100 requests per window
  message: {
    success: false,
    error: 'Too many requests from this IP, please try again later.',
  },
});

app.use('/api/', limiter);

// Health check route
app.get('/health', (req, res) => {
  const { supabaseAdmin } = require('./config/supabase');
  res.json({
    success: true,
    message: 'Estato API is running - Image Upload Fixed',
    timestamp: new Date().toISOString(),
    adminClientEnabled: supabaseAdmin !== null,
    serviceKeySet: !!process.env.SUPABASE_SERVICE_ROLE_KEY,
    version: '1.2.0',
  });
});

// Delete account webpage route (for Play Store compliance)
app.get('/delete-account', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Delete Account - Estato</title>
        <style>
            body { font-family: Arial, sans-serif; max-width: 600px; margin: 50px auto; padding: 20px; }
            h1 { color: #333; }
            .instructions { background: #f9f9f9; padding: 20px; border-radius: 8px; margin: 20px 0; }
            .contact { background: #fff3cd; padding: 15px; border-left: 4px solid #ffc107; margin: 20px 0; }
            .data-info { background: #d1ecf1; padding: 15px; border-left: 4px solid #17a2b8; margin: 20px 0; }
        </style>
    </head>
    <body>
        <h1>Delete Your Estato Account</h1>
        <p>We're sorry to hear you want to delete your account. Please follow these steps:</p>

        <div class="instructions">
            <h3>How to Delete Your Account:</h3>
            <ol>
                <li>Send an email to <strong>support@estato.com</strong></li>
                <li>Include your registered email address and phone number</li>
                <li>Subject line: "Delete My Account"</li>
                <li>Include any specific requests about data retention</li>
            </ol>
        </div>

        <div class="data-info">
            <h3>What Data Will Be Deleted:</h3>
            <ul>
                <li>Your profile information (name, email, phone)</li>
                <li>All your chat messages and conversations</li>
                <li>Your property favorites and saved searches</li>
                <li>Property view history</li>
                <li>All booking information</li>
            </ul>
            <p><strong>Retention Period:</strong> Account deletion will be processed within 30 days of your request.</p>
        </div>

        <div class="contact">
            <h3>Contact Information:</h3>
            <p><strong>Email:</strong> support@estato.com</p>
            <p><strong>Subject:</strong> Delete My Account</p>
            <p><strong>Response Time:</strong> Within 48 hours</p>
        </div>

        <p>If you have any questions, please contact us before deleting your account. You can always create a new account later if needed.</p>
    </body>
    </html>
  `);
});

// API Routes
app.use('/api/auth', authRoutes);
app.use('/api/otp', otpRoutes);
app.use('/api/users', userRoutes);
app.use('/api/properties', propertyRoutes);
app.use('/api/favorites', favoriteRoutes);
app.use('/api/chats', chatRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/settings', settingsRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Route not found',
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Error:', err);

  // Multer errors
  const multer = require('multer');
  if (err instanceof multer.MulterError) {
    if (err.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({
        success: false,
        error: 'File size too large. Maximum size is 5MB.',
      });
    }
  }

  res.status(err.status || 500).json({
    success: false,
    error: err.message || 'Internal server error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
});

// Start server with error handling
try {
  const server = app.listen(PORT, () => {
    console.log(`🚀 Estato API Server running on port ${PORT}`);
    console.log(`📝 Environment: ${process.env.NODE_ENV || 'development'}`);
    console.log(`🔗 Health check: http://localhost:${PORT}/health`);
    console.log(`✅ Server started successfully!`);
  });

  // Initialize Socket.IO
  const { initializeSocket } = require('./services/socket');
  initializeSocket(server);
  console.log(`🔌 Socket.IO initialized for real-time communication`);

} catch (error) {
  console.error('❌ Failed to start server:', error.message);
  console.error('Stack trace:', error.stack);
  process.exit(1);
}

module.exports = app;

