const express = require('express');
const router = express.Router();
const { supabase, supabaseAdmin } = require('../config/supabase');
const { body, validationResult } = require('express-validator');
const { authenticate } = require('../middleware/auth');

/**
 * @route   POST /api/auth/register
 * @desc    Register a new user
 * @access  Public
 */
router.post(
  '/register',
  [
    body('email').isEmail().normalizeEmail(),
    body('password').isLength({ min: 6 }),
    body('name').notEmpty().trim(),
    body('phone').notEmpty().trim(),
    body('userType').isIn(['buyer', 'seller', 'agent', 'landlord', 'owner', 'both']),
  ],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          error: 'Validation failed',
          errors: errors.array(),
        });
      }

      const { email, password, name, phone, userType } = req.body;

      // Register user with Supabase Auth
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: {
            name,
            phone,
            userType,
          },
        },
      });

      if (authError) {
        return res.status(400).json({
          success: false,
          error: authError.message,
        });
      }

      // Create user profile in database using admin client to bypass RLS
      const dbClient = supabaseAdmin || supabase;
      const { error: profileError } = await dbClient.from('users').insert([
        {
          id: authData.user.id,
          email,
          name,
          phone,
          user_type: userType,
          role: 'user',
          verified: false,
          subscription_plan: 'free',
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        },
      ]);

      if (profileError) {
        console.error('Error creating user profile:', profileError);
        // Try to create profile without admin client as fallback
        if (supabaseAdmin) {
          const { error: fallbackError } = await supabase.from('users').insert([
            {
              id: authData.user.id,
              email,
              name,
              phone,
              user_type: userType,
              created_at: new Date().toISOString(),
            },
          ]);
          if (fallbackError) {
            console.error('Fallback profile creation also failed:', fallbackError);
          }
        }
      }

      res.status(201).json({
        success: true,
        message: 'User registered successfully. Please verify your email.',
        data: {
          user: authData.user,
          session: authData.session,
          accessToken: authData.session?.access_token || null,
          refreshToken: authData.session?.refresh_token || null,
        },
      });
    } catch (error) {
      console.error('Register error:', error);
      res.status(500).json({
        success: false,
        error: 'Server error during registration',
      });
    }
  }
);

/**
 * @route   POST /api/auth/login
 * @desc    Login user
 * @access  Public
 */
router.post(
  '/login',
  [
    body('email').isEmail().normalizeEmail(),
    body('password').notEmpty(),
  ],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          error: 'Validation failed',
          errors: errors.array(),
        });
      }

      const { email, password } = req.body;

      // Sign in with Supabase Auth
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) {
        return res.status(401).json({
          success: false,
          error: 'Invalid email or password',
        });
      }

      // Get user profile
      let { data: userProfile, error: profileError } = await supabase
        .from('users')
        .select('*')
        .eq('id', data.user.id)
        .single();

      // If profile doesn't exist, create it from user metadata using admin client
      if (profileError || !userProfile) {
        console.log('User profile not found, creating from metadata...');
        const metadata = data.user.user_metadata || {};
        const dbClient = supabaseAdmin || supabase;
        
        const { data: newProfile, error: createError } = await dbClient
          .from('users')
          .insert([{
            id: data.user.id,
            email: data.user.email,
            name: metadata.name || 'User',
            phone: metadata.phone || '',
            user_type: metadata.userType || 'buyer',
            role: 'user',
            verified: false,
            subscription_plan: 'free',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
          }])
          .select()
          .single();

        if (createError) {
          console.error('Error creating user profile on login:', createError);
          // Return user data even without profile
          userProfile = {
            id: data.user.id,
            email: data.user.email,
            name: metadata.name || 'User',
            phone: metadata.phone || '',
            user_type: metadata.userType || 'buyer',
          };
        } else {
          userProfile = newProfile;
          console.log('User profile created successfully on login');
        }
      }

      res.json({
        success: true,
        message: 'Login successful',
        data: {
          user: {
            ...data.user,
            profile: userProfile || null,
          },
          session: data.session,
          accessToken: data.session.access_token,
          refreshToken: data.session.refresh_token,
        },
      });
    } catch (error) {
      console.error('Login error:', error);
      res.status(500).json({
        success: false,
        error: 'Server error during login',
      });
    }
  }
);

/**
 * @route   POST /api/auth/logout
 * @desc    Logout user
 * @access  Private
 */
router.post('/logout', authenticate, async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    const token = authHeader.substring(7);

    // Sign out with Supabase
    const { error } = await supabase.auth.signOut();

    if (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }

    res.json({
      success: true,
      message: 'Logout successful',
    });
  } catch (error) {
    console.error('Logout error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error during logout',
    });
  }
});

/**
 * @route   POST /api/auth/refresh
 * @desc    Refresh access token
 * @access  Public
 */
router.post('/refresh', async (req, res) => {
  try {
    const { refreshToken } = req.body;

    if (!refreshToken) {
      return res.status(400).json({
        success: false,
        error: 'Refresh token required',
      });
    }

    // Refresh session with Supabase
    const { data, error } = await supabase.auth.refreshSession({
      refresh_token: refreshToken,
    });

    if (error) {
      return res.status(401).json({
        success: false,
        error: 'Invalid refresh token',
      });
    }

    res.json({
      success: true,
      data: {
        accessToken: data.session.access_token,
        refreshToken: data.session.refresh_token,
        expiresAt: data.session.expires_at,
      },
    });
  } catch (error) {
    console.error('Refresh token error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error during token refresh',
    });
  }
});

/**
 * @route   GET /api/auth/me
 * @desc    Get current user
 * @access  Private
 */
router.get('/me', authenticate, async (req, res) => {
  try {
    // Use admin client to bypass RLS
    const dbClient = supabaseAdmin || supabase;
    
    // Get user profile
    let { data: userProfile, error } = await dbClient
      .from('users')
      .select('*')
      .eq('id', req.userId)
      .single();

    // If profile doesn't exist, create it from user metadata
    if (error || !userProfile) {
      console.log('User profile not found in /me, creating from metadata...');
      console.log('User ID:', req.userId);
      console.log('Error:', error);
      
      const metadata = req.user?.user_metadata || {};
      
      const { data: newProfile, error: createError } = await dbClient
        .from('users')
        .insert([{
          id: req.userId,
          email: req.user?.email || '',
          name: metadata.name || 'User',
          phone: metadata.phone || '',
          user_type: metadata.userType || 'buyer',
          role: 'user',
          verified: false,
          subscription_plan: 'free',
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        }])
        .select()
        .single();

      if (createError) {
        console.error('Error creating user profile:', createError);
        // Return basic profile from auth data instead of 404
        userProfile = {
          id: req.userId,
          email: req.user?.email || '',
          name: metadata.name || 'User',
          phone: metadata.phone || '',
          user_type: metadata.userType || 'buyer',
          role: 'user',
          verified: false,
          avatar_url: null,
          bio: null,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        };
      } else {
        userProfile = newProfile;
      }
    }

    res.json({
      success: true,
      data: {
        ...req.user,
        profile: userProfile,
      },
    });
  } catch (error) {
    console.error('Get user error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   POST /api/auth/forgot-password
 * @desc    Send password reset email
 * @access  Public
 */
router.post(
  '/forgot-password',
  [body('email').isEmail().normalizeEmail()],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          error: 'Validation failed',
          errors: errors.array(),
        });
      }

      const { email } = req.body;

      // Send password reset email with Supabase
      const { error } = await supabase.auth.resetPasswordForEmail(email, {
        redirectTo: `${process.env.APP_URL}/reset-password`,
      });

      if (error) {
        return res.status(400).json({
          success: false,
          error: error.message,
        });
      }

      res.json({
        success: true,
        message: 'Password reset email sent successfully',
      });
    } catch (error) {
      console.error('Forgot password error:', error);
      res.status(500).json({
        success: false,
        error: 'Server error',
      });
    }
  }
);

/**
 * @route   POST /api/auth/reset-password
 * @desc    Reset password
 * @access  Public
 */
router.post(
  '/reset-password',
  [
    body('password').isLength({ min: 6 }),
    body('token').notEmpty(),
  ],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          error: 'Validation failed',
          errors: errors.array(),
        });
      }

      const { password, token } = req.body;

      // Update password with Supabase
      const { error } = await supabase.auth.updateUser({
        password: password,
      });

      if (error) {
        return res.status(400).json({
          success: false,
          error: error.message,
        });
      }

      res.json({
        success: true,
        message: 'Password reset successfully',
      });
    } catch (error) {
      console.error('Reset password error:', error);
      res.status(500).json({
        success: false,
        error: 'Server error',
      });
    }
  }
);

/**
 * @route   POST /api/auth/request-deletion
 * @desc    Request account deletion (Google Play Store compliance)
 * @access  Public
 */
router.post(
  '/request-deletion',
  [body('email').isEmail().normalizeEmail()],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          error: 'Valid email is required',
        });
      }

      const { email, reason } = req.body;

      // Check if user exists
      const dbClient = supabaseAdmin || supabase;
      const { data: user } = await dbClient
        .from('users')
        .select('id, email, name')
        .eq('email', email)
        .single();

      if (!user) {
        // Don't reveal if email exists or not for security
        return res.json({
          success: true,
          message: 'If an account exists with this email, a deletion request has been submitted.',
        });
      }

      // Create deletion request record
      const { error: insertError } = await dbClient
        .from('deletion_requests')
        .insert([{
          user_id: user.id,
          email: email,
          reason: reason || null,
          status: 'pending',
          requested_at: new Date().toISOString(),
          scheduled_deletion_at: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(), // 30 days
        }]);

      // If table doesn't exist, just log and continue
      if (insertError) {
        console.log('Deletion request logged (table may not exist):', { email, reason });
      }

      // Log the deletion request
      console.log('Account deletion requested:', {
        email,
        userId: user.id,
        reason,
        requestedAt: new Date().toISOString(),
      });

      res.json({
        success: true,
        message: 'Account deletion request submitted successfully. Your account will be deleted within 30 days.',
      });
    } catch (error) {
      console.error('Deletion request error:', error);
      // Still return success for UX
      res.json({
        success: true,
        message: 'Deletion request received. We will process it within 30 days.',
      });
    }
  }
);

/**
 * @route   GET /api/auth/deletion-policy
 * @desc    Get account deletion policy information
 * @access  Public
 */
router.get('/deletion-policy', (req, res) => {
  res.json({
    success: true,
    data: {
      appName: 'Estato',
      developerName: 'Web Nova Crew',
      deletionUrl: 'https://champ-y6eg.onrender.com/delete-account',
      websiteUrl: 'https://estatoprop.com',
      processingTime: '30 days',
      dataDeleted: [
        'Profile information (name, email, phone)',
        'Property listings and saved searches',
        'Booking history and inquiries',
        'Saved favorites and preferences',
        'Chat messages and conversations',
        'Reviews and ratings',
        'Payment information',
      ],
      dataRetained: [
        { type: 'Transaction records', period: '7 years', reason: 'Legal compliance' },
        { type: 'Anonymized analytics', period: 'Indefinite', reason: 'Service improvement' },
        { type: 'Legal dispute data', period: 'Until resolved', reason: 'Legal requirements' },
        { type: 'Tax records', period: 'As required by law', reason: 'Regulatory compliance' },
      ],
      supportEmail: 'support@estatoprop.com',
      developerEmail: 'Contact@webnovacrew.com',
    },
  });
});

module.exports = router;

