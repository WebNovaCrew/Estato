const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const { authenticate } = require('../middleware/auth');
const { supabase, supabaseAdmin } = require('../config/supabase');
const multer = require('multer');
const { v4: uuidv4 } = require('uuid');

// Configure multer for file uploads
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB
  },
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Only image files are allowed'), false);
    }
  },
});

/**
 * @route   GET /api/users/profile
 * @desc    Get user profile
 * @access  Private
 */
router.get('/profile', authenticate, async (req, res) => {
  try {
    // Use admin client to bypass RLS
    const dbClient = supabaseAdmin || supabase;
    
    let { data: userProfile, error } = await dbClient
      .from('users')
      .select('*')
      .eq('id', req.userId);

    // Handle case where user doesn't exist in users table
    if (error || !userProfile || userProfile.length === 0) {
      console.log('User profile not found, creating from auth metadata...');
      
      // Create user profile from auth metadata
      const metadata = req.user?.user_metadata || {};
      const newProfile = {
        id: req.userId,
        email: req.user?.email || '',
        name: metadata.name || 'User',
        phone: metadata.phone || '',
        user_type: metadata.userType || 'buyer',
        avatar_url: null,
        bio: null,
        role: 'user',
        verified: false,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      };

      // Try to create the profile in database
      const { data: createdProfile, error: createError } = await dbClient
        .from('users')
        .insert([newProfile])
        .select()
        .single();

      if (createError) {
        console.error('Error creating user profile:', createError);
        // Return metadata profile even if DB insert fails
        userProfile = newProfile;
      } else {
        userProfile = createdProfile;
        console.log('User profile created successfully');
      }
    } else {
      userProfile = userProfile[0]; // Get first result from array
    }

    res.json({
      success: true,
      data: userProfile,
    });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({
      success: false,
      error: 'Server error',
    });
  }
});

/**
 * @route   PUT /api/users/profile
 * @desc    Update user profile
 * @access  Private
 */
router.put(
  '/profile',
  authenticate,
  [
    body('name').optional().notEmpty().trim(),
    body('phone').optional().notEmpty().trim(),
    body('email').optional().isEmail().normalizeEmail(),
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

      const updates = {};
      if (req.body.name) updates.name = req.body.name;
      if (req.body.phone) updates.phone = req.body.phone;
      if (req.body.bio) updates.bio = req.body.bio;
      updates.updated_at = new Date().toISOString();

      // Use admin client to bypass RLS
      const dbClient = supabaseAdmin || supabase;

      // First check if user exists
      const { data: existingUser, error: checkError } = await dbClient
        .from('users')
        .select('id')
        .eq('id', req.userId)
        .single();

      let data;
      let error;

      if (!existingUser) {
        // Create user profile if it doesn't exist
        const metadata = req.user?.user_metadata || {};
        const insertResult = await dbClient
          .from('users')
          .insert([{
            id: req.userId,
            email: req.user?.email || '',
            name: req.body.name || metadata.name || 'User',
            phone: req.body.phone || metadata.phone || '',
            bio: req.body.bio || null,
            user_type: metadata.userType || 'buyer',
            role: 'user',
            verified: false,
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
          }])
          .select()
          .single();
        
        data = insertResult.data;
        error = insertResult.error;
      } else {
        // Update existing profile
        const updateResult = await dbClient
          .from('users')
          .update(updates)
          .eq('id', req.userId)
          .select()
          .single();
        
        data = updateResult.data;
        error = updateResult.error;
      }

      if (error) {
        console.error('Profile update error:', error);
        return res.status(400).json({
          success: false,
          error: error.message,
        });
      }

      res.json({
        success: true,
        message: 'Profile updated successfully',
        data,
      });
    } catch (error) {
      console.error('Update profile error:', error);
      res.status(500).json({
        success: false,
        error: 'Server error',
      });
    }
  }
);

/**
 * @route   POST /api/users/avatar
 * @desc    Upload user avatar
 * @access  Private
 */
router.post('/avatar', authenticate, upload.single('avatar'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'No file uploaded',
      });
    }

    // Use admin client for storage and database
    const dbClient = supabaseAdmin || supabase;

    // Upload to Supabase Storage
    const fileExt = req.file.originalname.split('.').pop();
    const fileName = `${req.userId}/${uuidv4()}.${fileExt}`;

    const { data: uploadData, error: uploadError } = await dbClient.storage
      .from('avatars')
      .upload(fileName, req.file.buffer, {
        contentType: req.file.mimetype,
        upsert: true, // Allow overwriting
      });

    if (uploadError) {
      console.error('Avatar upload error:', uploadError);
      return res.status(400).json({
        success: false,
        error: uploadError.message,
      });
    }

    // Get public URL
    const { data: urlData } = dbClient.storage
      .from('avatars')
      .getPublicUrl(fileName);

    // Update user profile with avatar URL
    const { data, error } = await dbClient
      .from('users')
      .update({ avatar_url: urlData.publicUrl, updated_at: new Date().toISOString() })
      .eq('id', req.userId)
      .select()
      .single();

    if (error) {
      console.error('Avatar profile update error:', error);
      // Still return success with avatar URL even if profile update fails
      return res.json({
        success: true,
        message: 'Avatar uploaded successfully',
        data: {
          avatarUrl: urlData.publicUrl,
        },
      });
    }

    res.json({
      success: true,
      message: 'Avatar uploaded successfully',
      data: {
        avatarUrl: urlData.publicUrl,
        user: data,
      },
    });
  } catch (error) {
    console.error('Upload avatar error:', error);
    res.status(500).json({
      success: false,
      error: error.message || 'Server error',
    });
  }
});

/**
 * @route   POST /api/users/change-password
 * @desc    Change user password
 * @access  Private
 */
router.post(
  '/change-password',
  authenticate,
  [
    body('currentPassword').notEmpty(),
    body('newPassword').isLength({ min: 6 }),
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

      const { currentPassword, newPassword } = req.body;

      // Update password with Supabase
      const { error } = await supabase.auth.updateUser({
        password: newPassword,
      });

      if (error) {
        return res.status(400).json({
          success: false,
          error: error.message,
        });
      }

      res.json({
        success: true,
        message: 'Password changed successfully',
      });
    } catch (error) {
      console.error('Change password error:', error);
      res.status(500).json({
        success: false,
        error: 'Server error',
      });
    }
  }
);

module.exports = router;

